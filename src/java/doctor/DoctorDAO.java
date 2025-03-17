/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package doctor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import utils.DBUtils;

/**
 *
 * @author Admin
 */
public class DoctorDAO {
    private static final String LOGIN = "SELECT doctorName, roleID FROM tblDoctor WHERE doctorID=? AND password=? AND status=1";
    
    public DoctorDTO checkLogin(String doctorID, String password) throws SQLException {
        DoctorDTO doctor = null;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(LOGIN);
                ptm.setString(1, doctorID);
                ptm.setString(2, password);
                rs = ptm.executeQuery();
                if (rs.next()) {
                    String doctorName = rs.getString("doctorName");
                    String roleID = rs.getString("roleID");
                    doctor = new DoctorDTO(doctorID, doctorName, "", roleID, "", "", "", true);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return doctor;
    }
}