<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.StaffDAO" %>
<%@ page import="model.Staff" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    List<Staff> staffList = StaffDAO.getAllStaff();
    
    int activeCount = 0;
    int leaveCount = 0;
    for (Staff s : staffList) {
        if ("ACTIVE".equals(s.getStatus())) activeCount++;
        if ("ON_LEAVE".equals(s.getStatus())) leaveCount++;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Quản lý Nhân viên - Manager</title>
    <style>
        .staff-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }
        .department-badge {
            background: linear-gradient(135deg, #e8f5e9 0%, #f1f8e9 100%);
            color: #2e7d32;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
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
                        <h4 class="mb-1"><i class="fas fa-user-nurse me-2"></i>Quản lý Nhân viên</h4>
                        <p class="text-muted mb-0">Danh sách và quản lý thông tin nhân viên</p>
                    </div>
                    <button class="btn-dashboard btn-dashboard-primary" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                        <i class="fas fa-plus"></i> Thêm nhân viên
                    </button>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-card-value"><%= staffList.size() %></div>
                            <div class="stat-card-label">Tổng số nhân viên</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="stat-card-value"><%= activeCount %></div>
                            <div class="stat-card-label">Đang làm việc</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-card-value"><%= leaveCount %></div>
                            <div class="stat-card-label">Đang nghỉ phép</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card danger">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-slash"></i>
                            </div>
                            <div class="stat-card-value"><%= staffList.size() - activeCount - leaveCount %></div>
                            <div class="stat-card-label">Không hoạt động</div>
                        </div>
                    </div>
                </div>
                
                <!-- Filters -->
                <div class="dashboard-card mb-4">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm nhân viên..." onkeyup="filterTable()">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <select class="form-select" id="departmentFilter" onchange="filterTable()">
                                <option value="">Tất cả phòng ban</option>
                                <option value="RECEPTION">Lễ tân</option>
                                <option value="NURSING">Điều dưỡng</option>
                                <option value="PHARMACY">Dược</option>
                                <option value="LABORATORY">Xét nghiệm</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <select class="form-select" id="statusFilter" onchange="filterTable()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="ACTIVE">Đang làm việc</option>
                                <option value="ON_LEAVE">Nghỉ phép</option>
                                <option value="INACTIVE">Không hoạt động</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- Staff Table -->
                <div class="dashboard-card">
                    <div class="table-responsive">
                        <table class="dashboard-table" id="staffTable">
                            <thead>
                                <tr>
                                    <th style="width: 60px;">ID</th>
                                    <th style="width: 60px;">Ảnh</th>
                                    <th>Họ tên</th>
                                    <th>Phòng ban</th>
                                    <th>Chức vụ</th>
                                    <th>Email</th>
                                    <th>Điện thoại</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (staffList.isEmpty()) { %>
                                <tr>
                                    <td colspan="9" class="text-center py-5">
                                        <i class="fas fa-users text-muted" style="font-size: 48px;"></i>
                                        <p class="text-muted mt-3">Chưa có nhân viên nào</p>
                                    </td>
                                </tr>
                                <% } else { for (Staff staff : staffList) { %>
                                <tr data-department="<%= staff.getDepartment() %>" data-status="<%= staff.getStatus() %>">
                                    <td><span class="badge bg-secondary">#<%= staff.getUserId() %></span></td>
                                    <td>
                                        <img src="<%= staff.getAvatar() != null ? staff.getAvatar() : request.getContextPath() + "/view/assets/img/default-avatar.png" %>" 
                                             class="staff-avatar" alt="Staff Avatar">
                                    </td>
                                    <td><strong><%= staff.getName() %></strong></td>
                                    <td><span class="department-badge"><%= staff.getDepartment() %></span></td>
                                    <td><%= staff.getPosition() %></td>
                                    <td><%= staff.getEmail() %></td>
                                    <td><%= staff.getPhone() %></td>
                                    <td>
                                        <span class="badge bg-<%= "ACTIVE".equals(staff.getStatus()) ? "success" : "ON_LEAVE".equals(staff.getStatus()) ? "warning" : "danger" %>">
                                            <%= "ACTIVE".equals(staff.getStatus()) ? "Đang làm việc" : "ON_LEAVE".equals(staff.getStatus()) ? "Nghỉ phép" : "Không hoạt động" %>
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-info me-1" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-warning me-1" title="Chỉnh sửa">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" title="Xóa" onclick="confirmAction('Bạn có chắc muốn xóa nhân viên này?', function() { deleteStaffAction(<%= staff.getUserId() %>); })">
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
    
    <!-- Add Staff Modal -->
    <div class="modal fade" id="addStaffModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Thêm nhân viên mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/AddStaffServlet" method="POST">
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
                            <label class="form-label">Phòng ban <span class="text-danger">*</span></label>
                            <select class="form-select" name="department" required>
                                <option value="RECEPTION">Lễ tân</option>
                                <option value="NURSING">Điều dưỡng</option>
                                <option value="PHARMACY">Dược</option>
                                <option value="LABORATORY">Xét nghiệm</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Chức vụ <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="position" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" name="password" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm nhân viên</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function filterTable() {
            var searchInput = document.getElementById("searchInput").value.toLowerCase();
            var departmentFilter = document.getElementById("departmentFilter").value;
            var statusFilter = document.getElementById("statusFilter").value;
            var table = document.getElementById("staffTable");
            var tr = table.getElementsByTagName("tr");

            for (var i = 1; i < tr.length; i++) {
                var department = tr[i].getAttribute("data-department");
                var status = tr[i].getAttribute("data-status");
                var show = true;
                
                if (departmentFilter && department !== departmentFilter) {
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
        
        function deleteStaffAction(staffId) {
            window.location.href = '${pageContext.request.contextPath}/DeleteStaffServlet?id=' + staffId;
        }
    </script>
</body>
</html>
