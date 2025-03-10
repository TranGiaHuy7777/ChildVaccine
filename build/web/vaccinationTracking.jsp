<%-- Document : vaccinationTracking Created on : Jan 21, 2025, 11:40:37 PM Author : Windows --%>

<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>

    <head>
        <title>Vaccination Tracking</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f9f9f9;
            }

            .container {
                width: 90%;
                margin: auto;
                overflow: hidden;
            }

            h1 {
                text-align: center;
                color: #333;
                margin-top: 20px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                background-color: #fff;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }

            th {
                background-color: #007BFF;
                color: white;
            }

            tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            tr:hover {
                background-color: #f1f1f1;
            }

            .no-records {
                text-align: center;
                color: #888;
                font-size: 16px;
            }

            .nav-link {
                display: block;
                text-align: center;
                margin-top: 20px;
                font-size: 16px;
                text-decoration: none;
                padding: 10px 20px;
                background-color: #007BFF;
                color: white;
                border-radius: 4px;
            }

            .nav-link:hover {
                background-color: #0056b3;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <h1>Vaccination Tracking</h1>

            <!-- Link to Children Page -->
            <a href="children.jsp" class="nav-link">Go to Children Management</a>

            <div class="search-form">
                <form action="VaccinationTracking" method="POST">
                                Search : <input type="text" name="search" value="<%= request.getParameter(" search")
                                        != null ? request.getParameter("search") : ""%>">
                    <input type="submit" name="action" value="Search">
                    <input type="submit" name="action" value="Logout">
                </form>

            </div>
            <!-- Vaccination Records Table -->
            <table>
                <thead>
                    <tr>
                        <th>Child ID</th>
                        <th>Child Name</th>
                        <th>Gender</th>
                        <th>Age in Months</th>
                        <th>Vaccination Date</th>
                        <th>Required Vaccines</th>
                    </tr>
                </thead>
                <tbody>
                    <% List<Map<String, Object>> records = (List<Map<String, Object>>) request.getAttribute("trackingRecords");
                        if (records != null && !records.isEmpty()) {
                            SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
                            for (Map<String, Object> record : records) {
                                List<String> requiredVaccines = (List<String>) record.get("requiredVaccines");
                    %>
                    <tr>
                        <td>
                            <%= record.get("childID")%>
                        </td>
                        <td>
                            <%= record.get("childName")%>
                        </td>
                        <td>
                            <%= record.get("gender")%>
                        </td>
                        <td>
                            <%= record.get("childAgeInMonths")%>
                        </td>
                        <td>
                            <%= record.get("vaccinationDate") != null
                                    ? dateFormatter.format(record.get("vaccinationDate"))
                                    : "Not vaccinated yet"%>
                        </td>
                        <td>
                            <%= requiredVaccines != null
                                    && !requiredVaccines.isEmpty() ? String.join(", ", requiredVaccines)
                                    : " No vaccines required"%>
                        </td>
                    </tr>
                    <% }
                    } else { %>
                    <tr>
                        <td colspan="6" class="no-records">No vaccination
                            records found.</td>
                    </tr>
                    <% }%>
                </tbody>
            </table>
        </div>
    </body>

</html>