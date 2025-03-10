<%-- 
    Document   : addChild
    Created on : Feb 6, 2025, 7:51:38 AM
    Author     : Windows
--%>

<%@page import="utils.DBUtils"%>
<%@page import="customer.CustomerDTO"%>
<%@page import="java.sql.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Vaccination Tracking</title>
        <link rel="stylesheet" href="styles.css">
    </head>
    <body>
        <%
            if (session == null || session.getAttribute("LOGIN_USER") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            CustomerDTO user = (CustomerDTO) session.getAttribute("LOGIN_USER");
        %>

        <h1>Welcome, <%= user.getFullName()%></h1>

        <h2>Register Children</h2>
        <form action="AddChildController" method="POST">
            <input type="hidden" name="userID" value="<%= user.getUserID()%>">
            <label for="childName">Child Name:</label>
            <input type="text" name="childName" required>
            <label for="dateOfBirth">Date of Birth:</label>
            <input type="date" name="dateOfBirth" required>
            <label for="gender">Gender:</label>
            <select name="gender" required>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
            </select>
            <button type="submit">Add Child</button>
        </form>
    </body>



