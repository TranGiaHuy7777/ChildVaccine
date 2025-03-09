<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="customer.CustomerDTO"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Hồ Sơ Cá Nhân</title>
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
                background-color: #f0f2f5;
                color: #333;
                line-height: 1.6;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
                    url('https://img.freepik.com/free-photo/doctor-getting-patient-ready-covid-vaccination_23-2149850142.jpg?w=2000');
                background-size: cover;
                background-position: center;
                padding: 100px 0;
                text-align: center;
                color: white;
                margin-bottom: 40px;
                border-radius: 15px;
            }

            .profile-section {
                background: white;
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }

            .profile-header {
                display: flex;
                align-items: center;
                gap: 20px;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 2px solid #e3f2fd;
            }

            .profile-avatar {
                width: 100px;
                height: 100px;
                background: #1e88e5;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 40px;
                color: white;
            }

            .profile-info {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
            }

            .info-card {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                border-left: 4px solid #1e88e5;
            }

            .info-card label {
                display: block;
                color: #666;
                margin-bottom: 5px;
                font-size: 0.9em;
            }

            .info-card .value {
                color: #333;
                font-size: 1.1em;
                font-weight: 500;
            }

            .profile-actions {
                display: flex;
                gap: 15px;
                margin-top: 30px;
            }

            .action-button {
                padding: 12px 25px;
                border-radius: 25px;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .edit-button {
                background: #1e88e5;
                color: white;
            }

            .back-button {
                background: #e0e0e0;
                color: #333;
            }

            .action-button:hover {
                transform: translateY(-2px);
            }

            .toast {
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 25px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                gap: 10px;
                animation: slideIn 0.3s ease;
                z-index: 1000;
            }

            .toast.success {
                background: #4CAF50;
                color: white;
            }

            .toast.error {
                background: #f44336;
                color: white;
            }
        </style>
    </head>
    <body>
        <%
            CustomerDTO user = (CustomerDTO) session.getAttribute("LOGIN_USER");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <div class="container">
            <div class="hero-section">
                <h1>Hồ Sơ Cá Nhân</h1>
                <p>Quản lý thông tin tài khoản của bạn</p>
            </div>

            <div class="profile-section">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>
                        <h2><%= user.getFullName()%></h2>
                        <p><i class="fas fa-shield-alt"></i> <%= user.getRoleID()%></p>
                    </div>
                </div>

                <div class="profile-info">
                    <div class="info-card">
                        <label><i class="fas fa-id-card"></i> User ID</label>
                        <div class="value"><%= user.getUserID()%></div>
                    </div>

                    <div class="info-card">
                        <label><i class="fas fa-user"></i> Họ và tên</label>
                        <div class="value"><%= user.getFullName() != null ? user.getFullName() : "Chưa cập nhật"%></div>
                    </div>

                    <div class="info-card">
                        <label><i class="fas fa-envelope"></i> Email</label>
                        <div class="value"><%= user.getEmail() != null ? user.getEmail() : "Chưa cập nhật"%></div>
                    </div>

                    <div class="info-card">
                        <label><i class="fas fa-phone"></i> Số điện thoại</label>
                        <div class="value"><%= user.getPhone() != null ? user.getPhone() : "Chưa cập nhật"%></div>
                    </div>

                    <div class="info-card">
                        <label><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                        <div class="value"><%= user.getAddress() != null ? user.getAddress() : "Chưa cập nhật"%></div>
                    </div>

                    <div class="info-card">
                        <label><i class="fas fa-user-tag"></i> Vai trò</label>
                        <div class="value"><%= user.getRoleID()%></div>
                    </div>
                </div>

                <div class="profile-actions">
                    <a href="editProfile.jsp" class="action-button edit-button">
                        <i class="fas fa-edit"></i>
                        Chỉnh sửa thông tin
                    </a>
                    <a href="vaccinationSchedule.jsp" class="action-button back-button">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại trang chủ
                    </a>
                </div>
            </div>
        </div>

        <script>
            document.getElementById('editForm').addEventListener('submit', function (e) {
                e.preventDefault();

                const formData = new FormData(this);


                fetch('EditProfileController', {
                    method: 'POST',
                    body: formData
                })
                        .then(response => response.text())
                        .then(data => {
                            if (data === 'success') {
                                const toast = document.createElement('div');
                                toast.className = 'toast success';
                                toast.innerHTML = `
    <i class="fas fa-check-circle"></i>
    <span>Cập nhật thông tin thành công!</span>
`;
                                document.body.appendChild(toast);

                                setTimeout(() => {
                                    window.location.href = 'profile.jsp';
                                }, 2000);
                            } else {
                                throw new Error('Update failed');
                            }
                        })
                        .catch(error => {
                            const toast = document.createElement('div');
                            toast.className = 'toast error';
                            toast.innerHTML = `
<i class="fas fa-exclamation-circle"></i>
<span>Có lỗi xảy ra khi cập nhật!</span>
`;
                            document.body.appendChild(toast);
                        });
            });
        </script>


    </body>



</html>