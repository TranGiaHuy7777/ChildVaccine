package controller;

import child.ChildDAO;
import child.ChildDTO;
import java.io.IOException;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "EditChildController", urlPatterns = {"/EditChildController"})
public class EditChildController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            String childID = request.getParameter("childID");
            String childName = request.getParameter("fullName");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");

            ChildDTO child = new ChildDTO();
            child.setChildID(Integer.parseInt(childID));
            child.setChildName(childName);
            child.setDateOfBirth(Date.valueOf(dateOfBirth)); // Convert String to Date
            child.setGender(gender);

            ChildDAO dao = new ChildDAO();
            boolean success = dao.updateChild(child);

            if (success) {
                response.sendRedirect("childProfile.jsp");
            } else {
                request.setAttribute("ERROR_MESSAGE", "Cập nhật thông tin thất bại!");
                request.getRequestDispatcher("childProfile.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR_MESSAGE", "Lỗi: " + e.getMessage());
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
        return "EditChildController";
    }
}
