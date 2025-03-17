/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;
import doctor.DoctorDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import utils.DBUtils;
import vaccine.VaccinationDAO;

/**
 *
 * @author Admin
 */

//DANH SACH LỊCH CUA BAC SI
@WebServlet(name = "UpdateVaccinationStatusController", urlPatterns = {"/UpdateVaccinationStatusController"})
public class UpdateVaccinationStatusController extends HttpServlet {
    private static final String ERROR = "doctor.jsp";
    private static final String SUCCESS = "doctor.jsp";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = ERROR;
        try {
            String scheduleID = request.getParameter("scheduleID");
            String status = request.getParameter("status");
            
            HttpSession session = request.getSession();
            // Lấy thông tin bác sĩ, tuy nhiên, để gửi thông báo đến người dùng, bạn cần biết userID của lịch đó.
            // Ví dụ: Lấy thông tin lịch từ DAO (nếu cần) để biết userID của lịch đó.
            // Giả sử bạn có cách lấy userID từ lịch:
            String userID = getUserIDFromSchedule(scheduleID); // Phương thức bạn tự cài đặt
            
            // Cập nhật trạng thái lịch
            VaccinationDAO dao = new VaccinationDAO();
            boolean check = dao.updateScheduleStatus(scheduleID, status);
            
            // Gửi thông báo cho người dùng dựa vào trạng thái
            if (check && userID != null) {
                vaccine.NotificationDAO nDao = new vaccine.NotificationDAO();
                String message = "";
                if ("Completed".equalsIgnoreCase(status)) {
                    message = "Lịch tiêm của bạn đã được xác nhận.";
                } else if ("Canceled".equalsIgnoreCase(status)) {
                    message = "Lịch tiêm của bạn đã bị hủy.";
                }
                nDao.insertNotification(userID, message);
            }
            
            if (check) {
                url = SUCCESS;
                request.setAttribute("SUCCESS", "Cập nhật trạng thái thành công và thông báo đã được gửi!");
            } else {
                request.setAttribute("ERROR", "Cập nhật trạng thái thất bại!");
            }
        } catch (Exception e) {
            log("Error at UpdateVaccinationStatusController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }
    
    // Ví dụ: Phương thức này giả định bạn có cách lấy userID từ lịch tiêm.
    private String getUserIDFromSchedule(String scheduleID) {
        String userID = null;
        // Thực hiện truy vấn cơ sở dữ liệu để lấy userID từ bảng tblAppointments dựa trên appointmentID (scheduleID)
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "SELECT c.userID FROM tblAppointments a JOIN tblChildren c ON a.childID = c.childID WHERE a.appointmentID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, scheduleID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                userID = rs.getString("userID");
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userID;
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

