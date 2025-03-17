package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import report.ReportDAO;

import reports.ReportDTO;

@WebServlet(name = "ReportController", urlPatterns = {"/ReportController"})
public class ReportController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String centerIDParam = request.getParameter("centerID");
            String reportDateParam = request.getParameter("reportDate");

            List<ReportDTO> reportList;
            if (centerIDParam != null && !centerIDParam.isEmpty()) {
                int centerID = Integer.parseInt(centerIDParam);
                reportList = ReportDAO.getReportsByCenter(centerID, reportDateParam);
            } else {    
                reportList = ReportDAO.getAllReports();
            }

            request.setAttribute("reportList", reportList);
            request.getRequestDispatcher("report.jsp").forward(request, response);
        } catch (Exception e) {
            log("Error at ReportController: " + e.getMessage());
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
