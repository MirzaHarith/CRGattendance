// DashboardHelper.java
package helper;

import dao.AttendanceDAO;
import dao.EmployeeDAO;
import dao.LeaveDAO;
import model.Attendance;
import model.Employee;
import model.Leave;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import java.sql.SQLException;
import java.util.List;

public class DashboardHelper {

    public static int getTotalEmployees() throws SQLException, ClassNotFoundException {
        EmployeeDAO employeeDAO = new EmployeeDAO();
        List<Employee> employees = employeeDAO.getAllEmployees();
        return employees.size();
    }

    public static int getPendingLeaveRequests() throws SQLException, ClassNotFoundException {
        LeaveDAO leaveDAO = new LeaveDAO();
        List<Leave> leaves = leaveDAO.getAllLeaves();
        int pendingCount = 0;
        for (Leave leave : leaves) {
            if ("Pending".equalsIgnoreCase(leave.getStatus())) {
                pendingCount++;
            }
        }
        return pendingCount;
    }

    public static int getTodayAttendance() throws SQLException, ClassNotFoundException {
        AttendanceDAO attendanceDAO = new AttendanceDAO();
        List<Attendance> attendances = attendanceDAO.getAttendancesByDate(getTodayDate());
        return attendances.size();
    }

    public static int getTodayLeave() throws SQLException, ClassNotFoundException {
        LeaveDAO leaveDAO = new LeaveDAO();
        List<Leave> leaves = leaveDAO.getAllLeaves();
        int todayLeaveCount = 0;
        String todayDate = getTodayDate();
        for (Leave leave : leaves) {
            if (todayDate.equals(leave.getStartDate()) || todayDate.equals(leave.getEndDate())) {
                todayLeaveCount++;
            }
        }
        return todayLeaveCount;
    }

    public static List<Attendance> getDetailedAttendanceOverview(String date) throws SQLException, ClassNotFoundException {
        AttendanceDAO attendanceDAO = new AttendanceDAO();
        return attendanceDAO.getAttendancesByDate(date);
    }

    public static String getEmployeeNameById(String employeeID) throws SQLException, ClassNotFoundException {
        EmployeeDAO employeeDAO = new EmployeeDAO();
        Employee employee = employeeDAO.getEmployeeByID(employeeID);
        return employee != null ? employee.getEmployeeName() : "Unknown";
    }
    
    public static String getTodayDate() {
        LocalDate today = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return today.format(formatter);
    }
}
