package controller;

import appointment.AppointmentDAO;
import appointment.AppointmentDTO;
import java.io.IOException;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AppointmentController")
public class AppointmentController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Nhận dữ liệu từ form
        String childID = request.getParameter("childID");
        String centerID = request.getParameter("centerID");
        String appointmentDate = request.getParameter("appointmentDate");
        String serviceType = request.getParameter("serviceType");

        // In dữ liệu để debug
        System.out.println("Received Data - childID: " + childID + ", centerID: " + centerID
                + ", appointmentDate: " + appointmentDate + ", serviceType: " + serviceType);

        // Kiểm tra dữ liệu hợp lệ
        if (childID == null || childID.isEmpty() || centerID == null || centerID.isEmpty()
                || appointmentDate == null || appointmentDate.isEmpty() || serviceType == null || serviceType.isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("appointmentForm.jsp").forward(request, response);
            return;
        }

        try {
            int childIdInt = Integer.parseInt(childID);
            int centerIdInt = Integer.parseInt(centerID);
            Date appointmentDateSQL = Date.valueOf(appointmentDate); // Convert to SQL Date

            // Tạo đối tượng DTO để lưu vào database
            AppointmentDTO appointment = new AppointmentDTO(0, childIdInt, centerIdInt, appointmentDateSQL, serviceType, "Not pending", "Pending");


            // Gọi DAO để lưu vào database
            AppointmentDAO dao = new AppointmentDAO();
            boolean success = dao.addAppointment(appointment);

            if (success) {
                System.out.println("Appointment saved successfully!");

                // Lưu thông tin vào session để chuyển sang payment.jsp
                HttpSession session = request.getSession();
                session.setAttribute("childID", childID);
                session.setAttribute("centerID", centerID);
                session.setAttribute("appointmentDate", appointmentDate);
                session.setAttribute("serviceType", serviceType);

                // Chuyển hướng sang trang thanh toán
                request.getRequestDispatcher("payment.jsp").forward(request, response);
            } else {
                System.out.println("Failed to save appointment.");
                request.setAttribute("errorMessage", "Booking failed. Please try again.");
                request.getRequestDispatcher("appointmentForm.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid input format.");
            request.getRequestDispatcher("appointmentForm.jsp").forward(request, response);
        }
    }
}
