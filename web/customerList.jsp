<%-- 
    Document   : customerList.jsp
    Created on : Jan 8, 2025
    Author     : Windows
--%>

<%@page import="customer.CustomerDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="customer.CustomerDTO"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer</title>
        <style>
            body {
                font-family: 'Arial', sans-serif;
                margin: 0;
                padding: 0;
                background: url('images/img8.jpg') no-repeat center center fixed;
                background-size: cover;
                color: #333;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                backdrop-filter: blur(5px); /* To blur the background behind the content */
            }

            .container {
                background: rgba(255, 255, 255, 0.9); /* Background with transparency */
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
                width: 90%;
                max-width: 600px;
                text-align: center;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .container:hover {
                transform: scale(1.05);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            }

            h1 {
                color: #4CAF50;
                font-size: 2.5em;
                margin-bottom: 20px;
            }

            .info {
                font-size: 1.2em;
                line-height: 1.8;
                margin-bottom: 15px;
            }

            .info span {
                font-weight: bold;
                color: #007bff;
            }

            .logout-btn {
                display: inline-block;
                background-color: #ff4747;
                color: #fff;
                padding: 10px 20px;
                border-radius: 5px;
                font-size: 16px;
                text-decoration: none;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.3s ease;
            }

            .logout-btn:hover {
                background-color: #e03e3e;
                transform: scale(1.05);
            }

            .logout-btn:active {
                background-color: #d23232;
            }

            /* Hover effects for the user information */
            .info:hover {
                background-color: #f1f1f1;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                transition: background-color 0.3s ease, box-shadow 0.3s ease;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>User Page</h1>
            
            
            
            <%
                CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
                if(loginUser == null || !"US".equals(loginUser.getRoleID())) {
                    response.sendRedirect("login.jsp");
                    return;
                }
            %>
            <div class="info">
                <p>Customer ID: <span><%= loginUser.getUserID() %></span></p>
                <p>Full Name: <span><%= loginUser.getFullName() %></span></p>
                <p>Role ID: <span><%= loginUser.getRoleID() %></span></p>
                <p>Password: <span>***</span></p>
            </div>
                 <div class="search-form">
            <form action="MainController" method="POST">
                <input type="submit" name="action" value="Logout">
            </form>
        </div>
            <a href="login.jsp" class="logout-btn">Home</a>
        </div>
    </body>
</html>
