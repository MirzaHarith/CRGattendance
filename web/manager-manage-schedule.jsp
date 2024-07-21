<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.Employee"%>
<%@page import="dao.EmployeeDAO"%>
<%@page import="dao.ScheduleDAO"%>
<%@page import="model.Schedule"%>
<%
    String employeePosition = (String) session.getAttribute("employeePosition");

    if (!"manager".equalsIgnoreCase(employeePosition)) {
        response.sendRedirect("login.jsp");
        return;
    }

    EmployeeDAO employeeDAO = new EmployeeDAO();
    ScheduleDAO scheduleDAO = new ScheduleDAO();
    List<Employee> employees = new ArrayList<>();
    List<Schedule> schedules = new ArrayList<>();
    try {
        employees = employeeDAO.getAllEmployees();
        schedules = scheduleDAO.getAllSchedules();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Schedules</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
    body {
    display: flex;
    margin: 0;
    height: 100vh;
    font-family: Arial, sans-serif;
}
    .sidebar {
            position: static;
            width: 270px;
            background-color: ghostwhite;
            color: black;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px 0;

        }

.profile {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
}

.profile img {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    margin-right: 10px;
}

.profile h2 {
    margin: 0;
    font-size: 1.5em;
}

.sidebar a {
    margin-right: 30px;
    text-decoration: none;
    color: black;
    padding: 20px 0;
    width: 115%;
    text-align: left;
    display: flex;
    align-items: center;
    box-sizing: border-box; /* Ensure padding is included in width */
}

.sidebar a:hover {
    background-color: #d9a41d;
    opacity: 90%;
}

.sidebar a i {
    margin-right: 10px;
    margin-left: 45px;
}

.content {
    margin-left: 30px; /* Adjusted to match sidebar width */
    padding: 20px;
    flex-grow: 1;
    box-sizing: border-box; /* Ensure padding is included in width */
}

.filter-form {
    display: flex;
    align-items: center;
}

.filter-form label {
    margin-right: 10px;
}

.filter-form select {
    margin-right: 10px;
}

.filter-form input[type="submit"] {
    padding: 5px 15px;
    background-color: gray;
    color: white;
    border: none;
    cursor: pointer;
    margin-right: 20px;
}

.filter-form input[type="submit"]:hover {
    background-color: black;
}

/* Button Styles */
.button {
    padding: 4px 10px;
    background-color: #d9a41d;
    color: white;
    border: none;
    cursor: pointer;
    margin-left: 10px;
    font-size: 15px;
}

.button:hover {
    background-color: black;
}

/* Table Styles */
table {
    margin-right: 100px;
    width: 100%;
    border-collapse: collapse;
}

th, td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
}

tr:nth-child(even) {
    background-color: #f2f2f2;
}

th {
    background-color: black;
    color: white;
}
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="profile">
            <img src="img/logo.jpg" alt="Logo">
            <h2>CRG-M</h2>
        </div>
        <a href="manager.jsp"><i class="fas fa-window-maximize"></i> Dashboard</a>
        <a href="manager-manage-employee.jsp"><i class="fas fa-users"></i> Employees List</a>
        <a href="manager-manage-schedule.jsp"><i class="fas fa-calendar-alt"></i> Schedule</a>
        <a href="manager-verify-attendance.jsp"><i class="fas fa-check-square"></i> Attendance</a>
        <a href="manager-manage-leave.jsp"><i class="fas fa-plane"></i> Leave</a>
        <a href="login.jsp"><i class="fas fa-sign-out-alt"></i> Log Out</a>
    </div>

    <div class="content">
        
        <h2>Select Month</h2>
        <form method="get" action="manager-manage-schedule.jsp" class="filter-form">
            <label for="month">Month:</label>
            <select name="month" id="month">
                <% 
                    String[] months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                    for (int i = 0; i < months.length; i++) {
                        %>
                        <option value="<%= i + 1 %>"><%= months[i] %></option>
                        <%
                    }
                %>
            </select>
            <input type="submit" value="Show Schedule">
            
            <a href="manager-add-schedule.jsp" class="button">Add Schedule</a><br>
            <a href="manager-delete-schedule.jsp" class="button">Delete Schedule</a><br>
            
        
        </form>

        <% 
            String selectedMonth = request.getParameter("month");
            int month = selectedMonth != null ? Integer.parseInt(selectedMonth) : 1;
            java.util.Calendar calendar = java.util.Calendar.getInstance();
            int year = calendar.get(java.util.Calendar.YEAR);
            calendar.set(year, month - 1, 1);
            int daysInMonth = calendar.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
        %>

        <h2>Schedules for <%= months[month - 1] %> <%= year %></h2>
        <table>
        <tr>
            <th>Employee Name</th>
            <% 
                for (int day = 1; day <= daysInMonth; day++) {
                    %>
                    <th><%= day %></th>
                    <%
                }
            %>
        </tr>
        <% for (Employee employee : employees) { %>
            <tr>
                <td><%= employee.getEmployeeName() %></td>
                <% 
                    for (int day = 1; day <= daysInMonth; day++) {
                        boolean found = false;
                        String currentDate = year + "-" + String.format("%02d", month) + "-" + String.format("%02d", day);
                        for (Schedule schedule : schedules) {
                            if (schedule.getEmployeeID().equals(employee.getEmployeeID()) && schedule.getDate().equals(currentDate)) {
                                found = true;
                                String clockIn = schedule.getClockIn().substring(0, 5);  // Remove seconds
                                String clockOut = schedule.getClockOut().substring(0, 5); // Remove seconds
                                %>
                                <td><%= clockIn %> to <%= clockOut %></td>
                                <%
                                break;
                            }
                        }
                        if (!found) {
                            %>
                            <td></td>
                            <%
                        }
                    }
                %>
            </tr>
        <% } %>
        
    </table>
        
    </div>

</body>
</html>
