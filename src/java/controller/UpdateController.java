/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import customer.CustomerDAO;
import customer.CustomerDTO;
import java.util.List;

/**
 *
 * @author Windows
 */

@WebServlet(name = "UpdateController", urlPatterns = {"/UpdateController"})
public class UpdateController extends HttpServlet {

    private static final String SUCCESS = "admin.jsp";
    private static final String ERROR = "editUser.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String userID = request.getParameter("userID");
            String roleID = request.getParameter("roleID");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // Log thông tin nhận được
            System.out.println("Received update request:");
            System.out.println("UserID: " + userID);
            System.out.println("RoleID: " + roleID);
            System.out.println("FullName: " + fullName);
            System.out.println("Email: " + email);
            System.out.println("Phone: " + phone);

            CustomerDAO dao = new CustomerDAO();

            // Kiểm tra kết nối database
            if (!dao.testConnection()) {
                request.setAttribute("ERROR_MESSAGE", "Không thể kết nối đến database!");
                return;
            }

            CustomerDTO existingUser = dao.getUserByID(userID);
            if (existingUser != null) {
                CustomerDTO updatedUser = new CustomerDTO(
                        userID,
                        existingUser.getPassword(),
                        roleID,
                        fullName,
                        email,
                        existingUser.getAddress(),
                        phone
                );

                boolean checkUpdate = dao.update(updatedUser);

                if (checkUpdate) {
                    HttpSession session = request.getSession();

                    // Cập nhật LOGIN_USER nếu cần
                    CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
                    if (loginUser != null && loginUser.getUserID().equals(userID)) {
                        loginUser.setFullName(fullName);
                        loginUser.setRoleID(roleID);
                        loginUser.setEmail(email);
                        loginUser.setPhone(phone);
                        session.setAttribute("LOGIN_USER", loginUser);
                    }

                    // Cập nhật LIST_USER
                    List<CustomerDTO> updatedList = dao.getListUser();
                    session.setAttribute("LIST_USER", updatedList);

                    out.print("success");
                } else {
                    out.print("failed");
                }
            } else {
                out.print("user_not_found");
            }

        } catch (Exception e) {
            log("Error at UpdateController: " + e.toString());
            out.print("error: " + e.getMessage());
        }
    }

    // ... các phương thức khác giữ nguyên
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
