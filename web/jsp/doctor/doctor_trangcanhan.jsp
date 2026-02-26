<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.Doctors" %>
<%@page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Hồ Sơ Bác Sĩ</title>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/doctor/doctor_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-user-md me-2"></i>Hồ Sơ Cá Nhân</h4>
                        <p class="text-muted mb-0">Thông tin chi tiết về bác sĩ</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/EditDoctorServlet" class="btn btn-primary">
                        <i class="fas fa-edit me-1"></i>Chỉnh sửa
                    </a>
                </div>
                
                <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i><%= request.getAttribute("errorMessage") %>
                </div>
                <% } %>
                
                <% 
                    Object doctor_trangcanhan = request.getAttribute("doctor_trangcanhan");
                    if (doctor_trangcanhan != null) {
                        Doctors doc = (Doctors) doctor_trangcanhan;
                        String gender = doc.getGender();
                        String genderDisplay = "Chưa cập nhật";
                        if ("male".equalsIgnoreCase(gender)) {
                            genderDisplay = "Nam";
                        } else if ("female".equalsIgnoreCase(gender)) {
                            genderDisplay = "Nữ";
                        }
                %>
                
                <div class="row g-4">
                    <!-- Avatar Card -->
                    <div class="col-lg-4">
                        <div class="dashboard-card text-center">
                            <% if (doc.getAvatar() != null && !doc.getAvatar().isEmpty()) { %>
                            <img src="<%= doc.getAvatar() %>" alt="Avatar" class="rounded-circle mb-3"
                                 style="width: 150px; height: 150px; object-fit: cover; border: 4px solid var(--primary-color);"
                                 onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                            <% } else { %>
                            <div class="rounded-circle mx-auto mb-3 d-flex align-items-center justify-content-center"
                                 style="width: 150px; height: 150px; background: #f0f9ff; border: 4px solid var(--primary-color);">
                                <i class="fas fa-user-md text-primary" style="font-size: 64px;"></i>
                            </div>
                            <% } %>
                            
                            <h5 class="mb-1"><%= doc.getFullName() %></h5>
                            <p class="text-muted mb-3">Bác sĩ <%= doc.getSpecialty() %></p>
                            
                            <span class="badge bg-primary">ID: <%= doc.getDoctorId() %></span>
                        </div>
                    </div>
                    
                    <!-- Info Card -->
                    <div class="col-lg-8">
                        <div class="dashboard-card">
                            <h6 class="mb-4"><i class="fas fa-info-circle me-2 text-primary"></i>Thông tin cá nhân</h6>
                            
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded">
                                        <small class="text-muted d-block mb-1">Họ và tên</small>
                                        <strong><%= doc.getFullName() %></strong>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded">
                                        <small class="text-muted d-block mb-1">Chuyên khoa</small>
                                        <strong><%= doc.getSpecialty() %></strong>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded">
                                        <small class="text-muted d-block mb-1">Số điện thoại</small>
                                        <strong><i class="fas fa-phone me-2 text-primary"></i><%= doc.getPhone() %></strong>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded">
                                        <small class="text-muted d-block mb-1">Ngày sinh</small>
                                        <strong><i class="fas fa-birthday-cake me-2 text-primary"></i>
                                            <%= (doc.getDate_of_birth() != null) ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(doc.getDate_of_birth()) : "Chưa cập nhật" %>
                                        </strong>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded">
                                        <small class="text-muted d-block mb-1">Giới tính</small>
                                        <strong><i class="fas fa-venus-mars me-2 text-primary"></i><%= genderDisplay %></strong>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded">
                                        <small class="text-muted d-block mb-1">Mã bác sĩ</small>
                                        <strong><i class="fas fa-id-badge me-2 text-primary"></i><%= doc.getDoctorId() %></strong>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <% } else { %>
                <div class="dashboard-card text-center py-5">
                    <i class="fas fa-user-slash text-muted" style="font-size: 64px;"></i>
                    <h4 class="mt-4 text-muted">Không tìm thấy thông tin bác sĩ</h4>
                    <a href="${pageContext.request.contextPath}/DoctorHomePageServlet" class="btn-dashboard btn-dashboard-primary mt-3">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại trang chủ
                    </a>
                </div>
                <% } %>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
</body>
</html>
