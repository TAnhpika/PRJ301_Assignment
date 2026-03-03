package dao;

import java.sql.*;
import util.DBContext;
import model.Manager;

public class ManagerDAO {
    public static Connection getConnect() {
        return DBContext.getConnection();
    }

    public static Manager getManagerInfo(int userId) {
        // First try: Get full info from Managers table joined with users
        String sql = "SELECT m.*, u.email, u.created_at as user_created FROM Managers m JOIN users u ON m.user_id = u.user_id WHERE m.user_id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Manager(
                        rs.getInt("manager_id"),
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getDate("date_of_birth"),
                        rs.getString("gender"),
                        rs.getString("position"),
                        rs.getTimestamp("user_created"));
            }

            // Second try: If not in Managers table, get basic info from users table
            String sqlUser = "SELECT * FROM users WHERE user_id = ? AND role = 'MANAGER'";
            try (PreparedStatement ps2 = conn.prepareStatement(sqlUser)) {
                ps2.setInt(1, userId);
                try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) {
                        return new Manager(
                                -1, // Placeholder manager_id
                                rs2.getInt("user_id"),
                                rs2.getString("email"), // Backup: use email as full_name
                                "Chưa có", // phone
                                "Chưa có", // address
                                null, // dob
                                "Chưa có", // gender
                                "Quản lý", // position
                                rs2.getTimestamp("created_at"));
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting manager info: " + e);
        }
        return null;
    }

    public static int getUserId(int managerId) {
        String sql = "SELECT user_id FROM Managers WHERE manager_id = ?";
        try (Connection conn = getConnect();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            System.out.println("Error getting user id: " + e);
        }
        return -1;
    }

    public static boolean updateManagerProfile(Manager manager) {
        String checkSql = "SELECT 1 FROM Managers WHERE user_id = ?";
        String updateSql = "UPDATE Managers SET full_name = ?, phone = ?, address = ?, date_of_birth = ?, gender = ?, position = ? WHERE user_id = ?";
        String insertSql = "INSERT INTO Managers (user_id, full_name, phone, address, date_of_birth, gender, position) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection()) {
            boolean exists = false;
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setInt(1, manager.getUserId());
                try (ResultSet rs = checkPs.executeQuery()) {
                    exists = rs.next();
                }
            }

            if (exists) {
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setString(1, manager.getFullName());
                    updatePs.setString(2, manager.getPhone());
                    updatePs.setString(3, manager.getAddress());
                    if (manager.getDateOfBirth() != null) {
                        updatePs.setDate(4, new java.sql.Date(manager.getDateOfBirth().getTime()));
                    } else {
                        updatePs.setNull(4, java.sql.Types.DATE);
                    }
                    updatePs.setString(5, manager.getGender());
                    updatePs.setString(6, manager.getPosition());
                    updatePs.setInt(7, manager.getUserId());
                    int updated = updatePs.executeUpdate();
                    System.out.println("✅ Update result: " + updated + " rows affected");
                    return updated > 0;
                }
            } else {
                System.out.println(
                        "ℹ️ Manager not found in Managers table. Inserting for user_id: " + manager.getUserId());
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setInt(1, manager.getUserId());
                    insertPs.setString(2, manager.getFullName());
                    insertPs.setString(3, manager.getPhone());
                    insertPs.setString(4, manager.getAddress());
                    if (manager.getDateOfBirth() != null) {
                        insertPs.setDate(5, new java.sql.Date(manager.getDateOfBirth().getTime()));
                    } else {
                        insertPs.setNull(5, java.sql.Types.DATE);
                    }
                    insertPs.setString(6, manager.getGender());
                    insertPs.setString(7, manager.getPosition());
                    int inserted = insertPs.executeUpdate();
                    System.out.println("✅ Insert result: " + inserted + " rows affected");
                    return inserted > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error updating/inserting manager profile: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        Connection conn = getConnect();
        if (conn != null) {
            System.out.println("✅ Kết nối database thành công!");

            // Test lấy thông tin manager có userId = 1
            Manager manager = getManagerInfo(1);
            if (manager != null) {
                System.out.println("Thông tin manager:");
                System.out.println("Họ tên: " + manager.getFullName());
                System.out.println("Chức vụ: " + manager.getPosition());
            } else {
                System.out.println("❌ Không tìm thấy manager với userId = 1");
            }
        } else {
            System.out.println("❌ Kết nối database thất bại!");
        }
    }
}