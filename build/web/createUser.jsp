<%-- 
    Document   : user
    Created on : Jan 7, 2025, 1:45:18 PM
    Author     : Windows
--%>

<%@page import="customer.UserError"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create User Page</title>
        <style>
            body {
                font-family: 'Arial', sans-serif;
                margin: 0;
                padding: 0;
                color: #333;
                background: url('images/img1.jpg') no-repeat center center fixed;
                background-size: cover;
            }
            .overlay {
                background-color: rgba(255, 255, 255, 0.8);
                width: 100%;
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }
            .content {
                display: flex;
                gap: 20px;
                align-items: flex-start;
                max-width: 1000px;
                width: 100%;
            }
            .container {
                max-width: 400px;
                width: 100%;
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .container:hover {
                transform: scale(1.05);
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
            }
            h1 {
                text-align: center;
                color: #444;
                font-size: 2em;
                margin-bottom: 20px;
            }
            form {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }
            input[type="text"],
            input[type="password"] {
                width: 100%;
                padding: 10px;
                font-size: 16px;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-sizing: border-box;
                outline: none;
                transition: border 0.3s ease;
            }
            input[type="text"]:focus,
            input[type="password"]:focus {
                border-color: #007bff;
            }
            input[type="submit"],
            input[type="reset"] {
                padding: 10px 15px;
                font-size: 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            input[type="submit"] {
                background-color: #28a745;
                color: #fff;
            }
            input[type="submit"]:hover {
                background-color: #218838;
            }
            input[type="reset"] {
                background-color: #dc3545;
                color: #fff;
            }
            input[type="reset"]:hover {
                background-color: #c82333;
            }
            .error-message {
                color: #e74c3c;
                font-size: 14px;
                margin-top: -10px;
            }
            .logout-btn {
                display: block;
                text-align: center;
                margin: 20px auto 0;
                background-color: #007bff;
                color: #fff;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                text-decoration: none;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.3s ease;
            }
            .logout-btn:hover {
                background-color: #0056b3;
                transform: scale(1.05);
            }
            .image-gallery {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
                flex: 1;
            }
            .image-gallery img {
                width: 100%;
                height: auto;
                object-fit: cover;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .image-gallery img:hover {
                transform: scale(1.05);
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
            }
            a {
                display: inline-block;
                text-decoration: none;
                color: #007bff;
                font-weight: bold;
                padding: 10px 20px;
                border: 2px solid #007bff;
                border-radius: 5px;
                background-color: #fff;
                font-size: 16px;
                transition: background-color 0.3s ease, color 0.3s ease, transform 0.3s ease, border-color 0.3s ease;
            }
            a:hover {
                background-color: #007bff;
                color: #fff;
                transform: scale(1.1);
                border-color: #0056b3;
            }

        </style>
    </head>
    <body>
        <div class="overlay">
            <div class="content">
                <!-- Form Container -->
                <div class="container">
                    <h1>Create Your Account</h1>
                    <%
                        UserError userError = (UserError) request.getAttribute("USER_ERROR");
                        if (userError == null) {
                            userError = new UserError();
                        }
                    %>
                    <form action="MainController" method="POST">
                        <div>
                            <label for="userID">User ID</label>
                            <input type="text" name="userID" id="userID" required />
                            <div class="error-message"><%= userError.getUserIDError()%></div>
                        </div>
                        <div>
                            <label for="fullName">Full Name</label>
                            <input type="text" name="fullName" id="fullName" required />
                            <div class="error-message"><%= userError.getFullNameError()%></div>
                        </div>
                        <div>
                            <label for="roleID">Role ID</label>
                            <input type="text" name="roleID" id="roleID" value="US" readonly />
                        </div>
                        <div>
                            <label for="password">Password</label>
                            <input type="password" name="password" id="password" required />
                        </div>
                        <div>
                            <label for="confirm">Confirm Password</label>
                            <input type="password" name="confirm" id="confirm" required />
                            <div class="error-message"><%= userError.getConfirmError()%></div>
                        </div>
                        <div>
                            <label for="email">Email</label>
                            <input type="email" name="email" id="email" required />
                        </div>
                        <div>
                            <label for="address">Address</label>
                            <input type="text" name="address" id="address" required />
                        </div>
                        <div>
                            <label for="phone">Phone</label>
                            <input type="text" name="phone" id="phone" required />
                        </div>
                        <input type="submit" name="action" value="Create" />
                        <input type="reset" value="Reset"   />
                        <div class="error-message"><%= userError.getError()%></div>
                    </form>
                    <form action="MainController" method="POST">
                        <input type="submit" name="action" value="Logout" class="logout-btn" />
                    </form>
                </div>

                <a href="login.jsp">Home</a>
            </div>
        </div>
    </body>
</html>
