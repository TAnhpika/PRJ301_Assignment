<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff.css">
    <%@page import="model.User" %>
        <%@page import="model.Staff" %>
            <%-- Staff Header Component - Bootstrap Version Unified UI/UX Dashboard Header --%>

                <% User currentUser=(User) session.getAttribute("user"); Staff currentStaff=(Staff)
                    session.getAttribute("staff"); String userName=currentStaff !=null ? currentStaff.getFullName() :
                    (currentUser !=null ? currentUser.getUsername() : "Nhân viên" ); String userAvatar=currentUser
                    !=null && currentUser.getAvatar() !=null ? currentUser.getAvatar() : request.getContextPath()
                    + "/img/default-avatar.png" ; %>

                    <!-- Sidebar Toggle Button (Mobile) -->
                    <button class="sidebar-toggle" onclick="toggleSidebar()">
                        <i class="fas fa-bars"></i>
                    </button>

                    <!-- Dashboard Header -->
                    <header class="dashboard-header">
                        <div class="header-left">
                            <div class="header-search">
                                <i class="fas fa-search"></i>
                                <input type="text" placeholder="Tìm kiếm bệnh nhân, lịch hẹn..." class="form-control">
                            </div>
                        </div>

                        <div class="header-right">
                            <!-- Notifications -->
                            <div class="header-notification" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-bell"></i>
                                <span class="notification-badge">5</span>
                            </div>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <h6 class="dropdown-header">Thông báo</h6>
                                </li>
                                <li><a class="dropdown-item" href="#">
                                        <i class="fas fa-calendar-plus text-primary me-2"></i>
                                        Lịch hẹn mới cần xử lý
                                    </a></li>
                                <li><a class="dropdown-item" href="#">
                                        <i class="fas fa-user-clock text-warning me-2"></i>
                                        3 bệnh nhân đang chờ
                                    </a></li>
                                <li><a class="dropdown-item" href="#">
                                        <i class="fas fa-file-invoice-dollar text-success me-2"></i>
                                        Hóa đơn cần thanh toán
                                    </a></li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li><a class="dropdown-item text-center" href="#">Xem tất cả</a></li>
                            </ul>

                            <!-- User Profile -->
                            <div class="header-user">
                                <img src="<%= userAvatar %>" alt="Avatar"
                                    onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                                <div class="header-user-info">
                                    <span class="header-user-name">
                                        <%= userName %>
                                    </span>
                                    <span class="header-user-role">Nhân viên</span>
                                </div>
                                <div class="header-dropdown">
                                    <a href="${pageContext.request.contextPath}/StaffProfileServlet">
                                        <i class="fas fa-user"></i> Tài khoản của tôi
                                    </a>
                                    <a href="${pageContext.request.contextPath}/jsp/staff/staff_caidat.jsp">
                                        <i class="fas fa-cog"></i> Cài đặt
                                    </a>

                                </div>
                            </div>
                        </div>
                    </header>