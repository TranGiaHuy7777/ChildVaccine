/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import customer.CustomerDAO;
import customer.CustomerDTO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
@WebServlet(name = "EditProfileController", urlPatterns = {"/EditProfileController"})
public class EditProfileController extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession();
            CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");

            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            String userID = request.getParameter("userID");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Debug log
            System.out.println("Received data for update:");
            System.out.println("UserID: " + userID);
            System.out.println("FullName: " + fullName);
            System.out.println("Email: " + email);
            System.out.println("Phone: " + phone);
            System.out.println("Address: " + address);

            CustomerDTO updatedUser = new CustomerDTO();
            updatedUser.setUserID(userID);
            updatedUser.setFullName(fullName);
            updatedUser.setEmail(email);
            updatedUser.setPhone(phone);
            updatedUser.setAddress(address);
            updatedUser.setRoleID(loginUser.getRoleID());
            updatedUser.setPassword(loginUser.getPassword());

            CustomerDAO dao = new CustomerDAO();
            boolean success = dao.updateProfile(updatedUser);

            if (success) {
                CustomerDTO refreshedUser = dao.getUserByID(userID);
                session.setAttribute("LOGIN_USER", refreshedUser);
                out.print("success");
            } else {
                out.print("failed");
            }

        } catch (Exception e) {
            System.out.println("Error in EditProfileController: " + e.getMessage());
            e.printStackTrace();
            out.print("error: " + e.getMessage());
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