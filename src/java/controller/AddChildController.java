package controller;

import child.ChildDAO;
import child.ChildDTO;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AddChildController", urlPatterns = {"/AddChildController"})
public class AddChildController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Nhận dữ liệu từ form
            String userID = request.getParameter("userID");
            String childName = request.getParameter("childName");
            String dobString = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");

            // Kiểm tra dữ liệu đầu vào
            if (userID == null || childName == null || dobString == null || gender == null
                    || userID.trim().isEmpty() || childName.trim().isEmpty() || dobString.trim().isEmpty() || gender.trim().isEmpty()) {
                response.sendRedirect("childRegistration.jsp?error=Dữ liệu không hợp lệ!");
                return;
            }

            // Chuyển đổi dateOfBirth từ String sang Date (SQL)
            Date dateOfBirth;
            try {
                dateOfBirth = Date.valueOf(dobString);
            } catch (IllegalArgumentException e) {
                response.sendRedirect("childRegistration.jsp?error=Ngày sinh không hợp lệ!");
                return;
            }

            // Kiểm tra xem trẻ đã tồn tại chưa (tránh trùng lặp)
            ChildDAO dao = new ChildDAO();
            if (dao.childExists(userID, childName, dateOfBirth)) {
                response.sendRedirect("childRegistration.jsp?error=Trẻ đã tồn tại!");
                return;
            }

            // Thêm trẻ vào DB và lấy ID
            ChildDTO child = new ChildDTO(0, userID, childName, dateOfBirth, gender);
            int childID = dao.insertChild(child);

            if (childID > 0) {  // Kiểm tra nếu ID hợp lệ
                child.setChildID(childID);  // Cập nhật ID cho đối tượng ChildDTO

                // Lưu thông tin vào session
                HttpSession session = request.getSession();
                session.setAttribute("REGISTERED_CHILD", child);

                // Chuyển sang trang lựa chọn vaccine
                response.sendRedirect("vaccinationSchedule.jsp?success=Successfully!");
            } else {
                response.sendRedirect("childRegistration.jsp?error=Đăng ký thất bại. Vui lòng thử lại.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("childRegistration.jsp?error=Lỗi hệ thống. Vui lòng thử lại sau.");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AddChildController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("childRegistration.jsp");
    }
}

