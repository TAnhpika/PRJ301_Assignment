<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Quick Actions Component
    Reusable quick action buttons card
    
    Usage:
    <jsp:include page="/includes/components/quick_actions.jsp">
        <jsp:param name="title" value="Thao tác nhanh"/>
        <jsp:param name="actions" value="Thêm mới|fa-plus|/add|primary,Xuất báo cáo|fa-download|/export|secondary"/>
    </jsp:include>
    
    Actions format: "Label|Icon|URL|Variant" (comma separated)
    Variants: primary, secondary, success, danger, warning, info
--%>
<%
    String title = request.getParameter("title");
    String actions = request.getParameter("actions");
    String icon = request.getParameter("titleIcon");
    
    if (title == null) title = "Thao tác nhanh";
    if (icon == null) icon = "fa-bolt";
    if (actions == null || actions.isEmpty()) return;
    
    String[] actionList = actions.split(",");
%>

<div class="dashboard-card">
    <div class="dashboard-card-header">
        <h5 class="dashboard-card-title">
            <i class="fas <%= icon %> text-warning me-2"></i>
            <%= title %>
        </h5>
    </div>
    <div class="d-grid gap-2">
        <% for (String action : actionList) {
            String[] parts = action.trim().split("\\|");
            String label = parts.length > 0 ? parts[0] : "Action";
            String actionIcon = parts.length > 1 ? parts[1] : "fa-arrow-right";
            String url = parts.length > 2 ? parts[2] : "#";
            String variant = parts.length > 3 ? parts[3] : "secondary";
        %>
        <a href="${pageContext.request.contextPath}<%= url %>" class="btn-dashboard btn-dashboard-<%= variant %> w-100">
            <i class="fas <%= actionIcon %>"></i>
            <%= label %>
        </a>
        <% } %>
    </div>
</div>
