/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package staff;

/**
 *
 * @author Admin
 */
public class StaffDTO {
    private String staffID;
    private String password;
    private String staffName;
    private String roleID;
    private String email;
    private String address;
    private String phone;
    private boolean status;
    private String transactionCode;
    private String childName; 

    public StaffDTO(String staffID, String password, String staffName, String roleID, String email, String address, String phone, boolean status) {
        this.staffID = staffID;
        this.password = password;
        this.staffName = staffName;
        this.roleID = roleID;
        this.email = email;
        this.address = address;
        this.phone = phone;
        this.status = status;
    }

    public StaffDTO(String transactionCode, String childName) {
        this.transactionCode = transactionCode;
        this.childName = childName;
    }

    
    

    public String getStaffID() {
        return staffID;
    }

    public void setStaffID(String staffID) {
        this.staffID = staffID;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getRoleID() {
        return roleID;
    }

    public void setRoleID(String roleID) {
        this.roleID = roleID;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
    
}
