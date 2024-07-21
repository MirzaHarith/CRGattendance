package dao;

import connection.DatabaseConnection;
import model.Leave;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LeaveDAO {

    public String generateLeaveID() throws SQLException, ClassNotFoundException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT MAX(leaveID) AS maxID FROM `leave`";
            try (PreparedStatement ps = conn.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {
                String newID = "LV01";
                if (rs.next() && rs.getString("maxID") != null) {
                    String maxID = rs.getString("maxID");
                    int num = Integer.parseInt(maxID.substring(2)) + 1;
                    newID = "LV" + String.format("%02d", num);
                }
                return newID;
            }
        }
    }

    public void addLeave(Leave leave) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO `leave` (leaveID, applyLeaveDate, leaveType, startDate, endDate, evidence, reason, employeeID, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, leave.getLeaveID());
            ps.setString(2, leave.getApplyLeaveDate());
            ps.setString(3, leave.getLeaveType());
            ps.setString(4, leave.getStartDate());
            ps.setString(5, leave.getEndDate());
            ps.setBytes(6, leave.getEvidence());
            ps.setString(7, leave.getReason());
            ps.setString(8, leave.getEmployeeID());
            ps.setString(9, leave.getStatus());
            ps.executeUpdate();
        }
    }

    public List<Leave> getLeavesByEmployeeID(String employeeID) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM `leave` WHERE employeeID = ?";
        List<Leave> leaves = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, employeeID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Leave leave = new Leave();
                    leave.setLeaveID(rs.getString("leaveID"));
                    leave.setApplyLeaveDate(rs.getString("applyLeaveDate"));
                    leave.setLeaveType(rs.getString("leaveType"));
                    leave.setStartDate(rs.getString("startDate"));
                    leave.setEndDate(rs.getString("endDate"));
                    leave.setEvidence(rs.getBytes("evidence"));
                    leave.setReason(rs.getString("reason"));
                    leave.setEmployeeID(rs.getString("employeeID"));
                    leave.setStatus(rs.getString("status"));
                    leaves.add(leave);
                }
            }
        }
        return leaves;
    }

    public Leave getLeaveByID(String leaveID) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM `leave` WHERE leaveID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, leaveID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Leave leave = new Leave();
                    leave.setLeaveID(rs.getString("leaveID"));
                    leave.setApplyLeaveDate(rs.getString("applyLeaveDate"));
                    leave.setLeaveType(rs.getString("leaveType"));
                    leave.setStartDate(rs.getString("startDate"));
                    leave.setEndDate(rs.getString("endDate"));
                    leave.setEvidence(rs.getBytes("evidence"));
                    leave.setReason(rs.getString("reason"));
                    leave.setEmployeeID(rs.getString("employeeID"));
                    leave.setStatus(rs.getString("status"));
                    return leave;
                }
            }
        }
        return null;
    }

    public void updateLeaveStatus(String leaveID, String status) throws SQLException, ClassNotFoundException {
        String query = "UPDATE `leave` SET status = ? WHERE leaveID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setString(2, leaveID);
            ps.executeUpdate();
        }
    }

    public void deleteLeave(String leaveID) throws SQLException, ClassNotFoundException {
        String query = "DELETE FROM `leave` WHERE leaveID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, leaveID);
            ps.executeUpdate();
        }
    }
    
    public List<Leave> getAllLeaves() throws SQLException, ClassNotFoundException {
    String query = "SELECT * FROM `leave`";
    List<Leave> leaves = new ArrayList<>();
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Leave leave = new Leave();
            leave.setLeaveID(rs.getString("leaveID"));
            leave.setApplyLeaveDate(rs.getString("applyLeaveDate"));
            leave.setLeaveType(rs.getString("leaveType"));
            leave.setStartDate(rs.getString("startDate"));
            leave.setEndDate(rs.getString("endDate"));
            leave.setEvidence(rs.getBytes("evidence"));
            leave.setReason(rs.getString("reason"));
            leave.setEmployeeID(rs.getString("employeeID"));
            leave.setStatus(rs.getString("status"));
            leaves.add(leave);
        }
    }
    return leaves;
    }

}
