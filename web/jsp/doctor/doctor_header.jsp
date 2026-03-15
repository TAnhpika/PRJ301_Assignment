<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%@page import="model.Doctors" %>
<% 
    User currentUser=(User) session.getAttribute("user"); 
    Doctors currentDoctor=(Doctors) session.getAttribute("doctor"); 
    String userName = currentDoctor != null ? currentDoctor.getFullName() : (currentUser != null ? currentUser.getUsername() : "Bác sĩ"); 
    String userAvatar = (currentUser != null && currentUser.getAvatar() != null && !currentUser.getAvatar().isEmpty()) 
        ? (currentUser.getAvatar().startsWith("http") ? currentUser.getAvatar() : request.getContextPath() + currentUser.getAvatar()) 
        : request.getContextPath() + "/view/assets/img/default-user-avatar.png"; 
%>

<!-- Sidebar Toggle Button (Mobile) -->
<button class="sidebar-toggle" onclick="toggleSidebar()">
    <i class="fas fa-bars"></i>
</button>

<!-- Dashboard Header -->
<header class="dashboard-header">
    <div class="header-left d-none d-md-flex">
        <div class="breadcrumb-placeholder">
            <span class="text-muted small">Bảng điều khiển / <strong>Bác sĩ</strong></span>
        </div>
    </div>

    <div class="header-right">
        <!-- Notifications -->
        <div class="dropdown">
            <div class="header-notification" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fas fa-bell"></i>
                <span class="notification-badge">4</span>
            </div>
            <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 mt-2" style="border-radius: 12px; min-width: 280px;">
                <li><h6 class="dropdown-header py-3">Thông báo mới</h6></li>
                <li><hr class="dropdown-divider m-0"></li>
                <li>
                    <a class="dropdown-item d-flex align-items-center py-3" href="#">
                        <div class="bg-primary-light text-primary rounded-circle p-2 me-3">
                            <i class="fas fa-user-clock"></i>
                        </div>
                        <div>
                            <div class="small fw-bold">Bệnh nhân mới</div>
                            <div class="text-muted small">Có 3 bệnh nhân đang chờ khám</div>
                        </div>
                    </a>
                </li>
                <li>
                    <a class="dropdown-item d-flex align-items-center py-3" href="#">
                        <div class="bg-success-light text-success rounded-circle p-2 me-3">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div>
                            <div class="small fw-bold">Lịch hẹn</div>
                            <div class="text-muted small">Bạn có 1 lịch hẹn vào 2h chiều</div>
                        </div>
                    </a>
                </li>
                <li><hr class="dropdown-divider m-0"></li>
                <li><a class="dropdown-item text-center py-2 small text-primary fw-bold" href="#">Xem tất cả thông báo</a></li>
            </ul>
        </div>

        <!-- User Profile -->
        <div class="header-user" onclick="toggleUserDropdown(event)">
            <img src="<%= userAvatar %>" alt="Avatar">
            <div class="header-user-info">
                <span class="header-user-name"><%= userName %></span>
                <span class="header-user-role">Bác sĩ chuyên khoa</span>
            </div>
            <div class="header-dropdown">
                <a href="${pageContext.request.contextPath}/doctor_trangcanhan">
                    <i class="fas fa-user-circle"></i> Trang cá nhân
                </a>
                <a href="${pageContext.request.contextPath}/EditDoctorServlet">
                    <i class="fas fa-user-cog"></i> Cài đặt tài khoản
                </a>
                <hr class="mx-3 my-2 opacity-10" style="margin: 0;">
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="text-danger">
                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                </a>
            </div>
        </div>
    </div>
</header>