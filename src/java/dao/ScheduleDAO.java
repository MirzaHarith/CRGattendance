package dao;

import model.Schedule;
import connection.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {

    private String generateScheduleID() throws SQLException, ClassNotFoundException {
        Connection conn = DatabaseConnection.getConnection();
        String query = "SELECT MAX(scheduleID) AS maxID FROM schedule";
        PreparedStatement ps = conn.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        String newID = "SCH01";
        if (rs.next() && rs.getString("maxID") != null) {
            String maxID = rs.getString("maxID");
            int num = Integer.parseInt(maxID.substring(3)) + 1;
            newID = "SCH" + String.format("%02d", num);
        }
        conn.close();
        return newID;
    }

    public void addSchedule(Schedule schedule) throws SQLException, ClassNotFoundException {
        Connection conn = DatabaseConnection.getConnection();
        String newScheduleID = generateScheduleID();
        String query = "INSERT INTO schedule (scheduleID, employeeID, date, clockIn, clockOut) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, newScheduleID);
        ps.setString(2, schedule.getEmployeeID());
        ps.setString(3, schedule.getDate());
        ps.setString(4, schedule.getClockIn());
        ps.setString(5, schedule.getClockOut());
        ps.executeUpdate();
        conn.close();
    }

    public void updateSchedule(Schedule schedule) throws SQLException, ClassNotFoundException {
        Connection conn = DatabaseConnection.getConnection();
        String query = "UPDATE schedule SET employeeID = ?, date = ?, clockIn = ?, clockOut = ? WHERE scheduleID = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, schedule.getEmployeeID());
        ps.setString(2, schedule.getDate());
        ps.setString(3, schedule.getClockIn());
        ps.setString(4, schedule.getClockOut());
        ps.setString(5, schedule.getScheduleID());
        ps.executeUpdate();
        conn.close();
    }

    public void deleteSchedule(String scheduleID) throws SQLException, ClassNotFoundException {
        Connection conn = DatabaseConnection.getConnection();
        String query = "DELETE FROM schedule WHERE scheduleID = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, scheduleID);
        ps.executeUpdate();
        conn.close();
    }

    public void deleteScheduleByEmployeeAndDate(String employeeID, String date) throws SQLException, ClassNotFoundException {
        Connection conn = DatabaseConnection.getConnection();
        String query = "DELETE FROM schedule WHERE employeeID = ? AND date = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, employeeID);
        ps.setString(2, date);
        ps.executeUpdate();
        conn.close();
    }

    public Schedule getScheduleById(String scheduleID) throws SQLException, ClassNotFoundException {
        Connection conn = DatabaseConnection.getConnection();
        String query = "SELECT * FROM schedule WHERE scheduleID = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, scheduleID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Schedule schedule = new Schedule();
            schedule.setScheduleID(rs.getString("scheduleID"));
            schedule.setEmployeeID(rs.getString("employeeID"));
            schedule.setDate(rs.getString("date"));
            schedule.setClockIn(rs.getString("clockIn"));
            schedule.setClockOut(rs.getString("clockOut"));
            conn.close();
            return schedule;
        } else {
            conn.close();
            return null;
        }
    }

    public List<Schedule> getAllSchedules() throws SQLException, ClassNotFoundException {
        Connection conn = DatabaseConnection.getConnection();
        String query = "SELECT * FROM schedule";
        PreparedStatement ps = conn.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        List<Schedule> schedules = new ArrayList<>();
        while (rs.next()) {
            Schedule schedule = new Schedule();
            schedule.setScheduleID(rs.getString("scheduleID"));
            schedule.setEmployeeID(rs.getString("employeeID"));
            schedule.setDate(rs.getString("date"));
            schedule.setClockIn(rs.getString("clockIn"));
            schedule.setClockOut(rs.getString("clockOut"));
            schedules.add(schedule);
        }
        conn.close();
        return schedules;
    }

    public List<Schedule> getSchedulesByEmployeeId(String employeeID) throws SQLException, ClassNotFoundException {
        Connection conn = DatabaseConnection.getConnection();
        String query = "SELECT * FROM schedule WHERE employeeID = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, employeeID);
        ResultSet rs = ps.executeQuery();
        List<Schedule> schedules = new ArrayList<>();
        while (rs.next()) {
            Schedule schedule = new Schedule();
            schedule.setScheduleID(rs.getString("scheduleID"));
            schedule.setEmployeeID(rs.getString("employeeID"));
            schedule.setDate(rs.getString("date"));
            schedule.setClockIn(rs.getString("clockIn"));
            schedule.setClockOut(rs.getString("clockOut"));
            schedules.add(schedule);
        }
        conn.close();
        return schedules;
    }
}
