package appointment;

import java.util.Date;

public class AppointmentStatisticsDTO {
    private Date appointmentDate;
    private int injectionCount;
    private double revenue;

    public AppointmentStatisticsDTO(Date appointmentDate, int injectionCount, double revenue) {
        this.appointmentDate = appointmentDate;
        this.injectionCount = injectionCount;
        this.revenue = revenue;
    }

    // Getters và Setters
    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

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
