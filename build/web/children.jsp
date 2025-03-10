<%-- 
    Document   : children
    Created on : Jan 16, 2025, 11:39:49 PM
    Author     : Windows
--%>

<%@page import="java.util.List"%>
<%@page import="child.ChildDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Children Management</title>
        <style>
            /* Giữ nguyên CSS cũ */

            /* Thêm style cho nút Delete */
            .btn-delete {
                background-color: #dc3545;
                color: white;
                padding: 5px 10px;
                border: none;
                border-radius: 3px;
                cursor: pointer;
                text-decoration: none;
                font-size: 14px;
            }

            .btn-delete:hover {
                background-color: #c82333;
            }

            /* Style cho modal xác nhận */
            .modal {
                display: none;
                position: fixed;
                z-index: 1;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.4);
            }

            .modal-content {
                background-color: #fefefe;
                margin: 15% auto;
                padding: 20px;
                border: 1px solid #888;
                width: 30%;
                border-radius: 5px;
            }

            .modal-buttons {
                text-align: right;
                margin-top: 20px;
            }

            .modal-buttons button {
                margin-left: 10px;
                padding: 5px 15px;
                border: none;
                border-radius: 3px;
                cursor: pointer;
            }

            .btn-confirm {
                background-color: #dc3545;
                color: white;
            }

            .btn-cancel {
                background-color: #6c757d;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Children Management</h1>

            <!-- Search Form -->
            <div class="search-form">
                <form action="ChildrenController" method="GET">
                    <input type="text" name="search" 
                           value="<%= request.getParameter("search") != null ? request.getParameter("search") : ""%>"
                           placeholder="Search by name...">
                    <input type="submit" value="Search">
                </form>
            </div>

            <!-- Children Table -->
            <table>
                <thead>
                    <tr>
                        <th>Child ID</th>
                        <th>Name</th>
                        <th>Date of Birth</th>
                        <th>Gender</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<ChildDTO> children = (List<ChildDTO>) request.getAttribute("children");
                        if (children != null && !children.isEmpty()) {
                            for (ChildDTO child : children) {
                    %>
                    <tr>
                        <td><%= child.getChildID()%></td>
                        <td><%= child.getChildName()%></td>
                        <td><%= child.getDateOfBirth()%></td>
                        <td><%= child.getGender()%></td>
                        <td>
                            <a href="ChildrenController?action=edit&childID=<%= child.getChildID()%>" 
                               class="btn-edit">Edit</a>
                            <button onclick="showDeleteConfirm(<%= child.getChildID()%>)" 
                                    class="btn-delete">Delete</button>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="5" class="no-records">No children found</td>
                    </tr>
                    <% }%>
                </tbody>
            </table>

            <!-- Add New Child Button -->
            <a href="addChild.jsp" class="btn-add">Add New Child</a>
        </div>

        <!-- Delete Confirmation Modal -->
        <div id="deleteModal" class="modal">
            <div class="modal-content">
                <h3>Confirm Delete</h3>
                <p>Are you sure you want to delete this child? This action cannot be undone.</p>
                <div class="modal-buttons">
                    <form id="deleteForm" action="ChildrenController" method="POST" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" id="deleteChildID" name="childID" value="">
                        <button type="button" class="btn-cancel" onclick="hideDeleteConfirm()">Cancel</button>
                        <button type="submit" class="btn-confirm">Delete</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- JavaScript for Modal -->
        <script>
            function showDeleteConfirm(childID) {
                document.getElementById('deleteChildID').value = childID;
                document.getElementById('deleteModal').style.display = "block";
            }

            function hideDeleteConfirm() {
                document.getElementById('deleteModal').style.display = "none";
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                var modal = document.getElementById('deleteModal');
                if (event.target === modal) {
                    modal.style.display = "none";
                }
            }
        </script>
        <a href="login.jsp">Home</a>
    </body>
</html>
