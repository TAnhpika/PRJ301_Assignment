<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Date Range Picker Component
    Reusable date range input fields
    
    Usage:
    <jsp:include page="/includes/components/date_range_picker.jsp">
        <jsp:param name="startId" value="startDate"/>
        <jsp:param name="endId" value="endDate"/>
        <jsp:param name="startLabel" value="Từ ngày"/>
        <jsp:param name="endLabel" value="Đến ngày"/>
        <jsp:param name="startValue" value=""/>
        <jsp:param name="endValue" value=""/>
    </jsp:include>
--%>
<%
    String startId = request.getParameter("startId");
    String endId = request.getParameter("endId");
    String startLabel = request.getParameter("startLabel");
    String endLabel = request.getParameter("endLabel");
    String startValue = request.getParameter("startValue");
    String endValue = request.getParameter("endValue");
    String startName = request.getParameter("startName");
    String endName = request.getParameter("endName");
    String required = request.getParameter("required");
    String colClass = request.getParameter("colClass");
    
    if (startId == null) startId = "startDate";
    if (endId == null) endId = "endDate";
    if (startLabel == null) startLabel = "Từ ngày";
    if (endLabel == null) endLabel = "Đến ngày";
    if (startValue == null) startValue = "";
    if (endValue == null) endValue = "";
    if (startName == null) startName = startId;
    if (endName == null) endName = endId;
    if (required == null) required = "false";
    if (colClass == null) colClass = "col-12 col-md-6";
%>

<div class="row g-3">
    <div class="<%= colClass %>">
        <label for="<%= startId %>" class="form-label">
            <%= startLabel %>
            <% if ("true".equals(required)) { %><span class="text-danger">*</span><% } %>
        </label>
        <div class="input-group">
            <span class="input-group-text"><i class="fas fa-calendar"></i></span>
            <input type="date" 
                   class="form-control" 
                   id="<%= startId %>" 
                   name="<%= startName %>"
                   value="<%= startValue %>"
                   <% if ("true".equals(required)) { %>required<% } %>>
        </div>
    </div>
    <div class="<%= colClass %>">
        <label for="<%= endId %>" class="form-label">
            <%= endLabel %>
            <% if ("true".equals(required)) { %><span class="text-danger">*</span><% } %>
        </label>
        <div class="input-group">
            <span class="input-group-text"><i class="fas fa-calendar"></i></span>
            <input type="date" 
                   class="form-control" 
                   id="<%= endId %>" 
                   name="<%= endName %>"
                   value="<%= endValue %>"
                   <% if ("true".equals(required)) { %>required<% } %>>
        </div>
    </div>
</div>
