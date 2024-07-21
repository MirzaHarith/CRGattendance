// controller/ScheduleController.java
package controller;

import dao.ScheduleDAO;
import model.Schedule;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class ScheduleController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        ScheduleDAO scheduleDAO = new ScheduleDAO();
        String currentUserPosition = (String) request.getSession().getAttribute("employeePosition");

        try {
            if ("add".equalsIgnoreCase(action) && "manager".equalsIgnoreCase(currentUserPosition)) {
                Schedule schedule = new Schedule();
                schedule.setEmployeeID(request.getParameter("employeeID"));
                schedule.setDate(request.getParameter("date"));
                String shift = request.getParameter("shift");
                if ("7:00am-1:00pm".equals(shift)) {
                    schedule.setClockIn("07:00");
                    schedule.setClockOut("13:00");
                } else if ("1:00pm-7:00pm".equals(shift)) {
                    schedule.setClockIn("13:00");
                    schedule.setClockOut("19:00");
                }
                scheduleDAO.addSchedule(schedule);
                response.sendRedirect("manager-manage-schedule.jsp");
            } else if ("delete".equalsIgnoreCase(action) && "manager".equalsIgnoreCase(currentUserPosition)) {
                String employeeID = request.getParameter("employeeID");
                String date = request.getParameter("date");
                scheduleDAO.deleteScheduleByEmployeeAndDate(employeeID, date);
                response.sendRedirect("manager-manage-schedule.jsp");
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to perform this action.");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
