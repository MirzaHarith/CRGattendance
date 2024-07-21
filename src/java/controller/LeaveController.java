package controller;

import dao.LeaveDAO;
import dao.EmployeeDAO;
import model.Leave;
import model.Employee;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig(maxFileSize = 16177215) // 16MB
public class LeaveController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LeaveDAO leaveDAO;
    private EmployeeDAO employeeDAO;

    public void init() {
        leaveDAO = new LeaveDAO();
        employeeDAO = new EmployeeDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "apply":
                    applyLeave(request, response);
                    break;
                case "delete":
                    deleteLeave(request, response);
                    break;
                case "approve":
                    updateLeaveStatus(request, response, "approved");
                    break;
                case "reject":
                    updateLeaveStatus(request, response, "rejected");
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
                    break;
            }
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException(e);
        }
    }

    private void applyLeave(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ClassNotFoundException, ServletException {
        String leaveID = leaveDAO.generateLeaveID();
        String applyLeaveDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        String leaveType = request.getParameter("leaveType");
        if ("other".equals(leaveType)) {
        leaveType = request.getParameter("otherLeaveType");
        }
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String reason = request.getParameter("reason");
        String employeeID = request.getParameter("employeeID");
        String status = "pending";

        Employee employee = employeeDAO.getEmployeeByID(employeeID);
        int leaveDays = calculateLeaveDays(startDate, endDate);

        if (employee.getLeaveBalance() <= 0 || employee.getLeaveBalance() < leaveDays) {
            response.setContentType("text/html");
            response.getWriter().write("<script>alert('Invalid leave request: Leave balance is insufficient.');window.history.back();</script>");
            return;
        }

        Part filePart = request.getPart("evidence");
        byte[] evidence = null;
        if (filePart != null && filePart.getSize() > 0) {
            try (InputStream inputStream = filePart.getInputStream()) {
                evidence = new byte[inputStream.available()];
                inputStream.read(evidence);
            }
        }

        Leave leave = new Leave();
        leave.setLeaveID(leaveID);
        leave.setApplyLeaveDate(applyLeaveDate);
        leave.setLeaveType(leaveType);
        leave.setStartDate(startDate);
        leave.setEndDate(endDate);
        leave.setEvidence(evidence);
        leave.setReason(reason);
        leave.setEmployeeID(employeeID);
        leave.setStatus(status);

        leaveDAO.addLeave(leave);
        response.sendRedirect("employee-view-leave.jsp");
    }

    private void deleteLeave(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ClassNotFoundException {
        String leaveID = request.getParameter("leaveID");
        leaveDAO.deleteLeave(leaveID);
        response.sendRedirect("employee-view-leave.jsp");
    }

    private void updateLeaveStatus(HttpServletRequest request, HttpServletResponse response, String status) throws SQLException, IOException, ClassNotFoundException {
        String leaveID = request.getParameter("leaveID");
        Leave leave = leaveDAO.getLeaveByID(leaveID);

        if ("approved".equals(status)) {
            int leaveDays = calculateLeaveDays(leave.getStartDate(), leave.getEndDate());
            Employee employee = employeeDAO.getEmployeeByID(leave.getEmployeeID());

            if (employee.getLeaveBalance() < leaveDays) {
                response.setContentType("text/html");
                response.getWriter().write("<script>alert('Invalid approval: Leave balance is insufficient.');window.history.back();</script>");
                return;
            }

            if (leave.getEvidence() == null) {
                int newLeaveBalance = employee.getLeaveBalance() - leaveDays;
                employeeDAO.updateLeaveBalance(employee.getEmployeeID(), newLeaveBalance);
            }
        }

        leaveDAO.updateLeaveStatus(leaveID, status);
        response.sendRedirect("manager-manage-leave.jsp");
    }

    private int calculateLeaveDays(String startDate, String endDate) {
        LocalDate start = LocalDate.parse(startDate);
        LocalDate end = LocalDate.parse(endDate);
        return (int) ChronoUnit.DAYS.between(start, end) + 1;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
