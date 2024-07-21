<%@page import="java.util.List"%>
<%@page import="model.Leave"%>
<%@page import="dao.LeaveDAO"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Leaves</title>
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

        button {
            background-color: #d9a41d;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        button:hover {
            background-color: black;
        }

        form {
            display: inline;
        }
    </style>
    <script>
        function viewEvidence(evidenceSrc) {
            const evidenceWindow = window.open("", "Evidence", "width=800,height=600");
            evidenceWindow.document.write("<img src='" + evidenceSrc + "' style='width:100%; height:auto;'>");
        }
    </script>
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
            <h1>Manage Leaves</h1>
            <table>
                <tr>
                    <th>Leave ID</th>
                    <th>Employee ID</th>
                    <th>Apply Date</th>
                    <th>Leave Type</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>
                    <th>Evidence</th>
                    <th>Actions</th>
                </tr>
                <%
                    try {
                        LeaveDAO leaveDAO = new LeaveDAO();
                        List<Leave> leaves = leaveDAO.getAllLeaves();
                        for (Leave leave : leaves) {
                %>
                <tr>
                    <td><%= leave.getLeaveID() %></td>
                    <td><%= leave.getEmployeeID() %></td>
                    <td><%= leave.getApplyLeaveDate() %></td>
                    <td><%= leave.getLeaveType() %></td>
                    <td><%= leave.getStartDate() %></td>
                    <td><%= leave.getEndDate() %></td>
                    <td><%= leave.getStatus() %></td>
                    <td>
                        <%
                            if (leave.getEvidence() != null) {
                                String base64Image = java.util.Base64.getEncoder().encodeToString(leave.getEvidence());
                                String imageSrc = "data:image/jpeg;base64," + base64Image;
                        %>
                        <button onclick="viewEvidence('<%= imageSrc %>')">View Evidence</button>
                        <%
                            }
                        %>
                    </td>
                    <td>
                        <%
                            if (!"approved".equalsIgnoreCase(leave.getStatus()) && !"rejected".equalsIgnoreCase(leave.getStatus())) {
                        %>
                        <form action="LeaveController" method="post">
                            <input type="hidden" name="action" value="approve">
                            <input type="hidden" name="leaveID" value="<%= leave.getLeaveID() %>">
                            <input type="submit" value="Approve">
                        </form>
                        <form action="LeaveController" method="post">
                            <input type="hidden" name="action" value="reject">
                            <input type="hidden" name="leaveID" value="<%= leave.getLeaveID() %>">
                            <input type="submit" value="Reject">
                        </form>
                        <%
                            }
                        %>
                    </td>
                </tr>
                <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                %>
                <tr>
                    <td colspan="9">An error occurred while fetching leave requests.</td>
                </tr>
                <%
                }
                %>
            </table>
        </div>
    </div>
</body>
</html>
