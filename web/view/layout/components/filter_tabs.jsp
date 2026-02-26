<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Filter Tabs Component
    Reusable filter button group
    
    Usage:
    <jsp:include page="/includes/components/filter_tabs.jsp">
        <jsp:param name="filterId" value="statusFilter"/>
        <jsp:param name="filters" value="all|Tất cả,pending|Chờ xử lý,completed|Hoàn thành,cancelled|Đã hủy"/>
        <jsp:param name="activeFilter" value="all"/>
        <jsp:param name="onFilter" value="filterData"/>
    </jsp:include>
    
    Filters format: "value|Label" (comma separated)
--%>
<%
    String filterId = request.getParameter("filterId");
    String filters = request.getParameter("filters");
    String activeFilter = request.getParameter("activeFilter");
    String onFilter = request.getParameter("onFilter");
    String size = request.getParameter("size");
    
    if (filterId == null) filterId = "filterTabs";
    if (filters == null || filters.isEmpty()) return;
    if (activeFilter == null) activeFilter = "";
    if (size == null) size = "";
    
    String[] filterItems = filters.split(",");
    String btnSize = "";
    if ("sm".equals(size)) btnSize = "btn-sm";
    else if ("lg".equals(size)) btnSize = "btn-lg";
%>

<div class="btn-group mb-3" role="group" id="<%= filterId %>">
    <% for (int i = 0; i < filterItems.length; i++) {
        String[] parts = filterItems[i].trim().split("\\|");
        String value = parts.length > 0 ? parts[0] : "";
        String label = parts.length > 1 ? parts[1] : value;
        boolean isActive = activeFilter.isEmpty() ? (i == 0) : activeFilter.equals(value);
    %>
    <button type="button" 
            class="btn btn-outline-primary <%= btnSize %> <%= isActive ? "active" : "" %>" 
            data-filter="<%= value %>"
            <% if (onFilter != null && !onFilter.isEmpty()) { %>
            onclick="<%= onFilter %>('<%= value %>')"
            <% } %>>
        <%= label %>
    </button>
    <% } %>
</div>
