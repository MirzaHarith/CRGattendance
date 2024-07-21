package controller;

import dao.EmployeeDAO;
import model.Employee;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.io.InputStream;
import java.util.List;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

@MultipartConfig(maxFileSize = 16177215) // 16MB
public class EmployeeController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        EmployeeDAO employeeDAO = new EmployeeDAO();
        String currentUserID = (String) request.getSession().getAttribute("employeeID");
        String currentUserPosition = (String) request.getSession().getAttribute("employeePosition");

        // Debugging information
        System.out.println("Action: " + action);
        System.out.println("Current User Position: " + currentUserPosition);
        System.out.println("Current User ID: " + currentUserID);

        try {
            if ("add".equalsIgnoreCase(action) && "manager".equalsIgnoreCase(currentUserPosition)) {
                addEmployee(request, response, employeeDAO);
            } else if ("update".equalsIgnoreCase(action)) {
                updateEmployee(request, response, employeeDAO, currentUserID, currentUserPosition);
            } else if ("delete".equalsIgnoreCase(action) && "manager".equalsIgnoreCase(currentUserPosition)) {
                deleteEmployee(request, response, employeeDAO);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to perform this action.");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filterPosition = request.getParameter("filterPosition");
        EmployeeDAO employeeDAO = new EmployeeDAO();

        try {
            List<Employee> employees;
            if (filterPosition != null && !filterPosition.isEmpty()) {
                employees = employeeDAO.getEmployeesByPosition(filterPosition);
            } else {
                employees = employeeDAO.getAllEmployees();
            }

            List<String> positions = employeeDAO.getDistinctPositions();
            request.setAttribute("employees", employees);
            request.setAttribute("positions", positions);

            request.getRequestDispatcher("manager-manage-employee.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
        }
    }

    private void addEmployee(HttpServletRequest request, HttpServletResponse response, EmployeeDAO employeeDAO) throws SQLException, IOException, ServletException, ClassNotFoundException {
        Employee employee = new Employee();
        employee.setEmployeeID(request.getParameter("employeeID"));
        employee.setEmployeeName(request.getParameter("employeeName"));
        employee.setEmployeePassword(request.getParameter("employeePassword"));
        employee.setEmployeePosition(request.getParameter("employeePosition"));
        employee.setEmployeePhoneNum(Integer.parseInt(request.getParameter("employeePhoneNum")));

        // Handle Bank Account
        String bankAccount = request.getParameter("employeeBankAccount");
        if ("Other".equals(bankAccount)) {
            bankAccount = request.getParameter("otherBankAccount");
        }
        employee.setEmployeeBankAccount(bankAccount);

        employee.setEmployeeAccountNum(Integer.parseInt(request.getParameter("employeeAccountNum")));
        employee.setEmployeeGender(request.getParameter("employeeGender"));
        employee.setLeaveBalance(Integer.parseInt(request.getParameter("leaveBalance")));
        employee.setPayRate(Integer.parseInt(request.getParameter("payRate")));

        // Handling image
        Part filePart = request.getPart("employeeImage");
        if (filePart != null && filePart.getSize() > 0) {
            try (InputStream inputStream = filePart.getInputStream()) {
                byte[] imageBytes = new byte[inputStream.available()];
                inputStream.read(imageBytes);
                employee.setEmployeeImage(imageBytes);
            }
        }

        employeeDAO.addEmployee(employee);
        response.sendRedirect("EmployeeController?action=list");
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response, EmployeeDAO employeeDAO, String currentUserID, String currentUserPosition) throws SQLException, IOException, ServletException, ClassNotFoundException {
        String employeeID = request.getParameter("employeeID");

        // Manager can update any employee's profile, employees can only update their own profile
        if ("manager".equalsIgnoreCase(currentUserPosition) || currentUserID.equals(employeeID)) {
            Employee currentEmployee = employeeDAO.getEmployeeByID(employeeID);

            if (currentEmployee == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Employee not found.");
                return;
            }

            Employee employee = new Employee();
            employee.setEmployeeID(employeeID);
            employee.setEmployeeName(request.getParameter("employeeName"));
            employee.setEmployeePassword(request.getParameter("employeePassword"));
            employee.setEmployeePosition(request.getParameter("employeePosition"));
            employee.setEmployeePhoneNum(Integer.parseInt(request.getParameter("employeePhoneNum")));

            // Handle Bank Account
            String bankAccount = request.getParameter("employeeBankAccount");
            if ("Other".equals(bankAccount)) {
                bankAccount = request.getParameter("otherBankAccount");
            }
            employee.setEmployeeBankAccount(bankAccount);

            employee.setEmployeeAccountNum(Integer.parseInt(request.getParameter("employeeAccountNum")));
            employee.setEmployeeGender(request.getParameter("employeeGender"));

            // Preserve the current values of leaveBalance and payRate
            employee.setLeaveBalance(currentEmployee.getLeaveBalance());
            employee.setPayRate(currentEmployee.getPayRate());

            // Handling image
            Part filePart = request.getPart("employeeImage");
            if (filePart != null && filePart.getSize() > 0) {
                try (InputStream inputStream = filePart.getInputStream()) {
                    byte[] imageBytes = new byte[inputStream.available()];
                    inputStream.read(imageBytes);
                    employee.setEmployeeImage(imageBytes);
                }
            } else {
                employee.setEmployeeImage(currentEmployee.getEmployeeImage());
            }

            employeeDAO.updateEmployee(employee);
            response.sendRedirect("employee-profile.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to update this profile.");
        }
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response, EmployeeDAO employeeDAO) throws SQLException, IOException, ClassNotFoundException {
        String employeeID = request.getParameter("employeeID");
        employeeDAO.deleteEmployee(employeeID);
        response.sendRedirect("EmployeeController?action=list");
    }
}
