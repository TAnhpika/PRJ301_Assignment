<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Header Search Component
    Reusable header search bar
    
    Usage:
    <jsp:include page="/includes/components/header_search.jsp">
        <jsp:param name="placeholder" value="Tìm kiếm..."/>
        <jsp:param name="action" value="/search"/>
        <jsp:param name="name" value="q"/>
    </jsp:include>
--%>
<%
    String placeholder = request.getParameter("placeholder");
    String action = request.getParameter("action");
    String name = request.getParameter("name");
    String id = request.getParameter("id");
    
    if (placeholder == null) placeholder = "Tìm kiếm...";
    if (name == null) name = "q";
    if (id == null) id = "headerSearch";
%>

<div class="header-search">
    <% if (action != null && !action.isEmpty()) { %>
    <form action="${pageContext.request.contextPath}<%= action %>" method="get" class="d-flex">
    <% } %>
    <i class="fas fa-search"></i>
    <input type="text" 
           id="<%= id %>"
           name="<%= name %>" 
           placeholder="<%= placeholder %>" 
           class="form-control"
           autocomplete="off">
    <% if (action != null && !action.isEmpty()) { %>
    </form>
    <% } %>
</div>
