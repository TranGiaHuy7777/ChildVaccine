<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.DateFormatSymbols" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="utils.DBUtils" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hồ Sơ Tiêm Chủng</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            color: #333;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 20px;
        }
        h1 {
            text-align: center;
            margin-bottom: 20px;
        }
        h2 {
            margin-top: 40px;
            color: #1e88e5;
            text-align: center;
        }
        table.calendar {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }
        table.calendar th,
        table.calendar td {
            width: 14.28%;
            height: 100px;
            border: 1px solid #ccc;
            vertical-align: top;
            text-align: center;
            position: relative;
            background-color: #fafafa;
        }
        table.calendar th {
            background-color: #1e88e5;
            color: white;
        }
        .day-container {
            position: relative;
            width: 100%;
            height: 100%;
            padding: 5px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
        }
        .day-number {
            font-weight: bold;
            font-size: 16px;
            color: #333;
            margin-bottom: 5px;
        }
        .marker {
            display: inline-block;
            margin: 2px 0;
            padding: 4px 8px;
            font-size: 13px;
            font-weight: 600;
            border-radius: 12px;
        }
        .marker-x {
            background-color: #f44336;
            color: #fff;
        }
        .marker-remind {
            background-color: #ffa726;
            color: #fff;
            cursor: pointer;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }
        .modal-content {
            background-color: #fff;
            margin: 10% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 400px;
            border-radius: 8px;
            position: relative;
        }
        .modal-close {
            position: absolute;
            right: 15px;
            top: 10px;
            font-size: 20px;
            font-weight: bold;
            color: #aaa;
            cursor: pointer;
        }
        .modal-close:hover {
            color: #333;
        }
        .modal-body {
            margin-top: 20px;
        }
        .detail-item {
            margin-bottom: 10px;
        }
        .detail-item span {
            font-weight: bold;
        }
        .back-button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #1e88e5;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 20px;
            transition: background-color 0.3s ease;
        }
        .back-button:hover {
            background-color: #1565c0;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Hồ Sơ Tiêm Chủng - Lịch Cả Năm (No AppointmentDetails)</h1>
    <a href="vaccinationSchedule.jsp" class="back-button">
        <i class="fas fa-arrow-left"></i> Back to Schedule
    </a>

    <%
        // 1) Lấy childID từ URL
        String childIDParam = request.getParameter("childID");
        if (childIDParam == null || childIDParam.trim().isEmpty()) {
            out.println("<p style='text-align:center;color:red;'>Không tìm thấy thông tin trẻ em (thiếu childID).</p>");
            return;
        }
        int childID = Integer.parseInt(childIDParam);
        out.println("<!-- DEBUG: childID = " + childID + " -->");

        // 2) Lấy năm hiện tại
        Calendar now = Calendar.getInstance();
        int currentYear = now.get(Calendar.YEAR);
        out.println("<!-- DEBUG: currentYear = " + currentYear + " -->");

        // 3) Chuẩn bị định dạng ngày
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // 4) Tạo lớp AppointmentDetail với thêm trường appointmentID
        class AppointmentDetail {
            int appointmentID;
            String marker;         // "X" hoặc "tiêm chủng"
            String serviceType;
            String centerName;
            java.sql.Date appointmentDate;
        }

        // 5) Cấu trúc: yearAppointments[tháng][ngày] = List<AppointmentDetail>
        Map<Integer, Map<Integer, List<AppointmentDetail>>> yearAppointments = new HashMap<>();
        for (int m = 1; m <= 12; m++) {
            yearAppointments.put(m, new HashMap<Integer, List<AppointmentDetail>>());
        }

        // 6) Truy vấn DB: lấy thông tin lịch hẹn của trẻ (bao gồm appointmentID)
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            String sql = "SELECT a.appointmentID, a.appointmentDate, a.serviceType, c.centerName " +
                         "FROM tblAppointments a " +
                         "JOIN tblCenters c ON a.centerID = c.centerID " +
                         "WHERE YEAR(a.appointmentDate)=? AND a.childID=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, currentYear);
            ps.setInt(2, childID);
            rs = ps.executeQuery();

            // Tính ngày hôm nay (0h0p)
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
                countAppointments++;
                out.println("<!-- DEBUG: Found appointment => appointmentID=" + appointmentID 
                            + ", date=" + appDate
                            + ", serviceType=" + serviceType
                            + ", center=" + centerName + " -->");

                Calendar appCal = Calendar.getInstance();
                appCal.setTime(appDate);
                int month = appCal.get(Calendar.MONTH) + 1;
                int day = appCal.get(Calendar.DAY_OF_MONTH);

                AppointmentDetail detail = new AppointmentDetail();
                detail.appointmentID = appointmentID;
                detail.serviceType = serviceType;
                detail.centerName = centerName;
                detail.appointmentDate = appDate;
                if (appDate.before(todayDate)) {
                    detail.marker = "X";
                } else {
                    detail.marker = "tiêm chủng";
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

        // 7) Hiển thị lịch cho 12 tháng
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
            <th>Chủ Nhật</th>
            <th>Thứ Hai</th>
            <th>Thứ Ba</th>
            <th>Thứ Tư</th>
            <th>Thứ Năm</th>
            <th>Thứ Sáu</th>
            <th>Thứ Bảy</th>
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
                            String appDateStr = sdf.format(detail.appointmentDate);
                            out.print("<span class='marker " +
                                      ("X".equals(detail.marker) ? "marker-x" : "marker-remind") +
                                      "' onclick=\"showDetailModal(" + detail.appointmentID + ",'" +
                                      detail.serviceType + "','" +
                                      detail.centerName + "','" +
                                      appDateStr + "')\">" +
                                      (("X".equals(detail.marker)) ? "X" : "Tiêm Chủng") +
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

<!-- Modal hiển thị chi tiết -->
<div id="detailModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeDetailModal()">&times;</span>
        <h3>Thông Tin Tiêm Chủng</h3>
        <div class="modal-body" id="modalBody">
            <!-- Nội dung chi tiết sẽ được cập nhật qua JavaScript -->
        </div>
    </div>
</div>

<script>
            var globalAppointmentID = 0;
            function showDetailModal(appointmentID, serviceType, centerName, appDate) {
                globalAppointmentID = appointmentID;
                const modalBody = document.getElementById('modalBody');
                modalBody.innerHTML =
                        "<div class='detail-item'><span>Dịch vụ:</span> " + serviceType + "</div>" +
                        "<div class='detail-item'><span>Cơ sở:</span> " + centerName + "</div>" +
                        "<div class='detail-item'><span>Thời gian:</span> " + appDate + "</div>" +
                        "<div class='detail-item'><span>Lưu ý:</span> " + "Trung tâm chúng tôi sẽ nhắc nhở bạn qua SMS/ Email. Hãy kiểm tra lại " + "</div>" +
                        "<button class='delete-button' style='margin-top:10px; padding:8px 12px; background-color:#f44336; color:#fff; border:none; border-radius:5px; cursor:pointer;' onclick='deleteAppointment()'>Delete Appointment</button>";
                document.getElementById('detailModal').style.display = 'block';
            }

            function deleteAppointment() {
                if (confirm("Are you sure you want to delete this appointment?")) {
                    window.location.href = 'DeleteAppointmentController?appointmentID=' + globalAppointmentID;
                }
            }

            function closeDetailModal() {
                document.getElementById('detailModal').style.display = 'none';
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
