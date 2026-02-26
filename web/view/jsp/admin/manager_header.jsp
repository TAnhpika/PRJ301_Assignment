<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/manager.css">
    <%@page import="model.User" %>
        <%-- Manager Header Component - Bootstrap Version Unified UI/UX Dashboard Header --%>

            <% User currentUser=(User) session.getAttribute("user"); String userName=currentUser !=null ?
                currentUser.getUsername() : "Manager" ; String userAvatar=currentUser !=null && currentUser.getAvatar()
                !=null ? currentUser.getAvatar() : request.getContextPath() + "/view/assets/img/default-avatar.png" ; %>

                <!-- Sidebar Toggle Button (Mobile) -->
                <button class="sidebar-toggle" onclick="toggleSidebar()">
                    <i class="fas fa-bars"></i>
                </button>

                <!-- Dashboard Header -->
                <header class="dashboard-header">
                    <div class="header-left">
                        <div class="header-search">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Tìm kiếm..." class="form-control">
                        </div>
                    </div>

                    <div class="header-right">
                        <!-- Notifications -->
                        <div class="header-notification" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-bell"></i>
                            <span class="notification-badge">3</span>
                        </div>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <h6 class="dropdown-header">Thông báo</h6>
                            </li>
                            <li><a class="dropdown-item" href="#">
                                    <i class="fas fa-user-plus text-primary me-2"></i>
                                    Nhân viên mới đăng ký lịch
                                </a></li>
                            <li><a class="dropdown-item" href="#">
                                    <i class="fas fa-calendar-check text-success me-2"></i>
                                    Có 5 lịch hẹn hôm nay
                                </a></li>
                            <li><a class="dropdown-item" href="#">
                                    <i class="fas fa-chart-line text-info me-2"></i>
                                    Báo cáo doanh thu tuần
                                </a></li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li><a class="dropdown-item text-center" href="#">Xem tất cả</a></li>
                        </ul>

                        <!-- User Profile -->
                        <div class="header-user">
                            <img src="<%= userAvatar %>" alt="Avatar"
                                onerror="this.src='${pageContext.request.contextPath}/view/assets/img/default-avatar.png'">
                            <div class="header-user-info">
                                <span class="header-user-name">
                                    <%= userName %>
                                </span>
                                <span class="header-user-role">Quản lý</span>
                            </div>
                            <div class="header-dropdown">
                                <a href="${pageContext.request.contextPath}/jsp/manager/manager_trangcanhan.jsp">
                                    <i class="fas fa-user"></i> Trang cá nhân
                                </a>
                                <a href="${pageContext.request.contextPath}/jsp/manager/manager_caidat.jsp">
                                    <i class="fas fa-cog"></i> Cài đặt
                                </a>
                            </div>
                        </div>
                    </div>
                </header>