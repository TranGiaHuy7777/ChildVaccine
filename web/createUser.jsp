<%-- 
    Document   : user
    Created on : Jan 7, 2025, 1:45:18 PM
    Author     : Windows
--%>

<%@page import="customer.UserError"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Account - Child Vaccination</title>
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
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 40px 20px;
            }

            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880385.jpg');
                background-size: cover;
                background-position: center;
                padding: 60px 0;
                text-align: center;
                color: white;
                border-radius: 15px;
                margin-bottom: 40px;
            }.form-container {
                background: white;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }

            .form-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .form-header h1 {
                color: #1e88e5;
                font-size: 2em;
                margin-bottom: 10px;
            }

            .form-header p {
                color: #666;
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

            .form-group input {
                width: 100%;
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-size: 1em;
                transition: all 0.3s ease;
            }

            .form-group input:focus {
                border-color: #1e88e5;
                box-shadow: 0 0 10px rgba(30, 136, 229, 0.1);
                outline: none;
            }

            .form-group input[readonly] {
                background-color: #f8f9fa;
                cursor: not-allowed;
            }.error-message {
                color: #e74c3c;
                font-size: 0.85em;
                margin-top: 5px;
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
                border-radius: 10px;
                font-size: 1em;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-create {
                background: #1e88e5;
                color: white;
            }
            .btn-create:hover {
                background: #1565c0;
                transform: translateY(-2px);
            }

            .btn-reset {
                background: #e74c3c;
                color: white;
            }

            .btn-reset:hover {
                background: #c0392b;
                transform: translateY(-2px);
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

            .input-icon {
                position: relative;
            }

            .input-icon i {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: #666;
            }

            .input-icon input {
                padding-left: 40px;
            }
        </style>
    </head>
    <body>
        <div class="overlay">
            <div class="content">
                <!-- Form Container -->
                <div class="container">
                    <a href="login.jsp" class="back-link">
                        <i class="fas fa-arrow-left"></i>
                        Back to Home
                    </a>

                    <div class="hero-section">
                        <h1>Join Our Vaccination Program</h1>
                        <p>Create an account to access our services</p>
                    </div>

                    <div class="form-container">
                        <div class="form-header">
                            <h1>Create Your Account</h1>
                            <p>Please fill in the information below</p>
                        </div>

                        <%
                            UserError userError = (UserError) request.getAttribute("USER_ERROR");
                            if (userError == null) {
                                userError = new UserError();
                            }
                        %>
                        <form action="MainController" method="POST">
                            <div class="form-group">
                                <label for="userID">User ID</label>
                                <div class="input-icon">
                                    <i class="fas fa-user"></i>
                                    <input type="text" name="userID" id="userID" required />
                                </div>
                                <div class="error-message"><%= userError.getUserIDError()%></div>
                            </div>

                            <div class="form-group">
                                <label for="fullName">Full Name</label>
                                <div class="input-icon">
                                    <i class="fas fa-user-circle"></i>
                                    <input type="text" name="fullName" id="fullName" required />
                                </div>
                                <div class="error-message"><%= userError.getFullNameError()%></div>
                            </div>

                            <div class="form-group">
                                <label for="roleID">Role</label>
                                <div class="input-icon">
                                    <i class="fas fa-user-tag"></i>
                                    <input type="text" name="roleID" id="roleID" value="US" readonly />
                                </div>
                            </div><div class="form-group">
                                <label for="password">Password</label>
                                <div class="input-icon">
                                    <i class="fas fa-lock"></i>
                                    <input type="password" name="password" id="password" required />
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="confirm">Confirm Password</label>
                                <div class="input-icon">
                                    <i class="fas fa-lock"></i>
                                    <input type="password" name="confirm" id="confirm" required />
                                </div>
                                <div class="error-message"><%= userError.getConfirmError()%></div>
                            </div>

                            <div class="form-group">
                                <label for="email">Email</label>
                                <div class="input-icon">
                                    <i class="fas fa-envelope"></i>
                                    <input type="email" name="email" id="email" required />
                                </div>
                            </div> <div class="form-group">
                                <label for="address">Address</label>
                                <div class="input-icon">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <input type="text" name="address" id="address" required />
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="phone">Phone</label>
                                <div class="input-icon">
                                    <i class="fas fa-phone"></i>
                                    <input type="text" name="phone" id="phone" required />
                                </div>
                            </div>

                            <div class="btn-group">
                                <button type="submit" name="action" value="Create" class="btn btn-create">
                                    <i class="fas fa-user-plus"></i> Create Account
                                </button>
                                <button type="reset" class="btn btn-reset">
                                    <i class="fas fa-undo"></i> Reset
                                </button>
                            </div>

                            <div class="error-message text-center"><%= userError.getError()%></div>
                        </form>
                    </div>

                </div>

            </div>
        </div>
    </body>
</html>
