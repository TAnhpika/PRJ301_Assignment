<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Empty State Component
    Reusable empty state display when no data available
    
    Usage:
    <jsp:include page="/includes/components/empty_state.jsp">
        <jsp:param name="icon" value="fa-inbox"/>
        <jsp:param name="title" value="Không có dữ liệu"/>
        <jsp:param name="message" value="Chưa có dữ liệu để hiển thị"/>
        <jsp:param name="showAction" value="true"/>
        <jsp:param name="actionText" value="Thêm mới"/>
        <jsp:param name="actionLink" value="#"/>
    </jsp:include>
--%>
<%
    String icon = request.getParameter("icon");
    String title = request.getParameter("title");
    String message = request.getParameter("message");
    String showAction = request.getParameter("showAction");
    String actionText = request.getParameter("actionText");
    String actionLink = request.getParameter("actionLink");
    
    if (icon == null) icon = "fa-inbox";
    if (title == null) title = "Không có dữ liệu";
    if (message == null) message = "Chưa có dữ liệu để hiển thị";
    if (showAction == null) showAction = "false";
    if (actionText == null) actionText = "Thêm mới";
    if (actionLink == null) actionLink = "#";
%>

<div class="text-center py-5">
    <div class="empty-state-icon mb-4">
        <i class="fas <%= icon %> fa-4x text-muted"></i>
    </div>
    <h5 class="text-muted mb-2"><%= title %></h5>
    <p class="text-muted mb-4"><%= message %></p>
    <% if ("true".equals(showAction)) { %>
    <a href="<%= actionLink %>" class="btn-dashboard btn-dashboard-primary">
        <i class="fas fa-plus me-2"></i><%= actionText %>
    </a>
    <% } %>
</div>
