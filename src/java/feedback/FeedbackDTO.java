package feedback;

import java.sql.Date;
import java.time.LocalDate;

public class FeedbackDTO {

    private int feedbackID;
    private String userID;
    private int centerID;
    private String feedbackText;
    private int rating;
    private LocalDate feedbackDate;

    public FeedbackDTO() {
    }

    public FeedbackDTO(int feedbackID, String userID, int centerID, String feedbackText, int rating, LocalDate feedbackDate) {
        this.feedbackID = feedbackID;
        this.userID = userID;
        this.centerID = centerID;
        this.feedbackText = feedbackText;
        this.rating = rating;
        this.feedbackDate = feedbackDate;
    }

    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public int getCenterID() {
        return centerID;
    }

    public void setCenterID(int centerID) {
        this.centerID = centerID;
    }

    public String getFeedbackText() {
        return feedbackText;
    }

    public void setFeedbackText(String feedbackText) {
        this.feedbackText = feedbackText;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        if (rating >= 1 && rating <= 5) {
            this.rating = rating;
        } else {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
    }

    public LocalDate getFeedbackDate() {
        return feedbackDate;
    }

    public void setFeedbackDate(LocalDate feedbackDate) {
        this.feedbackDate = feedbackDate;
    }
}
