<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="customer.CustomerDTO" %>
<%@ page import="feedback.FeedbackDTO" %>

<% // Kiểm tra đăng nhập 
    CustomerDTO loggedInUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
    if (loggedInUser == null) {
        response.sendRedirect("vaccinationSchedule.jsp");
        return;
    }
    String userID = loggedInUser.getUserID();
    String fullName = loggedInUser.getFullName();
    List<FeedbackDTO> feedbackList = (List<FeedbackDTO>) request.getAttribute("userFeedback");
    String feedbackSuccess = (String) session.getAttribute("FEEDBACK_SUCCESS");
    String feedbackError = (String) session.getAttribute("FEEDBACK_ERROR");

    // Xóa session message sau khi hiển thị
    session.removeAttribute("FEEDBACK_SUCCESS");
    session.removeAttribute("FEEDBACK_ERROR");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <title>Submit Feedback</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
            }

            body {
                background: #f0f7fa;
                color: #333;
                line-height: 1.6;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .hero-section {
                background: linear-gradient(rgba(25, 47, 89, 0.8), rgba(11, 34, 77, 0.9)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880745.jpg');
                background-size: cover;
                background-position: center;
                padding: 80px 0;
                color: white;
                text-align: center;
            }

            .hero-title {
                font-size: 2.5em;
                margin-bottom: 20px;
                font-weight: 700;
                color: #fff;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
            }

            .hero-subtitle {
                font-size: 1.2em;
                color: rgba(255, 255, 255, 0.9);
                max-width: 600px;
                margin: 0 auto;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 40px 20px;
                flex: 1;
            }

            .feedback-wrapper {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 30px;
                margin: -60px auto 40px;
                position: relative;
            }

            .feedback-form {
                background: white;
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }

            .form-header {
                margin-bottom: 30px;
                text-align: center;
            }

            .form-header h2 {
                color: #192f59;
                font-size: 1.8em;
                margin-bottom: 10px;
            }

            .form-group {
                margin-bottom: 25px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #192f59;
                font-weight: 500;
            }

            .form-control {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e1e8ef;
                border-radius: 10px;
                font-size: 1em;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                border-color: #4a90e2;
                box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
                outline: none;
            }

            .rating-group {
                display: flex;
                gap: 10px;
                margin: 15px 0;
            }

            .rating-btn {
                flex: 1;
                padding: 12px;
                border: 2px solid #e1e8ef;
                border-radius: 10px;
                background: white;
                cursor: pointer;
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .rating-btn:hover {
                border-color: #4a90e2;
                background: #f8fafd;
            }

            .rating-btn.selected {
                background: #4a90e2;
                color: white;
                border-color: #4a90e2;
            }

            .submit-btn {
                width: 100%;
                padding: 15px;
                background: #4a90e2;
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 1.1em;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .submit-btn:hover {
                background: #357abd;
                transform: translateY(-2px);
            }

            .previous-feedback {
                background: white;
                padding: 30px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }

            .previous-feedback h3 {
                color: #192f59;
                font-size: 1.5em;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 2px solid #e1e8ef;
            }

            .feedback-item {
                padding: 20px;
                background: #f8fafd;
                border-radius: 15px;
                margin-bottom: 20px;
                transition: all 0.3s ease;
            }

            .feedback-item:hover {
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }

            .feedback-date {
                color: #666;
                font-size: 0.9em;
                margin-bottom: 10px;
            }

            .feedback-rating {
                color: #f1c40f;
                margin: 10px 0;
            }

            .feedback-text {
                color: #2c3e50;
                line-height: 1.6;
            }

            .message {
                padding: 15px 20px;
                border-radius: 10px;
                margin-bottom: 20px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .error {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .continue-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                padding: 15px 30px;
                background: #4CAF50;
                color: white;
                text-decoration: none;
                border-radius: 10px;
                font-weight: 500;
                margin-top: 20px;
                transition: all 0.3s ease;
            }

            .continue-btn:hover {
                background: #45a049;
                transform: translateY(-2px);
            }

            .footer {
                background: linear-gradient(135deg, #192f59 0%, #0b224d 100%);
                color: #fff;
                padding: 80px 0 0;
                margin-top: auto;
            }

            .footer-content {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 40px;
            }

            .footer-section {
                background: rgba(255, 255, 255, 0.05);
                border-radius: 15px;
                padding: 30px;
                backdrop-filter: blur(10px);
            }

            .footer-section h3 {
                color: #fff;
                font-size: 1.4em;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li {
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .footer-bottom {
                background: rgba(0, 0, 0, 0.2);
                text-align: center;
                padding: 20px 0;
                margin-top: 60px;
            }

            @media (max-width: 768px) {
                .feedback-wrapper {
                    grid-template-columns: 1fr;
                }
                
                .hero-section {
                    padding: 60px 20px;
                }
                
                .feedback-form, .previous-feedback {
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        <div class="hero-section">
            <h1 class="hero-title">Your Feedback Matters</h1>
            <p class="hero-subtitle">Help us improve our services by sharing your experience</p>
        </div>

        <div class="container">
            <div class="feedback-wrapper">
                <div class="feedback-form">
                    <div class="form-header">
                        <h2>Submit Your Feedback</h2>
                        <p>Please share your thoughts with us</p>
                    </div>

                    <% if (feedbackSuccess != null) { %>
                    <div class="message success">
                        <i class="fas fa-check-circle"></i>
                        <%= feedbackSuccess %>
                    </div>
                    <% } else if (feedbackError != null) { %>
                    <div class="message error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= feedbackError %>
                    </div>
                    <% } %>

                    <form action="FeedbackController" method="POST">
                        <div class="form-group">
                            <label for="centerID"><i class="fas fa-hospital"></i> Select Center</label>
                            <select id="centerID" name="centerID" class="form-control" required>
                                <option value="">Choose a center...</option>
                                <option value="1">Center 1 (Ha Noi)</option>
                                <option value="2">Center 2 (TP HCM)</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="rating"><i class="fas fa-star"></i> Rating</label>
                            <div class="rating-group">
                                <% for (int i = 1; i <= 5; i++) { %>
                                <button type="button" class="rating-btn" data-rating="<%= i %>">
                                    <%= i %> <i class="fas fa-star"></i>
                                </button>
                                <% } %>
                            </div>
                            <input type="hidden" name="rating" id="ratingInput" required>
                        </div>

                        <div class="form-group">
                            <label for="feedbackText"><i class="fas fa-comment"></i> Your Feedback</label>
                            <textarea id="feedbackText" name="feedbackText" class="form-control"
                                    placeholder="Share your experience with us..." required></textarea>
                        </div>

                        <button type="submit" class="submit-btn">
                            <i class="fas fa-paper-plane"></i> Submit Feedback
                        </button>
                    </form>

                    <% if (feedbackSuccess != null) { %>
                    <a href="vaccinationSchedule.jsp" class="continue-btn">
                        <i class="fas fa-home"></i> Return to Home
                    </a>
                    <% } %>
                </div>

                <div class="previous-feedback">
                    <h3><i class="fas fa-history"></i> Your Previous Feedback</h3>
                    <% if (feedbackList != null && !feedbackList.isEmpty()) { %>
                        <% for (FeedbackDTO feedback : feedbackList) { %>
                        <div class="feedback-item">
                            <div class="feedback-date">
                                <i class="fas fa-calendar"></i>
                                <%= feedback.getFeedbackDate() %>
                            </div>
                            <div class="feedback-rating">
                                <% for (int i = 0; i < feedback.getRating(); i++) { %>
                                <i class="fas fa-star"></i>
                                <% } %>
                            </div>
                            <div class="feedback-text">
                                <%= feedback.getFeedbackText() %>
                            </div>
                        </div>
                        <% } %>
                    <% } else { %>
                        <p><i class="fas fa-info-circle"></i> No feedback submitted yet.</p>
                    <% } %>
                </div>
            </div>
        </div>

        <footer class="footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h3><i class="fas fa-map-marker-alt"></i> Hệ Thống Miền Bắc</h3>
                    <ul>
                        <li><i class="fas fa-map-marker-alt"></i> Số 180 Trường Chinh, Hà Nội</li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3><i class="fas fa-map-marker-alt"></i> Hệ Thống Miền Nam</h3>
                    <ul>
                        <li><i class="fas fa-map-marker-alt"></i> Số 198 Nguyễn Thị Minh Khai, Quận 1, TP.HCM</li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3><i class="fas fa-clock"></i> Giờ Làm Việc</h3>
                    <ul>
                        <li><i class="fas fa-sun"></i> Sáng: 08:00 - 12:00</li>
                        <li><i class="fas fa-moon"></i> Chiều: 13:00 - 17:00</li>
                        <li><i class="fas fa-calendar-alt"></i> Từ Thứ 2 - Chủ Nhật</li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Vaccine Booking System. All Rights Reserved.</p>
            </div>
        </footer>

        <script>
            const ratingBtns = document.querySelectorAll('.rating-btn');
            const ratingInput = document.getElementById('ratingInput');

            ratingBtns.forEach(btn => {
                btn.addEventListener('click', () => {
                    ratingBtns.forEach(b => b.classList.remove('selected'));
                    btn.classList.add('selected');
                    ratingInput.value = btn.dataset.rating;
                });
            });
        </script>
    </body>
</html>