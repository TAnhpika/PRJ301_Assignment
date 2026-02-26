<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Activity Item Component
    Reusable activity/timeline item
    
    Usage:
    <jsp:include page="/includes/components/activity_item.jsp">
        <jsp:param name="time" value="10:30 AM"/>
        <jsp:param name="description" value="Bác sĩ Nguyễn Văn A đã cập nhật hồ sơ"/>
        <jsp:param name="status" value="completed"/>
        <jsp:param name="statusText" value="Hoàn thành"/>
    </jsp:include>
--%>
<%
    String time = request.getParameter("time");
    String description = request.getParameter("description");
    String status = request.getParameter("status");
    String statusText = request.getParameter("statusText");
    String icon = request.getParameter("icon");
    String user = request.getParameter("user");
    String userAvatar = request.getParameter("userAvatar");
    
    if (time == null) time = "";
    if (description == null) description = "Hoạt động";
    if (status == null) status = "completed";
    if (statusText == null) statusText = "";
    
    // Determine badge class based on status
    String badgeClass = "badge-success";
    String defaultStatusText = "Hoàn thành";
    switch (status.toLowerCase()) {
        case "pending":
            badgeClass = "badge-warning";
            defaultStatusText = "Chờ xử lý";
            break;
        case "processing":
            badgeClass = "badge-primary";
            defaultStatusText = "Đang xử lý";
            break;
        case "cancelled":
            badgeClass = "badge-danger";
            defaultStatusText = "Đã hủy";
            break;
        case "system":
            badgeClass = "badge-primary";
            defaultStatusText = "Hệ thống";
            break;
    }
    if (statusText.isEmpty()) statusText = defaultStatusText;
%>

<tr>
    <td>
        <small class="text-muted"><%= time %></small>
    </td>
    <td>
        <% if (user != null && !user.isEmpty()) { %>
        <div class="d-flex align-items-center">
            <% if (userAvatar != null && !userAvatar.isEmpty()) { %>
            <img src="<%= userAvatar %>" alt="<%= user %>" class="rounded-circle me-2" style="width: 24px; height: 24px; object-fit: cover;">
            <% } %>
            <span><%= description %></span>
        </div>
        <% } else { %>
        <%= description %>
        <% } %>
    </td>
    <td>
        <span class="badge-dashboard <%= badgeClass %>"><%= statusText %></span>
    </td>
</tr>
