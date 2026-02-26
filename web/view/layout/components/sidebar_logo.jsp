<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Sidebar Logo Component
    Reusable sidebar header with logo
    
    Usage:
    <jsp:include page="/includes/components/sidebar_logo.jsp">
        <jsp:param name="logoUrl" value="/img/logo.png"/>
        <jsp:param name="title" value="HAPPY SMILE"/>
        <jsp:param name="subtitle" value="Dental Clinic"/>
    </jsp:include>
--%>
<%
    String logoUrl = request.getParameter("logoUrl");
    String title = request.getParameter("title");
    String subtitle = request.getParameter("subtitle");
    String homeUrl = request.getParameter("homeUrl");
    
    if (logoUrl == null) logoUrl = "/img/logo.png";
    if (title == null) title = "HAPPY SMILE";
    if (homeUrl == null) homeUrl = "";
%>

<div class="sidebar-header">
    <% if (!homeUrl.isEmpty()) { %>
    <a href="${pageContext.request.contextPath}<%= homeUrl %>" class="text-decoration-none">
    <% } %>
    <div class="sidebar-logo">
        <img src="${pageContext.request.contextPath}<%= logoUrl %>" alt="Logo">
        <div>
            <h2><%= title %></h2>
            <% if (subtitle != null && !subtitle.isEmpty()) { %>
            <small class="text-muted"><%= subtitle %></small>
            <% } %>
        </div>
    </div>
    <% if (!homeUrl.isEmpty()) { %>
    </a>
    <% } %>
</div>
