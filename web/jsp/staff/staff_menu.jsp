<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Staff Sidebar Menu - Bootstrap Version Unified UI/UX Dashboard Sidebar --%>

        <!-- Dashboard Sidebar -->
        <nav class="dashboard-sidebar" id="sideMenu">
            <!-- Sidebar Header / Logo -->
            <div class="sidebar-header">
                <a href="${pageContext.request.contextPath}/jsp/staff/staff_tongquan.jsp" class="sidebar-logo"
                    title="Về trang chủ">
                    <img src="${pageContext.request.contextPath}/view/assets/img/logo.png" alt="Logo Happy Smile">
                    <span class="sidebar-logo-text">HAPPY <em>Smile</em></span>
                </a>
            </div>

            <!-- Sidebar Menu -->
            <div class="sidebar-menu">
                <!-- Main Section -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Tổng quan</div>

                    <a href="${pageContext.request.contextPath}/jsp/staff/staff_tongquan.jsp" class="sidebar-item">
                        <i class="fas fa-home"></i>
                        <span>Trang chủ</span>
                    </a>
                </div>

                <!-- Appointment Management Section -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Quản lý chính</div>

                    <div class="sidebar-dropdown">
                        <div class="sidebar-item sidebar-dropdown-toggle" onclick="toggleDropdown(this)">
                            <i class="fas fa-calendar-check"></i>
                            <span>Quản lý lịch hẹn</span>
                        </div>
                        <div class="sidebar-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/StaffBookingServlet"
                                class="sidebar-dropdown-item">
                                Đặt lịch mới
                            </a>
                            <a href="${pageContext.request.contextPath}/CancelAppointmentServlet"
                                class="sidebar-dropdown-item">
                                Xem huỷ lịch hẹn
                            </a>
                            <a href="${pageContext.request.contextPath}/RescheduleAppointmentServlet"
                                class="sidebar-dropdown-item">
                                Đổi lịch hẹn
                            </a>
                            <a href="#" class="sidebar-dropdown-item">
                                Lịch tái khám
                            </a>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/StaffHandleQueueServlet" class="sidebar-item">
                        <i class="fas fa-users-line"></i>
                        <span>Quản lý hàng đợi</span>
                    </a>

                    <div class="sidebar-dropdown">
                        <div class="sidebar-item sidebar-dropdown-toggle" onclick="toggleDropdown(this)">
                            <i class="fas fa-file-invoice-dollar"></i>
                            <span>Quản lý thanh toán</span>
                        </div>
                        <div class="sidebar-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/StaffPaymentServlet?action=payments"
                                class="sidebar-dropdown-item">
                                Thanh toán hóa đơn
                            </a>
                            <a href="${pageContext.request.contextPath}/StaffPaymentServlet?action=installments"
                                class="sidebar-dropdown-item">
                                Quản lý trả góp
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Work Schedule Section -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Công việc</div>

                    <a href="${pageContext.request.contextPath}/StaffRegisterSecheduleServlet" class="sidebar-item">
                        <i class="fas fa-calendar-plus"></i>
                        <span>Đăng kí lịch làm việc</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/jsp/blog/blog.jsp" class="sidebar-item">
                        <i class="fas fa-newspaper"></i>
                        <span>Tin tức y tế</span>
                    </a>

                    <a href="#" class="sidebar-item">
                        <i class="fas fa-bell"></i>
                        <span>Thông báo</span>
                        <span class="badge bg-danger rounded-pill ms-auto">3</span>
                    </a>
                </div>

                <!-- Account Section -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Cá nhân</div>

                    <a href="${pageContext.request.contextPath}/StaffProfileServlet" class="sidebar-item">
                        <i class="fas fa-user-circle"></i>
                        <span>Tài khoản của tôi</span>
                    </a>


                </div>
            </div>
        </nav>