<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Card Header Component
    Reusable dashboard card header with title and optional actions
    
    Usage:
    <jsp:include page="/includes/components/card_header.jsp">
        <jsp:param name="title" value="Danh sách"/>
        <jsp:param name="icon" value="fa-list"/>
        <jsp:param name="iconColor" value="primary"/>
        <jsp:param name="showAction" value="true"/>
        <jsp:param name="actionText" value="Thêm mới"/>
        <jsp:param name="actionUrl" value="/add"/>
        <jsp:param name="actionIcon" value="fa-plus"/>
    </jsp:include>
--%>
<%
    String title = request.getParameter("title");
    String icon = request.getParameter("icon");
    String iconColor = request.getParameter("iconColor");
    String showAction = request.getParameter("showAction");
    String actionText = request.getParameter("actionText");
    String actionUrl = request.getParameter("actionUrl");
    String actionIcon = request.getParameter("actionIcon");
    String actionVariant = request.getParameter("actionVariant");
    String subtitle = request.getParameter("subtitle");
    
    if (title == null) title = "Tiêu đề";
    if (iconColor == null) iconColor = "primary";
    if (showAction == null) showAction = "false";
    if (actionText == null) actionText = "Thêm mới";
    if (actionIcon == null) actionIcon = "fa-plus";
    if (actionVariant == null) actionVariant = "primary";
%>

<div class="dashboard-card-header">
    <div>
        <h5 class="dashboard-card-title mb-0">
            <% if (icon != null && !icon.isEmpty()) { %>
            <i class="fas <%= icon %> text-<%= iconColor %> me-2"></i>
            <% } %>
            <%= title %>
        </h5>
        <% if (subtitle != null && !subtitle.isEmpty()) { %>
        <small class="text-muted"><%= subtitle %></small>
        <% } %>
    </div>
    <% if ("true".equals(showAction) && actionUrl != null) { %>
    <a href="${pageContext.request.contextPath}<%= actionUrl %>" 
       class="btn-dashboard btn-dashboard-<%= actionVariant %> btn-sm">
        <i class="fas <%= actionIcon %> me-1"></i>
        <%= actionText %>
    </a>
    <% } %>
</div>
