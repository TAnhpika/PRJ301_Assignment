<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    List<User> users = UserDAO.getAllUsers();
    
    int patientCount = 0;
    int doctorCount = 0;
    int staffCount = 0;
    int activeCount = 0;
    for (User u : users) {
        if ("PATIENT".equals(u.getRole())) patientCount++;
        if ("DOCTOR".equals(u.getRole())) doctorCount++;
        if ("STAFF".equals(u.getRole())) staffCount++;
        if (u.isActive()) activeCount++;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Quản lý Người dùng - Manager</title>
    <style>
        .user-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/manager/manager_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/manager/manager_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-users me-2"></i>Quản lý Người dùng</h4>
                        <p class="text-muted mb-0">Quản lý tất cả tài khoản trong hệ thống</p>
                    </div>
                    <button class="btn-dashboard btn-dashboard-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                        <i class="fas fa-plus"></i> Thêm người dùng
                    </button>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-card-value"><%= users.size() %></div>
                            <div class="stat-card-label">Tổng người dùng</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="stat-card-value"><%= patientCount %></div>
                            <div class="stat-card-label">Bệnh nhân</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="stat-card-value"><%= doctorCount %></div>
                            <div class="stat-card-label">Bác sĩ</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-nurse"></i>
                            </div>
                            <div class="stat-card-value"><%= staffCount %></div>
                            <div class="stat-card-label">Nhân viên</div>
                        </div>
                    </div>
                </div>
                
                <!-- Filters -->
                <div class="dashboard-card mb-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm người dùng..." onkeyup="filterTable()">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="roleFilter" onchange="filterTable()">
                                <option value="">Tất cả vai trò</option>
                                <option value="PATIENT">Bệnh nhân</option>
                                <option value="DOCTOR">Bác sĩ</option>
                                <option value="STAFF">Nhân viên</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="statusFilter" onchange="filterTable()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active">Hoạt động</option>
                                <option value="inactive">Bị khóa</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- Users Table -->
                <div class="dashboard-card">
                    <div class="table-responsive">
                        <table class="dashboard-table" id="usersTable">
                            <thead>
                                <tr>
                                    <th style="width: 60px;">ID</th>
                                    <th style="width: 60px;">Ảnh</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Điện thoại</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (users.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center py-5">
                                        <i class="fas fa-users text-muted" style="font-size: 48px;"></i>
                                        <p class="text-muted mt-3">Chưa có người dùng nào</p>
                                    </td>
                                </tr>
                                <% } else { for (User u : users) { %>
                                <tr data-role="<%= u.getRole() %>" data-status="<%= u.isActive() ? "active" : "inactive" %>">
                                    <td><span class="badge bg-secondary">#<%= u.getId() %></span></td>
                                    <td>
                                        <img src="<%= u.getAvatar() != null ? u.getAvatar() : request.getContextPath() + "/view/assets/img/default-avatar.png" %>" 
                                             class="user-avatar" alt="User Avatar">
                                    </td>
                                    <td><strong><%= u.getName() %></strong></td>
                                    <td><%= u.getEmail() %></td>
                                    <td><%= u.getPhone() %></td>
                                    <td>
                                        <span class="badge bg-<%= "PATIENT".equals(u.getRole()) ? "info" : "DOCTOR".equals(u.getRole()) ? "success" : "STAFF".equals(u.getRole()) ? "warning" : "secondary" %>">
                                            <%= "PATIENT".equals(u.getRole()) ? "Bệnh nhân" : "DOCTOR".equals(u.getRole()) ? "Bác sĩ" : "STAFF".equals(u.getRole()) ? "Nhân viên" : u.getRole() %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge bg-<%= u.isActive() ? "success" : "danger" %>">
                                            <%= u.isActive() ? "Hoạt động" : "Bị khóa" %>
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-info me-1" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-warning me-1" title="Chỉnh sửa">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <% if (u.isActive()) { %>
                                        <button class="btn btn-sm btn-outline-secondary me-1" title="Khóa tài khoản" onclick="confirmAction('Bạn có chắc muốn khóa tài khoản này?', function() { toggleUserStatus(<%= u.getId() %>, false); })">
                                            <i class="fas fa-lock"></i>
                                        </button>
                                        <% } else { %>
                                        <button class="btn btn-sm btn-outline-success me-1" title="Mở khóa tài khoản" onclick="confirmAction('Bạn có chắc muốn mở khóa tài khoản này?', function() { toggleUserStatus(<%= u.getId() %>, true); })">
                                            <i class="fas fa-unlock"></i>
                                        </button>
                                        <% } %>
                                        <button class="btn btn-sm btn-outline-danger" title="Xóa" onclick="confirmAction('Bạn có chắc muốn xóa người dùng này?', function() { deleteUserAction(<%= u.getId() %>); })">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Thêm người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/AddUserServlet" method="POST">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Họ tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" name="phone" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Vai trò <span class="text-danger">*</span></label>
                            <select class="form-select" name="role" required>
                                <option value="PATIENT">Bệnh nhân</option>
                                <option value="DOCTOR">Bác sĩ</option>
                                <option value="STAFF">Nhân viên</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" name="password" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm người dùng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function filterTable() {
            var searchInput = document.getElementById("searchInput").value.toLowerCase();
            var roleFilter = document.getElementById("roleFilter").value;
            var statusFilter = document.getElementById("statusFilter").value;
            var table = document.getElementById("usersTable");
            var tr = table.getElementsByTagName("tr");

            for (var i = 1; i < tr.length; i++) {
                var role = tr[i].getAttribute("data-role");
                var status = tr[i].getAttribute("data-status");
                var show = true;
                
                if (roleFilter && role !== roleFilter) {
                    show = false;
                }
                
                if (statusFilter && status !== statusFilter) {
                    show = false;
                }
                
                if (searchInput) {
                    var textContent = tr[i].textContent || tr[i].innerText;
                    if (textContent.toLowerCase().indexOf(searchInput) === -1) {
                        show = false;
                    }
                }
                
                tr[i].style.display = show ? "" : "none";
            }
        }
        
        function toggleUserStatus(userId, isActive) {
            window.location.href = '${pageContext.request.contextPath}/ToggleUserStatusServlet?id=' + userId + '&active=' + isActive;
        }
        
        function deleteUserAction(userId) {
            window.location.href = '${pageContext.request.contextPath}/DeleteUserServlet?id=' + userId;
        }
    </script>
</body>
</html>
