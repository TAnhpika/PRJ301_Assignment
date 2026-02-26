<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Sidebar Dropdown Component
    Reusable sidebar dropdown menu
    
    Usage:
    <jsp:include page="/includes/components/sidebar_dropdown.jsp">
        <jsp:param name="icon" value="fa-users"/>
        <jsp:param name="text" value="Quản lý người dùng"/>
        <jsp:param name="items" value="Danh sách|/list,Thêm mới|/add,Phân quyền|/roles"/>
    </jsp:include>
    
    Items format: "Label|URL" (comma separated)
--%>
<%
    String icon = request.getParameter("icon");
    String text = request.getParameter("text");
    String items = request.getParameter("items");
    String open = request.getParameter("open");
    
    if (icon == null) icon = "fa-folder";
    if (text == null) text = "Menu";
    if (open == null) open = "false";
    if (items == null || items.isEmpty()) return;
    
    String[] menuItems = items.split(",");
%>

<div class="sidebar-dropdown <%= "true".equals(open) ? "open" : "" %>">
    <div class="sidebar-item sidebar-dropdown-toggle" onclick="toggleDropdown(this)">
        <i class="fas <%= icon %>"></i>
        <span><%= text %></span>
    </div>
    <div class="sidebar-dropdown-menu">
        <% for (String item : menuItems) {
            String[] parts = item.trim().split("\\|");
            String label = parts.length > 0 ? parts[0] : "Item";
            String url = parts.length > 1 ? parts[1] : "#";
            String itemIcon = parts.length > 2 ? parts[2] : "";
        %>
        <a href="${pageContext.request.contextPath}<%= url %>" class="sidebar-dropdown-item">
            <% if (!itemIcon.isEmpty()) { %>
            <i class="fas <%= itemIcon %> me-2"></i>
            <% } %>
            <%= label %>
        </a>
        <% } %>
    </div>
</div>
