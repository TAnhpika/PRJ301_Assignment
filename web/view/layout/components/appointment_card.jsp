<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Appointment Card Component
    Reusable appointment display card
    
    Usage:
    <jsp:include page="/includes/components/appointment_card.jsp">
        <jsp:param name="patientName" value="Nguyễn Văn A"/>
        <jsp:param name="date" value="01/01/2024"/>
        <jsp:param name="time" value="09:00"/>
        <jsp:param name="service" value="Khám tổng quát"/>
        <jsp:param name="status" value="confirmed"/>
        <jsp:param name="doctorName" value="BS. Trần Văn B"/>
        <jsp:param name="detailUrl" value="/appointment/1"/>
    </jsp:include>
--%>
<%
    String patientName = request.getParameter("patientName");
    String date = request.getParameter("date");
    String time = request.getParameter("time");
    String service = request.getParameter("service");
    String status = request.getParameter("status");
    String doctorName = request.getParameter("doctorName");
    String detailUrl = request.getParameter("detailUrl");
    String patientAvatar = request.getParameter("patientAvatar");
    String note = request.getParameter("note");
    
    if (patientName == null) patientName = "Bệnh nhân";
    if (date == null) date = "";
    if (time == null) time = "";
    if (service == null) service = "";
    if (status == null) status = "pending";
    
    // Status styling
    String statusClass = "";
    String statusText = "";
    String statusIcon = "";
    switch (status.toLowerCase()) {
        case "pending":
            statusClass = "warning";
            statusText = "Chờ xác nhận";
            statusIcon = "fa-clock";
            break;
        case "confirmed":
            statusClass = "primary";
            statusText = "Đã xác nhận";
            statusIcon = "fa-check";
            break;
        case "completed":
            statusClass = "success";
            statusText = "Hoàn thành";
            statusIcon = "fa-check-circle";
            break;
        case "cancelled":
            statusClass = "danger";
            statusText = "Đã hủy";
            statusIcon = "fa-times-circle";
            break;
        default:
            statusClass = "secondary";
            statusText = status;
            statusIcon = "fa-circle";
    }
    
    String defaultAvatar = request.getContextPath() + "/img/default-avatar.png";
    String avatarSrc = (patientAvatar != null && !patientAvatar.isEmpty()) ? patientAvatar : defaultAvatar;
%>

<div class="dashboard-card appointment-card mb-3">
    <div class="d-flex justify-content-between align-items-start">
        <div class="d-flex align-items-center">
            <img src="<%= avatarSrc %>" 
                 alt="<%= patientName %>" 
                 class="rounded-circle me-3"
                 style="width: 48px; height: 48px; object-fit: cover;"
                 onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
            <div>
                <h6 class="mb-1"><%= patientName %></h6>
                <p class="text-muted mb-0 small">
                    <i class="fas fa-tooth me-1"></i><%= service %>
                </p>
            </div>
        </div>
        <span class="badge-dashboard badge-<%= statusClass %>">
            <i class="fas <%= statusIcon %> me-1"></i><%= statusText %>
        </span>
    </div>
    
    <hr class="my-3">
    
    <div class="row g-3">
        <div class="col-6 col-md-3">
            <div class="text-muted small">Ngày khám</div>
            <div class="fw-medium">
                <i class="fas fa-calendar text-primary me-1"></i><%= date %>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="text-muted small">Giờ khám</div>
            <div class="fw-medium">
                <i class="fas fa-clock text-primary me-1"></i><%= time %>
            </div>
        </div>
        <% if (doctorName != null && !doctorName.isEmpty()) { %>
        <div class="col-6 col-md-3">
            <div class="text-muted small">Bác sĩ</div>
            <div class="fw-medium">
                <i class="fas fa-user-md text-primary me-1"></i><%= doctorName %>
            </div>
        </div>
        <% } %>
        <% if (detailUrl != null && !detailUrl.isEmpty()) { %>
        <div class="col-6 col-md-3 text-end">
            <a href="${pageContext.request.contextPath}<%= detailUrl %>" 
               class="btn-dashboard btn-dashboard-primary btn-sm">
                <i class="fas fa-eye me-1"></i>Chi tiết
            </a>
        </div>
        <% } %>
    </div>
    
    <% if (note != null && !note.isEmpty()) { %>
    <div class="mt-3 p-2 bg-light rounded">
        <small class="text-muted"><i class="fas fa-sticky-note me-1"></i>Ghi chú: <%= note %></small>
    </div>
    <% } %>
</div>
