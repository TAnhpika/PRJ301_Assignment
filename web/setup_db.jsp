<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBContext" %>
<!DOCTYPE html>
<html>
<head>
    <title>DB Setup</title>
</head>
<body>
    <h2>Repairing Managers Table</h2>
    <%
        try (Connection conn = DBContext.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Check if table exists
            boolean exists = false;
            try (ResultSet rs = conn.getMetaData().getTables(null, null, "Managers", null)) {
                exists = rs.next();
            }

            if (!exists) {
                out.println("<p>Creating Managers table...</p>");
                stmt.execute("CREATE TABLE Managers (" +
                            "manager_id INT PRIMARY KEY IDENTITY(1,1)," +
                            "user_id INT NOT NULL UNIQUE," +
                            "full_name NVARCHAR(255)," +
                            "phone NVARCHAR(20)," +
                            "address NVARCHAR(MAX)," +
                            "date_of_birth DATE," +
                            "gender NVARCHAR(20)," +
                            "position NVARCHAR(100)," +
                            "FOREIGN KEY (user_id) REFERENCES users(user_id))");
                out.println("<p style='color:green'>Managers table created successfully.</p>");
            } else {
                out.println("<p>Managers table already exists. Checking for missing columns...</p>");
                // Ensure columns exist (naive approach for a quick fix)
                String[] columns = {"full_name", "phone", "address", "date_of_birth", "gender", "position"};
                for (String col : columns) {
                    try {
                        stmt.execute("ALTER TABLE Managers ADD " + col + " NVARCHAR(255)");
                        out.println("<p>Added missing column: " + col + "</p>");
                    } catch (SQLException e) {
                        // Probably already exists
                    }
                }
                out.println("<p style='color:blue'>Schema check completed.</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red'>Setup failed: " + e.getMessage() + "</p>");
            e.printStackTrace(new java.io.PrintWriter(out));
        }
    %>
</body>
</html>
