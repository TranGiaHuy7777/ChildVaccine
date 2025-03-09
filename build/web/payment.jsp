<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="child.ChildDTO" %>
<%@ page import="vaccine.VaccineDTO" %>

<%
    // Lấy vaccine đã chọn từ session
    VaccineDTO selectedVaccine = (VaccineDTO) session.getAttribute("selectedVaccine");

    String vaccineId = (selectedVaccine != null) ? String.valueOf(selectedVaccine.getVaccineID()) : "Unknown";
    String vaccineName = (selectedVaccine != null) ? selectedVaccine.getVaccineName() : "Không xác định";
    String vaccinePrice = (selectedVaccine != null) ? String.format("%,.0f VND", selectedVaccine.getPrice()) : "Chưa có giá";

    // Lấy thông tin trẻ từ session
    ChildDTO registeredChild = (ChildDTO) session.getAttribute("REGISTERED_CHILD");

    String childName = (registeredChild != null) ? registeredChild.getChildName() : "Unknown";
    String childGender = (registeredChild != null) ? registeredChild.getGender() : "Unknown";
    String childDOB = "Unknown";

    if (registeredChild != null && registeredChild.getDateOfBirth() != null) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        childDOB = sdf.format(registeredChild.getDateOfBirth());
    }
    // Lấy serviceType từ session
    String centerID = (session.getAttribute("centerID") != null)
            ? (String) session.getAttribute("centerID")
            : "Unknown";
    // Lấy serviceType từ session
    String appointmentDate = (session.getAttribute("appointmentDate") != null)
            ? (String) session.getAttribute("appointmentDate")
            : "Unknown";
    // Lấy serviceType từ session
    String serviceType = (session.getAttribute("serviceType") != null)
            ? (String) session.getAttribute("serviceType")
            : "Unknown";
