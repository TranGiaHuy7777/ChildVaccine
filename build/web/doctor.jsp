<%@page import="vaccine.VaccinationScheduleDTO"%>
<%@page import="java.util.List"%>
<%@page import="vaccine.VaccinationDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Doctor Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
            }

            body {
                background: #f5f7fb;
                color: #333;
                line-height: 1.6;
                padding: 20px;
            }

            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148981266.jpg?w=2000');
                background-size: cover;
                background-position: center;
                padding: 80px 0;
                text-align: center;
                color: white;
                border-radius: 15px;
                margin-bottom: 30px;
            }

            .hero-title {
                font-size: 2.5em;
                margin-bottom: 20px;
                font-weight: 700;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            }

            .dashboard-container {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            }

            .alert {
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .alert-error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                border-radius: 8px;
                overflow: hidden;
                margin-top: 20px;
            }

            th {
                background: #1e88e5;
                color: white;
                padding: 15px;
                text-align: left;
                font-weight: 500;
            }

            td {
                padding: 12px 15px;
                border-bottom: 1px solid #eee;
            }

            tr:hover {
                background-color: #f8f9fa;
            }

            .status-button {
                padding: 8px 15px;
                border-radius: 5px;
                border: none;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .confirm-btn {
                background-color: #2196f3;
                color: white;
            }

            .confirm-btn:hover {
                background-color: #1976d2;
            }

            .cancel-btn {
                background-color: #f44336;
                color: white;
            }

            .cancel-btn:hover {
                background-color: #d32f2f;
            }

            .status-badge {
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 0.85em;
                font-weight: 500;
            }

            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }

            .status-completed {
                background-color: #d4edda;
                color: #155724;
            }

            .status-canceled {
                background-color: #f8d7da;
                color: #721c24;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
            }
            .navbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px;
                background: rgba(255, 255, 255, 0.95);
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            .navbar-brand {
                font-size: 1.5em;
                font-weight: 600;
                color: #1e88e5;
                text-decoration: none;
            }

            .user-section {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .user-info {
                text-align: right;
            }

            .user-name {
                font-weight: 500;
                color: #333;
            }

            .user-role {
                font-size: 0.8em;
                color: #666;
            }

            .logout-btn {
                padding: 8px 20px;
                background-color: #f44336;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .logout-btn:hover {
                background-color: #d32f2f;
                transform: translateY(-2px);
            }

            .content-wrapper {
                margin-top: 80px; /* Để tránh bị navbar che mất nội dung */
            }

            /* Điều chỉnh hero-section để phù hợp với navbar */
            .hero-section {
                margin-top: 0;
            }

        </style>
    </head>
    <body>
        <nav class="navbar">
            <a href="#" class="navbar-brand">
                <i class="fas fa-hospital"></i>
                Vaccination Schedule
            </a>
            <div class="user-section">
                <div class="user-info">
                    <div class="user-name">Hi, ${sessionScope.LOGIN_USER.fullName}</div>
                    <div class="user-role">Doctor</div>
                </div>
                <a href="MainController?action=Logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i>
                    Logout
                </a>
            </div>
        </nav>



        <div class="content-wrapper">

            <div class="hero-section">
                <h1 class="hero-title">Manage Vaccine Appointment</h1>
            </div>

            <div class="dashboard-container">
                <c:if test="${not empty requestScope.SUCCESS}">
                    <div class="alert alert-success">
                        ${requestScope.SUCCESS}
                    </div>
                </c:if>

                <c:if test="${not empty requestScope.ERROR}">
                    <div class="alert alert-error">
                        ${requestScope.ERROR}
                    </div>
                </c:if>

                <%
                    VaccinationDAO dao = new VaccinationDAO();
                    List<VaccinationScheduleDTO> scheduleList = dao.getAllSchedules();
                    request.setAttribute("SCHEDULE_LIST", scheduleList);
                %>

                <table>
                    <thead>
                        <tr>
                            <th>AppointmentID</th>
                            <th>Children Name</th>
                            <th>Center</th>
                            <th>Date</th>
                            <th>Service Type</th>
                            <th>Status</th>
                            <th>Notification</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${SCHEDULE_LIST}" var="schedule">
                            <tr>
                                <td>${schedule.scheduleID}</td>
                                <td>${schedule.childName}</td>
                                <td>${schedule.centerName}</td>
                                <td>${schedule.appointmentDate}</td>
                                <td>${schedule.serviceType}</td>
                                <td>
                                    <span class="status-badge status-${schedule.status.toLowerCase()}">${schedule.status}</span>
                                </td>
                                <td>${schedule.notificationStatus}</td>
                                <td>
                                    <div class="action-buttons">
                                        <c:if test="${schedule.status eq 'Pending'}">
                                            <form action="MainController" method="POST" style="display: inline;">
                                                <input type="hidden" name="action" value="UpdateVaccinationStatus"/>
                                                <input type="hidden" name="scheduleID" value="${schedule.scheduleID}"/>
                                                <input type="hidden" name="status" value="Completed"/>
                                                <button type="submit" class="status-button confirm-btn">
                                                    <i class="fas fa-check"></i>Confirm
                                                </button>
                                            </form>
                                            <form action="MainController" method="POST" style="display: inline;">
                                                <input type="hidden" name="action" value="UpdateVaccinationStatus"/>
                                                <input type="hidden" name="scheduleID" value="${schedule.scheduleID}"/>
                                                <input type="hidden" name="status" value="Canceled"/>
                                                <button type="submit" class="status-button cancel-btn">
                                                    <i class="fas fa-times"></i> Cancel
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>