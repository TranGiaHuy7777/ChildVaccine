package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import customer.CustomerDAO;
import customer.CustomerDTO;
import java.util.List;
import javax.servlet.http.Cookie;

@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

    private static final String ERROR = "login.jsp";
    private static final String ADMIN = "AD";
    private static final String USER = "US";
    private static final String ADMIN_PAGE = "admin.jsp";
    private static final String USER_PAGE = "vaccinationSchedule.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR;
        try {
            String userID = request.getParameter("userID");
            String password = request.getParameter("password");
            String rememberMe = request.getParameter("rememberMe");
            String loginType = request.getParameter("loginType");
            String doctorID = request.getParameter("doctorID"); // nếu là form doctor

            if (userID == null || password == null || loginType == null) {
                request.setAttribute("ERROR", "Invalid input parameters!");
                request.getRequestDispatcher(url).forward(request, response);
                return;
            }

            CustomerDAO dao = new CustomerDAO();
            CustomerDTO loginUser = dao.checkLogin(userID, password);

            // Kiểm tra nghiêm ngặt loginType và roleID
            if (!isValidAccess(loginType, loginUser.getRoleID())) {
                request.setAttribute("ERROR", "You don't have permission to access this portal!");
                request.getRequestDispatcher(url).forward(request, response);
                return;
            }

            // Xử lý Remember Me
            if (loginUser != null) {
                if (rememberMe != null) {
                    // Tạo cookie cho username
                    Cookie usernameCookie = new Cookie(loginType + "_username",
                            loginType.equals("doctor") ? doctorID : userID);
                    Cookie passwordCookie = new Cookie(loginType + "_password", password);

                    usernameCookie.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
                    passwordCookie.setMaxAge(7 * 24 * 60 * 60);

                    response.addCookie(usernameCookie);
                    response.addCookie(passwordCookie);

                } else {
                    // Xóa cookies nếu không chọn Remember Me
                    Cookie usernameCookie = new Cookie(loginType + "_username", "");
                    Cookie passwordCookie = new Cookie(loginType + "_password", "");

                    usernameCookie.setMaxAge(0);
                    passwordCookie.setMaxAge(0);

                    response.addCookie(usernameCookie);
                    response.addCookie(passwordCookie);

                }
            }

            // Xử lý phân quyền và chuyển hướng
            String roleID = loginUser.getRoleID();
            HttpSession session = request.getSession();
            session.setAttribute("LOGIN_USER", loginUser);

            if (ADMIN.equals(roleID)) {
                List<CustomerDTO> listUser = dao.getListUser();
                session.setAttribute("LIST_USER", listUser);
                url = ADMIN_PAGE;
            } else if (USER.equals(roleID)) {
                url = USER_PAGE;
            } else {
                request.setAttribute("ERROR", "Your role is not supported yet!");
            }

        } catch (Exception e) {
            log("Error at LoginController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }

    }

    private boolean isValidAccess(String loginType, String roleID) {
        switch (loginType.toLowerCase()) {
            case "admin":
                return ADMIN.equals(roleID);
            case "customer":
                return USER.equals(roleID);
            default:
                return false;
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
        return "Short description";
    }
}
