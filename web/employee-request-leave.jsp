<%@page import="java.time.LocalDate"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Leave" %>
<%@ page import="dao.LeaveDAO" %>
<%@page import="model.Employee" %>
<%@page import="dao.EmployeeDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<%
    String employeeID = (String) session.getAttribute("employeeID");
    if (employeeID == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    EmployeeDAO employeeDAO = new EmployeeDAO();
    Employee employee = null;
    try {
        employee = employeeDAO.getEmployeeByID(employeeID);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Request Leave</title>
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
        .profile-header {
            width: 100%;
            background-color: #e1e8ed;
            position: relative;
            overflow: hidden;
            height: 250px;
        }
        .profile-header img {
            width: 100%;
            height: auto; /* Maintain aspect ratio */
        }
        .profile-info {
            position: absolute;
            top: 120px; /* Adjust based on the desired vertical position */
            left: 50%;
            transform: translateX(-50%); /* Center horizontally */
            text-align: center;
            z-index: 1; /* Ensure it is above the header */
        }
        .profile-info img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid #fff;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.2);
            margin-top: -70px;
        }
        .profile-info h2 {
            margin-top: 10px;
            font-size: 1.8em;
            color: #333;
        }
        .profile-info p {
            margin: 5px 0;
            color: #666;
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
        .form-container {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
            max-width: 500px;
            margin: auto;
        }
        .form-container h1 {
            margin-top: 0;
            color: #333;
        }
        .form-container label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }
        .form-container input[type="text"],
        .form-container input[type="date"],
        .form-container input[type="file"],
        .form-container input[id="leaveType"],
        .form-container textarea {
            width: 95%;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 4px;
            border: 1px solid #ddd;
        }
        .form-container input[type="submit"] {
            background-color: #d9a41d;
            color: white;
            width: 99%;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .form-container input[type="submit"]:hover {
            background-color: black;
        }
    </style>
    <script>
        function toggleOtherType(select) {
            var otherLeaveType = document.getElementById("otherLeaveType");
            if (select.value === "other") {
                otherLeaveType.style.display = "block";
            } else {
                otherLeaveType.style.display = "none";
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
        <div class="form-container">
            <h1>Request Leave</h1>
            <p>Leave Balance: <%= employee.getLeaveBalance() %></p>
            <form action="LeaveController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="apply">
                <label for="applyLeaveDate">Apply Leave Date:</label>
                <input type="text" id="applyLeaveDate" name="applyLeaveDate" value="<%= LocalDate.now().toString() %>" readonly><br><br>
                <label for="leaveType">Leave Type:</label>
                <select name="leaveType" id="leaveType" onchange="toggleOtherType(this)">
                    <option value="annual">Annual Leave</option>
                    <option value="sick">Sick Leave</option>
                    <option value="vacation">Vacation Leave</option>
                    <option value="maternity">Maternity Leave</option>
                    <option value="paternity">Paternity Leave</option>
                    <option value="other">Other</option>
                </select>
                <br><br><input type="text" name="otherLeaveType" id="otherLeaveType" style="display:none;">
                <br>
                <label for="startDate">Start Date:</label>
                <input type="date" name="startDate" required>
                <br>
                <label for="endDate">End Date:</label>
                <input type="date" name="endDate" required>
                <br>
                <label for="evidence">Evidence:</label>
                <input type="file" name="evidence">
                <br>
                <label for="reason">Reason:</label>
                <textarea name="reason" required></textarea>
                <br>
                <input type="hidden" name="employeeID" value="<%= session.getAttribute("employeeID") %>">
                <input type="submit" value="Submit">
            </form>
        </div>
    </div>

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
</body>
</html>
