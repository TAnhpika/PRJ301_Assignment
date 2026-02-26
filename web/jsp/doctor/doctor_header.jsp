<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@page import="model.User" %>
        <%@page import="model.Doctors" %>
            <%-- Doctor Header Component - Bootstrap Version Unified UI/UX Dashboard Header --%>

                <% User currentUser=(User) session.getAttribute("user"); Doctors currentDoctor=(Doctors)
                    session.getAttribute("doctor"); String userName=currentDoctor !=null ? currentDoctor.getFullName() :
                    (currentUser !=null ? currentUser.getUsername() : "Bác sĩ" ); String userAvatar=currentUser !=null
                    && currentUser.getAvatar() !=null ? currentUser.getAvatar() : request.getContextPath()
                    + "/img/default-avatar.png" ; %>

                    <!-- Sidebar Toggle Button (Mobile) -->
                    <button class="btn btn-primary sidebar-toggle" onclick="toggleSidebar()">
                        <i class="fas fa-bars"></i>
                    </button>

                    <!-- Dashboard Header -->
                    <header class="dashboard-header d-flex justify-content-between align-items-center">
                        <div class="flex-grow-1"></div>

                        <div class="d-flex align-items-center gap-3">
                            <!-- Notifications -->
                            <div class="dropdown">
                                <button class="btn btn-light position-relative" data-bs-toggle="dropdown">
                                    <i class="fas fa-bell"></i>
                                    <span
                                        class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                        4
                                    </span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li>
                                        <h6 class="dropdown-header">Thông báo</h6>
                                    </li>
                                    <li><a class="dropdown-item" href="#">
                                            <i class="fas fa-user-clock text-primary me-2"></i>
                                            Có 3 bệnh nhân đang chờ khám
                                        </a></li>
                                    <li><a class="dropdown-item" href="#">
                                            <i class="fas fa-calendar-check text-success me-2"></i>
                                            Lịch tái khám mới
                                        </a></li>
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>
                                    <li><a class="dropdown-item text-center" href="#">Xem tất cả</a></li>
                                </ul>
                            </div>

                            <!-- User Profile -->
                            <div class="dropdown">
                                <button class="btn btn-light d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                                    <img src="<%= userAvatar %>" alt="Avatar" class="rounded-circle"
                                        style="width: 32px; height: 32px; object-fit: cover;"
                                        onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                                    <div class="text-start d-none d-md-block">
                                        <div class="fw-semibold small">
                                            <%= userName %>
                                        </div>
                                        <div class="text-muted" style="font-size: 0.75rem;">Bác sĩ</div>
                                    </div>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item"
                                            href="${pageContext.request.contextPath}/doctor_trangcanhan">
                                            <i class="fas fa-user me-2"></i>Trang cá nhân
                                        </a></li>
                                    <li><a class="dropdown-item"
                                            href="${pageContext.request.contextPath}/EditDoctorServlet">
                                            <i class="fas fa-cog me-2"></i> Cài đặt
                                        </a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/LogoutServlet">
                                            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                        </a></li>
                                </ul>
                            </div>
                        </div>
                    </header>