package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import utils.DBUtils;

public class MarkNotificationReadController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String notificationID = request.getParameter("notificationID");

        try (Connection conn = DBUtils.getConnection()) {
            String sql = "UPDATE tblNotifications SET isRead = 1 WHERE notificationID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, notificationID);
            ps.executeUpdate();
            ps.close();
            // Không redirect => chỉ trả về status OK
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi => status 500
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
