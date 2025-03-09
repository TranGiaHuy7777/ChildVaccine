package statistics;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import utils.DBUtils;

public class StatisticsDAO {

    // Truy vấn theo năm và (tùy chọn) quý cho số mũi tiêm
    public Map<Integer, Integer> getInjectionCountByMonth(int year, int quarter) {
    Map<Integer, Integer> result = new HashMap<>();
    String sql = "SELECT MONTH(appointmentDate) AS month, COUNT(*) AS count " +
                 "FROM tblAppointments " +
                 "WHERE YEAR(appointmentDate) = ? ";
    if (quarter != 0) {
        sql += "AND MONTH(appointmentDate) BETWEEN ? AND ? ";
    }
    sql += "GROUP BY MONTH(appointmentDate) ORDER BY month";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement stm = conn.prepareStatement(sql)) {
        stm.setInt(1, year);
        if (quarter != 0) {
            stm.setInt(2, (quarter - 1) * 3 + 1);
            stm.setInt(3, quarter * 3);
        }
        try (ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                int month = rs.getInt("month");
                int count = rs.getInt("count");
                result.put(month, count);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return result;
}


    public Map<Integer, Double> getRevenueByMonth(int year, int quarter) {
        Map<Integer, Double> result = new HashMap<>();
        String sql = "SELECT MONTH(a.appointmentDate) AS month, SUM(s.price) AS total " +
                     "FROM tblAppointments a " +
                     "JOIN tblServiceAppointments sa ON a.appointmentID = sa.appointmentID " +
                     "JOIN tblServices s ON sa.serviceID = s.serviceID " +
                     "WHERE YEAR(a.appointmentDate) = ? ";
        if (quarter != 0) {
            int startMonth = (quarter - 1) * 3 + 1;
            int endMonth = quarter * 3;
            sql += "AND MONTH(a.appointmentDate) BETWEEN ? AND ? ";
        }
        sql += "GROUP BY MONTH(a.appointmentDate) ORDER BY month";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, year);
            if (quarter != 0) {
                stm.setInt(2, (quarter - 1) * 3 + 1);
                stm.setInt(3, quarter * 3);
            }
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    int month = rs.getInt("month");
                    double total = rs.getDouble("total");
                    result.put(month, total);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // Đếm số người dùng mới (có thể lọc theo năm và quý nếu có cột createdDate)
    public int getTotalNewUsers(int year, int quarter) {
    int total = 0;
    // Loại bỏ điều kiện năm/quý vì không có cột createdDate
    String sql = "SELECT COUNT(*) AS total FROM tblCustomers";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement stm = conn.prepareStatement(sql)) {
        try (ResultSet rs = stm.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return total;
}

    
    // Lấy danh sách thống kê chi tiết với phân trang (ví dụ: từ bảng tblAppointments)
    public java.util.List getDetailedStatistics(int year, int quarter, int offset, int pageSize) {
    java.util.List list = new ArrayList<>();
    String sql = "SELECT appointmentDate, " +
                 "(SELECT COUNT(*) FROM tblServiceAppointments WHERE appointmentID = a.appointmentID) AS injectionCount, " +
                 "(SELECT SUM(s.price) FROM tblServiceAppointments sa " +
                 " JOIN tblServices s ON sa.serviceID = s.serviceID " +
                 " WHERE sa.appointmentID = a.appointmentID) AS revenue " +
                 "FROM tblAppointments a " +
                 "WHERE YEAR(appointmentDate) = ? ";
    if (quarter != 0) {
        sql += "AND MONTH(appointmentDate) BETWEEN ? AND ? ";
    }
    sql += "ORDER BY appointmentDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement stm = conn.prepareStatement(sql)) {
        int index = 1;
        stm.setInt(index++, year);
        if (quarter != 0) {
            stm.setInt(index++, (quarter - 1) * 3 + 1);
            stm.setInt(index++, quarter * 3);
        }
        stm.setInt(index++, offset);
        stm.setInt(index++, pageSize);
        try (ResultSet rs = stm.executeQuery()) {
            while(rs.next()){
                // Ví dụ: tạo đối tượng StatisticDetail (nếu có) hoặc dùng chuỗi để minh họa
                String detail = rs.getString("appointmentDate") + " - " +
                                rs.getInt("injectionCount") + " - " +
                                rs.getDouble("revenue");
                list.add(detail);
            }
        }
    } catch(Exception e){
        e.printStackTrace();
    }
    return list;
}


    
    // Lấy tổng số bản ghi chi tiết để tính phân trang
    public int getTotalDetailedStats(int year, int quarter) {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM tblAppointments WHERE YEAR(appointmentDate) = ? ";
        if (quarter != 0) {
            sql += "AND MONTH(appointmentDate) BETWEEN ? AND ?";
        }
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, year);
            if (quarter != 0) {
                stm.setInt(2, (quarter - 1) * 3 + 1);
                stm.setInt(3, quarter * 3);
            }
            try (ResultSet rs = stm.executeQuery()) {
                if(rs.next()){
                    total = rs.getInt("total");
                }
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return total;
    }
}
