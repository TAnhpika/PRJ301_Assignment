<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Staff" %>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    Staff staff = (Staff) request.getAttribute("staff");
    User staffUser = (User) request.getAttribute("user");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat displayFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Tài khoản - Staff</title>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/staff/staff_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/staff/staff_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="mb-4">
                    <h4 class="mb-1"><i class="fas fa-user-cog me-2"></i>Thông tin Tài khoản</h4>
                    <p class="text-muted mb-0">Quản lý thông tin cá nhân của bạn</p>
                </div>
                
                <!-- Alerts -->
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i><%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i><%= request.getAttribute("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                
                <% if (staff != null && staffUser != null) { %>
                <div class="row">
                    <!-- Avatar & Basic Info -->
                    <div class="col-lg-4 mb-4">
                        <div class="dashboard-card text-center">
                            <form id="uploadForm" action="${pageContext.request.contextPath}/UpdateStaffAvatarServlet" method="post" enctype="multipart/form-data">
                                <input type="file" id="avatarInput" name="avatar" accept="image/*" style="display: none;">
                                <input type="hidden" name="userId" value="<%= staffUser.getId() %>">
                            </form>
                            <img id="avatarImg" src="<%= staff.getAvatar() != null ? staff.getAvatar() : request.getContextPath() + "/img/default-avatar.png" %>" 
                                 alt="Avatar" style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid #e9ecef; cursor: pointer;" 
                                 onclick="document.getElementById('avatarInput').click()">
                            <p class="text-muted mt-2 mb-0"><small>Nhấn vào ảnh để đổi</small></p>
                            <h5 class="mt-3 mb-1"><%= staff.getFullName() %></h5>
                            <span class="badge bg-info"><%= staff.getPosition() != null ? staff.getPosition() : "Nhân viên" %></span>
                            
                            <hr class="my-4">
                            
                            <div class="text-start">
                                <p class="mb-2"><i class="fas fa-envelope me-2 text-muted"></i><%= staffUser.getEmail() %></p>
                                <p class="mb-2"><i class="fas fa-phone me-2 text-muted"></i><%= staff.getPhone() %></p>
                                <p class="mb-2"><i class="fas fa-calendar me-2 text-muted"></i>Tạo: <%= staff.getCreatedAt() != null ? displayFormat.format(staff.getCreatedAt()) : "N/A" %></p>
                                <p class="mb-0"><i class="fas fa-briefcase me-2 text-muted"></i>
                                    <%= "fulltime".equals(staff.getEmploymentType()) ? "Toàn thời gian" : "parttime".equals(staff.getEmploymentType()) ? "Bán thời gian" : "N/A" %>
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Forms -->
                    <div class="col-lg-8">
                        <!-- Update Email -->
                        <div class="dashboard-card mb-4">
                            <h6 class="mb-3"><i class="fas fa-envelope me-2"></i>Cập nhật Email</h6>
                            <form method="post" action="${pageContext.request.contextPath}/StaffUpdateServlet">
                                <input type="hidden" name="type" value="email">
                                <div class="row align-items-end">
                                    <div class="col-md-8 mb-3 mb-md-0">
                                        <label class="form-label">Email</label>
                                        <input type="email" class="form-control" name="value" value="<%= staffUser.getEmail() %>" required>
                                    </div>
                                    <div class="col-md-4">
                                        <button type="submit" class="btn btn-primary w-100">Cập nhật Email</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                        
                        <!-- Change Password -->
                        <div class="dashboard-card mb-4">
                            <h6 class="mb-3"><i class="fas fa-lock me-2"></i>Đổi mật khẩu</h6>
                            <form method="post" action="${pageContext.request.contextPath}/StaffUpdateServlet">
                                <input type="hidden" name="type" value="password">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Mật khẩu cũ <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" name="oldPassword" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Mật khẩu mới <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" name="newPassword" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Xác nhận <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" name="confirmPassword" required>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-warning">Đổi mật khẩu</button>
                            </form>
                        </div>
                        
                        <!-- Update Info -->
                        <div class="dashboard-card">
                            <h6 class="mb-3"><i class="fas fa-user-edit me-2"></i>Cập nhật thông tin cá nhân</h6>
                            <form method="post" action="${pageContext.request.contextPath}/StaffUpdateServlet">
                                <input type="hidden" name="type" value="update_staff_info">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="fullName" value="<%= staff.getFullName() %>" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                        <input type="tel" class="form-control" name="phone" value="<%= staff.getPhone() %>" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Ngày sinh <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" name="dateOfBirth" value="<%= staff.getDateOfBirth() != null ? dateFormat.format(staff.getDateOfBirth()) : "" %>" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Giới tính <span class="text-danger">*</span></label>
                                        <select class="form-select" name="gender" required>
                                            <option value="male" <%= "male".equalsIgnoreCase(staff.getGender()) ? "selected" : "" %>>Nam</option>
                                            <option value="female" <%= "female".equalsIgnoreCase(staff.getGender()) ? "selected" : "" %>>Nữ</option>
                                            <option value="other" <%= "other".equalsIgnoreCase(staff.getGender()) ? "selected" : "" %>>Khác</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="address" value="<%= staff.getAddress() != null ? staff.getAddress() : "" %>" required>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-success">Lưu thay đổi</button>
                            </form>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle me-2"></i>Không tìm thấy thông tin nhân viên.
                </div>
                <% } %>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        document.getElementById('avatarInput').addEventListener('change', function() {
            if (this.files.length > 0) {
                document.getElementById('uploadForm').submit();
            }
        });
    </script>
</body>
</html>
