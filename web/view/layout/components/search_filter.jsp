<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Search Filter Component
    Reusable search input with optional filter dropdowns
    
    Usage:
    <jsp:include page="/includes/components/search_filter.jsp">
        <jsp:param name="placeholder" value="Tìm kiếm..."/>
        <jsp:param name="searchId" value="searchInput"/>
        <jsp:param name="showFilter" value="true"/>
        <jsp:param name="filterLabel" value="Trạng thái"/>
        <jsp:param name="filterId" value="statusFilter"/>
    </jsp:include>
--%>
<%
    String placeholder = request.getParameter("placeholder");
    String searchId = request.getParameter("searchId");
    String showFilter = request.getParameter("showFilter");
    String filterLabel = request.getParameter("filterLabel");
    String filterId = request.getParameter("filterId");
    String onSearch = request.getParameter("onSearch");
    
    if (placeholder == null) placeholder = "Tìm kiếm...";
    if (searchId == null) searchId = "searchInput";
    if (showFilter == null) showFilter = "false";
    if (filterLabel == null) filterLabel = "Lọc";
    if (filterId == null) filterId = "filterSelect";
    if (onSearch == null) onSearch = "";
%>

<div class="row g-3 mb-4">
    <div class="col-12 col-md-6 col-lg-4">
        <div class="input-group">
            <span class="input-group-text bg-white border-end-0">
                <i class="fas fa-search text-muted"></i>
            </span>
            <input type="text" 
                   class="form-control border-start-0" 
                   id="<%= searchId %>" 
                   placeholder="<%= placeholder %>"
                   <% if (!onSearch.isEmpty()) { %>
                   onkeyup="<%= onSearch %>"
                   <% } %>
            >
        </div>
    </div>
    <% if ("true".equals(showFilter)) { %>
    <div class="col-12 col-md-4 col-lg-3">
        <select class="form-select" id="<%= filterId %>">
            <option value="">Tất cả <%= filterLabel.toLowerCase() %></option>
            <!-- Add options dynamically -->
        </select>
    </div>
    <% } %>
</div>
