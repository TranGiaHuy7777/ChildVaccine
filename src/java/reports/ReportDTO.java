/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reports;

import java.util.Date;

/**
 *
 * @author Windows
 */
public class ReportDTO {
    private int reportID;
    private int centerID;
    private Date reportDate;
    private int totalAppointments;
    private double totalRevenue;

    public ReportDTO() {
    }

    public ReportDTO(int reportID, int centerID, Date reportDate, int totalAppointments, double totalRevenue) {
        this.reportID = reportID;
        this.centerID = centerID;
        this.reportDate = reportDate;
        this.totalAppointments = totalAppointments;
        this.totalRevenue = totalRevenue;
    }

    // Getters and Setters
    public int getReportID() {
        return reportID;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public int getCenterID() {
        return centerID;
    }

    public void setCenterID(int centerID) {
        this.centerID = centerID;
    }

    public Date getReportDate() {
        return reportDate;
    }

    public void setReportDate(Date reportDate) {
        this.reportDate = reportDate;
    }

    public int getTotalAppointments() {
        return totalAppointments;
    }

    public void setTotalAppointments(int totalAppointments) {
        this.totalAppointments = totalAppointments;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}
