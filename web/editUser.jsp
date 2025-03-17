<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit User - Vaccine Management</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
                    url('https://img.freepik.com/free-photo/doctor-getting-patient-ready-covid-vaccination_23-2149850142.jpg?w=2000');
                background-size: cover;
                background-position: center;
                padding: 60px 0;
                text-align: center;
                color: white;
                margin-bottom: 40px;
            }

            .hero-title {
                font-size: 2.5em;
                margin-bottom: 15px;
                font-weight: 700;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            }

            .hero-subtitle {
                font-size: 1.1em;
                opacity: 0.9;
            }

            .edit-container {
                max-width: 600px;
                margin: -60px auto 40px;
                padding: 0 20px;
                position: relative;
                z-index: 1;
            }

            .edit-form {
                background: white;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }

            .form-title {
                text-align: center;
                color: #1e88e5;
                margin-bottom: 30px;
                font-size: 1.8em;
                font-weight: 600;
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
                padding: 12px;
                border: none;
                border-radius: 8px;
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

            .btn-primary:hover {
                background: #1565c0;
            }

            .btn-secondary:hover {
                background: #d5d5d5;
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                color: #1e88e5;
                text-decoration: none;
                font-weight: 500;
                margin-bottom: 20px;
                transition: all 0.3s ease;
            }

            .back-link:hover {
                color: #1565c0;
                transform: translateX(-5px);
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
                animation: slideIn 0.3s ease, fadeOut 0.3s ease 0.7s forwards;
                z-index: 1000;
            }

            .toast.success {
                background: #4CAF50;
                color: white;
                box-shadow: 0 4px 12px rgba(76, 175, 80, 0.2);
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
                }
            }
        </style>

        <%@page import="customer.CustomerDAO"%>
        <%@page import="customer.CustomerDTO"%>
        <%
            String userID = request.getParameter("userID");
            CustomerDTO user = null;
            if (userID != null) {
                CustomerDAO dao = new CustomerDAO();
                user = dao.getUserByID(userID);
            }
        %>


    </head>
    <body>
        <div class="hero-section">
            <h1 class="hero-title">Chỉnh Sửa Thông Tin</h1>
            <p class="hero-subtitle">Cập nhật thông tin người dùng</p>
        </div>

        <div class="edit-container">
            <a href="admin.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i>
                Quay lại trang quản lý
            </a>

            <div class="edit-form">
                <h2 class="form-title">
                    <i class="fas fa-user-edit"></i>
                    Chỉnh sửa thông tin
                </h2>

                <form action="MainController" method="POST" id="updateForm">
                    <input type="hidden" name="action" value="Update">
                    <input type="hidden" name="userID" value="<%= user.getUserID()%>">
                    <div class="form-group">
                        <label for="userID">
                            <i class="fas fa-id-card"></i>
                            User ID
                        </label>
                        <input type="text" id="userID" name="userID" class="form-control" 
                               value="<%= user.getUserID()%>" readonly>
                    </div>

                    <div class="form-group">
                        <label for="fullName">
                            <i class="fas fa-user"></i>
                            Họ và tên
                        </label>
                        <input type="text" id="fullName" name="fullName" class="form-control" 
                               value="<%= user.getFullName()%>" required>
                    </div>

                    <div class="form-group">
                        <label for="roleID">
                            <i class="fas fa-user-tag"></i>
                            Vai trò
                        </label>
                        <input type="text" id="roleID" name="roleID" class="form-control" 
                               value="<%= user.getRoleID()%>" required>
                    </div>

                    <div class="form-group">
                        <label for="email">
                            <i class="fas fa-envelope"></i>Email
                        </label>
                        <input type="email" id="email" name="email" class="form-control" 
                               value="<%= user.getEmail()%>" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">
                            <i class="fas fa-phone"></i>
                            Số điện thoại
                        </label>
                        <input type="tel" id="phone" name="phone" class="form-control" 
                               value="<%= user.getPhone()%>" required>
                    </div>

                    <div class="btn-group">
                        <button type="submit" name="action" value="Update" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Lưu thay đổi
                        </button>
                        <button type="reset" class="btn btn-secondary">
                            <i class="fas fa-undo"></i>
                            Đặt lại
                        </button>
                    </div>
                </form>

            </div>
        </div>
    </body>

    <script>
        document.querySelector('form').addEventListener('submit', async (e) => {
            e.preventDefault();

            try {
                const formData = new FormData(e.target);
                const response = await fetch('MainController', {
                    method: 'POST',
                    body: formData
                });

                if (response.ok) {
                    // Hiển thị thông báo thành công
                    const toast = document.createElement('div');
                    toast.className = 'toast success';
                    toast.innerHTML = `
                    <i class="fas fa-check-circle"></i>
                    <span>Cập nhật thành công!</span>
                `;
                    document.body.appendChild(toast);

                    // Đợi 1 giây rồi chuyển hướng
                    setTimeout(() => {
                        window.location.href = 'admin.jsp';
                    }, 1000);
                }
            } catch (error) {
                console.error('Error:', error);
            }
        });
    </script>

    <script>
        document.getElementById('updateForm').addEventListener('submit', function (e) {
            e.preventDefault();

            const formData = new FormData(this);
            fetch('MainController', {
                method: 'POST',
                body: formData
            })
                    .then(response => {
                        if (response.ok) {
                            // Hiển thị thông báo thành công
                            const toast = document.createElement('div');
                            toast.className = 'toast success';
                            toast.innerHTML = `
                    <i class="fas fa-check-circle"></i>
                    <span>Cập nhật thành công!</span>
                `;
                            document.body.appendChild(toast);

                            // Chuyển về trang admin sau 1 giây
                            setTimeout(() => {
                                window.location.href = 'admin.jsp';
                            }, 1000);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        //Hiển thị thông báo lỗi
                        const toast = document.createElement('div');
                        toast.className = 'toast error';
                        toast.innerHTML = `
                <i class="fas fa-exclamation-circle"></i>
                <span>Cập nhật thất bại!</span>
            `;
                        document.body.appendChild(toast);
                    });
        });
    </script>
</html>