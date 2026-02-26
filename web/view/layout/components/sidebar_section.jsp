<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Sidebar Section Component
    Reusable sidebar section with title
    
    Usage:
    <jsp:include page="/includes/components/sidebar_section.jsp">
        <jsp:param name="title" value="Quản lý"/>
    </jsp:include>
    
    Then add sidebar-items after this include
--%>
<%
    // ✅ CRITICAL: Set request encoding UTF-8 để decode đúng parameter tiếng Việt
    request.setCharacterEncoding("UTF-8");
    
    String title = request.getParameter("title");
    if (title == null) title = "Menu";
%>

<div class="sidebar-section">
    <div class="sidebar-section-title"><%= title %></div>
