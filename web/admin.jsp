<%@page import="vaccine.VaccineDAO"%>
<%@page import="vaccine.VaccineDTO"%>
<%@page import="customer.CustomerDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="customer.CustomerDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Admin Dashboard - Vaccine Management</title>
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
                display: flex;
                flex-direction: column;
                margin: 0;
                padding: 0;
            }

            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
                    url('https://img.freepik.com/free-photo/medical-banner-with-doctor-working-laptop_23-2149611193.jpg?w=2000');
                background-size: cover;
                background-position: center;
                padding: 60px 0;
                text-align: center;
                color: white;
                margin-bottom: 40px;
                border-radius: 0 0 20px 20px;
            }

            .navbar {
                background: white;
                padding: 1rem 2rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .welcome-message {
                display: flex;
                align-items: center;
                gap: 10px;
                font-weight: 500;
            }

            .welcome-message i {
                color: #1e88e5;
            }

            .dashboard-title {
                font-size: 2.5em;
                margin-bottom: 15px;
                font-weight: 700;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            }

            .dashboard-subtitle {
                font-size: 1.1em;
                opacity: 0.9;
            }

            .main-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
                flex: 1;
            }

            .search-box {
                background: white;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }

            .search-form {
                display: flex;
                gap: 15px;
            }

            .search-input {
                flex: 1;
                padding: 12px 20px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-size: 1em;
                transition: all 0.3s ease;
            }

            .search-input:focus {
                border-color: #1e88e5;
                outline: none;
                box-shadow: 0 0 0 3px rgba(30,136,229,0.1);
            }

            .search-button {
                padding: 12px 25px;
                background: #1e88e5;
                color: white;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s ease;
            }

            .search-button:hover {
                background: #1565c0;
                transform: translateY(-2px);
            }

            .users-table {
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }

            .users-table table {
                width: 100%;
                border-collapse: collapse;
            }

            .users-table th {
                background: #1e88e5;
                color: white;
                padding: 15px;
                text-align: left;
                font-weight: 500;
            }

            .users-table td {
                padding: 15px;
                border-bottom: 1px solid #eee;
            }

            .users-table tr:last-child td {
                border-bottom: none;
            }

            .users-table tr:hover {
                background: #f8f9fa;
            }

            .action-buttons {
                display: flex;
                gap: 10px;
            }

            .action-button {
                padding: 8px 15px;
                border-radius: 8px;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 5px;
                font-size: 0.9em;
                transition: all 0.3s ease;
            }

            .edit-button {
                background: #4CAF50;
                color: white;
            }

            .delete-button {
                background: #f44336;
                color: white;
            }

            .action-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .logout-button {
                padding: 10px 20px;
                background: #f44336;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s ease;
            }

            .logout-button:hover {
                background: #d32f2f;
                transform: translateY(-2px);
            }

            .no-results {
                text-align: center;
                padding: 40px;
                color: #666;
            }

            .no-results i {
                font-size: 48px;
                color: #ccc;
                margin-bottom: 15px;
            }

            /* Modal styles */
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 1000;
                animation: fadeIn 0.3s ease;
            }

            .modal-container {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.1);
                width: 90%;
                max-width: 500px;
                text-align: left;
                z-index: 1001;
                animation: slideIn 0.3s ease;
            }

            .edit-form {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .form-group label {
                font-weight: 500;
                color: #333;
            }

            .form-group input {
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 1em;
                transition: all 0.3s ease;
            }

            .form-group input:focus {
                border-color: #1e88e5;
                outline: none;
                box-shadow: 0 0 0 3px rgba(30,136,229,0.1);
            }

            .form-group select {
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 1em;
                transition: all 0.3s ease;
            }

            .edit-buttons {
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                margin-top: 20px;
            }

            .save-button {
                background: #4CAF50;
                color: white;
                padding: 12px 25px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .save-button:hover {
                background: #43A047;
                transform: translateY(-2px);
            }

            .modal-close {
                position: absolute;
                top: 15px;
                right: 15px;
                background: none;
                border: none;
                font-size: 1.5em;
                cursor: pointer;
                color: #666;
                transition: all 0.3s ease;
            }

            .modal-close:hover {
                color: #333;
                transform: rotate(90deg);
            }

            .success-message, .error-message {
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                display: none;
            }

            .success-message {
                background: #E8F5E9;
                color: #2E7D32;
                border: 1px solid #A5D6A7;
            }

            .error-message {
                background: #FFEBEE;
                color: #C62828;
                border: 1px solid #FFCDD2;
            }

            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            @keyframes slideIn {
                from { 
                    opacity: 0;
                    transform: translate(-50%, -60%);
                }
                to { 
                    opacity: 1;
                    transform: translate(-50%, -50%);
                }
            }
            .footer {
                background: linear-gradient(135deg, #192f59 0%, #0b224d 100%);
                color: #fff;
                padding: 80px 0 0;
                margin-top: auto;
            }

            .footer-content {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 40px;
            }

            .footer-section {
                background: rgba(255, 255, 255, 0.05);
                border-radius: 15px;
                padding: 30px;
                backdrop-filter: blur(10px);
            }

            .footer-section h3 {
                color: #fff;
                font-size: 1.4em;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li {
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .footer-bottom {
                background: rgba(0, 0, 0, 0.2);
                text-align: center;
                padding: 20px 0;
                margin-top: 60px;
            }

            .report-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: #1e88e5;
                color: white;
                padding: 12px 25px;
                border-radius: 10px;
                text-decoration: none;
                font-weight: 500;
                margin: 30px auto;
                transition: all 0.3s ease;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }

            .report-link:hover {
                background: #1565c0;
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(0,0,0,0.15);
            }

            .report-container {
                display: flex;
                justify-content: center;
                width: 100%;
                margin-top: 30px;
            }
            /* Nút Notify */
            .notify-button {
                background: #ffa726;
                color: white;
                border: none;
                /* Các thuộc tính CSS tương tự các nút action-button khác */
            }

            .section {
                background: white;
                border-radius: 10px;
                padding: 20px;
                margin: 20px 0;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .section-title {
                color: #333;
                font-size: 1.5em;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .section-title i {
                color: #2196F3;
            }

            .vaccine-price-container {
                overflow-x: auto;
            }

            .vaccine-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }

            .vaccine-table th,
            .vaccine-table td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }

            .vaccine-table th {
                background-color: #f8f9fa;
                font-weight: 600;
                color: #444;
            }

            .vaccine-table tr:hover {
                background-color: #f5f5f5;
            }

            .price-input {
                width: 150px;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            .price-input:focus {
                border-color: #2196F3;
                outline: none;
                box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.1);
            }

            .price-cell {
                font-weight: 500;
                color: #2196F3;
            }

            .update-btn {
                padding: 8px 16px;
                background: #4CAF50;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 5px;
                transition: all 0.3s ease;
            }

            .update-btn:hover {
                background: #45a049;
                transform: translateY(-1px);
            }

            .update-btn i {
                font-size: 14px;
            }

            @media (max-width: 768px) {
                .vaccine-table {
                    font-size: 14px;
                }

                .price-input {
                    width: 100px;
                }

                .update-btn {
                    padding: 6px 12px;
                }
            }

            .nav-buttons {
                display: flex;
                gap: 15px;
                align-items: center;
            }

            .report-button, .logout-button {
                padding: 8px 16px;
                border-radius: 5px;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .report-button {
                background: #4CAF50;
                color: white;
            }

            .report-button:hover {
                background: #45a049;
                transform: translateY(-1px);
            }

            .logout-button {
                background: #f44336;
                color: white;
            }

            .logout-button:hover {
                background: #d32f2f;
                transform: translateY(-1px);
            }

            @media (max-width: 768px) {
                .nav-buttons {
                    gap: 8px;
                }

                .report-button, .logout-button {
                    padding: 6px 12px;
                    font-size: 14px;
                }
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .add-vaccine-btn {
                background: #2196F3;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .add-vaccine-btn:hover {
                background: #1976D2;
                transform: translateY(-1px);
            }

            .add-vaccine-form {
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
                color: #333;
            }

            .form-group input,
            .form-group textarea {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            .form-group input:focus,
            .form-group textarea:focus {
                border-color: #2196F3;
                outline: none;
                box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.1);
            }

            .form-actions {
                display: flex;
                gap: 10px;
                margin-top: 20px;
            }

            .submit-btn, .cancel-btn {
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 5px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .submit-btn {
                background: #4CAF50;
                color: white;
            }

            .submit-btn:hover {
                background: #45a049;
            }

            .cancel-btn {
                background: #f44336;
                color: white;
            }

            .cancel-btn:hover {
                background: #d32f2f;
            }

            .add-vaccine-form {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin: 20px 0;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }

            .form-group input,
            .form-group textarea {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }

            .btn-submit {
                background: #1e88e5;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

            .btn-submit:hover {
                background: #1565c0;
            }

            .nav-button {
                background: #2196F3;
                color: white;
                padding: 8px 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s ease;
                margin-right: 10px;
            }

            .nav-button:hover {
                background: #1976D2;
                transform: translateY(-1px);
            }

            .nav-button.active {
                background: #1565C0;
            }

            #usersSection, #vaccineSection {
                margin-top: 20px;
                background: white;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #eee;
            }

            .search-box {
                background: transparent;
                padding: 0;
                box-shadow: none;
                margin-bottom: 20px;
            }

            .search-form {
                display: flex;
                gap: 10px;
            }

            .search-input {
                width: 300px;
            }

            .data-table {
                width: 100%;
                border-collapse: collapse;
            }

            .data-table th {
                background: #f5f5f5;
                padding: 12px;
                text-align: left;
            }

            .data-table td {
                padding: 12px;
                border-bottom: 1px solid #eee;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
            }

            .action-button {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 4px;
                font-size: 0.9em;
            }

            .edit-button {
                background: #4CAF50;
                color: white;
            }

            .delete-button {
                background: #f44336;
                color: white;
            }

            .notify-button {
                background: #ff9800;
                color: white;
            }

            /* Styles cho phần vaccine management */
            .add-vaccine-form {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
            }

            .form-group input,
            .form-group textarea {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }

            .btn-submit {
                background: #4CAF50;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .vaccine-table {
                width: 100%;
                margin-top: 20px;
            }

            .price-input {
                width: 150px;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }

            .update-btn {
                background: #2196F3;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 4px;
                cursor: pointer;
            }

            .content-section {
                background: white;
                border-radius: 10px;
                padding: 20px;
                margin-top: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .nav-button.active {
                background: #1565C0;
                transform: translateY(-1px);
            }

            .role-badge {
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 0.85em;
                font-weight: 500;
            }

            .role-badge.admin {
                background: #1e88e5;
                color: white;
            }

            .role-badge.user {
                background: #4CAF50;
                color: white;
            }

            select:disabled {
                opacity: 0.7;
                background-color: #f5f5f5 !important;
                cursor: not-allowed;
            }

            .form-group select:disabled + label {
                color: #666;
            }

            #displayRole {
                background-color: #f5f5f5;
                cursor: not-allowed;
                color: #666;
                border: 1px solid #ddd;
                padding: 12px;
                border-radius: 8px;
                width: 100%;
            }

            .form-group input[disabled] {
                opacity: 0.7;
            }
        </style>
    </head>
    <body>
        <%
            // Kiểm tra đăng nhập
            CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
            if (loginUser == null || !"AD".equals(loginUser.getRoleID())) {
                response.sendRedirect("login.jsp");
                return;
            }

            // Lấy danh sách users từ session
            List<CustomerDTO> list = (List<CustomerDTO>) session.getAttribute("LIST_USER");
            if (list == null) {
                CustomerDAO dao = new CustomerDAO();
                list = dao.getListUser();
                session.setAttribute("LIST_USER", list);
            }
        %>

        <!-- Navbar -->
<nav class="navbar">
    <div class="welcome-message">
        <i class="fas fa-user-shield"></i>
        Welcome, <%= loginUser.getFullName()%>
    </div>
    <div class="nav-buttons">
        <button class="nav-button" onclick="showSection('users')">
            <i class="fas fa-users"></i> Manage Users
        </button>
        <button class="nav-button" onclick="showSection('vaccines')">
            <i class="fas fa-syringe"></i> Manage Vaccines
        </button>
        <!-- Nút mở trang System Overview -->
        <button class="nav-button" onclick="window.location.href='StatisticsController'">
            <i class="fas fa-chart-line"></i> System Overview
        </button>
        <button class="report-button" onclick="window.location.href = 'report.jsp'">
            <i class="fas fa-chart-bar"></i> View Report
        </button>
        <form action="MainController" method="POST" style="display: inline;">
            <button type="submit" name="action" value="Logout" class="logout-button">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </form>
    </div>
</nav>


        <!-- Hero Section -->
        <div class="hero-section">
            <h1 class="dashboard-title">Admin Dashboard</h1>
            <p class="dashboard-subtitle">Manage users and system settings</p>
        </div>

        <!-- Main Content -->
        <div class="main-container">
            <!-- Users Section -->
            <div id="usersSection" class="content-section">
                <!-- Search Box -->
                <div class="search-box">
                    <form action="MainController" method="POST" class="search-form">
                        <input type="text" 
                               name="search" 
                               class="search-input"
                               value="<%= request.getParameter("search") != null ? request.getParameter("search") : ""%>"
                               placeholder="Search users by name...">
                        <button type="submit" name="action" value="Search" class="search-button">
                            <i class="fas fa-search"></i>
                            Search
                        </button>
                    </form>
                </div>

                <!-- Users Table -->
                <div class="users-table">
                    <table>
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>User ID</th>
                                <th>Full Name</th>
                                <th>Role</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (list != null && !list.isEmpty()) {
                                    int count = 1;
                                    for (CustomerDTO user : list) {
                            %>
                            <tr>
                                <td><%= count++%></td>
                                <td><%= user.getUserID()%></td>
                                <td><%= user.getFullName()%></td>
                                <td>
                                    <span class="role-badge <%= user.getRoleID().equals("AD") ? "admin" : "user"%>">
                                        <%= user.getRoleID()%>
                                    </span>
                                </td>
                                <td><%= user.getEmail()%></td>
                                <td><%= user.getPhone()%></td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="editUser.jsp?userID=<%= user.getUserID()%>" 
                                           class="action-button edit-button">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <% if (!"AD".equals(user.getRoleID())) { %>
                                            <a href="MainController?action=Delete&userID=<%= user.getUserID()%>" 
                                               class="action-button delete-button"
                                               onclick="return confirm('Are you sure you want to delete this user?')">
                                                <i class="fas fa-trash-alt"></i> Delete
                                            </a>
                                            <a href="adminDashboard.jsp?userID=<%= user.getUserID()%>" 
                                               class="action-button notify-button">
                                                <i class="fas fa-bell"></i> Notify
                                            </a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="7" class="no-results">
                                    <i class="fas fa-search"></i>
                                    <p>No users found</p>
                                    <p style="font-size: 0.9em; color: #888;">Try different search terms</p>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Vaccines Section -->
            <div id="vaccineSection" class="content-section" style="display: none;">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-syringe"></i>
                        Manage Vaccine
                    </h2>
                </div>

                <div class="add-vaccine-form">
                    <h2>Thêm Vaccine Mới</h2>
                    <form action="MainController" method="POST">
                        <div class="form-group">
                            <label for="vaccineName">Tên Vaccine:</label>
                            <input type="text" id="vaccineName" name="vaccineName" required>
                        </div>

                        <div class="form-group">
                            <label for="description">Mô tả:</label>
                            <textarea id="description" name="description" required></textarea>
                        </div>

                        <div class="form-group">
                            <label for="price">Giá:</label>
                            <input type="number" id="price" name="price" min="0" step="1000" required>
                        </div>

                        <div class="form-group">
                            <label for="recommendedAge">Độ tuổi khuyến nghị:</label>
                            <input type="text" id="recommendedAge" name="recommendedAge" required>
                        </div>

                        <input type="hidden" name="action" value="AddVaccine">
                        <button type="submit" class="btn-submit">Thêm Vaccine</button>
                    </form>
                </div>

                <div class="vaccine-price-container">
                    <table class="vaccine-table">
                        <thead>
                            <tr>
                                <th>Tên Vaccine</th>
                                <th>Mô tả</th>
                                <th>Giá hiện tại</th>
                                <th>Giá mới</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                VaccineDAO vaccineDAO = new VaccineDAO();
                                List<VaccineDTO> vaccines = vaccineDAO.getAllVaccines();
                                for (VaccineDTO vaccine : vaccines) {
                            %>
                            <tr>
                                <td><%= vaccine.getVaccineName()%></td>
                                <td><%= vaccine.getDescription()%></td>
                                <td class="price-cell"><%= vaccine.getPrice()%> VND</td>
                                <td>
                                    <input type="number" 
                                           min="0" 
                                           step="1000" 
                                           class="price-input" 
                                           id="price_<%= vaccine.getVaccineID()%>"
                                           placeholder="Nhập giá mới">
                                </td>
                                <td>
                                    <button onclick="updatePrice('<%= vaccine.getVaccineID()%>')" 
                                            class="update-btn">
                                        <i class="fas fa-check"></i> Cập nhật
                                    </button>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->  
        <div id="deleteModal" class="modal-overlay">
            <div class="modal-container">
                <div class="modal-icon">
                    <i class="fas fa-exclamation-circle"></i>
                </div>
                <h2 class="modal-title">Xác nhận xóa</h2>
                <p class="modal-message">Bạn có chắc chắn muốn xóa người dùng này?</p>
                <div class="modal-buttons">
                    <button id="confirmDelete" class="modal-button confirm-button">
                        <i class="fas fa-trash-alt"></i> Xóa
                    </button>
                    <button id="cancelDelete" class="modal-button cancel-button">
                        <i class="fas fa-times"></i> Hủy
                    </button>
                </div>
            </div>
        </div>

        <!-- Edit User Modal -->
        <div id="editModal" class="modal-overlay">
            <div class="modal-container">
                <button class="modal-close">&times;</button>
                <h2 class="modal-title">Edit User Information</h2>
                <div class="success-message"></div>
                <div class="error-message"></div>
                <form id="editForm" class="edit-form">
                    <input type="hidden" id="editUserID" name="userID">
                    <input type="hidden" id="editRole" name="roleID">
                    
                    <div class="form-group">
                        <label for="editFullName">Full Name</label>
                        <input type="text" id="editFullName" name="fullName" required>
                    </div>
                    <div class="form-group">
                        <label for="editEmail">Email</label>
                        <input type="email" id="editEmail" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="editPhone">Phone</label>
                        <input type="tel" id="editPhone" name="phone" required>
                    </div>
                    <div class="form-group">
                        <label>Role</label>
                        <input type="text" id="displayRole" disabled>
                    </div>
                    <div class="edit-buttons">
                        <button type="button" class="modal-button cancel-button" onclick="closeEditModal()">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                        <button type="submit" class="save-button">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <footer class="footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h3><i class="fas fa-map-marker-alt"></i> Hệ Thống Miền Bắc</h3>
                    <ul>
                        <li><i class="fas fa-map-marker-alt"></i> Số 180 Trường Chinh, Hà Nội</li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3><i class="fas fa-map-marker-alt"></i> Hệ Thống Miền Nam</h3>
                    <ul>
                        <li><i class="fas fa-map-marker-alt"></i> Số 198 Nguyễn Thị Minh Khai, Quận 1, TP.HCM</li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3><i class="fas fa-clock"></i> Giờ Làm Việc</h3>
                    <ul>
                        <li><i class="fas fa-sun"></i> Sáng: 08:00 - 12:00</li>
                        <li><i class="fas fa-moon"></i> Chiều: 13:00 - 17:00</li>
                        <li><i class="fas fa-calendar-alt"></i> Từ Thứ 2 - Chủ Nhật</li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Vaccine Booking System. All Rights Reserved.</p>
            </div>
        </footer>
        <script>
            let userIdToDelete = null;

            function showDeleteConfirmation(userId) {
                userIdToDelete = userId;
                document.getElementById('deleteModal').style.display = 'block';
                document.body.style.overflow = 'hidden';
            }

            function showEditModal(userId, fullName, email, phone, roleID) {
                document.getElementById('editUserID').value = userId;
                document.getElementById('editFullName').value = fullName;
                document.getElementById('editEmail').value = email;
                document.getElementById('editPhone').value = phone;
                document.getElementById('editRole').value = roleID;
                
                // Hiển thị role trong trường input disabled
                const displayRole = document.getElementById('displayRole');
                displayRole.value = roleID === 'AD' ? 'Admin' : 'User';
                
                document.getElementById('editModal').style.display = 'block';
                document.body.style.overflow = 'hidden';
            }

            function closeEditModal() {
                document.getElementById('editModal').style.display = 'none';
                document.body.style.overflow = 'auto';
                document.querySelector('.success-message').style.display = 'none';
                document.querySelector('.error-message').style.display = 'none';
            }

            document.getElementById('editForm').addEventListener('submit', function(e) {
                e.preventDefault();
                const formData = new FormData(this);

                fetch('UpdateController', {
                    method: 'POST',
                    body: new URLSearchParams(formData)
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('success')) {
                        document.querySelector('.success-message').textContent = 'User information updated successfully!';
                        document.querySelector('.success-message').style.display = 'block';
                        document.querySelector('.error-message').style.display = 'none';
                        setTimeout(() => {
                            window.location.reload();
                        }, 1500);
                    } else {
                        document.querySelector('.error-message').textContent = 'Failed to update user information. Please try again.';
                        document.querySelector('.error-message').style.display = 'block';
                        document.querySelector('.success-message').style.display = 'none';
                    }
                })
                .catch(error => {
                    document.querySelector('.error-message').textContent = 'An error occurred. Please try again.';
                    document.querySelector('.error-message').style.display = 'block';
                    document.querySelector('.success-message').style.display = 'none';
                });
            });

            // Update the edit button click handler
            document.querySelectorAll('.edit-button').forEach(button => {
                button.onclick = function(e) {
                    e.preventDefault();
                    const row = this.closest('tr');
                    const userId = row.querySelector('td:nth-child(2)').textContent;
                    const fullName = row.querySelector('td:nth-child(3)').textContent;
                    const roleID = row.querySelector('td:nth-child(4) .role-badge').textContent.trim();
                    const email = row.querySelector('td:nth-child(5)').textContent;
                    const phone = row.querySelector('td:nth-child(6)').textContent;
                    showEditModal(userId, fullName, email, phone, roleID);
                };
            });

            // Existing delete functionality
            document.getElementById('cancelDelete').addEventListener('click', function () {
                document.getElementById('deleteModal').style.display = 'none';
                document.body.style.overflow = 'auto';
                userIdToDelete = null;
            });

            document.getElementById('confirmDelete').addEventListener('click', function () {
                if (userIdToDelete) {
                    window.location.href = 'MainController?action=Delete&userID=' + userIdToDelete;
                }
            });

            document.querySelectorAll('.delete-button').forEach(button => {
                button.onclick = function (e) {
                    e.preventDefault();
                    const userId = this.getAttribute('href').split('userID=')[1];
                    showDeleteConfirmation(userId);
                };
            });

            // Close modal when clicking outside
            window.onclick = function (event) {
                if (event.target.classList.contains('modal-overlay')) {
                    event.target.style.display = 'none';
                    document.body.style.overflow = 'auto';
                }
            };

            function updatePrice(vaccineId) {
                var newPrice = document.getElementById('price_' + vaccineId).value;
                if (newPrice && newPrice > 0) {
                    var form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'AdminController';

                    var actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'updatePrice';

                    var idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'vaccineId';
                    idInput.value = vaccineId;

                    var priceInput = document.createElement('input');
                    priceInput.type = 'hidden';
                    priceInput.name = 'newPrice';
                    priceInput.value = newPrice;

                    form.appendChild(actionInput);
                    form.appendChild(idInput);
                    form.appendChild(priceInput);

                    document.body.appendChild(form);
                    form.submit();
                } else {
                    alert('Vui lòng nhập giá hợp lệ!');
                }
            }

            function openAddVaccineForm() {
                document.getElementById('addVaccineForm').style.display = 'block';
            }

            function closeAddVaccineForm() {
                document.getElementById('addVaccineForm').style.display = 'none';
            }

            function showSection(section) {
                // Ẩn tất cả các section
                document.getElementById('usersSection').style.display = 'none';
                document.getElementById('vaccineSection').style.display = 'none';
                
                // Lấy các phần tử header
                const dashboardTitle = document.querySelector('.dashboard-title');
                const dashboardSubtitle = document.querySelector('.dashboard-subtitle');
                
                // Cập nhật tiêu đề và subtitle dựa trên section
                if (section === 'users') {
                    document.getElementById('usersSection').style.display = 'block';
                    dashboardTitle.textContent = 'Admin Dashboard';
                    dashboardSubtitle.textContent = 'Manage users and system settings';
                } else if (section === 'vaccines') {
                    document.getElementById('vaccineSection').style.display = 'block';
                    dashboardTitle.textContent = 'Vaccine Dashboard';
                    dashboardSubtitle.textContent = 'Manage vaccines and pricing';
                }
                
                // Cập nhật trạng thái active của nút
                document.querySelectorAll('.nav-button').forEach(btn => {
                    btn.classList.remove('active');
                    if (btn.textContent.includes(section === 'users' ? 'Users' : 'Vaccines')) {
                        btn.classList.add('active');
                    }
                });
            }

            // Khi trang load, mặc định hiển thị phần users
            window.onload = function() {
                showSection('users');
            };
        </script>
    </body>
</html>