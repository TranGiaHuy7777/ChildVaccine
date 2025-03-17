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
import vaccine.VaccineDTO;

/**
 *
 * @author Windows
 */
@WebServlet(name = "ConfirmPaymentController", urlPatterns = {"/ConfirmPaymentController"})
public class ConfirmPaymentController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        VaccineDTO selectedVaccine = (VaccineDTO) session.getAttribute("selectedVaccine");

        if (selectedVaccine == null) {
            response.sendRedirect("vaccinationSchedule.jsp"); // Quay lại trang chọn vaccine nếu chưa có vaccine được chọn
            return;
        }

        try {
            // Xử lý logic thanh toán ở đây (ví dụ: lưu thông tin vào database)

            // Sau khi thanh toán thành công, xóa vaccine khỏi session
            session.removeAttribute("selectedVaccine");

            // Chuyển hướng đến trang thông báo thanh toán thành công
            response.sendRedirect("paymentSuccess.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); // Chuyển hướng đến trang lỗi nếu có vấn đề xảy ra
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
