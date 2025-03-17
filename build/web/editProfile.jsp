<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="customer.CustomerDTO"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Chỉnh Sửa Thông Tin</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            /* Copy base styles from profile.jsp */
            * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
            body { background-color: #f0f2f5; color: #333; line-height: 1.6; }
            .container { max-width: 1200px; margin: 0 auto; padding: 20px; }

            /* Hero section matching home page */
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

            /* Form specific styles */
            .edit-form {
                background: white;
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }

            .form-group {
                margin-bottom: 25px;
            }

            .form-group label {
                display: block;
                margin-bottom: 10px;
                color: #333;
                font-weight: 500;
            }

            .form-control {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 1em;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                border-color: #1e88e5;
                outline: none;
                box-shadow: 0 0 0 3px rgba(30,136,229,0.1);
            }

            .btn-group {
                display: flex;
                gap: 15px;
                margin-top: 30px;
            }

            .btn {
                flex: 1;
                padding: 12px 20px;
                border: none;
                border-radius: 25px;
                font-size: 1em;
                font-weight: 500;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                transition: all 0.3s ease;
            }

            .btn-primary {
                background: #1e88e5;
                color: white;
            }

            .btn-secondary {
                background: #e0e0e0;
                color: #333;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }

            .toast {
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 25px;
                background: #4CAF50;
                color: white;
                border-radius: 8px;
                display: flex;
                align-items: center;
                gap: 10px;
                animation: slideIn 0.3s ease, fadeOut 0.3s ease 2s forwards;
                z-index: 1000;
            }

            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }

            @keyframes fadeOut {
                to { opacity: 0; visibility: hidden; }
            }

            .notification {
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 20px;
                border-radius: 10px;
                background: #ffffff;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
                display: flex;
                align-items: center;
                gap: 15px;
                z-index: 1000;
                animation: slideIn 0.5s ease;
                max-width: 350px;
            }

            .notification.success {
                border-left: 5px solid #4CAF50;
            }

            .notification i {
                font-size: 24px;
                color: #4CAF50;
            }

            .notification-content {
                flex: 1;
            }.notification-title {
                font-weight: 600;
                color: #333;
                margin-bottom: 5px;
            }

            .notification-message {
                color: #666;
                font-size: 0.9em;
            }

            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }

            @keyframes fadeOut {
                to {
                    opacity: 0;
                    transform: translateX(100%);
                }
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
                <h1>Chỉnh Sửa Thông Tin</h1>
                <p>Cập nhật thông tin tài khoản của bạn</p>
            </div>

            <div class="edit-form">
                <form id="editForm" action="EditProfileController" method="POST">
                    <input type="hidden" name="userID" value="<%= user.getUserID()%>">

                    <div class="form-group">
                        <label><i class="fas fa-user"></i> Họ và tên</label>
                        <input type="text" class="form-control" name="fullName" value="<%= user.getFullName()%>" required>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" class="form-control" name="email" value="<%= user.getEmail() != null ? user.getEmail() : ""%>">
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-phone"></i> Số điện thoại</label>
                        <input type="tel" class="form-control" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : ""%>">
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                        <input type="text" class="form-control" name="address" value="<%= user.getAddress() != null ? user.getAddress() : ""%>">
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Lưu thay đổi
                        </button>
                        <a href="profile.jsp" class="btn btn-secondary">
                            <i class="fas fa-times"></i>
                            Hủy
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <script>

            document.getElementById('editForm').addEventListener('submit', function (e) {
                e.preventDefault();
                const formData = new FormData(this);
                const searchParams = new URLSearchParams();

                for (const [key, value] of formData) {
                    searchParams.append(key, value);
                }

                fetch('EditProfileController', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: searchParams.toString()
                })
                        .then(response => response.text())
                        .then(data => {
                            if (data.trim() === 'success') {
                                // Create notification
                                const notification = document.createElement('div');
                                notification.className = 'notification success';
                                notification.innerHTML = `
                <i class="fas fa-check-circle"></i>
                <div class="notification-content">
                    <div class="notification-title">Cập nhật thành công!</div>
                    <div class="notification-message">Thông tin của bạn đã được lưu</div>
                </div>
            `;
                                document.body.appendChild(notification);

                                // Redirect after delay
                                setTimeout(() => {
                                    notification.style.animation = 'fadeOut 0.5s ease forwards';
                                    setTimeout(() => {
                                        window.location.href = 'profile.jsp';
                                    }, 500);
                                }, 2000);
                            } else {
                                throw new Error(data || 'Cập nhật thất bại');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            const notification = document.createElement('div');
                            notification.className = 'notification error';
                            notification.innerHTML = `
            <i class="fas fa-exclamation-circle" style="color: #f44336;"></i>
            <div class="notification-content">
                <div class="notification-title">Cập nhật thất bại</div>
                <div class="notification-message">${error.message}</div>
            </div>
        `;
                            document.body.appendChild(notification);
                            setTimeout(() => {
                                notification.style.animation = 'fadeOut 0.5s ease forwards';
                                setTimeout(() => notification.remove(), 500);
                            }, 3000);
                        });
            });
        </script>
    </body>
</html>