<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Notification Item Component
    Reusable notification list item
    
    Usage:
    <jsp:include page="/includes/components/notification_item.jsp">
        <jsp:param name="icon" value="fa-user"/>
        <jsp:param name="iconBg" value="primary"/>
        <jsp:param name="message" value="3 nhân viên yêu cầu đổi ca"/>
        <jsp:param name="time" value="5 phút trước"/>
        <jsp:param name="link" value="/notifications/1"/>
        <jsp:param name="unread" value="true"/>
    </jsp:include>
--%>
<%
    String icon = request.getParameter("icon");
    String iconBg = request.getParameter("iconBg");
    String message = request.getParameter("message");
    String time = request.getParameter("time");
    String link = request.getParameter("link");
    String unread = request.getParameter("unread");
    
    if (icon == null) icon = "fa-bell";
    if (iconBg == null) iconBg = "primary";
    if (message == null) message = "Thông báo mới";
    if (time == null) time = "Vừa xong";
    if (link == null) link = "";
    if (unread == null) unread = "false";
%>

<% if (!link.isEmpty()) { %>
<a href="${pageContext.request.contextPath}<%= link %>" class="text-decoration-none">
<% } %>
<div class="list-group-item border-0 px-0 <%= "true".equals(unread) ? "bg-light" : "" %>">
    <div class="d-flex align-items-start">
        <div class="bg-<%= iconBg %> rounded-circle p-2 me-3" style="min-width: 36px; height: 36px; display: flex; align-items: center; justify-content: center;">
            <i class="fas <%= icon %> text-white" style="font-size: 12px;"></i>
        </div>
        <div class="flex-grow-1">
            <p class="mb-1 small <%= "true".equals(unread) ? "fw-semibold" : "" %>"><%= message %></p>
            <small class="text-muted"><i class="fas fa-clock me-1"></i><%= time %></small>
        </div>
        <% if ("true".equals(unread)) { %>
        <span class="badge bg-primary rounded-pill ms-2" style="width: 8px; height: 8px; padding: 0;"></span>
        <% } %>
    </div>
</div>
<% if (!link.isEmpty()) { %>
</a>
<% } %>
