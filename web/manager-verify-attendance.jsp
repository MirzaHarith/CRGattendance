<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.Attendance"%>
<%@page import="dao.AttendanceDAO"%>
<%
    String employeePosition = (String) session.getAttribute("employeePosition");

    if (!"manager".equalsIgnoreCase(employeePosition)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String filterDate = request.getParameter("date");
    List<Attendance> attendances = new ArrayList<>();
    if (filterDate != null && !filterDate.isEmpty()) {
        AttendanceDAO attendanceDAO = new AttendanceDAO();
        try {
            attendances = attendanceDAO.getAttendancesByDate(filterDate);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Verify Attendance</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            display: flex;
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .sidebar {
            width: 213px;
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
            box-sizing: border-box;
        }

        .sidebar a:hover {
            background-color: #d9a41d;
            opacity: 90%;
        }

        .sidebar a i {
            margin-right: 10px;
            margin-left: 50px;
        }

        .content {
            margin-right: 100px;
            padding: 20px;
            flex-grow: 1;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .form-container {
            max-width: 800px;
            width: 100%;
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .form-container h2 {
            margin-top: 0;
        }

        .form-container label {
            display: block;
            margin-bottom: 8px;
        }

        .form-container select, .form-container input[type="date"], .form-container input[type="submit"] {
            display: block;
            width: 100%;
            padding: 10px;
            margin-bottom: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .form-container input[type="submit"] {
            background-color: #d9a41d;
            color: white;
            border: none;
            cursor: pointer;
        }

        .form-container input[type="submit"]:hover {
            background-color: #b87a16;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
            
        }

        th {
            background-color: black;
            color: white;
        }

        a.update-link {
            color: #d9a41d;
            text-decoration: none;
        }

        a.update-link:hover {
            text-decoration: underline;
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
        <div class="form-container">
            <h2>Verify Attendance</h2>
            <form action="manager-verify-attendance.jsp" method="get">
                <label for="date">Date:</label>
                <input type="date" name="date" id="date" value="<%= filterDate != null ? filterDate : "" %>">
                <input type="submit" value="Verify Attendance">
            </form>

            <h2>Attendances</h2>
            <table>
                <tr>
                    <th>Attendance ID</th>
                    <th>Employee ID</th>
                    <th>Clock In</th>
                    <th>Clock Out</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Reason</th>
                    <th>Schedule ID</th>
                    <th>Action</th>
                </tr>
                <% for (Attendance attendance : attendances) { %>
                    <tr>
                        <td><%= attendance.getAttendanceID() %></td>
                        <td><%= attendance.getEmployeeID() %></td>
                        <td><%= attendance.getClockIn() %></td>
                        <td><%= attendance.getClockOut() %></td>
                        <td><%= attendance.getDate() %></td>
                        <td><%= attendance.getStatus() %></td>
                        <td><%= attendance.getReason() %></td>
                        <td><%= attendance.getScheduleID() %></td>
                        <td>
                            <a href="manager-verify-attendance-form.jsp?attendanceID=<%= attendance.getAttendanceID() %>&employeeID=<%= attendance.getEmployeeID() %>&clockIn=<%= attendance.getClockIn() %>&clockOut=<%= attendance.getClockOut() %>&date=<%= attendance.getDate() %>&status=<%= attendance.getStatus() %>&scheduleID=<%= attendance.getScheduleID() %>&reason=<%= attendance.getReason() %>" class="update-link">Update</a>
                        </td>
                    </tr>
                <% } %>
            </table>
        </div>
    </div>
</body>
</html>