%>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <title>Payment for Vaccination Appointment</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
            }

            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);
                color: #333;
                line-height: 1.6;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .container {
                max-width: 1200px;
                margin: 40px auto;
                padding: 0 20px;
                flex: 1;
            }

            .hero-section {
                background: linear-gradient(rgba(25, 47, 89, 0.8), rgba(11, 34, 77, 0.9)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880745.jpg');
                background-size: cover;
                background-position: center;
                padding: 60px 0;
                border-radius: 30px;
                margin-bottom: 40px;
                color: white;
                text-align: center;
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
            }

            .hero-content {
                max-width: 800px;
                margin: 0 auto;
                padding: 0 20px;
            }

            .hero-title {
                font-size: 2.5em;
                margin-bottom: 20px;
                font-weight: 700;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
            }

            .payment-wrapper {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 30px;
                margin-top: -80px;
                position: relative;
                z-index: 1;
            }

            .appointment-details, .payment-summary {
                background: white;
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
            }

            .payment-summary {
                position: sticky;
                top: 20px;
                height: fit-content;
            }

            .timeline-steps {
                display: flex;
                justify-content: space-between;
                margin: 0 auto 40px;
                max-width: 800px;
                position: relative;
                padding: 20px;
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.05);
            }

            .timeline-steps::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 40px;
                right: 40px;
                height: 2px;
                background: #e0e0e0;
                transform: translateY(-50%);
                z-index: 0;
            }

            .timeline-step {
                display: flex;
                flex-direction: column;
                align-items: center;
                z-index: 1;
                background: white;
                padding: 0 10px;
            }

            .step-icon {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: #e0e0e0;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #666;
                margin-bottom: 8px;
                transition: all 0.3s ease;
                font-size: 1.2em;
            }

            .step-icon.active {
                background: #192f59;
                color: white;
                box-shadow: 0 5px 15px rgba(25, 47, 89, 0.3);
                transform: scale(1.1);
            }

            .step-label {
                font-size: 0.9em;
                color: #666;
                text-align: center;
                font-weight: 500;
            }

            .vaccine-image-container {
                position: relative;
                width: 100%;
                height: 250px;
                margin-bottom: 30px;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            }

            .vaccine-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s ease;
            }

            .vaccine-image-container:hover .vaccine-image {
                transform: scale(1.05);
            }

            .info-group {
                margin-bottom: 30px;
                padding: 20px;
                border-radius: 15px;
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                transition: all 0.3s ease;
            }

            .info-group:hover {
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                transform: translateY(-2px);
            }

            .info-label {
                color: #192f59;
                font-size: 0.9em;
                margin-bottom: 10px;
                text-transform: uppercase;
                letter-spacing: 1px;
                font-weight: 600;
            }

            .info-value {
                font-size: 1.1em;
                color: #333;
                margin: 8px 0;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .info-value i {
                color: #192f59;
                width: 24px;
            }

            .payment-methods {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
                margin: 25px 0;
            }

            .payment-method-card {
                border: 2px solid #e0e0e0;
                border-radius: 15px;
                padding: 20px;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
                background: white;
            }

            .payment-method-card:hover {
                transform: translateY(-5px);
                border-color: #192f59;
                box-shadow: 0 10px 20px rgba(25, 47, 89, 0.1);
            }

            .payment-method-card.selected {
                border-color: #192f59;
                background: #f8f9fa;
            }

            .payment-icon {
                font-size: 2.5em;
                margin-bottom: 15px;
                color: #192f59;
            }

            .confirm-button {
                width: 100%;
                padding: 15px;
                background: #192f59;
                color: white;
                border: none;
                border-radius: 12px;
                font-size: 1.1em;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                margin-top: 20px;
            }

            .confirm-button:hover {
                background: #0b224d;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(25, 47, 89, 0.2);
            }

            .price {
                font-size: 2em;
                font-weight: 700;
                color: #192f59;
                margin: 20px 0;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 15px;
                text-align: right;
                border: 1px solid #e9ecef;
                transition: all 0.3s ease;
            }

            .price:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            }

            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 8px 16px;
                border-radius: 30px;
                font-size: 0.9em;
                font-weight: 500;
                background: #fff3cd;
                color: #856404;
                border: 1px solid #ffeeba;
            }

            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.8);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 1000;
                animation: fadeIn 0.3s ease;
                backdrop-filter: blur(5px);
            }

            .modal-content {
                background: white;
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
                text-align: center;
                max-width: 450px;
                width: 90%;
                animation: slideIn 0.3s ease;
            }

            .qr-code {
                margin: 25px 0;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 15px;
                border: 1px solid #e9ecef;
            }

            .qr-code img {
                width: 250px;
                height: 250px;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }

            .payment-buttons {
                display: flex;
                gap: 15px;
                margin-top: 25px;
                justify-content: center;
            }

            .payment-button {
                padding: 12px 24px;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .confirm-payment {
                background: #192f59;
                color: white;
            }

            .confirm-payment:hover {
                background: #0b224d;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(25, 47, 89, 0.2);
            }

            .cancel-payment {
                background: #dc3545;
                color: white;
            }

            .cancel-payment:hover {
                background: #c82333;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(220, 53, 69, 0.2);
            }

            .notification {
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 20px;
                border-radius: 15px;
                background: white;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                display: flex;
                align-items: center;
                gap: 15px;
                z-index: 1000;
                animation: slideInRight 0.5s ease;
                max-width: 350px;
                border-left: 5px solid #192f59;
            }

            @media (max-width: 768px) {
                .payment-wrapper {
                    grid-template-columns: 1fr;
                    margin-top: 0;
                }

                .hero-title {
                    font-size: 2em;
                }

                .container {
                    padding: 15px;
                    margin: 20px auto;
                }

                .timeline-steps {
                    padding: 15px;
                    margin-bottom: 30px;
                }

                .step-icon {
                    width: 40px;
                    height: 40px;
                    font-size: 1em;
                }

                .payment-methods {
                    grid-template-columns: 1fr;
                }

                .appointment-details, .payment-summary {
                    padding: 20px;
                }

                .vaccine-image-container {
                    height: 200px;
                }
            }

            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            @keyframes slideIn {
                from { transform: translateY(-50px); opacity: 0; }
                to { transform: translateY(0); opacity: 1; }
            }

            @keyframes slideInRight {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
        </style>

    </head>
    <body>

        <div class="container">

            <div class="hero-section">
                <div class="hero-content">
                    <h1 class="hero-title">Complete Your Vaccination Payment</h1>
                    <p>Please review your appointment details and complete the payment</p>
                </div>
            </div>

            <div class="timeline-steps">
                <div class="timeline-step">
                    <div class="step-icon active">
                        <i class="fas fa-syringe"></i>
                    </div>
                    <div class="step-label">Select Vaccine</div>
                </div>
                <div class="timeline-step">
                    <div class="step-icon active">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="step-label">Schedule</div>
                </div>
                <div class="timeline-step">
                    <div class="step-icon active">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <div class="step-label">Payment</div>
                </div>
                <div class="timeline-step">
                    <div class="step-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="step-label">Complete</div>
                </div>
            </div>

            <div class="payment-wrapper">


                <div class="appointment-details">
                    <h2><i class="fas fa-info-circle"></i> Appointment Details</h2>

                    <div class="vaccine-image-container">
                        <img src="https://img.freepik.com/free-photo/close-up-doctor-vaccinating-patient_23-2149098203.jpg" 
                             alt="Vaccination" 
                             class="vaccine-image">
                    </div>
                    <div class="info-group">
                        <div class="info-label">Child Information</div>
                        <div class="info-value"><i class="fas fa-child"></i> <%= childName%></div>
                        <div class="info-value"><i class="fas fa-calendar"></i> <%= childDOB%></div>
                        <div class="info-value"><i class="fas fa-venus-mars"></i> <%= childGender%></div>
                    </div>

                    <div class="info-group">
                        <div class="info-label">Vaccine Information and Appointment Date</div>
                        <div class="info-value"><i class="fas fa-syringe"></i> <%= vaccineName%></div>
                        <div class="info-value"><i class="fas fa-hashtag"></i> Vaccine ID: <%= vaccineId%></div>
                        <div class="info-value"><i class="fas fa-hashtag"></i> Center ID: <%= centerID%></div>  Note :   1 - VNVC Ha Noi / 2 - VNVC Ho Chi Minh
                        <div class="info-value"><i class="fas fa-hashtag"></i> Appointment Date: <%= appointmentDate%></div>
                        <div class="info-value"><i class="fas fa-stethoscope"></i> <%= serviceType%></div>
                    </div>

                    <div class="status-badge">
                        <i class="fas fa-clock"></i> Pending Payment
                    </div>
                </div>
                <div class="payment-summary">
                    <h2><i class="fas fa-credit-card"></i> Payment Summary</h2>

                    <div class="info-group">
                        <div class="info-label">Package Selected</div>
                        <div class="info-value"><%= vaccineName%></div>
                        <div class="price">
                            <i class="fas fa-tag"></i> <%= vaccinePrice%>
                        </div>
                    </div>
                    <form id="paymentForm" action="PaymentServlet" method="POST">
                        <div class="payment-methods">
                            <div class="payment-method-card" data-value="cash">
                                <div class="payment-icon">💵</div>
                                <div>Cash Payment</div>
                            </div>
                            <div class="payment-method-card" data-value="credit_card">
                                <div class="payment-icon">💳</div>
                                <div>Credit Card</div>
                            </div>
                            <div class="payment-method-card" data-value="e_wallet">
                                <div class="payment-icon">📱</div>
                                <div>E-Wallet</div>
                            </div>
                        </div>
                        <input type="hidden" id="selectedPaymentMethod" name="paymentMethod" required>

                        <button type="submit" class="confirm-button">
                            <i class="fas fa-check-circle"></i> Confirm Payment
                        </button>
                    </form>

                    <div id="successMessage" class="success-message">
                        <i class="fas fa-check-circle"></i> Please wait, redirecting to feedback...
                    </div>
                </div>
            </div>

        </div>



        <script>
            // Payment method selection
            const paymentCards = document.querySelectorAll('.payment-method-card');
            const paymentMethodInput = document.getElementById('selectedPaymentMethod');

            paymentCards.forEach(card => {
                card.addEventListener('click', () => {
                    // Remove selected class from all cards
                    paymentCards.forEach(c => c.classList.remove('selected'));
                    // Add selected class to clicked card
                    card.classList.add('selected');
                    // Update hidden input value
                    paymentMethodInput.value = card.dataset.value;
                });
            });

            document.getElementById('paymentForm').addEventListener('submit', function (e) {
                e.preventDefault();

                const paymentMethod = document.getElementById('selectedPaymentMethod').value;
                if (!paymentMethod) {
                    alert('Vui lòng chọn phương thức thanh toán');
                    return;
                }

                if (paymentMethod === 'cash') {
                    const notification = document.createElement('div');
                    notification.className = 'notification info';
                    notification.innerHTML = `
            <i class="fas fa-info-circle"></i>
            <div>
                <div style="font-weight: 600; margin-bottom: 5px;">Thanh toán tiền mặt</div>
                <div>Vui lòng đến cơ sở tiêm chủng gần nhất để thanh toán! Cảm ơn quý khách!</div>
            </div>
        `;
                    document.body.appendChild(notification);
                    setTimeout(() => {
                        window.location.href = 'feedback.jsp';
                    }, 3000);
                } else {
                    const modal = document.createElement('div');
                    modal.className = 'modal-overlay';
                    modal.innerHTML = `
            <div class="modal-content">
                <span class="close-modal">&times;</span>
                <h3 style="margin-bottom: 15px; color: #2c3e50;">
                    <i class="fas fa-qrcode"></i> Quét mã để thanh toán
                </h3>
                <div class="qr-code">
                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=Demo_Payment_${paymentMethod}_${vaccineId}" 
                         alt="QR Code">
                </div>
                <p style="color: #666; margin-top: 15px;">
                    Vui lòng quét mã QR để hoàn tất thanh toán
                </p>
                <div class="payment-buttons">
                    <button class="payment-button confirm-payment">
                        <i class="fas fa-check"></i> Xác nhận đã thanh toán
                    </button>
                    <button class="payment-button cancel-payment">
                        <i class="fas fa-times"></i> Hủy
                    </button>
                </div>
            </div>
        `;
                    document.body.appendChild(modal);

                    // Close button handler
                    modal.querySelector('.close-modal').onclick = () => {
                        if (confirm('Are you sure you want to cancel payment?')) {
                            modal.remove();
                        }
                    };

                    // Confirm payment button
                    modal.querySelector('.confirm-payment').onclick = () => {
                        modal.remove();
                        window.location.href = 'feedback.jsp';
                    };

                    // Cancel payment button
                    modal.querySelector('.cancel-payment').onclick = () => {
                        if (confirm('Are you sure you want to cancel payment?')) {
                            modal.remove();
                        }
                    };// Click outside to show confirmation
                    modal.onclick = (e) => {
                        if (e.target === modal) {
                            if (confirm('Are you sure you want to cancel payment?')) {
                                modal.remove();
                            }
                        }
                    };
                }
            });
        </script>

    </body>
</html>
