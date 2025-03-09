package child;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class ChildDAO {

    public int insertChild(ChildDTO child) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO tblChildren (userID, childName, dateOfBirth, gender) VALUES (?, ?, ?, ?)";
        int generatedID = 0; // Giá trị mặc định nếu thất bại

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, child.getUserID());
            ps.setString(2, child.getChildName());
            ps.setDate(3, child.getDateOfBirth());
            ps.setString(4, child.getGender());
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedID = rs.getInt(1); // Lấy childID vừa tạo
                    }
                }
            }
        }
        return generatedID;
    }

    public boolean childExists(String userID, String childName, Date dateOfBirth) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM tblChildren WHERE userID = ? AND childName = ? AND dateOfBirth = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userID);
            ps.setString(2, childName);
            ps.setDate(3, dateOfBirth);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // Kiểm tra xem khách hàng đã có con chưa
    public boolean hasChildren(int customerID) throws Exception {
        String sql = "SELECT COUNT(*) FROM tblChildren WHERE customerID = ?";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // Lấy danh sách trẻ em theo customerID
    public List<ChildDTO> getChildrenByCustomerID(int customerID) throws SQLException, ClassNotFoundException {
        List<ChildDTO> children = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            // Updated SQL query to match your database structure
            String sql = "SELECT * FROM tblChildren WHERE customerID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerID);

            // Debug log
            System.out.println("Executing query with customerID: " + customerID);

            rs = ps.executeQuery();

            while (rs.next()) {
                ChildDTO child = new ChildDTO();
                child.setChildID(rs.getInt("childID"));
                child.setUserID(rs.getString("userID"));
                child.setChildName(rs.getString("ChildName"));
                child.setDateOfBirth(rs.getDate("dateOfBirth"));
                child.setGender(rs.getString("gender"));
                children.add(child);

                // Debug log
                System.out.println("Found child: " + child.getChildName());
            }
        } catch (SQLException e) {
            System.out.println("Error in getChildrenByCustomerID: " + e.getMessage());
            e.printStackTrace();
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
        return children;
    }

    // Thêm trẻ em vào cơ sở dữ liệu
    public boolean addChild(ChildDTO child) throws Exception {
        String sql = "INSERT INTO tblChildren (userID, fullName, dateOfBirth, gender) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, child.getUserID());
            ps.setString(2, child.getChildName());
            ps.setDate(3, child.getDateOfBirth()); // Đảm bảo dateOfBirth là kiểu java.sql.Date
            ps.setString(4, child.getGender());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception("Lỗi khi thêm trẻ vào cơ sở dữ liệu: " + e.getMessage());
        }
    }

    // Lấy thông tin trẻ em theo ID
    public ChildDTO getChildByID(int childID) throws Exception {
    ChildDTO child = null;
    String sql = "SELECT childID, userID, childName, dateOfBirth, gender FROM tblChildren WHERE childID = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
         ps.setInt(1, childID);
         try (ResultSet rs = ps.executeQuery()) {
             if (rs.next()) {
                 child = new ChildDTO(
                     rs.getInt("childID"),
                     rs.getString("userID"),
                     rs.getString("childName"),
                     rs.getDate("dateOfBirth"),
                     rs.getString("gender")
                 );
             }
         }
    }
    return child;
}


    //Hồ sơ trẻ em
    public List<ChildDTO> getAllChildrenByUserID(String userID) throws SQLException, ClassNotFoundException {
        List<ChildDTO> children = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            // Debug log
            System.out.println("Debug - Executing getAllChildrenByUserID:");
            System.out.println("UserID: " + userID);

            String sql = "SELECT * FROM tblChildren WHERE userID = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, userID);

            rs = ps.executeQuery();

            while (rs.next()) {
                ChildDTO child = new ChildDTO();
                child.setChildID(rs.getInt("childID"));
                child.setUserID(rs.getString("userID"));
                // Sử dụng tên cột đúng "childName"
                child.setChildName(rs.getString("childName"));
                child.setDateOfBirth(rs.getDate("dateOfBirth"));
                child.setGender(rs.getString("gender"));

                // Debug log
                System.out.println("Found child: " + child.getChildName());
                children.add(child);
            }

        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
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
        return children;
    }

    // Cập nhật thông tin trẻ em
    public boolean updateChild(ChildDTO child) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;

        try {
            conn = DBUtils.getConnection();
            String sql = "UPDATE tblChildren SET ChildName=?, dateOfBirth=?, gender=? WHERE childID=?";
            ps = conn.prepareStatement(sql);

            ps.setString(1, child.getChildName());
            ps.setDate(2, child.getDateOfBirth());
            ps.setString(3, child.getGender());
            ps.setInt(4, child.getChildID());

            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;

        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return success;
    }

    // Xóa thông tin trẻ em
    public boolean deleteChild(int childID) throws Exception {
        String sql = "DELETE FROM tblChildren WHERE childID = ?";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, childID);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteAppointmentSessions(int childID) throws Exception {
        String sql = "DELETE FROM tblAppointments WHERE childID = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, childID);
            int rowsAffected = ps.executeUpdate();
            System.out.println("Deleted appointment sessions for childID " + childID + ": " + rowsAffected + " rows affected.");
            return rowsAffected > 0;
        }
    }

}
