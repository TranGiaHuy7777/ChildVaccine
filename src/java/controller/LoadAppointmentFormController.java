package controller;

import disease.DiseaseDAO;
import disease.DiseaseDTO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoadAppointmentForm")
public class LoadAppointmentFormController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            DiseaseDAO diseaseDao = new DiseaseDAO();
            List<DiseaseDTO> diseaseList = diseaseDao.getAllDiseaseNames();
            request.setAttribute("diseaseList", diseaseList);
            request.getRequestDispatcher("appointmentForm.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading disease list.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
