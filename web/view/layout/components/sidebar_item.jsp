<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Sidebar Item Component
    Reusable single sidebar menu item
    
    Usage:
    <jsp:include page="/includes/components/sidebar_item.jsp">
        <jsp:param name="url" value="/home"/>
        <jsp:param name="icon" value="fa-home"/>
        <jsp:param name="text" value="Trang chủ"/>
        <jsp:param name="badge" value="5"/>
        <jsp:param name="badgeVariant" value="danger"/>
    </jsp:include>
--%>
<%
    // ✅ CRITICAL: Set request encoding UTF-8 để decode đúng parameter tiếng Việt
    request.setCharacterEncoding("UTF-8");
    
    String url = request.getParameter("url");
    String icon = request.getParameter("icon");
    String text = request.getParameter("text");
    String badge = request.getParameter("badge");
    String badgeVariant = request.getParameter("badgeVariant");
    String active = request.getParameter("active");
    
    if (url == null) url = "#";
    if (icon == null) icon = "fa-circle";
    if (text == null) text = "Menu Item";
    if (badgeVariant == null) badgeVariant = "primary";
    if (active == null) active = "false";
%>

<a href="${pageContext.request.contextPath}<%= url %>" 
   class="sidebar-item <%= "true".equals(active) ? "active" : "" %>">
    <i class="fas <%= icon %>"></i>
    <span><%= text %></span>
    <% if (badge != null && !badge.isEmpty()) { %>
    <span class="badge bg-<%= badgeVariant %> ms-auto"><%= badge %></span>
    <% } %>
</a>
