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
            CustomerDAO dao = new CustomerDAO();
            CustomerDTO loginUser = dao.checkLogin(userID, password);

            if (loginUser != null) {
                String roleID = loginUser.getRoleID();
                HttpSession session = request.getSession();
                session.setAttribute("LOGIN_USER", loginUser);

                if (ADMIN.equals(roleID)) {
                    // Khi admin đăng nhập, lấy danh sách users
                    List<CustomerDTO> listUser = dao.getListUser();
                    session.setAttribute("LIST_USER", listUser);
                    url = ADMIN_PAGE;
                } else if (USER.equals(roleID)) {
                    url = USER_PAGE;
                } else {
                    request.setAttribute("ERROR", "Your role is not supported yet!");
                }
            } else {
                request.setAttribute("ERROR", "Incorrect UserID or Password");
            }
        } catch (Exception e) {
            log("Error at LoginController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }
    // ... các phương thức khác giữ nguyên

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
