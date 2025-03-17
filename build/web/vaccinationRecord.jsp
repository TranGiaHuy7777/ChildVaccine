<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DateFormatSymbols" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="utils.DBUtils" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vaccination Record - Full Year Calendar</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Global Styles */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #eef2f3, #8e9eab);
            color: #333;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            animation: fadeIn 1s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        h1, h2 {
            text-align: center;
            margin-bottom: 20px;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }
        h1 { font-size: 2.5em; }
        h2 { font-size: 1.8em; color: #1e88e5; }
        
        /* Back Button */
        .back-button {
            display: inline-block;
            padding: 12px 25px;
            background: linear-gradient(90deg, #4a90e2, #357ab7);
            color: #fff;
            text-decoration: none;
            border-radius: 30px;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .back-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.15);
        }
        
        /* Calendar Table */
        table.calendar {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
        }
        table.calendar th, table.calendar td {
            padding: 10px;
            border: 1px solid #ddd;
        }
        table.calendar th {
            background: #4a90e2;
            color: #fff;
            text-transform: uppercase;
            font-size: 13px;
        }
        table.calendar td {
            height: 100px;
            vertical-align: top;
            background: #fff;
            position: relative;
            transition: background 0.3s;
        }
        table.calendar td:hover {
            background: #f9f9f9;
        }
        .day-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            height: 100%;
            padding: 5px;
        }
        .day-number {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 5px;
            color: #4a4a4a;
        }
        .marker {
            display: inline-block;
            margin: 2px 0;
            padding: 4px 8px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 12px;
            transition: transform 0.3s, opacity 0.3s;
            cursor: pointer;
        }
        .marker:hover {
            transform: scale(1.1);
            opacity: 0.9;
        }
        .marker-x { background: #e74c3c; color: #fff; }
        .marker-remind { background: #f39c12; color: #fff; }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            animation: fadeInModal 0.5s ease forwards;
        }
        @keyframes fadeInModal {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .modal-content {
            background: #fff;
            margin: 10% auto;
            padding: 20px;
            width: 400px;
            border-radius: 10px;
            position: relative;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            animation: slideIn 0.5s ease;
        }
        @keyframes slideIn {
            from { transform: translateY(-30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .modal-close {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 22px;
            color: #888;
            cursor: pointer;
            transition: color 0.3s;
        }
        .modal-close:hover { color: #444; }
        .modal-body { margin-top: 20px; font-size: 14px; }
        .detail-item { margin-bottom: 10px; }
        .detail-item span { font-weight: bold; color: #333; }
        
        /* Alert Styles */
        .alert {
            padding: 15px;
            margin: 20px auto;
            border-radius: 4px;
            text-align: center;
            width: 80%;
            font-size: 16px;
        }
        .alert-danger {
            color: #721c24;
            background: #f8d7da;
        }
        .alert-success {
            color: #155724;
            background: #d4edda;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            table.calendar th, table.calendar td {
                font-size: 12px;
                padding: 8px;
            }
            .back-button {
                padding: 10px 20px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Vaccination Record - Full Year Calendar</h1>
    <a href="vaccinationSchedule.jsp" class="back-button">
        <i class="fas fa-arrow-left"></i> Back to Schedule
    </a>

    <%
        // 1) Get childID from URL
        String childIDParam = request.getParameter("childID");
        if (childIDParam == null || childIDParam.trim().isEmpty()) {
            out.println("<p style='text-align:center;color:red;'>Child information not found (missing childID).</p>");
            return;
        }
        int childID = Integer.parseInt(childIDParam);
        out.println("<!-- DEBUG: childID = " + childID + " -->");

        // 2) Get current year
        Calendar now = Calendar.getInstance();
        int currentYear = now.get(Calendar.YEAR);
        out.println("<!-- DEBUG: currentYear = " + currentYear + " -->");

        // 3) Prepare date format
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // 4) Define AppointmentDetail class with additional fields
        class AppointmentDetail {
            int appointmentID;
            String marker;         // "X" or "Vaccinated"
            String serviceType;
            String centerName;
            java.sql.Date appointmentDate;
            String diseaseName;
            String description;
            java.sql.Date diagnosisDate;
        }

        // 5) Structure: yearAppointments[month][day] = List<AppointmentDetail>
        Map<Integer, Map<Integer, List<AppointmentDetail>>> yearAppointments = new HashMap<>();
        for (int m = 1; m <= 12; m++) {
            yearAppointments.put(m, new HashMap<Integer, List<AppointmentDetail>>());
        }

        // 6) Query DB: get child's appointment info (including fields from tblDisease)
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            String sql = "SELECT a.appointmentID, a.appointmentDate, a.serviceType, " +
                         "       c.centerName, d.diseaseName, d.description, d.diagnosisDate " +
                         "FROM tblAppointments a " +
                         "JOIN tblCenters c ON a.centerID = c.centerID " +
                         "JOIN tblDisease d ON a.appointmentID = d.appointmentID " +
                         "WHERE YEAR(a.appointmentDate)=? AND a.childID=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, currentYear);
            ps.setInt(2, childID);
            rs = ps.executeQuery();

            // Calculate today's date (00:00)
            Calendar todayCal = Calendar.getInstance();
            todayCal.set(Calendar.HOUR_OF_DAY, 0);
            todayCal.set(Calendar.MINUTE, 0);
            todayCal.set(Calendar.SECOND, 0);
            todayCal.set(Calendar.MILLISECOND, 0);
            java.sql.Date todayDate = new java.sql.Date(todayCal.getTimeInMillis());
            out.println("<!-- DEBUG: todayDate = " + todayDate + " -->");

            int countAppointments = 0;
            while (rs.next()) {
                int appointmentID = rs.getInt("appointmentID");
                java.sql.Date appDate = rs.getDate("appointmentDate");
                String serviceType = rs.getString("serviceType");
                String centerName = rs.getString("centerName");
                String diseaseName = rs.getString("diseaseName");
                String description = rs.getString("description");
                java.sql.Date diagnosisDate = rs.getDate("diagnosisDate");
                countAppointments++;
                out.println("<!-- DEBUG: Found appointment => appointmentID=" + appointmentID 
                            + ", date=" + appDate
                            + ", serviceType=" + serviceType
                            + ", center=" + centerName
                            + ", diseaseName=" + diseaseName 
                            + ", description=" + description 
                            + ", diagnosisDate=" + diagnosisDate + " -->");

                Calendar appCal = Calendar.getInstance();
                appCal.setTime(appDate);
                int month = appCal.get(Calendar.MONTH) + 1;
                int day = appCal.get(Calendar.DAY_OF_MONTH);

                AppointmentDetail detail = new AppointmentDetail();
                detail.appointmentID = appointmentID;
                detail.serviceType = serviceType;
                detail.centerName = centerName;
                detail.appointmentDate = appDate;
                detail.diseaseName = diseaseName;
                detail.description = description;
                detail.diagnosisDate = diagnosisDate;
                if (appDate.before(todayDate)) {
                    detail.marker = "X";
                } else {
                    detail.marker = "Vaccinated";
                }

                Map<Integer, List<AppointmentDetail>> monthMap = yearAppointments.get(month);
                if (!monthMap.containsKey(day)) {
                    monthMap.put(day, new ArrayList<AppointmentDetail>());
                }
                monthMap.get(day).add(detail);
            }
            out.println("<!-- DEBUG: Total appointments found = " + countAppointments + " -->");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<!-- DEBUG: Error in query: " + e.getMessage() + " -->");
        } finally {
            if (rs != null) { try { rs.close(); } catch (Exception e) {} }
            if (ps != null) { try { ps.close(); } catch (Exception e) {} }
            if (conn != null) { try { conn.close(); } catch (Exception e) {} }
        }

        // 7) Display calendar for all 12 months
        for (int m = 1; m <= 12; m++) {
            Calendar monthCal = Calendar.getInstance();
            monthCal.set(Calendar.YEAR, currentYear);
            monthCal.set(Calendar.MONTH, m - 1);
            monthCal.set(Calendar.DAY_OF_MONTH, 1);

            int firstDayOfWeek = monthCal.get(Calendar.DAY_OF_WEEK);
            int daysInMonth = monthCal.getActualMaximum(Calendar.DAY_OF_MONTH);

            Map<Integer, List<AppointmentDetail>> monthlyData = yearAppointments.get(m);
    %>
    <h2><%= new DateFormatSymbols().getMonths()[m - 1] %> <%= currentYear %></h2>
    <table class="calendar">
        <tr>
            <th>Sunday</th>
            <th>Monday</th>
            <th>Tuesday</th>
            <th>Wednesday</th>
            <th>Thursday</th>
            <th>Friday</th>
            <th>Saturday</th>
        </tr>
        <tr>
            <%
                int cellCount = 0;
                for (int i = 1; i < firstDayOfWeek; i++) {
                    out.print("<td></td>");
                    cellCount++;
                }
                for (int day = 1; day <= daysInMonth; day++) {
                    if (cellCount % 7 == 0 && cellCount != 0) {
                        out.println("</tr><tr>");
                    }
                    out.print("<td>");
                    out.print("<div class='day-container'>");
                    out.print("<span class='day-number'>" + day + "</span>");
                    if (monthlyData.containsKey(day)) {
                        List<AppointmentDetail> detailList = monthlyData.get(day);
                        for (AppointmentDetail detail : detailList) {
                            // Format diagnosisDate
                            String diagnosisDateStr = "";
                            if(detail.diagnosisDate != null){
                                diagnosisDateStr = sdf.format(detail.diagnosisDate);
                            }
                            String appDateStr = sdf.format(detail.appointmentDate);
                            // Escape dấu nháy đơn trong các chuỗi nếu cần
                            String safeServiceType = detail.serviceType.replace("'", "\\'");
                            String safeCenterName = detail.centerName.replace("'", "\\'");
                            String safeDiseaseName = detail.diseaseName.replace("'", "\\'");
                            String safeDescription = detail.description.replace("'", "\\'");
                            
                            out.print("<span class='marker " +
          ("X".equals(detail.marker) ? "marker-x" : "marker-remind") +
          "' data-appointmentID='" + detail.appointmentID + "'" +
          " data-serviceType=\"" + detail.serviceType + "\"" +
          " data-centerName=\"" + detail.centerName + "\"" +
          " data-appDate='" + appDateStr + "'" +
          " data-diseaseName=\"" + detail.diseaseName + "\"" +
          " data-description=\"" + detail.description + "\"" +
          " data-diagnosisDate='" + diagnosisDateStr + "'" +
          " onclick='handleMarkerClick(this)'>" +
          (("X".equals(detail.marker)) ? "X" : "Vaccinated") +
          "</span>");

                        }
                    }
                    out.print("</div>");
                    out.print("</td>");
                    cellCount++;
                }
                while (cellCount % 7 != 0) {
                    out.print("<td></td>");
                    cellCount++;
                }
            %>
        </tr>
    </table>
    <%
        }
    %>
</div>

<!-- Detail Modal -->
<div id="detailModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeDetailModal()">&times;</span>
        <h3>Vaccination Details</h3>
        <div class="modal-body" id="modalBody">
            <!-- Detail content will be updated via JavaScript -->
        </div>
    </div>
</div>

<script>
    function handleMarkerClick(element) {
    var appointmentID = element.getAttribute("data-appointmentID");
    var serviceType = element.getAttribute("data-serviceType");
    var centerName = element.getAttribute("data-centerName");
    var appDate = element.getAttribute("data-appDate");
    var diseaseName = element.getAttribute("data-diseaseName");
    var description = element.getAttribute("data-description");
    var diagnosisDate = element.getAttribute("data-diagnosisDate");

    showDetailModal(appointmentID, serviceType, centerName, appDate, diseaseName, description, diagnosisDate);
}

function showDetailModal(appointmentID, serviceType, centerName, appDate, diseaseName, description, diagnosisDate) {
    globalAppointmentID = appointmentID;
    const modalBody = document.getElementById('modalBody');
    modalBody.innerHTML =
        "<div class='detail-item'><span>Service:</span> " + serviceType + "</div>" +
        "<div class='detail-item'><span>Center:</span> " + centerName + "</div>" +
        "<div class='detail-item'><span>Date:</span> " + appDate + "</div>" +
        "<div class='detail-item'><span>Disease Name:</span> " + diseaseName + "</div>" +
        "<div class='detail-item'><span>Description:</span> " + description + "</div>" +
        "<div class='detail-item'><span>Diagnosis Date:</span> " + diagnosisDate + "</div>" +
        "<div class='detail-item'><span>Note:</span> The center will remind you via SMS/Email. Please check your messages.</div>" +
        "<button class='delete-button' style='margin-top:10px; padding:8px 12px; background-color:#f44336; color:#fff; border:none; border-radius:5px; cursor:pointer;' onclick='deleteAppointment()'>Delete Appointment</button>";
    document.getElementById('detailModal').style.display = 'block';
}

function closeDetailModal() {
    document.getElementById('detailModal').style.display = 'none';
}

function deleteAppointment() {
    if (confirm("Are you sure you want to delete this appointment?")) {
        window.location.href = 'DeleteAppointmentController?appointmentID=' + globalAppointmentID;
    }
}

window.onclick = function (event) {
    const detailModal = document.getElementById('detailModal');
    if (event.target === detailModal) {
        detailModal.style.display = 'none';
    }
}

</script>

</body>
</html>
