<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Doctor Sidebar Menu - Bootstrap Version Unified UI/UX Dashboard Sidebar --%>

        <!-- Dashboard Sidebar -->
        <nav class="dashboard-sidebar" id="sideMenu">
            <!-- Sidebar Header / Logo -->
            <div class="sidebar-header">
                <a href="${pageContext.request.contextPath}/DoctorHomePageServlet" class="sidebar-logo"
                    title="Về trang chủ">
                    <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo Happy Smile">
                    <span class="sidebar-logo-text">HAPPY <em>Smile</em></span>
                </a>
            </div>

            <!-- Sidebar Menu -->
            <div class="sidebar-menu">
                <!-- Main Section -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Tổng quan</div>

                    <a href="${pageContext.request.contextPath}/DoctorHomePageServlet" class="sidebar-item">
                        <i class="fas fa-home"></i>
                        <span>Trang chủ</span>
                    </a>
                </div>

                <!-- Appointments Section -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Lượt khám</div>

                    <div class="sidebar-dropdown">
                        <div class="sidebar-item sidebar-dropdown-toggle" onclick="toggleDropdown(this)">
                            <i class="fas fa-calendar-day"></i>
                            <span>Lượt khám</span>
                        </div>
                        <div class="sidebar-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet"
                                class="sidebar-dropdown-item">
                                Trong ngày
                            </a>
                            <a href="${pageContext.request.contextPath}/cancelledAppointments"
                                class="sidebar-dropdown-item">
                                Bị huỷ bỏ
                            </a>
                            <a href="${pageContext.request.contextPath}/completedAppointments"
                                class="sidebar-dropdown-item">
                                Kết quả khám
                            </a>
                        </div>
                    </div>

                    <div class="sidebar-dropdown">
                        <div class="sidebar-item sidebar-dropdown-toggle" onclick="toggleDropdown(this)">
                            <i class="fas fa-calendar-week"></i>
                            <span>Lịch khám</span>
                        </div>
                        <div class="sidebar-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/DoctorHaveAppointmentServlet"
                                class="sidebar-dropdown-item">
                                Lịch làm
                            </a>
                            <a href="${pageContext.request.contextPath}/DoctorRegisterScheduleServlet"
                                class="sidebar-dropdown-item">
                                Đăng ký lịch
                            </a>
                            <a href="${pageContext.request.contextPath}/ReexaminationServlet"
                                class="sidebar-dropdown-item">
                                Tái khám
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Consultation Section -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Tư vấn</div>

                    <div class="sidebar-dropdown">
                        <div class="sidebar-item sidebar-dropdown-toggle" onclick="toggleDropdown(this)">
                            <i class="fas fa-comments"></i>
                            <span>Tư vấn</span>
                        </div>
                        <div class="sidebar-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/public/chat.jsp" class="sidebar-dropdown-item">
                                Phòng chờ
                            </a>
                            <a href="${pageContext.request.contextPath}/public/chat.jsp" class="sidebar-dropdown-item">
                                Trò chuyện
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Account Section -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Tài khoản</div>

                    <div class="sidebar-dropdown">
                        <div class="sidebar-item sidebar-dropdown-toggle" onclick="toggleDropdown(this)">
                            <i class="fas fa-user-circle"></i>
                            <span>Tài khoản</span>
                        </div>
                        <div class="sidebar-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/doctor_trangcanhan"
                                class="sidebar-dropdown-item">
                                Trang cá nhân
                            </a>
                            <a href="${pageContext.request.contextPath}/EditDoctorServlet"
                                class="sidebar-dropdown-item">
                                Cài đặt
                            </a>
                        </div>
                    </div>
            
                </div>
            </div>
        </nav>