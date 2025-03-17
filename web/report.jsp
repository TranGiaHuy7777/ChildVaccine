<%@page import="customer.CustomerDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="reports.ReportDTO"%>
<%@page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Report</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

        <style>
            body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
                min-height: 100vh;
                background-color: #f0f2f5;
                background-image: url('https://www.transparenttextures.com/patterns/medical-icons.png'),
                    linear-gradient(135deg, #0396FF 0%, #ABDCFF 100%);
                background-attachment: fixed;
                position: relative;
            }

            /* Add decorative elements */
            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: url('https://www.transparenttextures.com/patterns/crosses.png');
                opacity: 0.05;
                z-index: -1;
            }

            .container {
                width: 85%;
                max-width: 1200px;
                margin: 50px auto;
                background: white;
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            }

            h2 {
                color: #1a237e;
                font-size: 36px;
                margin-bottom: 40px;
                text-align: center;
                position: relative;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
            }

            h2:after {
                content: '';
                display: block;
                width: 80px;
                height: 4px;
                background: linear-gradient(90deg, #0396FF, #ABDCFF);
                margin: 15px auto;
                border-radius: 2px;
            }

            /* Search Box */
            .search-box {
                background: #f8f9fa;
                padding: 25px;
                border-radius: 15px;
                margin-bottom: 30px;
                display: flex;
                gap: 20px;
                justify-content: center;
                align-items: center;
                flex-wrap: wrap;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            }

            .search-box input {
                padding: 15px 25px;
                border: 2px solid #e0e0e0;
                border-radius: 12px;
                font-size: 16px;
                flex: 1;
                min-width: 200px;
                transition: all 0.3s ease;
            }

            .search-box input:focus {
                border-color: #0396FF;
                outline: none;
                box-shadow: 0 0 0 3px rgba(3, 150, 255, 0.1);
            }

            .search-box button {
                padding: 15px 35px;
                background: linear-gradient(135deg, #0396FF, #ABDCFF);
                color: white;
                border: none;
                border-radius: 12px;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .search-box button:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(3, 150, 255, 0.3);
            }

            /* Table Styling */
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                margin: 25px 0;
                box-shadow: 0 5px 25px rgba(0, 0, 0, 0.1);
                border-radius: 15px;
                overflow: hidden;
                background: white;
                transition: transform 0.2s ease;
            }

            table:hover {
                transform: translateY(-5px);
            }

            th {
                background: linear-gradient(135deg, #0396FF, #ABDCFF);
                color: white;
                font-size: 18px;
                font-weight: 500;
                padding: 18px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            td {
                padding: 18px;
                background: white;
                border-bottom: 1px solid #eef2f7;
                color: #2C3E50;
                font-size: 15px;
                transition: all 0.3s ease;
            }

            tr:last-child td {
                border-bottom: none;
            }

            tr:hover td {
                background: #f8f9fa;
            }

            /* Error Message */
            p {
                background: #FFF5F5;
                color: #E53E3E;
                padding: 20px;
                border-radius: 12px;
                font-size: 16px;
                text-align: center;
                margin: 20px 0;
                border: 1px solid #FED7D7;
            }

            /* Home Button */
            a {
                display: block;
                width: fit-content;
                padding: 15px 40px;
                background: linear-gradient(135deg, #0396FF, #ABDCFF);
                color: white;
                text-decoration: none;
                border-radius: 50px;
                font-weight: 500;
                margin: 40px auto;
                transition: all 0.3s ease;
                box-shadow: 0 5px 15px rgba(3, 150, 255, 0.3);
            }

            a:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(3, 150, 255, 0.4);
            }

            @media (max-width: 768px) {
                .container {
                    width: 95%;
                    padding: 20px;
                }

                .search-box {
                    flex-direction: column;
                }

                .search-box input,
                .search-box button {
                    width: 100%;
                }

                table {
                    font-size: 14px;
                }

                th, td {
                    padding: 12px;
                }

                h2 {
                    font-size: 28px;
                }
            }
            
              .footer {
                background: linear-gradient(135deg, #1a237e 0%, #0d47a1 100%);
                color: #fff;
                padding: 80px 0 0;
                margin-top: 60px;
                position: relative;
                box-shadow: 0 -10px 20px rgba(0, 0, 0, 0.1);
                width: 100%;
                left: 0;
                right: 0;
                overflow: hidden;
            }

            .footer::before {
                content: '';
                position: absolute;
                top: -50px;
                left: 0;
                right: 0;
                height: 50px;
                background: linear-gradient(to top right, transparent 49%, #1a237e 50%);
            }

            .footer::after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%23ffffff10" fill-opacity="1" d="M0,32L48,37.3C96,43,192,53,288,90.7C384,128,480,192,576,186.7C672,181,768,107,864,101.3C960,96,1056,160,1152,170.7C1248,181,1344,139,1392,117.3L1440,96L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat bottom;
                background-size: cover;
                opacity: 0.1;
                pointer-events: none;
            }

            .footer-content {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 40px;
                padding: 0 40px;
                max-width: 1400px;
                margin: 0 auto;
                position: relative;
                z-index: 1;
            }

            .footer-section {
                background: rgba(255, 255, 255, 0.05);
                border-radius: 20px;
                padding: 30px;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.1);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .footer-section::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1), transparent);
                transform: translateX(-100%);
                transition: 0.5s;
            }

            .footer-section:hover::before {
                transform: translateX(100%);
            }

            .footer-section:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
                border-color: rgba(255, 255, 255, 0.2);
            }

            .footer-section h3 {
                display: flex;
                align-items: center;
                gap: 12px;
                color: #fff;
                font-size: 1.6rem;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 2px solid rgba(255, 255, 255, 0.2);
                position: relative;
            }

            .footer-section h3 i {
                background: rgba(255, 255, 255, 0.1);
                padding: 10px;
                border-radius: 50%;
                font-size: 1.2rem;
                transition: all 0.3s ease;
            }

            .footer-section:hover h3 i {
                background: #4CAF50;
                transform: rotate(360deg);
            }

            .footer-section h3::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 50px;
                height: 2px;
                background: #4CAF50;
                transition: width 0.3s ease;
            }

            .footer-section:hover h3::after {
                width: 100%;
            }

            .footer-section ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .footer-section ul li {
                display: flex;
                align-items: center;
                gap: 15px;
                padding: 15px;
                margin-bottom: 15px;
                background: rgba(255, 255, 255, 0.08);
                border-radius: 12px;
                transition: all 0.3s ease;
                cursor: pointer;
                position: relative;
                overflow: hidden;
            }

            .footer-section ul li::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 3px;
                height: 100%;
                background: #4CAF50;
                transform: scaleY(0);
                transition: transform 0.3s ease;
            }

            .footer-section ul li:hover::before {
                transform: scaleY(1);
            }

            .footer-section ul li:hover {
                background: rgba(255, 255, 255, 0.15);
                transform: translateX(10px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                padding-left: 20px;
            }

            .footer-section ul li i {
                width: 35px;
                height: 35px;
                display: flex;
                align-items: center;
                justify-content: center;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 50%;
                font-size: 1.1rem;
                transition: all 0.3s ease;
            }

            .footer-section ul li:hover i {
                background: #4CAF50;
                color: white;
                transform: rotate(360deg);
            }

            .footer-bottom {
                background: rgba(0, 0, 0, 0.3);
                text-align: center;
                padding: 25px 0;
                margin-top: 60px;
                position: relative;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
            }

            .footer-bottom::before {
                content: '';
                position: absolute;
                top: -1px;
                left: 50%;
                transform: translateX(-50%);
                width: 80%;
                height: 1px;
                background: linear-gradient(to right, 
                    transparent, 
                    rgba(255, 255, 255, 0.5), 
                    transparent
                );
            }

            .footer-bottom p {
                color: rgba(255, 255, 255, 0.8);
                font-size: 0.9rem;
                letter-spacing: 1.5px;
                margin: 0;
                text-transform: uppercase;
                font-weight: 300;
                position: relative;
                display: inline-block;
            }

            .footer-bottom p::after {
                content: '';
                position: absolute;
                bottom: -5px;
                left: 0;
                width: 100%;
                height: 1px;
                background: #4CAF50;
                transform: scaleX(0);
                transition: transform 0.3s ease;
            }

            .footer-bottom p:hover::after {
                transform: scaleX(1);
            }

            @media (max-width: 768px) {
                .footer {
                    padding: 60px 0 0;
                }
                
                .footer-content {
                    grid-template-columns: 1fr;
                    gap: 30px;
                    padding: 0 20px;
                }
                
                .footer-section {
                    padding: 20px;
                }
                
                .footer-section h3 {
                    font-size: 1.3rem;
                }
                
                .footer-section ul li {
                    padding: 12px;
                    margin-bottom: 10px;
                }
                
                .footer-bottom p {
                    font-size: 0.8rem;
                }
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
        %>
        <div class="container">
            <h2>Report Summary</h2>


            <!-- Search Form -->
            <form action="ReportController" method="GET" class="search-box">
                <input type="text" name="centerID" placeholder="Enter Center ID...">
                <input type="date" name="reportDate">
                <button type="submit">Search</button>
            </form>

            <%
                List<ReportDTO> reportList = (List<ReportDTO>) request.getAttribute("reportList");
                if (reportList != null && !reportList.isEmpty()) {
            %>
            <table>
                <tr>
                    <th>Report ID</th>
                    <th>Center ID</th>
                    <th>Report Date</th>
                    <th>Total Appointments</th>
                    <th>Total Revenue</th>
                </tr>
                <%
                    for (ReportDTO report : reportList) {
                %>
                <tr>
                    <td><%= report.getReportID()%></td>
                    <td><%= report.getCenterID()%></td>
                    <td><%= report.getReportDate()%></td>
                    <td><%= report.getTotalAppointments()%></td>
                    <td>$<%= report.getTotalRevenue()%></td>
                </tr>
                <%
                    }
                %>
            </table>
            <%
            } else {
            %>
            <p style="color: red;">No reports available.</p>
            <%
                }
            %>
        </div>
        <a href="admin.jsp">Back to admin page</a>
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
    </body>
</html>
