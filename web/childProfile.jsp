<%@page import="java.util.ArrayList" %>
<%@page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@page import="utils.DBUtils" %>
<%@page import="child.ChildDTO" %>
<%@page import="child.ChildDAO" %>
<%@page import="customer.CustomerDTO" %>
<%@page import="java.util.List" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Child Profile</title>
    <!-- Font Awesome & Google Fonts -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Global Reset & Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
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
        /* Navbar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #1e88e5;
            color: #fff;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            position: relative;
        }
        .welcome-message {
            display: flex;
            align-items: center;
            font-size: 1.1em;
            font-weight: 500;
        }
        .welcome-message i {
            margin-right: 10px;
            font-size: 1.4em;
        }
        .nav-right {
            display: flex;
            align-items: center;
        }
        .logout-button {
            padding: 10px 20px;
            background: linear-gradient(135deg, #f44336, #d32f2f);
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1em;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-left: 15px;
        }
        .logout-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }
        /* Notification Icon & Dropdown */
        .notification-icon {
            position: relative;
            font-size: 1.4em;
            cursor: pointer;
            margin-right: 10px;
            transition: color 0.3s ease;
            display: inline-block;
        }
        .notification-icon:hover {
            color: #f5f5f5;
        }
        .notification-badge {
            position: absolute;
            top: -6px;
            right: -10px;
            background: red;
            color: #fff;
            font-size: 0.8em;
            padding: 3px 6px;
            border-radius: 50%;
            font-weight: bold;
        }
        .notification-dropdown {
            display: none;
            position: absolute;
            top: 60px;
            right: 20px;
            background: #fff;
            width: 320px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 15px;
            z-index: 999;
        }
        .notification-dropdown h4 {
            margin-bottom: 10px;
            padding-bottom: 5px;
            font-size: 1.1em;
            border-bottom: 1px solid #ddd;
        }
        .notification-dropdown ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .notification-dropdown li {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding: 10px 0;
            transition: background 0.2s ease;
            cursor: pointer;
        }
        .notification-dropdown li:last-child {
            border-bottom: none;
        }
        .notification-content .message {
            margin: 0;
            font-size: 0.95em;
            color: #333;
        }
        .notification-content .timestamp {
            font-size: 0.85em;
            color: #777;
            margin-top: 4px;
        }
        .mark-read-button {
            background: none;
            border: none;
            color: #4CAF50;
            cursor: pointer;
            font-size: 1.2em;
            transition: color 0.3s ease;
        }
        .mark-read-button:hover {
            color: #388e3c;
        }
        .no-notifications {
            text-align: center;
            color: #999;
            font-size: 0.95em;
        }
        /* Extra Notifications Animation */
        .notification-item.extra-notification {
            display: none;
        }
        .notification-item.extra-notification.show {
            display: flex !important;
            animation: fadeInSlideUp 0.5s ease forwards;
        }
        @keyframes fadeInSlideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .toggle-notifications {
            text-align: center;
            margin-top: 10px;
            cursor: pointer;
            color: #1e88e5;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        .toggle-notifications:hover {
            color: #1565c0;
        }
        /* Hero Section */
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
                        url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880385.jpg?w=1380');
            background-size: cover;
            background-position: center;
            padding: 80px 0;
            text-align: center;
            color: #fff;
            border-radius: 10px;
            margin-bottom: 40px;
        }
        .hero-title {
            font-size: 2.5em;
            margin-bottom: 15px;
            font-weight: 600;
        }
        /* Children Grid */
        .children-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        .child-card {
            background: #fff;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .child-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 12px rgba(0,0,0,0.15);
        }
        .child-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: #1e88e5;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        .child-avatar i {
            color: #fff;
            font-size: 40px;
        }
        .child-info {
            text-align: center;
        }
        .child-name {
            font-size: 1.3em;
            color: #1e88e5;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .info-item {
            display: flex;
            align-items: center;
            margin: 8px 0;
            font-size: 0.95em;
            color: #333;
            background: #f9f9f9;
            padding: 8px;
            border-radius: 5px;
        }
        .info-item i {
            color: #1e88e5;
            margin-right: 8px;
        }
        /* Refined Buttons */
        .btn-edit, .btn-delete {
            margin-top: 10px;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            color: #fff;
            cursor: pointer;
            margin-right: 5px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .btn-edit {
            background: linear-gradient(135deg, #1e88e5, #1565c0);
        }
        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .btn-delete {
            background: linear-gradient(135deg, #f44336, #d32f2f);
        }
        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .btn-vaccination-record {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 18px;
            background: linear-gradient(135deg, #1e88e5, #1565c0);
            color: #fff;
            border-radius: 5px;
            text-decoration: none;
            font-size: 0.95em;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-top: 10px;
        }
        .btn-vaccination-record:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .btn-disease-info {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 18px;
            background: linear-gradient(135deg, #8e24aa, #6a1b9a);
            color: #fff;
            border-radius: 5px;
            text-decoration: none;
            font-size: 0.95em;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-top: 10px;
        }
        .btn-disease-info:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .add-child-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 12px 25px;
            background: linear-gradient(135deg, #4CAF50, #43a047);
            color: #fff;
            border: none;
            border-radius: 25px;
            font-size: 1em;
            text-decoration: none;
            margin-top: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .add-child-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .btn-back {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 20px;
            background: linear-gradient(135deg, #1e88e5, #1565c0);
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            text-decoration: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-top: 30px;
        }
        .btn-back:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.4);
        }
        .modal-content {
            background: #fff;
            margin: 5% auto;
            padding: 20px;
            max-width: 500px;
            border-radius: 8px;
            position: relative;
        }
        .modal-content h2 {
            margin-bottom: 15px;
            font-size: 1.3em;
            color: #333;
        }
        .close {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 24px;
            cursor: pointer;
            color: #aaa;
            transition: color 0.3s ease;
        }
        .close:hover {
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            margin-bottom: 5px;
            display: block;
            font-weight: 500;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 2px solid #ccc;
            border-radius: 5px;
            font-size: 0.95em;
        }
        .form-group input:focus, .form-group select:focus {
            border-color: #1e88e5;
            outline: none;
        }
        .btn-save {
            background: linear-gradient(135deg, #4CAF50, #43a047);
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        /* Confirm Modal */
        .confirm-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.4);
        }
        .confirm-modal-content {
            background: #fff;
            margin: 10% auto;
            padding: 20px;
            max-width: 400px;
            border-radius: 8px;
            text-align: center;
            position: relative;
        }
        .confirm-modal-content h2 {
            margin-bottom: 20px;
            font-size: 1.2em;
        }
        .confirm-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        .confirm-buttons button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-weight: 500;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }
        .btn-yes {
            background: linear-gradient(135deg, #4CAF50, #43a047);
            color: #fff;
        }
        .btn-yes:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .btn-no {
            background: linear-gradient(135deg, #f44336, #d32f2f);
            color: #fff;
        }
        .btn-no:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .btn-vaccination-record:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .btn-disease-info {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 18px;
            background: linear-gradient(135deg, #8e24aa, #6a1b9a);
            color: #fff;
            border-radius: 5px;
            text-decoration: none;
            font-size: 0.95em;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-top: 10px;
        }
        .btn-disease-info:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
    </style>
</head>
<body>
<%
    // Check login
    CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get children list
    ChildDAO childDAO = new ChildDAO();
    List<ChildDTO> children = null;
    try {
        String userID = loginUser.getUserID();
        children = childDAO.getAllChildrenByUserID(userID);
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    // Get notifications & count unread
    int unreadCount = 0;
    List<String[]> notifications = new ArrayList<>();
    try {
        Connection conn = DBUtils.getConnection();
        String sql = "SELECT notificationID, notificationText, isRead, notificationDate "
                   + "FROM tblNotifications "
                   + "WHERE userID = ? "
                   + "ORDER BY notificationDate DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, loginUser.getUserID());
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            String[] notification = new String[4];
            notification[0] = rs.getString("notificationID");
            notification[1] = rs.getString("notificationText");
            notification[2] = rs.getString("isRead");
            notification[3] = rs.getString("notificationDate");
            if (rs.getInt("isRead") == 0) {
                unreadCount++;
            }
            notifications.add(notification);
        }
        rs.close();
        ps.close();
        conn.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!-- Navbar -->
<div class="navbar">
    <div class="welcome-message">
        <i class="fas fa-user-shield"></i>
        Welcome, <%= loginUser.getFullName() %>
    </div>
    <div class="nav-right">
        <!-- Notification Icon -->
        <div class="notification-icon" onclick="toggleNotificationDropdown()">
            <i class="fas fa-bell"></i>
            <% if (unreadCount > 0) { %>
                <span class="notification-badge"><%= unreadCount %></span>
            <% } %>
        </div>
        <!-- Logout Form -->
        <form action="MainController" method="POST">
            <button type="submit" name="action" value="Logout" class="logout-button">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </form>
    </div>
</div>

<!-- Notification Dropdown -->
<div id="notificationDropdown" class="notification-dropdown">
    <h4>Notifications</h4>
    <% if (notifications.isEmpty()) { %>
        <p class="no-notifications">No notifications</p>
    <% } else { %>
    <ul>
        <%
            int showLimit = 5;
            for (int i = 0; i < notifications.size(); i++) {
                String[] notification = notifications.get(i);
                String extraClass = (i < showLimit) ? "" : " extra-notification";
        %>
        <li class="notification-item<%= extraClass %> <%= notification[2].equals("0") ? " unread" : "" %>"
            id="notification-<%= notification[0] %>"
            onclick="animateNotification(this, '<%= notification[0] %>')">
            <div class="notification-content">
                <p class="message"><%= notification[1] %></p>
                <p class="timestamp"><i class="far fa-clock"></i> <%= notification[3] %></p>
            </div>
            <% if (notification[2].equals("0")) { %>
                <button class="mark-read-button" onclick="event.stopPropagation(); markAsRead('<%= notification[0] %>')">✔</button>
            <% } %>
        </li>
        <% } %>
    </ul>
    <% if (notifications.size() > showLimit) { %>
        <div id="toggleNotifications" class="toggle-notifications" onclick="toggleExtraNotifications()" data-showing="false">
            View More
        </div>
    <% } %>
    <% } %>
</div>

<!-- Hero Section -->
<div class="hero-section">
    <h1 class="hero-title">Child Profile</h1>
    <p>Manage your child's information</p>
</div>

<!-- Children Grid -->
<div class="container">
    <div class="children-grid">
        <% if (children != null && !children.isEmpty()) {
            for (ChildDTO child : children) { %>
        <div class="child-card">
            <div class="child-avatar">
                <i class="fas fa-child"></i>
            </div>
            <div class="child-info">
                <div class="child-name"><%= child.getChildName() %></div>
                <div class="info-item">
                    <i class="fas fa-birthday-cake"></i>
                    <span>Date of Birth: <%= child.getDateOfBirth() %></span>
                </div>
                <div class="info-item">
                    <i class="fas fa-venus-mars"></i>
                    <span>Gender: <%= child.getGender() %></span>
                </div>
                <button onclick="openEditModal(<%= child.getChildID() %>, 
                                    '<%= child.getChildName() %>', 
                                    '<%= child.getDateOfBirth() %>',
                                    '<%= child.getGender() %>')"
                        class="btn-edit">
                    <i class="fas fa-edit"></i> Edit
                </button>
                <button onclick="openConfirmModal(<%= child.getChildID() %>)" class="btn-delete">
                    <i class="fas fa-trash-alt"></i> Delete
                </button>
                <!-- Vaccination Record Link -->
                <a href="vaccinationRecord.jsp?childID=<%= child.getChildID() %>" class="btn-vaccination-record">
                    <i class="fas fa-notes-medical"></i> Vaccination Record
                </a>
                <!-- Disease Info Button -->
                <a href="diseaseInfo.jsp?childID=<%= child.getChildID() %>" class="btn-disease-info">
                    <i class="fas fa-stethoscope"></i> Disease Information
                </a>   
            </div>
        </div>
        <% }
        } else { %>
        <div style="text-align: center; grid-column: 1 / -1;">
            <div class="child-card">
                <i class="fas fa-child" style="font-size: 48px; color: #ccc; margin-bottom: 20px;"></i>
                <p>No child information available</p>
                <a href="childRegistration.jsp" class="add-child-button">
                    <i class="fas fa-plus"></i> Add Child Information
                </a>
            </div>
        </div>
        <% } %>
    </div>

    <a href="vaccinationSchedule.jsp" class="btn-back">
        <i class="fas fa-arrow-left"></i> Back to Vaccine Schedule
    </a>
</div>

<!-- Edit Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h2>Edit Child Profile</h2>
        <form id="editForm" action="EditChildController" method="POST">
            <input type="hidden" id="editChildID" name="childID">
            <div class="form-group">
                <label>Name</label>
                <input type="text" id="editFullName" name="fullName" required>
            </div>
            <div class="form-group">
                <label>Date of Birth</label>
                <input type="date" id="editDateOfBirth" name="dateOfBirth" required>
            </div>
            <div class="form-group">
                <label>Gender</label>
                <select id="editGender" name="gender" required>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                </select>
            </div>
            <button type="submit" class="btn-save">Save Changes</button>
        </form>
    </div>
</div>

<!-- Confirm Delete Modal -->
<div id="confirmModal" class="confirm-modal">
    <div class="confirm-modal-content">
        <h2>Are you sure you want to delete this child profile?</h2>
        <div class="confirm-buttons">
            <button id="btnYes" class="btn-yes">Yes</button>
            <button id="btnNo" class="btn-no">No</button>
        </div>
    </div>
</div>

<script>
    // Open Edit Modal
    function openEditModal(childID, fullName, dateOfBirth, gender) {
        document.getElementById('editChildID').value = childID;
        document.getElementById('editFullName').value = fullName;
        document.getElementById('editDateOfBirth').value = dateOfBirth;
        document.getElementById('editGender').value = gender;
        document.getElementById('editModal').style.display = 'block';
    }
    document.querySelector('.close').onclick = function () {
        document.getElementById('editModal').style.display = 'none';
    }
    window.onclick = function (event) {
        if (event.target == document.getElementById('editModal')) {
            document.getElementById('editModal').style.display = 'none';
        }
        if (event.target == document.getElementById('confirmModal')) {
            document.getElementById('confirmModal').style.display = 'none';
        }
    }

    // Open Confirm Delete Modal
    function openConfirmModal(childID) {
        document.getElementById('confirmModal').style.display = 'block';
        document.getElementById('btnYes').onclick = function () {
            window.location.href = 'DeleteChildController?childID=' + childID;
        }
        document.getElementById('btnNo').onclick = function () {
            document.getElementById('confirmModal').style.display = 'none';
        }
    }

    // Toggle Notification Dropdown
    function toggleNotificationDropdown() {
        var dropdown = document.getElementById("notificationDropdown");
        dropdown.style.display = (dropdown.style.display === "block") ? "none" : "block";
    }

    // Toggle Extra Notifications
    function toggleExtraNotifications() {
        var dropdown = document.getElementById("notificationDropdown");
        var items = dropdown.getElementsByTagName("li");
        var toggleLink = document.getElementById("toggleNotifications");
        var showing = toggleLink.getAttribute("data-showing") === "true";
        for (var i = 5; i < items.length; i++) {
            if (showing) {
                items[i].classList.remove("show");
            } else {
                items[i].classList.add("show");
            }
        }
        if (toggleLink) {
            if (showing) {
                toggleLink.textContent = "View More";
                toggleLink.setAttribute("data-showing", "false");
            } else {
                toggleLink.textContent = "Show Less";
                toggleLink.setAttribute("data-showing", "true");
            }
        }
    }

    // Animate Notification & Mark as Read
    function animateNotification(elem, notificationID) {
        if (elem.classList.contains('unread')) {
            elem.classList.add("animate");
            setTimeout(function() {
                elem.classList.remove("animate");
            }, 300);
        }
        markAsRead(notificationID);
    }

    // Mark Notification as Read
    function markAsRead(notificationID) {
        fetch('MarkNotificationReadController', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'notificationID=' + notificationID
        })
        .then(response => {
            if (response.ok) {
                let notifElem = document.getElementById('notification-' + notificationID);
                if (notifElem) {
                    notifElem.classList.remove('unread');
                    let markBtn = notifElem.querySelector('.mark-read-button');
                    if (markBtn) {
                        markBtn.remove();
                    }
                    let badge = document.querySelector('.notification-badge');
                    if (badge) {
                        let count = parseInt(badge.textContent);
                        if (count > 1) {
                            badge.textContent = count - 1;
                        } else {
                            badge.remove();
                        }
                    }
                }
            }
        })
        .catch(error => console.log('Error marking notification as read:', error));
    }

    window.onclick = function(event) {
        if (!event.target.matches('.notification-icon, .notification-icon *')) {
            var dropdown = document.getElementById("notificationDropdown");
            if (dropdown && dropdown.style.display === "block") {
                dropdown.style.display = "none";
            }
        }
    };

    document.addEventListener("DOMContentLoaded", function() {
        var dropdown = document.getElementById("notificationDropdown");
        var items = dropdown.getElementsByTagName("li");
        for (var i = 5; i < items.length; i++) {
            if (items[i].classList.contains("extra-notification")) {
                items[i].style.display = "none";
            }
        }
    });
</script>
</body>
</html>
