<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Breadcrumb Component
    Reusable navigation breadcrumb
    
    Usage:
    <jsp:include page="/includes/components/breadcrumb.jsp">
        <jsp:param name="items" value="Trang chủ|/home,Quản lý|/manage,Chi tiết"/>
    </jsp:include>
    
    Format: "Label1|URL1,Label2|URL2,LabelCurrent" (last item has no URL)
--%>
<%
    String items = request.getParameter("items");
    if (items == null || items.isEmpty()) return;
    
    String[] breadcrumbItems = items.split(",");
%>

<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb mb-0">
        <% for (int i = 0; i < breadcrumbItems.length; i++) { 
            String item = breadcrumbItems[i].trim();
            String[] parts = item.split("\\|");
            String label = parts[0];
            String url = parts.length > 1 ? parts[1] : "";
            boolean isLast = (i == breadcrumbItems.length - 1);
        %>
        <li class="breadcrumb-item <%= isLast ? "active" : "" %>" 
            <% if (isLast) { %>aria-current="page"<% } %>>
            <% if (!isLast && !url.isEmpty()) { %>
            <a href="${pageContext.request.contextPath}<%= url %>"><%= label %></a>
            <% } else { %>
            <%= label %>
            <% } %>
        </li>
        <% } %>
    </ol>
</nav>
