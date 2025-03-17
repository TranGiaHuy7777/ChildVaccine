package report;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import reports.ReportDTO;
import utils.DBUtils;

public class ReportDAO {

    public static List<ReportDTO> getAllReports() throws Exception {
        List<ReportDTO> reports = new ArrayList<>();
        String sql = "SELECT * FROM tblReports";

        try (Connection con = DBUtils.getConnection();
                PreparedStatement stm = con.prepareStatement(sql);
                ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                reports.add(new ReportDTO(
                        rs.getInt("reportID"),
                        rs.getInt("centerID"),
                        rs.getDate("reportDate"),
                        rs.getInt("totalAppointments"),
                        rs.getDouble("totalRevenue")
                ));
            }
        }
        return reports;
    }

    public static List<ReportDTO> getReportsByCenter(int centerID, String reportDate) throws Exception {
        List<ReportDTO> reports = new ArrayList<>();
        String sql = "SELECT * FROM tblReports WHERE centerID = ?";

        if (reportDate != null && !reportDate.isEmpty()) {
            sql += " AND reportDate = ?";
        }

        try (Connection con = DBUtils.getConnection();
                PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setInt(1, centerID);
            if (reportDate != null && !reportDate.isEmpty()) {
                stm.setString(2, reportDate);
            }

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                reports.add(new ReportDTO(
                        rs.getInt("reportID"),
                        rs.getInt("centerID"),
                        rs.getDate("reportDate"),
                        rs.getInt("totalAppointments"),
                        rs.getDouble("totalRevenue")
                ));
            }
        }
        return reports;
    }
}
