package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import customer.CustomerDTO;
import java.util.List;
import vaccine.VaccineDAO;
import vaccine.VaccineDTO;

@WebServlet(name = "VaccinationController", urlPatterns = {"/VaccinationController"})
public class VaccinationController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {

            // Lấy action từ request
            String action = request.getParameter("action");
            String search = request.getParameter("search");
            VaccineDAO vaccineDAO = new VaccineDAO();

            // Xử lý tìm kiếm
            if (search != null && !search.trim().isEmpty()) {
                List<VaccineDTO> searchResults = vaccineDAO.searchVaccines(search.trim());
                request.setAttribute("vaccines", searchResults);
                request.getRequestDispatcher("vaccinationSchedule.jsp").forward(request, response);
                return;
            }
            if ("book".equals(action)) {
                HttpSession session = request.getSession();
                CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
                String vaccineIdParam = request.getParameter("vaccineId");

                if (loginUser == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
                if (vaccineIdParam == null || vaccineIdParam.isEmpty()) {
                    request.setAttribute("errorMessage", "Vaccine ID không hợp lệ!");
                    request.getRequestDispatcher("vaccinationSchedule.jsp").forward(request, response);
                    return;
                }

                int vaccineId = Integer.parseInt(vaccineIdParam);
                VaccineDTO selectedVaccine = vaccineDAO.getVaccineByID(vaccineId);

                if (selectedVaccine != null) {
                    session.setAttribute("selectedVaccine", selectedVaccine);
                    response.sendRedirect("childRegistration.jsp"); // Sang trang đăng ký trẻ em
                } else {
                    request.setAttribute("errorMessage", "Vaccine không tồn tại!");
                    request.getRequestDispatcher("vaccinationSchedule.jsp").forward(request, response);
                }
            } else {
                // Hiển thị tất cả vaccine nếu không có tìm kiếm
                List<VaccineDTO> allVaccines = vaccineDAO.getAllVaccines();
                request.setAttribute("vaccines", allVaccines);
                request.getRequestDispatcher("vaccinationSchedule.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Vaccine ID không hợp lệ!");
            request.getRequestDispatcher("vaccinationSchedule.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
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
