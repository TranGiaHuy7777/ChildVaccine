package vaccine;

import java.sql.Date;

public class VaccinationScheduleDTO {
    private String scheduleID;
    private String childID;
    private String childName;
    private String centerID;
    private String centerName;
    private Date appointmentDate;
    private String serviceType;
    private String notificationStatus;
    private String status;

    // Constructor
    public VaccinationScheduleDTO(String scheduleID, String childID, String childName, 
                                  String centerID, String centerName, Date appointmentDate, 
                                  String serviceType, String notificationStatus, String status) {
        this.scheduleID = scheduleID;
        this.childID = childID;
        this.childName = childName;
        this.centerID = centerID;
        this.centerName = centerName;
        this.appointmentDate = appointmentDate;
        this.serviceType = serviceType;
        this.notificationStatus = notificationStatus;
        this.status = status;
    }

    // Getters and setters...
    public String getScheduleID() { return scheduleID; }
    public void setScheduleID(String scheduleID) { this.scheduleID = scheduleID; }
    public String getChildID() { return childID; }
    public void setChildID(String childID) { this.childID = childID; }
    public String getChildName() { return childName; }
    public void setChildName(String childName) { this.childName = childName; }
    public String getCenterID() { return centerID; }
    public void setCenterID(String centerID) { this.centerID = centerID; }
    public String getCenterName() { return centerName; }
    public void setCenterName(String centerName) { this.centerName = centerName; }
    public Date getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }
    public String getServiceType() { return serviceType; }
    public void setServiceType(String serviceType) { this.serviceType = serviceType; }
    public String getNotificationStatus() { return notificationStatus; }
    public void setNotificationStatus(String notificationStatus) { this.notificationStatus = notificationStatus; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
