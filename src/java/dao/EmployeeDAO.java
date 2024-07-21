package dao;

import model.Employee;
import connection.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    public void addEmployee(Employee employee) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO employee (employeeID, employeeName, employeePassword, employeePosition, employeeImage, " +
                       "employeePhoneNum, employeeBankAccount, employeeAccountNum, employeeGender, leaveBalance, payRate) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, employee.getEmployeeID());
            ps.setString(2, employee.getEmployeeName());
            ps.setString(3, employee.getEmployeePassword());
            ps.setString(4, employee.getEmployeePosition());
            ps.setBytes(5, employee.getEmployeeImage());
            ps.setInt(6, employee.getEmployeePhoneNum());
            ps.setString(7, employee.getEmployeeBankAccount());
            ps.setInt(8, employee.getEmployeeAccountNum());
            ps.setString(9, employee.getEmployeeGender());
            ps.setInt(10, employee.getLeaveBalance());
            ps.setInt(11, employee.getPayRate());
            ps.executeUpdate();
        }
    }

    public void updateEmployee(Employee employee) throws SQLException, ClassNotFoundException {
        String query = "UPDATE employee SET employeeName = ?, employeePassword = ?, employeePosition = ?, " +
                       "employeeImage = ?, employeePhoneNum = ?, employeeBankAccount = ?, " +
                       "employeeAccountNum = ?, employeeGender = ?, leaveBalance = ?, payRate = ? WHERE employeeID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, employee.getEmployeeName());
            ps.setString(2, employee.getEmployeePassword());
            ps.setString(3, employee.getEmployeePosition());
            ps.setBytes(4, employee.getEmployeeImage());
            ps.setInt(5, employee.getEmployeePhoneNum());
            ps.setString(6, employee.getEmployeeBankAccount());
            ps.setInt(7, employee.getEmployeeAccountNum());
            ps.setString(8, employee.getEmployeeGender());
            ps.setInt(9, employee.getLeaveBalance());
            ps.setInt(10, employee.getPayRate());
            ps.setString(11, employee.getEmployeeID());
            ps.executeUpdate();
        }
    }

    public void deleteEmployee(String employeeID) throws SQLException, ClassNotFoundException {
        String query = "DELETE FROM employee WHERE employeeID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, employeeID);
            ps.executeUpdate();
        }
    }

    public Employee getEmployeeByID(String employeeID) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM employee WHERE employeeID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, employeeID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Employee employee = new Employee();
                    employee.setEmployeeID(rs.getString("employeeID"));
                    employee.setEmployeeName(rs.getString("employeeName"));
                    employee.setEmployeePassword(rs.getString("employeePassword"));
                    employee.setEmployeePosition(rs.getString("employeePosition"));
                    employee.setEmployeeImage(rs.getBytes("employeeImage"));
                    employee.setEmployeePhoneNum(rs.getInt("employeePhoneNum"));
                    employee.setEmployeeBankAccount(rs.getString("employeeBankAccount"));
                    employee.setEmployeeAccountNum(rs.getInt("employeeAccountNum"));
                    employee.setEmployeeGender(rs.getString("employeeGender"));
                    employee.setLeaveBalance(rs.getInt("leaveBalance"));
                    employee.setPayRate(rs.getInt("payRate"));
                    return employee;
                }
            }
        }
        return null;
    }

    public List<Employee> getAllEmployees() throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM employee";
        List<Employee> employees = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Employee employee = new Employee();
                employee.setEmployeeID(rs.getString("employeeID"));
                employee.setEmployeeName(rs.getString("employeeName"));
                employee.setEmployeePassword(rs.getString("employeePassword"));
                employee.setEmployeePosition(rs.getString("employeePosition"));
                employee.setEmployeeImage(rs.getBytes("employeeImage"));
                employee.setEmployeePhoneNum(rs.getInt("employeePhoneNum"));
                employee.setEmployeeBankAccount(rs.getString("employeeBankAccount"));
                employee.setEmployeeAccountNum(rs.getInt("employeeAccountNum"));
                employee.setEmployeeGender(rs.getString("employeeGender"));
                employee.setLeaveBalance(rs.getInt("leaveBalance"));
                employee.setPayRate(rs.getInt("payRate"));
                employees.add(employee);
            }
        }
        return employees;
    }

    public List<String> getDistinctPositions() throws SQLException, ClassNotFoundException {
        String query = "SELECT DISTINCT employeePosition FROM employee";
        List<String> positions = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                positions.add(rs.getString("employeePosition"));
            }
        }
        return positions;
    }
    
    public List<Employee> getEmployeesByPosition(String position) throws SQLException, ClassNotFoundException {
    String query = "SELECT * FROM employee WHERE employeePosition = ?";
    List<Employee> employees = new ArrayList<>();
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setString(1, position);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Employee employee = new Employee();
                employee.setEmployeeID(rs.getString("employeeID"));
                employee.setEmployeeName(rs.getString("employeeName"));
                employee.setEmployeePassword(rs.getString("employeePassword"));
                employee.setEmployeePosition(rs.getString("employeePosition"));
                employee.setEmployeeImage(rs.getBytes("employeeImage"));
                employee.setEmployeePhoneNum(rs.getInt("employeePhoneNum"));
                employee.setEmployeeBankAccount(rs.getString("employeeBankAccount"));
                employee.setEmployeeAccountNum(rs.getInt("employeeAccountNum"));
                employee.setEmployeeGender(rs.getString("employeeGender"));
                employee.setLeaveBalance(rs.getInt("leaveBalance"));
                employee.setPayRate(rs.getInt("payRate"));
                employees.add(employee);
            }
        }
    }
    return employees;
}


    public void updateLeaveBalance(String employeeID, int newLeaveBalance) throws SQLException, ClassNotFoundException {
        String query = "UPDATE employee SET leaveBalance = ? WHERE employeeID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, newLeaveBalance);
            ps.setString(2, employeeID);
            ps.executeUpdate();
        }
    }
}
