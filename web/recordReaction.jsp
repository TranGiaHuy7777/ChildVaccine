<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, child.ChildDAO, child.ChildDTO, appointment.AppointmentDAO, appointment.AppointmentDTO, customer.CustomerDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Record Post-Vaccination Reaction</title>
    <!-- Link Font Awesome & Google Fonts -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
  /* Global Styles */
  body {
    font-family: 'Poppins', sans-serif;
    background: #f7f9fc;
    margin: 0;
    padding: 20px;
    color: #333;
    overflow-x: hidden;
  }

  /* Container */
  .container {
    max-width: 900px;
    margin: 0 auto;
    padding: 20px;
    background: #ffffff;
    border-radius: 12px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
    animation: slideIn 0.8s ease-out;
  }
  
  @keyframes slideIn {
    from { transform: translateY(20px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
  }

  /* Back Button */
  .btn-back {
    display: inline-block;
    padding: 12px 20px;
    background: linear-gradient(135deg, #1e88e5, #1565c0);
    color: #fff;
    text-decoration: none;
    border-radius: 50px;
    margin-bottom: 20px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .btn-back:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
  }

  /* Hero Section */
  .hero-section {
    position: relative;
    background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
                url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880385.jpg');
    background-size: cover;
    background-position: center;
    padding: 120px 20px;
    text-align: center;
    color: #fff;
    border-radius: 15px;
    margin-bottom: 40px;
    overflow: hidden;
  }
  
  .hero-section::after {
    content: '';
    position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.3);
    pointer-events: none;
  }
  
  .hero-title {
    font-size: 2.8em;
    margin-bottom: 10px;
    letter-spacing: 1px;
  }
  
  .hero-subtitle {
    font-size: 1.3em;
  }

  /* Appointments Grid (Profile Tiles) */
  .appointments-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
    margin-bottom: 30px;
  }
  
  .profile-tile {
    width: 280px;
    height: 280px;
    background: linear-gradient(135deg, #e3f2fd, #bbdefb);
    border: 2px solid transparent;
    border-radius: 16px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 20px;
    text-align: center;
    cursor: pointer;
    transition: transform 0.3s ease, box-shadow 0.3s ease, background 0.3s ease, border-color 0.3s ease;
  }
  
  .profile-tile:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.2);
    background: linear-gradient(135deg, #bbdefb, #90caf9);
    border-color: #1e88e5;
  }
  
  .profile-tile div {
    margin: 10px 0;
    font-size: 1.2em;
    color: #0d47a1;
  }

  /* Registration Card (Form) */
  .registration-card {
    background: #fff;
    border-radius: 15px;
    padding: 30px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    margin-top: 40px;
  }
  
  .form-header {
    text-align: center;
    margin-bottom: 20px;
  }
  
  .form-header h2 {
    margin: 0;
    font-size: 2em;
    color: #333;
  }
  
  .form-header p {
    font-size: 1em;
    color: #777;
  }
  
  .form-group {
    margin-bottom: 20px;
  }
  
  .form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
  }
  
  .form-control {
    width: 100%;
    padding: 12px;
    border: 2px solid #e0e0e0;
    border-radius: 8px;
    font-size: 1em;
    transition: border-color 0.3s ease;
  }
  
  .form-control:focus {
    outline: none;
    border-color: #1e88e5;
  }
  
  /* Submit Button */
  .submit-btn {
    width: 100%;
    padding: 15px;
    background: linear-gradient(90deg, #1e88e5, #1565c0);
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .submit-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(30,136,229,0.3);
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
    background-color: rgba(0,0,0,0.5);
    backdrop-filter: blur(3px);
  }
  
  .modal-content {
    background: #fff;
    margin: 10% auto;
    padding: 20px 30px;
    border-radius: 8px;
    width: 50%;
    max-width: 600px;
    position: relative;
    animation: popIn 0.4s ease-out;
  }
  
  @keyframes popIn {
    from { transform: scale(0.95); opacity: 0; }
    to { transform: scale(1); opacity: 1; }
  }
  
  .modal-close {
    position: absolute;
    top: 10px;
    right: 15px;
    font-size: 28px;
    cursor: pointer;
    color: #aaa;
    transition: color 0.3s ease;
  }
  
  .modal-close:hover {
    color: #000;
  }
  
  .appointment-list {
    margin-top: 20px;
  }
  
  .appointment-item {
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    margin-bottom: 10px;
    cursor: pointer;
    transition: background 0.3s ease;
  }
  
  .appointment-item:hover {
    background: #f0f0f0;
  }

  /* Notification Popup */
  .notification {
    position: fixed;
    bottom: 20px;
    right: 20px;
    background: #4CAF50;
    color: #fff;
    padding: 15px 20px;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    font-size: 16px;
    z-index: 9999;
    display: flex;
    align-items: center;
    gap: 10px;
    opacity: 0;
    animation: fadeInOut 4s forwards;
  }
  
  @keyframes fadeInOut {
    0% { opacity: 0; transform: scale(0.8); }
    20% { opacity: 1; transform: scale(1); }
    80% { opacity: 1; transform: scale(1); }
    100% { opacity: 0; transform: scale(0.8); }
  }
  
  .checkmark {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    border: 2px solid #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    animation: pop 0.5s ease-out forwards;
  }
  
  .checkmark::after {
    content: "\2713";
    font-size: 16px;
    opacity: 0;
    animation: checkFade 0.5s ease-out forwards;
    animation-delay: 0.2s;
  }
  
  @keyframes pop {
    0% { transform: scale(0); }
    50% { transform: scale(1.2); }
    100% { transform: scale(1); }
  }
  
  @keyframes checkFade {
    0% { opacity: 0; }
    100% { opacity: 1; }
  }
</style>
</head>
<body>
<div class="container">
    <!-- Back Button -->
    <a href="vaccinationSchedule.jsp" class="btn-back">
        <i class="fas fa-arrow-left"></i> Back to Profile
    </a>
    
    <!-- Hero Section -->
    <div class="hero-section">
        <div class="hero-content">
            <h1 class="hero-title">Record Reaction</h1>
            <p class="hero-subtitle">Select a profile and appointment to record your post-vaccination reaction</p>
        </div>
    </div>
    
    <!-- Display Registered Child Profiles (Tiles) -->
    <h2>Select a Registered Child Profile</h2>
    <div class="appointments-grid">
    <%
       // Retrieve the CustomerDTO object from session
       CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
       String userID = null;
       if (loginUser != null) {
           userID = loginUser.getUserID();
       }
       List<child.ChildDTO> childList = new ArrayList<>();
       if (userID != null) {
           try {
               child.ChildDAO childDAO = new child.ChildDAO();
               childList = childDAO.getAllChildrenByUserID(userID);
           } catch (Exception ex) {
               ex.printStackTrace();
           }
       }
       if (childList == null || childList.isEmpty()) {
           out.println("<p>No profile available.</p>");
       } else {
           for (child.ChildDTO c : childList) {
    %>
        <button type="button" class="profile-tile" onclick="openAppointmentModal(<%= c.getChildID() %>)">
            <div><strong>Child Name:</strong> <%= c.getChildName() %></div>
            <div><strong>Date of Birth:</strong> <%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(c.getDateOfBirth()) %></div>
            <div><strong>Gender:</strong> <%= c.getGender() %></div>
        </button>
    <%
           }
       }
    %>
    </div>
    
    <!-- Reaction Recording Form -->
    <div class="registration-card">
        <div class="form-header">
            <h2>Record Post-Vaccination Reaction</h2>
            <p>Select an appointment from the modal above to record your reaction</p>
        </div>
        <form action="RecordReactionController" method="post">
            <div class="form-group">
                <label for="appointmentID">Appointment ID:</label>
                <input type="text" id="appointmentID" name="appointmentID" class="form-control" readonly required />
            </div>
            <div class="form-group">
                <label for="reaction">Reaction (if any):</label>
                <textarea id="reaction" name="reaction" class="form-control" placeholder="Enter post-vaccination reaction (e.g., fever, rash, shock,...)"></textarea>
            </div>
            <button type="submit" class="submit-btn">Record Reaction</button>
        </form>
    </div>
</div>

<!-- Modal to Display Child's Appointment List -->
<div id="appointmentModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeAppointmentModal()">&times;</span>
        <h3>Select Appointment</h3>
        <div id="appointmentList" class="appointment-list">
            <!-- The appointment list will be loaded via AJAX from GetAppointmentsByChildIDController -->
        </div>
    </div>
</div>

<script>
    // Open modal and load appointment list for the selected childID via AJAX
    function openAppointmentModal(childID) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "GetAppointmentsByChildIDController?childID=" + childID, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                document.getElementById("appointmentList").innerHTML = xhr.responseText;
                document.getElementById("appointmentModal").style.display = "block";
            }
        };
        xhr.send();
    }
    
    // When the user selects an appointment in the modal
    function selectAppointment(appointmentID) {
        document.getElementById("appointmentID").value = appointmentID;
        closeAppointmentModal();
        showNotification("Appointment selected successfully!");
    }
    
    function closeAppointmentModal() {
        document.getElementById("appointmentModal").style.display = "none";
    }
    
    window.onclick = function(event) {
        var modal = document.getElementById("appointmentModal");
        if (event.target === modal) {
            modal.style.display = "none";
        }
    }
    
    // Function to display a notification popup with animation (animated checkmark)
    function showNotification(message) {
        var notification = document.createElement("div");
        notification.classList.add("notification");
        
        var checkmark = document.createElement("div");
        checkmark.classList.add("checkmark");
        
        var msgSpan = document.createElement("span");
        msgSpan.innerText = message;
        
        notification.appendChild(checkmark);
        notification.appendChild(msgSpan);
        document.body.appendChild(notification);
        
        // Automatically remove the notification after 4 seconds (per defined animation duration)
        setTimeout(function() {
            notification.remove();
        }, 4000);
    }
    
    // Check if the URL has a "msg" parameter then display a notification popup
    window.addEventListener("DOMContentLoaded", function() {
        var urlParams = new URLSearchParams(window.location.search);
        var msg = urlParams.get("msg");
        if (msg) {
            // Decode the URL string
            showNotification(decodeURIComponent(msg));
            // Remove the parameter from the URL to prevent re-display on reload
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    });
</script>
</body>
</html>
