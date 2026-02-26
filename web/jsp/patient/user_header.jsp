<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%@page import="model.Patients" %>
            <%-- Patient Header Component - Bootstrap Version Unified UI/UX Dashboard Header ⚠️ IMPORTANT: File này PHẢI
                được save với UTF-8 encoding (không có BOM) --%>

                <% User currentUser=(User) session.getAttribute("user"); Patients currentPatient=(Patients)
                    session.getAttribute("patient"); String userName=currentPatient !=null ?
                    currentPatient.getFullName() : (currentUser !=null ? currentUser.getUsername() : "Khách" ); String
                    userAvatar=currentUser !=null && currentUser.getAvatar() !=null ? currentUser.getAvatar() :
                    request.getContextPath() + "/img/default-avatar.png" ; %>

                    <!-- Sidebar Toggle Button (Mobile) -->
                    <button class="sidebar-toggle" onclick="toggleSidebar()">
                        <i class="fas fa-bars"></i>
                    </button>

                    <!-- Dashboard Header -->
                    <header class="dashboard-header">
                        <div class="header-right" style="margin-left: auto;">
                            <!-- Notifications (Bootstrap 5: trigger + menu phải nằm trong .dropdown) -->
                            <div class="dropdown">
                                <div class="header-notification" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-bell"></i>
                                    <span class="notification-badge">2</span>
                                </div>
                                <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <h6 class="dropdown-header">Thông báo</h6>
                                </li>
                                <li><a class="dropdown-item" href="#">
                                        <i class="fas fa-calendar-check text-success me-2"></i>
                                        Lịch hẹn đã được xác nhận
                                    </a></li>
                                <li><a class="dropdown-item" href="#">
                                        <i class="fas fa-comment-medical text-info me-2"></i>
                                        Bác sĩ đã phản hồi tư vấn
                                    </a></li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li><a class="dropdown-item text-center" href="#">Xem tất cả</a></li>
                                </ul>
                            </div>

                            <!-- User Profile -->
                            <% if (currentUser !=null) { %>
                                <div class="header-user">
                                    <img src="<%= userAvatar %>" alt="Avatar"
                                        onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                                    <div class="header-user-info">
                                        <span class="header-user-name">
                                            <%= userName %>
                                        </span>
                                        <span class="header-user-role">Bệnh nhân</span>
                                    </div>
                                    <div class="header-dropdown">
                                        <a href="${pageContext.request.contextPath}/jsp/patient/user_taikhoan.jsp">
                                            <i class="fas fa-user"></i> Tài khoản
                                        </a>
                                        <a href="${pageContext.request.contextPath}/PatientAppointments">
                                            <i class="fas fa-calendar-alt"></i> Lịch khám
                                        </a>
                                        <a href="${pageContext.request.contextPath}/LogoutServlet">
                                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                        </a>
                                    </div>
                                </div>
                                <% } else { %>
                                    <div class="d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/jsp/auth/login.jsp"
                                            class="btn-dashboard btn-dashboard-secondary">
                                            Đăng nhập
                                        </a>
                                        <a href="${pageContext.request.contextPath}/jsp/auth/register.jsp"
                                            class="btn-dashboard btn-dashboard-primary">
                                            Đăng ký
                                        </a>
                                    </div>
                                    <% } %>
                        </div>
                    </header>