package staff;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;
import payment.PaymentDTO;
import staff.StaffDTO;

public class StaffDAO {

    public StaffDTO checkLogin(String staffID, String password) throws SQLException, ClassNotFoundException {
        StaffDTO staff = null;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT staffID, staffName, email, phone, roleID, address, status FROM tblStaff WHERE staffID=? AND password=?";
                ptm = conn.prepareStatement(sql);
                ptm.setString(1, staffID);
                ptm.setString(2, password);
                rs = ptm.executeQuery();

                if (rs.next()) {
                    staff = new StaffDTO(
                            rs.getString("staffID"),
                            "", // không trả về password vì lý do bảo mật
                            rs.getString("staffName"),
                            rs.getString("roleID"),
                            rs.getString("email"),
                            rs.getString("address"),
                            rs.getString("phone"),
                            rs.getBoolean("status")
                    );
                }
            }
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
        return staff;
    }

    public boolean updatePaymentStatus(int paymentID, String status) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ptm = null;
        boolean success = false;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                // First check if payment exists and can be updated
                String checkSql = "SELECT status FROM tblPayment WHERE paymentID = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                    checkStmt.setInt(1, paymentID);
                    ResultSet rs = checkStmt.executeQuery();

                    if (!rs.next()) {
                        return false; // Payment not found
                    }

                    String currentStatus = rs.getString("status");
                    if ("Cancelled".equals(currentStatus) || "Confirmed".equals(currentStatus)) {
                        return false; // Cannot update final statuses
                    }
                }

                // Proceed with update
                String sql = "UPDATE tblPayment SET status = ?, updateDate = GETDATE() WHERE paymentID = ?";
                ptm = conn.prepareStatement(sql);
                ptm.setString(1, status);
                ptm.setInt(2, paymentID);
                success = ptm.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            throw new SQLException("Error updating payment status: " + e.getMessage());
        } finally {
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return success;
    }

    public List<PaymentDTO> getPaymentsByStatus(String status) throws SQLException, ClassNotFoundException {
        List<PaymentDTO> payments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT p.*, c.fullName as childName "
                        + "FROM tblPayment p "
                        + "JOIN tblAppointment a ON p.appointmentID = a.appointmentID "
                        + "JOIN tblChildren c ON a.childID = c.childID "
                        + "WHERE p.status = ? "
                        + "ORDER BY p.paymentDate DESC";

                ptm = conn.prepareStatement(sql);
                ptm.setString(1, status);
                rs = ptm.executeQuery();

                while (rs.next()) {
                    PaymentDTO payment = new PaymentDTO();
                    payment.setPaymentID(rs.getInt("paymentID"));
                    payment.setAppointmentID(rs.getInt("appointmentID"));
                    payment.setAmount(rs.getDouble("amount"));
                    payment.setPaymentDate(rs.getDate("paymentDate"));
                    payment.setStatus(rs.getString("status"));
                    payment.setChildName(rs.getString("childName"));
                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Error getting payments: " + e.getMessage());
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
        return payments;
    }
}
