package statistics;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "StatisticsExportController", urlPatterns = {"/StatisticsExportController"})
public class StatisticsExportController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"statistics.csv\"");
        try (PrintWriter out = response.getWriter()) {
            // Ghi header CSV gồm 2 cột: AppointmentDate và Revenue
            out.println("AppointmentDate,Revenue");
            StatisticsDAO dao = new StatisticsDAO();
            int year = Integer.parseInt(request.getParameter("year"));
            int quarter = Integer.parseInt(request.getParameter("quarter"));
            java.util.List data = dao.getDetailedStatistics(year, quarter, 0, Integer.MAX_VALUE);
            for (Object obj : data) {
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
