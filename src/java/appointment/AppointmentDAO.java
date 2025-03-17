package appointment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;
import static utils.DBUtils.getConnection;

public class AppointmentDAO {

    // Lấy tất cả cuộc hẹn (bao gồm vaccineID)
    public List<AppointmentDTO> getAllAppointments() throws Exception {
    List<AppointmentDTO> appointments = new ArrayList<>();
    String sql = "SELECT * FROM tblAppointments";

    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            AppointmentDTO appointment = new AppointmentDTO(
                    rs.getInt("appointmentID"),
                    rs.getInt("childID"),
                    rs.getInt("centerID"),
                    rs.getDate("appointmentDate"),
                    rs.getString("serviceType"),
                    rs.getString("notificationStatus"),
                    rs.getString("status"),
                    rs.getInt("vaccineID")
            );
            appointments.add(appointment);
        }
    }
    return appointments;
}


    // Thêm cuộc hẹn mới (bao gồm vaccineID)
    public int addAppointment(Connection conn, AppointmentDTO appointment) throws Exception {
    int generatedID = 0;
    String sql = "INSERT INTO tblAppointments(childID, centerID, appointmentDate, serviceType, notificationStatus, status, vaccineID) "
               + "VALUES (?, ?, ?, ?, ?, ?, ?)";

    try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
        ps.setInt(1, appointment.getChildID());
        ps.setInt(2, appointment.getCenterID());

        // Chuyển đổi java.util.Date thành java.sql.Date
        ps.setDate(3, new java.sql.Date(appointment.getAppointmentDate().getTime()));

        ps.setString(4, appointment.getServiceType());
        ps.setString(5, appointment.getNotificationStatus());
        ps.setString(6, appointment.getStatus());
        ps.setInt(7, appointment.getVaccineID());

        int rows = ps.executeUpdate();
        if (rows > 0) {
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedID = rs.getInt(1);
                }
            }
        }
    }
    return generatedID;
}



    // Cập nhật trạng thái thông báo (không thay đổi, vì không liên quan đến vaccineID)
    public boolean updateNotificationStatus(int appointmentID, String status) throws Exception {
        String sql = "UPDATE tblAppointments SET notificationStatus = ? WHERE appointmentID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, appointmentID);
            return ps.executeUpdate() > 0;
        }
    }

    // Tìm cuộc hẹn theo ID (bao gồm vaccineID)
    public AppointmentDTO findAppointmentById(int appointmentID) throws Exception {
        String sql = "SELECT * FROM tblAppointments WHERE appointmentID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new AppointmentDTO(
                            rs.getInt("appointmentID"),
                            rs.getInt("childID"),
                            rs.getInt("centerID"),
                            rs.getDate("appointmentDate"),
                            rs.getString("serviceType"),
                            rs.getString("notificationStatus"),
                            rs.getString("status"),
                            rs.getInt("vaccineID")
                    );
                }
            }
        }
        return null;
    }

    // Lấy lịch sử cuộc hẹn theo childID (bao gồm vaccineID)
    public List<AppointmentDTO> getAppointmentHistory(int childID) throws Exception {
        List<AppointmentDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM tblAppointments WHERE childID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, childID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new AppointmentDTO(
                            rs.getInt("appointmentID"),
                            rs.getInt("childID"),
                            rs.getInt("centerID"),
                            rs.getDate("appointmentDate"),
                            rs.getString("serviceType"),
                            rs.getString("notificationStatus"),
                            rs.getString("status"),
                            rs.getInt("vaccineID")
                    ));
                }
            }
        }
        return list;
    }

    // Lấy các cuộc hẹn theo childID, sắp xếp theo appointmentDate giảm dần (bao gồm vaccineID)
    public List<AppointmentDTO> getAppointmentsByChildID(int childID) throws Exception {
        List<AppointmentDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM tblAppointments WHERE childID = ? ORDER BY appointmentDate DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, childID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new AppointmentDTO(
                            rs.getInt("appointmentID"),
                            rs.getInt("childID"),
                            rs.getInt("centerID"),
                            rs.getDate("appointmentDate"),
                            rs.getString("serviceType"),
                            rs.getString("notificationStatus"),
                            rs.getString("status"),
                            rs.getInt("vaccineID")
                    ));
                }
            }
        }
        return list;
    }

    // Xóa cuộc hẹn theo appointmentID
    public boolean deleteAppointment(int appointmentID) throws Exception {
        String sql = "DELETE FROM tblAppointments WHERE appointmentID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, appointmentID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

   
    public List<AppointmentDTO> getAppointmentsByUserID(String userID) throws Exception {
    List<AppointmentDTO> list = new ArrayList<>();
    String sql = "SELECT a.appointmentID, a.childID, a.centerID, a.appointmentDate, " +
                 "a.serviceType, a.notificationStatus, a.status, a.vaccineID, " +
                 "c.childName, c.dateOfBirth, c.gender " +
                 "FROM tblAppointments a JOIN tblChildren c ON a.childID = c.childID " +
                 "WHERE c.userID = ? ORDER BY a.appointmentDate DESC";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, userID);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AppointmentDTO appointment = new AppointmentDTO();
                appointment.setAppointmentID(rs.getInt("appointmentID"));
                appointment.setChildID(rs.getInt("childID"));
                appointment.setCenterID(rs.getInt("centerID"));
                appointment.setAppointmentDate(rs.getDate("appointmentDate"));
                appointment.setServiceType(rs.getString("serviceType"));
                appointment.setNotificationStatus(rs.getString("notificationStatus"));
                appointment.setStatus(rs.getString("status"));
                appointment.setVaccineID(rs.getInt("vaccineID"));
                // Các thông tin của trẻ
                appointment.setChildName(rs.getString("childName"));
                appointment.setDateOfBirth(rs.getDate("dateOfBirth"));
                appointment.setGender(rs.getString("gender"));
                list.add(appointment);
            }
        }
    }
    return list;
}


    /*
    public List<AppointmentDTO> getAppointmentsByUserID(String userID) throws Exception {
    List<AppointmentDTO> list = new ArrayList<>();
    String sql = "SELECT a.appointmentID, a.childID, a.centerID, a.appointmentDate, " +
                 "a.serviceType, a.notificationStatus, a.status, " +
                 "c.ChildName as childName, c.dateOfBirth as dateOfBirth, c.gender as gender " +
                 "FROM tblAppointments a " +
                 "JOIN tblChildren c ON a.childID = c.childID " +
                 "WHERE c.userID = ? ORDER BY a.appointmentDate DESC";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, userID);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AppointmentDTO appointment = new AppointmentDTO();
                appointment.setAppointmentID(rs.getInt("appointmentID"));
                appointment.setChildID(rs.getInt("childID"));
                appointment.setCenterID(rs.getInt("centerID"));
                appointment.setAppointmentDate(rs.getDate("appointmentDate"));
                appointment.setServiceType(rs.getString("serviceType"));
                appointment.setNotificationStatus(rs.getString("notificationStatus"));
                appointment.setStatus(rs.getString("status"));
                appointment.setChildName(rs.getString("childName")); // Lấy thông tin từ alias
                appointment.setDateOfBirth(rs.getDate("dateOfBirth"));
                appointment.setGender(rs.getString("gender"));
                list.add(appointment);
            }
        }
    }
    return list;
}
*/
    
