package feedback;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class FeedbackDAO {

    // Save new feedback to the database
    public boolean saveFeedback(FeedbackDTO feedback) throws ClassNotFoundException {
        String sql = "INSERT INTO tblFeedback (userID, centerID, feedbackText, rating, feedbackDate) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, feedback.getUserID());
            stmt.setInt(2, feedback.getCenterID());
            stmt.setString(3, feedback.getFeedbackText());
            stmt.setInt(4, feedback.getRating());
            stmt.setDate(5, Date.valueOf(feedback.getFeedbackDate())); // Chuyển LocalDate thành java.sql.Date

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0; // Nếu có ít nhất một dòng được chèn, trả về true
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Retrieve feedback history for a specific user
    public List<FeedbackDTO> getFeedbackByUserId(String userID) throws ClassNotFoundException {
        List<FeedbackDTO> feedbackList = new ArrayList<>();
        String sql = "SELECT feedbackID, centerID, feedbackText, rating, feedbackDate FROM tblFeedback WHERE userID = ? ORDER BY feedbackDate DESC";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userID); // userID là NVARCHAR trong SQL
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int feedbackID = rs.getInt("feedbackID");
                int centerID = rs.getInt("centerID");
                String feedbackText = rs.getString("feedbackText");
                int rating = rs.getInt("rating");
                LocalDate feedbackDate = rs.getDate("feedbackDate").toLocalDate(); // Chuyển java.sql.Date -> LocalDate

                FeedbackDTO feedback = new FeedbackDTO(feedbackID, userID, centerID, feedbackText, rating, feedbackDate);
                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public boolean deleteFeedback(int feedbackID, String userID) throws ClassNotFoundException {
        String sql = "DELETE FROM tblFeedback WHERE feedbackID = ? AND userID = ?";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedbackID);
            stmt.setString(2, userID);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0; // Nếu xóa thành công, trả về true
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
