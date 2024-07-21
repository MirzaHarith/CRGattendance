<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        img {
            width: 400px;
            height: 140px;
        }
        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 400px;
        }
        input[type="text"], input[type="password"] {
            margin: 10px 0;
            padding: 10px;
            width: 100%;
            box-sizing: border-box;
            border-color: #d9a41d;
        }
        .password-container {
            position: relative;
            width: 100%;
            display: flex;
            align-items: center;
        }
        .password-container input {
            flex: 1;
        }
        .password-container .toggle-password {
            position: absolute;
            right: 10px;
            cursor: pointer;
        }
        input[type="submit"] {
            margin-top: 20px;
            padding: 10px 20px;
            width: 80%;
            background-color: #d9a41d;
            color: white;
            border: 3px #d9a41d;
            border-radius: 10px;
        }
        input[type="submit"]:hover {
            background-color: black;
        }
        p{
            font-size: 14px;
            color: gray;
            margin-bottom: 10px;
        }
        h2{
            text-shadow: 0 0 2px #d9a41d, 0 0 3px #d9a41d;
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="img/background.jpg" alt="Header"><br>
        <h2>CRG ATTENDANCE</h2>
        <p>Please login here</p>
        <form action="LoginController" method="post">
            <input type="text" name="employeeID" placeholder="Employee ID" required><br>
            <div class="password-container">
                <input type="password" name="password" id="password" placeholder="Password" required>
                <i class="fas fa-eye toggle-password" onclick="togglePassword()"></i>
            </div>
            <input type="submit" value="Login">
        </form>
    </div>

    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <script>
            alert("<%= error %>");
        </script>
    <%
        }
    %>

    <script>
        function togglePassword() {
            var passwordField = document.getElementById("password");
            var icon = document.querySelector(".toggle-password");
            if (passwordField.type === "password") {
                passwordField.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                passwordField.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }
    </script>
</body>
</html>
