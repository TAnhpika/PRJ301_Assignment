<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Header Notification Component
    Reusable notification bell dropdown
    
    Usage:
    <jsp:include page="/includes/components/header_notification.jsp">
        <jsp:param name="count" value="5"/>
        <jsp:param name="viewAllUrl" value="/notifications"/>
    </jsp:include>
    
    Note: Notification items should be added dynamically via JavaScript or passed as attribute
--%>
<%
    String count = request.getParameter("count");
    String viewAllUrl = request.getParameter("viewAllUrl");
    
    if (count == null) count = "0";
    if (viewAllUrl == null) viewAllUrl = "#";
    
    int notifCount = Integer.parseInt(count);
%>

<div class="header-notification" data-bs-toggle="dropdown" aria-expanded="false">
    <i class="fas fa-bell"></i>
    <% if (notifCount > 0) { %>
    <span class="notification-badge"><%= notifCount > 99 ? "99+" : count %></span>
    <% } %>
</div>
<ul class="dropdown-menu dropdown-menu-end" style="min-width: 300px;">
    <li>
        <h6 class="dropdown-header d-flex justify-content-between align-items-center">
            <span>Thông báo</span>
            <% if (notifCount > 0) { %>
            <span class="badge bg-primary rounded-pill"><%= count %></span>
            <% } %>
        </h6>
    </li>
    <li><hr class="dropdown-divider"></li>
    
    <!-- Notification items will be inserted here dynamically -->
    <div id="notificationList">
        <li class="text-center py-3 text-muted">
            <i class="fas fa-bell-slash me-2"></i>
            Không có thông báo mới
        </li>
    </div>
    
    <li><hr class="dropdown-divider"></li>
    <li>
        <a class="dropdown-item text-center text-primary" href="${pageContext.request.contextPath}<%= viewAllUrl %>">
            <i class="fas fa-eye me-1"></i>Xem tất cả
        </a>
    </li>
</ul>
