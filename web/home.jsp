<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRG Employee Attendance System</title>
     <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Roboto', Arial, sans-serif;
            background-color: #f8f8f8;
        }
        .header {
            text-align: center;
            padding: 50px;
            color: white;
            position: relative;
            overflow: hidden;
            height: 400px; /* Set a fixed height for the header */
        }
        .header .background {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 76%;
            z-index: -1;
            background-size: cover;
            background-position: center;
            transition: background-image 1s ease-in-out;
        }
        .header .title {
            font-size: 4em;
            margin-bottom: 20px;
            color: white;
            text-shadow: 2px 2px 4px rgba(255, 223, 0, 0.8); /* Yellow shadow */
        }
        .header .subtitle {
            font-size: 1.5em;
            margin-bottom: 50px;
            color: white;
            text-shadow: 2px 2px 4px rgba(255, 223, 0, 0.8); /* Yellow shadow */
        }
        .header .login-button {
            padding: 15px 30px;
            font-size: 1em;
            color: white;
            background-color: #d9a41d;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }
        .header .login-button:hover {
            background-color: black;
        }
        .content {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            padding: 20px;
            margin-top: -120px;
        }
        .content .section {
            flex: 1;
            min-width: 300px;
            margin: 10px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .content .section img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .content .section .text {
            padding: 20px;
            text-align: center;
        }
        .content .section .text h2 {
            margin: 0;
            font-size: 1.5em;
            margin-bottom: 10px;
        }
        .content .section .text p {
            margin: 0;
            font-size: 1em;
            color: #555;
        }
        @keyframes slideshow {
            0% { opacity: 0; }
            20% { opacity: 1; }
            80% { opacity: 1; }
            100% { opacity: 0; }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="background" id="background"></div>
        <div class="title">Welcome to CRG Employee Attendance System</div>
        <div class="subtitle">Manage your attendance easily and efficiently</div>
        <a href="login.jsp" class="login-button">Login Here</a>
    </div>
    <div class="content">
        <div class="section">
            <img src="img/team.jpg" alt="Track Attendance">
            <div class="text">
                <h2>Track Attendance</h2>
                <p>Keep track of employee attendance with ease.</p>
            </div>
        </div>
        <div class="section">
            <img src="img/report.jpg" alt="Detailed Reports">
            <div class="text">
                <h2>Detailed Reports</h2>
                <p>Generate detailed reports on employee attendance.</p>
            </div>
        </div>
        <div class="section">
            <img src="img/user.jpg" alt="User-Friendly Interface">
            <div class="text">
                <h2>User-Friendly Interface</h2>
                <p>Experience a simple and intuitive user interface.</p>
            </div>
        </div>
    </div>
    <script>
        // Array of background image URLs
        var images = ['img/back.jpg', 'img/back2.jpeg', 'img/back3.jpg'];
        var currentIndex = 0;
        var background = document.querySelector('.background');

        // Function to change background image
        function changeBackground() {
            background.style.backgroundImage = 'url(' + images[currentIndex] + ')';
            currentIndex = (currentIndex + 1) % images.length; // Loop through images
        }

        // Initial call
        changeBackground();

        // Change background image every 2 seconds
        setInterval(changeBackground, 3000);
    </script>
</body>
</html>
