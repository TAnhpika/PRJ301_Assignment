<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Alert Component
    Reusable alert/notification box
    
    Usage:
    <jsp:include page="/includes/components/alert.jsp">
        <jsp:param name="type" value="success"/>
        <jsp:param name="message" value="Thao tác thành công!"/>
        <jsp:param name="dismissible" value="true"/>
        <jsp:param name="icon" value="fa-check-circle"/>
    </jsp:include>
    
    Types: success, danger, warning, info, primary
--%>
<%
    String type = request.getParameter("type");
    String message = request.getParameter("message");
    String dismissible = request.getParameter("dismissible");
    String icon = request.getParameter("icon");
    String title = request.getParameter("title");
    
    if (type == null) type = "info";
    if (message == null) message = "";
    if (dismissible == null) dismissible = "true";
    
    // Default icons based on type
    if (icon == null) {
        switch (type) {
            case "success": icon = "fa-check-circle"; break;
            case "danger": icon = "fa-times-circle"; break;
            case "warning": icon = "fa-exclamation-triangle"; break;
            case "info": icon = "fa-info-circle"; break;
            default: icon = "fa-bell"; break;
        }
    }
    
    // Skip if no message
    if (message.isEmpty()) return;
%>

<div class="alert alert-<%= type %> <%= "true".equals(dismissible) ? "alert-dismissible fade show" : "" %>" role="alert">
    <div class="d-flex align-items-center">
        <i class="fas <%= icon %> me-2"></i>
        <div>
            <% if (title != null && !title.isEmpty()) { %>
            <strong><%= title %></strong><br>
            <% } %>
            <%= message %>
        </div>
    </div>
    <% if ("true".equals(dismissible)) { %>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
    <% } %>
</div>
