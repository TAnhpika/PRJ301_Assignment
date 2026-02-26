<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Data Table Component
    Reusable table wrapper with responsive container
    
    Usage:
    <jsp:include page="/includes/components/data_table.jsp">
        <jsp:param name="tableId" value="dataTable"/>
        <jsp:param name="striped" value="true"/>
        <jsp:param name="hover" value="true"/>
        <jsp:param name="bordered" value="false"/>
    </jsp:include>
    
    Note: This creates the table wrapper. You need to add thead and tbody content separately.
--%>
<%
    String tableId = request.getParameter("tableId");
    String striped = request.getParameter("striped");
    String hover = request.getParameter("hover");
    String bordered = request.getParameter("bordered");
    String small = request.getParameter("small");
    String tableClass = request.getParameter("tableClass");
    
    if (tableId == null) tableId = "dataTable";
    if (striped == null) striped = "false";
    if (hover == null) hover = "true";
    if (bordered == null) bordered = "false";
    if (small == null) small = "false";
    if (tableClass == null) tableClass = "";
    
    StringBuilder classes = new StringBuilder("dashboard-table");
    if ("true".equals(striped)) classes.append(" table-striped");
    if ("true".equals(hover)) classes.append(" table-hover");
    if ("true".equals(bordered)) classes.append(" table-bordered");
    if ("true".equals(small)) classes.append(" table-sm");
    if (!tableClass.isEmpty()) classes.append(" ").append(tableClass);
%>

<div class="table-responsive">
    <table class="<%= classes.toString() %>" id="<%= tableId %>">
        <!-- Add thead and tbody content here -->
    </table>
</div>
