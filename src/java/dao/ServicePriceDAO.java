package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.math.BigDecimal;
import model.Service;
import util.DBContext;

public class ServicePriceDAO {

    private static final String GET_SERVICE_WITH_FIXED_PRICE = "SELECT service_id, service_name, description, status, category, image FROM Services WHERE service_id = ? AND status = 'active'";
    private static final String GET_ALL_SERVICES_WITH_FIXED_PRICE = "SELECT service_id, service_name, description, status, category, image FROM Services WHERE status = 'active' ORDER BY service_name";

    /**
     * Lấy dịch vụ theo ID với giá cố định 50,000 VNĐ
     */
    public static Service getServiceWithFixedPrice(int serviceId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Service service = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_SERVICE_WITH_FIXED_PRICE);
                ps.setInt(1, serviceId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    service = mapResultSetToServiceWithFixedPrice(rs);
                    System.out.println("✅ Lấy dịch vụ với giá cố định: " + service.getServiceName() + " - 50,000 VNĐ");
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy dịch vụ với giá cố định: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return service;
    }

    /**
     * Lấy tất cả dịch vụ với giá cố định 50,000 VNĐ
     */
    public static java.util.List<Service> getAllServicesWithFixedPrice() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        java.util.List<Service> services = new java.util.ArrayList<>();
        try {
            System.out.println("🔍 Bắt đầu lấy danh sách dịch vụ...");
            conn = DBContext.getConnection();
            if (conn != null) {
                System.out.println("✅ Kết nối database thành công");
                ps = conn.prepareStatement(GET_ALL_SERVICES_WITH_FIXED_PRICE);
                System.out.println("🔍 Thực thi query: " + GET_ALL_SERVICES_WITH_FIXED_PRICE);
                rs = ps.executeQuery();
                int count = 0;
                while (rs.next()) {
                    Service service = mapResultSetToServiceWithFixedPrice(rs);
                    services.add(service);
                    count++;
                    System.out.println("📋 Dịch vụ " + count + ": " + service.getServiceName() + " - 50,000 VNĐ");
                }
                System.out.println("✅ Đã tải " + services.size() + " dịch vụ với giá cố định 50,000 VNĐ");
            } else {
                System.err.println("❌ Không thể kết nối database");
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy danh sách dịch vụ với giá cố định: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return services;
    }

    /**
     * Map ResultSet sang Service object với giá cố định 50,000 VNĐ
     */
    private static Service mapResultSetToServiceWithFixedPrice(ResultSet rs) throws SQLException {
        if (rs == null || rs.isClosed()) {
            throw new SQLException("ResultSet is null or closed");
        }

        try {
            Service service = new Service();
            service.setServiceId(rs.getInt("service_id"));
            service.setServiceName(rs.getString("service_name"));
            service.setDescription(rs.getString("description"));
            service.setPrice(50000.0); // Giá cố định 50,000 VNĐ
            service.setStatus(rs.getString("status"));
            service.setCategory(rs.getString("category"));
            try {
                if (rs.findColumn("specialty_id") > 0) {
                    int sid = rs.getInt("specialty_id");
                    service.setSpecialtyId(rs.wasNull() ? 0 : sid);
                }
            } catch (SQLException e) {
                /* column may not exist */ }
            service.setImage(rs.getString("image"));
            return service;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi mapping ResultSet to Service: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Lấy giá cố định 50,000 VNĐ cho bất kỳ serviceId nào
     */
    public static double getFixedPrice(int serviceId) {
        return 50000.0;
    }

    /**
     * Lấy giá cố định 50,000 VNĐ dưới dạng BigDecimal
     */
    public static BigDecimal getFixedPriceAsBigDecimal(int serviceId) {
        return new BigDecimal("50000");
    }

    /**
     * Kiểm tra dịch vụ có tồn tại và active không
     */
    public static boolean isServiceActive(int serviceId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean isActive = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                String sql = "SELECT COUNT(*) FROM Services WHERE service_id = ? AND status = 'active'";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, serviceId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    isActive = rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kiểm tra dịch vụ active: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return isActive;
    }

    /**
     * Lấy thông tin dịch vụ cơ bản (không có giá) để hiển thị
     */
    public static Service getServiceInfoOnly(int serviceId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Service service = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                String sql = "SELECT service_id, service_name, description, category, image FROM Services WHERE service_id = ? AND status = 'active'";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, serviceId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    service = new Service();
                    service.setServiceId(rs.getInt("service_id"));
                    service.setServiceName(rs.getString("service_name"));
                    service.setDescription(rs.getString("description"));
                    service.setCategory(rs.getString("category"));
                    service.setImage(rs.getString("image"));
                    service.setStatus("active");
                    // Không set price - sẽ dùng giá cố định khi cần
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy thông tin dịch vụ: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return service;
    }

    /**
     * Test method để kiểm tra DAO
     */
    public static void main(String[] args) {
        ServicePriceDAO dao = new ServicePriceDAO();

        System.out.println("=== Test ServicePriceDAO ===");

        // Test lấy dịch vụ với giá cố định
        Service service = dao.getServiceWithFixedPrice(1);
        if (service != null) {
            System.out.println("✅ Dịch vụ: " + service.getServiceName() + " - Giá: " + service.getPrice() + " VNĐ");
        } else {
            System.out.println("❌ Không tìm thấy dịch vụ ID 1");
        }

        // Test lấy tất cả dịch vụ
        java.util.List<Service> services = dao.getAllServicesWithFixedPrice();
        System.out.println("📋 Tổng số dịch vụ: " + services.size());
        for (Service s : services) {
            System.out.println("   - " + s.getServiceName() + ": " + s.getPrice() + " VNĐ");
        }

        // Test giá cố định
        System.out.println("💰 Giá cố định cho service 1: " + getFixedPrice(1) + " VNĐ");
        System.out.println("💰 Giá cố định cho service 999: " + getFixedPrice(999) + " VNĐ");
    }
}