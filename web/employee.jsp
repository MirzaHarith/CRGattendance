<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="model.Employee" %>
<%@page import="dao.EmployeeDAO" %>
<%@page import="dao.ScheduleDAO" %>
<%@page import="model.Schedule" %>
<%@page import="dao.AttendanceDAO" %>
<%@page import="model.Attendance" %>
<%
    String employeeID = (String) session.getAttribute("employeeID");
    String employeePosition = (String) session.getAttribute("employeePosition");
    EmployeeDAO employeeDAO = new EmployeeDAO();
    Employee employee = null;

    if (employeeID == null || employeePosition == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        employee = employeeDAO.getEmployeeByID(employeeID);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Home</title>
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
            box-sizing: border-box; /* Ensure padding is included in width */
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
            margin-left: 300px; /* Match the sidebar width */
            padding: 20px;
            flex-grow: 1;
            box-sizing: border-box; /* Ensure padding is included in width */
        }
        .greeting-box {
            background-color: black;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 750px;
            
        }
        .greeting-box h2 {
            margin: 0;
            font-size: 2em;
            color: white;
        }
        .greeting-box p {
            font-size: 1.2em;
            color: white;
        }
    </style>
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
        <div class="greeting-box">
            <h2>Welcome, <%= employee != null ? employee.getEmployeeName() : "Employee" %>!</h2>
            <p>We're glad to have you here. Explore the sidebar to manage your profile, check your attendance, request leave, and view your payroll. Wishing you a productive and fulfilling day!</p>
        </div>
    </div>

    <script>
        function toggleDropdown(id) {
            var dropdown = document.getElementById(id);
            if (dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
            } else {
                // Hide all dropdowns
                var dropdowns = document.querySelectorAll('.dropdown');
                dropdowns.forEach(function(dd) {
                    dd.classList.remove('show');
                });
                // Show the clicked dropdown
                dropdown.classList.add('show');
            }
        }
    </script>
</body>
</html>
