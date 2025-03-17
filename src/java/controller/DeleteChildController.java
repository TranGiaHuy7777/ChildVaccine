/*
package controller;

import child.ChildDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DeleteChildController", urlPatterns = {"/DeleteChildController"})
public class DeleteChildController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String childID = request.getParameter("childID");

            ChildDAO dao = new ChildDAO();
            boolean success = dao.deleteChild(Integer.parseInt(childID));

            if (success) {
                response.sendRedirect("childProfile.jsp");
            } else {
                request.setAttribute("ERROR_MESSAGE", "Xóa thông tin thất bại!");
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
        return "DeleteChildController";
    }
}
*/
package controller;

import child.ChildDAO;
import appointment.AppointmentDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "DeleteChildController", urlPatterns = {"/DeleteChildController"})
public class DeleteChildController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String childIDStr = request.getParameter("childID");
            int childID = Integer.parseInt(childIDStr);

            // Trước tiên, xóa các cuộc hẹn liên quan đến trẻ
            AppointmentDAO appDao = new AppointmentDAO();
            appDao.deleteAppointmentsByChildID(childID);

            // Sau đó, xóa thông tin trẻ
            ChildDAO dao = new ChildDAO();
            boolean success = dao.deleteChild(childID);

            if (success) {
                response.sendRedirect("childProfile.jsp");
            } else {
                request.setAttribute("ERROR_MESSAGE", "Xóa thông tin thất bại!");
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
        return "DeleteChildController";
    }
}

