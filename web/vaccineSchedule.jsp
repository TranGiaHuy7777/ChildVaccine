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
            /* Global Styles */
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f4f6f8;
                color: #333;
                margin: 0;
                padding: 0;
            }
            .container {
                max-width: 1200px;
                margin: 40px auto;
                padding: 30px;
                background-color: #fff;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
                animation: fadeIn 0.8s ease-out;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(10px); }
                to { opacity: 1; transform: translateY(0); }
            }
            h1 {
                text-align: center;
                margin-bottom: 20px;
                font-weight: 600;
                color: #2c3e50;
            }
            /* Modern Table Styles */
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                margin: 20px 0;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                overflow: hidden;
            }
            table th, table td {
                padding: 15px 20px;
                text-align: center;
            }
            table th {
                background-color: #0078D7;
                color: #fff;
                font-weight: 500;
            }
            table tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            table td {
                border-bottom: 1px solid #e0e0e0;
                transition: background-color 0.3s ease;
            }
            table tr:hover td {
                background-color: #f1faff;
            }
            table tr:last-child td {
                border-bottom: none;
            }
            .vaccine-name {
                text-align: left;
                font-weight: 500;
            }
            /* Vaccine Link Styles */
            .vaccine-link {
                color: #0078D7;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s ease, transform 0.3s ease;
            }
            .vaccine-link:hover {
                color: #005bb5;
                transform: translateY(-2px);
            }
            /* Modern Button Styles */
            .back-button, .reaction-button {
                display: inline-block;
                padding: 12px 24px;
                text-decoration: none;
                border: none;
                border-radius: 50px;
                font-size: 16px;
                font-weight: 600;
                color: #fff;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
            }
            .back-button {
                background: linear-gradient(135deg, #6dd5ed, #2193b0);
            }
            .reaction-button {
                background: linear-gradient(135deg, #f7971e, #ffd200);
            }
            .back-button:hover, .reaction-button:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
            }
            .back-button:focus, .reaction-button:focus {
                outline: none;
                box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.4);
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
                background-color: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(3px);
            }
            .modal-content {
                background-color: #fff;
                margin: 10% auto;
                padding: 30px;
                border-radius: 10px;
                width: 90%;
                max-width: 500px;
                position: relative;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                animation: fadeInModal 0.5s ease-out;
            }
            @keyframes fadeInModal {
                from { opacity: 0; transform: scale(0.95); }
                to { opacity: 1; transform: scale(1); }
            }
            .close {
                color: #aaa;
                position: absolute;
                top: 10px;
                right: 15px;
                font-size: 24px;
                font-weight: bold;
                cursor: pointer;
                transition: color 0.3s ease;
            }
            .close:hover {
                color: #333;
            }
            .modal-title {
                font-size: 1.6em;
                font-weight: 600;
                margin-bottom: 15px;
                color: #2c3e50;
            }
            .modal-note {
                line-height: 1.6;
                color: #555;
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
                    <p class="hero-subtitle">Child Vaccination Schedule</p>
                </div>
            </div>

            <!-- Bảng Vaccination Schedule -->
            <c:if test="${not empty SCHEDULE_MONTHS and not empty SCHEDULE_MAP}">
                <table>
                    <thead>
                        <tr>
                            <th rowspan="2">Disease Name</th>
                            <!-- Nhóm 0-1 tuổi: gồm 2, 3, 4, 6, 9, 12 tháng -->
                            <th colspan="6">Children from 0 to 1 years old</th>
                            <!-- Nhóm 1-2 tuổi: gồm 15, 18, 24 tháng -->
                            <th colspan="3">Children from 1 to 2 years old</th>
                            <!-- Nhóm trên 3 tuổi: gồm 36 tháng -->
                            <th colspan="1">Children over 3 years old</th>
                        </tr>
                        <tr>
                            <th>2 months</th>
                            <th>3 months</th>
                            <th>4 months</th>
                            <th>6 months</th>
                            <th>9 months</th>
                            <th>12 months</th>
                            <th>15 months</th>
                            <th>18 months</th>
                            <th>24 months</th>
                            <th>36 months</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${SCHEDULE_MAP}">
                            <tr>
                                <td class="vaccine-name">
                                    <!-- Tên Disease được bọc trong link để khi click hiển thị modal -->
                                    <a href="javascript:void(0)"
                                       class="vaccine-link"
                                       title="Click để xem thông tin chi tiết"
                                       data-name="${entry.key.vaccineName}"
                                       data-note="${DISEASE_INFO[entry.key.vaccineID].description}">
                                        <c:out value="${entry.key.vaccineName}" />
                                        <i class="fas fa-info-circle" style="margin-left:5px;"></i>
                                    </a>
                                </td>

                                <c:set var="recommended" value="${entry.value}" />
                                <!-- Hiển thị các mốc tháng -->
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
                <p style="text-align:center; color:red;">No data available to display.</p>
            </c:if>

            <!-- Nút ghi nhận phản ứng -->
            <div style="text-align: center; margin-top: 20px;">
                <a href="recordReaction.jsp" class="reaction-button">
                    <i class="fas fa-exclamation-triangle"></i> Record Reaction
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

                // Lấy tất cả các link disease (vaccine-link)
                const vaccineLinks = document.querySelectorAll('.vaccine-link');
                vaccineLinks.forEach(link => {
                    link.addEventListener('click', event => {
                        event.preventDefault();
                        const diseaseName = link.dataset.name;
                        const description = link.dataset.note;
                        modalVaccineName.textContent = diseaseName;
                        modalNote.textContent = description ? description : "No note available for this disease.";
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
