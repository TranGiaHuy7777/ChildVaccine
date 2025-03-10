<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="java.util.List" %>
        <%@page import="appointment.AppointmentDTO" %>
            <%@page import="appointment.AppointmentDAO" %>
                <%@page import="customer.CustomerDTO" %>
                    <!DOCTYPE html>
                    <html>

                    <head>
                        <title>Appointment History</title>
                        <style>
                            body {
                                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                background-color: #f0f2f5;
                                margin: 0;
                                padding: 0;
                                min-height: 100vh;
                            }

                            .container {
                                width: 80%;
                                max-width: 1200px;
                                margin: 30px auto;
                                background: white;
                                padding: 25px;
                                border-radius: 12px;
                                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
                            }

                            h2 {
                                color: #1a73e8;
                                margin-bottom: 30px;
                                font-size: 28px;
                                font-weight: 600;
                            }

                            table {
                                width: 100%;
                                border-collapse: collapse;
                                margin: 25px 0;
                                background: white;
                                border-radius: 8px;
                                overflow: hidden;
                            }

                            table,
                            th,
                            td {
                                border: none;
                            }

                            th {
                                background-color: #1a73e8;
                                color: white;
                                font-weight: 500;
                                padding: 12px;
                                text-transform: uppercase;
                                font-size: 14px;
                            }

                            td {
                                padding: 12px;
                                border-bottom: 1px solid #eee;
                                color: #333;
                            }

                            tr:hover {
                                background-color: #f8f9fa;
                            }

                            .search-box {
                                margin: 20px 0 30px 0;
                                display: flex;
                                justify-content: center;
                                gap: 10px;
                            }

                            .search-box input {
                                padding: 12px 20px;
                                width: 50%;
                                border: 2px solid #e0e0e0;
                                border-radius: 8px;
                                font-size: 15px;
                                transition: all 0.3s ease;
                            }

                            .search-box input:focus {
                                border-color: #1a73e8;
                                outline: none;
                                box-shadow: 0 0 0 3px rgba(26, 115, 232, 0.1);
                            }

                            .search-box button {
                                padding: 12px 25px;
                                background-color: #1a73e8;
                                color: white;
                                border: none;
                                border-radius: 8px;
                                cursor: pointer;
                                font-size: 15px;
                                font-weight: 500;
                                transition: all 0.3s ease;
                            }

                            .search-box button:hover {
                                background-color: #1557b0;
                                transform: translateY(-1px);
                            }

                            .delete-btn {
                                padding: 8px 16px;
                                background-color: #dc3545;
                                color: white;
                                border: none;
                                border-radius: 6px;
                                cursor: pointer;
                                font-size: 14px;
                                transition: all 0.3s ease;
                                display: flex;
                                align-items: center;
                                gap: 5px;
                            }

                            .delete-btn:before {
                                content: "🗑️";
                                font-size: 16px;
                            }

                            .delete-btn:hover {
                                background-color: #c82333;
                                transform: translateY(-1px);
                                box-shadow: 0 2px 5px rgba(220, 53, 69, 0.3);
                            }

                            .delete-btn:active {
                                transform: translateY(0);
                            }

                            @keyframes shake {
                                0%, 100% { transform: translateX(0); }
                                25% { transform: translateX(-5px); }
                                75% { transform: translateX(5px); }
                            }

                            .delete-btn:hover {
                                animation: shake 0.3s ease-in-out;
                            }

                            /* Style cho link Home */
                            .home-link {
                                display: inline-block;
                                position: fixed;
                                bottom: 30px;
                                right: 30px;
                                padding: 15px 30px;
                                background: linear-gradient(45deg, #28a745, #34ce57);
                                color: white;
                                text-decoration: none;
                                border-radius: 50px;
                                font-size: 16px;
                                font-weight: 600;
                                text-transform: uppercase;
                                letter-spacing: 1px;
                                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
                                transition: all 0.3s ease;
                                border: 2px solid transparent;
                                display: flex;
                                align-items: center;
                                gap: 8px;
                            }

                            .home-link:before {
                                content: "🏠";
                                font-size: 18px;
                            }

                            .home-link:hover {
                                background: linear-gradient(45deg, #34ce57, #28a745);
                                transform: translateY(-3px);
                                box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
                                border-color: rgba(255, 255, 255, 0.4);
                            }

                            .home-link:active {
                                transform: translateY(-1px);
                                box-shadow: 0 3px 10px rgba(40, 167, 69, 0.3);
                            }

                            @media (max-width: 768px) {
                                .home-link {
                                    bottom: 20px;
                                    right: 20px;
                                    padding: 12px 25px;
                                    font-size: 14px;
                                }
                            }

                            /* Style cho thông báo không có lịch sử */
                            .no-history {
                                color: #dc3545;
                                padding: 20px;
                                background-color: #fff;
                                border-radius: 8px;
                                margin: 20px 0;
                                font-size: 16px;
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
                                background-color: rgba(0, 0, 0, 0.5);
                                opacity: 0;
                                transition: opacity 0.3s ease;
                            }

                            .modal.show {
                                display: block;
                                opacity: 1;
                            }

                            .modal-content {
                                background-color: #fefefe;
                                margin: 15% auto;
                                padding: 20px;
                                border-radius: 12px;
                                width: 400px;
                                position: relative;
                                transform: translateY(-50px);
                                transition: transform 0.3s ease;
                                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
                            }

                            .modal.show .modal-content {
                                transform: translateY(0);
                            }

                            .modal-header {
                                padding-bottom: 15px;
                                border-bottom: 1px solid #eee;
                                margin-bottom: 20px;
                            }

                            .modal-title {
                                margin: 0;
                                color: #dc3545;
                                font-size: 1.5em;
                            }

                            .modal-body {
                                margin-bottom: 20px;
                                color: #555;
                                font-size: 1.1em;
                                line-height: 1.5;
                            }

                            .modal-footer {
                                display: flex;
                                justify-content: flex-end;
                                gap: 10px;
                            }

                            .btn {
                                padding: 10px 20px;
                                border-radius: 6px;
                                cursor: pointer;
                                font-size: 14px;
                                font-weight: 500;
                                transition: all 0.3s ease;
                                border: none;
                            }

                            .btn-cancel {
                                background-color: #6c757d;
                                color: white;
                            }

                            .btn-cancel:hover {
                                background-color: #5a6268;
                            }

                            .btn-delete {
                                background-color: #dc3545;
                                color: white;
                            }

                            .btn-delete:hover {
                                background-color: #c82333;
                            }

                            /* Thêm style cho status badges */
                            .status-badge {
                                padding: 6px 12px;
                                border-radius: 20px;
                                font-size: 13px;
                                font-weight: 500;
                                text-transform: capitalize;
                            }

                            .status-pending {
                                background-color: #fff3cd;
                                color: #856404;
                                border: 1px solid #ffeeba;
                            }

                            .status-not-pending {
                                background-color: #f8d7da;
                                color: #721c24;
                                border: 1px solid #f5c6cb;
                            }

                            /* Cập nhật style cho modal */
                            .modal-icon {
                                font-size: 48px;
                                text-align: center;
                                margin-bottom: 20px;
                                color: #dc3545;
                            }

                            .modal-message {
                                text-align: center;
                                font-size: 1.1em;
                                margin-bottom: 25px;
                                color: #555;
                            }

                            .modal-buttons {
                                display: flex;
                                justify-content: center;
                                gap: 15px;
                            }

                            .btn {
                                padding: 10px 25px;
                                border-radius: 25px;
                                cursor: pointer;
                                font-size: 14px;
                                font-weight: 500;
                                transition: all 0.3s ease;
                                border: none;
                                text-transform: uppercase;
                                letter-spacing: 1px;
                            }

                            .btn-cancel {
                                background-color: #6c757d;
                                color: white;
                                box-shadow: 0 2px 5px rgba(108, 117, 125, 0.2);
                            }

                            .btn-cancel:hover {
                                background-color: #5a6268;
                                transform: translateY(-1px);
                                box-shadow: 0 4px 8px rgba(108, 117, 125, 0.3);
                            }

                            .btn-delete {
                                background-color: #dc3545;
                                color: white;
                                box-shadow: 0 2px 5px rgba(220, 53, 69, 0.2);
                            }

                            .btn-delete:hover {
                                background-color: #c82333;
                                transform: translateY(-1px);
                                box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
                            }
                        </style>
                        <script>
                            function confirmDelete(appointmentId) {
                                document.getElementById('deleteModal').classList.add('show');
                                document.getElementById('currentAppointmentId').value = appointmentId;
                            }

                            function closeModal() {
                                document.getElementById('deleteModal').classList.remove('show');
                            }

                            function proceedWithDeletion() {
                                const appointmentId = document.getElementById('currentAppointmentId').value;
                                if (appointmentId) {
                                    window.location.href = 'AppointmentHistoryController?action=updateStatus&appointmentID=' + appointmentId + '&status=not_pending';
                                }
                                closeModal();
                            }

                            // Đóng modal khi click bên ngoài
                            window.onclick = function(event) {
                                const modal = document.getElementById('deleteModal');
                                if (event.target === modal) {
                                    closeModal();
                                }
                            }

                            // Đóng modal khi nhấn ESC
                            document.addEventListener('keydown', function(event) {
                                if (event.key === 'Escape') {
                                    closeModal();
                                }
                            });
                        </script>
                    </head>

                    <body>
                        <%
                            CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
                            if (loginUser == null) {
                                response.sendRedirect("login.jsp");
                                return;
                            }

                            // Lấy danh sách lịch hẹn từ request hoặc tạo mới nếu chưa có
                            List<AppointmentDTO> appointmentList = (List<AppointmentDTO>) request.getAttribute("appointmentList");
                            if (appointmentList == null) {
                                AppointmentDAO dao = new AppointmentDAO();
                                try {
                                    appointmentList = dao.getAppointmentsByUserID(loginUser.getUserID());
                                    request.setAttribute("appointmentList", appointmentList);
                                } catch (Exception e) {
                                    request.setAttribute("ERROR", "Có lỗi xảy ra khi tải danh sách lịch hẹn: " + e.getMessage());
                                }
                            }
                            
                            String errorMsg = (String) request.getAttribute("ERROR");
                            String successMsg = (String) request.getAttribute("MESSAGE");
                        %>

                        <% if (errorMsg != null) { %>
                            <div class="alert alert-danger">
                                <%= errorMsg %>
                            </div>
                        <% } %>
                        <% if (successMsg != null) { %>
                            <div class="alert alert-success">
                                <%= successMsg %>
                            </div>
                        <% } %>

                        <div class="container">
                            <h2>Appointment History</h2>

                            <!-- Optional Search Form -->
                            <form action="AppointmentHistoryController" method="GET" class="search-box">
                                <input type="text" 
                                       name="searchChildID" 
                                       placeholder="Enter Child ID to filter results..." 
                                       value="<%= request.getParameter("searchChildID") != null ? request.getParameter("searchChildID") : "" %>">
                                <button type="submit">Filter</button>
                            </form>

                            <% if (appointmentList != null && !appointmentList.isEmpty()) { %>
                                <table>
                                    <tr>
                                        <th>Appointment ID</th>
                                        <th>Child Name</th>
                                        <th>Center ID</th>
                                        <th>Appointment Date</th>
                                        <th>Service Type</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                    <% for (AppointmentDTO appointment : appointmentList) { %>
                                        <tr>
                                            <td><%= appointment.getAppointmentID() %></td>
                                            <td><%= appointment.getChildName() != null ? appointment.getChildName() : appointment.getChildID() %></td>
                                            <td><%= appointment.getCenterID() %></td>
                                            <td><%= appointment.getAppointmentDate() %></td>
                                            <td><%= appointment.getServiceType() %></td>
                                            <td>
                                                <span class="status-badge <%= "pending".equalsIgnoreCase(appointment.getStatus()) ? "status-pending" : "status-not-pending" %>">
                                                    <%= appointment.getStatus() %>
                                                </span>
                                            </td>
                                            <td>
                                                <% if ("pending".equalsIgnoreCase(appointment.getStatus())) { %>
                                                    <button type="button" 
                                                            class="delete-btn"
                                                            onclick="confirmDelete('<%= appointment.getAppointmentID() %>')">
                                                        Delete
                                                    </button>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% } %>
                                </table>
                            <% } else { %>
                                <p class="no-history">No appointments found.</p>
                            <% } %>
                        </div>

                        <!-- Delete Confirmation Modal -->
                        <div id="deleteModal" class="modal">
                            <div class="modal-content">
                                <div class="modal-icon">🗑️</div>
                                <h3 class="modal-title">Xác Nhận Hủy Lịch Hẹn</h3>
                                <div class="modal-message">
                                    Bạn có chắc chắn muốn hủy lịch hẹn này không?<br>
                                    <small style="color: #6c757d">Lịch hẹn sẽ được đánh dấu là đã hủy sau khi xác nhận</small>
                                </div>
                                <div class="modal-buttons">
                                    <button type="button" class="btn btn-cancel" onclick="closeModal()">Giữ Lại</button>
                                    <button type="button" class="btn btn-delete" onclick="proceedWithDeletion()">Hủy Lịch Hẹn</button>
                                </div>
                                <input type="hidden" id="currentAppointmentId" value="" />
                            </div>
                        </div>

                        <a href="vaccinationSchedule.jsp" class="home-link">Home</a>

                        <style>
                            .alert {
                                padding: 15px;
                                margin-bottom: 20px;
                                border: 1px solid transparent;
                                border-radius: 4px;
                                text-align: center;
                                width: 80%;
                                margin: 20px auto;
                            }

                            .alert-danger {
                                color: #721c24;
                                background-color: #f8d7da;
                                border-color: #f5c6cb;
                            }

                            .alert-success {
                                color: #155724;
                                background-color: #d4edda;
                                border-color: #c3e6cb;
                            }
                        </style>
                    </body>

                    </html>