<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Timeline Item Component
    Reusable timeline/history item
    
    Usage:
    <jsp:include page="/includes/components/timeline_item.jsp">
        <jsp:param name="icon" value="fa-check"/>
        <jsp:param name="iconBg" value="success"/>
        <jsp:param name="title" value="Đặt lịch thành công"/>
        <jsp:param name="description" value="Lịch hẹn đã được xác nhận"/>
        <jsp:param name="time" value="10:30 AM - 01/01/2024"/>
        <jsp:param name="isLast" value="false"/>
    </jsp:include>
--%>
<%
    String icon = request.getParameter("icon");
    String iconBg = request.getParameter("iconBg");
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    String time = request.getParameter("time");
    String isLast = request.getParameter("isLast");
    String user = request.getParameter("user");
    
    if (icon == null) icon = "fa-circle";
    if (iconBg == null) iconBg = "primary";
    if (title == null) title = "Sự kiện";
    if (isLast == null) isLast = "false";
%>

<div class="timeline-item d-flex <%= !"true".equals(isLast) ? "pb-4" : "" %>">
    <div class="timeline-icon me-3 position-relative">
        <div class="bg-<%= iconBg %> rounded-circle d-flex align-items-center justify-content-center" 
             style="width: 40px; height: 40px;">
            <i class="fas <%= icon %> text-white"></i>
        </div>
        <% if (!"true".equals(isLast)) { %>
        <div class="timeline-line position-absolute" style="left: 50%; top: 40px; bottom: 0; width: 2px; background: #dee2e6; transform: translateX(-50%);"></div>
        <% } %>
    </div>
    <div class="timeline-content flex-grow-1">
        <h6 class="mb-1"><%= title %></h6>
        <% if (description != null && !description.isEmpty()) { %>
        <p class="text-muted mb-1 small"><%= description %></p>
        <% } %>
        <div class="d-flex align-items-center">
            <small class="text-muted">
                <i class="fas fa-clock me-1"></i><%= time %>
            </small>
            <% if (user != null && !user.isEmpty()) { %>
            <small class="text-muted ms-3">
                <i class="fas fa-user me-1"></i><%= user %>
            </small>
            <% } %>
        </div>
    </div>
</div>
