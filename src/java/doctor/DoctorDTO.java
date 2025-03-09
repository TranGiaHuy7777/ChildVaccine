/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package doctor;

/**
 *
 * @author Admin
 */
public class DoctorDTO {
    private String doctorID;
    private String doctorName;
    private String password;
    private String roleID;
    private String email;
    private String address;
    private String phone;
    private boolean status;
    
    // Constructor
    public DoctorDTO() {
    }
    
    public DoctorDTO(String doctorID, String doctorName, String password, 
                     String roleID, String email, String address, 
                     String phone, boolean status) {
        this.doctorID = doctorID;
        this.doctorName = doctorName;
        this.password = password;
        this.roleID = roleID;
        this.email = email;
        this.address = address;
        this.phone = phone;
        this.status = status;
    }

    public String getDoctorID() {
        return doctorID;
    }

    public void setDoctorID(String doctorID) {
        this.doctorID = doctorID;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
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
