<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vaccination Schedule</title>
    <!-- Link Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Link Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Global styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            color: #333;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 20px;
        }
        h1 {
            text-align: center;
            margin-bottom: 20px;
        }
        /* Table Styles */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        table th, table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        table th {
            background-color: #0078D7;
            color: #fff;
        }
        .vaccine-name {
            text-align: left;
        }
        /* Vaccine link styles */
        .vaccine-link {
            color: #0078D7;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        .vaccine-link:hover {
            text-decoration: underline;
        }
        /* Back Button */
        .back-button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #1e88e5;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 20px;
            transition: background-color 0.3s ease;
        }
        .back-button:hover {
            background-color: #1565c0;
        }
        /* Reaction Button */
        .reaction-button {
            display: inline-block;
            padding: 12px 24px;
            background-color: #ff5722;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            transition: background-color 0.3s ease, transform 0.3s ease;
            margin-top: 20px;
        }
        .reaction-button:hover {
            background-color: #e64a19;
            transform: translateY(-3px);
        }
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fff;
            margin: 10% auto;
            padding: 20px;
            border-radius: 8px;
            width: 50%;
            max-width: 600px;
            position: relative;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            margin-top: -8px;
        }
        .close:hover {
            color: #000;
        }
        .modal-title {
            font-size: 1.4em;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .modal-note {
            line-height: 1.5;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Back Button -->
    <a href="vaccinationSchedule.jsp" class="back-button">
        <i class="fas fa-arrow-left"></i> Back to Schedule
    </a>
    
    <!-- Hero Section -->
    <div class="hero-section">
        <div class="hero-content">
            <h1 class="hero-title">Vaccination Schedule</h1>
            <p class="hero-subtitle">Lịch Tiêm Chủng Cho Trẻ</p>
        </div>
    </div>
    
    <!-- Bảng Vaccine Schedule -->
    <c:if test="${not empty SCHEDULE_MONTHS and not empty SCHEDULE_MAP}">
        <table>
            <thead>
                <tr>
                    <th rowspan="2">Vaccine</th>
                    <!-- Nhóm 0-1 tuổi: gồm 2, 3, 4, 6, 9, 12 tháng -->
                    <th colspan="6">Trẻ từ 0 đến 1 tuổi</th>
                    <!-- Nhóm 1-2 tuổi: gồm 15, 18, 24 tháng -->
                    <th colspan="3">Trẻ từ 1 đến 2 tuổi</th>
                    <!-- Nhóm trên 3 tuổi: gồm 36 tháng -->
                    <th colspan="1">Trẻ trên 3 tuổi</th>
                </tr>
                <tr>
                    <th>2 tháng</th>
                    <th>3 tháng</th>
                    <th>4 tháng</th>
                    <th>6 tháng</th>
                    <th>9 tháng</th>
                    <th>12 tháng</th>
                    <th>15 tháng</th>
                    <th>18 tháng</th>
                    <th>24 tháng</th>
                    <th>36 tháng</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="entry" items="${SCHEDULE_MAP}">
                    <tr>
                        <td class="vaccine-name">
                            <!-- Tên vaccine được bọc trong link để khi click hiển thị modal -->
                            <a href="javascript:void(0)"
                               class="vaccine-link"
                               data-name="${entry.key.vaccineName}"
                               data-note="${VACCINE_NOTES[entry.key.vaccineID]}">
                                <c:out value="${entry.key.vaccineName}" />
                            </a>
                        </td>
                        <c:set var="recommended" value="${entry.value}" />
                        <!-- Cột 2 tháng -->
                        <td>
                            <c:set var="found2" value="false" />
                            <c:forEach var="m" items="${recommended}">
                                <c:if test="${m == 2}">
                                    <c:set var="found2" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${found2}">X</c:when>
                                <c:otherwise>&nbsp;</c:otherwise>
                            </c:choose>
                        </td>
                        <!-- Cột 3 tháng -->
                        <td>
                            <c:set var="found3" value="false" />
                            <c:forEach var="m" items="${recommended}">
                                <c:if test="${m == 3}">
                                    <c:set var="found3" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${found3}">X</c:when>
                                <c:otherwise>&nbsp;</c:otherwise>
                            </c:choose>
                        </td>
                        <!-- Cột 4 tháng -->
                        <td>
                            <c:set var="found4" value="false" />
                            <c:forEach var="m" items="${recommended}">
                                <c:if test="${m == 4}">
                                    <c:set var="found4" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${found4}">X</c:when>
                                <c:otherwise>&nbsp;</c:otherwise>
                            </c:choose>
                        </td>
                        <!-- Cột 6 tháng -->
                        <td>
                            <c:set var="found6" value="false" />
                            <c:forEach var="m" items="${recommended}">
                                <c:if test="${m == 6}">
                                    <c:set var="found6" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${found6}">X</c:when>
                                <c:otherwise>&nbsp;</c:otherwise>
                            </c:choose>
                        </td>
                        <!-- Cột 9 tháng -->
                        <td>
                            <c:set var="found9" value="false" />
                            <c:forEach var="m" items="${recommended}">
                                <c:if test="${m == 9}">
                                    <c:set var="found9" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${found9}">X</c:when>
                                <c:otherwise>&nbsp;</c:otherwise>
                            </c:choose>
                        </td>
                        <!-- Cột 12 tháng -->
                        <td>
                            <c:set var="found12" value="false" />
                            <c:forEach var="m" items="${recommended}">
                                <c:if test="${m == 12}">
                                    <c:set var="found12" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${found12}">X</c:when>
                                <c:otherwise>&nbsp;</c:otherwise>
                            </c:choose>
                        </td>
                        <!-- Cột 15 tháng -->
                        <td>
                            <c:set var="found15" value="false" />
                            <c:forEach var="m" items="${recommended}">
                                <c:if test="${m == 15}">
                                    <c:set var="found15" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${found15}">X</c:when>
                                <c:otherwise>&nbsp;</c:otherwise>
                            </c:choose>
                        </td>
                        <!-- Cột 18 tháng -->
                        <td>
                            <c:set var="found18" value="false" />
                            <c:forEach var="m" items="${recommended}">
                                <c:if test="${m == 18}">
                                    <c:set var="found18" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${found18}">X</c:when>
                                <c:otherwise>&nbsp;</c:otherwise>
                            </c:choose>
                        </td>
                        <!-- Cột 24 tháng -->
                        <td>
                            <c:set var="found24" value="false" />
                            <c:forEach var="m" items="${recommended}">
                                <c:if test="${m == 24}">
                                    <c:set var="found24" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${found24}">X</c:when>
                                <c:otherwise>&nbsp;</c:otherwise>
                            </c:choose>
                        </td>
                        <!-- Cột 36 tháng -->
                        <td>
                            <c:set var="found36" value="false" />
                            <c:forEach var="m" items="${recommended}">
                                <c:if test="${m == 36}">
                                    <c:set var="found36" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${found36}">X</c:when>
                                <c:otherwise>&nbsp;</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    
    <c:if test="${empty SCHEDULE_MONTHS or empty SCHEDULE_MAP}">
        <p style="text-align:center; color:red;">Không có dữ liệu để hiển thị.</p>
    </c:if>
    
    <!-- Nút ghi nhận phản ứng -->
    <div style="text-align: center; margin-top: 20px;">
        <a href="recordReaction.jsp" class="reaction-button">
            <i class="fas fa-exclamation-triangle"></i> Ghi nhận phản ứng
        </a>
    </div>
    
</div>

<!-- Modal hiển thị ghi chú -->
<div id="noteModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <div class="modal-title" id="modalVaccineName"></div>
        <div class="modal-note" id="modalNote"></div>
    </div>
</div>

<!-- JavaScript xử lý modal -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const modal = document.getElementById('noteModal');
        const closeBtn = modal.querySelector('.close');
        const modalVaccineName = document.getElementById('modalVaccineName');
        const modalNote = document.getElementById('modalNote');

        // Lấy tất cả các link vaccine
        const vaccineLinks = document.querySelectorAll('.vaccine-link');
        vaccineLinks.forEach(link => {
            link.addEventListener('click', event => {
                event.preventDefault();
                const vaccineName = link.dataset.name;
                const note = link.dataset.note;
                modalVaccineName.textContent = vaccineName;
                modalNote.textContent = note ? note : "Chưa có ghi chú cho vaccine này.";
                modal.style.display = 'block';
            });
        });
        closeBtn.addEventListener('click', () => {
            modal.style.display = 'none';
        });
        window.addEventListener('click', event => {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });
    });
</script>
<style>
    .reaction-button {
        display: inline-block;
        padding: 12px 24px;
        background-color: #ff5722;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-size: 16px;
        font-weight: 600;
        transition: background-color 0.3s ease, transform 0.3s ease;
    }
    .reaction-button:hover {
        background-color: #e64a19;
        transform: translateY(-3px);
    }
</style>
</body>
</html>
