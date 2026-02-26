package model;

/**
 * Model cho bảng Specialties - Chuyên khoa (dùng chung cho Bác sĩ và Dịch vụ).
 */
public class Specialty {
    private int specialtyId;
    private String specialtyName;
    private String description;

    public Specialty() {
    }

    public Specialty(int specialtyId, String specialtyName, String description) {
        this.specialtyId = specialtyId;
        this.specialtyName = specialtyName;
        this.description = description;
    }

    public int getSpecialtyId() {
        return specialtyId;
    }

    public void setSpecialtyId(int specialtyId) {
        this.specialtyId = specialtyId;
    }

    public String getSpecialtyName() {
        return specialtyName;
    }

    public void setSpecialtyName(String specialtyName) {
        this.specialtyName = specialtyName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
