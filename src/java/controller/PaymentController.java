/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import appointment.AppointmentDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import vaccine.VaccineDTO;

/**
 *
 * @author Windows
 */
@WebServlet(name = "PaymentController", urlPatterns = {"/PaymentController"})
public class PaymentController extends HttpServlet {

    private static final String PAYMENT_PAGE = "payment.jsp";
    private static final String ERROR_PAGE = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            HttpSession session = request.getSession();
            VaccineDTO selectedVaccine = (VaccineDTO) session.getAttribute("selectedVaccine");

            // Lấy thông tin từ request/session
            Integer childID = (Integer) session.getAttribute("childID");
            Integer centerID = (Integer) session.getAttribute("centerID");
            String appointmentDateStr = request.getParameter("appointmentDate");
            String serviceType = request.getParameter("serviceType");
            String notificationStatus = "Pending"; // Giả sử mặc định là "Pending"
            String status = "Scheduled"; // Mặc định trạng thái "Scheduled"

            if (selectedVaccine != null && childID != null && centerID != null && appointmentDateStr != null && serviceType != null) {
                // Chuyển đổi appointmentDate từ String sang Date
                // Chuyển đổi appointmentDate từ String sang java.util.Date
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date utilDate = dateFormat.parse(appointmentDateStr);

                // Chuyển từ java.util.Date sang java.sql.Date
                Date appointmentDate = new java.sql.Date(utilDate.getTime());

                // Tạo AppointmentDTO
                AppointmentDTO newAppointment = new AppointmentDTO();
                newAppointment.setChildID(childID);
                newAppointment.setCenterID(centerID);
                newAppointment.setAppointmentDate(appointmentDate);
                newAppointment.setServiceType(serviceType);
                newAppointment.setNotificationStatus(notificationStatus);
                newAppointment.setStatus(status);

                // Lưu vào session
                session.setAttribute("latestAppointment", newAppointment);

                // Chuyển hướng đến trang thanh toán
                request.getRequestDispatcher(PAYMENT_PAGE).forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Lỗi: Dữ liệu không đầy đủ để đặt lịch.");
                request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("Error in PaymentController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại.");
            request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
        }
    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
