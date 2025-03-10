<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login - Vaccine Management System</title>
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
                min-height: 100vh;
            }

            .hero-section {
                background: linear-gradient(135deg, rgba(41,128,185,0.95), rgba(52,152,219,0.8)),
                    url('https://img.freepik.com/free-photo/doctor-getting-patient-ready-covid-vaccination_23-2149850142.jpg?w=2000');
                background-size: cover;
                background-position: center;
                padding: 150px 0;
                text-align: center;
                color: white;
                position: relative;
                overflow: hidden;
                animation: fadeIn 1s ease-in;
            }

            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            .hero-section::before {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 120px;
                background: linear-gradient(to bottom, transparent, #f0f2f5);
            }

            .hero-content {
                max-width: 900px;
                margin: 0 auto;
                padding: 0 20px;
                position: relative;
                z-index: 1;
            }

            .hero-title {
                font-size: 4em;
                margin-bottom: 25px;
                font-weight: 700;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                letter-spacing: -1px;
                animation: slideDown 0.8s ease-out;
            }

            @keyframes slideDown {
                from { transform: translateY(-50px); opacity: 0; }
                to { transform: translateY(0); opacity: 1; }
            }

            .hero-subtitle {
                font-size: 1.4em;
                margin-bottom: 35px;
                text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
                font-weight: 300;
                line-height: 1.8;
            }

            .login-container {
                max-width: 1200px;
                margin: -100px auto 40px;
                padding: 0 20px;
                position: relative;
                z-index: 2;
            }

            .login-box {
                background: white;
                padding: 60px;
                border-radius: 25px;
                box-shadow: 0 15px 40px rgba(0,0,0,0.12);
                width: 100%;
                max-width: 550px;
                margin: 0 auto;
                position: relative;
                overflow: hidden;
                transform: translateY(0);
                transition: transform 0.3s ease;
            }

            .login-box:hover {
                transform: translateY(-5px);
            }

            .login-box::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 5px;
                background: linear-gradient(90deg, #2980b9, #3498db);
            }

            .form-title {
                text-align: center;
                color: #2980b9;
                margin-bottom: 45px;
                font-size: 2.4em;
                font-weight: 600;
                position: relative;
            }

            .form-title i {
                font-size: 0.9em;
                margin-right: 12px;
                background: linear-gradient(45deg, #2980b9, #3498db);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .form-group {
                margin-bottom: 30px;
                position: relative;
            }

            .form-group label {
                display: block;
                margin-bottom: 10px;
                color: #2c3e50;
                font-weight: 500;
                font-size: 1.1em;
                transition: color 0.3s ease;
            }

            .form-group input {
                width: 100%;
                padding: 15px;
                border: 2px solid #e0e0e0;
                border-radius: 12px;
                font-size: 1.1em;
                transition: all 0.3s ease;
            }

            .form-group input:focus {
                border-color: #3498db;
                box-shadow: 0 0 0 3px rgba(52,152,219,0.1);
                outline: none;
            }

            .login-button {
                width: 100%;
                padding: 15px;
                background: linear-gradient(45deg, #2980b9, #3498db);
                border: none;
                border-radius: 12px;
                color: white;
                font-size: 1.2em;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .login-button:hover {
                background: linear-gradient(45deg, #3498db, #2980b9);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(52,152,219,0.3);
            }

            .forgot-password {
                text-align: center;
                margin-top: 20px;
            }

            .forgot-password a {
                color: #3498db;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s ease;
            }

            .forgot-password a:hover {
                color: #2980b9;
            }

            @media (max-width: 768px) {
                .hero-title {
                    font-size: 3em;
                }

                .login-box {
                    padding: 40px;
                }

                .form-title {
                    font-size: 2em;
                }
            }
            /* Style cho tabs */
            .login-tabs {
                display: flex;
                justify-content: center;
                gap: 20px;
                margin-bottom: 40px;
                position: relative;
                border-bottom: 2px solid #eef2f7;
                padding-bottom: 15px;
            }

            .tab-btn {
                position: relative;
                background: none;
                border: none;
                padding: 12px 30px;
                font-size: 1.1em;
                color: #718096;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 12px;
                font-weight: 500;
                overflow: hidden;
            }

            .tab-btn i {
                font-size: 1.2em;
                transition: transform 0.3s ease;
            }

            .tab-btn:hover {
                color: #3498db;
            }

            .tab-btn:hover i {
                transform: scale(1.1);
            }

            .tab-btn.active {
                color: #2980b9;
                font-weight: 600;
            }

            /* Hiệu ứng gạch chân cho tab active */
            .tab-btn::after {
                content: '';
                position: absolute;
                bottom: -15px;
                left: 0;
                width: 100%;
                height: 3px;
                background: linear-gradient(90deg, #2980b9, #3498db);
                transform: scaleX(0);
                transition: transform 0.3s ease;
                border-radius: 2px;
            }

            .tab-btn.active::after {
                transform: scaleX(1);
            }

            /* Animation cho nội dung tab */
            .tab-content {
                display: none;
                animation: fadeIn 0.4s ease forwards;
            }

            .tab-content.active {
                display: block;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Hiệu ứng ripple khi click */
            .tab-btn .ripple {
                position: absolute;
                background: rgba(52, 152, 219, 0.2);
                border-radius: 50%;
                transform: scale(0);
                animation: ripple 0.6s linear;
                pointer-events: none;
            }

            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }

            /* Responsive design */
            @media (max-width: 768px) {
                .tab-btn {
                    padding: 10px 20px;
                }

                .tab-btn span {
                    font-size: 0.9em;
                }
            }

            @media (max-width: 480px) {
                .login-tabs {
                    gap: 10px;
                }

                .tab-btn {
                    padding: 8px 15px;
                }

                .tab-btn span {
                    display: none;
                }

                .tab-btn i {
                    font-size: 1.4em;
                }
            }
            .login-tabs {
                display: flex;
                justify-content: center;
                margin-bottom: 30px;
                border-bottom: 2px solid #eef2f7;
                position: relative;
            }

            .tab-btn {
                padding: 15px 30px;
                background: none;
                border: none;
                font-size: 1.1em;
                color: #718096;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 10px;
                position: relative;
            }

            .tab-btn i {
                font-size: 1.2em;
            }

            .tab-btn::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 100%;
                height: 3px;
                background: linear-gradient(90deg, #2980b9, #3498db);
                transform: scaleX(0);
                transition: transform 0.3s ease;
            }

            .tab-btn.active {
                color: #2980b9;
                font-weight: 600;
            }

            .tab-btn.active::after {
                transform: scaleX(1);
            }

            .tab-btn:hover {
                color: #3498db;
            }

            .tab-content {
                display: none;
                opacity: 0;
                transform: translateY(10px);
                transition: all 0.3s ease;
            }

            .tab-content.active {
                display: block;
                opacity: 1;
                transform: translateY(0);
            }

            @media (max-width: 480px) {
                .tab-btn {
                    padding: 12px 20px;
                }

                .tab-btn span {
                    display: none;
                }

                .tab-btn i {
                    font-size: 1.4em;
                }
            }


            .login-tabs {
                display: flex;
                justify-content: center;
                gap: 20px;
                margin-bottom: 30px;
                padding: 10px;
                background: #f8fafc;
                border-radius: 15px;
            }

            .tablinks {
                position: relative;
                padding: 12px 25px;
                background: transparent;
                border: none;
                font-size: 1.1em;
                color: #64748b;
                cursor: pointer;
                transition: all 0.3s ease;
                border-radius: 10px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .tablinks i {
                font-size: 1.2em;
            }

            .tablinks:hover {
                color: #3498db;
                background: rgba(52, 152, 219, 0.1);
            }

            .tablinks.active {
                color: #2980b9;
                background: white;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            /* Style cho content tabs */
            .tabcontent {
                display: none;
                animation: fadeIn 0.4s ease;
                padding: 20px;
                background: white;
                border-radius: 10px;
            }

            /* Cải thiện form đăng nhập */
            .tabcontent input[type="text"],
            .tabcontent input[type="password"] {
                width: 100%;
                padding: 12px;
                margin: 8px 0;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 1em;
            }

            .tabcontent input[type="submit"],
            .tabcontent input[type="reset"] {
                padding: 10px 20px;
                margin: 10px 5px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
            }

            .tabcontent input[type="submit"] {
                background: #3498db;
                color: white;
            }

            .tabcontent input[type="reset"] {
                background: #e0e0e0;
                color: #333;
            }

            .tabcontent h3 {
                color: #2980b9;
                margin-bottom: 20px;
                font-size: 1.5em;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Thêm CSS cho checkbox Remember Me */
            .remember-me {
                display: flex;
                align-items: center;
                margin: 15px 0;
            }

            .remember-me input[type="checkbox"] {
                margin-right: 10px;
                width: 18px;
                height: 18px;
                cursor: pointer;
            }

            .remember-me label {
                margin: 0;
                cursor: pointer;
                color: #666;
                font-size: 0.9em;
            }

            .forgot-password {
                text-align: right;
                margin-bottom: 20px;
            }

            .forgot-password a {
                color: #2980b9;
                text-decoration: none;
                font-size: 0.9em;
            }

            .forgot-password a:hover {
                text-decoration: underline;
            }

            /* Thêm style cho phần divider và register section */
            .divider {
                text-align: center;
                margin: 30px 0;
                position: relative;
            }

            .divider::before,
            .divider::after {
                content: '';
                position: absolute;
                top: 50%;
                width: 45%;
                height: 1px;
                background: #e0e0e0;
            }

            .divider::before {
                left: 0;
            }

            .divider::after {
                right: 0;
            }

            .divider span {
                background: white;
                padding: 0 15px;
                color: #718096;
                font-size: 0.9em;
            }

            .register-section {
                text-align: center;
                margin-top: 30px;
                padding: 20px;
                background: #f8fafc;
                border-radius: 12px;
                transition: all 0.3s ease;
            }

            .register-button {
                display: inline-flex;
                align-items: center;
                gap: 10px;
                background: linear-gradient(45deg, #2ecc71, #27ae60);
                color: white;
                padding: 15px 30px;
                border-radius: 10px;
                text-decoration: none;
                font-weight: 500;
                font-size: 1.1em;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                box-shadow: 0 4px 15px rgba(46, 204, 113, 0.2);
            }

            .register-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(46, 204, 113, 0.3);
                background: linear-gradient(45deg, #27ae60, #2ecc71);
            }

            .register-button i {
                font-size: 1.2em;
            }

            .register-text {
                margin-bottom: 15px;
                color: #4a5568;
                font-size: 1.1em;
            }

        </style>
    </head>
    <body>

        <%
            String savedCustomerUsername = "";
            String savedCustomerPassword = "";
            String savedDoctorUsername = "";
            String savedDoctorPassword = "";
            String savedAdminUsername = "";
            String savedAdminPassword = "";

            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    switch (cookie.getName()) {
                        case "customer_username":
                            savedCustomerUsername = cookie.getValue();
                            break;
                        case "customer_password":
                            savedCustomerPassword = cookie.getValue();
                            break;
                        case "doctor_username":
                            savedDoctorUsername = cookie.getValue();
                            break;
                        case "doctor_password":
                            savedDoctorPassword = cookie.getValue();
                            break;
                        case "admin_username":
                            savedAdminUsername = cookie.getValue();
                            break;
                        case "admin_password":
                            savedAdminPassword = cookie.getValue();
                            break;
                    }
                }
            }
        %>
        <% String previousUrl = request.getParameter("previousUrl");
            if (previousUrl == null) {
                previousUrl = "vaccinationSchedule.jsp";
            }%>

        <div class="hero-section">
            <div class="hero-content">
                <h1 class="hero-title">Welcome Back!</h1>
                <p class="hero-subtitle">Sign in to continue your baby's health journey</p>
            </div>
        </div>


        <div class="login-container">
            <div class="login-box">
                <h2 class="form-title">Login</h2>



                <!-- Tab links -->
                <div class="login-tabs">
                    <button class="tablinks" onclick="openLoginType(event, 'CustomerLogin')">Customer Login</button>
                    <button class="tablinks" onclick="openLoginType(event, 'DoctorLogin')">Doctor Login</button>
                    <button class="tablinks" onclick="openLoginType(event, 'AdminLogin')">Admin Login</button>

                </div>



                <!-- Customer Login Form -->
                <div id="CustomerLogin" class="tabcontent">
                    <h3>Customer Login</h3>
                    <form action="MainController" method="POST">
                        User ID: <input type="text" name="userID" value="<%= savedCustomerUsername%>"/><br/>
                        Password: <input type="password" name="password" value="<%= savedCustomerPassword%>"/><br/>
                        <div class="remember-me">
                            <label>
                                <input type="checkbox" name="rememberMe" id="customerRememberMe" 
                                       <%= (savedCustomerUsername != "" && savedCustomerPassword != "") ? "checked" : ""%>>
                                <span>Ghi nhớ đăng nhập</span>
                            </label>
                        </div>
                        <input type="hidden" name="loginType" value="customer"/>
                        <input type="hidden" name="action" value="Login"/>
                        <input type="submit" value="Login"/>
                        <input type="reset" value="Reset"/>
                    </form>
                </div>

                <!-- Doctor Login Form -->
                <div id="DoctorLogin" class="tabcontent">
                    <h3>Doctor Login</h3>
                    <form action="MainController" method="POST">
                        Doctor ID: <input type="text" name="doctorID" value="<%= savedDoctorUsername%>"/><br/>
                        Password: <input type="password" name="password" value="<%= savedDoctorPassword%>"/><br/>
                        <div class="remember-me">
                            <label>
                                <input type="checkbox" name="remember" id="doctorRememberMe"
                                       <%= (savedDoctorUsername != "" && savedDoctorPassword != "") ? "checked" : ""%>>
                                <span>Ghi nhớ đăng nhập</span>
                            </label>
                        </div>
                        <input type="hidden" name="loginType" value="doctor"/>
                        <input type="hidden" name="action" value="DoctorLogin"/>
                        <input type="submit" value="Login"/>
                        <input type="reset" value="Reset"/>
                    </form>
                </div>


                <!-- Admin Login Form -->
                <div id="AdminLogin" class="tabcontent">
                    <h3>Admin Login</h3>
                    <form action="MainController" method="POST">
                        AdminID: <input type="text" name="userID" value="<%= savedAdminUsername%>"/><br/>
                        Password: <input type="password" name="password" value="<%= savedAdminPassword%>"/><br/>
                        <div class="remember-me">
                            <label>
                                <input type="checkbox" name="rememberMe" id="adminRememberMe"
                                       <%= (savedAdminUsername != "" && savedAdminPassword != "") ? "checked" : ""%>>
                                <span>Ghi nhớ đăng nhập</span>
                            </label>
                        </div>
                        <input type="hidden" name="loginType" value="admin"/>
                        <input type="hidden" name="action" value="Login"/>
                        <input type="submit" value="Login"/>
                        <input type="reset" value="Reset"/>
                    </form>
                </div>








                <form action="MainController" method="POST">
                    <input type="hidden" name="previousUrl" value="<%= previousUrl%>">



                    <% String error = (String) request.getAttribute("ERROR");
                        if (error != null && !error.isEmpty()) {%>
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= error%>
                    </div>
                    <% }%>



                    <div class="divider">
                        <span>OR</span>
                    </div>

                    <div class="register-section">
                        <p class="register-text">Chưa có tài khoản?</p>
                        <a href="createUser.jsp" class="register-button">
                            <i class="fas fa-user-plus"></i>
                            Đăng ký ngay
                        </a>
                    </div>
                </form>
            </div>

        </div>


        <script>
            function openLoginType(evt, loginType) {
                var i, tabcontent, tablinks;
                tabcontent = document.getElementsByClassName("tabcontent");
                for (i = 0; i < tabcontent.length; i++) {
                    tabcontent[i].style.display = "none";
                }
                tablinks = document.getElementsByClassName("tablinks");
                for (i = 0; i < tablinks.length; i++) {
                    tablinks[i].className = tablinks[i].className.replace(" active", "");
                }
                document.getElementById(loginType).style.display = "block";
                evt.currentTarget.className += " active";
            }

// Mặc định hiển thị tab Customer Login
            document.addEventListener('DOMContentLoaded', function () {
                document.querySelector('.tablinks').click();
            });
            document.addEventListener('DOMContentLoaded', function () {
                const tabBtns = document.querySelectorAll('.tab-btn');
                tabBtns.forEach(btn => {
                    btn.addEventListener('click', function (e) {
                        // Thêm hiệu ứng ripple
                        const ripple = document.createElement('div');
                        ripple.className = 'ripple';
                        const rect = this.getBoundingClientRect();
                        ripple.style.left = e.clientX - rect.left + 'px';
                        ripple.style.top = e.clientY - rect.top + 'px';
                        this.appendChild(ripple);
                        setTimeout(() => ripple.remove(), 600);
                    });
                });
            });
            document.addEventListener('DOMContentLoaded', function () {
                const tabBtns = document.querySelectorAll('.tab-btn');
                const tabContents = document.querySelectorAll('.tab-content');
                tabBtns.forEach(btn => {
                    btn.addEventListener('click', function () {
                        // Remove active class from all buttons
                        tabBtns.forEach(b => b.classList.remove('active'));
                        // Add active class to clicked button
                        this.classList.add('active');
                        // Hide all tab contents
                        tabContents.forEach(content => {
                            content.classList.remove('active');
                        });
                        // Show selected tab content
                        const tabId = this.getAttribute('data-tab');
                        document.getElementById(tabId + '-tab').classList.add('active');
                    });
                });
            });
        </script>

    </body>



</html>