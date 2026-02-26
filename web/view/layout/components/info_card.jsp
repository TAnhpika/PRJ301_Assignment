<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Info Card Component
    Reusable information display card with icon
    
    Usage:
    <jsp:include page="/includes/components/info_card.jsp">
        <jsp:param name="icon" value="fa-user"/>
        <jsp:param name="iconBg" value="primary"/>
        <jsp:param name="title" value="Thông tin bệnh nhân"/>
        <jsp:param name="items" value="Họ tên|Nguyễn Văn A,Email|email@test.com,Điện thoại|0123456789"/>
    </jsp:include>
    
    Items format: "Label|Value" (comma separated)
--%>
<%
    String icon = request.getParameter("icon");
    String iconBg = request.getParameter("iconBg");
    String title = request.getParameter("title");
    String items = request.getParameter("items");
    String colClass = request.getParameter("colClass");
    
    if (icon == null) icon = "fa-info-circle";
    if (iconBg == null) iconBg = "primary";
    if (title == null) title = "Thông tin";
    if (colClass == null) colClass = "";
    
    String[] infoItems = items != null ? items.split(",") : new String[0];
%>

<% if (!colClass.isEmpty()) { %><div class="<%= colClass %>"><% } %>
<div class="dashboard-card h-100">
    <div class="d-flex align-items-center mb-3">
        <div class="bg-<%= iconBg %> rounded-circle p-3 me-3">
            <i class="fas <%= icon %> text-white fa-lg"></i>
        </div>
        <h5 class="mb-0"><%= title %></h5>
    </div>
    <% if (infoItems.length > 0) { %>
    <div class="info-list">
        <% for (String item : infoItems) {
            String[] parts = item.trim().split("\\|");
            String label = parts.length > 0 ? parts[0] : "";
            String value = parts.length > 1 ? parts[1] : "";
        %>
        <div class="d-flex justify-content-between py-2 border-bottom">
            <span class="text-muted"><%= label %></span>
            <span class="fw-medium"><%= value %></span>
        </div>
        <% } %>
    </div>
    <% } %>
</div>
<% if (!colClass.isEmpty()) { %></div><% } %>
