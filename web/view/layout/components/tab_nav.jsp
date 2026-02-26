<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Tab Navigation Component
    Reusable Bootstrap tabs navigation
    
    Usage:
    <jsp:include page="/includes/components/tab_nav.jsp">
        <jsp:param name="tabId" value="myTabs"/>
        <jsp:param name="tabs" value="all|Tất cả|fa-list,pending|Chờ xử lý|fa-clock,completed|Hoàn thành|fa-check"/>
        <jsp:param name="activeTab" value="all"/>
        <jsp:param name="pills" value="false"/>
    </jsp:include>
    
    Tabs format: "id|Label|Icon" (comma separated)
--%>
<%
    String tabId = request.getParameter("tabId");
    String tabs = request.getParameter("tabs");
    String activeTab = request.getParameter("activeTab");
    String pills = request.getParameter("pills");
    String justified = request.getParameter("justified");
    String fill = request.getParameter("fill");
    
    if (tabId == null) tabId = "navTabs";
    if (tabs == null || tabs.isEmpty()) return;
    if (pills == null) pills = "false";
    if (justified == null) justified = "false";
    if (fill == null) fill = "false";
    
    String[] tabItems = tabs.split(",");
    String navClass = "true".equals(pills) ? "nav-pills" : "nav-tabs";
    if ("true".equals(justified)) navClass += " nav-justified";
    if ("true".equals(fill)) navClass += " nav-fill";
%>

<ul class="nav <%= navClass %> mb-4" id="<%= tabId %>" role="tablist">
    <% for (int i = 0; i < tabItems.length; i++) {
        String[] parts = tabItems[i].trim().split("\\|");
        String id = parts.length > 0 ? parts[0] : "tab" + i;
        String label = parts.length > 1 ? parts[1] : "Tab " + (i + 1);
        String icon = parts.length > 2 ? parts[2] : "";
        boolean isActive = activeTab != null ? activeTab.equals(id) : (i == 0);
    %>
    <li class="nav-item" role="presentation">
        <button class="nav-link <%= isActive ? "active" : "" %>" 
                id="<%= id %>-tab" 
                data-bs-toggle="<%= "true".equals(pills) ? "pill" : "tab" %>" 
                data-bs-target="#<%= id %>" 
                type="button" 
                role="tab" 
                aria-controls="<%= id %>" 
                aria-selected="<%= isActive ? "true" : "false" %>">
            <% if (!icon.isEmpty()) { %>
            <i class="fas <%= icon %> me-1"></i>
            <% } %>
            <%= label %>
        </button>
    </li>
    <% } %>
</ul>
