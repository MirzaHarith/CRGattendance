package controller;

import dao.AttendanceDAO;
import dao.EmployeeDAO;
import dao.PayrollDAO;
import model.Attendance;
import model.Employee;
import model.Payroll;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class PayrollController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String employeeID = (String) request.getSession().getAttribute("employeeID");

        PayrollDAO payrollDAO = new PayrollDAO();
        AttendanceDAO attendanceDAO = new AttendanceDAO();

        try {
            if ("generatePayroll".equalsIgnoreCase(action)) {
                String month = request.getParameter("month");

                List<Attendance> attendances = attendanceDAO.getAttendancesByEmployeeIdAndMonth(employeeID, month);
                int totalHours = 0;
                List<Attendance> calculatedAttendances = new ArrayList<>();
                for (Attendance attendance : attendances) {
                    if (attendance.getClockIn() != null && attendance.getClockOut() != null) {
                        LocalTime clockIn = LocalTime.parse(attendance.getClockIn());
                        LocalTime clockOut = LocalTime.parse(attendance.getClockOut());
                        long hoursWorked = Duration.between(clockIn, clockOut).toHours();
                        totalHours += hoursWorked;
                        attendance.setHoursWorked(hoursWorked);
                    }
                    calculatedAttendances.add(attendance);
                }

                EmployeeDAO employeeDAO = new EmployeeDAO();
                Employee employee = employeeDAO.getEmployeeByID(employeeID);
                double payRate = employee.getPayRate();
                double totalSalary = payRate * totalHours;

                Payroll payroll = new Payroll();
                payroll.setEmployeeID(employeeID);
                payroll.setMonth(month);
                payroll.setTotalHours(totalHours);
                payroll.setPayDay(payRate);
                payroll.setTotalSalary(totalSalary);

                Payroll existingPayroll = payrollDAO.getPayrollByEmployeeAndMonth(employeeID, month);
                if (existingPayroll != null) {
                    payroll.setPayrollID(existingPayroll.getPayrollID());
                    payrollDAO.updatePayroll(payroll);
                } else {
                    payroll.setPayrollID(payrollDAO.generatePayrollID());
                    payrollDAO.addPayroll(payroll);
                }

                request.setAttribute("payroll", payroll);
                request.setAttribute("attendanceList", calculatedAttendances);
                request.setAttribute("selectedMonth", month);
                request.getRequestDispatcher("employee-payroll.jsp").forward(request, response);
                return;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error.");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
