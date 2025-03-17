<%@page import="java.util.List"%>
<%@page import="center.CenterDTO"%>
<%@page import="center.CenterDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Center List</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #f5f5f5;
            }
            
            .search-form {
                margin-bottom: 20px;
                padding: 15px;
                background-color: #fff;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            
            table {
                width: 100%;
                border-collapse: collapse;
                background-color: #fff;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            
            th, td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            
            th {
                background-color: #4CAF50;
                color: white;
            }
            
            tr:hover {
                background-color: #f5f5f5;
            }
            
            input[type="text"] {
                padding: 8px;
                margin-right: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                width: 200px;
            }
            
            input[type="submit"] {
                padding: 8px 15px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            
            input[type="submit"]:hover {
                background-color: #45a049;
            }
            
            .navigation {
                margin-top: 20px;
                text-align: center;
            }
            
            .navigation a {
                margin: 0 10px;
                color: #4CAF50;
                text-decoration: none;
            }
            
            .navigation a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <%
            String search = request.getParameter("search");
            if (search == null) {
                search = "";
            }
            
            List<CenterDTO> list = null;
            try {
                CenterDAO centerDAO = new CenterDAO();
                list = centerDAO.search(search);
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
        
        <div class="search-form">
            <form action="centerList.jsp" method="GET">
                Search Centers: <input type="text" name="search" value="<%=search%>">
                <input type="submit" value="Search">
            </form>
        </div>
                
        <h1>List of Vaccination Centers</h1>
        <table>
            <tr>
                <th>Center ID</th>
                <th>Center Name</th>
                <th>Address</th>
                <th>Phone Number</th>
                <th>Email</th>
                <th>Operating Hours</th>
                <th>Description</th>
            </tr>
            <%
                if (list != null && !list.isEmpty()) {
                    for (CenterDTO u : list) {
            %>
            <tr>
                <td><%=u.getCenterID()%></td>
                <td><%=u.getCenterName()%></td>
                <td><%=u.getAddress()%></td>
                <td><%=u.getPhoneNumber()%></td>
                <td><%=u.getEmail()%></td>
                <td><%=u.getOperatingHours()%></td>
                <td><%=u.getDescription()%></td>
            </tr>
            <%
                    }
                }
            %>
        </table>
        
        <div class="navigation">
            <a href="vaccinationSchedule.jsp">Vaccine Schedule</a> |
            <a href="appointmentForm.jsp">Booking</a>
        </div>
    </body>
</html>