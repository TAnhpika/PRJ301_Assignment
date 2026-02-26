<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Avatar Component
    Reusable avatar image with fallback
    
    Usage:
    <jsp:include page="/includes/components/avatar.jsp">
        <jsp:param name="src" value="/img/user.jpg"/>
        <jsp:param name="alt" value="User Name"/>
        <jsp:param name="size" value="md"/>
        <jsp:param name="rounded" value="circle"/>
        <jsp:param name="showStatus" value="true"/>
        <jsp:param name="status" value="online"/>
    </jsp:include>
    
    Sizes: xs (24px), sm (32px), md (48px), lg (64px), xl (96px)
    Rounded: circle, rounded, square
    Status: online, offline, busy, away
--%>
<%
    String src = request.getParameter("src");
    String alt = request.getParameter("alt");
    String size = request.getParameter("size");
    String rounded = request.getParameter("rounded");
    String showStatus = request.getParameter("showStatus");
    String status = request.getParameter("status");
    String border = request.getParameter("border");
    String className = request.getParameter("className");
    
    if (alt == null) alt = "Avatar";
    if (size == null) size = "md";
    if (rounded == null) rounded = "circle";
    if (showStatus == null) showStatus = "false";
    if (status == null) status = "online";
    if (border == null) border = "false";
    if (className == null) className = "";
    
    // Determine size in pixels
    String sizeStyle = "";
    switch (size) {
        case "xs": sizeStyle = "width: 24px; height: 24px;"; break;
        case "sm": sizeStyle = "width: 32px; height: 32px;"; break;
        case "md": sizeStyle = "width: 48px; height: 48px;"; break;
        case "lg": sizeStyle = "width: 64px; height: 64px;"; break;
        case "xl": sizeStyle = "width: 96px; height: 96px;"; break;
        default: sizeStyle = "width: 48px; height: 48px;";
    }
    
    // Determine border radius
    String roundedClass = "";
    switch (rounded) {
        case "circle": roundedClass = "rounded-circle"; break;
        case "rounded": roundedClass = "rounded"; break;
        case "square": roundedClass = ""; break;
    }
    
    // Status color
    String statusColor = "";
    switch (status) {
        case "online": statusColor = "bg-success"; break;
        case "offline": statusColor = "bg-secondary"; break;
        case "busy": statusColor = "bg-danger"; break;
        case "away": statusColor = "bg-warning"; break;
    }
    
    String defaultAvatar = request.getContextPath() + "/img/default-avatar.png";
    String imgSrc = (src != null && !src.isEmpty()) ? src : defaultAvatar;
%>

<div class="avatar-wrapper position-relative d-inline-block <%= className %>">
    <img src="<%= imgSrc %>" 
         alt="<%= alt %>"
         class="<%= roundedClass %> object-fit-cover <%= "true".equals(border) ? "border border-2 border-white shadow-sm" : "" %>"
         style="<%= sizeStyle %>"
         onerror="this.src='<%= defaultAvatar %>'">
    <% if ("true".equals(showStatus)) { %>
    <span class="position-absolute bottom-0 end-0 translate-middle p-1 <%= statusColor %> border border-2 border-white rounded-circle">
        <span class="visually-hidden"><%= status %></span>
    </span>
    <% } %>
</div>
