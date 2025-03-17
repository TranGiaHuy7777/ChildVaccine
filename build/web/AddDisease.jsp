<%@page import="disease.DiseaseDAO"%>
<%@page import="disease.DiseaseDTO"%>
<%@page import="vaccine.VaccineDAO"%>
<%@page import="vaccine.VaccineDTO"%>
<%@page import="customer.CustomerDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check login – only admin can access
    CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
    if (loginUser == null || !"AD".equals(loginUser.getRoleID())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Retrieve disease list from table tblDiseaseName (including diseaseID, diseaseName, description)
    DiseaseDAO diseaseDAO = new DiseaseDAO();
    List<DiseaseDTO> diseaseList = diseaseDAO.getAllDiseases();
    
    // Retrieve vaccine list to use in the dropdown
    VaccineDAO vaccineDAO = new VaccineDAO();
    List<VaccineDTO> vaccineList = vaccineDAO.getAllVaccines();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Disease Management</title>
    <style>
        /* Reset & Basic */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #eef2f7;
            color: #333;
            line-height: 1.6;
        }
        a {
            text-decoration: none;
            color: inherit;
        }
        /* Back Button */
        .back-button {
            margin: 20px;
        }
        .back-button a {
            display: inline-block;
            background: #555;
            color: #fff;
            padding: 8px 16px;
            border-radius: 4px;
            transition: background 0.3s ease;
        }
        .back-button a:hover {
            background: #333;
        }
        /* Container */
        .container {
            width: 90%;
            max-width: 1100px;
            margin: 20px auto 40px;
            background: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            animation: fadeIn 1s ease-in-out;
        }
        h1, h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #222;
        }
        form {
            margin-bottom: 40px;
        }
        form label {
            display: block;
            margin: 10px 0 6px;
            font-weight: 600;
            color: #555;
        }
        form input[type="text"],
        form select,
        form textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        form input[type="text"]:focus,
        form select:focus,
        form textarea:focus {
            border-color: #1e88e5;
            outline: none;
        }
        form button {
            margin-top: 15px;
            padding: 12px 25px;
            background: #1e88e5;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        form button:hover {
            background: #1565c0;
            transform: translateY(-2px);
        }
        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table thead {
            background: #1e88e5;
            color: #fff;
        }
        table th, table td {
            padding: 14px;
            text-align: left;
            border: 1px solid #ddd;
        }
        table tbody tr:nth-child(even) {
            background: #f9f9f9;
        }
        table tbody tr:hover {
            background: #f1f8ff;
        }
        /* Modern Action Buttons */
        .action-buttons a {
            display: inline-block;
            text-decoration: none;
            padding: 8px 16px;
            font-size: 0.9rem;
            font-weight: bold;
            border-radius: 6px;
            transition: background 0.3s, transform 0.2s, box-shadow 0.3s;
            color: #fff;
            margin-right: 5px;
        }
        .action-buttons a.edit {
            background: #4caf50;
        }
        .action-buttons a.edit:hover {
            background: #43a047;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .action-buttons a.delete {
            background: #f44336;
        }
        .action-buttons a.delete:hover {
            background: #e53935;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top:0;
            left:0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            animation: fadeIn 0.5s ease;
        }
        .modal-content {
            background: #fff;
            width: 90%;
            max-width: 500px;
            margin: 10% auto;
            padding: 20px 30px;
            border-radius: 8px;
            position: relative;
            animation: slideIn 0.5s ease;
        }
        .modal-content .close {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 24px;
            cursor: pointer;
            color: #aaa;
            transition: color 0.3s ease;
        }
        .modal-content .close:hover {
            color: #333;
        }
        /* Animation Keyframes */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes slideIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="back-button">
        <a href="admin.jsp">&larr; Back to Admin</a>
    </div>
    <div class="container">
        <h1>Disease Management</h1>
        <!-- Add New Disease Form -->
        <h2>Add New Disease</h2>
        <form action="DiseaseController" method="post">
            <input type="hidden" name="action" value="AddDiseaseName">
            <label for="vaccineID">Select Vaccine:</label>
            <select name="vaccineID" id="vaccineID" required>
                <option value="">-- Select Vaccine --</option>
                <% for(VaccineDTO vaccine : vaccineList) { %>
                    <option value="<%= vaccine.getVaccineID() %>"><%= vaccine.getVaccineName() %></option>
                <% } %>
            </select>
            <label for="diseaseName">Disease Name:</label>
            <input type="text" name="diseaseName" id="diseaseName" placeholder="Enter disease name" required>
            <label for="description">Description:</label>
            <textarea name="description" id="description" placeholder="Enter disease description" rows="4" required></textarea>
            <button type="submit">Add Disease</button>
        </form>
        
        <!-- Disease List Table -->
        <h2>Disease List</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Vaccine ID</th>
                    <th>Disease Name</th>
                    <th>Description</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <% for(DiseaseDTO disease : diseaseList) { %>
                <tr>
                    <td><%= disease.getDiseaseID() %></td>
                    <td><%= disease.getVaccineID() %></td>
                    <td><%= disease.getDiseaseName() %></td>
                    <td><%= disease.getDescription() %></td>
                    <td class="action-buttons">
                        <a href="javascript:void(0);" class="edit"
                           data-diseaseid="<%= disease.getDiseaseID() %>"
                           data-vaccineid="<%= disease.getVaccineID() %>"
                           data-diseasename="<%= disease.getDiseaseName().replace("\"", "&quot;") %>"
                           data-description="<%= disease.getDescription().replace("\"", "&quot;") %>">
                            Edit
                        </a>
                        <a href="DiseaseController?action=DeleteDiseaseName&diseaseId=<%= disease.getDiseaseID() %>" class="delete" 
                           onclick="return confirm('Are you sure you want to delete this disease?');">
                            Delete
                        </a>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <!-- Modal for Editing Disease -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditModal()">&times;</span>
            <h2>Edit Disease Information</h2>
            <form action="DiseaseController" method="post">
                <input type="hidden" name="action" value="UpdateDiseaseName">
                <input type="hidden" name="diseaseId" id="editDiseaseId">
                <label for="editVaccineID">Select Vaccine:</label>
                <select name="vaccineID" id="editVaccineID" required>
                    <option value="">-- Select Vaccine --</option>
                    <% for(VaccineDTO vaccine : vaccineList) { %>
                        <option value="<%= vaccine.getVaccineID() %>"><%= vaccine.getVaccineName() %></option>
                    <% } %>
                </select>
                <label for="editDiseaseName">Disease Name:</label>
                <input type="text" name="diseaseName" id="editDiseaseName" required>
                <label for="editDescription">Description:</label>
                <textarea name="description" id="editDescription" rows="4" required></textarea>
                <button type="submit">Update Disease</button>
            </form>
        </div>
    </div>

    <script>
        // Add event listener for all Edit buttons using data attributes
        document.querySelectorAll('.action-buttons a.edit').forEach(function(btn) {
            btn.addEventListener('click', function() {
                var diseaseId = this.getAttribute('data-diseaseid');
                var vaccineID = this.getAttribute('data-vaccineid');
                var diseaseName = this.getAttribute('data-diseasename');
                var description = this.getAttribute('data-description');
                showEditModal(diseaseId, vaccineID, diseaseName, description);
            });
        });
        
        function showEditModal(diseaseId, vaccineID, diseaseName, description) {
            document.getElementById('editDiseaseId').value = diseaseId;
            document.getElementById('editVaccineID').value = vaccineID;
            document.getElementById('editDiseaseName').value = diseaseName;
            document.getElementById('editDescription').value = description;
            document.getElementById('editModal').style.display = "block";
        }
        
        function closeEditModal() {
            document.getElementById('editModal').style.display = "none";
        }
        
        // Close modal when clicking outside of it
        window.onclick = function(event) {
            var modal = document.getElementById('editModal');
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
</body>
</html>
