<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.List" %>
<%@page import="appointment.AppointmentStatisticsDTO" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Set" %>
<%@page import="java.util.TreeSet" %>
<%
    // Lấy dữ liệu từ Controller (set qua setAttribute trước khi forward)
    Integer year = (Integer) request.getAttribute("YEAR");
    Map<Integer, Integer> injectionMap = (Map<Integer, Integer>) request.getAttribute("INJECTION_MAP");
    Map<Integer, Double> revenueMap = (Map<Integer, Double>) request.getAttribute("REVENUE_MAP");
    Integer totalNewUsers = (Integer) request.getAttribute("TOTAL_NEW_USERS");
    if(totalNewUsers == null) { totalNewUsers = 0; }
    
    Integer quarter = (Integer) request.getAttribute("QUARTER");
    if(quarter == null) quarter = 0;
    
    Integer currentPage = (Integer) request.getAttribute("CURRENT_PAGE");
    Integer totalPages = (Integer) request.getAttribute("TOTAL_PAGES");
    if(currentPage == null) currentPage = 1;
    if(totalPages == null) totalPages = 1;
    
    List<AppointmentStatisticsDTO> detailedStats = (List<AppointmentStatisticsDTO>) request.getAttribute("DETAILED_STATS");
    
    // Tạo tập hợp tháng từ 1 đến 12
    Set<Integer> allMonths = new TreeSet<>();
    for (int m = 1; m <= 12; m++) {
        allMonths.add(m);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>System Overview</title>
    <!-- Font Awesome & Google Fonts -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.2/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Global */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f0f2f5, #ffffff);
            color: #333;
        }
        /* Navbar */
        .navbar {
            background: linear-gradient(90deg, #1e88e5, #1565c0);
            color: #fff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            box-shadow: 0 3px 6px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar .nav-left { font-size: 1.3em; font-weight: 600; }
        .navbar .nav-right { display: flex; align-items: center; }
        .logout-button {
            padding: 10px 15px;
            background: #f44336;
            border: none;
            border-radius: 5px;
            color: #fff;
            cursor: pointer;
            margin-left: 15px;
            transition: background 0.3s ease;
        }
        .logout-button:hover { background: #d32f2f; }
        /* Loader */
        #loader {
            display: none;
            position: fixed;
            z-index: 999;
            top: 0; left: 0;
            width: 100%; height: 100%;
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
        @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
        /* Container */
        .container { width: 90%; max-width: 1200px; margin: 20px auto; }
        .overview-title {
            text-align: center;
            margin: 20px 0;
            font-size: 30px;
            font-weight: 600;
            color: #333;
        }
        /* Back to Admin Button */
        .back-admin-btn {
            display: block;
            margin: 20px auto;
            padding: 12px 25px;
            background: linear-gradient(90deg, #1e88e5, #1565c0);
            color: #fff;
            text-decoration: none;
            text-align: center;
            border-radius: 30px;
            font-size: 1em;
            width: 220px;
            transition: background 0.3s, transform 0.3s;
        }
        .back-admin-btn:hover {
            background: #1565c0;
            transform: translateY(-3px);
        }
        /* Filter Selection */
        .filter-selection {
            text-align: center;
            margin-bottom: 20px;
        }
        .filter-selection form { display: inline-block; }
        .filter-selection select,
        .filter-selection button {
            padding: 8px;
            font-size: 14px;
            margin-right: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .filter-selection button {
            background: #1e88e5;
            color: #fff;
            border: none;
            cursor: pointer;
            transition: background 0.3s;
        }
        .filter-selection button:hover { background: #1565c0; }
        /* Chart Container */
        .chart-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
            margin-bottom: 30px;
        }
        .chart-box {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 20px;
            width: 350px;
            height: 350px;
            transition: transform 0.3s ease;
        }
        .chart-box:hover { transform: translateY(-5px); }
        .chart-box h3 {
            text-align: center;
            margin-bottom: 15px;
            font-size: 20px;
            color: #555;
        }
        @media (max-width: 768px) { .chart-box { width: 90%; margin: 0 auto; height: auto; } }
        /* Detailed Table */
        .detailed-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
        }
        .detailed-table th,
        .detailed-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        .detailed-table th { background: #f2f2f2; }
        .pagination {
            text-align: center;
            margin-top: 15px;
        }
        .pagination a {
            margin: 0 5px;
            text-decoration: none;
            color: #1e88e5;
        }
        /* Container cho bộ lọc và nút Export */
.filter-container {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: center;
    gap: 15px;
    margin-bottom: 20px;
}

/* Bộ lọc */
.filter-form select,
.filter-form button {
    padding: 8px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 4px;
    margin-right: 5px;
}
.filter-form button {
    background: #1e88e5;
    color: #fff;
    border: none;
    cursor: pointer;
    transition: background 0.3s;
}
.filter-form button:hover {
    background: #1565c0;
}

/* Nút Export CSV kiểu "Back to Admin" */
.export-btn a {
    display: inline-block;
    padding: 12px 25px;
    background: linear-gradient(90deg, #1e88e5, #1565c0);
    color: #fff;
    text-decoration: none;
    text-align: center;
    border-radius: 30px;
    font-size: 1em;
    transition: background 0.3s, transform 0.3s;
}
.export-btn a:hover {
    background: #1565c0;
    transform: translateY(-3px);
}

        
    </style>
    <script>
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
    <!-- Back to Admin Button -->
    <div class="container">
        <a href="admin.jsp" class="back-admin-btn"><i class="fas fa-arrow-left"></i> Back to Admin</a>
    </div>
    <div class="container">
        <h2 class="overview-title">System Overview</h2>
        <!-- Filter Selection: Year & Quarter -->
<div class="filter-container">
    <form action="StatisticsController" method="GET" onsubmit="showLoader();" class="filter-form">
        <label>Year:</label>
        <select name="year">
            <%
                int currentYearVal = java.time.Year.now().getValue();
                for (int y = currentYearVal - 2; y <= currentYearVal + 2; y++) {
            %>
                <option value="<%= y %>" <%= (year != null && year == y) ? "selected" : "" %>><%= y %></option>
            <%
                }
            %>
        </select>
        <label>Quarter:</label>
        <select name="quarter">
            <option value="0" <%= (quarter == 0) ? "selected" : "" %>>All</option>
            <option value="1" <%= (quarter == 1) ? "selected" : "" %>>Q1</option>
            <option value="2" <%= (quarter == 2) ? "selected" : "" %>>Q2</option>
            <option value="3" <%= (quarter == 3) ? "selected" : "" %>>Q3</option>
            <option value="4" <%= (quarter == 4) ? "selected" : "" %>>Q4</option>
        </select>
        <button type="submit">View</button>
    </form>
    <!-- Nút Export CSV hiện đại -->
    <div class="export-btn">
        <a href="StatisticsExportController?year=<%= year %>&quarter=<%= quarter %>">Export CSV</a>
    </div>
</div>

        <!-- Charts -->
        <div class="chart-container">
            <div class="chart-box">
                <h3>Injections Performed</h3>
                <canvas id="injectionsChart"></canvas>
            </div>
            <div class="chart-box">
                <h3>New Users</h3>
                <canvas id="usersChart"></canvas>
            </div>
            <div class="chart-box">
                <h3>Revenue (million VND)</h3>
                <canvas id="revenueChart"></canvas>
            </div>
        </div>
<%
    if(detailedStats != null && !detailedStats.isEmpty()){
%>
        <h3 style="text-align:center; margin-top:30px;">Detailed Statistics</h3>
        <table class="detailed-table">
            <tr>
                <th>No.</th>
                <th>Appointment Date</th>
                <th>Revenue</th>
            </tr>
            <%
                int stt = 1;
                for (AppointmentStatisticsDTO stat : detailedStats){
            %>
            <tr>
                <td><%= stt++ %></td>
                <td><%= stat.getAppointmentDate() %></td>
                <td><%= stat.getRevenue() %></td>
            </tr>
            <%
                }
            %>
        </table>
        <div class="pagination">
            <% if(currentPage > 1){ %>
                <a href="StatisticsController?year=<%= year %>&quarter=<%= quarter %>&page=<%= currentPage - 1 %>">&laquo; Prev</a>
            <% } %>
            <span>Page <%= currentPage %> / <%= totalPages %></span>
            <% if(currentPage < totalPages){ %>
                <a href="StatisticsController?year=<%= year %>&quarter=<%= quarter %>&page=<%= currentPage + 1 %>">Next &raquo;</a>
            <% } %>
        </div>
<%
    }
%>
    </div>
    <!-- Chart.js Script -->
    <script>
        const labels = [1,2,3,4,5,6,7,8,9,10,11,12];
        const injectionDataMap = {
            <% for (Integer m : allMonths) {
                 Integer val = (injectionMap != null && injectionMap.containsKey(m)) ? injectionMap.get(m) : 0;
                 out.print(m + ":" + val + ",");
            } %>
        };
        const revenueDataMap = {
            <% for (Integer m : allMonths) {
                 Double val = (revenueMap != null && revenueMap.containsKey(m)) ? revenueMap.get(m) : 0.0;
                 out.print(m + ":" + val + ",");
            } %>
        };
        const injections = labels.map(m => injectionDataMap[m] || 0);
        const revenues = labels.map(m => revenueDataMap[m] || 0);
        
        // Injections Chart (Bar)
        new Chart(document.getElementById('injectionsChart').getContext('2d'), {
            type: 'bar',
            data: {
                labels: labels.map(m => "Month " + m),
                datasets: [{
                    label: 'Injections',
                    data: injections,
                    backgroundColor: 'rgba(54, 162, 235, 0.5)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: { responsive: true, scales: { y: { beginAtZero: true } } }
        });
        // New Users Chart (Bar)
        new Chart(document.getElementById('usersChart').getContext('2d'), {
            type: 'bar',
            data: {
                labels: ["Total"],
                datasets: [{
                    label: 'New Users',
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
        // Revenue Chart (Line)
        new Chart(document.getElementById('revenueChart').getContext('2d'), {
            type: 'line',
            data: {
                labels: labels.map(m => "Month " + m),
                datasets: [{
                    label: 'Revenue (million VND)',
                    data: revenues,
                    backgroundColor: 'rgba(75, 192, 192, 0.5)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 2,
                    fill: true
                }]
            },
            options: { 
                responsive: true, 
                scales: { 
                    y: { 
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) { return value + " M"; },
                            stepSize: 1
                        }
                    }
                } 
            }
        });
    </script>
</body>
</html>
