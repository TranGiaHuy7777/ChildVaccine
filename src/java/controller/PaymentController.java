package controller;

import appointment.AppointmentDTO;
import payment.PaymentDAO;
import payment.PaymentDTO;
import vaccine.VaccineDTO;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "PaymentController", urlPatterns = {"/PaymentController"})
public class PaymentController extends HttpServlet {

    private static final String PAYMENT_PAGE = "payment.jsp";
    private static final String ERROR_PAGE = "error.jsp";
    private static final String SUCCESS_PAGE = "paymentSuccess.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;

        try {
            String action = request.getParameter("action");
            
            if (action == null || action.isEmpty()) {
                throw new ServletException("Action parameter is required");
            }

            switch (action) {
                case "initPayment":
                    url = handleInitPayment(request);
                    break;

                case "processPayment":
                    url = handleProcessPayment(request);
                    break;

                default:
                    request.setAttribute("ERROR", "Invalid action");
            }

        } catch (Exception e) {
            log("Error in PaymentController: " + e.toString());
            request.setAttribute("ERROR", "System error occurred: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private String handleInitPayment(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        VaccineDTO selectedVaccine = (VaccineDTO) session.getAttribute("selectedVaccine");
        Integer childID = (Integer) session.getAttribute("childID");
        Integer centerID = (Integer) session.getAttribute("centerID");
        String appointmentDateStr = request.getParameter("appointmentDate");
        String serviceType = request.getParameter("serviceType");

        if (selectedVaccine == null || childID == null || centerID == null
                || appointmentDateStr == null || serviceType == null) {
            request.setAttribute("ERROR", "Missing required data for appointment");
            return ERROR_PAGE;
        }

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date utilDate = dateFormat.parse(appointmentDateStr);
        Date appointmentDate = new Date(utilDate.getTime());

        AppointmentDTO newAppointment = new AppointmentDTO();
        newAppointment.setChildID(childID);
        newAppointment.setCenterID(centerID);
        newAppointment.setAppointmentDate(appointmentDate);
        newAppointment.setServiceType(serviceType);
        newAppointment.setNotificationStatus("Pending");
        newAppointment.setStatus("Scheduled");

        session.setAttribute("latestAppointment", newAppointment);
        return PAYMENT_PAGE;
    }

    private String handleProcessPayment(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        AppointmentDTO appointment = (AppointmentDTO) session.getAttribute("latestAppointment");
        VaccineDTO vaccine = (VaccineDTO) session.getAttribute("selectedVaccine");
        String paymentMethod = request.getParameter("paymentMethod");

        log("Processing payment - Appointment: " + appointment);
        log("Vaccine: " + vaccine);
        log("Payment Method: " + paymentMethod);

        if (appointment == null || vaccine == null || paymentMethod == null) {
            request.setAttribute("ERROR", "Invalid payment data");
            return ERROR_PAGE;
        }

        PaymentDTO payment = new PaymentDTO(
                appointment.getAppointmentID(),
                vaccine.getPrice(),
                paymentMethod,
                generateTransactionCode()
        );

        PaymentDAO paymentDAO = new PaymentDAO();
        boolean success = paymentDAO.createPayment(payment);
        log("Payment creation result: " + success);

        if (success) {
            session.setAttribute("PAYMENT_SUCCESS", true);
            session.setAttribute("TRANSACTION_CODE", payment.getTransactionCode());
            request.setAttribute("MESSAGE", "Payment processed successfully!");
            return SUCCESS_PAGE;
        } else {
            request.setAttribute("ERROR", "Payment processing failed");
            return ERROR_PAGE;
        }
    }

    private String generateTransactionCode() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String datePart = sdf.format(new java.util.Date());
        String randomPart = String.format("%05d", new Random().nextInt(100000));
        return "TR-" + datePart + "-" + randomPart;
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
