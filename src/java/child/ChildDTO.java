package child;

import java.sql.Date;

public class ChildDTO {
    private int childID;         // Khóa chính (IDENTITY)
    private String userID;       // Khóa ngoại tham chiếu đến tblCustomers
    private String childName;    // Tên trẻ
    private Date dateOfBirth;    // Ngày sinh
    private String gender;       // Giới tính

    // Constructor không tham số
    public ChildDTO() {
    }

    // Constructor có tham số
    public ChildDTO(int childID, String userID, String childName, Date dateOfBirth, String gender) {
        this.childID = childID;
        this.userID = userID;
        this.childName = childName;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
    }

    // Getter và Setter
    public int getChildID() {
        return childID;
    }

    public void setChildID(int childID) {
        this.childID = childID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getChildName() {
        return childName;
    }

    public void setChildName(String childName) {
        this.childName = childName;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }
}
