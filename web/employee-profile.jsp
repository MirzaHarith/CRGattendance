<%@page import="model.Employee" %>
<%@page import="dao.EmployeeDAO" %>
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
<!DOCTYPE html>
<html>
<head>
    <title>Employee Profile</title>
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
        .form-container {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            max-width: 800px;
            
        }
        .form-container h2 {
            margin-top: 0;
            font-size: 1.5em;
            color: #333;
        }
        .form-container input[type="text"],
        .form-container input[type="file"],
        .form-container select {
            width: calc(100% - 22px); /* Adjust for padding and border */
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            border-color: #d9a41d;
        }
        .form-container input[type="submit"] {
            background-color: #d9a41d;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            width: 780px;
        }
        .form-container input[type="submit"]:hover {
            background-color: black;
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
        <div class="form-container">
            <h2>Update Profile</h2>
            <form action="EmployeeController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <%
                byte[] imageBytes = employee.getEmployeeImage();
                if (imageBytes != null && imageBytes.length > 0) {
                    String base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
                %>   
                    <center><img src="data:image/jpeg;base64,<%= base64Image %>" alt="Employee Image" width="200" height="200"></center>
                <%
                }
                %>
                <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID() %>">
                Name: <input type="text" name="employeeName" value="<%= employee.getEmployeeName() %>"><br>
                Password: <input type="text" name="employeePassword" value="<%= employee.getEmployeePassword() %>"><br>
                Position: <input type="text" name="employeePosition" value="<%= employee.getEmployeePosition() %>"><br>
                Profile Image: <input type="file" name="employeeImage"><br>
                Phone Number: <input type="text" name="employeePhoneNum" value="0<%= employee.getEmployeePhoneNum() %>"><br>
                Bank Account: 
                <select name="employeeBankAccount" id="employeeBankAccount" onchange="showOtherBankField(this)">
                    <option value="CIMB" <%= "CIMB".equals(employee.getEmployeeBankAccount()) ? "selected" : "" %>>CIMB</option>
                    <option value="Maybank" <%= "Maybank".equals(employee.getEmployeeBankAccount()) ? "selected" : "" %>>Maybank</option>
                    <option value="Public Bank" <%= "Public Bank".equals(employee.getEmployeeBankAccount()) ? "selected" : "" %>>Public Bank</option>
                    <option value="Other" <%= !("CIMB".equals(employee.getEmployeeBankAccount()) || "Maybank".equals(employee.getEmployeeBankAccount()) || "Public Bank".equals(employee.getEmployeeBankAccount())) ? "selected" : "" %>>Other</option>
                </select>
                <br>
                <div id="otherBankField" style="display: <%= !("CIMB".equals(employee.getEmployeeBankAccount()) || "Maybank".equals(employee.getEmployeeBankAccount()) || "Public Bank".equals(employee.getEmployeeBankAccount())) ? "block" : "none" %>;">
                    Other Bank: <input type="text" name="otherBankAccount" value="<%= !("CIMB".equals(employee.getEmployeeBankAccount()) || "Maybank".equals(employee.getEmployeeBankAccount()) || "Public Bank".equals(employee.getEmployeeBankAccount())) ? employee.getEmployeeBankAccount() : "" %>"><br>
                </div>
                Account Number: <input type="text" name="employeeAccountNum" value="<%= employee.getEmployeeAccountNum() %>"><br>
                Gender: 
                <select name="employeeGender">
                    <option value="Male" <%= "Male".equals(employee.getEmployeeGender()) ? "selected" : "" %>>Male</option>
                    <option value="Female" <%= "Female".equals(employee.getEmployeeGender()) ? "selected" : "" %>>Female</option>
                </select>
                <br>
                Leave Balance: <%= employee.getLeaveBalance() %><br>
                Pay Rate: <%= employee.getPayRate() %><br>
                <input type="submit" value="Update Profile">
            </form>
        </div>
    </div>

    <script>
        function toggleDropdown(id) {
            var dropdown = document.getElementById(id);
            dropdown.classList.toggle("show");
        }

        function showOtherBankField(select) {
            var otherBankField = document.getElementById("otherBankField");
            if (select.value === "Other") {
                otherBankField.style.display = "block";
            } else {
                otherBankField.style.display = "none";
            }
        }
    </script>
</body>
</html>
