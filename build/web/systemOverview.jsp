<%@page import="java.util.List"%>
<%@page import="appointment.AppointmentStatisticsDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.TreeSet" %>
<%
    // Lấy dữ liệu từ Controller (đã setAttribute trước khi forward)
    Integer year = (Integer) request.getAttribute("YEAR");
    // Injection và Revenue map truyền từ controller
    Map<Integer, Integer> injectionMap = (Map<Integer, Integer>) request.getAttribute("INJECTION_MAP");
    Map<Integer, Double> revenueMap = (Map<Integer, Double>) request.getAttribute("REVENUE_MAP");
    // Dữ liệu người dùng mới theo tổng số (sử dụng bar chart riêng)
    Integer totalNewUsers = (Integer) request.getAttribute("TOTAL_NEW_USERS");
    if(totalNewUsers == null) {
        totalNewUsers = 0;
    }
    // Bộ lọc theo quý (0: tất cả, 1: Q1, 2: Q2, 3: Q3, 4: Q4)
    Integer quarter = (Integer) request.getAttribute("QUARTER");
    if(quarter == null) quarter = 0;
    
    // Phân trang cho bảng chi tiết thống kê
    Integer currentPage = (Integer) request.getAttribute("CURRENT_PAGE");
    Integer totalPages = (Integer) request.getAttribute("TOTAL_PAGES");
    if(currentPage == null) currentPage = 1;
    if(totalPages == null) totalPages = 1;

    // Dữ liệu chi tiết thống kê (nếu có)
     List<AppointmentStatisticsDTO> detailedStats = (List<AppointmentStatisticsDTO>) request.getAttribute("DETAILED_STATS");
    
    // Tạo tập hợp tháng từ 1 đến 12
    Set<Integer> allMonths = new TreeSet<>();
    for(int m = 1; m <= 12; m++){
        allMonths.add(m);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>System Overview</title>
    <!-- Font Awesome & Google Font -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.2/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { margin: 0; font-family: 'Poppins', sans-serif; background-color: #f0f2f5; }
        /* Navbar */
        .navbar { background-color: #1e88e5; color: white; display: flex; justify-content: space-between; align-items: center; padding: 15px 20px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
        .navbar .nav-left { font-size: 1.2em; font-weight: 500; }
        .navbar .nav-right { display: flex; align-items: center; }
        .logout-button { padding: 10px 15px; background: #f44336; border: none; border-radius: 5px; cursor: pointer; color: white; margin-left: 15px; transition: background 0.3s; }
        .logout-button:hover { background: #d32f2f; }
        /* Loader */
        #loader {
            display: none;
            position: fixed;
            z-index: 999;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(255,255,255,0.8);
        }
        #loader .spinner {
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            border: 8px solid #f3f3f3;
            border-top: 8px solid #1e88e5;
            border-radius: 50%;
            width: 60px; height: 60px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        /* Container */
        .container { width: 90%; max-width: 1200px; margin: 20px auto; }
        .overview-title { text-align: center; margin: 20px 0; color: #333; font-size: 28px; font-weight: 600; }
        .chart-container { display: flex; flex-wrap: wrap; gap: 20px; justify-content: center; }
        .chart-box { background: white; border-radius: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); padding: 20px; width: 350px; height: 350px; }
        .chart-box h3 { text-align: center; margin-bottom: 15px; font-size: 18px; color: #555; }
        @media (max-width: 768px) { .chart-box { width: 90%; margin: 0 auto; height: auto; } }
        /* Year & Quarter Selection */
        .filter-selection { text-align: center; margin-bottom: 20px; }
        .filter-selection form { display: inline-block; }
        .filter-selection select, .filter-selection button { padding: 8px; font-size: 14px; margin-right: 5px; }
        .filter-selection button { cursor: pointer; background: #1e88e5; color: white; border: none; border-radius: 4px; transition: background 0.3s; }
        .filter-selection button:hover { background: #1565c0; }
        /* Detailed Table */
        .detailed-table { width: 100%; border-collapse: collapse; margin-top: 30px; }
        .detailed-table th, .detailed-table td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        .detailed-table th { background: #f2f2f2; }
        .pagination { text-align: center; margin-top: 15px; }
        .pagination a { margin: 0 5px; text-decoration: none; color: #1e88e5; }
        .export-btn { margin-top: 20px; display: block; text-align: center; }
        .export-btn a { padding: 10px 15px; background: #388e3c; color: white; text-decoration: none; border-radius: 5px; transition: background 0.3s; }
        .export-btn a:hover { background: #2e7d32; }
    </style>
    <script>
        // Khi gửi form, hiển thị loader
        function showLoader() {
            document.getElementById('loader').style.display = 'block';
        }
    </script>
</head>
<body>
    <!-- Loader -->
    <div id="loader"><div class="spinner"></div></div>
    <!-- Navbar -->
    <div class="navbar">
        <div class="nav-left"><i class="fas fa-chart-line"></i> System Overview</div>
        <div class="nav-right">
            <form action="MainController" method="POST" style="display:inline;">
                <button type="submit" name="action" value="Logout" class="logout-button">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </button>
            </form>
        </div>
    </div>
    <div class="container">
        <h2 class="overview-title">Tổng quan hệ thống</h2>
        <!-- Bộ lọc: Chọn năm và quý -->
        <div class="filter-selection">
            <form action="StatisticsController" method="GET" onsubmit="showLoader();">
                <label>Năm:</label>
                <select name="year">
                    <%
                        int currentYear = java.time.Year.now().getValue();
                        for (int y = currentYear - 2; y <= currentYear + 2; y++) {
                    %>
                        <option value="<%= y %>" <%= (year != null && year == y) ? "selected" : "" %>><%= y %></option>
                    <%
                        }
                    %>
                </select>
                <label>Quý:</label>
                <select name="quarter">
                    <option value="0" <%= (quarter == 0) ? "selected" : "" %>>Tất cả</option>
                    <option value="1" <%= (quarter == 1) ? "selected" : "" %>>Quý 1</option>
                    <option value="2" <%= (quarter == 2) ? "selected" : "" %>>Quý 2</option>
                    <option value="3" <%= (quarter == 3) ? "selected" : "" %>>Quý 3</option>
                    <option value="4" <%= (quarter == 4) ? "selected" : "" %>>Quý 4</option>
                </select>
                <button type="submit">Xem</button>
            </form>
            <!-- Nút Export CSV -->
            <div class="export-btn">
                <a href="StatisticsExportController?year=<%= year %>&quarter=<%= quarter %>">Export CSV</a>
            </div>
        </div>
        <!-- Biểu đồ -->
        <div class="chart-container">
            <div class="chart-box">
                <h3>Mũi tiêm đã thực hiện</h3>
                <canvas id="injectionsChart"></canvas>
            </div>
            <div class="chart-box">
                <h3>Người dùng mới</h3>
                <canvas id="usersChart"></canvas>
            </div>
            <div class="chart-box">
                <h3>Doanh thu</h3>
                <canvas id="revenueChart"></canvas>
            </div>
        </div>

        <!-- Bảng thống kê chi tiết (nếu có dữ liệu) -->

        <%          
            if(detailedStats != null && !detailedStats.isEmpty()){
        %>
        <h3 style="text-align:center; margin-top:30px;">Bảng thống kê chi tiết</h3>
        <table class="detailed-table">
            <tr>
                <th>STT</th>
                <th>Ngày hẹn</th>
                <th>Số mũi tiêm</th>
                <th>Doanh thu</th>
            </tr>
            <%
                int stt = 1;
                for (AppointmentStatisticsDTO stat : detailedStats){
                    // Giả sử mỗi object có 3 thuộc tính: appointmentDate, injectionCount, revenue
                    // Bạn cần ép kiểu về lớp thích hợp (ví dụ: StatisticDetail) để truy xuất các giá trị
            %>
            <tr>
                <td><%= stt++ %></td>
                <td><%=stat.getAppointmentDate() %></td>
                <td><%=stat.getInjectionCount() %></td>
                <td><%=stat.getRevenue() %></td>
            </tr>
            <%
                }
            %>
        </table>

        <!-- Phân trang đơn giản -->
        <div class="pagination">
            <% if(currentPage > 1){ %>
                <a href="StatisticsController?year=<%= year %>&quarter=<%= quarter %>&page=<%= currentPage - 1 %>">&laquo; Prev</a>
            <% } %>
            <span>Trang <%= currentPage %> / <%= totalPages %></span>
            <% if(currentPage < totalPages){ %>
                <a href="StatisticsController?year=<%= year %>&quarter=<%= quarter %>&page=<%= currentPage + 1 %>">Next &raquo;</a>
            <% } %>
        </div>
        <%
            }
        %>
    </div>
    <!-- Script Chart.js -->
    <script>
        const labels = [1,2,3,4,5,6,7,8,9,10,11,12];
        const injectionDataMap = {
            <% for(Integer m : allMonths) {
                 Integer val = (injectionMap != null && injectionMap.containsKey(m)) ? injectionMap.get(m) : 0;
                 out.print(m + ":" + val + ",");
            } %>
        };
        const revenueDataMap = {
            <% for(Integer m : allMonths) {
                 Double val = (revenueMap != null && revenueMap.containsKey(m)) ? revenueMap.get(m) : 0.0;
                 out.print(m + ":" + val + ",");
            } %>
        };
        const injections = labels.map(m => injectionDataMap[m] || 0);
        const revenues = labels.map(m => revenueDataMap[m] || 0);
        // Biểu đồ mũi tiêm
        new Chart(document.getElementById('injectionsChart').getContext('2d'), {
            type: 'bar',
            data: {
                labels: labels.map(m => "Tháng " + m),
                datasets: [{
                    label: 'Mũi tiêm',
                    data: injections,
                    backgroundColor: 'rgba(54, 162, 235, 0.5)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: { responsive: true, scales: { y: { beginAtZero: true } } }
        });
        // Biểu đồ người dùng mới
        new Chart(document.getElementById('usersChart').getContext('2d'), {
            type: 'bar',
            data: {
                labels: ["Tổng số"],
                datasets: [{
                    label: 'Người dùng mới',
                    data: [<%= totalNewUsers %>],
                    backgroundColor: 'rgba(255, 206, 86, 0.5)',
                    borderColor: 'rgba(255, 206, 86, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: { y: { beginAtZero: true, suggestedMax: 100, ticks: { stepSize: 50 } } }
            }
        });
        // Biểu đồ doanh thu
        new Chart(document.getElementById('revenueChart').getContext('2d'), {
            type: 'line',
            data: {
                labels: labels.map(m => "Tháng " + m),
                datasets: [{
                    label: 'Doanh thu (triệu VNĐ)',
                    data: revenues,
                    backgroundColor: 'rgba(75, 192, 192, 0.5)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 2,
                    fill: true
                }]
            },
            options: { responsive: true, scales: { y: { beginAtZero: true } } }
        });
    </script>
</body>
</html>