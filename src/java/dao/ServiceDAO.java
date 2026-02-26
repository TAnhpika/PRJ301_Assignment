package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Service;
import util.DBContext;

/**
 * DAO cho bảng Services
 * Quản lý CRUD operations cho dịch vụ y tế
 * @author: TranHongPhuoc
 */

public class ServiceDAO {
    
    private static final String GET_ALL_SERVICES = "SELECT * FROM Services WHERE status = 'active' ORDER BY service_name";
    private static final String GET_SERVICE_BY_ID = "SELECT * FROM Services WHERE service_id = ?";
    private static final String GET_SERVICE_BY_NAME = "SELECT * FROM Services WHERE service_name = ? AND status = 'active'";
    private static final String GET_SERVICES_BY_STATUS = "SELECT * FROM Services WHERE status = ? ORDER BY service_name";
    private static final String GET_SERVICES_BY_CATEGORY = "SELECT * FROM Services WHERE category = ? AND status = 'active' ORDER BY service_name";
    private static final String SEARCH_SERVICES_BY_NAME = "SELECT * FROM Services WHERE service_name LIKE ? AND status = 'active' ORDER BY service_name";
    private static final String INSERT_SERVICE = "INSERT INTO Services (service_name, description, price, status, category, specialty_id, image) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_SERVICE = "UPDATE Services SET service_name = ?, description = ?, price = ?, status = ?, category = ?, specialty_id = ?, image = ? WHERE service_id = ?";
    private static final String GET_SPECIALTY_ID_BY_NAME = "SELECT specialty_id FROM Specialties WHERE LTRIM(RTRIM(specialty_name)) = LTRIM(RTRIM(?))";
    private static final String DELETE_SERVICE = "UPDATE Services SET status = 'inactive' WHERE service_id = ?";
    private static final String GET_ALL_CATEGORIES = "SELECT DISTINCT category FROM Services WHERE status = 'active' ORDER BY category";


