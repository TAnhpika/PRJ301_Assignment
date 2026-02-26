<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Page Title Component
    Reusable page header with title, subtitle and date badge
    
    Usage:
    <jsp:include page="/includes/components/page_title.jsp">
        <jsp:param name="title" value="Tiêu đề trang"/>
        <jsp:param name="subtitle" value="Mô tả ngắn"/>
        <jsp:param name="showDate" value="true"/>
        <jsp:param name="icon" value="fa-home"/>
    </jsp:include>
--%>
<%
    String title = request.getParameter("title");
    String subtitle = request.getParameter("subtitle");
    String showDate = request.getParameter("showDate");
    String icon = request.getParameter("icon");
    
    if (title == null) title = "Trang";
    if (subtitle == null) subtitle = "";
    if (showDate == null) showDate = "true";
    if (icon == null) icon = "";
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1">
            <% if (!icon.isEmpty()) { %>
            <i class="fas <%= icon %> text-primary me-2"></i>
            <% } %>
            <%= title %>
        </h4>
        <% if (!subtitle.isEmpty()) { %>
        <p class="text-muted mb-0"><%= subtitle %></p>
        <% } %>
    </div>
    <% if ("true".equals(showDate)) { %>
    <div>
        <span class="badge bg-light text-dark">
            <i class="fas fa-calendar me-1"></i>
            <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
        </span>
    </div>
    <% } %>
</div>
