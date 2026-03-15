<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/staff.css">
    <%@page import="model.User" %>
        <%@page import="model.Staff" %>
            <%-- Staff Header Component - Bootstrap Version Unified UI/UX Dashboard Header --%>

                <% User currentUser=(User) session.getAttribute("user"); Staff currentStaff=(Staff)
                    session.getAttribute("staff"); String userName=currentStaff !=null ? currentStaff.getFullName() :
                    (currentUser !=null ? currentUser.getUsername() : "Nhân viên" ); String userAvatar=currentUser
                    !=null && currentUser.getAvatar() !=null ? request.getContextPath() + currentUser.getAvatar() : request.getContextPath()
                    + "/view/assets/img/default-user-avatar.png" ; %>

                    <style>
                        /* Đẩy toàn bộ nội dung header lên trên cùng */
                        .dashboard-header {
                            align-items: flex-start !important;
                            padding-top: 10px !important;
                        }

                        /* Notification button */
                        .dashboard-header .btn-light {
                            width: 38px;
                            height: 38px;
                            padding: 0;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            border-radius: 10px;
                            background: #f8fafc;
                            border: 1.5px solid #e2e8f0;
                            color: #475569;
                            font-size: 15px;
                            flex-shrink: 0;
                        }
                        .dashboard-header .btn-light:hover { background: #eef2f8; }

                        /* User profile block */
                        .header-user {
                            display: flex;
                            align-items: center;
                            gap: 10px;
                            cursor: pointer;
                            padding: 6px 10px;
                            border-radius: 10px;
                            transition: background 0.2s;
                            position: relative;
                        }
                        .header-user:hover { background: #f1f5f9; }
                        .header-user img {
                            width: 36px;
                            height: 36px;
                            border-radius: 50%;
                            object-fit: cover;
                            border: 2px solid #e2e8f0;
                            flex-shrink: 0;
                        }
                        .header-user-info {
                            display: flex;
                            flex-direction: column;
                            line-height: 1.25;
                        }
                        .header-user-name {
                            font-size: 13.5px;
                            font-weight: 700;
                            color: #1e293b;
                            white-space: nowrap;
                            max-width: 160px;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }
                        .header-user-role {
                            font-size: 11.5px;
                            color: #64748b;
                        }

                        /* Dropdown menu của user */
                        .header-dropdown {
                            display: none;
                            position: absolute;
                            top: calc(100% + 8px);
                            right: 0;
                            background: white;
                            border: 1.5px solid #e2e8f0;
                            border-radius: 12px;
                            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
                            min-width: 200px;
                            padding: 8px 0;
                            z-index: 9999;
                        }
                        /* JS thêm class 'active' vào .header-user khi click */
                        .header-user.active .header-dropdown { display: block; }
                        .header-dropdown a {
                            display: flex;
                            align-items: center;
                            gap: 10px;
                            padding: 10px 18px;
                            font-size: 13.5px;
                            color: #334155;
                            text-decoration: none;
                            transition: background 0.15s;
                        }
                        .header-dropdown a:hover { background: #f8fafc; }
                        .header-dropdown a.text-danger { color: #ef4444; }
                        .header-dropdown hr { margin: 6px 12px; border-color: #f1f5f9; opacity: 1; }
                    </style>

                    <!-- Sidebar Toggle Button (Mobile) -->
                    <button class="sidebar-toggle" onclick="toggleSidebar()">
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
                                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                        5
                                    </span>
                                </button>
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
                            </div>

                            <!-- User Profile -->
                            <div class="header-user" onclick="toggleUserDropdown(event)">
                                <img src="<%= userAvatar %>" alt="Avatar">
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

                                    <hr class="m-0 opacity-10">
                                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="text-danger">
                                        <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                    </a>
                                </div>
                            </div>
                        </div>
                    </header>