<%@ page import="vaccine.VaccineDTO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="child.ChildDAO, child.ChildDTO" %>
<%@ page import="appointment.AppointmentDAO, appointment.AppointmentDTO" %>
<%@ page import="customer.CustomerDTO" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Child Profile Registration</title>
        <!-- Link Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <!-- Link Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            /* Background tổng thể */
            body {
                background: linear-gradient(135deg, #e0f7fa, #ffffff);
                color: #333;
                line-height: 1.6;
                min-height: 100vh;
                margin: 0;
                padding: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .container {
                max-width: 800px;
                margin: 40px auto;
                padding: 20px;
            }
            /* Nút Back to Home */
            .btn-back {
                display: inline-flex;
                align-items: center;
                gap: 10px;
                padding: 12px 20px;
                background-color: #1e88e5;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                font-size: 16px;
                font-weight: 600;
                margin-bottom: 20px;
                transition: background-color 0.3s ease;
            }
            .btn-back:hover {
                background-color: #1565c0;
            }
            .hero-section {
                background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880385.jpg');
                background-size: cover;
                background-position: center;
                padding: 100px 0;
                text-align: center;
                color: white;
                margin-bottom: 40px;
                border-radius: 15px;
            }
            .hero-content {
                max-width: 600px;
                margin: 0 auto;
                padding: 0 20px;
            }
            .hero-title {
                font-size: 2.5em;
                margin-bottom: 20px;
                font-weight: 700;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            }
            .hero-subtitle {
                font-size: 1.2em;
                margin-bottom: 30px;
                text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
            }
            .registration-card {
                background: white;
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                position: relative;
                overflow: hidden;
                margin-top: 40px;
            }
            .registration-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(90deg, #1e88e5, #1565c0);
            }
            .form-header {
                text-align: center;
                margin-bottom: 30px;
            }
            .form-header h2 {
                color: #1e88e5;
                font-size: 24px;
                margin-bottom: 10px;
            }
            .form-group {
                margin-bottom: 20px;
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
            }
            .form-control:focus {
                border-color: #1e88e5;
                outline: none;
                box-shadow: 0 0 0 3px rgba(30,136,229,0.1);
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
                box-shadow: 0 5px 15px rgba(30,136,229,0.3);
            }
            /* CSS cho ô vuông hiển thị hồ sơ trẻ */
            .appointments-grid {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                justify-content: center;
                margin-bottom: 30px;
            }
            .profile-tile {
                width: 280px;
                height: 280px;
                border: none;
                border-radius: 16px;
                background: linear-gradient(135deg, #e3f2fd, #bbdefb);
                border: 2px solid transparent;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                cursor: pointer;
                transition: transform 0.3s ease, box-shadow 0.3s ease, background 0.3s ease, border-color 0.3s ease;
                text-align: center;
                padding: 20px;
            }
            .profile-tile:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0,0,0,0.2);
                background: linear-gradient(135deg, #bbdefb, #90caf9);
                border-color: #1e88e5;
            }
            .profile-tile div {
                margin: 10px 0;
                font-size: 1.2em;
                color: #0d47a1;
            }
            .profile-tile strong {
                color: #1565c0;
            }
            /* Thêm style cho thông báo lỗi */
            .error-message {
                color: #dc3545;
                font-size: 0.875rem;
                margin-top: 5px;
                display: block;
                transition: all 0.3s ease;
            }

            .form-control.error {
                border-color: #dc3545;
                box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
            }

            .form-control.error:focus {
                border-color: #dc3545;
                box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
            }

            /* Animation cho thông báo lỗi */
            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
                20%, 40%, 60%, 80% { transform: translateX(5px); }
            }

            .error-shake {
                animation: shake 0.8s ease;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Nút Back to Home -->
            <a href="vaccinationSchedule.jsp" class="btn-back">
                <i class="fas fa-arrow-left"></i> Back to Home
            </a>
            
            <div class="hero-section">
                <div class="hero-content">
                    <h1 class="hero-title">Child Profile Registration</h1>
                    <p class="hero-subtitle">The first step to protecting your child's health</p>
                </div>
            </div>
            
            <!-- Phần hiển thị nhiều hồ sơ trẻ đã đăng ký -->
            <div class="registered-appointments">
                <h2>Chọn hồ sơ trẻ đã đăng ký</h2>
                <%
                    // Lấy đối tượng CustomerDTO từ session và debug
                    CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
                    out.println("<!-- DEBUG: loginUser = " + loginUser + " -->");
                    String userID = null;
                    if (loginUser != null) {
                        userID = loginUser.getUserID();
                        out.println("<!-- DEBUG: userID = " + userID + " -->");
                    }
                    
                    // Lấy danh sách lịch hẹn từ AppointmentDAO
                    List<AppointmentDTO> appointmentList = new ArrayList<>();
                    if(userID != null) {
                        try {
                            AppointmentDAO appointmentDAO = new AppointmentDAO();
                            appointmentList = appointmentDAO.getAppointmentsByUserID(userID);
                            out.println("<!-- DEBUG: appointmentList.size() = " + appointmentList.size() + " -->");
                        } catch(Exception e) {
                            e.printStackTrace();
                        }
                    }
                    
                    // Lấy danh sách hồ sơ trẻ từ ChildDAO nếu danh sách lịch hẹn rỗng hoặc để bổ sung
                    List<child.ChildDTO> childList = new ArrayList<>();
                    if(userID != null) {
                        try {
                            child.ChildDAO childDAO = new child.ChildDAO();
                            childList = childDAO.getAllChildrenByUserID(userID);
                            out.println("<!-- DEBUG: childList.size() = " + childList.size() + " -->");
                        } catch(Exception e) {
                            e.printStackTrace();
                        }
                    }
                    
                    // Tạo map theo childID từ appointmentList
                    Map<Integer, AppointmentDTO> appointmentMap = new HashMap<>();
                    for(AppointmentDTO app : appointmentList) {
                        appointmentMap.put(app.getChildID(), app);
                    }
                    
                    // Tạo danh sách kết hợp: nếu có lịch hẹn, sử dụng dữ liệu của lịch hẹn; nếu không, sử dụng hồ sơ trẻ từ ChildDAO.
                    List<AppointmentDTO> combinedList = new ArrayList<>();
                    // Duyệt qua danh sách hồ sơ trẻ (childList) để tạo đối tượng AppointmentDTO cho từng hồ sơ
                    for(child.ChildDTO c : childList) {
                        if(appointmentMap.containsKey(c.getChildID())) {
                            combinedList.add(appointmentMap.get(c.getChildID()));
                        } else {
                            AppointmentDTO app = new AppointmentDTO();
                            app.setAppointmentID(0); // Không có lịch hẹn cụ thể
                            app.setChildID(c.getChildID());
                            app.setChildName(c.getChildName());
                            app.setDateOfBirth(c.getDateOfBirth());
                            app.setGender(c.getGender());
                            combinedList.add(app);
                        }
                    }
                    
                    if(combinedList.isEmpty()) {
                %>
                    <p>Không có hồ sơ nào.</p>
                <%
                    } else {
                %>
                    <div class="appointments-grid">
                    <%
                        for(AppointmentDTO appointment : combinedList) {
                    %>
                        <form action="SelectAppointmentController" method="post">
                            <input type="hidden" name="appointmentID" value="<%= appointment.getAppointmentID() %>" />
                            <input type="hidden" name="childID" value="<%= appointment.getChildID() %>" />
                            <button type="submit" class="profile-tile">
                                <div><strong>Child Name:</strong> <%= appointment.getChildName() %></div>
                                <div><strong>Date of Birth:</strong> <%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(appointment.getDateOfBirth()) %></div>
                                <div><strong>Gender:</strong> <%= appointment.getGender() %></div>
                            </button>
                        </form>
                    <%
                        }
                    %>
                    </div>
                <%
                    }
                %>
            </div>
            
            <!-- Form đăng ký hồ sơ trẻ mới -->
            <div class="registration-card">
                <div class="form-header">
                    <h2>Child Information</h2>
                    <p>Please fill in all the required details below</p>
                </div>
                <form id="childForm" action="AddChildController" method="post">
                  <div class="form-group">
                        <label for="userID">User ID</label>
                        <input type="text" id="userID" name="userID" class="form-control"
                               value="<%= userID%>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="childName">Child Name:</label>
                        <input type="text" id="childName" name="childName" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="dateOfBirth">Date of Birth:</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control" required 
                               max="<%= java.time.LocalDate.now() %>"
                               onchange="validateDate(this)">
                        <span id="dateError" class="error-message"></span>
                    </div>
                    <div class="form-group">
                        <label for="gender">Gender:</label>
                        <select id="gender" name="gender" class="form-control" required>
                            <option value="">-- Select Gender --</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                        </select>
                    </div>
                    <button type="submit" id="submitBtn" class="submit-btn">Register</button>
                </form>
            </div>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const form = document.getElementById("childForm");
                const submitBtn = document.getElementById("submitBtn");
                form.addEventListener("submit", function () {
                    submitBtn.disabled = true;
                });
            });

            function validateDate(input) {
                const selectedDate = new Date(input.value);
                const today = new Date();
                const errorElement = document.getElementById('dateError');
                
                if (selectedDate > today) {
                    input.classList.add('error');
                    errorElement.textContent = "Ngày sinh không tồn tại!";
                    errorElement.classList.add('error-shake');
                    input.value = '';
                    
                    // Xóa class error-shake sau khi animation kết thúc
                    setTimeout(() => {
                        errorElement.classList.remove('error-shake');
                    }, 800);
                } else {
                    input.classList.remove('error');
                    errorElement.textContent = "";
                }
            }
        </script>
    </body>
</html>
