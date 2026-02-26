<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Loading Spinner Component
    Reusable loading spinner/overlay
    
    Usage (inline spinner):
    <jsp:include page="/includes/components/loading_spinner.jsp">
        <jsp:param name="type" value="inline"/>
        <jsp:param name="size" value="sm"/>
        <jsp:param name="text" value="Đang tải..."/>
    </jsp:include>
    
    Usage (overlay spinner):
    <jsp:include page="/includes/components/loading_spinner.jsp">
        <jsp:param name="type" value="overlay"/>
        <jsp:param name="id" value="loadingOverlay"/>
    </jsp:include>
    
    Types: inline, overlay, button
    Sizes: sm, md, lg
--%>
<%
    String type = request.getParameter("type");
    String size = request.getParameter("size");
    String text = request.getParameter("text");
    String id = request.getParameter("id");
    String color = request.getParameter("color");
    
    if (type == null) type = "inline";
    if (size == null) size = "md";
    if (text == null) text = "";
    if (id == null) id = "loadingSpinner";
    if (color == null) color = "primary";
    
    String spinnerSize = "";
    if ("sm".equals(size)) spinnerSize = "spinner-border-sm";
%>

<% if ("inline".equals(type)) { %>
<div class="d-flex align-items-center justify-content-center py-4" id="<%= id %>">
    <div class="spinner-border text-<%= color %> <%= spinnerSize %>" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
    <% if (!text.isEmpty()) { %>
    <span class="ms-2 text-muted"><%= text %></span>
    <% } %>
</div>
<% } else if ("overlay".equals(type)) { %>
<div class="loading-overlay d-none" id="<%= id %>">
    <div class="text-center">
        <div class="spinner-border text-<%= color %> mb-3" style="width: 48px; height: 48px;" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <p class="text-muted mb-0"><%= text.isEmpty() ? "Đang xử lý..." : text %></p>
    </div>
</div>
<style>
    #<%= id %> {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(255, 255, 255, 0.9);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 9999;
    }
    #<%= id %>.d-none { display: none !important; }
</style>
<% } else if ("button".equals(type)) { %>
<span class="spinner-border <%= spinnerSize %>" role="status" aria-hidden="true"></span>
<% if (!text.isEmpty()) { %><span class="ms-1"><%= text %></span><% } %>
<% } %>
