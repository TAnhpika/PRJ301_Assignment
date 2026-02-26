<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Header User Component
    Reusable user profile dropdown in header
    
    Usage:
    <jsp:include page="/includes/components/header_user.jsp">
        <jsp:param name="userName" value="Nguyễn Văn A"/>
        <jsp:param name="userRole" value="Bác sĩ"/>
        <jsp:param name="userAvatar" value="/img/avatar.jpg"/>
        <jsp:param name="profileUrl" value="/profile"/>
        <jsp:param name="settingsUrl" value="/settings"/>
        <jsp:param name="logoutUrl" value="/logout"/>
    </jsp:include>
--%>
<%
    String userName = request.getParameter("userName");
    String userRole = request.getParameter("userRole");
    String userAvatar = request.getParameter("userAvatar");
    String profileUrl = request.getParameter("profileUrl");
    String settingsUrl = request.getParameter("settingsUrl");
    String logoutUrl = request.getParameter("logoutUrl");
    
    if (userName == null) userName = "Người dùng";
    if (userRole == null) userRole = "User";
    if (logoutUrl == null) logoutUrl = "/LogoutServlet";
    
    String defaultAvatar = request.getContextPath() + "/img/default-avatar.png";
    String avatarSrc = (userAvatar != null && !userAvatar.isEmpty()) ? userAvatar : defaultAvatar;
%>

<div class="header-user">
    <img src="<%= avatarSrc %>" alt="Avatar" onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
    <div class="header-user-info">
        <span class="header-user-name"><%= userName %></span>
        <span class="header-user-role"><%= userRole %></span>
    </div>
    <div class="header-dropdown">
        <% if (profileUrl != null && !profileUrl.isEmpty()) { %>
        <a href="${pageContext.request.contextPath}<%= profileUrl %>">
            <i class="fas fa-user"></i> Trang cá nhân
        </a>
        <% } %>
        <% if (settingsUrl != null && !settingsUrl.isEmpty()) { %>
        <a href="${pageContext.request.contextPath}<%= settingsUrl %>">
            <i class="fas fa-cog"></i> Cài đặt
        </a>
        <% } %>
        <a href="${pageContext.request.contextPath}<%= logoutUrl %>">
            <i class="fas fa-sign-out-alt"></i> Đăng xuất
        </a>
    </div>
</div>
