/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package statistics;


import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import statistics.StatisticsDAO;

@WebServlet(name = "StatisticsExportController", urlPatterns = {"/StatisticsExportController"})
public class StatisticsExportController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập header cho file CSV
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"statistics.csv\"");
        try (PrintWriter out = response.getWriter()) {
            // Ghi header CSV
            out.println("AppointmentDate,InjectionCount,Revenue");
            // Lấy dữ liệu thống kê chi tiết từ DAO (tương tự như trong bảng chi tiết)
            // Ví dụ:
            StatisticsDAO dao = new StatisticsDAO();
            int year = Integer.parseInt(request.getParameter("year"));
            int quarter = Integer.parseInt(request.getParameter("quarter"));
            // Lấy toàn bộ dữ liệu không phân trang cho export
            java.util.List data = dao.getDetailedStatistics(year, quarter, 0, Integer.MAX_VALUE);
            for (Object obj : data) {
                // Với ví dụ, obj là chuỗi đã được định dạng
                out.println(obj.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
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
