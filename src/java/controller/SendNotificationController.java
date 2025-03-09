package controller;

import utils.DBUtils;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "SendNotificationController", urlPatterns = {"/SendNotificationController"})
public class SendNotificationController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đặt encoding cho request/response
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String userID = request.getParameter("userID");
        String notificationText = request.getParameter("notificationText");

        if(userID == null || userID.trim().isEmpty() || notificationText == null || notificationText.trim().isEmpty()){
            response.sendRedirect("adminDashboard.jsp?error=" + URLEncoder.encode("Missing userID or notification message", "UTF-8"));
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtils.getConnection();
            String sql = "INSERT INTO tblNotifications (userID, notificationText, isRead) VALUES (?, ?, 0)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, userID);
            ps.setString(2, notificationText);
            int rows = ps.executeUpdate();
            if(rows > 0){
                response.sendRedirect("adminDashboard.jsp?success=" + URLEncoder.encode("Notification sent successfully", "UTF-8"));
            } else {
                response.sendRedirect("adminDashboard.jsp?error=" + URLEncoder.encode("Failed to send notification", "UTF-8"));
            }
        } catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("adminDashboard.jsp?error=" + URLEncoder.encode("Error: " + e.getMessage(), "UTF-8"));
        } finally {
            try{ if(ps != null) ps.close(); } catch(Exception e){}
            try{ if(conn != null) conn.close(); } catch(Exception e){}
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
