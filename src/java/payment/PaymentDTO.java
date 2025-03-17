package payment;

import java.sql.Date;

public class PaymentDTO {
    private int paymentID;
    private int appointmentID;
    private double amount;
    private Date paymentDate;
    private String status;
    private String paymentMethod;
    private String transactionCode;
    private String childName; // For display purposes
    
    // Default constructor
    public PaymentDTO() {
    }
    
    // Constructor with parameters
    public PaymentDTO(int appointmentID, double amount, String paymentMethod, String transactionCode) {
        this.appointmentID = appointmentID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.transactionCode = transactionCode;
        this.status = "Paid"; // Default status
    }
    
    // Getters and Setters
    public int getPaymentID() { return paymentID; }
    public void setPaymentID(int paymentID) { this.paymentID = paymentID; }
    
    public int getAppointmentID() { return appointmentID; }
    public void setAppointmentID(int appointmentID) { this.appointmentID = appointmentID; }
    
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    
    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getTransactionCode() { return transactionCode; }
    public void setTransactionCode(String transactionCode) { this.transactionCode = transactionCode; }
    
    public String getChildName() { return childName; }
    public void setChildName(String childName) { this.childName = childName; }
}