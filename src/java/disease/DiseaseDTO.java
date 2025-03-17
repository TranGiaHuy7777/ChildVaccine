package disease;

import java.io.Serializable;
import java.sql.Date;
import java.util.List;
import vaccine.VaccineDTO;

public class DiseaseDTO implements Serializable {
    private int diseaseID;
    private int childID;
    private int vaccineID;
    private int appointmentID;
    private String diseaseName;
    private String description;
    private Date diagnosisDate; // Sử dụng java.sql.Date để tương thích với SQL Date
    
    // Danh sách các vaccine liên quan (nếu cần)
    private List<VaccineDTO> vaccineList;

    public DiseaseDTO() {
    }

    public DiseaseDTO(int diseaseID, String diseaseName, String description) {
        this.diseaseID = diseaseID;
        this.diseaseName = diseaseName;
        this.description = description;
    }

    // Constructor đầy đủ (nếu cần)
    public DiseaseDTO(int diseaseID, int childID, int vaccineID, int appointmentID, String diseaseName, String description, Date diagnosisDate) {
        this.diseaseID = diseaseID;
        this.childID = childID;
        this.vaccineID = vaccineID;
        this.appointmentID = appointmentID;
        this.diseaseName = diseaseName;
        this.description = description;
        this.diagnosisDate = diagnosisDate;
    }

    public int getDiseaseID() {
        return diseaseID;
    }

    public void setDiseaseID(int diseaseID) {
        this.diseaseID = diseaseID;
    }

    public int getChildID() {
        return childID;
    }

    public void setChildID(int childID) {
        this.childID = childID;
    }

    public int getVaccineID() {
        return vaccineID;
    }

    public void setVaccineID(int vaccineID) {
        this.vaccineID = vaccineID;
    }

    public int getAppointmentID() {
        return appointmentID;
    }

    public void setAppointmentID(int appointmentID) {
        this.appointmentID = appointmentID;
    }

    public String getDiseaseName() {
        return diseaseName;
    }

    public void setDiseaseName(String diseaseName) {
        this.diseaseName = diseaseName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDiagnosisDate() {
        return diagnosisDate;
    }

    public void setDiagnosisDate(Date diagnosisDate) {
        this.diagnosisDate = diagnosisDate;
    }

    public List<VaccineDTO> getVaccineList() {
        return vaccineList;
    }

    public void setVaccineList(List<VaccineDTO> vaccineList) {
        this.vaccineList = vaccineList;
    }
}
