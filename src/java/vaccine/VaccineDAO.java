package vaccine;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;
import java.text.Normalizer;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class VaccineDAO {

    private static final String GET_ALL_VACCINES = "SELECT vaccineID, vaccineName, description, price, recommendedAge, status FROM tblVaccines WHERE status = 'Active'";
    private static final String GET_VACCINE_BY_ID = "SELECT vaccineID, vaccineName, description, price, recommendedAge, status FROM tblVaccines WHERE vaccineID = ? AND status = 'Active'";
    private static final String ADD_VACCINE = "INSERT INTO tblVaccines(vaccineName, description, price, recommendedAge, status) VALUES(?, ?, ?, ?, ?)";
    private static final String UPDATE_VACCINE = "UPDATE tblVaccines SET vaccineName = ?, description = ?, price = ?, recommendedAge = ?, status = ? WHERE vaccineID = ?";
    private static final String DELETE_VACCINE = "UPDATE tblVaccines SET status = 'Inactive' WHERE vaccineID = ?";
    private static final String GET_ACTIVE_VACCINES = "SELECT vaccineID, vaccineName, description, price, recommendedAge, status "
            + "FROM tblVaccines "
            + "WHERE status = 'Active' "
            + "ORDER BY vaccineName";

    private String normalizeString(String str) {
        if (str == null) {
            return "";
        }
        String temp = Normalizer.normalize(str, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(temp).replaceAll("").toLowerCase().trim();
    }

    public List<VaccineDTO> getActiveVaccines() throws Exception {
        List<VaccineDTO> vaccines = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_ACTIVE_VACCINES);
                rs = ps.executeQuery();

                while (rs.next()) {
                    VaccineDTO vaccine = new VaccineDTO(
                            rs.getInt("vaccineID"),
                            rs.getString("vaccineName"),
                            rs.getString("description"),
                            rs.getDouble("price"),
                            rs.getString("recommendedAge"),
                            rs.getString("status")
                    );
                    vaccines.add(vaccine);
                }
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return vaccines;
    }

    public List<VaccineDTO> search(String search) throws Exception {
        List<VaccineDTO> vaccines = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                // Đơn giản hóa câu query
                String sql = "SELECT vaccineID, vaccineName, description, price, recommendedAge, status "
                        + "FROM tblVaccines "
                        + "WHERE status = 'Active'";

                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();

                String searchLower = removeAccent(search.toLowerCase());
                System.out.println("Search term (no accent): " + searchLower); // Debug log

                while (rs.next()) {
                    String vaccineName = rs.getString("vaccineName");
                    String description = rs.getString("description");

                    // So sánh chuỗi không dấu
                    if (removeAccent(vaccineName.toLowerCase()).contains(searchLower)
                            || removeAccent(description.toLowerCase()).contains(searchLower)) {

                        VaccineDTO vaccine = new VaccineDTO(
                                rs.getInt("vaccineID"),
                                vaccineName,
                                description,
                                rs.getDouble("price"),
                                rs.getString("recommendedAge"),
                                rs.getString("status")
                        );
                        vaccines.add(vaccine);
                        System.out.println("Found vaccine: " + vaccineName); // Debug log
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error in search: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return vaccines;
    }

// Phương thức bỏ dấu tiếng Việt
    private String removeAccent(String s) {
        if (s == null) {
            return "";
        }
        String temp = Normalizer.normalize(s, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        temp = pattern.matcher(temp).replaceAll("");
        return temp.replaceAll("đ", "d").replaceAll("Đ", "D");
    }

    public List<VaccineDTO> getAllVaccines() throws Exception {
        List<VaccineDTO> vaccines = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_ALL_VACCINES);
                rs = ps.executeQuery();

                while (rs.next()) {
                    VaccineDTO vaccine = new VaccineDTO(
                            rs.getInt("vaccineID"),
                            rs.getString("vaccineName"),
                            rs.getString("description"),
                            rs.getDouble("price"),
                            rs.getString("recommendedAge"),
                            rs.getString("status")
                    );
                    vaccines.add(vaccine);
                }
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return vaccines;
    }

    public VaccineDTO getVaccineByID(int vaccineID) throws Exception {
        VaccineDTO vaccine = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_VACCINE_BY_ID);
                ps.setInt(1, vaccineID);
                rs = ps.executeQuery();

                if (rs.next()) {
                    vaccine = new VaccineDTO(
                            rs.getInt("vaccineID"),
                            rs.getString("vaccineName"),
                            rs.getString("description"),
                            rs.getDouble("price"),
                            rs.getString("recommendedAge"),
                            rs.getString("status")
                    );
                }
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return vaccine;
    }

    public boolean addVaccine(VaccineDTO vaccine) throws Exception {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(ADD_VACCINE);
                ps.setString(1, vaccine.getVaccineName());
                ps.setString(2, vaccine.getDescription());
                ps.setDouble(3, vaccine.getPrice());
                ps.setString(4, vaccine.getRecommendedAge());
                ps.setString(5, "Active");

                check = ps.executeUpdate() > 0;
            }
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

    public boolean updateVaccine(VaccineDTO vaccine) throws Exception {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(UPDATE_VACCINE);
                ps.setString(1, vaccine.getVaccineName());
                ps.setString(2, vaccine.getDescription());
                ps.setDouble(3, vaccine.getPrice());
                ps.setString(4, vaccine.getRecommendedAge());
                ps.setString(5, vaccine.getStatus());
                ps.setInt(6, vaccine.getVaccineID());

                check = ps.executeUpdate() > 0;
            }
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

    public boolean deleteVaccine(int vaccineID) throws Exception {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(DELETE_VACCINE);
                ps.setInt(1, vaccineID);

                check = ps.executeUpdate() > 0;
            }
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

    public List<VaccineDTO> searchVaccines(String searchTerm) throws Exception {
        List<VaccineDTO> vaccines = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT vaccineID, vaccineName, description, price, recommendedAge, status "
                        + "FROM tblVaccines "
                        + "WHERE status = 'Active'";

                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();

                // Chuẩn hóa từ khóa tìm kiếm
                String normalizedSearch = removeAccent(searchTerm.toLowerCase().trim());

                while (rs.next()) {
                    String vaccineName = rs.getString("vaccineName");
                    String description = rs.getString("description");

                    // So sánh cả có dấu và không dấu
                    String normalizedName = removeAccent(vaccineName.toLowerCase());
                    String normalizedDesc = removeAccent(description.toLowerCase());

                    if (normalizedName.contains(normalizedSearch)
                            || normalizedDesc.contains(normalizedSearch)
                            || vaccineName.toLowerCase().contains(searchTerm.toLowerCase())
                            || description.toLowerCase().contains(searchTerm.toLowerCase())) {

                        VaccineDTO vaccine = new VaccineDTO(
                                rs.getInt("vaccineID"),
                                vaccineName,
                                description,
                                rs.getDouble("price"),
                                rs.getString("recommendedAge"),
                                rs.getString("status")
                        );
                        vaccines.add(vaccine);
                    }
                }
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return vaccines;
    }
    
    // Lấy thông tin vaccine
    private static final String GET_VACCINE_NOTES
            = "SELECT vaccineID, note FROM tblChildVaccineNotes";

    public Map<Integer, String> getVaccineNotes() throws Exception {
        Map<Integer, String> notes = new HashMap<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_VACCINE_NOTES);
                rs = ps.executeQuery();
                while (rs.next()) {
                    int vaccineID = rs.getInt("vaccineID");
                    String note = rs.getString("note");
                    notes.put(vaccineID, note);
                }
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return notes;
    }
    //Sửa giá vaccine trong trang admin
    public boolean updateVaccinePrice(int vaccineId, BigDecimal newPrice) throws Exception {
    Connection conn = null;
    PreparedStatement ps = null;
    boolean success = false;
    
    try {
        conn = DBUtils.getConnection();
        String sql = "UPDATE tblVaccines SET price = ? WHERE vaccineID = ? AND status = 'Active'";
        ps = conn.prepareStatement(sql);
        ps.setBigDecimal(1, newPrice);
        ps.setInt(2, vaccineId);
        
        int rowsAffected = ps.executeUpdate();
        success = rowsAffected > 0;
        
    } finally {
        if (ps != null) {
            ps.close();
        }//
        if (conn != null) {
            conn.close();
        }
    }
    
    return success;
}


}
