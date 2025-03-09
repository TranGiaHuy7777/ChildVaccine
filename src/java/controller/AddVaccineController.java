package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import vaccine.VaccineDAO;
import vaccine.VaccineDTO;
import java.math.BigDecimal;

@WebServlet(name = "AddVaccineController", urlPatterns = {"/AddVaccineController"})
public class AddVaccineController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String url = "admin.jsp";
        
        try {
            // Lấy các tham số từ form
            String vaccineName = request.getParameter("vaccineName");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String recommendedAge = request.getParameter("recommendedAge");
            
            // Kiểm tra dữ liệu đầu vào
            if (vaccineName == null || vaccineName.trim().isEmpty()
                    || description == null || description.trim().isEmpty()
                    || priceStr == null || priceStr.trim().isEmpty()
                    || recommendedAge == null || recommendedAge.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
                return;
            }
            
            // Chuyển đổi giá từ String sang BigDecimal
            BigDecimal price;
            try {
                price = new BigDecimal(priceStr);
                if (price.compareTo(BigDecimal.ZERO) < 0) {
                    request.setAttribute("error", "Giá không được âm!");
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Giá không hợp lệ!");
                return;
            }
            
            // Tạo đối tượng VaccineDTO
            VaccineDTO vaccine = new VaccineDTO();
            vaccine.setVaccineName(vaccineName.trim());
            vaccine.setDescription(description.trim());
            vaccine.setPrice(price.doubleValue());
            vaccine.setRecommendedAge(recommendedAge.trim());
            vaccine.setStatus("Active");
            
            // Thêm vaccine vào database
            VaccineDAO dao = new VaccineDAO();
            boolean success = dao.addVaccine(vaccine);
            
            if (success) {
                request.setAttribute("message", "Thêm vaccine thành công!");
                // Cập nhật lại danh sách vaccine
                request.setAttribute("vaccines", dao.getAllVaccines());
            } else {
                request.setAttribute("error", "Thêm vaccine thất bại!");
            }
            
        } catch (Exception e) {
            log("Error at AddVaccineController: " + e.toString());
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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

    @Override
    public String getServletInfo() {
        return "AddVaccine Controller";
    }
}