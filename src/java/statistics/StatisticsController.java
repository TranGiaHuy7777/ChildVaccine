package statistics;

import appointment.AppointmentDAO;
import appointment.AppointmentStatisticsDTO;
import java.io.IOException;
import java.time.Year;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "StatisticsController", urlPatterns = {"/StatisticsController"})
public class StatisticsController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(StatisticsController.class.getName());
    private static final int PAGE_SIZE = 10;  // Số lượng dòng trên mỗi trang (pagination)

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy tham số từ request (năm, quý, trang)
            String yearParam = request.getParameter("year");
            int year = (yearParam != null) ? Integer.parseInt(yearParam) : Year.now().getValue();

            String quarterParam = request.getParameter("quarter");
            int quarter = (quarterParam != null) ? Integer.parseInt(quarterParam) : 0;

            String pageParam = request.getParameter("page");
            int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;

            // Lấy dữ liệu thống kê từ StatisticsDAO
            StatisticsDAO statisticsDAO = new StatisticsDAO();
            Map<Integer, Integer> injectionMap = statisticsDAO.getInjectionCountByMonth(year, quarter);
            Map<Integer, Double> revenueMap = statisticsDAO.getRevenueByMonth(year, quarter);
            int totalNewUsers = statisticsDAO.getTotalNewUsers(year, quarter);

            // Lấy dữ liệu chi tiết từ AppointmentDAO (có phân trang)
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            List<AppointmentStatisticsDTO> detailedStats = appointmentDAO.getAppointmentStatistics(year);

            int totalRecords = detailedStats.size();
            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
            int offset = (currentPage - 1) * PAGE_SIZE;

            // Đưa dữ liệu sang JSP
            request.setAttribute("YEAR", year);
            request.setAttribute("QUARTER", quarter);
            request.setAttribute("INJECTION_MAP", injectionMap);
            request.setAttribute("REVENUE_MAP", revenueMap);
            request.setAttribute("TOTAL_NEW_USERS", totalNewUsers);
            request.setAttribute("DETAILED_STATS", detailedStats);
            request.setAttribute("CURRENT_PAGE", currentPage);
            request.setAttribute("TOTAL_PAGES", totalPages);

            request.getRequestDispatcher("systemOverview.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing statistics", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi xử lý thống kê. Vui lòng thử lại sau.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
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
