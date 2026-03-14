<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*, java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>Debug Bills</title></head>
<body>
    <h1>All Bills in Database</h1>
    <table border="1">
        <tr>
            <th>Bill ID</th>
            <th>Customer</th>
            <th>Amount</th>
            <th>Status</th>
            <th>Created At</th>
            <th>Is Deleted</th>
        </tr>
        <%
            try (Connection conn = new util.DBContext().getConnection()) {
                String sql = "SELECT bill_id, customer_name, amount, payment_status, created_at, is_deleted FROM dbo.Bills ORDER BY created_at DESC";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("bill_id") %></td>
            <td><%= rs.getString("customer_name") %></td>
            <td><%= rs.getDouble("amount") %></td>
            <td><%= rs.getString("payment_status") %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
            <td><%= rs.getInt("is_deleted") %></td>
        </tr>
        <%
                    }
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
                e.printStackTrace();
            }
        %>
    </table>
</body>
</html>
