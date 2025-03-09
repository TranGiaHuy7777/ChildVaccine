<%@page import="vaccine.VaccineDTO" %>
<%@page import="vaccine.VaccineDAO" %>
<%@page import="child.ChildDAO" %>
<%@page import="child.ChildDTO" %>
<%@page import="java.util.List" %>
<%@page import="customer.CustomerDTO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>

    <head>
        <title>Vaccination Schedule</title>
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link
            href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background: url('https://files.oaiusercontent.com/file-CvLDXsVMfHU8jP8mFVR5ij?se=2025-03-01T17%3A32%3A34Z&sp=r&sv=2024-08-04&sr=b&rscc=max-age%3D604800%2C%20immutable%2C%20private&rscd=attachment%3B%20filename%3D6d0015d4-6b4a-48ce-9efe-3b5e06598a6d.webp&sig=A0GpqkV7iKN/lF%2BeZTTpvqwoRjh7s%2BhT6OQ7n4L4Jzc%3D') no-repeat center center fixed;
                background-size: cover;
                color: #333;
                line-height: 1.6;
            }

            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148981266.jpg?w=2000');
                background-size: cover;
                background-position: center;
                background-attachment: fixed;
                padding: 150px 0;
                text-align: center;
                color: white;
                margin: -20px -20px 40px -20px;
                position: relative;
                overflow: hidden;
            }

            .hero-section::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 100px;
                background: linear-gradient(to top, rgba(255,255,255,1), transparent);
            }

            .hero-content {
                max-width: 800px;
                margin: 0 auto;
                padding: 0 20px;
                position: relative;
                z-index: 1;
            }

            .hero-title {
                font-size: 4em;
                margin-bottom: 20px;
                font-weight: 700;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
                animation: fadeInDown 1s ease-out;
            }

            .hero-subtitle {
                font-size: 1.5em;
                margin-bottom: 30px;
                text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
                animation: fadeInUp 1s ease-out;
            }

            .vaccine-card {
                background: white;
                border-radius: 15px;
                padding: 20px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .vaccine-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(90deg, #1e88e5, #1565c0);
            }

            .vaccine-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
            }

            .vaccine-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 10px;
                margin-bottom: 15px;
            }

            .stats-section {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 30px;
                margin: 60px 0;
                padding: 0 20px;
            }

            .stat-card {
                background: white;
                padding: 30px;
                border-radius: 20px;
                text-align: center;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(90deg, #1e88e5, #1565c0);
            }

            .stat-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
            }

            .stat-number {
                font-size: 2.5em;
                font-weight: 700;
                color: #1e88e5;
                margin-bottom: 15px;
                position: relative;
                display: inline-block;
            }

            .stat-number::after {
                content: '';
                position: absolute;
                bottom: -5px;
                left: 50%;
                transform: translateX(-50%);
                width: 40px;
                height: 3px;
                background: #1e88e5;
                border-radius: 3px;
            }

            .stat-label {
                color: #666;
                font-size: 1.1em;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            /* Cập nhật style cho search section */
            .search-section {
                background: white;
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                margin: 40px 0;
            }

            .search-input {
                flex: 1;
                padding: 15px 25px;
                font-size: 1.1em;
                border: 2px solid #e0e0e0;
                border-radius: 30px;
                transition: all 0.3s ease;
            }

            .search-input:focus {
                border-color: #1e88e5;
                box-shadow: 0 0 0 3px rgba(30, 136, 229, 0.2);
            }

            .search-button {
                padding: 15px 30px;
                font-size: 1.1em;
                border-radius: 30px;
                background: linear-gradient(90deg, #1e88e5, #1565c0);
                color: white;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .search-button:hover {
                background: linear-gradient(90deg, #1565c0, #0d47a1);
                transform: translateY(-2px);
            }

            .container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 0;
                box-shadow: none;
            }

            .nav-info-bar {
                background: rgba(255, 255, 255, 0.95);
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
                margin: 20px auto;
                max-width: 1200px;
                position: relative;
                z-index: 10;
                display: flex;
                justify-content: space-around;
                align-items: center;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .nav-info-item {
                display: flex;
                align-items: center;
                gap: 15px;
                padding: 15px 30px;
                position: relative;
                transition: all 0.3s ease;
            }

            .nav-info-item:not(:last-child)::after {
                content: '';
                position: absolute;
                right: 0;
                top: 50%;
                transform: translateY(-50%);
                height: 30px;
                width: 1px;
                background: rgba(0, 0, 0, 0.1);
            }

            .nav-info-item i {
                font-size: 24px;
                color: #1e88e5;
                padding: 12px;
                background: rgba(30, 136, 229, 0.1);
                border-radius: 50%;
                transition: all 0.3s ease;
            }

            .nav-info-item:hover i {
                transform: scale(1.1);
                color: #1565c0;
                background: rgba(30, 136, 229, 0.2);
            }

            .info-content {
                display: flex;
                flex-direction: column;
            }

            .info-label {
                font-size: 0.85em;
                color: #666;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 4px;
            }

            .info-value {
                font-weight: 600;
                color: #333;
                font-size: 1.1em;
            }

            .info-value a {
                color: #1e88e5;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .info-value a:hover {
                color: #1565c0;
            }

            .status-warning {
                color: #ff9800;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .error {
                color: #f44336;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .header {
                background: linear-gradient(135deg, #1e88e5, #1565c0);
                padding: 30px;
                border-radius: 20px;
                margin-bottom: 40px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }

            .search-container {
                max-width: 800px;
                margin: 0 auto;
                display: flex;
                gap: 15px;
            }

            .vaccine-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 30px;
                margin-top: 40px;
                padding: 20px;
            }

            .vaccine-card {
                background: white;
                border-radius: 20px;
                padding: 0;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                overflow: hidden;
                position: relative;
            }

            .vaccine-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
            }

            .vaccine-name {
                font-size: 1.4em;
                font-weight: 600;
                color: #1e88e5;
                margin-bottom: 15px;
            }

            .vaccine-info {
                padding: 25px;
            }

            .vaccine-info p {
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .price {
                font-size: 1.2em;
                color: #2e7d32;
                font-weight: 600;
                margin: 15px 0;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .recommended-age {
                color: #1565c0;
            }

            .book-button {
                width: 100%;
                padding: 15px;
                border: none;
                background: linear-gradient(90deg, #1e88e5, #1565c0);
                color: white;
                font-size: 1.1em;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                border-radius: 0;
            }

            .book-button:hover {
                background: linear-gradient(90deg, #1565c0, #0d47a1);
            }

            .warning-button {
                background: #ff9800;
            }

            .warning-button:hover {
                background: #f57c00;
            }

            .success-message {
                background-color: #e8f5e9;
                color: #2e7d32;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .error-message {
                background: #ffebee;
                color: #c62828;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .welcome-message {
                display: flex;
                align-items: center;
                gap: 8px;
                color: white;
            }

            .login-button {
                padding: 8px 16px;
                background: rgba(255, 255, 255, 0.2);
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s ease;
            }

            .login-button:hover {
                background: rgba(255, 255, 255, 0.3);
            }

            .header-right {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .no-results {
                text-align: center;
                padding: 40px;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .no-results i {
                font-size: 48px;
                color: #9e9e9e;
                margin-bottom: 10px;
            }

            .book-button {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                width: 100%;
                padding: 12px;
                background: #4CAF50;
                color: white;
                border: none;
                border-radius: 25px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .book-button:hover {
                background: #45a049;
                transform: translateY(-2px);
            }

            .book-button i {
                font-size: 18px;
            }

            .warning-button {
                background: #ff9800;
            }

            .warning-button:hover {
                background: #f57c00;
            }

            /* User Profile Dropdown */
            .user-profile {
                position: relative;
                display: inline-block;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: #1e88e5;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
                border: 2px solid white;
            }

            .user-avatar:hover {
                transform: scale(1.05);
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            .profile-dropdown {
                position: absolute;
                top: 100%;
                right: 0;
                background: white;
                min-width: 250px;
                border-radius: 8px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                display: none;
                z-index: 1000;
                margin-top: 10px;
            }

            .profile-header {
                padding: 15px;
                border-bottom: 1px solid #eee;
                background: linear-gradient(135deg, #1e88e5, #1565c0);
                color: white;
                border-radius: 8px 8px 0 0;
            }

            .profile-header h4 {
                margin: 0;
                font-size: 1.1em;
            }

            .profile-header p {
                margin: 5px 0 0;
                font-size: 0.9em;
                opacity: 0.9;
            }

            .profile-menu {
                padding: 10px 0;
            }

            .profile-menu a {
                display: flex;
                align-items: center;
                padding: 12px 20px;
                color: #333;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .profile-menu a i {
                margin-right: 10px;
                width: 20px;
                text-align: center;
                color: #1e88e5;
            }

            .profile-menu a:hover {
                background: #f5f5f5;
                padding-left: 25px;
            }

            .profile-menu .logout {
                border-top: 1px solid #eee;
                margin-top: 5px;
                color: #dc3545;
            }

            .profile-menu .logout i {
                color: #dc3545;
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

            /* Nút "Xem Lịch Tiêm Chủng" */
            .view-schedule-button {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 12px 20px;
                background: #1e88e5;
                color: #fff;
                border: none;
                border-radius: 25px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                text-decoration: none;
                transition: all 0.3s ease;
                margin-top: 20px;
            }

            .view-schedule-button:hover {
                background: #1565c0;
            }

            @keyframes fadeInDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="nav-info-bar">
                <div class="nav-info-item">
                    <i class="fas fa-hospital"></i>
                    <div class="info-content">
                        <span class="info-label">Center</span>
                        <span class="info-value">Vaccine Medical Center</span>
                    </div>
                </div>

                <!--                <div class="nav-info-item">
<i class="fas fa-child"></i>
<div class="info-content">
<span class="info-label">Children</span>
                <%
                    CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
                    boolean isLoggedIn = loginUser != null;
                    boolean hasChildren = false;
                    ChildDAO childDAO = new ChildDAO();

                    if (isLoggedIn) {
                        try {
                            hasChildren = childDAO.hasChildren(Integer.parseInt(loginUser.getUserID()));
                            if (hasChildren) {
                                List<ChildDTO> children = childDAO.getChildrenByCustomerID(Integer.parseInt(loginUser.getUserID()));
                                if (!children.isEmpty()) {
                %>
                <span class="info-value"><%= children.get(0).getChildName()%></span>
                <%              }
                } else { %>
                <span class="info-value status-warning">
                    <i class="fas fa-exclamation-circle"></i> Not yet registered
                </span>
                <%          }
                } catch (Exception e) {
                    e.printStackTrace();
                %>
                <span class="info-value error">
                    <i class="fas fa-exclamation-triangle"></i> Not yet
                </span>
                <%      }
                } else { %>
                <span class="info-value">
                    <i class="fas fa-user"></i> Customer
                </span>
                <% } %>
            </div>
        </div>-->

                <div class="nav-info-item">
                    <i class="fas fa-calendar-check"></i>
                    <div class="info-content">
                        <span class="info-label">Vaccination schedule</span>
                        <span class="info-value">Track vaccination schedule</span>
                    </div>
                </div>
                <div class="nav-info-item">
                    <i class="fas fa-tags"></i>
                    <div class="info-content">
                        <span class="info-label">Price</span>
                        <a href="pricePackpage.jsp" class="info-value">Vaccination Package
                            Price</a>
                    </div>
                </div>
            </div>
            <div class="header">
                <div
                    style="display: flex; justify-content: space-between; align-items: center;">
                    <h1>Vaccination Schedule</h1>
                    <% if (isLoggedIn) {%>
                    <div class="user-profile">
                        <div class="user-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="profile-dropdown">
                            <div class="profile-header">
                                <h4>
                                    <%= loginUser.getFullName()%>
                                </h4>
                                <p>
                                    <%= loginUser.getEmail()%>
                                </p>
                            </div>
                            <div class="profile-menu">
                                <a href="profile.jsp">
                                    <i class="fas fa-user-circle"></i>
                                    Personal profile
                                </a>
                                <a href="childProfile.jsp">
                                    <i class="fas fa-baby"></i>
                                    Child Profile
                                </a>
                                <a href="appointmentHistory.jsp">
                                    <i class="fas fa-calendar-check"></i>
                                    Appointment History
                                </a>
                                <a href="ReportController">
                                    <i class="fas fa-chart-bar"></i>
                                    Report - Admin
                                </a>
                                <a href="MainController?action=Logout" class="logout">
                                    <i class="fas fa-sign-out-alt"></i>
                                    Logout
                                </a>
                            </div>
                        </div>
                    </div>
                    <% } else { %>
                    <a href="login.jsp" class="login-button">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                    <% }%>
                </div>
                <p>Find and schedule your vaccinations with ease</p>
            </div>

            <div class="hero-section">
                <div class="hero-content">
                    <h1 class="hero-title">Protecting Future Health</h1>
                    <p class="hero-subtitle">Schedule safe and convenient vaccinations for your
                        baby</p>
                </div>
            </div>


            <div class="stats-section">
                <div class="stat-card">
                    <div class="stat-number">1000+</div>
                    <div class="stat-label">Trusted Customer</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">50+</div>
                    <div class="stat-label">Vaccine Type</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">99%</div>
                    <div class="stat-label">Safety</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">24/7</div>
                    <div class="stat-label">Medical Support</div>
                </div>
            </div>

            <!-- Hiển thị thông báo thành công nếu có -->
            <% String successMessage = (String) request.getAttribute("SUCCESS_MESSAGE");
                if (successMessage != null) {%>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                <%= successMessage%>
            </div>
            <% }%>



            <div class="search-section">
                <form action="VaccinationController" method="GET">
                    <div class="search-container">
                        <input type="text" name="search" class="search-input"
                               placeholder="Search for vaccines..."
                               value="<%= request.getParameter(" search") != null
                                       ? request.getParameter("search") : ""%>">
                        <button type="submit" class="search-button">
                            <i class="fas fa-search"></i> Search
                        </button>
                    </div>
                </form>
            </div>
            <div style="text-align: center;">
                <a href="MainController?action=ShowVaccinationSchedule"
                   class="view-schedule-button">
                    <i class="fas fa-calendar-alt"></i> Xem Lịch Tiêm Chủng
                </a>
            </div>

            <% VaccineDAO vaccineDAO = new VaccineDAO();
                List<VaccineDTO> vaccines = (List<VaccineDTO>) request.getAttribute("vaccines");

                try {
                    if (vaccines == null) {
                        String search = request.getParameter("search");
                        if (search != null && !search.trim().isEmpty()) {
                            vaccines = vaccineDAO.search(search);
                        } else {
                            vaccines = vaccineDAO.getAllVaccines();
                        }
                    }
            %>

            <% if (vaccines != null && !vaccines.isEmpty()) { %>
            <div class="vaccine-grid">
                <% for (VaccineDTO vaccine : vaccines) {%>
                <div class="vaccine-card">
                    <img src="https://file3.qdnd.vn/data/images/0/2021/11/11/nguyenthao/vaccinephongcovid-19pfizerbiontechvamoderna.jpg?dpi=150&quality=100&w=870"
                         alt="Vaccine Image" class="vaccine-image">
                    <div class="vaccine-name">
                        <%= vaccine.getVaccineName()%>
                    </div>
                    <div class="vaccine-info">
                        <p>
                            <%= vaccine.getDescription()%>
                        </p>
                        <p class="price">
                            <i class="fas fa-tag"></i>
                            <%= String.format("%,.0f VND",
                                    vaccine.getPrice())%>
                        </p>
                        <p class="recommended-age">
                            <i class="fas fa-user-clock"></i>
                            <%= vaccine.getRecommendedAge()%>
                        </p>
                    </div>
                    <% if (isLoggedIn) { %>
                    <% if (hasChildren) {%>
                    <form action="VaccinationController"
                          method="POST">
                        <input type="hidden" name="action"
                               value="SelectVaccine">
                        <input type="hidden" name="vaccineId"
                               value="<%= vaccine.getVaccineID()%>">
                        <button type="submit"
                                class="book-button">
                            <i class="fas fa-calendar-plus"></i>
                            Buy Now
                        </button>
                    </form>
                    <% } else {%>
                    <a href="VaccinationController?action=book&vaccineId=<%= vaccine.getVaccineID()%>"
                       class="book-button warning-button">
                        <i class="fas fa-user-plus"></i> Buy
                        now
                    </a>
                    <% } %>
                    <% } else { %>
                    <a href="login.jsp"
                       class="book-button">
                        <i
                            class="fas fa-shopping-cart"></i>
                        Child Information
                        Registration
                    </a>
                    <% } %>







                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="no-results"
                 style="text-align: center; padding: 40px; background: white; border-radius: 10px; margin-top: 20px;">
                <i class="fas fa-search"
                   style="font-size: 48px; color: #ccc; margin-bottom: 20px;"></i>
                <p style="font-size: 18px; color: #666;">No vaccines
                    found matching your keywords</p>
                <p
                    style="font-size: 14px; color: #888; margin-top: 10px;">
                    Please try again with another keyword</p>
                <a href="vaccinationSchedule.jsp" class="search-button"
                   style="display: inline-block; margin-top: 20px; text-decoration: none;">
                    <i class="fas fa-redo"></i> View all vaccines
                </a>
            </div>
            <% } %>

            <% } catch (Exception e) {
                e.printStackTrace(); %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <p>An error occurred while loading vaccines.
                    Please try again later.</p>
            </div>
            <% }%>



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
        function redirectToLogin() {
            window.location.href = 'login.jsp';
        }

        document.addEventListener('DOMContentLoaded', function () {
            const userAvatar = document.querySelector('.user-avatar');
            const profileDropdown = document.querySelector('.profile-dropdown');

            if (userAvatar) {
                userAvatar.addEventListener('click', function (e) {
                    e.stopPropagation();
                    profileDropdown.style.display =
                            profileDropdown.style.display === 'block' ? 'none' : 'block';
                });

                document.addEventListener('click', function (e) {
                    if (!profileDropdown.contains(e.target)) {
                        profileDropdown.style.display = 'none';
                    }
                });
            }
        });
    </script>
</div>
</body>

</html>