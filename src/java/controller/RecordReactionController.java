package controller;

import utils.DBUtils;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.Normalizer;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "RecordReactionController", urlPatterns = {"/RecordReactionController"})
public class RecordReactionController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set encoding for request/response
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String appointmentIDStr = request.getParameter("appointmentID");
        String reaction = request.getParameter("reaction");

        if (appointmentIDStr == null || appointmentIDStr.trim().isEmpty()) {
            response.sendRedirect("recordReaction.jsp?error=" + URLEncoder.encode("Missing appointmentID", "UTF-8"));
            return;
        }

        int appointmentID = Integer.parseInt(appointmentIDStr);
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtils.getConnection();
            String sql = "INSERT INTO tblVaccineReactions (appointmentID, reactionText) VALUES (?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentID);
            ps.setString(2, reaction);
            int rows = ps.executeUpdate();

            // Normalize the reaction string for Unicode comparison and convert to lower-case
            String normalizedReaction = "";
            if (reaction != null) {
                normalizedReaction = Normalizer.normalize(reaction, Normalizer.Form.NFC).toLowerCase();
            }
            // Check for severe reaction keywords ("sốc", "sốt", "co giật")
            boolean severeReaction = normalizedReaction.contains("sốc") 
                                     || normalizedReaction.contains("sốt")
                                     || normalizedReaction.contains("co giật");

            if (rows > 0) {
                if (severeReaction) {
                    String msg = "Phản ứng nghiêm trọng. Vui lòng đọc hướng dẫn xử lý sốc phản vệ.";
                    request.setAttribute("msg", msg);
                    request.getRequestDispatcher("reactionSafety.jsp").forward(request, response);
                } else {
                    String msg = "Phản ứng đã được ghi nhận thành công";
                    String encodedMsg = URLEncoder.encode(msg, "UTF-8");
                    response.sendRedirect("recordReaction.jsp?msg=" + encodedMsg);
                }
            } else {
                response.sendRedirect("recordReaction.jsp?error=" + URLEncoder.encode("Ghi nhận thất bại", "UTF-8"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("recordReaction.jsp").forward(request, response);
        } finally {
            try { if (ps != null) ps.close(); } catch(Exception ex) {}
            try { if (conn != null) conn.close(); } catch(Exception ex) {}
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
