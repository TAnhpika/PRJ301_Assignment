<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Pagination Component
    Reusable pagination for tables and lists
    
    Usage (with scriptlet):
    <%
        request.setAttribute("currentPage", 1);
        request.setAttribute("totalPages", 10);
        request.setAttribute("baseUrl", "list.jsp?page=");
    %>
    <jsp:include page="/includes/components/pagination.jsp"/>
    
    Or with params:
    <jsp:include page="/includes/components/pagination.jsp">
        <jsp:param name="currentPage" value="1"/>
        <jsp:param name="totalPages" value="10"/>
        <jsp:param name="baseUrl" value="list.jsp?page="/>
    </jsp:include>
--%>
<%
    // Try attribute first, then parameter
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    String baseUrl = (String) request.getAttribute("baseUrl");
    
    if (currentPage == null) {
        String cp = request.getParameter("currentPage");
        currentPage = cp != null ? Integer.parseInt(cp) : 1;
    }
    if (totalPages == null) {
        String tp = request.getParameter("totalPages");
        totalPages = tp != null ? Integer.parseInt(tp) : 1;
    }
    if (baseUrl == null) {
        baseUrl = request.getParameter("baseUrl");
        if (baseUrl == null) baseUrl = "?page=";
    }
    
    if (totalPages <= 1) return; // Don't show pagination for single page
    
    int startPage = Math.max(1, currentPage - 2);
    int endPage = Math.min(totalPages, currentPage + 2);
%>

<nav aria-label="Phân trang" class="mt-4">
    <ul class="pagination justify-content-center mb-0">
        <!-- First Page -->
        <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
            <a class="page-link" href="<%= baseUrl %>1" aria-label="Đầu">
                <i class="fas fa-angle-double-left"></i>
            </a>
        </li>
        
        <!-- Previous Page -->
        <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
            <a class="page-link" href="<%= baseUrl %><%= currentPage - 1 %>" aria-label="Trước">
                <i class="fas fa-angle-left"></i>
            </a>
        </li>
        
        <!-- Page Numbers -->
        <% for (int i = startPage; i <= endPage; i++) { %>
        <li class="page-item <%= i == currentPage ? "active" : "" %>">
            <a class="page-link" href="<%= baseUrl %><%= i %>"><%= i %></a>
        </li>
        <% } %>
        
        <!-- Next Page -->
        <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
            <a class="page-link" href="<%= baseUrl %><%= currentPage + 1 %>" aria-label="Sau">
                <i class="fas fa-angle-right"></i>
            </a>
        </li>
        
        <!-- Last Page -->
        <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
            <a class="page-link" href="<%= baseUrl %><%= totalPages %>" aria-label="Cuối">
                <i class="fas fa-angle-double-right"></i>
            </a>
        </li>
    </ul>
</nav>
