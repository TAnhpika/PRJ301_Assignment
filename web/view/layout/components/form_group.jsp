<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Form Group Component
    Reusable form field with label
    
    Usage:
    <jsp:include page="/includes/components/form_group.jsp">
        <jsp:param name="type" value="text"/>
        <jsp:param name="name" value="username"/>
        <jsp:param name="label" value="Tên đăng nhập"/>
        <jsp:param name="placeholder" value="Nhập tên đăng nhập"/>
        <jsp:param name="required" value="true"/>
        <jsp:param name="value" value=""/>
        <jsp:param name="helpText" value="Tối thiểu 6 ký tự"/>
    </jsp:include>
    
    Types: text, email, password, number, tel, date, time, datetime-local, textarea, select
--%>
<%
    String type = request.getParameter("type");
    String name = request.getParameter("name");
    String label = request.getParameter("label");
    String placeholder = request.getParameter("placeholder");
    String required = request.getParameter("required");
    String value = request.getParameter("value");
    String helpText = request.getParameter("helpText");
    String disabled = request.getParameter("disabled");
    String readonly = request.getParameter("readonly");
    String colClass = request.getParameter("colClass");
    String id = request.getParameter("id");
    String icon = request.getParameter("icon");
    String min = request.getParameter("min");
    String max = request.getParameter("max");
    String step = request.getParameter("step");
    String rows = request.getParameter("rows");
    
    if (type == null) type = "text";
    if (name == null) name = "field";
    if (label == null) label = "";
    if (placeholder == null) placeholder = "";
    if (required == null) required = "false";
    if (value == null) value = "";
    if (disabled == null) disabled = "false";
    if (readonly == null) readonly = "false";
    if (colClass == null) colClass = "";
    if (id == null) id = name;
    if (rows == null) rows = "3";
    
    boolean isRequired = "true".equals(required);
    boolean isDisabled = "true".equals(disabled);
    boolean isReadonly = "true".equals(readonly);
%>

<% if (!colClass.isEmpty()) { %><div class="<%= colClass %>"><% } %>
<div class="form-group mb-3">
    <% if (!label.isEmpty()) { %>
    <label for="<%= id %>" class="form-label">
        <%= label %>
        <% if (isRequired) { %><span class="text-danger">*</span><% } %>
    </label>
    <% } %>
    
    <% if (icon != null && !icon.isEmpty()) { %>
    <div class="input-group">
        <span class="input-group-text"><i class="fas <%= icon %>"></i></span>
    <% } %>
    
    <% if ("textarea".equals(type)) { %>
    <textarea class="form-control" 
              id="<%= id %>" 
              name="<%= name %>"
              placeholder="<%= placeholder %>"
              rows="<%= rows %>"
              <% if (isRequired) { %>required<% } %>
              <% if (isDisabled) { %>disabled<% } %>
              <% if (isReadonly) { %>readonly<% } %>
    ><%= value %></textarea>
    <% } else if ("select".equals(type)) { %>
    <select class="form-select" 
            id="<%= id %>" 
            name="<%= name %>"
            <% if (isRequired) { %>required<% } %>
            <% if (isDisabled) { %>disabled<% } %>>
        <% if (!placeholder.isEmpty()) { %>
        <option value="" disabled selected><%= placeholder %></option>
        <% } %>
        <!-- Options should be added separately -->
    </select>
    <% } else { %>
    <input type="<%= type %>" 
           class="form-control" 
           id="<%= id %>" 
           name="<%= name %>"
           placeholder="<%= placeholder %>"
           value="<%= value %>"
           <% if (isRequired) { %>required<% } %>
           <% if (isDisabled) { %>disabled<% } %>
           <% if (isReadonly) { %>readonly<% } %>
           <% if (min != null) { %>min="<%= min %>"<% } %>
           <% if (max != null) { %>max="<%= max %>"<% } %>
           <% if (step != null) { %>step="<%= step %>"<% } %>
    >
    <% } %>
    
    <% if (icon != null && !icon.isEmpty()) { %>
    </div>
    <% } %>
    
    <% if (helpText != null && !helpText.isEmpty()) { %>
    <div class="form-text text-muted"><%= helpText %></div>
    <% } %>
</div>
<% if (!colClass.isEmpty()) { %></div><% } %>
