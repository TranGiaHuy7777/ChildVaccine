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
import customer.CustomerDAO;
import customer.CustomerDTO;
import customer.UserError;

/**
 *
 * @author Windows
 */
@WebServlet(name = "CreateController", urlPatterns = {"/CreateController"})
public class CreateController extends HttpServlet {

    private static final String ERROR = "createUser.jsp";
    private static final String SUCCESS = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR;
        UserError userError = new UserError();
        try {
            boolean check = true;
            CustomerDAO dao = new CustomerDAO();
            String userID = request.getParameter("userID");
            String fullName = request.getParameter("fullName");
            String roleID = request.getParameter("roleID");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String confirm = request.getParameter("confirm");
            

            // Kiểm tra dữ liệu nhập
            if (userID.length() < 2 || userID.length() > 10) {
                check = false;
                userError.setUserIDError("User ID phải từ 2 đến 10 ký tự.");
            }
            if (fullName.length() < 5 || fullName.length() > 50) {
                check = false;
                userError.setFullNameError("Full name phải từ 5 đến 50 ký tự.");
            }
            if (!password.equals(confirm)) {
                check = false;
                userError.setConfirmError("Mật khẩu xác nhận không khớp.");
            }
            if (dao.checkDuplicate(userID)) { // Kiểm tra trùng lặp
                check = false;
                userError.setUserIDError("User ID đã tồn tại.");
            }

            // Nếu không có lỗi, thêm user vào database
            if (check) {
                CustomerDTO user = new CustomerDTO(userID, password, roleID, fullName,email,address,phone);
                if (dao.insertv2(user)) {
                    url = SUCCESS; // Thành công, chuyển hướng đến login.html
                } else {
                    userError.setError("Không thể tạo tài khoản. Vui lòng thử lại.");
                }
            }
            request.setAttribute("USER_ERROR", userError);
        } catch (Exception e) {
            log("Error at CreateController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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
