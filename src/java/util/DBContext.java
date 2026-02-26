package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Kết nối database SQL Server (local hoặc Azure SQL). Cấu hình đọc từ file .env
 * ở thư mục gốc project (cạnh pom.xml / nbproject). Mẫu: copy .env.example
 * thành .env rồi điền DB_HOST, DB_PORT, DB_NAME, DB_USERNAME, DB_PASSWORD. -
 * Local: DB_HOST=localhost, DB_PORT=1433, DB_NAME=BenhVien, DB_USERNAME=sa,
 * DB_PASSWORD=... - Azure: DB_HOST=ten-server.database.windows.net,
 * DB_PORT=1433, DB_NAME=BenhVien, DB_USERNAME=sqladmin, DB_PASSWORD=...,
 * DB_ENCRYPT=true, DB_TRUST_SERVER_CERTIFICATE=false Nếu không có .env hoặc
 * biến trống → dùng mặc định bên dưới (local).
 */
public class DBContext {

    public static String driverName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

    /**
     * URL: ưu tiên từ .env (DB_HOST, DB_PORT, DB_NAME, DB_ENCRYPT,
     * DB_TRUST_SERVER_CERTIFICATE), không có thì dùng mặc định local.
     */
    private static String getDbURL() {
        String host = Env.get("DB_HOST", "localhost");
        String port = Env.get("DB_PORT", "1433");
        String dbName = Env.get("DB_NAME", "PRJ301_ASSIGNMENT_DENTAL_CLINIC");
        boolean encrypt = "true".equalsIgnoreCase(Env.get("DB_ENCRYPT", "false"));
        boolean trustCert = "true".equalsIgnoreCase(Env.get("DB_TRUST_SERVER_CERTIFICATE", "true"));
        return "jdbc:sqlserver://" + host + ":" + port + ";databaseName=" + dbName
                + ";encrypt=" + encrypt + ";trustServerCertificate=" + trustCert + ";loginTimeout=30;";
    }

    public static String getDbURLStatic() {
        return getDbURL();
    }

    /**
     * Mặc định khi .env không có DB_USERNAME / DB_PASSWORD (chạy local).
     */
    public static String userDB = "sa";
    public static String passDB = "123";

    public static Connection getConnection() {
        Connection con = null;
        try {
            String user = Env.get("DB_USERNAME");
            String pass = Env.get("DB_PASSWORD");

            if (user == null || user.isEmpty()) {
                user = userDB;
            }
            if (pass == null || pass.isEmpty()) {
                pass = passDB;
            }
            Class.forName(driverName);
            con = DriverManager.getConnection(getDbURL(), user, pass);
            return con;
        } catch (Exception ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public static void closeConnection(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Bổ sung hàm close cho tiện dùng ở các DAO
    public static void close(ResultSet rs, PreparedStatement ps, Connection conn) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (Exception e) {
        }
        try {
            if (ps != null) {
                ps.close();
            }
        } catch (Exception e) {
        }
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
        }
    }

    public static void main(String[] args) {
        try (Connection con = getConnection()) {
            if (con != null) {
                System.out.println("Connect Success");
            }
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
