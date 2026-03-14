<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBContext" %>
<!DOCTYPE html>
<html>
<head>
    <title>DB Debug</title>
</head>
<body>
    <h2>User List and Roles</h2>
    <table border="1">
        <tr>
            <th>User ID</th>
            <th>Email</th>
            <th>Role</th>
        </tr>
        <%
            try (Connection conn = DBContext.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT user_id, email, role FROM users")) {
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("user_id") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("role") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
                e.printStackTrace(new java.io.PrintWriter(out));
            }
        %>
    </table>

    <hr>
    <h2>Managers Table Schema</h2>
    <%
            try (Connection conn = DBContext.getConnection()) {
                DatabaseMetaData metaData = conn.getMetaData();
                try (ResultSet rs = metaData.getColumns(null, null, "Managers", null)) {
                    out.println("<table border='1'><tr><th>Column Name</th><th>Type</th><th>Size</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("COLUMN_NAME") + "</td>");
                        out.println("<td>" + rs.getString("TYPE_NAME") + "</td>");
                        out.println("<td>" + rs.getInt("COLUMN_SIZE") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }
            } catch (Exception e) {
                out.println("<p style='color:red'>Managers schema check failed: " + e.getMessage() + "</p>");
            }
    %>

    <hr>
    <h2>Managers Table Check</h2>
    <%
            try (Connection conn = DBContext.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM Managers")) {
                out.println("<table border='1'><tr>");
                ResultSetMetaData meta = rs.getMetaData();
                for (int i = 1; i <= meta.getColumnCount(); i++) {
                    out.println("<th>" + meta.getColumnName(i) + "</th>");
                }
                out.println("</tr>");
                while (rs.next()) {
                    out.println("<tr>");
                    for (int i = 1; i <= meta.getColumnCount(); i++) {
                        out.println("<td>" + rs.getObject(i) + "</td>");
                    }
                    out.println("</tr>");
                }
                out.println("</table>");
            } catch (Exception e) {
                out.println("<p style='color:orange'>Managers table check failed: " + e.getMessage() + "</p>");
            }
    %>
</body>
</html>
