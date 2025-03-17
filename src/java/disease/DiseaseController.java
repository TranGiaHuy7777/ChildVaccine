package disease;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DiseaseController")
public class DiseaseController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tham số action từ request
        String action = request.getParameter("action");
        DiseaseDAO dao = new DiseaseDAO();
        try {
            if (action != null) {
                if (action.equals("AddDiseaseName")) {
                    // Lấy dữ liệu từ form thêm bệnh
                    int vaccineID = Integer.parseInt(request.getParameter("vaccineID"));
                    String diseaseName = request.getParameter("diseaseName");
                    String description = request.getParameter("description");

                    DiseaseDTO dto = new DiseaseDTO();
                    dto.setVaccineID(vaccineID);
                    dto.setDiseaseName(diseaseName);
                    dto.setDescription(description);

                    boolean result = dao.addDiseaseName(dto);
                    // Bạn có thể set thông báo vào request hoặc session để hiển thị sau khi redirect
                    if (result) {
                        request.getSession().setAttribute("MESSAGE", "Thêm bệnh thành công!");
                    } else {
                        request.getSession().setAttribute("MESSAGE", "Thêm bệnh thất bại!");
                    }
                } else if (action.equals("DeleteDiseaseName")) {
                    int diseaseId = Integer.parseInt(request.getParameter("diseaseId"));
                    boolean result = dao.deleteDiseaseName(diseaseId);
                    if (result) {
                        request.getSession().setAttribute("MESSAGE", "Xoá bệnh thành công!");
                    } else {
                        request.getSession().setAttribute("MESSAGE", "Xoá bệnh thất bại!");
                    }
                } else if (action.equals("UpdateDiseaseName")) {
                    int diseaseId = Integer.parseInt(request.getParameter("diseaseId"));
                    int vaccineID = Integer.parseInt(request.getParameter("vaccineID"));
                    String diseaseName = request.getParameter("diseaseName");
                    String description = request.getParameter("description");

                    DiseaseDTO dto = new DiseaseDTO();
                    dto.setDiseaseID(diseaseId);
                    dto.setVaccineID(vaccineID);
                    dto.setDiseaseName(diseaseName);
                    dto.setDescription(description);

                    boolean result = dao.updateDiseaseName(dto);
                    if (result) {
                        request.getSession().setAttribute("MESSAGE", "Cập nhật bệnh thành công!");
                    } else {
                        request.getSession().setAttribute("MESSAGE", "Cập nhật bệnh thất bại!");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("MESSAGE", "Có lỗi xảy ra: " + e.getMessage());
        }
        // Sau khi xử lý xong, chuyển hướng về trang quản lý bệnh
        response.sendRedirect("AddDisease.jsp");
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
