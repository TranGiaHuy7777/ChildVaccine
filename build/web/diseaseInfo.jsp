<%@page import="java.sql.*" %>
<%@page import="utils.DBUtils" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Disease Information</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Reset & Global Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Poppins', sans-serif;
            background: #f7f9fc;
            color: #333;
            line-height: 1.6;
            padding: 30px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        h1 {
            margin-bottom: 25px;
            font-size: 2rem;
            color: #1e3d59;
            text-align: center;
        }
        /* Spinner Styles */
        #spinner {
            display: none;
            text-align: center;
            margin-bottom: 20px;
        }
        #spinner i {
            font-size: 2rem;
            color: #1e88e5;
        }
        /* Table Styles */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
            margin-bottom: 25px;
        }
        thead tr {
            background: #1e88e5;
            color: #fff;
            text-align: left;
            border-radius: 8px;
            overflow: hidden;
        }
        thead th {
            padding: 15px 20px;
            font-size: 0.95rem;
        }
        tbody tr {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            transition: transform 0.2s ease;
        }
        tbody tr:hover {
            transform: translateY(-3px);
        }
        tbody td {
            padding: 15px 20px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 0.9rem;
        }
        /* Checkbox Styles */
        .row-checkbox {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }
        /* Delete Button Styles */
        .delete-button {
            padding: 5px 10px;
            background: #f44336;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            display: none;
            transition: background 0.3s ease;
        }
        .delete-button:hover {
            background: #d32f2f;
        }
        /* Back Button */
        .back-button {
            display: inline-block;
            padding: 10px 20px;
            background: linear-gradient(135deg, #1e88e5, #1565c0);
            color: #fff;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 500;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-top: 10px;
        }
        .back-button i {
            margin-right: 8px;
        }
        .back-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        /* Modal Error Styles */
        .modal {
            display: none;
            position: fixed;
            top:0;
            left:0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: #fff;
            padding: 20px 30px;
            border-radius: 8px;
            text-align: center;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .modal-content p {
            margin-bottom: 20px;
            font-size: 1rem;
        }
        .modal .close {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 1.5rem;
            cursor: pointer;
        }
        /* Responsive Table */
        @media (max-width: 768px) {
            table, thead, tbody, th, td, tr {
                display: block;
            }
            thead {
                display: none;
            }
            tbody tr {
                margin-bottom: 15px;
            }
            tbody td {
                padding: 10px;
                text-align: right;
                position: relative;
            }
            tbody td::before {
                content: attr(data-label);
                position: absolute;
                left: 10px;
                width: 45%;
                padding-right: 10px;
                font-weight: 500;
                text-align: left;
            }
        }
        /* Description styles */
        .description-container {
            display: inline;
        }
        .toggle-button {
            background: none;
            border: none;
            color: blue;
            cursor: pointer;
            font-size: 0.9rem;
            padding: 0;
            margin-left: 5px;
        }
    </style>
    <script>
        // Function to handle checkbox state changes
        function toggleDeleteButton(checkbox) {
            var row = checkbox.parentNode.parentNode;
            var deleteBtn = row.querySelector('.delete-button');
            // If the checkbox is checked, show the delete button and change the checkbox background
            if (checkbox.checked) {
                deleteBtn.style.display = "inline-block";
                checkbox.style.backgroundColor = "#c8e6c9"; // light green background
            } else {
                deleteBtn.style.display = "none";
                checkbox.style.backgroundColor = "";
            }
        }
        // Function to delete an appointment; receives appointmentID as parameter
        function deleteAppointment(appointmentID) {
            if (confirm("Are you sure you want to delete this appointment?")) {
                window.location.href = 'DeleteAppointmentController?appointmentID=' + appointmentID;
            }
        }
        // Function to toggle between shortened and full description for the vaccine
        function toggleDescription(btn) {
            var container = btn.parentNode;
            var shortText = container.querySelector('.description-short');
            var fullText = container.querySelector('.description-full');
            
            if (fullText.style.display === "none") {
                // Show the full description
                fullText.style.display = "inline";
                shortText.style.display = "none";
                btn.textContent = "Show Less";
            } else {
                // Show the shortened description
                fullText.style.display = "none";
                shortText.style.display = "inline";
                btn.textContent = "Show All";
            }
        }
    </script>
</head>
<body>
<div class="container">
    <h1>Disease Information</h1>
    <!-- Spinner displayed while data is loading -->
    <div id="spinner">
        <i class="fas fa-spinner fa-spin"></i>
        <p>Loading...</p>
    </div>
    <%
        String childIDStr = request.getParameter("childID");
        if(childIDStr == null || childIDStr.trim().isEmpty()){
    %>
        <p>Child information not found.</p>
    <%
        } else {
            int childID = Integer.parseInt(childIDStr);
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                conn = DBUtils.getConnection();
                String sql = "SELECT a.appointmentID, a.appointmentDate, a.serviceType, a.status, " +
                             "       c.centerName, d.diseaseName, d.description, d.diagnosisDate " +
                             "FROM tblAppointments a " +
                             "JOIN tblCenters c ON a.centerID = c.centerID " +
                             "JOIN tblDisease d ON a.appointmentID = d.appointmentID " +
                             "WHERE a.childID = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, childID);
                rs = ps.executeQuery();
    %>
                <table>
                    <thead>
                        <tr>
                            <th>Select</th>
                            <th>Appointment ID</th>
                            <th>Vaccination Date</th>
                            <th>Service</th>
                            <th>Status</th>
                            <th>Center Name</th>
                            <th>Disease Name</th>
                            <th>Description</th>
                            <th>Diagnosis Date</th>
                            <th>Delete</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            boolean hasData = false;
                            int descriptionThreshold = 100; // Character limit for truncating description
                            while(rs.next()){
                                hasData = true;
                                int appointmentID = rs.getInt("appointmentID");
                                String description = rs.getString("description");
                        %>
                        <tr>
                            <!-- Checkbox cell -->
                            <td data-label="Select">
                                <input type="checkbox" class="row-checkbox" onchange="toggleDeleteButton(this)">
                            </td>
                            <td data-label="Appointment ID"><%= appointmentID %></td>
                            <td data-label="Vaccination Date"><%= rs.getDate("appointmentDate") %></td>
                            <td data-label="Service"><%= rs.getString("serviceType") %></td>
                            <td data-label="Status"><%= rs.getString("status") %></td>
                            <td data-label="Center Name"><%= rs.getString("centerName") %></td>
                            <td data-label="Disease Name"><%= rs.getString("diseaseName") %></td>
                            <td data-label="Description">
                                <%
                                    if(description != null && !description.trim().isEmpty()){
                                        if(description.length() > descriptionThreshold){
                                            String shortDesc = description.substring(0, descriptionThreshold);
                                %>
                                            <div class="description-container">
                                                <span class="description-short"><%= shortDesc %>...</span>
                                                <span class="description-full" style="display:none;"><%= description %></span>
                                                <button class="toggle-button" onclick="toggleDescription(this)">Show All</button>
                                            </div>
                                <%
                                        } else {
                                            out.print(description);
                                        }
                                    }
                                %>
                            </td>
                            <td data-label="Diagnosis Date"><%= rs.getDate("diagnosisDate") %></td>
                            <!-- Delete Button cell -->
                            <td data-label="Delete">
                                <button class="delete-button" onclick="deleteAppointment(<%= appointmentID %>)">Delete</button>
                            </td>
                        </tr>
                        <%
                            }
                            if(!hasData){
                        %>
                        <tr>
                            <td colspan="10" style="text-align: center;">No disease data available for this child.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
    <%
            } catch(Exception e) {
                e.printStackTrace();
    %>
                <p>An error occurred while retrieving data.</p>
    <%
            } finally {
                if(rs != null) try { rs.close(); } catch(Exception e) {}
                if(ps != null) try { ps.close(); } catch(Exception e) {}
                if(conn != null) try { conn.close(); } catch(Exception e) {}
            }
        }
    %>
    <a href="childProfile.jsp" class="back-button"><i class="fas fa-arrow-left"></i> Back</a>
</div>
<!-- Modal for error notifications -->
<div id="errorModal" class="modal" role="alert" aria-live="assertive">
    <div class="modal-content">
        <span class="close" onclick="document.getElementById('errorModal').style.display='none'">&times;</span>
        <p>An error occurred while loading data. Please try again later!</p>
    </div>
</div>
<script>
    // Allow closing modal with the Esc key
    document.addEventListener('keydown', function(event) {
        if (event.key === "Escape") {
            document.getElementById('errorModal').style.display = 'none';
        }
    });
</script>
</body>
</html>
