<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="model.Schedule" %>
<%@page import="dao.ScheduleDAO" %>
<%
    String employeeID = (String) session.getAttribute("employeeID");
    if (employeeID == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ScheduleDAO scheduleDAO = new ScheduleDAO();
    List<Schedule> schedules = new ArrayList<>();
    try {
        schedules = scheduleDAO.getSchedulesByEmployeeId(employeeID);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Schedule</title>
     <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        .sidebar {
            width: 230px;
            background-color: ghostwhite;
            color: black;
            display: flex;
            flex-direction: column;
            padding: 20px 0;
            box-sizing: border-box;
            border-right: 1px solid #ddd;
            position: fixed;
            height: 100vh;
        }
        .sidebar .profile {
            text-align: center;
            margin-bottom: 20px;
        }
        .sidebar .profile img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin-bottom: 10px;
        }
        .sidebar .profile h2 {
            margin: 0;
            font-size: 1.2em;
            color: #333;
        }
        .sidebar a, .dropdown-content a {
            text-decoration: none;
            color: black;
            padding: 10px 20px;
            display: flex;
            align-items: center;
            box-sizing: border-box;
        }
        .sidebar a:hover, .dropdown-content a:hover {
            background-color: #d9a41d;
            opacity: 90%;
        }
        .sidebar a i {
            margin-right: 10px;
        }
        .dropdown {
            position: relative;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            left: 0;
            top: 100%;
            background-color: ghostwhite;
            width: 100%;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
        }
        .dropdown.show .dropdown-content {
            display: block;
        }
        .content {
            margin-left: 230px;
            padding: 20px;
            box-sizing: border-box;
        }
        .container {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            max-width: 850px;
        }
        .container h1 {
            margin-top: 0;
            color: #333;
        }
        form {
            margin-bottom: 20px;
        }
        form label {
            margin-right: 10px;
        }
        input[type="month"] {
            padding: 8px;
            font-size: 1em;
        }
        button {
            background-color: #d9a41d;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9em;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: black;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: black;
            color: white;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
    </style>
    <script>
        function toggleDropdown(id) {
            var dropdown = document.getElementById(id);
            if (dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
            } else {
                var dropdowns = document.querySelectorAll('.dropdown');
                dropdowns.forEach(function(dd) {
                    dd.classList.remove('show');
                });
                dropdown.classList.add('show');
            }
        }
    </script>
</head>
<body>
        <div class="sidebar">
        <div class="profile">
            <img src="img/logo.jpg" alt="Logo">
            <h2>CRG-EMP</h2>
        </div>
        
        <!-- Profile Category -->
        <div class="dropdown" id="profileDropdown">
            <a href="#" onclick="toggleDropdown('profileDropdown'); return false;"><i class="fas fa-user"></i> PROFILE <i class="fas fa-caret-down"></i></a>
            <div class="dropdown-content">
                <a href="employee-view-profile.jsp">View Profile</a>
                <a href="employee-profile.jsp">Update Profile</a>
            </div>
        </div>

        <!-- Attendance Category -->
        <div class="dropdown" id="attendanceDropdown">
            <a href="#" onclick="toggleDropdown('attendanceDropdown'); return false;"><i class="fas fa-check-square"></i> ATTENDANCE <i class="fas fa-caret-down"></i></a>
            <div class="dropdown-content">
                <a href="employee-tick-attendance.jsp">Tick Attendance</a>
                <a href="employee-view-attendance.jsp">View Attendance</a>
            </div>
        </div>
        
        <a href="employee-schedule.jsp"><i class="fas fa-calendar-alt"></i> View Schedule</a>
        
        <!-- Leave Category -->
        <div class="dropdown" id="leaveDropdown">
            <a href="#" onclick="toggleDropdown('leaveDropdown'); return false;"><i class="fas fa-plane"></i> LEAVE <i class="fas fa-caret-down"></i></a>
            <div class="dropdown-content">
                <a href="employee-request-leave.jsp">Request Leave</a>
                <a href="employee-view-leave.jsp">View Leave</a>
            </div>
        </div>

        <a href="employee-payroll.jsp"><i class="fas fa-money-bill-wave"></i> View Payroll</a>
        <a href="login.jsp"><i class="fas fa-sign-out-alt"></i> Log Out</a>
    </div>
    
    <div class="content">
        <div class="container">
            <h1>View Schedule</h1>
    <table border="1">
        <tr>
            <th>ScheduleID</th>
            <th>Date</th>
            <th>Clock In</th>
            <th>Clock Out</th>
        </tr>
        <% for (Schedule schedule : schedules) { %>
            <tr>
                <td><%=schedule.getScheduleID()%> </td>
                <td><%= schedule.getDate() %></td>
                <td><%= schedule.getClockIn() %></td>
                <td><%= schedule.getClockOut() %></td>
            </tr>
        <% } %>
    </table>
</body>
</html>
