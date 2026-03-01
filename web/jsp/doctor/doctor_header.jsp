<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@page import="model.User" %>
        <%@page import="model.Doctors" %>
            <%-- Doctor Header Component - Bootstrap Version Unified UI/UX Dashboard Header --%>

                <% User currentUser=(User) session.getAttribute("user"); Doctors currentDoctor=(Doctors)
                    session.getAttribute("doctor"); String userName=currentDoctor !=null ? currentDoctor.getFullName() :
                    (currentUser !=null ? currentUser.getUsername() : "Bác sĩ" ); String userAvatar=currentUser !=null
                    && currentUser.getAvatar() !=null ? currentUser.getAvatar() : request.getContextPath()
                    + "/view/assets/img/default-avatar.png" ; %>

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
                            <div class="header-user" onclick="toggleUserDropdown(event)">
                                <img src="<%= userAvatar %>" alt="Avatar">
                                <div class="header-user-info">
                                    <span class="header-user-name">
                                        <%= userName %>
                                    </span>
                                    <span class="header-user-role">Bác sĩ</span>
                                </div>
                                <div class="header-dropdown">
                                    <a href="${pageContext.request.contextPath}/doctor_trangcanhan">
                                        <i class="fas fa-user"></i> Trang cá nhân
                                    </a>
                                    <a href="${pageContext.request.contextPath}/EditDoctorServlet">
                                        <i class="fas fa-cog"></i> Cài đặt
                                    </a>
                                    <hr class="m-0 opacity-10">
                                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="text-danger">
                                        <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                    </a>
                                </div>
                            </div>
                        </div>
                    </header>