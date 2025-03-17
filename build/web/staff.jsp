<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<!-- Add this near the top of staff.jsp, after the taglib declarations -->
<c:if test="${not empty paymentList}">
    <!-- Debug information -->
    <div style="display: none;">
        <p>Number of payments: ${paymentList.size()}</p>
        <p>Pending count: ${pendingCount}</p>
        <p>Confirmed count: ${confirmedCount}</p>
        <p>Cancelled count: ${cancelledCount}</p>
    </div>
</c:if>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Staff Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
            }

            body {
                background: #f5f7fb;
                color: #333;
                line-height: 1.6;
                padding: 20px;
            }

            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)),
                    url('https://img.freepik.com/free-photo/close-up-hand-with-latex-gloves-holding-vaccine_23-2148962819.jpg?w=2000');
                background-size: cover;
                background-position: center;
                padding: 80px 0;
                text-align: center;
                color: white;
                border-radius: 15px;
                margin-bottom: 30px;
            }

            .hero-title {
                font-size: 2.5em;
                margin-bottom: 20px;
                font-weight: 700;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            }

            .dashboard-container {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            }

            .navbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px;
                background: rgba(255, 255, 255, 0.95);
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            .navbar-brand {
                font-size: 1.5em;
                font-weight: 600;
                color: #1e88e5;
                text-decoration: none;
            }

            .content-wrapper {
                margin-top: 80px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                border-radius: 8px;
                overflow: hidden;
                margin-top: 20px;
            }

            th {
                background: #1e88e5;
                color: white;
                padding: 15px;
                text-align: left;
                font-weight: 500;
            }

            td {
                padding: 12px 15px;
                border-bottom: 1px solid #eee;
            }

            tr:hover {
                background-color: #f8f9fa;
            }

            .status-button {
                padding: 8px 15px;
                border-radius: 5px;
                border: none;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-success {
                background-color: #2196f3;
                color: white;
            }

            .btn-danger {
                background-color: #f44336;
                color: white;
            }

            .badge {
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 0.85em;
                font-weight: 500;
            }

            .status-pending { color: #856404; background-color: #fff3cd; }
            .status-confirmed { color: #155724; background-color: #d4edda; }
            .status-cancelled { color: #721c24; background-color: #f8d7da; }

            .btn-group {
                margin-bottom: 20px;
            }

            .btn-group .btn {
                margin-right: 10px;
                border-radius: 5px;
            }

            .alert {
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .user-section {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .user-info {
                text-align: right;
            }

            .user-name {
                font-weight: 500;
                color: #333;
            }

            .user-role {
                font-size: 0.8em;
                color: #666;
            }

            .logout-btn {
                padding: 8px 20px;
                background-color: #f44336;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .logout-btn:hover {
                background-color: #d32f2f;
                transform: translateY(-2px);
            }

            /* Add these new styles */
            .summary-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .summary-card {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                text-align: center;
                transition: transform 0.3s ease;
            }

            .summary-card:hover {
                transform: translateY(-5px);
            }

            .summary-card i {
                font-size: 2em;
                margin-bottom: 10px;
            }

            .summary-card h3 {
                font-size: 1.2em;
                margin-bottom: 10px;
            }

            .summary-card p {
                font-size: 2em;
                font-weight: 600;
                margin: 0;
            }

            .summary-card.pending i { color: #ffc107; }
            .summary-card.confirmed i { color: #28a745; }
            .summary-card.cancelled i { color: #dc3545; }

            .table-responsive {
                overflow-x: auto;
                margin-top: 20px;
            }

            .transaction-code {
                font-family: monospace;
                font-weight: 500;
            }

            .amount {
                font-weight: 600;
                color: #2196f3;
            }

            .date {
                color: #666;
            }

            .method {
                text-transform: capitalize;
            }

            .action-buttons {
                display: flex;
                gap: 10px;
            }

            .action-buttons .btn {
                padding: 5px 10px;
            }

            @media (max-width: 768px) {
                .summary-cards {
                    grid-template-columns: 1fr;
                }
            }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="#" class="navbar-brand">
            <i class="fas fa-hospital"></i>
            Payment Management
        </a>
        <div class="user-section">
            <div class="user-info">
                <div class="user-name">Hi, ${sessionScope.STAFF_LOGIN.staffName}</div>
                <div class="user-role">Staff</div>
            </div>
            <a href="MainController?action=Logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i>
                Logout
            </a>
        </div>
    </nav>

    <div class="content-wrapper">
        <div class="hero-section">
            <h1 class="hero-title">Payment Management Dashboard</h1>
        </div>

        <div class="dashboard-container">
            <div class="btn-group">
                <button type="button" class="btn btn-outline-primary active" onclick="filterPayments('all')">
                    <i class="fas fa-list"></i> All Payments
                </button>
                <button type="button" class="btn btn-outline-warning" onclick="filterPayments('pending')">
                    <i class="fas fa-clock"></i> Pending
                </button>
                <button type="button" class="btn btn-outline-success" onclick="filterPayments('confirmed')">
                    <i class="fas fa-check-circle"></i> Confirmed
                </button>
                <button type="button" class="btn btn-outline-danger" onclick="filterPayments('cancelled')">
                    <i class="fas fa-times-circle"></i> Cancelled
                </button>
            </div>


            <div class="summary-cards">
                <div class="summary-card pending">
                    <i class="fas fa-clock"></i>
                    <h3>Pending Payments</h3>
                    <p>${pendingCount}</p>
                </div>
                <div class="summary-card confirmed">
                    <i class="fas fa-check-circle"></i>
                    <h3>Confirmed Payments</h3>
                    <p>${confirmedCount}</p>
                </div>
                <div class="summary-card cancelled">
                    <i class="fas fa-times-circle"></i>
                    <h3>Cancelled Payments</h3>
                    <p>${cancelledCount}</p>
                </div>
            </div>



            <table class="table">
                <thead>
                    <tr>
                        <th>Transaction ID</th>
                        <th>Child Name</th>
                        <th>Amount</th>
                        <th>Payment Date</th>
                        <th>Payment Method</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${paymentList}" var="payment">
                        <tr class="payment-row ${payment.status.toLowerCase()}">
                            <td>${payment.transactionCode}</td>
                            <td>${payment.childName}</td>
                            <td>$${payment.amount}</td>
                            <td>${payment.paymentDate}</td>
                            <td>${payment.paymentMethod}</td>
                            <td>
                                <span class="badge status-${payment.status.toLowerCase()}">${payment.status}</span>
                            </td>
                            <td>
                                <c:if test="${payment.status eq 'Paid'}">
                                    <form action="MainController" method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="UpdatePaymentStatus">
                                        <input type="hidden" name="paymentID" value="${payment.paymentID}">
                                        <input type="hidden" name="status" value="Confirmed">
                                        <button type="submit" class="status-button btn-success">
                                            <i class="fas fa-check"></i> Confirm
                                        </button>
                                    </form>
                                    <form action="MainController" method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="UpdatePaymentStatus">
                                        <input type="hidden" name="paymentID" value="${payment.paymentID}">
                                        <input type="hidden" name="status" value="Cancelled">
                                        <button type="submit" class="status-button btn-danger">
                                            <i class="fas fa-times"></i> Cancel
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
                
                

            <c:if test="${empty paymentList}">
                <div class="alert alert-info">No payments found.</div>
            </c:if>
        </div>
    </div>

    <script>
        function filterPayments(status) {
            const rows = document.querySelectorAll('.payment-row');
            rows.forEach(row => {
                if (status === 'all' || row.classList.contains(status)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });

            document.querySelectorAll('.btn-group .btn').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');
        }
    </script>
</body>
</html>