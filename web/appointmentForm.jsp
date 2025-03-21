<%@page import="disease.DiseaseDTO"%>
<%@page import="java.util.List"%>
<%@page import="disease.DiseaseDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="child.ChildDTO" %>
<%@ page import="vaccine.VaccineDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Schedule a Vaccination</title>
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            body {
                background-color: #f0f2f5;
                color: #333;
                line-height: 1.6;
            }
            .container {
                max-width: 800px;
                margin: 40px auto;
                padding: 20px;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .appointment-card {
                background: white;
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .header {
                text-align: center;
                margin-bottom: 30px;
                padding: 20px;
                background: linear-gradient(135deg, #1e88e5, #1565c0);
                color: white;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .child-info {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
                border-left: 4px solid #1e88e5;
            }
            .child-info h3 {
                color: #1e88e5;
                margin-bottom: 15px;
            }
            .info-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 15px;
            }
            .info-item {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .info-item i {
                color: #1e88e5;
                font-size: 1.2em;
            }
            .form-group {
                margin-bottom: 25px;
            }
            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: 500;
            }
            .form-control {
                width: 100%;
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 16px;
                transition: all 0.3s ease;
                background: #f8f9fa;
            }
            .form-control:focus {
                border-color: #1e88e5;
                outline: none;
                box-shadow: 0 0 0 3px rgba(30, 136, 229, 0.1);
            }
            .submit-btn {
                width: 100%;
                padding: 15px;
                background: linear-gradient(90deg, #1e88e5, #1565c0);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }
            .submit-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(30, 136, 229, 0.3);
            }
            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                color: #1e88e5;
                text-decoration: none;
                margin-bottom: 20px;
                font-weight: 500;
                transition: all 0.3s ease;
            }
            .back-link:hover {
                color: #1565c0;
            }
            @media (max-width: 768px) {
                .container {
                    padding: 10px;
                }
                .info-grid {
                    grid-template-columns: 1fr;
                }
            }
            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880385.jpg?w=1380&t=st=1709825937~exp=1709826537~hmac=4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a');
                background-size: cover;
                background-position: center;
                padding: 100px 0;
                text-align: center;
                color: white;
                margin-bottom: 40px;
                border-radius: 15px;
            }
            .hero-content {
                max-width: 800px;
                margin: 0 auto;
                padding: 0 20px;
            }
            .hero-title {
                font-size: 3em;
                margin-bottom: 20px;
                font-weight: 700;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            }
            .hero-subtitle {
                font-size: 1.2em;
                margin-bottom: 30px;
                text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
            }
            .price-btn {
                display: inline-block;
                padding: 12px 25px;
                background: linear-gradient(135deg, #1e88e5, #1565c0);
                color: white;
                border: none;
                border-radius: 30px;
                font-size: 16px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                margin-top: 20px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .price-btn:hover {
                background: linear-gradient(135deg, #1565c0, #1e88e5);
                transform: translateY(-2px);
                box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
            }
        </style>
    </head>
    <body>
        <%-- Lấy thông tin trẻ từ session --%>
        <%
            ChildDTO registeredChild = (ChildDTO) session.getAttribute("REGISTERED_CHILD");
            String childName = (registeredChild != null) ? registeredChild.getChildName() : "Unknown";
            String childGender = (registeredChild != null) ? registeredChild.getGender() : "Unknown";
            int childID = (registeredChild != null) ? registeredChild.getChildID() : 0;
            String childDOB = "Unknown";
            if (registeredChild != null && registeredChild.getDateOfBirth() != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                childDOB = sdf.format(registeredChild.getDateOfBirth());
            }
        %>
        <div class="hero-section">
            <div class="hero-content">
                <h1 class="hero-title">Vaccination Appointment</h1>
                <p class="hero-subtitle">Safe - Convenient - Professional</p>
            </div>
        </div>
        <div class="container">
            <a href="vaccinationSchedule.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i> Back
            </a>
            <div class="appointment-card">
                <div class="header">
                    <h1><i class="fas fa-calendar-plus"></i> Vaccination Appointment</h1>
                    <p>Fill in the information to schedule a vaccination appointment for your child</p>
                </div>
                <a href="pricePackpage.jsp" class="price-btn">Click to see the price of the service</a>
                <div class="child-info">
                    <h3><i class="fas fa-baby"></i> Child Information</h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <i class="fas fa-user"></i>
                            <input type="hidden" name="childID" value="<%= childID%>">
                            <div>
                                <strong>Child ID:</strong>
                                <div><%= childID%></div>
                            </div>
                            <div>
                                <strong>Child Name:</strong>
                                <div><%= childName%></div>
                            </div>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-birthday-cake"></i>
                            <div>
                                <strong>Date of Birth:</strong>
                                <div><%= childDOB%></div>
                            </div>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-venus-mars"></i>
                            <div>
                                <strong>Gender:</strong>
                                <div><%= childGender%></div>
                            </div>
                        </div>
                    </div>
                </div>
                <form id="appointmentForm" action="AppointmentController" method="POST">
                    <input type="hidden" name="childID" value="<%= childID%>">
                    <%-- Lấy thông tin vaccine đã được chọn từ session --%>
                    <%
                        VaccineDTO selectedVaccine = (VaccineDTO) session.getAttribute("selectedVaccine");
                        int vaccineID = (selectedVaccine != null) ? selectedVaccine.getVaccineID() : 0;
                    %>
                    <input type="hidden" name="vaccineID" value="<%= vaccineID%>">
                    <div class="form-group">
                        <%
                            DiseaseDAO diseaseDao = new DiseaseDAO();
                            List<DiseaseDTO> diseaseList = diseaseDao.getAllDiseaseNames();
                            request.setAttribute("diseaseList", diseaseList);

                        %>
                        <div class="form-group">
                            <label for="diseaseID">
                                <i class="fas fa-notes-medical"></i> Select Disease 
                                <span title="Chọn bệnh liên quan đến tiêm chủng. Thông tin chi tiết về bệnh sẽ được sử dụng để lưu vào hệ thống" style="cursor: help;">&#9432;</span>
                            </label>
                            <select id="diseaseID" name="diseaseID" class="form-control" required>
                                <option value="">-- Select Disease --</option>
                                <c:forEach var="disease" items="${diseaseList}">
                                    <option value="${disease.diseaseID}">${disease.diseaseName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="diseaseNote">
                                <i class="fas fa-info-circle"></i> Additional Disease Information (Optional)
                            </label>
                            <textarea id="diseaseNote" name="diseaseNote" class="form-control" rows="4" placeholder="Nhập thông tin bổ sung, ghi chú, triệu chứng, hoặc các chỉ dẫn từ bác sĩ nếu có"></textarea>
                        </div>






                        <div class="form-group">
                            <label for="centerID"><i class="fas fa-hospital"></i> Vaccination Center</label>
                            <select id="centerID" name="centerID" class="form-control" required>
                                <option value="">-- Select Center --</option>
                                <option value="1">VNVC Hanoi</option>
                                <option value="2">VNVC Ho Chi Minh</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="appointmentDate"><i class="fas fa-calendar-alt"></i> Appointment Date</label>
                            <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="timeSlot"><i class="fas fa-clock"></i> Time Slot</label>
                            <select id="timeSlot" name="timeSlot" class="form-control" required>
                                <option value="">-- Select Time Slot --</option>
                                <option value="morning">Morning (8:00 - 11:30)</option>
                                <option value="afternoon">Afternoon (13:30 - 16:30)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="serviceType"><i class="fas fa-syringe"></i> Service Type</label>
                            <select id="serviceType" name="serviceType" class="form-control" required>
                                <option value="">-- Select Service Type --</option>
                                <option value="Single Vaccination (Tiêm lẻ)">Single Vaccination (Tiêm lẻ)</option>
                                <option value="Full Package (Trọn Gói)">Full Vaccination Package (Trọn Gói)</option>
                                <option value="Personalized Package (Cá nhân hóa)">Personalized Vaccination Package (Cá nhân hóa)</option>
                            </select>
                        </div>
                        <button type="submit" class="submit-btn">
                            <i class="fas fa-check-circle"></i> Confirm Appointment
                        </button>
                </form>
                <script>
                    // Set minimum date to today
                    const today = new Date().toISOString().split('T')[0];
                    document.getElementById('appointmentDate').setAttribute('min', today);
                </script>
            </div>
        </div>
    </body>
</html>
