package disease;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import utils.DBUtils;
import vaccine.VaccineDTO;

public class DiseaseDAO {

    // Phương thức này chỉ lấy diseaseID và diseaseName từ bảng tblDisease
    // Lấy danh sách bệnh (chỉ gồm diseaseId và diseaseName)
    public List<DiseaseDTO> getAllDiseaseNames() throws Exception {
        List<DiseaseDTO> list = new ArrayList<>();
        String sql = "SELECT diseaseId, diseaseName FROM tblDiseaseName";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("diseaseId");
                String name = rs.getString("diseaseName");
                DiseaseDTO dto = new DiseaseDTO();
                dto.setDiseaseID(id);
                dto.setDiseaseName(name);
                list.add(dto);
            }
        }
        return list;
    }
    
    // Phương thức getAllDiseases() đầy đủ (nếu cần)
    public List<DiseaseDTO> getAllDiseases() throws Exception {
    List<DiseaseDTO> list = new ArrayList<>();
    // Thực hiện join 2 bảng để lấy vaccineID từ tblVaccines
    String sql = "SELECT dn.diseaseId, v.vaccineID, dn.diseaseName, dn.description " +
                 "FROM tblDiseaseName dn " +
                 "INNER JOIN tblVaccines v ON dn.vaccineID = v.vaccineID";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            int diseaseID = rs.getInt("diseaseId");
            int vaccineID = rs.getInt("vaccineID");
            String diseaseName = rs.getString("diseaseName");
            String description = rs.getString("description");
            
            DiseaseDTO dto = new DiseaseDTO(diseaseID, diseaseName, description);
            dto.setVaccineID(vaccineID);
            list.add(dto);
        }
    }
    return list;
}

    
    // Ví dụ phương thức lấy danh sách Vaccine cho bệnh (nếu cần)
    public List<VaccineDTO> getVaccinesByDisease(int diseaseID) throws Exception {
        List<VaccineDTO> list = new ArrayList<>();
        String sql = "SELECT v.vaccineID, v.vaccineName, v.description, v.price, v.recommendedAge, v.status " +
                     "FROM tblDiseaseName dv " +
                     "JOIN tblVaccines v ON dv.vaccineID = v.vaccineID " +
                     "WHERE dv.diseaseID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, diseaseID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int vaccineID = rs.getInt("vaccineID");
                    String vaccineName = rs.getString("vaccineName");
                    String description = rs.getString("description");
                    double price = rs.getDouble("price");
                    String recommendedAge = rs.getString("recommendedAge");
                    String status = rs.getString("status");
                    
                    // Giả sử VaccineDTO constructor có thứ tự: vaccineID, vaccineName, description, price, recommendedAge, status
                    VaccineDTO vaccine = new VaccineDTO(vaccineID, vaccineName, description, price, recommendedAge, status);
                    list.add(vaccine);
                }
            }
        }
        return list;
    }
    
     /**
     * Lấy thông tin bệnh (diseaseName, description) từ bảng tblDisease,
     * trả về Map với key là vaccineID và value là DiseaseDTO.
     * Nếu có nhiều bản ghi cùng vaccineID, chỉ lấy bản ghi đầu tiên.
     */
    public Map<Integer, DiseaseDTO> getDiseaseInfo() throws Exception {
        Map<Integer, DiseaseDTO> map = new HashMap<>();
        String sql = "SELECT DISTINCT vaccineID, diseaseName, description FROM tblDiseaseName";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int vaccineID = rs.getInt("vaccineID");
                String diseaseName = rs.getString("diseaseName");
                String description = rs.getString("description");
                
                DiseaseDTO dto = new DiseaseDTO();
                dto.setDiseaseName(diseaseName);
                dto.setDescription(description);
                // Lưu ý: diseaseID không được sử dụng làm key ở đây vì key là vaccineID
                map.put(vaccineID, dto);
            }
        }
        return map;
    }
    
    public DiseaseDTO getDiseaseById(int diseaseID) throws Exception {
    DiseaseDTO dto = null;
    String sql = "SELECT diseaseId, diseaseName, description FROM tblDiseaseName WHERE diseaseId = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, diseaseID);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                dto = new DiseaseDTO();
                dto.setDiseaseID(rs.getInt("diseaseId"));
                dto.setDiseaseName(rs.getString("diseaseName"));
                dto.setDescription(rs.getString("description"));
            }
        }
    }
    return dto;
}

public boolean addDisease(Connection conn, DiseaseDTO disease) throws Exception {
    boolean result = false;
    String sql = "INSERT INTO tblDisease (childID, vaccineID, appointmentID, diseaseName, description, diagnosisDate) "
               + "VALUES (?, ?, ?, ?, ?, ?)";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, disease.getChildID());
        ps.setInt(2, disease.getVaccineID());
        ps.setInt(3, disease.getAppointmentID());
        ps.setString(4, disease.getDiseaseName());
        ps.setString(5, disease.getDescription());
        ps.setDate(6, disease.getDiagnosisDate());
        
        result = (ps.executeUpdate() > 0);
    }
    return result;
}
public boolean addDiseaseName(DiseaseDTO disease) throws Exception {
    boolean result = false;
    String sql = "INSERT INTO tblDiseaseName (vaccineID, diseaseName, description) VALUES (?, ?, ?)";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
         ps.setInt(1, disease.getVaccineID());
         ps.setString(2, disease.getDiseaseName());
         ps.setString(3, disease.getDescription());
         result = (ps.executeUpdate() > 0);
    }
    return result;
}
public boolean deleteDiseaseName(int diseaseID) throws Exception {
    boolean result = false;
    String sql = "DELETE FROM tblDiseaseName WHERE diseaseId = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
         ps.setInt(1, diseaseID);
         result = (ps.executeUpdate() > 0);
    }
    return result;
}

public boolean updateDiseaseName(DiseaseDTO disease) throws Exception {
    boolean result = false;
    String sql = "UPDATE tblDiseaseName SET vaccineID = ?, diseaseName = ?, description = ? WHERE diseaseId = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
         ps.setInt(1, disease.getVaccineID());
         ps.setString(2, disease.getDiseaseName());
         ps.setString(3, disease.getDescription());
         ps.setInt(4, disease.getDiseaseID());
         result = (ps.executeUpdate() > 0);
    }
    return result;
}

}
