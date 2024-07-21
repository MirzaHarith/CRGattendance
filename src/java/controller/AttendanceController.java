package controller;

import dao.AttendanceDAO;
import dao.ScheduleDAO;
import model.Attendance;
import model.Schedule;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class AttendanceController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String employeeID = (String) request.getSession().getAttribute("employeeID");
        String scheduleID = request.getParameter("scheduleID");
        AttendanceDAO attendanceDAO = new AttendanceDAO();
        ScheduleDAO scheduleDAO = new ScheduleDAO();

        try {
            if ("selectSchedule".equalsIgnoreCase(action)) {
                List<Schedule> schedules = scheduleDAO.getSchedulesByEmployeeId(employeeID);
                request.setAttribute("schedules", schedules);
                request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                return;
            }

            if ("verify".equalsIgnoreCase(action)) {
                String date = request.getParameter("date");
                if (date == null || date.isEmpty()) {
                    request.setAttribute("errorMessage", "Date is required.");
                    request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                    return;
                }

                List<Attendance> attendances = attendanceDAO.getAttendancesByDate(date);
                request.setAttribute("attendances", attendances);
                request.getRequestDispatcher("manager-verify-attendance.jsp").forward(request, response);
                return;
            }
            
            if ("updateReason".equalsIgnoreCase(action)) {
                String attendanceID = request.getParameter("attendanceID");
                String reason = request.getParameter("reason");
                if (attendanceID == null || attendanceID.isEmpty() || reason == null || reason.isEmpty()) {
                    request.setAttribute("errorMessage", "Attendance ID and Reason are required.");
                    request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                    return;
                }

                Attendance attendance = attendanceDAO.getAttendanceById(attendanceID);
                if (attendance != null) {
                    attendance.setReason(reason);
                    attendanceDAO.updateAttendanceReason(attendance);
                    request.setAttribute("successMessage", "Reason updated successfully.");
                    request.getRequestDispatcher("manager-verify-attendance.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Invalid attendance ID.");
                    request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                }
                return;
            }

            if (scheduleID == null || scheduleID.isEmpty()) {
                request.setAttribute("errorMessage", "Schedule ID is required.");
                request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                return;
            }

            Schedule schedule = scheduleDAO.getScheduleById(scheduleID);
            if (schedule == null) {
                request.setAttribute("errorMessage", "Invalid schedule ID.");
                request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                return;
            }

            LocalDateTime currentDateTime = LocalDateTime.now();
            LocalTime currentTime = currentDateTime.toLocalTime();
            LocalDate currentDate = currentDateTime.toLocalDate();
            String currentStatus;

            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");

            LocalDate scheduleDate = LocalDate.parse(schedule.getDate(), dateFormatter);
            LocalTime scheduleClockInTime = LocalTime.parse(schedule.getClockIn(), timeFormatter);
            LocalTime scheduleClockOutTime = LocalTime.parse(schedule.getClockOut(), timeFormatter);
            LocalDateTime scheduleClockInDateTime = LocalDateTime.of(scheduleDate, scheduleClockInTime);

            // Check if currentDate is after scheduleDate and auto-generate absent record
            if (currentDate.isAfter(scheduleDate)) {
                Attendance existingAttendance = attendanceDAO.getAttendanceByEmployeeIdAndDate(employeeID, schedule.getDate());
                if (existingAttendance == null) {
                    String newAttendanceID = attendanceDAO.generateAttendanceID();
                    Attendance attendance = new Attendance();
                    attendance.setAttendanceID(newAttendanceID);
                    attendance.setEmployeeID(employeeID);
                    attendance.setClockIn(null);
                    attendance.setClockOut(null);
                    attendance.setDate(schedule.getDate());
                    attendance.setScheduleID(scheduleID);
                    attendance.setStatus("absent");
                    attendanceDAO.addAttendance(attendance);
                    request.setAttribute("successMessage", "Marked as absent.");
                    request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                    return;
                }
            }

            if ("clockIn".equalsIgnoreCase(action)) {
                // Ensure current time is not after the scheduled clock-out time
                if (currentTime.isAfter(scheduleClockOutTime)) {
                    request.setAttribute("errorMessage", "Invalid clock-in: current time is after clock-out time.");
                    request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                    return;
                }

                LocalDateTime earliestClockInTime = scheduleClockInDateTime.minusMinutes(10);
                LocalDateTime latestClockInTime = scheduleClockInDateTime.plusMinutes(10);

                if (currentDateTime.isAfter(earliestClockInTime) && currentDateTime.isBefore(latestClockInTime)) {
                    currentStatus = "on time";
                } else if (currentDateTime.isAfter(latestClockInTime)) {
                    currentStatus = "late";
                } else {
                    request.setAttribute("errorMessage", "Clock-in time must be within 10 minutes before or after the scheduled time.");
                    request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                    return;
                }

                Attendance existingAttendance = attendanceDAO.getAttendanceByEmployeeIdAndDate(employeeID, schedule.getDate());
                if (existingAttendance != null) {
                    request.setAttribute("errorMessage", "Clock-in action already exists for this schedule.");
                    request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                    return;
                }

                String newAttendanceID = attendanceDAO.generateAttendanceID();
                Attendance attendance = new Attendance();
                attendance.setAttendanceID(newAttendanceID);
                attendance.setEmployeeID(employeeID);
                attendance.setClockIn(currentTime.format(timeFormatter));
                attendance.setClockOut(null);
                attendance.setDate(schedule.getDate());
                attendance.setScheduleID(scheduleID);
                attendance.setStatus(currentStatus);
                attendanceDAO.addAttendance(attendance);

                request.setAttribute("successMessage", "Clock In successful.");
                request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                return;

            } else if ("clockOut".equalsIgnoreCase(action)) {
                Attendance attendance = attendanceDAO.getAttendanceByEmployeeIdAndDate(employeeID, schedule.getDate());
                if (attendance != null && attendance.getClockOut() == null) {
                    if (scheduleClockOutTime.equals(LocalTime.parse("13:00"))) {
                        if (currentTime.isAfter(scheduleClockOutTime) && currentTime.isBefore(scheduleClockOutTime.plusHours(1).plusSeconds(1))) {
                            attendance.setClockOut(currentTime.format(timeFormatter));
                        } else if (currentTime.isAfter(scheduleClockOutTime.plusHours(1))) {
                            attendance.setClockOut(scheduleClockOutTime.format(timeFormatter));
                        } else {
                            request.setAttribute("errorMessage", "ClockOut cannot be done because your shift is not ended yet.");
                            request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                            return;
                        }
                    } else if (scheduleClockOutTime.equals(LocalTime.parse("19:00"))) {
                        if (currentTime.isAfter(scheduleClockOutTime) && currentTime.isBefore(scheduleClockOutTime.plusHours(1).plusSeconds(1))) {
                            attendance.setClockOut(currentTime.format(timeFormatter));
                        } else if (currentTime.isAfter(scheduleClockOutTime.plusHours(1))) {
                            attendance.setClockOut(scheduleClockOutTime.format(timeFormatter));
                        } else {
                            request.setAttribute("errorMessage", "ClockOut cannot be done because your shift is not ended yet.");
                            request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                            return;
                        }
                    }

                    attendanceDAO.updateAttendance(attendance);
                    request.setAttribute("successMessage", "Clock Out successful.");
                    request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorMessage", "Invalid clock-out action.");
                    request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                    return;
                }
            } else if ("absent".equalsIgnoreCase(action)) {
                Attendance attendance = attendanceDAO.getAttendanceByEmployeeIdAndDate(employeeID, schedule.getDate());
                if (attendance == null) {
                    String newAttendanceID = attendanceDAO.generateAttendanceID();
                    attendance = new Attendance();
                    attendance.setAttendanceID(newAttendanceID);
                    attendance.setEmployeeID(employeeID);
                    attendance.setClockIn(null);
                    attendance.setClockOut(null);
                    attendance.setDate(schedule.getDate());
                    attendance.setScheduleID(scheduleID);
                    attendance.setStatus("absent");
                    attendanceDAO.addAttendance(attendance);
                    request.setAttribute("successMessage", "Marked as Absent.");
                    request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorMessage", "Attendance record already exists for this schedule.");
                    request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                    return;
                }
            } else {
                request.setAttribute("errorMessage", "Invalid action.");
                request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
                return;
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Internal server error.");
            request.getRequestDispatcher("employee-tick-attendance.jsp").forward(request, response);
            return;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
