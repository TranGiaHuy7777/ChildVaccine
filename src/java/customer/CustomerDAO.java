package customer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException;
import utils.DBUtils;

public class CustomerDAO {

    private static final String LOGIN = "SELECT fullName, roleID FROM tblCustomers WHERE userID=? AND password=?";
    private static final String SEARCH_BY_NAME = "SELECT userID, password, roleID, fullName, email, address, phone FROM tblCustomers WHERE LOWER(fullName) LIKE ?";
    private static final String GET_ALL = "SELECT userID, password, roleID, fullName, email, address, phone FROM tblCustomers";
    private static final String DELETE = "DELETE tblCustomers WHERE userID=?";
    private static final String UPDATE = "UPDATE tblCustomers SET password=? , roleID=?, fullName=?, email=?,address=?,phone=? WHERE userID=?";
    private static final String DUPLICATE = "SELECT fullName FROM tblCustomers WHERE userID = ?";
    private static final String INSERT = "INSERT INTO tblCustomers(userID, fullName, roleID, password, email, address, phone,status) VALUES(?,?,?,?,?,?,?,1)";

   public CustomerDTO checkLogin(String userID, String password) {
    CustomerDTO user = null;
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Thêm COLLATE Latin1_General_CS_AS để phân biệt chữ hoa/thường
        String sql = "SELECT userID, fullName, roleID, email, phone, address " +
                    "FROM tblCustomers " +
                    "WHERE userID COLLATE Latin1_General_CS_AS = ? " +  // Thêm COLLATE ở đây
                    "AND password = ? AND status=1";
        
        conn = DBUtils.getConnection();
        ps = conn.prepareStatement(sql);
        ps.setString(1, userID);  // Giữ nguyên userID như người dùng nhập
        ps.setString(2, password);
        rs = ps.executeQuery();

        if (rs.next()) {
            String fullName = rs.getString("fullName");
            String roleID = rs.getString("roleID");
            String email = rs.getString("email");
            String phone = rs.getString("phone");
            String address = rs.getString("address");

            user = new CustomerDTO();
            user.setUserID(userID);  // Sử dụng userID gốc
            user.setFullName(fullName);
            user.setRoleID(roleID);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    return user;
}

   public boolean updateProfile(CustomerDTO user) throws SQLException, Exception {
    boolean check = false;
    Connection conn = null;
    PreparedStatement ps = null;
    
    try {
        conn = DBUtils.getConnection();
        String sql = "UPDATE tblCustomers SET fullName=?, email=?, phone=?, address=? WHERE userID=?";
        ps = conn.prepareStatement(sql);
        
        ps.setString(1, user.getFullName());
        ps.setString(2, user.getEmail());
        ps.setString(3, user.getPhone());
        ps.setString(4, user.getAddress());
        ps.setString(5, user.getUserID());
        
        int rowsAffected = ps.executeUpdate();
        check = rowsAffected > 0;
        
        System.out.println("Update rows affected: " + rowsAffected);
        
    } catch (Exception e) {
        System.out.println("Error in updateProfile: " + e.getMessage());
        e.printStackTrace();
        throw e;
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
    return check;
}

    public CustomerDTO getUserByID(String userID) throws SQLException, ClassNotFoundException {
        CustomerDTO user = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            String sql = "SELECT * FROM tblCustomers WHERE userID=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, userID);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = new CustomerDTO();
                user.setUserID(rs.getString("userID"));
                user.setFullName(rs.getString("fullName"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRoleID(rs.getString("roleID"));
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
        return user;
    }

    // Phương thức lấy tất cả users
    public List<CustomerDTO> getListUser() throws SQLException {
        List<CustomerDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT userID, password, roleID, fullName, email, address, phone FROM tblCustomers";
                ptm = conn.prepareStatement(sql);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    String userID = rs.getString("userID");
                    String password = rs.getString("password");
                    String roleID = rs.getString("roleID");
                    String fullName = rs.getString("fullName");
                    String email = rs.getString("email");
                    String address = rs.getString("address");
                    String phone = rs.getString("phone");
                    list.add(new CustomerDTO(userID, password, roleID, fullName, email, address, phone));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return list;
    }

    public boolean testConnection() {
        try (Connection conn = DBUtils.getConnection()) {
            return conn != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Phương thức search theo tên
    public List<CustomerDTO> searchByName(String searchName) throws SQLException {
        List<CustomerDTO> users = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(SEARCH_BY_NAME);
                ptm.setString(1, "%" + searchName.toLowerCase() + "%");
                rs = ptm.executeQuery();
                while (rs.next()) {
                    String userID = rs.getString("userID");
                    String roleID = rs.getString("roleID");
                    String fullName = rs.getString("fullName");
                    String email = rs.getString("email");
                    String address = rs.getString("address");
                    String phone = rs.getString("phone");
                    users.add(new CustomerDTO(userID, "***", roleID, fullName, email, address, phone));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return users;
    }

    public boolean delete(String userID) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(DELETE);
                ptm.setString(1, userID);
                check = ptm.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

    public boolean update(CustomerDTO user) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                // Fixed SQL query to match database schema
                String sql = "UPDATE tblCustomers SET fullName=?, roleID=?, email=?, phone=? WHERE userID=?";
                ptm = conn.prepareStatement(sql);
                ptm.setString(1, user.getFullName());
                ptm.setString(2, user.getRoleID());
                ptm.setString(3, user.getEmail());
                ptm.setString(4, user.getPhone());
                ptm.setString(5, user.getUserID());
                check = ptm.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace(); // Add logging
        } finally {
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

    public boolean updateUser(CustomerDTO user) throws SQLException {
        boolean result = false;
        Connection con = null;
        PreparedStatement pst = null;
        try {
            con = DBUtils.getConnection();
            if (con != null) {
                String sql = "UPDATE Customers SET fullName=?, email=?, phone=? WHERE userID=?";
                pst = con.prepareStatement(sql);
                pst.setString(1, user.getFullName());
                pst.setString(2, user.getEmail());
                pst.setString(3, user.getPhone());
                pst.setString(4, user.getUserID());
                result = pst.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (pst != null) {
                pst.close();
            }
            if (con != null) {
                con.close();
            }
        }
        return result;
    }

    public boolean checkDuplicate(String userID) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(DUPLICATE);
                ptm.setString(1, userID);
                rs = ptm.executeQuery();
                if (rs.next()) {
                    check = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

    public boolean insertv2(CustomerDTO user) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(INSERT);
                ptm.setString(1, user.getUserID());
                ptm.setString(2, user.getFullName());
                ptm.setString(3, user.getRoleID());
                ptm.setString(4, user.getPassword());
                ptm.setString(5, user.getEmail());
                ptm.setString(6, user.getAddress());
                ptm.setString(7, user.getPhone());
                check = ptm.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

}
