<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="child.ChildDTO" %>
<%@ page import="child.ChildDAO" %>
<%@ page import="record.RecordDAO" %>
<%@ page import="record.RecordDTO" %>
<%@ page import="vaccine.VaccineDAO" %>
<%@ page import="vaccine.VaccineDTO" %>
<%@ page import="customer.CustomerDTO" %>
<%@ page import="utils.DBUtils" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    
    CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ===== 2) Lấy childID =====
    String childIdParam = request.getParameter("childID");
    if (childIdParam == null || childIdParam.isEmpty()) {
        out.println("<h2>Không có thông tin childID</h2>");
        return;
    }
    int childID = Integer.parseInt(childIdParam);

    // ===== 3) Kết nối DB, khởi tạo DAO =====
    Connection conn = null;
    ChildDAO childDAO = null;
    RecordDAO recordDAO = null;
    VaccineDAO vaccineDAO = null;

    try {
        conn = DBUtils.getConnection();
        if (conn == null) {
            out.println("<h2>Không thể kết nối CSDL</h2>");
            return;
        }

       
        childDAO = new ChildDAO(conn);
        recordDAO = new RecordDAO(conn);
        vaccineDAO = new VaccineDAO(); 
        ChildDTO child = childDAO.findChildByID(childID); 
        if (child == null) {
            out.println("<h2>Không tìm thấy thông tin trẻ!</h2>");
            return;
        }

        // Lấy ngày sinh (java.util.Date)
        Date dob = child.getDateOfBirth();
        if (dob == null) {
            out.println("<h2>Không có thông tin ngày sinh của trẻ!</h2>");
            return;
        }

        
        List<VaccineDTO> vaccineList = vaccineDAO.getActiveVaccines();

        
        List<RecordDTO> recordList = new ArrayList<>();
        {
            String sql = "SELECT recordID, childID, vaccineID, doseNumber, vaccinationDate, centerID, appointmentID, notes "
                       + "FROM tblRecords WHERE childID = ? ORDER BY vaccinationDate ASC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, childID);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                RecordDTO r = new RecordDTO(
                    rs.getInt("recordID"),
                    rs.getInt("childID"),
                    rs.getInt("vaccineID"),
                    rs.getInt("doseNumber"),
                    rs.getDate("vaccinationDate"),
                    rs.getInt("centerID"),
                    rs.getInt("appointmentID"),
                    rs.getString("notes")
                );
                recordList.add(r);
            }
            rs.close();
            ps.close();
        }

        
        LocalDate dobLocal = ((java.sql.Date) dob).toLocalDate();


        Map<Integer, List<Integer>> vaccineToMonthsMap = new HashMap<>();

        for (RecordDTO r : recordList) {
            int vID = r.getVaccineID();
            Date vacDate = r.getVaccinationDate(); 
            LocalDate vacLocal = vacDate.toInstant()
                                        .atZone(java.time.ZoneId.systemDefault())
                                        .toLocalDate();

            long months = ChronoUnit.MONTHS.between(dobLocal, vacLocal);

            
            if (!vaccineToMonthsMap.containsKey(vID)) {
                vaccineToMonthsMap.put(vID, new ArrayList<Integer>());
            }
            vaccineToMonthsMap.get(vID).add((int) months);
        }

        
        int[] monthColumns = {2, 3, 4, 6, 9, 12, 15, 18, 24, 36, 48, 60};
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sổ Tiêm Chủng - <%= child.getChildName() %></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 20px;
        }
        h1 {
            color: #333;
            margin-bottom: 10px;
        }
        .child-info p {
            margin: 5px 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        table, th, td {
            border: 1px solid #ccc;
        }
        th {
            background: #1976d2;
            color: #fff;
            text-align: center;
            padding: 8px;
        }
        td {
            text-align: center;
            padding: 8px;
        }
        .vaccine-name {
            text-align: left;
            font-weight: bold;
        }
        .status-x {
            font-weight: bold;
            color: green;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Sổ Tiêm Chủng của <%= child.getChildName() %></h1>
    <div class="child-info">
        <p><strong>Ngày sinh:</strong> <%= child.getDateOfBirth() %></p>
    </div>

    <h2>Danh Sách Vắc Xin Đã Tiêm</h2>
    <table>
        <thead>
            <tr>
                <th class="vaccine-name">Vaccine</th>
                <%
                    for(int m : monthColumns){
                %>
                    <th><%= m %> tháng</th>
                <%
                    }
                %>
            </tr>
        </thead>
        <tbody>
            <%
                for(VaccineDTO v : vaccineList){
                    int vID = v.getVaccineID();
            %>
            <tr>
                <td class="vaccine-name"><%= v.getVaccineName() %></td>
                <%
                    // Lấy danh sách tháng tuổi đã tiêm vaccine này
                    List<Integer> monthsList = vaccineToMonthsMap.getOrDefault(vID, new ArrayList<Integer>());
                    for(int m : monthColumns){
                        String display = "";
                        if(monthsList.contains(m)){
                            display = "<span class='status-x'>X</span>";
                        }
                %>
                <td><%= display %></td>
                <%
                    }
                %>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>Lỗi xảy ra: " + e.getMessage() + "</h2>");
    } finally {
        if (conn != null) {
            conn.close();
        }
    }
%>
