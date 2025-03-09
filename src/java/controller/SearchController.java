package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import customer.CustomerDAO;
import customer.CustomerDTO;
import javax.servlet.http.HttpSession;

@WebServlet(name = "SearchController", urlPatterns = {"/SearchController"})
public class SearchController extends HttpServlet {

    private static final String ERROR = "admin.jsp";
    private static final String SUCCESS = "admin.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String url = ERROR;
        try {
            String search = request.getParameter("search");
            CustomerDAO dao = new CustomerDAO();
            List<CustomerDTO> listUser;

            if (search == null || search.trim().isEmpty()) {
                listUser = dao.getListUser();
            } else {
                listUser = dao.searchByName(search);
            }

            if (listUser != null) {
                HttpSession session = request.getSession();
                session.setAttribute("LIST_USER", listUser);
                if (listUser.isEmpty()) {
                    request.setAttribute("SEARCH_MESSAGE", "No results found for: " + search);
                }
                url = SUCCESS;
            }
        } catch (Exception e) {
            log("Error at SearchController: " + e.toString());
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
