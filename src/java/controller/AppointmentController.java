package controller;

import appointment.AppointmentDAO;
import appointment.AppointmentDTO;
import disease.DiseaseDAO;
import disease.DiseaseDTO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import utils.DBUtils;

@WebServlet("/AppointmentController")
public class AppointmentController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Nhận dữ liệu từ form
        String childID = request.getParameter("childID");
        String centerID = request.getParameter("centerID");
        String appointmentDate = request.getParameter("appointmentDate");
        String serviceType = request.getParameter("serviceType");
        String vaccineID = request.getParameter("vaccineID"); // trường vaccineID
        String diseaseID = request.getParameter("diseaseID"); // trường diseaseID từ dropdown
        String diseaseNote = request.getParameter("diseaseNote"); // thông tin bổ sung về bệnh

        // Debug log
        System.out.println("Received Data - childID: " + childID + ", centerID: " + centerID
                + ", appointmentDate: " + appointmentDate + ", serviceType: " + serviceType
                + ", vaccineID: " + vaccineID + ", diseaseID: " + diseaseID
                + ", diseaseNote: " + diseaseNote);

        // Kiểm tra dữ liệu hợp lệ
        if (childID == null || childID.isEmpty()
                || centerID == null || centerID.isEmpty()
                || appointmentDate == null || appointmentDate.isEmpty()
                || serviceType == null || serviceType.isEmpty()
                || vaccineID == null || vaccineID.isEmpty()
                || diseaseID == null || diseaseID.isEmpty()) {
            request.setAttribute("errorMessage", "All required fields must be provided.");
            request.getRequestDispatcher("appointmentForm.jsp").forward(request, response);
            return;
        }

        try {
            int childIdInt = Integer.parseInt(childID);
            int centerIdInt = Integer.parseInt(centerID);
            int vaccineIdInt = Integer.parseInt(vaccineID);
            int diseaseIdInt = Integer.parseInt(diseaseID);
            Date appointmentDateSQL = Date.valueOf(appointmentDate);

            // Tạo đối tượng AppointmentDTO (appointmentID tự động tăng)
            AppointmentDTO appointment = new AppointmentDTO(
                    0,
                    childIdInt,
                    centerIdInt,
                    appointmentDateSQL,
                    serviceType,
                    "Not pending",
                    "Pending",
                    vaccineIdInt
            );

            try (Connection conn = DBUtils.getConnection()) {
                conn.setAutoCommit(false);

                // Lưu thông tin vào bảng tblAppointments và lấy appointmentID được sinh ra
                AppointmentDAO appointmentDAO = new AppointmentDAO();
                int generatedAppointmentID = appointmentDAO.addAppointment(conn, appointment);
                if (generatedAppointmentID <= 0) {
                    conn.rollback();
                    request.setAttribute("errorMessage", "Failed to save appointment. Please try again.");
                    request.getRequestDispatcher("appointmentForm.jsp").forward(request, response);
                    return;
                }

                // Lấy thông tin bệnh từ bảng tblDiseaseName dựa trên diseaseID
                DiseaseDAO diseaseDAO = new DiseaseDAO();
                DiseaseDTO diseaseInfo = diseaseDAO.getDiseaseById(diseaseIdInt);
                if (diseaseInfo == null) {
                    conn.rollback();
                    request.setAttribute("errorMessage", "Invalid disease selected.");
                    request.getRequestDispatcher("appointmentForm.jsp").forward(request, response);
                    return;
                }

                // Kết hợp mô tả bệnh từ DB với ghi chú bổ sung từ người dùng (nếu có)
                String combinedDescription = diseaseInfo.getDescription();
                if (diseaseNote != null && !diseaseNote.trim().isEmpty()) {
                    combinedDescription += "<br/><strong>User Note:</strong> " + diseaseNote.trim();
                }

                // Tạo đối tượng DiseaseDTO để lưu vào bảng tblDisease
                DiseaseDTO disease = new DiseaseDTO();
                disease.setChildID(childIdInt);
                disease.setVaccineID(vaccineIdInt);
                disease.setAppointmentID(generatedAppointmentID);
                disease.setDiseaseName(diseaseInfo.getDiseaseName());
                disease.setDescription(combinedDescription);
                disease.setDiagnosisDate(new Date(System.currentTimeMillis()));

                // Lưu thông tin bệnh vào bảng tblDisease
                boolean diseaseSaved = diseaseDAO.addDisease(conn, disease);
                if (!diseaseSaved) {
                    conn.rollback();
                    request.setAttribute("errorMessage", "Failed to save disease information.");
                    request.getRequestDispatcher("appointmentForm.jsp").forward(request, response);
                    return;
                }

                // Commit transaction nếu cả 2 thao tác thành công
                conn.commit();

                // Lưu thông tin vào session và chuyển hướng sang trang payment.jsp
                HttpSession session = request.getSession();
                session.setAttribute("childID", childID);
                session.setAttribute("centerID", centerID);
                session.setAttribute("appointmentDate", appointmentDate);
                session.setAttribute("serviceType", serviceType);
                session.setAttribute("vaccineID", vaccineID);
                request.getRequestDispatcher("payment.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid input format or server error.");
            request.getRequestDispatcher("appointmentForm.jsp").forward(request, response);
        }
    }
}
