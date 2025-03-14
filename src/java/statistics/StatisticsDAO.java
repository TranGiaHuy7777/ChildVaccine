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
                 "WHERE YEAR(appointmentDate) = ? " +
                 "AND status NOT IN ('not_pending', 'Canceled') ";
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


    // Lấy doanh thu theo tháng, tính dựa trên giá của vaccine, loại trừ các lịch hẹn có trạng thái 'not_pending' và 'Canceled'
    public Map<Integer, Double> getRevenueByMonth(int year, int quarter) {
    Map<Integer, Double> result = new HashMap<>();
    String sql = "SELECT MONTH(a.appointmentDate) AS month, SUM(v.price * 1.0)/1000000 AS total " +
                 "FROM tblAppointments a " +
                 "JOIN tblVaccines v ON a.vaccineID = v.vaccineID " +
                 "WHERE YEAR(a.appointmentDate) = ? " +
                 "AND a.status NOT IN ('not_pending', 'Canceled') ";
    if (quarter != 0) {
        sql += "AND MONTH(a.appointmentDate) BETWEEN ? AND ? ";
    }
    sql += "GROUP BY MONTH(a.appointmentDate) ORDER BY month";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement stm = conn.prepareStatement(sql)) {
        int index = 1;
        stm.setInt(index++, year);
        if (quarter != 0) {
            stm.setInt(index++, (quarter - 1) * 3 + 1);
            stm.setInt(index++, quarter * 3);
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



    // Đếm số người dùng mới (không sử dụng điều kiện năm/quý vì không có cột createdDate)
    public int getTotalNewUsers(int year, int quarter) {
        int total = 0;
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

    // Lấy danh sách thống kê chi tiết (ví dụ: chỉ lấy appointmentDate và doanh thu)
    public java.util.List getDetailedStatistics(int year, int quarter, int offset, int pageSize) {
        java.util.List list = new ArrayList<>();
        // Ví dụ: lấy appointmentDate và doanh thu, tính dựa trên giá của vaccine, loại trừ các lịch hẹn không hợp lệ
        String sql = "SELECT a.appointmentDate, SUM(v.price) AS revenue " +
                     "FROM tblAppointments a " +
                     "JOIN tblVaccines v ON a.vaccineID = v.vaccineID " +
                     "WHERE YEAR(a.appointmentDate) = ? " +
                     "AND a.status NOT IN ('not_pending', 'Canceled') ";
        if (quarter != 0) {
            sql += "AND MONTH(a.appointmentDate) BETWEEN ? AND ? ";
        }
        sql += "GROUP BY a.appointmentDate ORDER BY a.appointmentDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
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
                    String detail = rs.getString("appointmentDate") + " - " + rs.getDouble("revenue");
                    list.add(detail);
                }
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }
}
