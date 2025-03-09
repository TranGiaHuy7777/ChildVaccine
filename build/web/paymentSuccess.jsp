<%-- 
    Document   : paymentSuccess
    Created on : Feb 17, 2025, 2:41:33 PM
    Author     : Windows
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payment Success</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
            }

            body {
                background-color: #f0f2f5;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }

            .hero-section {
                background: linear-gradient(rgba(41, 128, 185, 0.9), rgba(52, 152, 219, 0.9)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880745.jpg');
                background-size: cover;
                background-position: center;
                width: 100%;
                padding: 60px 0;
                text-align: center;
                color: white;
                margin-bottom: 40px;
            }.container {
                width: 90%;
                max-width: 500px;
                background: white;
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                text-align: center;
                position: relative;
                margin-top: -80px;
            }

            .success-icon {
                width: 100px;
                height: 100px;
                background: #ebfaf0;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 30px;
                animation: scaleIn 0.5s ease-out;
            } .success-icon i {
                font-size: 50px;
                color: #2ecc71;
            }

            h2 {
                color: #2c3e50;
                font-size: 28px;
                margin-bottom: 20px;
                font-weight: 600;
            }

            .message {
                color: #666;
                font-size: 16px;
                line-height: 1.6;
                margin-bottom: 30px;
            }

            .timer {
                font-size: 14px;
                color: #95a5a6;
                margin-bottom: 20px;
            } .back-link {
                display: inline-block;
                padding: 12px 30px;
                background: #3498db;
                color: white;
                text-decoration: none;
                border-radius: 50px;
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .back-link:hover {
                background: #2980b9;
                transform: translateY(-2px);
            }@keyframes scaleIn {
                from {
                    transform: scale(0);
                }
                to {
                    transform: scale(1);
                }
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .container {
                animation: fadeIn 0.8s ease-out;
            }.progress-bar {
                width: 100%;
                height: 4px;
                background: #eee;
                border-radius: 2px;
                margin: 20px 0;
                overflow: hidden;
            }

            .progress {
                width: 100%;
                height: 100%;
                background: #3498db;
                animation: progress 5s linear;
            }

            @keyframes progress {
                from { width: 100%; }
                to { width: 0%; }
            }
        </style>


    </head>
    <body>
        <div class="hero-section">
            <h1>Thank You!</h1>
        </div>
        <div class="container">
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h2>Payment Successful!</h2>
            <p class="message">Your vaccination appointment has been confirmed. We look forward to seeing you!</p>

            <div class="progress-bar">
                <div class="progress"></div>
            </div>

            <p class="timer">Redirecting to vaccination schedule in <span id="countdown">5</span> seconds</p>
            <a href="vaccinationSchedule.jsp" class="back-link">
                <i class="fas fa-calendar-alt"></i> View Schedule
            </a>
        </div>
    </body>

    <script>
        // Tự động chuyển về trang lịch tiêm sau 5 giây
        setTimeout(function () {
            window.location.href = "vaccinationSchedule.jsp";
        }, 5000);
    </script>
</html>
