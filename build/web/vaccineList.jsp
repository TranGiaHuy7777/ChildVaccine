<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="vaccine.VaccineDTO"%>
<%@page import="vaccine.VaccineDAO"%>
<%@page import="java.util.List"%>
<%@page import="customer.CustomerDTO"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Vaccine</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #f0f2f5;
                padding: 20px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
            }

            .header {
                background: #fff;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .vaccine-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 20px;
            }

            .vaccine-card {
                background: white;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
            }

            .vaccine-card:hover {
                transform: translateY(-5px);
            }

            .vaccine-name {
                font-size: 1.2em;
                color: #1e88e5;
                margin-bottom: 10px;
            }

            .vaccine-description {
                color: #666;
                margin-bottom: 15px;
            }

            .vaccine-price {
                font-weight: bold;
                color: #2e7d32;
                margin-bottom: 10px;
            }

            .buy-button {
                display: inline-block;
                padding: 10px 20px;
                background: #1e88e5;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                transition: background 0.3s ease;
            }

            .buy-button:hover {
                background: #1565c0;
            }

            .search-box {
                margin-bottom: 20px;
            }

            .search-input {
                padding: 10px;
                width: 100%;
                max-width: 300px;
                border: 1px solid #ddd;
                border-radius: 5px;
                margin-right: 10px;
            }

            *{
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

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            /* Hero Section */
            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880385.jpg');
                background-size: cover;
                background-position: center;
                padding: 100px 0;
                text-align: center;
                color: white;margin-bottom: 40px;
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
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            }

            .hero-subtitle {
                font-size: 1.2em;
                margin-bottom: 30px;
                text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
            }

            /* Stats Section */
            .stats-section {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                margin: 40px 0;
            }
            .stat-card {
                background: white;
                padding: 20px;
                border-radius: 10px;
                text-align: center;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .stat-number {
                font-size: 2em;
                font-weight: 700;
                color: #1e88e5;
                margin-bottom: 10px;
            }

            .stat-label {
                color: #666;
                font-size: 0.9em;
            }

            /* Vaccine Cards */
            .vaccine-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 20px;
            }
            .vaccine-card {
                background: white;
                border-radius: 15px;
                padding: 20px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
                overflow: hidden;
            }

            .vaccine-card:hover {
                transform: translateY(-5px);
            }

            .vaccine-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 10px;
                margin-bottom: 15px;
            }

            .vaccine-name {
                font-size: 1.2em;
                font-weight: 600;
                color: #1e88e5;
                margin-bottom: 10px;
            }
            .vaccine-info {
                margin-bottom: 15px;
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

            .search-section {
                background: white;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .search-input {
                width: 100%;
                padding: 12px 20px;
                font-size: 16px;
                border: 2px solid #e0e0e0;
                border-radius: 25px;
                transition: all 0.3s ease;
            }

            .search-input:focus {
                border-color: #1e88e5;
                outline: none;
                box-shadow: 0 0 0 3px rgba(30,136,229,0.1);
            }

            .no-results {
                text-align: center;
                padding: 40px;
                background: white;
                border-radius: 10px;
                margin: 20px 0;
                color: #666;
            }

            .no-results i {
                font-size: 3em;
                color: #ccc;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <!-- Hero Section -->
                <div class="hero-section">
                    <div class="hero-content">
                        <h1 class="hero-title">Danh Sách Vaccine</h1>
                        <p class="hero-subtitle">Chọn vaccine phù hợp cho bé yêu của bạn</p>
                    </div>
                </div>

                <h1>Danh sách Vaccine</h1>
                <p>Chọn vaccine phù hợp cho trẻ</p>
            </div>

            <!-- Stats Section -->
            <div class="stats-section">
                <div class="stat-card">
                    <div class="stat-number">1000+</div>
                    <div class="stat-label">Khách Hàng Tin Tưởng</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">50+</div>
                    <div class="stat-label">Loại Vaccine</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">99%</div>
                    <div class="stat-label">Độ An Toàn</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">24/7</div>
                    <div class="stat-label">Hỗ Trợ Y Tế</div>
                </div>
            </div>

            <!-- Search Box -->
            <div class="search-section">
                <input type="text" class="search-input" placeholder="Tìm kiếm vaccine...">
            </div>



            <!-- Vaccine Grid -->
            <div class="vaccine-grid">
                <%
                    VaccineDAO vaccineDAO = new VaccineDAO();
                    List<VaccineDTO> vaccines = vaccineDAO.getAllVaccines();

                    for (VaccineDTO vaccine : vaccines) {
                %>
                <div class="vaccine-card">
                    <img src="https://img.freepik.com/free-photo/vaccine-bottles-arrangement_23-2149079681.jpg" 
                         alt="Vaccine Image" 
                         class="vaccine-image">
                    <h3 class="vaccine-name"><%= vaccine.getVaccineName()%></h3>
                    <div class="vaccine-info">
                        <p><%= vaccine.getDescription()%></p>
                        <p class="price">
                            <i class="fas fa-tag"></i>
                            Giá: <%= String.format("%,.0f VNĐ", vaccine.getPrice())%>
                        </p>
                    </div>
                    <a href="BookVaccineController?vaccineId=<%= vaccine.getVaccineID()%>" class="book-button">
                        <i class="fas fa-shopping-cart"></i> Đặt mua
                    </a>
                </div>
                <% }%>
            </div>
        </div>







        <script>
            // Implement search functionality
            const searchInput = document.querySelector('.search-input');
            const vaccineCards = document.querySelectorAll('.vaccine-card');
            let hasResults = false;


            // Remove existing no-results message
            const existingNoResults = document.querySelector('.no-results');
            if (existingNoResults) {
                existingNoResults.remove();
            }


            // Add removeAccents function
            function removeAccents(str) {
                return str.normalize('NFD')
                        .replace(/[\u0300-\u036f]/g, '')
                        .replace(/đ/g, 'd')
                        .replace(/Đ/g, 'D');
            }
            searchInput.addEventListener('input', function (e) {
                const searchTerm = e.target.value.toLowerCase();

                vaccineCards.forEach(card => {
                    const vaccineName = card.querySelector('.vaccine-name').textContent.toLowerCase();
                    const vaccineDesc = card.querySelector('.vaccine-info').textContent.toLowerCase();

                    if (vaccineName.includes(searchTerm) || vaccineDesc.includes(searchTerm)) {
                        card.style.display = '';
                        hasResults = true;

                    } else {
                        card.style.display = 'none';
                    }
                });

                // Show no results message
                const noResults = document.querySelector('.no-results');
                if (!hasResults) {
                    if (!noResults) {
                        const message = document.createElement('div');
                        message.className = 'no-results';
                        message.innerHTML = `
                    <i class="fas fa-search"></i>
                    <p>Không tìm thấy kết quả cho "${searchTerm}"</p>
                `;
                        document.querySelector('.vaccine-grid').before(message);
                    }
                } else if (noResults) {
                    noResults.remove();
                }
            });
        </script>
    </body>
</html>