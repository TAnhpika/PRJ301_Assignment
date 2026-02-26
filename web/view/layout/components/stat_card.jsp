<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Stat Card Component
    Reusable statistics card with icon, value and label
    
    Usage:
    <jsp:include page="/includes/components/stat_card.jsp">
        <jsp:param name="icon" value="fa-users"/>
        <jsp:param name="value" value="150"/>
        <jsp:param name="label" value="Tổng số bệnh nhân"/>
        <jsp:param name="variant" value="primary"/>
        <jsp:param name="colClass" value="col-12 col-sm-6 col-xl-3"/>
    </jsp:include>
    
    Variants: primary (default), success, warning, danger, info
--%>
<%
    String icon = request.getParameter("icon");
    String value = request.getParameter("value");
    String label = request.getParameter("label");
    String variant = request.getParameter("variant");
    String colClass = request.getParameter("colClass");
    String link = request.getParameter("link");
    
    if (icon == null) icon = "fa-chart-bar";
    if (value == null) value = "0";
    if (label == null) label = "Thống kê";
    if (variant == null) variant = "";
    if (colClass == null) colClass = "col-12 col-sm-6 col-xl-3";
    if (link == null) link = "";
%>

<div class="<%= colClass %>">
    <% if (!link.isEmpty()) { %>
    <a href="<%= link %>" class="text-decoration-none">
    <% } %>
    <div class="stat-card <%= variant %>">
        <div class="stat-card-icon">
            <i class="fas <%= icon %>"></i>
        </div>
        <div class="stat-card-value"><%= value %></div>
        <div class="stat-card-label"><%= label %></div>
    </div>
    <% if (!link.isEmpty()) { %>
    </a>
    <% } %>
</div>
