<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Back Button Component
    Reusable back navigation button
    
    Usage:
    <jsp:include page="/includes/components/back_button.jsp">
        <jsp:param name="url" value="/home"/>
        <jsp:param name="text" value="Quay lại"/>
        <jsp:param name="variant" value="secondary"/>
    </jsp:include>
    
    Or use JavaScript back:
    <jsp:include page="/includes/components/back_button.jsp">
        <jsp:param name="useHistory" value="true"/>
    </jsp:include>
--%>
<%
    String url = request.getParameter("url");
    String text = request.getParameter("text");
    String variant = request.getParameter("variant");
    String useHistory = request.getParameter("useHistory");
    String icon = request.getParameter("icon");
    String size = request.getParameter("size");
    
    if (text == null) text = "Quay lại";
    if (variant == null) variant = "secondary";
    if (useHistory == null) useHistory = "false";
    if (icon == null) icon = "fa-arrow-left";
    if (size == null) size = "";
    
    String btnSize = "";
    if ("sm".equals(size)) btnSize = "btn-sm";
    else if ("lg".equals(size)) btnSize = "btn-lg";
%>

<% if ("true".equals(useHistory)) { %>
<button type="button" 
        class="btn-dashboard btn-dashboard-<%= variant %> <%= btnSize %>" 
        onclick="window.history.back()">
    <i class="fas <%= icon %> me-1"></i>
    <%= text %>
</button>
<% } else if (url != null && !url.isEmpty()) { %>
<a href="${pageContext.request.contextPath}<%= url %>" 
   class="btn-dashboard btn-dashboard-<%= variant %> <%= btnSize %>">
    <i class="fas <%= icon %> me-1"></i>
    <%= text %>
</a>
<% } %>
