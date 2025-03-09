package vaccine;


import java.sql.Connection;
import java.sql.PreparedStatement;
import utils.DBUtils;

public class NotificationDAO {
    private static final String INSERT_NOTIFICATION = 
            "INSERT INTO tblNotifications (userID, notificationText) VALUES (?, ?)";
    
    public boolean insertNotification(String userID, String message) {
        boolean result = false;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_NOTIFICATION)) {
            ps.setString(1, userID);
            ps.setString(2, message);
            result = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}

