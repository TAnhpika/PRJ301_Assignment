<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Manager Sidebar Menu - Bootstrap Version Unified UI/UX Dashboard Sidebar --%>

        <!-- Dashboard Sidebar -->
        <nav class="dashboard-sidebar" id="sideMenu">
            <!-- Sidebar Header / Logo -->
            <div class="sidebar-header">
                <a href="${pageContext.request.contextPath}/jsp/manager/manager_tongquan.jsp" class="sidebar-logo" title="Về trang chủ">
                    <img src="${pageContext.request.contextPath}/view/assets/img/logo.png" alt="Logo Happy Smile">
                    <span class="sidebar-logo-text">HAPPY <em>Smile</em></span>
                </a>
            </div>

            <!-- Sidebar Menu -->
            <div class="sidebar-menu">
                <!-- Main Section -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Tổng quan</div>

                    <a href="${pageContext.request.contextPath}/jsp/manager/manager_tongquan.jsp" class="sidebar-item">
                        <i class="fas fa-home"></i>
                        <span>Trang chủ</span>
                    </a>
                </div>

                <!-- User Management Section -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Quản lý</div>

                    <div class="sidebar-dropdown">
                        <div class="sidebar-item sidebar-dropdown-toggle" onclick="toggleDropdown(this)">
                            <i class="fas fa-users"></i>
                            <span>Quản lý người dùng</span>
                        </div>
                        <div class="sidebar-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/jsp/manager/manager_danhsach.jsp"
                                class="sidebar-dropdown-item">
                                Danh sách nhân viên
                            </a>
                            <a href="${pageContext.request.contextPath}/jsp/manager/manager_customers.jsp"
                                class="sidebar-dropdown-item">
                                Danh sách khách hàng
                            </a>
                            <a href="${pageContext.request.contextPath}/jsp/manager/manager_doctors.jsp"
                                class="sidebar-dropdown-item">
                                Danh sách bác sĩ
                            </a>
                        </div>
                    </div>

                    <div class="sidebar-dropdown">
                        <div class="sidebar-item sidebar-dropdown-toggle" onclick="toggleDropdown(this)">
                            <i class="fas fa-calendar-week"></i>
                            <span>Lịch làm việc</span>
                        </div>
                        <div class="sidebar-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/jsp/manager/manager_lichtrinh.jsp"
                                class="sidebar-dropdown-item">
                                Lịch trình
                            </a>
                            <a href="${pageContext.request.contextPath}/ScheduleApprovalServlet"
                                class="sidebar-dropdown-item">
                                Phân công
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Statistics Section -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Thống kê</div>

                    <div class="sidebar-dropdown">
                        <div class="sidebar-item sidebar-dropdown-toggle" onclick="toggleDropdown(this)">
                            <i class="fas fa-chart-line"></i>
                            <span>Báo cáo</span>
                        </div>
                        <div class="sidebar-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/jsp/manager/manager_thongke.jsp"
                                class="sidebar-dropdown-item">
                                Báo cáo thống kê
                            </a>
                            <a href="${pageContext.request.contextPath}/jsp/manager/manager_doanhthu.jsp"
                                class="sidebar-dropdown-item">
                                Doanh thu
                            </a>
                            <a href="${pageContext.request.contextPath}/jsp/manager/manager_khothuoc.jsp"
                                class="sidebar-dropdown-item">
                                Kho thuốc
                            </a>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/jsp/manager/manager_blogs.jsp" class="sidebar-item">
                        <i class="fas fa-newspaper"></i>
                        <span>Quản lý Blog</span>
                    </a>
                </div>

            
            </div>
        </nav>