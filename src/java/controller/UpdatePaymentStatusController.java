package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import payment.PaymentDAO;

@WebServlet(name = "UpdatePaymentStatusController", urlPatterns = {"/UpdatePaymentStatusController"})
public class UpdatePaymentStatusController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            int paymentID = Integer.parseInt(request.getParameter("paymentID"));
            String status = request.getParameter("status");
            
            PaymentDAO paymentDAO = new PaymentDAO();
            boolean success = paymentDAO.updatePaymentStatus(paymentID, status);
            
            if (success) {
                request.setAttribute("MESSAGE", "Payment status updated successfully!");
            } else {
                request.setAttribute("ERROR", "Failed to update payment status.");
            }
            
        } catch (Exception e) {
            log("Error at UpdatePaymentStatusController: " + e.toString());
            request.setAttribute("ERROR", "System error occurred.");
        } finally {
            request.getRequestDispatcher("staff.jsp").forward(request, response);
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