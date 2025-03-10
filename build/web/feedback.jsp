<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="customer.CustomerDTO" %>
<%@ page import="feedback.FeedbackDTO" %>

<%
    // Kiểm tra đăng nhập
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
                background-color: #f0f2f5;
                color: #333;
                line-height: 1.6;
                min-height: 100vh;
            }

            .hero-section {
                background: linear-gradient(rgba(41, 128, 185, 0.9), rgba(52, 152, 219, 0.9)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880745.jpg');
                background-size: cover;
                background-position: center;
                padding: 60px 0;
                color: white;
                text-align: center;
                margin-bottom: 40px;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }

            .feedback-wrapper {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 30px;
                margin: 40px auto;
            }

            .feedback-form {
                background: white;
                padding: 30px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }

            .previous-feedback {
                background: white;
                padding: 30px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                height: fit-content;
            } .form-group {
                margin-bottom: 25px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
            }

            .form-control {
                width: 100%;
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-size: 1em;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                border-color: #3498db;
                outline: none;
                box-shadow: 0 0 10px rgba(52, 152, 219, 0.1);
            }
            textarea.form-control {
                min-height: 120px;
                resize: vertical;
            }

            .rating-group {
                display: flex;
                gap: 10px;
                margin: 15px 0;
            }

            .rating-btn {
                flex: 1;
                padding: 10px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                background: white;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .rating-btn:hover {
                border-color: #3498db;
                background: #f7f9fc;
            } .rating-btn.selected {
                background: #3498db;
                color: white;
                border-color: #3498db;
            }

            .submit-btn {
                width: 100%;
                padding: 15px;
                background: #3498db;
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 1.1em;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .submit-btn:hover {
                background: #2980b9;
                transform: translateY(-2px);
            }
            .message {
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                font-weight: 500;
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

            .feedback-item {
                padding: 15px;
                border-bottom: 1px solid #eee;
                margin-bottom: 15px;
            } .feedback-date {
                color: #666;
                font-size: 0.9em;
            }

            .feedback-rating {
                color: #f1c40f;
                margin: 5px 0;
            }

            .feedback-text {
                color: #2c3e50;
            }

            .delete-btn {
                background: #e74c3c;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 8px;
                font-size: 1em;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .delete-btn:hover {
                background: #c0392b;
                transform: scale(1.05);
            }

            .delete-btn i {
                font-size: 1.1em;
            }

            .continue-btn {
                display: inline-block;
                background: #27ae60;
                color: white;
                text-decoration: none;
                padding: 12px 20px;
                border-radius: 8px;
                font-size: 1.1em;
                font-weight: 600;
                transition: all 0.3s ease;
                text-align: center;
                margin-top: 15px;
            }

            .continue-btn:hover {
                background: #219150;
                transform: scale(1.05);
            }

            @media (max-width: 768px) {
                .feedback-wrapper {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>

        <div class="hero-section">
            <div class="container">
                <h1>Your Feedback Matters</h1>
                <p>Help us improve our services by sharing your experience</p>
            </div>
        </div>

        <div class="container">

            <div class="feedback-wrapper">
                <div class="feedback-form">
                    <h2><i class="fas fa-comment-dots"></i> Submit Your Feedback</h2>

                    <% if (feedbackSuccess != null) {%>
                    <div class="message success">
                        <i class="fas fa-check-circle"></i> <%= feedbackSuccess%>
                    </div>
                    <% } else if (feedbackError != null) {%>
                    <div class="message error">
                        <i class="fas fa-exclamation-circle"></i> <%= feedbackError%>
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
                        </div> <div class="form-group">
                            <label for="rating"><i class="fas fa-star"></i> Rating</label>
                            <div class="rating-group">
                                <% for (int i = 1; i <= 5; i++) {%>
                                <button type="button" class="rating-btn" data-rating="<%= i%>">
                                    <%= i%> <i class="fas fa-star"></i>
                                </button>
                                <% } %>
                            </div>
                            <input type="hidden" name="rating" id="ratingInput" required>
                        </div>

                        <div class="form-group">
                            <label for="feedbackText"><i class="fas fa-pen"></i> Your Feedback</label>
                            <textarea id="feedbackText" name="feedbackText" class="form-control" 
                                      placeholder="Share your experience with us..." required></textarea>
                        </div>

                        <button type="submit" class="submit-btn">
                            <i class="fas fa-paper-plane"></i> Submit Feedback
                        </button>
                    </form>
                </div>
                <div class="previous-feedback">
                    <h3><i class="fas fa-history"></i> Your Previous Feedback</h3>
                    <% if (feedbackList != null && !feedbackList.isEmpty()) { %>
                    <% for (FeedbackDTO feedback : feedbackList) {%>
                    <div class="feedback-item">
                        <div class="feedback-date">
                            <i class="fas fa-calendar"></i> <%= feedback.getFeedbackDate()%>
                        </div>
                        <div class="feedback-rating">
                            <% for (int i = 0; i < feedback.getRating(); i++) { %>
                            <i class="fas fa-star"></i>
                            <% }%>
                        </div>
                        <div class="feedback-text">
                            <%= feedback.getFeedbackText()%>
                        </div>
                        <form action="DeleteFeedbackController" method="POST" onsubmit="return confirm('Are you sure you want to delete this feedback?');">
                            <input type="hidden" name="feedbackID" value="<%= feedback.getFeedbackID()%>">
                            <button type="submit" class="delete-btn">
                                <i class="fas fa-trash-alt"></i> Delete
                            </button>
                        </form>
                    </div>
                    <% } %>
                    <% } else { %>
                    <p><i class="fas fa-info-circle"></i> No feedback submitted yet.</p>
                    <% } %>
                </div>

            </div>
            <!-- Hiển thị thông báo thành công hoặc lỗi -->
            <% if (feedbackSuccess != null) {%>
            <a href="paymentSuccess.jsp" class="continue-btn">Done & Thankyou</a>
            <p class="message success"><%= feedbackSuccess%></p>
            <% } else if (feedbackError != null) {%>
            <p class="message error"><%= feedbackError%></p>
            <% }%>


        </div>

        <script>
            // Rating buttons functionality
            const ratingBtns = document.querySelectorAll('.rating-btn');
            const ratingInput = document.getElementById('ratingInput');

            ratingBtns.forEach(btn => {
                btn.addEventListener('click', () => {
                    // Remove selected class from all buttons
                    ratingBtns.forEach(b => b.classList.remove('selected'));
                    // Add selected class to clicked button
                    btn.classList.add('selected');
                    // Update hidden input value
                    ratingInput.value = btn.dataset.rating;
                });
            });
        </script>
    </body>
</html>
