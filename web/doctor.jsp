<%@page import="vaccine.VaccinationScheduleDTO"%>
<%@page import="java.util.List"%>
<%@page import="vaccine.VaccinationDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Doctor Dashboard</title>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                padding: 8px;
                text-align: left;
                border: 1px solid #ddd;
            }
            th {
                background-color: #4CAF50;
                color: white;
            }
            tr:nth-child(even) {
                background-color: #f2f2f2;
            }
            .status-button {
                padding: 5px 10px;
                margin: 2px;
                cursor: pointer;
                border: none;
                border-radius: 3px;
            }
            .confirm-btn {
                background-color: #4CAF50;
                color: white;
            }
            .cancel-btn {
                background-color: #f44336;
                color: white;
            }
            /* Optional: status classes for rows */
            .completed {
                background-color: #dff0d8;
                color: #3c763d;
            }
            .canceled {
                background-color: #f2dede;
                color: #a94442;
            }
            .pending {
                background-color: #fcf8e3;
                color: #8a6d3b;
            }
        </style>
    </head>
    <body>
        <h1>Danh sách lịch tiêm chủng</h1>

        <c:if test="${not empty requestScope.SUCCESS}">
            <div style="color: green;">
                ${requestScope.SUCCESS}
            </div>
        </c:if>

        <c:if test="${not empty requestScope.ERROR}">
            <div style="color: red;">
                ${requestScope.ERROR}
            </div>
        </c:if>

        <%
            // Get all schedules from the DAO.
            VaccinationDAO dao = new VaccinationDAO();
            List<VaccinationScheduleDTO> scheduleList = dao.getAllSchedules();
            request.setAttribute("SCHEDULE_LIST", scheduleList);
        %>

        <table>
            <thead>
                <tr>
                    <th>Mã lịch hẹn</th>
                    <th>Tên trẻ</th>
                    <th>Trung tâm</th>
                    <th>Ngày</th>
                    <th>Loại dịch vụ</th>
                    <th>Trạng thái</th>
                    <th>Thông báo</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${SCHEDULE_LIST}" var="schedule">
                    <tr class="${schedule.status}">
                        <td>${schedule.scheduleID}</td>
                        <td>${schedule.childName}</td>
                        <!-- Changed from vaccineName to centerName -->
                        <td>${schedule.centerName}</td>
                        <!-- Assuming appointmentDate is used for the date -->
                        <td>${schedule.appointmentDate}</td>
                        <!-- Assuming serviceType holds information you want to show in the "Loại dịch vụ" column -->
                        <td>${schedule.serviceType}</td>
                        <td>${schedule.status}</td>
                        <!-- Use notificationStatus to display any note or extra info -->
                        <td>${schedule.notificationStatus}</td>
                        <td>
                            <c:if test="${schedule.status eq 'Pending'}">
                                <form action="MainController" method="POST" style="display: inline;">
                                    <input type="hidden" name="action" value="UpdateVaccinationStatus"/>
                                    <input type="hidden" name="scheduleID" value="${schedule.scheduleID}"/>
                                    <button type="submit" name="status" value="Completed" class="status-button confirm-btn">
                                        Xác nhận
                                    </button>
                                    <button type="submit" name="status" value="Canceled" class="status-button cancel-btn">
                                        Hủy
                                    </button>
                                </form>

                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div style="margin-top: 20px;">
            <form action="MainController" method="POST">
                <input type="hidden" name="action" value="Logout"/>
                <input type="submit" value="Đăng xuất"/>
            </form>
        </div>
    </body>
</html>
