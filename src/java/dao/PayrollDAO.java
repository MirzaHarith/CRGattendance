package dao;

import model.Payroll;
import connection.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PayrollDAO {

    private static final String INSERT_PAYROLL_SQL = "INSERT INTO payroll (payrollID, employeeID, month, totalHours, payday, totalSalary) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_PAYROLL_SQL = "UPDATE payroll SET totalHours = ?, payday = ?, totalSalary = ? WHERE payrollID = ?";
    private static final String SELECT_PAYROLL_BY_EMPLOYEE_AND_MONTH = "SELECT * FROM payroll WHERE employeeID = ? AND month = ?";
    private static final String GENERATE_PAYROLL_ID = "SELECT COUNT(*) FROM payroll";

    public String generatePayrollID() throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(GENERATE_PAYROLL_ID);
             ResultSet rs = preparedStatement.executeQuery()) {
            if (rs.next()) {
                return "PAY" + (rs.getInt(1) + 1);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addPayroll(Payroll payroll) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_PAYROLL_SQL)) {
            preparedStatement.setString(1, payroll.getPayrollID());
            preparedStatement.setString(2, payroll.getEmployeeID());
            preparedStatement.setString(3, payroll.getMonth());
            preparedStatement.setInt(4, payroll.getTotalHours());
            preparedStatement.setDouble(5, payroll.getPayDay());
            preparedStatement.setDouble(6, payroll.getTotalSalary());
            preparedStatement.executeUpdate();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void updatePayroll(Payroll payroll) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_PAYROLL_SQL)) {
            preparedStatement.setInt(1, payroll.getTotalHours());
            preparedStatement.setDouble(2, payroll.getPayDay());
            preparedStatement.setDouble(3, payroll.getTotalSalary());
            preparedStatement.setString(4, payroll.getPayrollID());
            preparedStatement.executeUpdate();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public Payroll getPayrollByEmployeeAndMonth(String employeeID, String month) throws SQLException {
        Payroll payroll = null;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_PAYROLL_BY_EMPLOYEE_AND_MONTH)) {
            preparedStatement.setString(1, employeeID);
            preparedStatement.setString(2, month);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    payroll = new Payroll();
                    payroll.setPayrollID(rs.getString("payrollID"));
                    payroll.setEmployeeID(rs.getString("employeeID"));
                    payroll.setMonth(rs.getString("month"));
                    payroll.setTotalHours(rs.getInt("totalHours"));
                    payroll.setPayDay(rs.getDouble("payday"));
                    payroll.setTotalSalary(rs.getDouble("totalSalary"));
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return payroll;
    }
}