public boolean deleteAppointmentsByChildID(int childID) throws Exception {
    String sql = "DELETE FROM tblAppointments WHERE childID = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, childID);
        int rowsAffected = ps.executeUpdate();
        return rowsAffected >= 0;  // Hoặc kiểm tra cụ thể tùy vào logic của bạn
    }
}

public boolean updateAppointmentStatus(int appointmentID, String status) throws SQLException, ClassNotFoundException {
    String sql = "UPDATE tblAppointments SET status = ? WHERE appointmentID = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, status);
        ps.setInt(2, appointmentID);
        return ps.executeUpdate() > 0;
    }
}

 // 1. Lấy danh sách ngày hẹn, số mũi tiêm và doanh thu theo từng ngày
    public List<AppointmentStatisticsDTO> getAppointmentStatistics(int year) {
    List<AppointmentStatisticsDTO> stats = new ArrayList<>();
    String sql = "SELECT a.appointmentDate, COUNT(*) AS injectionCount, SUM(v.price) AS revenue " +
                 "FROM tblAppointments a " +
                 "JOIN tblVaccines v ON a.vaccineID = v.vaccineID " +
                 "WHERE YEAR(a.appointmentDate) = ? " +
                 "AND a.status NOT IN ('not_pending', 'Canceled') " +
                 "GROUP BY a.appointmentDate " +
                 "ORDER BY a.appointmentDate";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, year);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.add(new AppointmentStatisticsDTO(
                        rs.getDate("appointmentDate"),
                        rs.getInt("injectionCount"),
                        rs.getDouble("revenue")
                ));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return stats;
}



    // 2. Lấy tổng số mũi tiêm theo ngày cụ thể
    public int getTotalInjectionsByDate(String date) {
    int count = 0;
    String sql = "SELECT COUNT(*) AS totalInjections " +
                 "FROM tblAppointments " +
                 "WHERE appointmentDate = ? " +
                 "AND status NOT IN ('not_pending', 'Canceled')";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, date);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt("totalInjections");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return count;
}


    // 3. Lấy tổng doanh thu theo ngày cụ thể
    public double getRevenueByDate(String date) {
    double revenue = 0.0;
    String sql = "SELECT SUM(v.price) AS totalRevenue " +
                 "FROM tblAppointments a " +
                 "JOIN tblVaccines v ON a.vaccineID = v.vaccineID " +
                 "WHERE a.appointmentDate = ? " +
                 "AND a.status NOT IN ('not_pending', 'Canceled')";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, date);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                revenue = rs.getDouble("totalRevenue");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return revenue;
}



}
