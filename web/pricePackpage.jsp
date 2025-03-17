<%-- Document : pricePackpage Created on : Feb 23, 2025, 8:22:53 PM Author : Windows --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Vaccine Pricing</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
            <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap"
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

                .hero-section {
                    background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
                        url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880385.jpg?w=1380');
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

                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 20px;
                }

                .section-title {
                    font-size: 26px;
                    color: #1a237e;
                    margin: 40px 0 20px;
                    font-weight: 600;
                    text-align: center;
                    position: relative;
                    padding-bottom: 15px;
                }

                .section-title:after {
                    content: '';
                    position: absolute;
                    bottom: 0;
                    left: 50%;
                    transform: translateX(-50%);
                    width: 120px;
                    height: 3px;
                    background: linear-gradient(90deg, #0396FF, #ABDCFF);
                    border-radius: 2px;
                }

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
                    background-color: white;
                    padding: 18px;
                    font-size: 16px;
                    border-bottom: 1px solid #eee;
                    transition: all 0.3s ease;
                }

                tr:last-child td {
                    border-bottom: none;
                }

                tr:hover td {
                    background-color: #f8f9fa;
                }

                .back-btn {
                    display: block;
                    width: fit-content;
                    padding: 15px 40px;
                    background: linear-gradient(135deg, #0396FF, #ABDCFF);
                    color: white;
                    font-size: 18px;
                    font-weight: 500;
                    text-decoration: none;
                    border-radius: 50px;
                    margin: 40px auto;
                    transition: transform 0.2s ease;
                    box-shadow: 0 5px 15px rgba(3, 150, 255, 0.3);
                }

                .back-btn:hover {
                    transform: translateY(-3px);
                }

                @media (max-width: 768px) {
                    .container {
                        width: 95%;
                        padding: 20px;
                    }

                    table {
                        font-size: 14px;
                    }

                    th,
                    td {
                        padding: 12px;
                    }

                    .section-title {
                        font-size: 22px;
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
            </style>
        </head>

        <body>
            <div class="hero-section">
                <div class="hero-content">
                    <h1 class="hero-title">Vaccine Pricing Packages</h1>
                    <p class="hero-subtitle">Find the best vaccination packages for your child</p>
                </div>
            </div>

            <div class="container">
                <!-- Gói Tiêm Lẻ -->
                <div class="section-title">Gói Tiêm Lẻ</div>
                <table>
                    <tr>
                        <th>Vaccine Name</th>
                        <th>Description</th>
                        <th>Price (VNĐ)</th>
                        <th>Recommended Age</th>
                    </tr>
                    <tr>
                        <td>Vaccine bạch hầu</td>
                        <td>Phòng ngừa bệnh bạch hầu</td>
                        <td>500,000</td>
                        <td>2 tháng trở lên</td>
                    </tr>
                    <tr>
                        <td>Vaccine uốn ván</td>
                        <td>Phòng chống bệnh uốn ván</td>
                        <td>450,000</td>
                        <td>2 tháng trở lên</td>
                    </tr>
                    <tr>
                        <td>Vaccine ho gà</td>
                        <td>Phòng ngừa bệnh ho gà</td>
                        <td>400,000</td>
                        <td>2 tháng trở lên</td>
                    </tr>
                    <tr>
                        <td>Vaccine viêm gan B</td>
                        <td>Phòng bệnh viêm gan B</td>
                        <td>550,000</td>
                        <td>2 tháng trở lên</td>
                    </tr>
                    <tr>
                        <td>Vaccine quai bị</td>
                        <td>Phòng bệnh quai bị</td>
                        <td>600,000</td>
                        <td>1 tuổi trở lên</td>
                    </tr>
                </table>

                <!-- Gói Trọn Gói -->
                <div class="section-title">Gói Trọn Gói</div>
                <table>
                    <tr>
                        <th>Package Name</th>
                        <th>Included Vaccines</th>
                        <th>Price (VNĐ)</th>
                        <th>Recommended Age</th>
                    </tr>
                    <tr>
                        <td>Gói Vaccine Sơ Sinh</td>
                        <td>Viêm gan B, Lao (BCG), Rotavirus</td>
                        <td>3,000,000</td>
                        <td>0 - 6 tháng</td>
                    </tr>
                    <tr>
                        <td>Gói Vaccine 6 Tháng</td>
                        <td>Bạch hầu, ho gà, uốn ván, viêm phổi</td>
                        <td>7,000,000</td>
                        <td>6 tháng trở lên</td>
                    </tr>
                    <tr>
                        <td>Gói Vaccine 1 Tuổi</td>
                        <td>Quai bị, sởi, rubella, viêm gan A</td>
                        <td>10,000,000</td>
                        <td>1 tuổi trở lên</td>
                    </tr>
                </table>

                <!-- Gói Cá Nhân Hóa -->
                <div class="section-title">Gói Cá Nhân Hóa</div>
                <table>
                    <tr>
                        <th>Package Type</th>
                        <th>Description</th>
                        <th>Price</th>
                    </tr>
                    <tr>
                        <td>Gói Cá Nhân Hóa</td>
                        <td>Chọn vaccine theo nhu cầu cá nhân.</td>
                        <td>Tư vấn & báo giá riêng</td>
                    </tr>
                </table>

                <a href="vaccinationSchedule.jsp" class="back-btn">Back to Home</a>
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
        </body>

        </html>