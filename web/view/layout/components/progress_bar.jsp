<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Progress Bar Component
    Reusable progress bar
    
    Usage:
    <jsp:include page="/includes/components/progress_bar.jsp">
        <jsp:param name="value" value="75"/>
        <jsp:param name="label" value="Hoàn thành"/>
        <jsp:param name="variant" value="success"/>
        <jsp:param name="showPercent" value="true"/>
        <jsp:param name="striped" value="true"/>
        <jsp:param name="animated" value="true"/>
    </jsp:include>
--%>
<%
    String value = request.getParameter("value");
    String label = request.getParameter("label");
    String variant = request.getParameter("variant");
    String showPercent = request.getParameter("showPercent");
    String striped = request.getParameter("striped");
    String animated = request.getParameter("animated");
    String height = request.getParameter("height");
    
    if (value == null) value = "0";
    if (variant == null) variant = "primary";
    if (showPercent == null) showPercent = "true";
    if (striped == null) striped = "false";
    if (animated == null) animated = "false";
    if (height == null) height = "20";
    
    int progressValue = 0;
    try {
        progressValue = Integer.parseInt(value);
    } catch (Exception e) {}
    
    String barClass = "progress-bar bg-" + variant;
    if ("true".equals(striped)) barClass += " progress-bar-striped";
    if ("true".equals(animated)) barClass += " progress-bar-animated";
%>

<% if (label != null && !label.isEmpty()) { %>
<div class="d-flex justify-content-between mb-1">
    <span class="small"><%= label %></span>
    <% if ("true".equals(showPercent)) { %>
    <span class="small text-muted"><%= value %>%</span>
    <% } %>
</div>
<% } %>
<div class="progress" style="height: <%= height %>px;">
    <div class="<%= barClass %>" 
         role="progressbar" 
         style="width: <%= value %>%;" 
         aria-valuenow="<%= value %>" 
         aria-valuemin="0" 
         aria-valuemax="100">
        <% if (!"true".equals(showPercent) && label == null) { %>
        <%= value %>%
        <% } %>
    </div>
</div>
