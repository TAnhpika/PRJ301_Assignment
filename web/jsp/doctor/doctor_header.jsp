<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%@page import="model.Doctors" %>
<% 
    User currentUser=(User) session.getAttribute("user"); 
    Doctors currentDoctor=(Doctors) session.getAttribute("doctor"); 
    String userName = currentDoctor != null ? currentDoctor.getFullName() : (currentUser != null ? currentUser.getUsername() : "Bác sĩ"); 
    String userAvatar = (currentUser != null && currentUser.getAvatar() != null && !currentUser.getAvatar().isEmpty()) 
        ? (currentUser.getAvatar().startsWith("http") ? currentUser.getAvatar() : request.getContextPath() + currentUser.getAvatar()) 
        : request.getContextPath() + "/view/assets/img/default-avatar.png"; 
%>

<style>
    /* Reset and Override for Header */
    .dashboard-header {
        display: flex !important;
        justify-content: space-between !important;
        align-items: center !important;
        padding: 0 30px !important; /* Tăng padding để không bị sát lề */
        background: #ffffff !important;
        height: 70px !important;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05) !important;
        border-bottom: 1px solid #edf2f7;
        position: fixed;
        top: 0;
        right: 0;
        left: 260px; /* Sidebar width */
        z-index: 1000;
    }

    .header-left-side {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .header-right-side {
        display: flex;
        align-items: center;
        gap: 25px; /* Khoảng cách giữa các icon và profile */
    }

    .mobile-nav-toggle {
        display: none;
        background: none;
        border: none;
        font-size: 20px;
        color: #475569;
        cursor: pointer;
    }

    /* Notification Styling */
    .notif-wrapper {
        position: relative;
    }
    
    .btn-notif {
        background: #f1f5f9;
        border: none;
        width: 42px;
        height: 42px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #64748b;
        transition: all 0.2s;
    }
    
    .btn-notif:hover {
        background: #e2e8f0;
        color: #4E80EE;
    }

    /* User Profile Styling */
    .user-profile-block {
        display: flex;
        align-items: center;
        gap: 12px;
        cursor: pointer;
        padding: 5px 10px;
        border-radius: 12px;
        transition: background 0.2s;
    }

    .user-profile-block:hover {
        background: #f8fafc;
    }

    .user-profile-img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #4E80EE;
    }

    .user-profile-meta {
        display: flex;
        flex-direction: column;
        line-height: 1.2;
    }

    .user-profile-name {
        font-size: 14px;
        font-weight: 700;
        color: #1e293b;
    }

    .user-profile-role {
        font-size: 11px;
        color: #64748b;
        font-weight: 500;
    }

    /* Dropdown UI */
    .user-dropdown-menu {
        display: none;
        position: absolute;
        top: calc(100% + 10px);
        right: 0;
        background: white;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        min-width: 200px;
        padding: 10px 0;
        z-index: 1050;
    }
    
    .user-profile-block.active .user-dropdown-menu {
        display: block;
        animation: slideIn 0.2s ease-out;
    }

    @keyframes slideIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .user-dropdown-menu a {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 10px 20px;
        color: #475569;
        text-decoration: none;
        font-size: 14px;
        transition: all 0.2s;
    }

    .user-dropdown-menu a:hover {
        background: #f8fafc;
        color: #4E80EE;
        padding-left: 25px;
    }

    @media (max-width: 768px) {
        .dashboard-header { left: 0 !important; padding: 0 15px !important; }
        .mobile-nav-toggle { display: block; }
        .user-profile-meta { display: none; }
    }
</style>

<header class="dashboard-header">
    <div class="header-left-side">
        <button class="mobile-nav-toggle" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
        </button>
        <div class="breadcrumb-placeholder d-none d-md-block">
            <span class="text-muted small">Bảng điều khiển / <strong>Bác sĩ</strong></span>
        </div>
    </div>

    <div class="header-right-side">
        <!-- Notifications -->
        <div class="dropdown notif-wrapper">
            <button class="btn btn-notif" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fas fa-bell"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 10px; padding: 3px 6px;">
                    4
                </span>
            </button>
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
        <div class="user-profile-block" onclick="this.classList.toggle('active')">
            <img src="<%= userAvatar %>" alt="Avatar" class="user-profile-img">
            <div class="user-profile-meta">
                <span class="user-profile-name"><%= userName %></span>
                <span class="user-profile-role">Bác sĩ chuyên khoa</span>
            </div>
            <i class="fas fa-chevron-down text-muted ms-1 small"></i>
            
            <div class="user-dropdown-menu">
                <a href="${pageContext.request.contextPath}/doctor_trangcanhan">
                    <i class="fas fa-user-circle"></i> Trang cá nhân
                </a>
                <a href="${pageContext.request.contextPath}/EditDoctorServlet">
                    <i class="fas fa-user-cog"></i> Cài đặt tài khoản
                </a>
                <hr class="mx-3 my-2 opacity-10">
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="text-danger">
                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                </a>
            </div>
        </div>
    </div>
</header>

<script>
    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const profileBlock = document.querySelector('.user-profile-block');
        if (profileBlock && !profileBlock.contains(event.target)) {
            profileBlock.classList.remove('active');
        }
    });

    function toggleUserDropdown(event) {
        event.stopPropagation();
        const profileBlock = document.querySelector('.user-profile-block');
        profileBlock.classList.toggle('active');
    }
</script>