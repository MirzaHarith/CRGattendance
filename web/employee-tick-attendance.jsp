<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Schedule" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Attendance</title>
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
            max-width: 850px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 30px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group select, .form-group button {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            margin-top: 5px;
        }
        .form-group button {
            background-color: #d9a41d;
            border: none;
            color: white;
            cursor: pointer;
        }
        .form-group button:hover {
            opacity: 90%;
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
        <div class="container">
            <h1>Employee Attendance</h1>
            <div id="clock"></div>

            <form action="AttendanceController" method="post">
                <input type="hidden" name="action" value="selectSchedule"/>
                <button type="submit">Select Schedule</button>
            </form>

            <%
                List<Schedule> schedules = (List<Schedule>) request.getAttribute("schedules");
                if (schedules != null && !schedules.isEmpty()) {
            %>
            <form action="AttendanceController" method="post" onsubmit="return confirmAction('clockIn')">
                <div class="form-group">
                    <label for="scheduleID">Select Schedule:</label>
                    <select name="scheduleID" id="scheduleID">
                        <%
                            for (Schedule schedule : schedules) {
                        %>
                        <option value="<%= schedule.getScheduleID() %>"><%= schedule.getDate() + "  (" + schedule.getClockIn() + ")" %> </option>
                        <%
                            }
                        %>
                    </select>
                </div>
                
                <input type="hidden" name="action" value="clockIn"/>
                <button type="submit">Clock In</button>
            </form>
                
            <form action="AttendanceController" method="post" onsubmit="return confirmAction('clockOut')">
                <div class="form-group">
                    <label for="scheduleID">Select Schedule:</label>
                    <select name="scheduleID" id="scheduleID">
                        <%
                            for (Schedule schedule : schedules) {
                        %>
                        <option value="<%= schedule.getScheduleID() %>"><%= schedule.getDate() + "  (" + schedule.getClockOut() + ")" %> </option>
                        <%
                            }
                        %>
                    </select>
                </div>
                <input type="hidden" name="action" value="clockOut"/>
                <button type="submit">Clock Out</button>
            </form>
            
            <form action="AttendanceController" method="post" onsubmit="return confirmAction('absent')">
                <div class="form-group">
                    <label for="scheduleID">Select Schedule:</label>
                    <select name="scheduleID" id="scheduleID">
                        <%
                            for (Schedule schedule : schedules) {
                        %>
                        <option value="<%= schedule.getScheduleID() %>"><%= schedule.getDate()%> </option>
                        <%
                            }
                        %>
                    </select>
                </div>
                <input type="hidden" name="action" value="absent"/>
                <button type="submit">Absent</button>
            </form>
            <%
                }
            %>
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
        
        function updateClock() {
            var now = new Date();
            var hours = now.getHours();
            var minutes = now.getMinutes();
            var seconds = now.getSeconds();
            minutes = minutes < 10 ? '0' + minutes : minutes;
            seconds = seconds < 10 ? '0' + seconds : seconds;
            var timeString = hours + ':' + minutes + ':' + seconds;
            document.getElementById('clock').innerHTML = timeString;
            setTimeout(updateClock, 1000);
        }

        window.onload = function() {
            updateClock();
            displayMessage();
        };

        function confirmAction(action) {
            if (action === 'clockIn') {
                return confirm('Are you sure you want to Clock In?');
            } else if (action === 'clockOut') {
                return confirm('Are you sure you want to Clock Out?');
            } else if (action === 'absent') {
                return confirm('Are you sure you want to mark as Absent?');
            }
            return true;
        }

        function displayMessage() {
            const successMessage = '<%= request.getAttribute("successMessage") %>';
            const errorMessage = '<%= request.getAttribute("errorMessage") %>';
            if (successMessage && successMessage !== 'null') {
                alert(successMessage);
            }
            if (errorMessage && errorMessage !== 'null') {
                alert(errorMessage);
            }
        }
    </script>
</body>
</html>
