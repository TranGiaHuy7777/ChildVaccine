<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="utils.DBUtils" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Vaccine Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f0f2f5; color: #333; line-height: 1.6; }
        .navbar {
            background: white; padding: 1rem 2rem; box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 1000;
        }
        .reaction-table {
            width: 100%; border-collapse: collapse; margin: 30px 0;
        }
        .reaction-table th, .reaction-table td {
            padding: 10px; border: 1px solid #ddd; text-align: center;
        }
        .reaction-table th { background: #ffa726; color: white; }
        .notify-button {
            padding: 8px 12px; background: #ffa726; color: white; border: none; border-radius: 5px;
            cursor: pointer; font-weight: 500; transition: all 0.3s ease;
        }
        .notify-button:hover { background: #e69500; }
        /* Modal Styles */
        .modal-overlay {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.5); z-index: 1000;
        }
        .modal-container {
            position: fixed; top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            background: white; padding: 20px; border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
            width: 90%; max-width: 400px; text-align: center;
        }
        .modal-title { font-size: 1.5em; margin-bottom: 15px; }
        .modal-buttons { display: flex; justify-content: center; gap: 15px; margin-top: 15px; }
        .modal-button {
            padding: 10px 20px; border: none; border-radius: 5px;
            cursor: pointer; font-weight: 500;
        }
        .confirm-button { background: #3498db; color: white; }
        .cancel-button { background: #e0e0e0; color: #333; }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar">
        <div class="welcome-message">
            <i class="fas fa-user-shield"></i> Welcome, Admin
        </div>
        <form action="MainController" method="POST">
            <button type="submit" name="action" value="Logout" class="logout-button">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </form>
    </nav>

    <!-- Main Content -->
    <div class="main-container">
        <h2>Reaction Notifications (Today)</h2>
        <%
            List<String[]> reactionList = new ArrayList<>();
            try {
                Connection conn = DBUtils.getConnection();
                String sql = "SELECT TOP (1000) r.reactionID, r.appointmentID, r.reactionText, r.reactionDate, c.userID " +
                             "FROM tblVaccineReactions r " +
                             "JOIN tblAppointments a ON r.appointmentID = a.appointmentID " +
                             "JOIN tblChildren c ON a.childID = c.childID " +
                             "WHERE r.reactionDate = CONVERT(date, GETDATE())";
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
                while(rs.next()){
                    String[] row = new String[5];
                    row[0] = rs.getString("reactionID");
                    row[1] = rs.getString("appointmentID");
                    row[2] = rs.getString("reactionText");
                    row[3] = rs.getString("reactionDate");
                    row[4] = rs.getString("userID");
                    reactionList.add(row);
                }
                rs.close();
                ps.close();
                conn.close();
            } catch(Exception ex) {
                out.println("<p>Error: " + ex.getMessage() + "</p>");
            }
        %>

        <%
            if (reactionList.isEmpty()) {
        %>
            <p>No reaction notifications found.</p>
        <%
            } else {
        %>
            <table class="reaction-table">
                <thead>
                    <tr>
                        <th>Reaction ID</th>
                        <th>Appointment ID</th>
                        <th>Reaction Text</th>
                        <th>Reaction Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (String[] row : reactionList) {
                    %>
                    <tr>
                        <td><%= row[0] %></td>
                        <td><%= row[1] %></td>
                        <td><%= row[2] %></td>
                        <td><%= row[3] %></td>
                        <td>
                            <button class="notify-button" onclick="openNotifyModal('<%= row[4] %>')">
                                <i class="fas fa-bell"></i> Notify
                            </button>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        <%
            }
        %>
    </div>

    <!-- Modal for Sending Notification -->
    <div id="notifyModal" class="modal-overlay">
        <div class="modal-container">
            <span class="modal-close" onclick="closeNotifyModal()">&times;</span>
            <h2 class="modal-title">Send Notification</h2>
            <form id="notifyForm" action="SendNotificationController" method="post">
                <input type="hidden" name="userID" id="notifyUserID" value=""/>
                <textarea name="notificationText" id="notificationText" placeholder="Enter notification message"
                          style="width: 100%; height: 100px; padding: 10px; border: 1px solid #ccc; border-radius: 5px;" required></textarea>
                <div class="modal-buttons">
                    <button type="submit" class="modal-button confirm-button">Send</button>
                    <button type="button" class="modal-button cancel-button" onclick="closeNotifyModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <!-- JavaScript for Modal Handling -->
    <script>
        function openNotifyModal(userID) {
            document.getElementById("notifyUserID").value = userID;
            document.getElementById("notifyModal").style.display = "block";
        }
        function closeNotifyModal() {
            document.getElementById("notifyModal").style.display = "none";
        }
    </script>

</body>
</html>
