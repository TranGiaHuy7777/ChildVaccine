/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vaccine;

/**
 *
 * @author Windows
 */
public class VaccineDTO {

    private int vaccineID;
    private String vaccineName;
    private String description;
    private double price;
    private String recommendedAge;
    private String status;

    public VaccineDTO() {
    }

    public VaccineDTO(int vaccineID, String vaccineName, String description, double price, String recommendedAge, String status) {
        this.vaccineID = vaccineID;
        this.vaccineName = vaccineName;
        this.description = description;
        this.price = price;
        this.recommendedAge = recommendedAge;
        this.status = status;
    }

    // Getters and Setters

    public int getVaccineID() {
        return vaccineID;
    }

    public void setVaccineID(int vaccineID) {
        this.vaccineID = vaccineID;
    }

    public String getVaccineName() {
        return vaccineName;
    }

    public void setVaccineName(String vaccineName) {
        this.vaccineName = vaccineName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getRecommendedAge() {
        return recommendedAge;
    }

    public void setRecommendedAge(String recommendedAge) {
        this.recommendedAge = recommendedAge;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
}
