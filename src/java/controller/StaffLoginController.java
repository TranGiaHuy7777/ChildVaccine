package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import payment.PaymentDAO;
import payment.PaymentDTO;
import staff.StaffDAO;
import staff.StaffDTO;

@WebServlet(name = "StaffLoginController", urlPatterns = {"/StaffLoginController"})
public class StaffLoginController extends HttpServlet {

    private static final String ERROR = "login.jsp";
    private static final String SUCCESS = "staff.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR;

        try {
            String staffID = request.getParameter("staffID");
            String password = request.getParameter("password");
            String rememberMe = request.getParameter("rememberMe");

            StaffDAO dao = new StaffDAO();
            StaffDTO loginUser = dao.checkLogin(staffID, password);

            if (loginUser != null) {
                // Set session
                HttpSession session = request.getSession();
                session.setAttribute("STAFF_LOGIN", loginUser);

                // Get payment list and count by status
                PaymentDAO paymentDAO = new PaymentDAO();
                List<PaymentDTO> paymentList = paymentDAO.getAllPayments();
                
                int pendingCount = 0;
                int confirmedCount = 0;
                int cancelledCount = 0;

                for (PaymentDTO payment : paymentList) {
                    switch (payment.getStatus().toLowerCase()) {
                        case "pending":
                            pendingCount++;
                            break;
                        case "confirmed":
                            confirmedCount++;
                            break;
                        case "cancelled":
                            cancelledCount++;
                            break;
                    }
                }

                // Set attributes for JSP
                request.setAttribute("paymentList", paymentList);
                request.setAttribute("pendingCount", pendingCount);
                request.setAttribute("confirmedCount", confirmedCount);
                request.setAttribute("cancelledCount", cancelledCount);

                // Handle remember me
                if (rememberMe != null) {
                    Cookie usernameCookie = new Cookie("staff_username", staffID);
                    Cookie passwordCookie = new Cookie("staff_password", password);
                    usernameCookie.setMaxAge(24 * 60 * 60); // 24 hours
                    passwordCookie.setMaxAge(24 * 60 * 60);
                    response.addCookie(usernameCookie);
                    response.addCookie(passwordCookie);
                } else {
                    Cookie usernameCookie = new Cookie("staff_username", "");
                    Cookie passwordCookie = new Cookie("staff_password", "");
                    usernameCookie.setMaxAge(0);
                    passwordCookie.setMaxAge(0);
                    response.addCookie(usernameCookie);
                    response.addCookie(passwordCookie);
                }

                url = SUCCESS;
            } else {
                request.setAttribute("ERROR", "Incorrect Staff ID or Password");
            }
        } catch (Exception e) {
            log("Error at StaffLoginController: " + e.toString());
            request.setAttribute("ERROR", "System error occurred: " + e.getMessage());
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