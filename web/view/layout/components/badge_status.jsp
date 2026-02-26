<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Badge Status Component
    Reusable status badge with icon
    
    Usage:
    <jsp:include page="/includes/components/badge_status.jsp">
        <jsp:param name="status" value="completed"/>
        <jsp:param name="text" value="Hoàn thành"/>
        <jsp:param name="showIcon" value="true"/>
    </jsp:include>
    
    Statuses: pending, confirmed, completed, cancelled, processing, active, inactive
    Or use custom variant: primary, success, warning, danger, info, secondary
--%>
<%
    String status = request.getParameter("status");
    String text = request.getParameter("text");
    String showIcon = request.getParameter("showIcon");
    String variant = request.getParameter("variant");
    String size = request.getParameter("size");
    
    if (status == null) status = "pending";
    if (showIcon == null) showIcon = "true";
    if (size == null) size = "md";
    
    // Determine variant and default text based on status
    String badgeClass = "";
    String icon = "";
    String defaultText = "";
    
    switch (status.toLowerCase()) {
        case "pending":
        case "waiting":
            badgeClass = "badge-warning";
            icon = "fa-clock";
            defaultText = "Chờ xử lý";
            break;
        case "confirmed":
        case "approved":
            badgeClass = "badge-primary";
            icon = "fa-check";
            defaultText = "Đã xác nhận";
            break;
        case "completed":
        case "done":
        case "success":
            badgeClass = "badge-success";
            icon = "fa-check-circle";
            defaultText = "Hoàn thành";
            break;
        case "cancelled":
        case "rejected":
        case "failed":
            badgeClass = "badge-danger";
            icon = "fa-times-circle";
            defaultText = "Đã hủy";
            break;
        case "processing":
        case "in_progress":
            badgeClass = "badge-primary";
            icon = "fa-spinner fa-spin";
            defaultText = "Đang xử lý";
            break;
        case "active":
            badgeClass = "badge-success";
            icon = "fa-check";
            defaultText = "Hoạt động";
            break;
        case "inactive":
            badgeClass = "badge-secondary";
            icon = "fa-ban";
            defaultText = "Không hoạt động";
            break;
        default:
            // Use variant if provided
            if (variant != null) {
                badgeClass = "badge-" + variant;
            } else {
                badgeClass = "badge-secondary";
            }
            icon = "fa-circle";
            defaultText = status;
    }
    
    if (text == null || text.isEmpty()) text = defaultText;
    
    String sizeClass = "sm".equals(size) ? "badge-sm" : "";
%>

<span class="badge-dashboard <%= badgeClass %> <%= sizeClass %>">
    <% if ("true".equals(showIcon)) { %>
    <i class="fas <%= icon %> me-1"></i>
    <% } %>
    <%= text %>
</span>
