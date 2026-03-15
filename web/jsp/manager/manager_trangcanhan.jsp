<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Manager" %>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    Manager manager = (Manager) request.getAttribute("manager");
    User managerUser = (User) request.getAttribute("user");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat displayFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Trang cá nhân - Quản lý</title>
</head>
<body>
    <div class="dashboard-wrapper">
        <!-- Sidebar Menu -->
        <%@ include file="/jsp/manager/manager_menu.jsp" %>
        
        <!-- Main Content -->
        <main class="dashboard-main">
            <!-- Header -->
            <%@ include file="/jsp/manager/manager_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Messages -->
                <% 
                    String success = (String) session.getAttribute("successMessage");
                    String error = (String) session.getAttribute("errorMessage");
                    if (success != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i><%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% session.removeAttribute("successMessage"); } %>
                <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i><%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% session.removeAttribute("errorMessage"); } %>

                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-user-circle me-2"></i>Trang cá nhân</h4>
                        <p class="text-muted mb-0">Thông tin chi tiết tài khoản Quản lý</p>
                    </div>
                    <button type="button" class="btn-dashboard btn-dashboard-primary" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                        <i class="fas fa-user-edit me-2"></i>Chỉnh sửa hồ sơ
                    </button>
                </div>
                
                <% if (manager != null) { %>
                <div class="row">
                    <!-- Avatar & Info -->
                    <div class="col-lg-4">
                        <div class="dashboard-card text-center py-4">
                            <div class="position-relative d-inline-block mx-auto mb-3">
                                <img src="<%= user.getAvatar() != null ? user.getAvatar() : request.getContextPath() + "/view/assets/img/default-user-avatar.png" %>" 
                                     alt="Avatar" class="rounded-circle shadow-sm" style="width: 150px; height: 150px; object-fit: cover; border: 3px solid #eee;">
                            </div>
                            <h5 class="mb-1"><%= manager.getFullName() %></h5>
                            <p class="text-primary fw-bold mb-2"><%= manager.getPosition() %></p>
                            <span class="badge bg-light text-muted small"><i class="fas fa-clock me-1"></i>Tham gia từ: <%= manager.getCreatedAt() != null ? displayFormat.format(manager.getCreatedAt()) : "N/A" %></span>
                            
                            <hr class="mx-4 my-4">
                            
                            <div class="text-start px-4">
                                <div class="mb-3">
                                    <label class="text-muted small d-block mb-1">Email</label>
                                    <div class="fw-medium text-truncate"><i class="fas fa-envelope text-primary me-2"></i><%= user.getEmail() %></div>
                                </div>
                                <div class="mb-3">
                                    <label class="text-muted small d-block mb-1">Số điện thoại</label>
                                    <div class="fw-medium"><i class="fas fa-phone text-success me-2"></i><%= manager.getPhone() != null ? manager.getPhone() : "Chưa cập nhật" %></div>
                                </div>
                                <div class="mb-0">
                                    <label class="text-muted small d-block mb-1">Địa chỉ</label>
                                    <div class="fw-medium"><i class="fas fa-map-marker-alt text-danger me-2"></i><%= manager.getAddress() != null ? manager.getAddress() : "Chưa cập nhật" %></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Details -->
                    <div class="col-lg-8">
                        <div class="dashboard-card p-4">
                            <h6 class="mb-4 d-flex align-items-center">
                                <i class="fas fa-id-card text-primary me-2"></i>
                                Hồ sơ chi tiết
                            </h6>
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label text-muted small">Họ và tên</label>
                                    <p class="form-control bg-light mb-0"><%= manager.getFullName() %></p>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-muted small">Giới tính</label>
                                    <p class="form-control bg-light mb-0"><%= "male".equals(manager.getGender()) ? "Nam" : "female".equals(manager.getGender()) ? "Nữ" : "Khác" %></p>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-muted small">Ngày sinh</label>
                                    <p class="form-control bg-light mb-0"><%= manager.getDateOfBirth() != null ? displayFormat.format(manager.getDateOfBirth()) : "N/A" %></p>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-muted small">Mã quản lý</label>
                                    <p class="form-control bg-light mb-0">MGR-<%= manager.getManagerId() != -1 ? manager.getManagerId() : "NEW" %></p>
                                </div>
                            </div>
                            
                            <div class="mt-5 p-4 rounded-3 border border-1" style="background-color: #fff9f0; border-color: #ffeeba !important;">
                                <div class="d-flex align-items-center">
                                    <div class="bg-warning bg-opacity-10 p-3 rounded-circle me-3">
                                        <i class="fas fa-shield-alt text-warning fs-4"></i>
                                    </div>
                                    <div>
                                        <p class="mb-1 fw-bold">Quyền hạn hệ thống</p>
                                        <p class="mb-0 text-muted small">Bạn đang đăng nhập với quyền <strong>Quản lý cơ sở</strong>. Bạn có toàn quyền quản lý nhân sự, kho thuốc, dịch vụ và theo dõi báo cáo doanh thu phòng khám.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Edit Profile Modal -->
                <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content border-0 shadow-lg">
                            <form action="${pageContext.request.contextPath}/UpdateManagerProfileServlet" method="POST">
                                <div class="modal-header bg-primary text-white py-3">
                                    <h5 class="modal-title" id="editProfileModalLabel"><i class="fas fa-user-edit me-2"></i>Chỉnh sửa hồ sơ Quản lý</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <div class="row g-3">
                                        <div class="col-md-12">
                                            <label class="form-label fw-bold small text-muted">Họ và tên</label>
                                            <input type="text" name="fullName" class="form-control" value="<%= manager.getFullName() %>" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold small text-muted">Số điện thoại</label>
                                            <input type="tel" name="phone" class="form-control" value="<%= manager.getPhone() != null && !"Chưa cập nhật".equals(manager.getPhone()) ? manager.getPhone() : "" %>">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold small text-muted">Giới tính</label>
                                            <select name="gender" class="form-select">
                                                <option value="male" <%= "male".equals(manager.getGender()) ? "selected" : "" %>>Nam</option>
                                                <option value="female" <%= "female".equals(manager.getGender()) ? "selected" : "" %>>Nữ</option>
                                                <option value="other" <%= "other".equals(manager.getGender()) || "Chưa có".equals(manager.getGender()) ? "selected" : "" %>>Khác</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold small text-muted">Ngày sinh</label>
                                            <input type="date" name="dob" class="form-control" value="<%= manager.getDateOfBirth() != null ? dateFormat.format(manager.getDateOfBirth()) : "" %>">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold small text-muted">Chức vụ</label>
                                            <input type="text" name="position" class="form-control" value="<%= manager.getPosition() %>">
                                        </div>
                                        <div class="col-md-12">
                                            <label class="form-label fw-bold small text-muted">Địa chỉ</label>
                                            <textarea name="address" class="form-control" rows="2"><%= manager.getAddress() != null && !"Chưa cập nhật".equals(manager.getAddress()) ? manager.getAddress() : "" %></textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer bg-light p-3">
                                    <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary px-4"><i class="fas fa-save me-2"></i>Lưu thay đổi</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </main>
    </div>

    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
</body>
</html>
