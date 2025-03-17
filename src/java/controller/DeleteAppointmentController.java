package controller;

import appointment.AppointmentDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "DeleteAppointmentController", urlPatterns = {"/DeleteAppointmentController"})
public class DeleteAppointmentController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String appointmentIDStr = request.getParameter("appointmentID");
        if (appointmentIDStr == null || appointmentIDStr.trim().isEmpty()) {
            response.sendRedirect("childProfile.jsp?error=Missing appointmentID");
            return;
        }

        try {
            int appointmentID = Integer.parseInt(appointmentIDStr);
            AppointmentDAO dao = new AppointmentDAO();
            boolean success = dao.deleteAppointment(appointmentID);
            
            if (success) {
                response.sendRedirect("childProfile.jsp?msg=Appointment deleted successfully");
            } else {
                request.setAttribute("ERROR_MESSAGE", "Failed to delete appointment.");
                request.getRequestDispatcher("childProfile.jsp").forward(request, response);
            }
        } catch (NumberFormatException nfe) {
            nfe.printStackTrace();
            response.sendRedirect("childProfile.jsp?error=Invalid appointmentID");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR_MESSAGE", "Error: " + e.getMessage());
            request.getRequestDispatcher("childProfile.jsp").forward(request, response);
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
  
    @Override
    public String getServletInfo() {
        return "DeleteAppointmentController";
    }
}
