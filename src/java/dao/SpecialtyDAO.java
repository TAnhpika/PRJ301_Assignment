package dao;

import model.Specialty;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBContext;

/**
 * DAO cho bảng Specialties - Chuyên khoa (dùng cho Bác sĩ và Dịch vụ).
 */
public class SpecialtyDAO {

    private static final String GET_ALL = "SELECT specialty_id, specialty_name, description FROM Specialties ORDER BY specialty_name";
    private static final String GET_BY_ID = "SELECT specialty_id, specialty_name, description FROM Specialties WHERE specialty_id = ?";

    /**
     * Lấy chuyên khoa theo ID.
     */
    public static Specialty getById(int specialtyId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_BY_ID)) {
            ps.setInt(1, specialtyId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SpecialtyDAO.getById: " + e.getMessage());
            return null;
        }
    }

    /**
     * Lấy tất cả chuyên khoa.
     */
    public static List<Specialty> getAllSpecialties() {
        List<Specialty> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SpecialtyDAO.getAllSpecialties: " + e.getMessage());
        }
        return list;
    }

    private static Specialty mapRow(ResultSet rs) throws SQLException {
        Specialty s = new Specialty();
        s.setSpecialtyId(rs.getInt("specialty_id"));
        s.setSpecialtyName(rs.getString("specialty_name"));
        s.setDescription(rs.getString("description"));
        return s;
    }
}
