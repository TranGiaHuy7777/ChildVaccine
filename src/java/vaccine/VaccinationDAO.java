/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vaccine;

/**
 *
 * @author Admin
 */
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class VaccinationDAO {

    private static final String GET_ALL_SCHEDULES = "SELECT a.appointmentID, a.childID, c.childName, "
            + "a.centerID, ct.centerName, a.appointmentDate, a.serviceType, a.notificationStatus, a.status "
            + "FROM tblAppointments a "
            + "JOIN tblChildren c ON a.childID = c.childID "
            + "JOIN tblCenters ct ON a.centerID = ct.centerID "
            + "ORDER BY a.appointmentDate, a.appointmentID";

    private static final String UPDATE_SCHEDULE_STATUS = "UPDATE tblAppointments "
            + "SET status = ? WHERE appointmentID = ?";

    public List<VaccinationScheduleDTO> getAllSchedules() throws SQLException {
        List<VaccinationScheduleDTO> scheduleList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(GET_ALL_SCHEDULES);
                rs = ptm.executeQuery();

                while (rs.next()) {
                    String scheduleID = rs.getString("appointmentID");
                    String childID = rs.getString("childID");
                    String childName = rs.getString("childName");
                    String centerID = rs.getString("centerID");
                    String centerName = rs.getString("centerName");
                    java.sql.Date appointmentDate = rs.getDate("appointmentDate");
                    String serviceType = rs.getString("serviceType");
                    String notificationStatus = rs.getString("notificationStatus");
                    String status = rs.getString("status");

                    VaccinationScheduleDTO schedule = new VaccinationScheduleDTO(
                            scheduleID, childID, childName, centerID, centerName,
                            appointmentDate, serviceType, notificationStatus, status);
                    scheduleList.add(schedule);
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
        return scheduleList;
    }

    public boolean updateScheduleStatus(String scheduleID, String status) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(UPDATE_SCHEDULE_STATUS);
                ptm.setString(1, status);
                ptm.setString(2, scheduleID);

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
