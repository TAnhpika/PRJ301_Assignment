<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Doctor Card Component
    Reusable doctor profile card
    
    Usage:
    <jsp:include page="/includes/components/doctor_card.jsp">
        <jsp:param name="doctorName" value="BS. Nguyễn Văn A"/>
        <jsp:param name="specialty" value="Nha khoa tổng quát"/>
        <jsp:param name="experience" value="10 năm"/>
        <jsp:param name="avatar" value="/img/doctors/doctor1.jpg"/>
        <jsp:param name="rating" value="4.8"/>
        <jsp:param name="bookUrl" value="/book?doctor=1"/>
        <jsp:param name="profileUrl" value="/doctor/1"/>
    </jsp:include>
--%>
<%
    String doctorName = request.getParameter("doctorName");
    String specialty = request.getParameter("specialty");
    String experience = request.getParameter("experience");
    String avatar = request.getParameter("avatar");
    String rating = request.getParameter("rating");
    String bookUrl = request.getParameter("bookUrl");
    String profileUrl = request.getParameter("profileUrl");
    String colClass = request.getParameter("colClass");
    String status = request.getParameter("status");
    
    if (doctorName == null) doctorName = "Bác sĩ";
    if (colClass == null) colClass = "col-12 col-md-6 col-lg-4";
    if (status == null) status = "available";
    
    String defaultAvatar = request.getContextPath() + "/img/default-doctor.jpg";
    String avatarSrc = (avatar != null && !avatar.isEmpty()) ? avatar : defaultAvatar;
    
    // Parse rating
    double ratingValue = 0;
    try {
        if (rating != null) ratingValue = Double.parseDouble(rating);
    } catch (Exception e) {}
%>

<div class="<%= colClass %>">
    <div class="dashboard-card doctor-card h-100 text-center">
        <div class="position-relative d-inline-block mb-3">
            <img src="<%= avatarSrc %>" 
                 alt="<%= doctorName %>" 
                 class="rounded-circle"
                 style="width: 100px; height: 100px; object-fit: cover; border: 3px solid var(--border-color);"
                 onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
            <% if ("available".equals(status)) { %>
            <span class="position-absolute bottom-0 end-0 bg-success rounded-circle border border-2 border-white" 
                  style="width: 20px; height: 20px;"
                  title="Đang làm việc"></span>
            <% } %>
        </div>
        
        <h5 class="mb-1"><%= doctorName %></h5>
        
        <% if (specialty != null && !specialty.isEmpty()) { %>
        <p class="text-primary mb-2"><%= specialty %></p>
        <% } %>
        
        <% if (experience != null && !experience.isEmpty()) { %>
        <p class="text-muted small mb-2">
            <i class="fas fa-briefcase me-1"></i>Kinh nghiệm: <%= experience %>
        </p>
        <% } %>
        
        <% if (ratingValue > 0) { %>
        <div class="mb-3">
            <% for (int i = 1; i <= 5; i++) { %>
            <i class="fas fa-star <%= i <= ratingValue ? "text-warning" : "text-muted" %>"></i>
            <% } %>
            <span class="ms-1 small text-muted">(<%= rating %>)</span>
        </div>
        <% } %>
        
        <div class="d-flex gap-2 justify-content-center">
            <% if (profileUrl != null && !profileUrl.isEmpty()) { %>
            <a href="${pageContext.request.contextPath}<%= profileUrl %>" 
               class="btn-dashboard btn-dashboard-secondary btn-sm">
                <i class="fas fa-user me-1"></i>Xem hồ sơ
            </a>
            <% } %>
            <% if (bookUrl != null && !bookUrl.isEmpty()) { %>
            <a href="${pageContext.request.contextPath}<%= bookUrl %>" 
               class="btn-dashboard btn-dashboard-primary btn-sm">
                <i class="fas fa-calendar-plus me-1"></i>Đặt lịch
            </a>
            <% } %>
        </div>
    </div>
</div>
