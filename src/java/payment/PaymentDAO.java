package payment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class PaymentDAO {

    public boolean createPayment(PaymentDTO payment) throws SQLException {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ptm = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "INSERT INTO tblPayments ( appointmentID, amount, paymentDate, status, paymentMethod, transactionCode) "
                        + "VALUES (?, ?, GETDATE(), ?, ?, ?)";

                ptm = conn.prepareStatement(sql);
                ptm.setInt(1, payment.getAppointmentID());
                ptm.setDouble(2, payment.getAmount());
                ptm.setString(3, "Paid"); // Initial status
                ptm.setString(4, payment.getPaymentMethod());
                ptm.setString(5, payment.getTransactionCode());
                System.out.println("Executing payment insert with values: "
                        + "appointmentID=" + payment.getAppointmentID()
                        + ", amount=" + payment.getAmount()
                        + ", method=" + payment.getPaymentMethod()
                        + ", transaction=" + payment.getTransactionCode());

                success = ptm.executeUpdate() > 0;
                int rowsAffected = ptm.executeUpdate();
                success = rowsAffected > 0;

                if (success) {
                    System.out.println("Payment saved successfully: " + payment.getTransactionCode());
                } else {
                    System.out.println("Failed to save payment");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Error creating payment: " + e.getMessage());
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

    public List<PaymentDTO> getAllPayments() throws SQLException {
        List<PaymentDTO> payments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT p.*, a.childID, c.childName as childName "
                        + "FROM tblPayments p "
                        + "JOIN tblAppointments a ON p.appointmentID = a.appointmentID "
                        + "JOIN tblChildren c ON a.childID = c.childID "
                        + "ORDER BY p.paymentDate DESC";

                System.out.println("Executing SQL: " + sql); // For debugging

                ptm = conn.prepareStatement(sql);
                rs = ptm.executeQuery();

                while (rs.next()) {
                    PaymentDTO payment = new PaymentDTO();
                    payment.setPaymentID(rs.getInt("paymentID"));
                    payment.setAppointmentID(rs.getInt("appointmentID"));
                    payment.setAmount(rs.getDouble("amount"));
                    payment.setPaymentDate(rs.getDate("paymentDate"));
                    payment.setStatus(rs.getString("status"));
                    payment.setPaymentMethod(rs.getString("paymentMethod"));
                    payment.setTransactionCode(rs.getString("transactionCode"));
                    payment.setChildName(rs.getString("childName"));
                    payments.add(payment);

                    // Debug log
                    System.out.println("Loaded payment: ID=" + payment.getPaymentID()
                            + ", Status=" + payment.getStatus()
                            + ", Child=" + payment.getChildName());
                }
            }
        } catch (Exception e) {
            System.out.println("Error in getAllPayments: " + e.getMessage());
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
        return payments;
    }

    public boolean updatePaymentStatus(int paymentID, String status) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        boolean success = false;

        try {
            conn = DBUtils.getConnection();
            String sql = "UPDATE tblPayments SET status = ? WHERE paymentID = ?";
            ptm = conn.prepareStatement(sql);
            ptm.setString(1, status);
            ptm.setInt(2, paymentID);

            success = ptm.executeUpdate() > 0;
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
        return success;
    }

    public PaymentDTO getPaymentByID(int paymentID) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        PaymentDTO payment = null;

        try {
            conn = DBUtils.getConnection();
            String sql = "SELECT p.*, c.childName as childName FROM Payments p "
                    + "JOIN Appointments a ON p.appointmentID = a.appointmentID "
                    + "JOIN Children c ON a.childID = c.childID "
                    + "WHERE p.paymentID = ?";
            ptm = conn.prepareStatement(sql);
            ptm.setInt(1, paymentID);
            rs = ptm.executeQuery();

            if (rs.next()) {
                payment = new PaymentDTO();
                payment.setPaymentID(rs.getInt("paymentID"));
                payment.setAppointmentID(rs.getInt("appointmentID"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentDate(rs.getDate("paymentDate"));
                payment.setStatus(rs.getString("status"));
                payment.setPaymentMethod(rs.getString("paymentMethod"));
                payment.setChildName(rs.getString("childName"));
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
        return payment;
    }
}
