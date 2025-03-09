package controller;

import appointment.AppointmentDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AppointmentDeleteController", urlPatterns = {"/AppointmentDeleteController"})
public class AppointmentDeleteController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int appointmentID = Integer.parseInt(request.getParameter("appointmentID"));
            AppointmentDAO dao = new AppointmentDAO();

            boolean deleted = dao.updateAppointmentStatus(appointmentID, "Not pending");


            if (deleted) {
                request.setAttribute("message", "Appointment deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to delete appointment.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while deleting appointment.");
        }

        response.sendRedirect("appointmentHistory.jsp"); // Reload trang lịch sử
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
