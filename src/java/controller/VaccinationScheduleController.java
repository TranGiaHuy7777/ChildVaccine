package controller;

import vaccine.VaccineDAO;
import vaccine.VaccineDTO;
import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "VaccinationScheduleController", urlPatterns = {"/VaccinationScheduleController"})
public class VaccinationScheduleController extends HttpServlet {

    // Danh sách các mốc tháng cơ bản để hiển thị trong bảng (ví dụ: 2, 3, 4, 6, 9, 12, 15, 18, 24, 36)
    private static final List<Integer> BASE_SCHEDULE_MONTHS = Arrays.asList(
        2, 3, 4, 6, 9, 12, 15, 18, 24, 36
    );

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy danh sách vaccine từ DB
            VaccineDAO dao = new VaccineDAO();
            List<VaccineDTO> vaccineList = dao.getAllVaccines();
            
            // 2. Tạo Map: VaccineDTO -> Set<Integer> dựa trên recommendedAge và thêm mũi nhắc bổ sung
            Map<VaccineDTO, Set<Integer>> scheduleMap = new HashMap<>();
            for (VaccineDTO vaccine : vaccineList) {
                String recommendedAge = vaccine.getRecommendedAge();
                // Parse cơ bản từ recommendedAge
                Set<Integer> recommendedMonths = parseRecommendedAge(recommendedAge);
                
                // Thêm các mũi nhắc bổ sung dựa trên tên vaccine (so sánh không phân biệt hoa thường)
                String vaccineName = vaccine.getVaccineName().toLowerCase();
                if(vaccineName.contains("hib")) {
                    // Vaccine HIB: nhắc lại lúc 18 tháng
                    recommendedMonths.add(18);
                } else if(vaccineName.contains("thuong han")) {
                    // Vaccine thuong han: thêm mũi nhắc bổ sung lúc 30 tháng (ví dụ)
                    recommendedMonths.add(30);
                } else if(vaccineName.contains("viem gan a")) {
                    // Vaccine viem gan A: thêm nhắc lại sau 6 và 12 tháng
                    recommendedMonths.add(6);
                    recommendedMonths.add(12);
                } else if(vaccineName.contains("soi")) {
                    // Vaccine soi: thêm nhắc lại lúc 18 tháng (với mũi đầu lúc 9 hoặc 12 đã có)
                    recommendedMonths.add(18);
                } else if(vaccineName.contains("phoi cau")) {
                    // Vaccine phoi cau: thêm nhắc ở 12 và 15 tháng
                    recommendedMonths.add(12);
                    recommendedMonths.add(15);
                }
                scheduleMap.put(vaccine, recommendedMonths);
            }
            
            // 3. Lấy Map ghi chú từ bảng tblChildVaccineNotes (key: vaccineID, value: note)
            Map<Integer, String> vaccineNotes = dao.getVaccineNotes();
            
            // 4. Đặt các dữ liệu cần thiết lên request
            request.setAttribute("SCHEDULE_MONTHS", BASE_SCHEDULE_MONTHS);
            request.setAttribute("SCHEDULE_MAP", scheduleMap);
            request.setAttribute("VACCINE_NOTES", vaccineNotes);
            
            // Nếu cần, tạo thêm attribute theo vaccineID
            Map<Integer, Set<Integer>> scheduleVaccineMap = new HashMap<>();
            for (VaccineDTO vaccine : vaccineList) {
                String recommendedAge = vaccine.getRecommendedAge();
                Set<Integer> recommendedMonths = parseRecommendedAge(recommendedAge);
                // Lặp lại logic thêm nhắc
                String vaccineName = vaccine.getVaccineName().toLowerCase();
                if(vaccineName.contains("hib")) {
                    recommendedMonths.add(18);
                } else if(vaccineName.contains("thuong han")) {
                    recommendedMonths.add(30);
                } else if(vaccineName.contains("viem gan a")) {
                    recommendedMonths.add(6);
                    recommendedMonths.add(12);
                } else if(vaccineName.contains("soi")) {
                    recommendedMonths.add(18);
                } else if(vaccineName.contains("phoi cau")) {
                    recommendedMonths.add(12);
                    recommendedMonths.add(15);
                }
                scheduleVaccineMap.put(vaccine.getVaccineID(), recommendedMonths);
            }
            request.setAttribute("SCHEDULE_VACCINE_MAP", scheduleVaccineMap);
            
            // 5. Forward sang trang JSP hiển thị
            request.getRequestDispatcher("vaccineSchedule.jsp").forward(request, response);
        } catch (Exception e) {
            log("Error at VaccinationScheduleController: " + e.toString());
            e.printStackTrace();
            request.setAttribute("ERROR", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    /**
     * Phương thức parseRecommendedAge(String)
     * Tìm các số trong chuỗi recommendedAge rồi xác định đó là "tháng" hay "tuổi".
     * Ví dụ: "2 thang tuoi" -> thêm 2; "1 tuoi" -> thêm 12.
     */
    private Set<Integer> parseRecommendedAge(String recommendedAge) {
        Set<Integer> months = new HashSet<>();
        if (recommendedAge == null) {
            return months;
        }
        String[] tokens = recommendedAge.split("\\s+");
        for (int i = 0; i < tokens.length; i++) {
            try {
                int number = Integer.parseInt(tokens[i]);
                if (i + 1 < tokens.length) {
                    String next = tokens[i + 1].toLowerCase();
                    if (next.contains("thang")) {
                        months.add(number);
                    } else if (next.contains("tuoi")) {
                        months.add(number * 12);
                    }
                }
            } catch (NumberFormatException e) {
                // Bỏ qua token không phải số
            }
        }
        return months;
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
