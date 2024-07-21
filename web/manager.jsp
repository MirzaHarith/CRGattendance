<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="helper.DashboardHelper" %>
<%@ page import="model.Attendance" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            display: flex;
            margin: 0;
            height: 100vh;
            font-family: Arial, sans-serif;
        }
        .sidebar {
            position: static;
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
            text-decoration: none;
            color: black;
            padding: 20px 0;
            width: 100%;
            text-align: left;
            display: flex;
            align-items: center;
        }
        .sidebar a:hover {
            background-color: #d9a41d;
            opacity: 90%;
        }
        .sidebar a i {
            margin-right: 10px;
            margin-left: 20px;
        }
        .content {
            flex: 1;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .greeting {
            display: flex;
            align-items: center;
            font-size: 1.5em;
        }
        .greeting .emoji {
            margin-left: 10px;
        }
        .stats-container {
            display: flex;
            justify-content: space-between;
            margin: 20px 0;
        }
        .stat-box {
            background-color: white;
            padding: 20px;
            flex: 1;
            margin: 0 10px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .chart-container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 20px 0;
        }
        .attendance-details {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 20px 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
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
        <div class="greeting">
            Hello, <span id="managerName"><%= session.getAttribute("employeeName") %></span> <span class="emoji">&#128075;</span>
        </div>
        <div class="stats-container">
            <div class="stat-box">
                <h3>Total Employees</h3>
                <p id="totalEmployees"><%= DashboardHelper.getTotalEmployees() %></p>
            </div>
            <div class="stat-box">
                <h3>Pending Leave Requests</h3>
                <p id="pendingLeaveRequests"><%= DashboardHelper.getPendingLeaveRequests() %></p>
            </div>
            <div class="stat-box">
                <h3>Today's Attendance</h3>
                <p id="todayAttendance"><%= DashboardHelper.getTodayAttendance() %></p>
            </div>
            <div class="stat-box">
                <h3>Today's Leave</h3>
                <p id="todayLeave"><%= DashboardHelper.getTodayLeave() %></p>
            </div>
        </div>
        <div class="chart-container">
            <h3>Attendance Overview (This Week)</h3>
            <canvas id="attendanceChart"></canvas>
        </div>
        <div class="attendance-details">
            <h3>Detailed Attendance Overview</h3>
            <table>
                <tr>
                    <th>Employee ID</th>
                    <th>Name</th>
                    <th>Check-in Time</th>
                    <th>Status</th>
                </tr>
                <%
                    try {
                        List<Attendance> attendances = DashboardHelper.getDetailedAttendanceOverview(DashboardHelper.getTodayDate());
                        for (Attendance attendance : attendances) {
                %>
                <tr>
                    <td><%= attendance.getEmployeeID() %></td>
                    <td><%= DashboardHelper.getEmployeeNameById(attendance.getEmployeeID()) %></td>
                    <td><%= attendance.getClockIn() %></td>
                    <td><%= attendance.getStatus() %></td>
                </tr>
                <%
                        }
                    } catch (SQLException | ClassNotFoundException e) {
                        e.printStackTrace();
                    }
                %>
            </table>
        </div>
    </div>

    <script>
        // Replace these variables with actual data
        const attendanceData = [8, 10, 7, 9, 6, 11, 10]; // Example data for attendance in a week

        // Attendance Chart
        const ctx = document.getElementById('attendanceChart').getContext('2d');
        const attendanceChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                datasets: [{
                    label: 'Attendance',
                    data: attendanceData,
                    backgroundColor: 'rgba(0, 123, 255, 0.2)',
                    borderColor: 'rgba(0, 123, 255, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>
