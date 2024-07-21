<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Attendance" %>
<%@ page import="dao.AttendanceDAO" %>
<%
    String attendanceID = request.getParameter("attendanceID");
    AttendanceDAO attendanceDAO = new AttendanceDAO();
    Attendance attendance = null;
    try {
        attendance = attendanceDAO.getAttendanceById(attendanceID);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Attendance Reason</title>
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
            max-width: 500px;
            width: 100%;
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 10px;
            position: relative;
            top: 40px;
        }

        .form-container h2 {
            margin-top: 0;
        }

        .form-container label {
            display: block;
            margin-bottom: 8px;
        }

        .form-container input[type="text"], .form-container input[type="submit"] {
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

        .form-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .form-row label {
            width: 30%;
        }

        .form-row span {
            width: 65%;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            text-decoration: none;
            color: #d9a41d;
            font-size: 13px;
        }

        .back-link:hover {
            color: #b87a16;
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
            <a href="manager-verify-attendance.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Attendance</a>
            <h2>Update Attendance Reason</h2>
            <form action="AttendanceController" method="post">
                <input type="hidden" name="action" value="updateReason">
                <input type="hidden" name="attendanceID" value="<%= attendance.getAttendanceID() %>">
                <div class="form-row">
                    <label>Employee ID:</label> <span><%= attendance.getEmployeeID() %></span>
                </div>
                <div class="form-row">
                    <label>Date:</label> <span><%= attendance.getDate() %></span>
                </div>
                <div class="form-row">
                    <label>Status:</label> <span><%= attendance.getStatus() %></span>
                </div>
                <label for="reason">Reason:</label>
                <input type="text" name="reason" id="reason" value="<%= attendance.getReason() %>">
                <input type="submit" value="Update Reason">
            </form>
        </div>
    </div>
</body>
</html>
