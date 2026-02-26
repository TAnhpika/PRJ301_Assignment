<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Staff" %>

<%
    User user = (User) session.getAttribute("user");
    Staff staff = (Staff) session.getAttribute("staff");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    String staffName = staff != null ? staff.getFullName() : (user != null ? user.getUsername() : "Nhân viên");
    String staffAvatar = user != null && user.getAvatar() != null 
        ? user.getAvatar() 
        : request.getContextPath() + "/img/default-avatar.png";
%>

                <!DOCTYPE html>
<html lang="vi">
                <head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Tổng quan - Staff Dashboard</title>
</head>
<body>
    <div class="dashboard-wrapper">
        <!-- Sidebar Menu -->
        <%@ include file="/jsp/staff/staff_menu.jsp" %>
        
        <!-- Main Content -->
        <main class="dashboard-main">
            <!-- Header -->
            <%@ include file="/jsp/staff/staff_header.jsp" %>
            
            <!-- Page Content -->
            <div class="dashboard-content">
                <!-- Page Title -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1">Trang chủ</h4>
                        <p class="text-muted mb-0">Chào mừng trở lại, <%= staffName %>!</p>
                    </div>
                    <div>
                        <span class="badge bg-light text-dark">
                            <i class="fas fa-calendar me-1"></i>
                            <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
                        </span>
                    </div>
                </div>
                
                <!-- Stats Cards Row -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-card-value">12</div>
                            <div class="stat-card-label">Lịch hẹn hôm nay</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-card-value">5</div>
                            <div class="stat-card-label">Bệnh nhân chờ khám</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-file-invoice-dollar"></i>
                            </div>
                            <div class="stat-card-value">8</div>
                            <div class="stat-card-label">Hóa đơn chờ xử lý</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-comments"></i>
                            </div>
                            <div class="stat-card-value">3</div>
                            <div class="stat-card-label">Yêu cầu tư vấn</div>
                        </div>
                            </div>
                        </div>

                <!-- Main Content Row -->
                <div class="row g-4">
                    <!-- Staff Info Card -->
                    <div class="col-12 col-lg-4">
                        <div class="dashboard-card">
                            <div class="text-center mb-4">
                                <img src="<%= staffAvatar %>" alt="Avatar" 
                                     class="rounded-circle mb-3"
                                     style="width: 80px; height: 80px; object-fit: cover; border: 3px solid var(--primary-color);"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                                <h5 class="mb-1"><%= staffName %></h5>
                                <span class="badge-dashboard badge-primary">Nhân viên lễ tân</span>
                            </div>
                            <div class="border-top pt-3">
                                <div class="d-flex align-items-center mb-3">
                                    <i class="fas fa-phone text-primary me-3"></i>
                                    <div>
                                        <small class="text-muted d-block">Số điện thoại</small>
                                        <span><%= staff != null ? staff.getPhone() : "Chưa cập nhật" %></span>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center mb-3">
                                    <i class="fas fa-envelope text-primary me-3"></i>
                                    <div>
                                        <small class="text-muted d-block">Email</small>
                                        <span><%= user != null ? user.getEmail() : "Chưa cập nhật" %></span>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center">
                                    <i class="fas fa-circle text-success me-3"></i>
                                    <div>
                                        <small class="text-muted d-block">Trạng thái</small>
                                        <span class="text-success">Đang trực</span>
                            </div>
                                </div>
                            </div>
                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/StaffProfileServlet" class="btn-dashboard btn-dashboard-secondary w-100">
                                    <i class="fas fa-cog"></i> Cài đặt tài khoản
                                </a>
                            </div>
                            </div>
                        </div>

                    <!-- Today's Appointments -->
                    <div class="col-12 col-lg-8">
                        <div class="dashboard-card">
                            <div class="dashboard-card-header">
                                <h5 class="dashboard-card-title">
                                    <i class="fas fa-calendar-alt text-primary me-2"></i>
                                    Lịch hẹn hôm nay
                                </h5>
                                <a href="${pageContext.request.contextPath}/StaffBookingServlet" class="btn-dashboard btn-dashboard-primary btn-sm">
                                    <i class="fas fa-plus"></i> Đặt lịch mới
                                </a>
                            </div>
                            <div class="table-responsive">
                                <table class="dashboard-table">
                                    <thead>
                                        <tr>
                                            <th>Bệnh nhân</th>
                                            <th>Thời gian</th>
                                            <th>Dịch vụ</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}/img/default-avatar.png" 
                                                         class="rounded-circle me-2" 
                                                         style="width: 32px; height: 32px; object-fit: cover;">
                                                    <span>Trần Thị B</span>
                                                </div>
                                            </td>
                                            <td>09:00</td>
                                            <td>Khám tổng quát</td>
                                            <td><span class="badge-dashboard badge-success">Đã xác nhận</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary"><i class="fas fa-eye"></i></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}/img/default-avatar.png" 
                                                         class="rounded-circle me-2" 
                                                         style="width: 32px; height: 32px; object-fit: cover;">
                                                    <span>Lê Văn C</span>
                                                </div>
                                            </td>
                                            <td>10:30</td>
                                            <td>Tư vấn răng</td>
                                            <td><span class="badge-dashboard badge-warning">Chờ thanh toán</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary"><i class="fas fa-eye"></i></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}/img/default-avatar.png" 
                                                         class="rounded-circle me-2" 
                                                         style="width: 32px; height: 32px; object-fit: cover;">
                                                    <span>Nguyễn Văn D</span>
                                                </div>
                                            </td>
                                            <td>14:00</td>
                                            <td>Lấy cao răng</td>
                                            <td><span class="badge-dashboard badge-primary">Đã đặt</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary"><i class="fas fa-eye"></i></button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Consultation Requests -->
                        <div class="dashboard-card mt-4">
                            <div class="dashboard-card-header">
                                <h5 class="dashboard-card-title">
                                    <i class="fas fa-comments text-info me-2"></i>
                                    Yêu cầu tư vấn mới
                                </h5>
                            </div>
                            <div class="list-group list-group-flush">
                                <div class="list-group-item d-flex align-items-start px-0 py-3">
                                    <img src="${pageContext.request.contextPath}/img/default-avatar.png" 
                                         class="rounded-circle me-3" 
                                         style="width: 48px; height: 48px; object-fit: cover;">
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="mb-1">Phạm Thị D</h6>
                                                <p class="mb-1 text-muted small">Tôi muốn tư vấn về dịch vụ niềng răng...</p>
                                            </div>
                                            <small class="text-muted">10 phút trước</small>
                                        </div>
                                        <button class="btn btn-sm btn-outline-primary mt-2">
                                            <i class="fas fa-reply"></i> Phản hồi
                                        </button>
                                    </div>
                                </div>
                                <div class="list-group-item d-flex align-items-start px-0 py-3">
                                    <img src="${pageContext.request.contextPath}/img/default-avatar.png" 
                                         class="rounded-circle me-3" 
                                         style="width: 48px; height: 48px; object-fit: cover;">
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="mb-1">Hoàng Văn E</h6>
                                                <p class="mb-1 text-muted small">Tôi cần tư vấn về giá dịch vụ...</p>
                                            </div>
                                            <small class="text-muted">30 phút trước</small>
                                        </div>
                                        <button class="btn btn-sm btn-outline-primary mt-2">
                                            <i class="fas fa-reply"></i> Phản hồi
                                        </button>
                            </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
                </body>
                </html>
