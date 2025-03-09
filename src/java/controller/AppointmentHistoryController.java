package controller;

import appointment.AppointmentDAO;
import appointment.AppointmentDTO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import customer.CustomerDTO;

@WebServlet(name = "AppointmentHistoryController", urlPatterns = {"/AppointmentHistoryController"})
public class AppointmentHistoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "appointmentHistory.jsp";
        
        try {
            HttpSession session = request.getSession();
            CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
            
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            AppointmentDAO dao = new AppointmentDAO();
            List<AppointmentDTO> appointmentList;
            
            // Xử lý cập nhật trạng thái
            String action = request.getParameter("action");
            if ("updateStatus".equals(action)) {
                String appointmentID = request.getParameter("appointmentID");
                String status = request.getParameter("status");
                if (appointmentID != null && status != null) {
                    boolean updated = dao.updateAppointmentStatus(Integer.parseInt(appointmentID), status);
                    if (updated) {
                        request.setAttribute("MESSAGE", "Cập nhật trạng thái thành công!");
                    } else {
                        request.setAttribute("ERROR", "Không thể cập nhật trạng thái!");
                    }
                }
            }

            // Xử lý tìm kiếm và hiển thị danh sách
            String searchChildID = request.getParameter("searchChildID");
            if (searchChildID != null && !searchChildID.trim().isEmpty()) {
                // Nếu có tìm kiếm theo ChildID
                appointmentList = dao.getAppointmentsByChildID(Integer.parseInt(searchChildID));
            } else {
                // Mặc định hiển thị tất cả cuộc hẹn của user
                appointmentList = dao.getAppointmentsByUserID(loginUser.getUserID());
            }

            request.setAttribute("appointmentList", appointmentList);

        } catch (Exception e) {
            log("Error at AppointmentHistoryController: " + e.toString());
            request.setAttribute("ERROR", "Có lỗi xảy ra: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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