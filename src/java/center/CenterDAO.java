/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package center;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

/**
 *
 * @author Windows
 */
public class CenterDAO {

    // Lấy danh sách tất cả các trung tâm tiêm chủng
public List<CenterDTO> getAllCenters() throws Exception {
    List<CenterDTO> centers = new ArrayList<>();
    String sql = "SELECT centerID, centerName, address, phoneNumber, email, operatingHours, description FROM tblCenters";

    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            CenterDTO center = new CenterDTO(
                rs.getInt("centerID"),
                rs.getString("centerName"),
                rs.getString("address"),
                rs.getString("phoneNumber"),
                rs.getString("email"),
                rs.getString("operatingHours"),
                rs.getString("description")
            );
            centers.add(center);
        }
    }
    return centers;
}

public List<CenterDTO> search(String search) throws Exception {
    List<CenterDTO> centers = new ArrayList<>();
    String sql = "SELECT centerID, centerName, address, phoneNumber, email, operatingHours, description "
              + "FROM tblCenters "
              + "WHERE centerName LIKE ? OR address LIKE ?";

    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, "%" + search + "%");
        ps.setString(2, "%" + search + "%");
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CenterDTO center = new CenterDTO(
                    rs.getInt("centerID"),
                    rs.getString("centerName"),
                    rs.getString("address"),
                    rs.getString("phoneNumber"),
                    rs.getString("email"),
                    rs.getString("operatingHours"),
                    rs.getString("description")
                );
                centers.add(center);
            }
        }
    }
    return centers;
}


    // Thêm mới một trung tâm tiêm chủng
    public boolean addCenter(CenterDTO center) throws Exception {
        String sql = "INSERT INTO tblCenters(centerID, centerName, address, phoneNumber, email, operatingHours, description) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, center.getCenterID());
            ps.setString(2, center.getCenterName());
            ps.setString(3, center.getAddress());
            ps.setString(4, center.getPhoneNumber());
            ps.setString(5, center.getEmail());

            return ps.executeUpdate() > 0;
        }
    }

    // Cập nhật thông tin trung tâm
    public boolean updateCenter(CenterDTO center) throws Exception {
        String sql = "UPDATE tblCenters SET centerName = ?, address = ?, phoneNumber = ?, email = ? , operatingHours = ? , description = ? WHERE centerID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, center.getCenterName());
            ps.setString(2, center.getAddress());
            ps.setString(3, center.getPhoneNumber());
            ps.setString(4, center.getEmail());
            ps.setString(5, center.getOperatingHours());
            ps.setString(6, center.getDescription());
            ps.setInt(7, center.getCenterID());

            return ps.executeUpdate() > 0;
        }
    }

    // Xóa trung tâm theo ID
    public boolean deleteCenter(int centerID) throws Exception {
        String sql = "DELETE FROM tblCenters WHERE centerID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, centerID);
            return ps.executeUpdate() > 0;
        }
    }
}
