package controller;

import vaccine.VaccineDAO;
import vaccine.VaccineDTO;
import disease.DiseaseDTO; 
import disease.DiseaseDAO; 
import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "VaccinationScheduleController", urlPatterns = {"/VaccinationScheduleController"})
public class VaccinationScheduleController extends HttpServlet {

    // Danh sách các mốc tháng cơ bản để hiển thị trong bảng
    private static final List<Integer> BASE_SCHEDULE_MONTHS = Arrays.asList(
        2, 3, 4, 6, 9, 12, 15, 18, 24, 36
    );

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            request.setCharacterEncoding("UTF-8");
        try {
            VaccineDAO vaccineDao = new VaccineDAO();
            DiseaseDAO diseaseDao = new DiseaseDAO();
            
            // 1. Lấy danh sách vaccine từ DB
            List<VaccineDTO> vaccineList = vaccineDao.getAllVaccines();
            // 2. Lấy thông tin bệnh từ bảng tblDisease (lấy theo vaccineID)
            Map<Integer, DiseaseDTO> diseaseInfo = diseaseDao.getDiseaseInfo();

            // Nếu có thông tin bệnh cho vaccine nào, ta cập nhật vaccineName thành diseaseName để hiển thị cột "Bệnh"
            for (VaccineDTO vaccine : vaccineList) {
                if (diseaseInfo.containsKey(vaccine.getVaccineID())) {
                    vaccine.setVaccineName(diseaseInfo.get(vaccine.getVaccineID()).getDiseaseName());
                }
            }

            // 3. Tạo map: VaccineDTO -> Set<Integer> dựa trên recommendedAge và logic thêm mũi nhắc bổ sung
            Map<VaccineDTO, Set<Integer>> scheduleMap = new HashMap<>();
            for (VaccineDTO vaccine : vaccineList) {
                String recommendedAge = vaccine.getRecommendedAge();
                Set<Integer> recommendedMonths = parseRecommendedAge(recommendedAge);
                
                String lowerName = vaccine.getVaccineName().toLowerCase();
                if(lowerName.contains("hib")) {
                    recommendedMonths.add(18);
                } else if(lowerName.contains("thuong han")) {
                    recommendedMonths.add(30);
                } else if(lowerName.contains("viem gan a")) {
                    recommendedMonths.add(6);
                    recommendedMonths.add(12);
                } else if(lowerName.contains("soi")) {
                    recommendedMonths.add(18);
                } else if(lowerName.contains("phoi cau")) {
                    recommendedMonths.add(12);
                    recommendedMonths.add(15);
                }
                scheduleMap.put(vaccine, recommendedMonths);
            }

            // 4. Đặt dữ liệu lên request
            request.setAttribute("SCHEDULE_MONTHS", BASE_SCHEDULE_MONTHS);
            request.setAttribute("SCHEDULE_MAP", scheduleMap);
            // Gửi thông tin bệnh để JSP hiển thị modal (key: vaccineID, value: DiseaseDTO chứa diseaseName và description)
            request.setAttribute("DISEASE_INFO", diseaseInfo);

            // 5. Nếu cần, tạo thêm attribute map theo vaccineID
            Map<Integer, Set<Integer>> scheduleVaccineMap = new HashMap<>();
            for (VaccineDTO vaccine : vaccineList) {
                String recommendedAge = vaccine.getRecommendedAge();
                Set<Integer> recommendedMonths = parseRecommendedAge(recommendedAge);
                String lowerName = vaccine.getVaccineName().toLowerCase();
                if(lowerName.contains("hib")) {
                    recommendedMonths.add(18);
                } else if(lowerName.contains("thuong han")) {
                    recommendedMonths.add(30);
                } else if(lowerName.contains("viem gan a")) {
                    recommendedMonths.add(6);
                    recommendedMonths.add(12);
                } else if(lowerName.contains("soi")) {
                    recommendedMonths.add(18);
                } else if(lowerName.contains("phoi cau")) {
                    recommendedMonths.add(12);
                    recommendedMonths.add(15);
                }
                scheduleVaccineMap.put(vaccine.getVaccineID(), recommendedMonths);
            }
            request.setAttribute("SCHEDULE_VACCINE_MAP", scheduleVaccineMap);
            
            // 6. Forward sang trang JSP hiển thị
            request.getRequestDispatcher("vaccineSchedule.jsp").forward(request, response);
        } catch (Exception e) {
            log("Error at VaccinationScheduleController: " + e.toString());
            e.printStackTrace();
            request.setAttribute("ERROR", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    /**
     * Phương thức parseRecommendedAge(String):
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
