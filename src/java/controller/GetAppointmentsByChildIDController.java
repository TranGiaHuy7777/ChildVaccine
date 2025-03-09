package controller;

import appointment.AppointmentDAO;
import appointment.AppointmentDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "GetAppointmentsByChildIDController", urlPatterns = {"/GetAppointmentsByChildIDController"})
public class GetAppointmentsByChildIDController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String childIDStr = request.getParameter("childID");
        PrintWriter out = response.getWriter();
        try {
            int childID = Integer.parseInt(childIDStr);
            AppointmentDAO dao = new AppointmentDAO();
            List<AppointmentDTO> appointments = dao.getAppointmentsByChildID(childID);
            if (appointments == null || appointments.isEmpty()){
                out.print("<p>No appointments found.</p>");
            } else {
                // Xuất danh sách các lịch hẹn dưới dạng nút (button)
                for(AppointmentDTO app : appointments){
                    out.print("<div class='appointment-item' onclick='selectAppointment(" + app.getAppointmentID() + ")'>");
                    out.print("Appointment ID: " + app.getAppointmentID() + " - Date: " + app.getAppointmentDate());
                    out.print("</div>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            out.close();
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
