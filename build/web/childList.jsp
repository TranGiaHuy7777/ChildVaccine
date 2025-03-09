<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Child Registration</title>
        <style>
            .container {
                width: 80%;
                margin: 0 auto;
                padding: 20px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
            }
            .form-group input, .form-group select {
                width: 100%;
                padding: 8px;
                margin-bottom: 10px;
            }
            .success-message {
                background-color: #dff0d8;
                color: #3c763d;
                padding: 10px;
                margin-bottom: 20px;
                border: 1px solid #d6e9c6;
                border-radius: 4px;
            }
            .error-message {
                background-color: #f2dede;
                color: #a94442;
                padding: 10px;
                margin-bottom: 20px;
                border: 1px solid #ebccd1;
                border-radius: 4px;
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
            .btn {
                padding: 10px 20px;
                background-color: #4CAF50;
                color: white;
                text-decoration: none;
                border: none;
                cursor: pointer;
                border-radius: 4px;
            }
            .btn:hover {
                background-color: #45a049;
            }
            .back-button {
                margin-bottom: 20px;
                display: inline-block;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="vaccinationSchedule.jsp" class="btn back-button">Back to Schedule</a>
            
            <h1>Child Registration for Vaccination</h1>
            
            <c:if test="${not empty SUCCESS_MESSAGE}">
                <div class="success-message">${SUCCESS_MESSAGE}</div>
            </c:if>
            <c:if test="${not empty ERROR_MESSAGE}">
                <div class="error-message">${ERROR_MESSAGE}</div>
            </c:if>
            
            <div class="registration-form">
                <h2>Add New Child</h2>
                <form action="MainController" method="POST">
                    <div class="form-group">
                        <label>Full Name:</label>
                        <input type="text" name="fullName" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Date of Birth:</label>
                        <input type="date" name="dateOfBirth" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Gender:</label>
                        <select name="gender" required>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                        </select>
                    </div>
                    
                    <input type="hidden" name="action" value="AddChild">
                    <c:if test="${not empty param.vaccineId}">
                        <input type="hidden" name="vaccineId" value="${param.vaccineId}">
                    </c:if>
                    <button type="submit" class="btn">Add Child</button>
                </form>
            </div>

            <c:if test="${not empty childList}">
                <h2>Your Children</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Full Name</th>
                            <th>Date of Birth</th>
                            <th>Gender</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${childList}" var="child">
                            <tr>
                                <td>${child.fullName}</td>
                                <td>${child.dateOfBirth}</td>
                                <td>${child.gender}</td>
                                <td>
                                    <c:if test="${not empty param.vaccineId}">
                                        <a href="MainController?action=BookVaccine&childID=${child.childID}&vaccineId=${param.vaccineId}" class="btn">
                                            Book Vaccine
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </body>
</html>