    /**
     * Lấy tất cả dịch vụ đang hoạt động
     */
    public static List<Service> getAllServices() {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Service> services = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_ALL_SERVICES);
                rs = ps.executeQuery();
                while (rs.next()) {
                    Service service = mapResultSetToService(rs);
                    services.add(service);
                }
                System.out.println("Loaded " + services.size() + " services from database");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách dịch vụ: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return services;
    }

    /**
     * Lấy dịch vụ theo ID
     */
    public static Service getServiceById(int serviceId) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        Service service = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_SERVICE_BY_ID);
                ps.setInt(1, serviceId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    service = mapResultSetToService(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy dịch vụ theo ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return service;
    }

    /**
     * Lấy dịch vụ theo tên
     * @param serviceName tên dịch vụ cần tìm
     * @return Service object nếu tìm thấy, null nếu không tìm thấy
     */
    public static Service getServiceByName(String serviceName) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        Service service = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_SERVICE_BY_NAME);
                ps.setString(1, serviceName);
                rs = ps.executeQuery();
                if (rs.next()) {
                    service = mapResultSetToService(rs);
                    System.out.println("Found service: " + service.getServiceName() + " (ID: " + service.getServiceId() + ")");
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy dịch vụ theo tên: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return service;
    }

    /**
     * Lấy dịch vụ theo trạng thái
     */
    public static List<Service> getServicesByStatus(String status) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Service> services = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_SERVICES_BY_STATUS);
                ps.setString(1, status);
                rs = ps.executeQuery();
                while (rs.next()) {
                    Service service = mapResultSetToService(rs);
                    services.add(service);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy dịch vụ theo trạng thái: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return services;
    }

    /**
     * Lấy dịch vụ theo danh mục
     */
    public static List<Service> getServicesByCategory(String category) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Service> services = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_SERVICES_BY_CATEGORY);
                ps.setString(1, category);
                rs = ps.executeQuery();
                while (rs.next()) {
                    Service service = mapResultSetToService(rs);
                    services.add(service);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy dịch vụ theo danh mục: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return services;
    }

    /**
     * Lấy dịch vụ đang hoạt động
     */
    public static List<Service> getActiveServices() {
        return getServicesByStatus("active");
    }

    /**
     * Tìm kiếm dịch vụ theo tên
     */
    public static List<Service> searchServicesByName(String searchTerm) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Service> services = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(SEARCH_SERVICES_BY_NAME);
                ps.setString(1, "%" + searchTerm + "%");
                rs = ps.executeQuery();
                while (rs.next()) {
                    Service service = mapResultSetToService(rs);
                    services.add(service);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm kiếm dịch vụ: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return services;
    }

    /**
     * Thêm dịch vụ mới
     */
    public static boolean insertService(Service service) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        boolean result = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(INSERT_SERVICE);
                ps.setString(1, service.getServiceName());
                ps.setString(2, service.getDescription());
                ps.setDouble(3, service.getPrice());
                ps.setString(4, service.getStatus());
                ps.setString(5, service.getCategory());
                int sid = service.getSpecialtyId() > 0 ? service.getSpecialtyId() : getSpecialtyIdByCategory(conn, service.getCategory());
                ps.setInt(6, sid > 0 ? sid : 1);
                ps.setString(7, service.getImage());
                
                int rowsAffected = ps.executeUpdate();
                result = rowsAffected > 0;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm dịch vụ: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return result;
    }

    /**
     * Cập nhật dịch vụ
     */
    public static boolean updateService(Service service) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        boolean result = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(UPDATE_SERVICE);
                ps.setString(1, service.getServiceName());
                ps.setString(2, service.getDescription());
                ps.setDouble(3, service.getPrice());
                ps.setString(4, service.getStatus());
                ps.setString(5, service.getCategory());
                int sid = service.getSpecialtyId() > 0 ? service.getSpecialtyId() : getSpecialtyIdByCategory(conn, service.getCategory());
                ps.setInt(6, sid > 0 ? sid : 1);
                ps.setString(7, service.getImage());
                ps.setInt(8, service.getServiceId());
                
                int rowsAffected = ps.executeUpdate();
                result = rowsAffected > 0;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật dịch vụ: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return result;
    }

    /**
     * Xóa dịch vụ (thực tế là set status = 'inactive')
     */
    public static boolean deleteService(int serviceId) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        boolean result = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(DELETE_SERVICE);
                ps.setInt(1, serviceId);
                
                int rowsAffected = ps.executeUpdate();
                result = rowsAffected > 0;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa dịch vụ: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return result;
    }

    /**
     * Lấy tất cả danh mục dịch vụ
     */
    public static List<String> getAllCategories() {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<String> categories = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_ALL_CATEGORIES);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String category = rs.getString("category");
                    if (category != null && !category.trim().isEmpty()) {
                        categories.add(category);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh mục: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return categories;
    }

    /**
     * Thêm dữ liệu mẫu nếu bảng trống
     */
    public static void addSampleDataIfEmpty() {
        try {
            // Kiểm tra xem có dữ liệu không
            List<Service> existingServices = getAllServices();
            if (existingServices.isEmpty()) {
                System.out.println("Bảng Services trống, thêm dữ liệu mẫu...");
                
                // Tạo dữ liệu mẫu
                Service[] sampleServices = {
                    new Service(0, "Khám tổng quát", "Khám sức khỏe tổng quát, đánh giá tình trạng sức khỏe", 200000, "active", "Khám bệnh", null),
                    new Service(0, "Nhổ răng", "Dịch vụ nhổ răng an toàn, không đau", 150000, "active", "Nha khoa", null),
                    new Service(0, "Trám răng", "Trám răng sâu, phục hồi chức năng nhai", 300000, "active", "Nha khoa", null),
                    new Service(0, "Tẩy trắng răng", "Làm trắng răng an toàn, hiệu quả", 500000, "active", "Thẩm mỹ", null),
                    new Service(0, "Khám tim mạch", "Khám chuyên khoa tim mạch, siêu âm tim", 400000, "active", "Chuyên khoa", null),
                    new Service(0, "Xét nghiệm máu", "Xét nghiệm máu tổng quát, sinh hóa", 250000, "active", "Xét nghiệm", null),
                    new Service(0, "Chụp X-quang", "Chụp X-quang các bộ phận theo yêu cầu", 180000, "active", "Chẩn đoán hình ảnh", null),
                    new Service(0, "Siêu âm tổng quát", "Siêu âm bụng, khám thai, tim...", 350000, "active", "Chẩn đoán hình ảnh", null)
                };
                
                for (Service service : sampleServices) {
                    insertService(service);
                }
                
                System.out.println("Đã thêm " + sampleServices.length + " dịch vụ mẫu");
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi thêm dữ liệu mẫu: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Lấy specialty_id từ bảng Specialties theo tên chuyên khoa (category).
     * Trả về 0 nếu không tìm thấy hoặc bảng Specialties chưa tồn tại.
     */
    private static int getSpecialtyIdByCategory(Connection conn, String category) {
        if (conn == null || category == null || category.trim().isEmpty()) return 0;
        PreparedStatement ps2 = null;
        ResultSet rs2 = null;
        try {
            ps2 = conn.prepareStatement(GET_SPECIALTY_ID_BY_NAME);
            ps2.setString(1, category.trim());
            rs2 = ps2.executeQuery();
            return rs2.next() ? rs2.getInt("specialty_id") : 0;
        } catch (SQLException e) {
            return 0;
        } finally {
            try {
                if (rs2 != null) rs2.close();
                if (ps2 != null) ps2.close();
            } catch (SQLException ignored) {}
        }
    }

    /**
     * Map ResultSet sang Service object
     */
    private static Service mapResultSetToService(ResultSet rs) throws SQLException {
        // Kiểm tra ResultSet trước khi access
        if (rs == null || rs.isClosed()) {
            throw new SQLException("ResultSet is null or closed");
        }
        
        try {
            Service service = new Service();
            service.setServiceId(rs.getInt("service_id"));
            service.setServiceName(rs.getString("service_name"));
            service.setDescription(rs.getString("description"));
            service.setPrice(rs.getDouble("price"));
            service.setStatus(rs.getString("status"));
            service.setCategory(rs.getString("category"));
            try {
                if (rs.findColumn("specialty_id") > 0) {
                    int sid = rs.getInt("specialty_id");
                    service.setSpecialtyId(rs.wasNull() ? 0 : sid);
                }
            } catch (SQLException e) { /* column may not exist */ }
            service.setImage(rs.getString("image"));
            return service;
        } catch (SQLException e) {
            System.err.println("Error mapping ResultSet to Service: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Lấy giá dịch vụ theo serviceId
     */
    public static java.math.BigDecimal getServicePriceById(int serviceId) {
        java.math.BigDecimal price = java.math.BigDecimal.ZERO;
        java.sql.Connection conn = null;
        java.sql.PreparedStatement ps = null;
        java.sql.ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            String sql = "SELECT price FROM Service WHERE service_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, serviceId);
            rs = ps.executeQuery();
            if (rs.next()) {
                price = rs.getBigDecimal("price");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(rs, ps, conn);
        }
        return price;
    }

    // Test main method
    public static void main(String[] args) {
        ResultSet rs = null;
        ServiceDAO dao = new ServiceDAO();
        
        // Thêm dữ liệu mẫu nếu cần
        dao.addSampleDataIfEmpty();
        
        // Test getAllServices
        System.out.println("=== Test getAllServices ===");
        List<Service> services = dao.getAllServices();
        for (Service service : services) {
            System.out.println(service.getServiceId() + " - " + service.getServiceName() + " - " + service.getPrice() + " VNĐ");
        }
        
        // Test getServiceById
        if (!services.isEmpty()) {
            System.out.println("\n=== Test getServiceById ===");
            Service service = dao.getServiceById(services.get(0).getServiceId());
            if (service != null) {
                System.out.println("Found: " + service.getServiceName());
            }
        }
        
        // Test getServiceByName
        System.out.println("\n=== Test getServiceByName ===");
        Service pharmacyService = dao.getServiceByName("Bán thuốc trực tiếp");
        if (pharmacyService != null) {
            System.out.println("Found pharmacy service: " + pharmacyService.getServiceName() + " (ID: " + pharmacyService.getServiceId() + ")");
        } else {
            System.out.println("Pharmacy service not found - may need to run SQL script first");
        }
        
        // Test searchServicesByName
        System.out.println("\n=== Test searchServicesByName ===");
        List<Service> searchResults = dao.searchServicesByName("khám");
        for (Service service : searchResults) {
            System.out.println("Search result: " + service.getServiceName());
        }
        
        // Test getAllCategories
        System.out.println("\n=== Test getAllCategories ===");
        List<String> categories = dao.getAllCategories();
        for (String category : categories) {
            System.out.println("Category: " + category);
        }
    }

    // Đảm bảo có hàm close để tránh lỗi linter
    public static void close(java.sql.ResultSet rs, java.sql.PreparedStatement ps, java.sql.Connection conn) {
          
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
} 