package controller;

import appointment.AppointmentDAO;
import appointment.AppointmentDTO;
import child.ChildDAO;
import child.ChildDTO;
import customer.CustomerDTO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "SelectAppointmentController", urlPatterns = {"/SelectAppointmentController"})
public class SelectAppointmentController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tham số appointmentID và childID
        String appointmentIDStr = request.getParameter("appointmentID");
        int appointmentID = 0;
        if (appointmentIDStr != null && !appointmentIDStr.trim().isEmpty()) {
            appointmentID = Integer.parseInt(appointmentIDStr);
        }
        String childIDStr = request.getParameter("childID");
        
        try {
            HttpSession session = request.getSession();
            CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            String userID = loginUser.getUserID();
            ChildDTO child = null;
            
            if (appointmentID != 0) {
                // Nếu appointmentID khác 0, tìm thông tin từ AppointmentDAO
                AppointmentDAO dao = new AppointmentDAO();
                List<AppointmentDTO> appointments = dao.getAppointmentsByUserID(userID);
                AppointmentDTO selectedAppointment = null;
                if (appointments != null) {
                    for (AppointmentDTO app : appointments) {
                        if (app.getAppointmentID() == appointmentID) {
                            selectedAppointment = app;
                            break;
                        }
                    }
                }
                if (selectedAppointment != null) {
                    child = new ChildDTO();
                    child.setChildID(selectedAppointment.getChildID());
                    child.setUserID(userID);
                    child.setChildName(selectedAppointment.getChildName());
                    if (selectedAppointment.getDateOfBirth() != null) {
                        child.setDateOfBirth(new java.sql.Date(selectedAppointment.getDateOfBirth().getTime()));
                    } else {
                        child.setDateOfBirth(null);
                    }
                    child.setGender(selectedAppointment.getGender());
                }
            } else {
                // Nếu appointmentID = 0, lấy thông tin từ ChildDAO bằng childID
                if(childIDStr != null && !childIDStr.trim().isEmpty()){
                    int childID = Integer.parseInt(childIDStr);
                    ChildDAO childDAO = new ChildDAO();
                    child = childDAO.getChildByID(childID);
                }
            }
            
            if (child != null) {
                session.setAttribute("REGISTERED_CHILD", child);
                response.sendRedirect("appointmentForm.jsp?success=Appointment selected!");
            } else {
                response.sendRedirect("childRegistration.jsp?error=Không tìm thấy hồ sơ trẻ!");
            }
        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error occurred: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    public String getServletInfo() {
        return "SelectAppointmentController";
    }
}
