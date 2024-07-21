<%@page import="model.Employee" %>
<%@page import="dao.EmployeeDAO" %>
<%@page import="java.util.List" %>
<%@page import="java.io.IOException"%>
<%
    String employeeID = (String) session.getAttribute("employeeID");
    String employeePosition = (String) session.getAttribute("employeePosition");

    if (employeeID == null || !"manager".equalsIgnoreCase(employeePosition)) {
        response.sendRedirect("login.jsp");
        return;
    }

    EmployeeDAO employeeDAO = new EmployeeDAO();
    List<Employee> employees = (List<Employee>) request.getAttribute("employees");
    List<String> positions = (List<String>) request.getAttribute("positions");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <title>Employees List</title>
    <style>
        body {
            display: flex;
            margin: 0;
            height: 100vh;
            font-family: Arial, sans-serif;
        }
        .sidebar {
            position: static;
            width: 250px;
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
            margin-left: 10px;
            padding: 20px;
            flex-grow: 1;
        }
        .filter-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .filter-container input[type="submit"] {
            background-color: #d9a41d;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .filter-container input[type="submit"]:hover {
            background-color: black;
        }
        .filter-form {
            display: flex;
            align-items: center;
            flex-grow: 1;
        }
        .filter-form label {
            margin-right: 10px;
        }
        .filter-form select {
            margin-right: 10px;
        }
        .filter-form input[type="submit"] {
            padding: 5px 15px;
            background-color: #d9a41d;
            color: white;
            border: none;
            cursor: pointer;
        }
        .filter-form input[type="submit"]:hover {
            background-color: black;
        }
        .add-employee-btn {
            padding: 8px 15px;
            background-color: #d9a41d;
            color: white;
            border: none;
            cursor: pointer;
            margin-top: 20px;
        }
        .add-employee-btn:hover {
            background-color: black;
        }
        table {
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
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgb(0,0,0);
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 60%;
            max-width: 400px;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover, .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        form label, form input, form select {
            margin-bottom: 5px;
        }
        form input[type="submit"] {
            margin-top: 5px;
            padding: 5px;
            background-color: #d9a41d;
            color: white;
            border: none;
            cursor: pointer;
        }
        form input[type="submit"]:hover {
            background-color: black;
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
        <a href="EmployeeController?action=list"><i class="fas fa-users"></i> Employees List</a>
        <a href="manager-manage-schedule.jsp"><i class="fas fa-calendar-alt"></i> Schedule</a>
        <a href="manager-verify-attendance.jsp"><i class="fas fa-check-square"></i> Attendance</a>
        <a href="manager-manage-leave.jsp"><i class="fas fa-plane"></i> Leave</a>
        <a href="login.jsp"><i class="fas fa-sign-out-alt"></i> Log Out</a>
    </div>

    <div class="content">
        <h2>All Employees</h2>

        <div class="filter-container">
            <form action="EmployeeController" method="get">
                <label for="filterPosition">Filter by Position:</label>
                <select name="filterPosition" id="filterPosition">
                    <option value="">All Positions</option>
                    <%
                        if (positions != null) {
                            for (String position : positions) {
                    %>
                        <option value="<%= position %>"><%= position %></option>
                    <%
                            }
                        }
                    %>
                </select>
                <input type="submit" value="Filter">
            </form>
        
            <button class="add-employee-btn" id="addEmployeeBtn">Add New Employee</button>
        </div>

        <hr>

        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Position</th>
                <th>Profile Image</th>
                <th>Phone Num</th>
                <th>Bank Account</th>
                <th>Account Number</th>
                <th>Gender</th>
                <th>Leave Balance</th>
                <th>Pay Rate</th>
                <th>Actions</th>
            </tr>
            <%
                if (employees != null) {
                    for (Employee employee : employees) {
            %>
            <tr>
                <td><%= employee.getEmployeeID() %></td>
                <td><%= employee.getEmployeeName() %></td>
                <td><%= employee.getEmployeePosition() %></td>
                <td>
                    <%
                        byte[] imageBytes = employee.getEmployeeImage();
                        if (imageBytes != null && imageBytes.length > 0) {
                            String base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
                    %>
                        <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Employee Image" height="50" width="50">
                    <%
                        }
                    %>
                </td>
                <td>0<%= employee.getEmployeePhoneNum() %></td>
                <td><%= employee.getEmployeeBankAccount() %></td>
                <td><%= employee.getEmployeeAccountNum() %></td>
                <td><%= employee.getEmployeeGender() %></td>
                <td><%= employee.getLeaveBalance() %></td>
                <td>RM <%= employee.getPayRate() %> per hour</td>
                <td>
                    <form action="EmployeeController" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID() %>">
                        <input type="submit" value="Delete">
                    </form>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>
    </div>

    <div id="addEmployeeModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Add New Employee</h2>
            <form action="EmployeeController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                
                <label for="employeeID">Employee ID:</label>
                <input type="text" id="employeeID" name="employeeID" required><br>

                <label for="employeeName">Name:</label>
                <input type="text" id="employeeName" name="employeeName" required><br>

                <label for="employeePassword">Password:</label>
                <input type="password" id="employeePassword" name="employeePassword" required><br>

                <label for="employeePosition">Position:</label>
                <select id="employeePosition" name="employeePosition" required>
                    <option value="Manager">Manager</option>
                    <option value="Staff">Staff</option>
                </select><br>

                <label for="employeePhoneNum">Phone Number:</label>
                <input type="text" id="employeePhoneNum" name="employeePhoneNum" required><br>

                <label for="employeeBankAccount">Bank Account:</label>
                <input type="text" id="employeeBankAccount" name="employeeBankAccount" required><br>

                <label for="employeeAccountNum">Account Number:</label>
                <input type="text" id="employeeAccountNum" name="employeeAccountNum" required><br>

                <label for="employeeGender">Gender:</label>
                <select id="employeeGender" name="employeeGender" required>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                </select><br>

                <label for="leaveBalance">Leave Balance:</label>
                <input type="number" id="leaveBalance" name="leaveBalance" required><br>

                <label for="payRate">Pay Rate:</label>
                <input type="number" id="payRate" name="payRate" step="0.01" required><br>

                <label for="employeeImage">Profile Image:</label>
                <input type="file" id="employeeImage" name="employeeImage" accept="image/*"><br>

                <input type="submit" value="Add Employee">
            </form>
        </div>
    </div>

    <script>
        var modal = document.getElementById("addEmployeeModal");
        var btn = document.getElementById("addEmployeeBtn");
        var span = document.getElementsByClassName("close")[0];
        btn.onclick = function() {
            modal.style.display = "block";
        }
        span.onclick = function() {
            modal.style.display = "none";
        }
        window.onclick = function(event) {
            if (event.target === modal) {
                modal.style.display = "none";
            }
        }
    </script>
</body>
</html>
