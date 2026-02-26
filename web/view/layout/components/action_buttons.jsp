<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Action Buttons Component
    Reusable action button group (view, edit, delete)
    
    Usage:
    <jsp:include page="/includes/components/action_buttons.jsp">
        <jsp:param name="viewUrl" value="/detail?id=1"/>
        <jsp:param name="editUrl" value="/edit?id=1"/>
        <jsp:param name="deleteUrl" value="/delete?id=1"/>
        <jsp:param name="showView" value="true"/>
        <jsp:param name="showEdit" value="true"/>
        <jsp:param name="showDelete" value="true"/>
        <jsp:param name="deleteConfirm" value="Bạn có chắc muốn xóa?"/>
        <jsp:param name="size" value="sm"/>
    </jsp:include>
--%>
<%
    String viewUrl = request.getParameter("viewUrl");
    String editUrl = request.getParameter("editUrl");
    String deleteUrl = request.getParameter("deleteUrl");
    String showView = request.getParameter("showView");
    String showEdit = request.getParameter("showEdit");
    String showDelete = request.getParameter("showDelete");
    String deleteConfirm = request.getParameter("deleteConfirm");
    String size = request.getParameter("size");
    String customActions = request.getParameter("customActions");
    
    if (showView == null) showView = viewUrl != null ? "true" : "false";
    if (showEdit == null) showEdit = editUrl != null ? "true" : "false";
    if (showDelete == null) showDelete = deleteUrl != null ? "true" : "false";
    if (deleteConfirm == null) deleteConfirm = "Bạn có chắc chắn muốn xóa?";
    if (size == null) size = "sm";
    
    String btnSize = "btn-" + size;
%>

<div class="btn-group" role="group">
    <% if ("true".equals(showView) && viewUrl != null) { %>
    <a href="${pageContext.request.contextPath}<%= viewUrl %>" 
       class="btn btn-outline-primary <%= btnSize %>" 
       title="Xem chi tiết"
       data-bs-toggle="tooltip">
        <i class="fas fa-eye"></i>
    </a>
    <% } %>
    
    <% if ("true".equals(showEdit) && editUrl != null) { %>
    <a href="${pageContext.request.contextPath}<%= editUrl %>" 
       class="btn btn-outline-warning <%= btnSize %>" 
       title="Chỉnh sửa"
       data-bs-toggle="tooltip">
        <i class="fas fa-edit"></i>
    </a>
    <% } %>
    
    <% if ("true".equals(showDelete) && deleteUrl != null) { %>
    <a href="${pageContext.request.contextPath}<%= deleteUrl %>" 
       class="btn btn-outline-danger <%= btnSize %>" 
       title="Xóa"
       data-bs-toggle="tooltip"
       onclick="return confirmAction('<%= deleteConfirm %>', () => { window.location.href = this.href; }), false;">
        <i class="fas fa-trash"></i>
    </a>
    <% } %>
</div>
