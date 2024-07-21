package dao;

import model.Attendance;
import connection.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {

    public String generateAttendanceID() throws SQLException, ClassNotFoundException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT MAX(attendanceID) AS maxID FROM attendance";
            try (PreparedStatement ps = conn.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {
                String newID = "ATT01";
                if (rs.next() && rs.getString("maxID") != null) {
                    String maxID = rs.getString("maxID");
                    int num = Integer.parseInt(maxID.substring(3)) + 1;
                    newID = "ATT" + String.format("%02d", num);
                }
                return newID;
            }
        }
    }
    
    public void addAttendance(Attendance attendance) throws SQLException, ClassNotFoundException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "INSERT INTO attendance (attendanceID, employeeID, clockIn, clockOut, date, scheduleID, status, reason) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, attendance.getAttendanceID());
                ps.setString(2, attendance.getEmployeeID());
                ps.setString(3, attendance.getClockIn());
                ps.setString(4, attendance.getClockOut());
                ps.setString(5, attendance.getDate());
                ps.setString(6, attendance.getScheduleID());
                ps.setString(7, attendance.getStatus());
                ps.setString(8, attendance.getReason());
                ps.executeUpdate();
            }
        }
    }

    public void updateAttendance(Attendance attendance) throws SQLException, ClassNotFoundException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "UPDATE attendance SET clockOut = ? WHERE attendanceID = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, attendance.getClockOut());
                ps.setString(2, attendance.getAttendanceID());
                ps.executeUpdate();
            }
        }
    }

    public Attendance getAttendanceById(String attendanceID) throws SQLException, ClassNotFoundException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM attendance WHERE attendanceID = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, attendanceID);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Attendance attendance = new Attendance();
                        attendance.setAttendanceID(rs.getString("attendanceID"));
                        attendance.setEmployeeID(rs.getString("employeeID"));
                        attendance.setClockIn(rs.getString("clockIn"));
                        attendance.setClockOut(rs.getString("clockOut"));
                        attendance.setDate(rs.getString("date"));
                        attendance.setScheduleID(rs.getString("scheduleID"));
                        attendance.setStatus(rs.getString("status"));
                        attendance.setReason(rs.getString("reason"));
                        return attendance;
                    }
                }
            }
        }
        return null;
    }

    public List<Attendance> getAllAttendances() throws SQLException, ClassNotFoundException {
        List<Attendance> attendances = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM attendance";
            try (PreparedStatement ps = conn.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Attendance attendance = new Attendance();
                    attendance.setAttendanceID(rs.getString("attendanceID"));
                    attendance.setEmployeeID(rs.getString("employeeID"));
                    attendance.setClockIn(rs.getString("clockIn"));
                    attendance.setClockOut(rs.getString("clockOut"));
                    attendance.setDate(rs.getString("date"));
                    attendance.setScheduleID(rs.getString("scheduleID"));
                    attendance.setStatus(rs.getString("status"));
                    attendance.setReason(rs.getString("reason"));
                    attendances.add(attendance);
                }
            }
        }
        return attendances;
    }

    public List<Attendance> getAttendancesByEmployeeId(String employeeID) throws SQLException, ClassNotFoundException {
        List<Attendance> attendances = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM attendance WHERE employeeID = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, employeeID);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Attendance attendance = new Attendance();
                        attendance.setAttendanceID(rs.getString("attendanceID"));
                        attendance.setEmployeeID(rs.getString("employeeID"));
                        attendance.setClockIn(rs.getString("clockIn"));
                        attendance.setClockOut(rs.getString("clockOut"));
                        attendance.setDate(rs.getString("date"));
                        attendance.setScheduleID(rs.getString("scheduleID"));
                        attendance.setStatus(rs.getString("status"));
                        attendance.setReason(rs.getString("reason"));
                        attendances.add(attendance);
                    }
                }
            }
        }
        return attendances;
    }

    public List<Attendance> getAttendancesByEmployeeIdAndMonth(String employeeID, String month) throws SQLException, ClassNotFoundException {
        List<Attendance> attendances = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM attendance WHERE employeeID = ? AND DATE_FORMAT(date, '%Y-%m') = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, employeeID);
                ps.setString(2, month);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Attendance attendance = new Attendance();
                        attendance.setAttendanceID(rs.getString("attendanceID"));
                        attendance.setEmployeeID(rs.getString("employeeID"));
                        attendance.setClockIn(rs.getString("clockIn"));
                        attendance.setClockOut(rs.getString("clockOut"));
                        attendance.setDate(rs.getString("date"));
                        attendance.setScheduleID(rs.getString("scheduleID"));
                        attendance.setStatus(rs.getString("status"));
                        attendance.setReason(rs.getString("reason"));
                        attendances.add(attendance);
                    }
                }
            }
        }
        return attendances;
    }

    public Attendance getAttendanceByEmployeeIdAndDate(String employeeID, String date) throws SQLException, ClassNotFoundException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM attendance WHERE employeeID = ? AND date = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, employeeID);
                ps.setString(2, date);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Attendance attendance = new Attendance();
                        attendance.setAttendanceID(rs.getString("attendanceID"));
                        attendance.setEmployeeID(rs.getString("employeeID"));
                        attendance.setClockIn(rs.getString("clockIn"));
                        attendance.setClockOut(rs.getString("clockOut"));
                        attendance.setDate(rs.getString("date"));
                        attendance.setScheduleID(rs.getString("scheduleID"));
                        attendance.setStatus(rs.getString("status"));
                        attendance.setReason(rs.getString("reason"));
                        return attendance;
                    }
                }
            }
        }
        return null;
    }

    public List<Attendance> getAttendancesByDate(String date) throws SQLException, ClassNotFoundException {
        List<Attendance> attendances = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM attendance WHERE date = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, date);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Attendance attendance = new Attendance();
                        attendance.setAttendanceID(rs.getString("attendanceID"));
                        attendance.setEmployeeID(rs.getString("employeeID"));
                        attendance.setClockIn(rs.getString("clockIn"));
                        attendance.setClockOut(rs.getString("clockOut"));
                        attendance.setDate(rs.getString("date"));
                        attendance.setScheduleID(rs.getString("scheduleID"));
                        attendance.setStatus(rs.getString("status"));
                        attendance.setReason(rs.getString("reason"));
                        attendances.add(attendance);
                    }
                }
            }
        }
        return attendances;
    }

    public void updateAttendanceReason(Attendance attendance) throws SQLException, ClassNotFoundException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "UPDATE attendance SET reason = ? WHERE attendanceID = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, attendance.getReason());
                ps.setString(2, attendance.getAttendanceID());
                ps.executeUpdate();
            }
        }
    }
}
