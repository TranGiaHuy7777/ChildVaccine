package appointment;

import java.util.Date;

public class AppointmentDTO {

    private int appointmentID;
    private int childID;
    private int centerID;
    private Date appointmentDate;
    private String serviceType;
    private String notificationStatus;
    private String status;
    
    // Thông tin trẻ
    private String childName;
    private Date dateOfBirth;
    private String gender;
    
    // Thêm các trường cho thống kê chi tiết
    private int injectionCount;
    private double revenue;

    public AppointmentDTO() {
    }

    public AppointmentDTO(int appointmentID, int childID, int centerID, Date appointmentDate, String serviceType, String notificationStatus, String status) {
        this.appointmentID = appointmentID;
        this.childID = childID;
        this.centerID = centerID;
        this.appointmentDate = appointmentDate;
        this.serviceType = serviceType;
        this.notificationStatus = notificationStatus;
        this.status = status;
    }
    
    public AppointmentDTO(int appointmentID, int childID, int centerID, Date appointmentDate,
                      String serviceType, String notificationStatus, String status,
                      String childName, Date dateOfBirth, String gender) {
        this(appointmentID, childID, centerID, appointmentDate, serviceType, notificationStatus, status);
        this.childName = childName;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
    }

    // Getters and Setters cho các thuộc tính cũ
    public int getAppointmentID() {
        return appointmentID;
    }

    public void setAppointmentID(int appointmentID) {
        this.appointmentID = appointmentID;
    }

    public int getChildID() {
        return childID;
    }

    public void setChildID(int childID) {
        this.childID = childID;
    }

    public int getCenterID() {
        return centerID;
    }

    public void setCenterID(int centerID) {
        this.centerID = centerID;
    }

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public String getNotificationStatus() {
        return notificationStatus;
    }

    public void setNotificationStatus(String notificationStatus) {
        this.notificationStatus = notificationStatus;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Getters và Setters cho thông tin trẻ
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
    
    // --- Các phương thức mới cho thống kê chi tiết ---
    public int getInjectionCount() {
        return injectionCount;
    }
    public void setInjectionCount(int injectionCount) {
        this.injectionCount = injectionCount;
    }
    public double getRevenue() {
        return revenue;
    }
    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }
}
