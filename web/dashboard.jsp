<%-- 
    Document   : dashboard
    Created on : Jan 9, 2025, 6:45:21 AM
    Author     : Windows
--%>

<%@page import="appointment.AppointmentDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard - Appointments</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <h1>Dashboard - Appointment List</h1>
                
        <table border="1">
            <thead>
                <tr>
                    <th>Appointment ID</th>
                    <th>Child ID</th>
                    <th>Center ID</th>
                    <th>Appointment Date</th>
                    <th>Service Type</th>
                    <th>Notification Status</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Lấy danh sách cuộc hẹn từ request attribute
                    List<AppointmentDTO> appointments = (List<AppointmentDTO>) request.getAttribute("appointments");
                    if (appointments != null && !appointments.isEmpty()) {
                        for (AppointmentDTO appointment : appointments) {
                %>
                <tr>
                    <td><%= appointment.getAppointmentID()%></td>
                    <td><%= appointment.getChildID()%></td>
                    <td><%= appointment.getCenterID()%></td>
                    <td><%= appointment.getAppointmentDate()%></td>
                    <td><%= appointment.getServiceType()%></td>
                    <td><%= appointment.getNotificationStatus()%></td>
                    <td><%= appointment.getStatus()%></td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="7">No appointments available.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </body>
</html>
