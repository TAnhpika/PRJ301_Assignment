<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="model.User" %>
<%@page import="model.Patients" %>

<%
    User users = (User) session.getAttribute("user");
    Patients patient = (Patients) session.getAttribute("patient");
    
    if (users == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Thông tin cá nhân - Happy Smile</title>
    <style>
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--primary-color);
        }
        .profile-avatar-placeholder {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 48px;
            font-weight: 700;
        }
        .info-item {
            padding: 16px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .password-mask {
            letter-spacing: 3px;
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/patient/user_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/patient/user_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-user-circle me-2"></i>Thông tin cá nhân</h4>
                        <p class="text-muted mb-0">Quản lý thông tin tài khoản của bạn</p>
                    </div>
                </div>
                
                <!-- Alerts -->
                <% String error = (String) request.getAttribute("error"); 
                   if (error == null) error = request.getParameter("error");
                   if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="fas fa-exclamation-circle me-2"></i><%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                
                <% String success = (String) request.getAttribute("success"); 
                   if (success == null) success = request.getParameter("success");
                   if (success != null) { %>
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="fas fa-check-circle me-2"></i><%= success %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                
                <div class="row g-4">
                    <!-- Profile Card -->
                    <div class="col-lg-4">
                        <div class="dashboard-card text-center">
                            <% if (patient != null && patient.getAvatar() != null && !patient.getAvatar().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}<%= patient.getAvatar() %>" 
                                 class="profile-avatar mb-3" alt="Avatar"
                                 onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                            <% } else { %>
                            <div class="profile-avatar-placeholder mx-auto mb-3">
                                <%= users.getUsername() != null ? users.getUsername().substring(0, 1).toUpperCase() : "U" %>
                            </div>
                            <% } %>
                            
                            <h5 class="mb-1"><%= patient != null ? patient.getFullName() : users.getUsername() %></h5>
                            <p class="text-muted mb-3"><%= users.getEmail() %></p>
                            <span class="badge bg-primary">Bệnh nhân</span>
                            
                            <hr class="my-4">
                            
                            <!-- Upload Avatar Form -->
                            <form action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="type" value="profile_picture">
                                <% if (patient != null) { %>
                                <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                                <% } %>
                                <div class="mb-3">
                                    <input type="file" class="form-control" name="profilePicture" accept="image/*" id="avatarInput">
                                </div>
                                <button type="submit" class="btn btn-outline-primary btn-sm w-100">
                                    <i class="fas fa-camera me-1"></i>Đổi ảnh đại diện
                                </button>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Account Info -->
                    <div class="col-lg-8">
                        <!-- User Account -->
                        <div class="dashboard-card mb-4">
                            <h6 class="mb-4"><i class="fas fa-key me-2 text-primary"></i>Thông tin tài khoản</h6>
                            
                            <div class="info-item">
                                <div class="row align-items-center">
                                    <div class="col-md-3"><strong>Email</strong></div>
                                    <div class="col-md-6" id="emailDisplay"><%= users.getEmail() != null ? users.getEmail() : "--" %></div>
                                    <div class="col-md-3 text-end">
                                        <button class="btn btn-sm btn-outline-primary" onclick="toggleEdit('email')">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                    </div>
                                </div>
                                <form id="emailForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;" class="mt-2">
                                    <input type="hidden" name="field" value="email">
                                    <div class="row g-2">
                                        <div class="col-md-8">
                                            <input type="email" name="value" class="form-control" value="<%= users.getEmail() != null ? users.getEmail() : "" %>" required>
                                        </div>
                                        <div class="col-md-4">
                                            <button type="submit" class="btn btn-primary btn-sm">Lưu</button>
                                            <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('email')">Hủy</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            
                            <div class="info-item">
                                <div class="row align-items-center">
                                    <div class="col-md-3"><strong>Mật khẩu</strong></div>
                                    <div class="col-md-6"><span class="password-mask">••••••••</span></div>
                                    <div class="col-md-3 text-end">
                                        <button class="btn btn-sm btn-outline-primary" onclick="toggleEdit('password')">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                    </div>
                                </div>
                                <form id="passwordForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;" class="mt-3">
                                    <input type="hidden" name="type" value="password">
                                    <div class="mb-2">
                                        <input type="password" name="oldPassword" class="form-control" placeholder="Mật khẩu cũ" required>
                                    </div>
                                    <div class="mb-2">
                                        <input type="password" name="newPassword" class="form-control" placeholder="Mật khẩu mới" required>
                                    </div>
                                    <div class="mb-2">
                                        <input type="password" name="confirmPassword" class="form-control" placeholder="Xác nhận mật khẩu" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary btn-sm">Đổi mật khẩu</button>
                                    <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('password')">Hủy</button>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Patient Info -->
                        <div class="dashboard-card">
                            <h6 class="mb-4"><i class="fas fa-user me-2 text-success"></i>Thông tin bệnh nhân</h6>
                            
                            <% if (patient != null) { %>
                            
                            <!-- Full Name -->
                            <div class="info-item">
                                <div class="row align-items-center">
                                    <div class="col-md-3"><strong>Họ tên</strong></div>
                                    <div class="col-md-6" id="fullNameDisplay"><%= patient.getFullName() != null ? patient.getFullName() : "--" %></div>
                                    <div class="col-md-3 text-end">
                                        <button class="btn btn-sm btn-outline-primary" onclick="toggleEdit('fullName')"><i class="fas fa-edit"></i></button>
                                    </div>
                                </div>
                                <form id="fullNameForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;" class="mt-2">
                                    <input type="hidden" name="type" value="update_patient_info">
                                    <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                                    <input type="hidden" name="phone" value="<%= patient.getPhone() != null ? patient.getPhone() : "" %>">
                                    <input type="hidden" name="dateOfBirth" value="<%= patient.getDateOfBirth() != null ? new SimpleDateFormat("yyyy-MM-dd").format(patient.getDateOfBirth()) : "" %>">
                                    <input type="hidden" name="gender" value="<%= patient.getGender() != null ? patient.getGender() : "" %>">
                                    <div class="row g-2">
                                        <div class="col-md-8">
                                            <input type="text" name="fullName" class="form-control" value="<%= patient.getFullName() != null ? patient.getFullName() : "" %>" required>
                                        </div>
                                        <div class="col-md-4">
                                            <button type="submit" class="btn btn-primary btn-sm">Lưu</button>
                                            <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('fullName')">Hủy</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            
                            <!-- Phone -->
                            <div class="info-item">
                                <div class="row align-items-center">
                                    <div class="col-md-3"><strong>Điện thoại</strong></div>
                                    <div class="col-md-6" id="phoneDisplay"><%= patient.getPhone() != null ? patient.getPhone() : "--" %></div>
                                    <div class="col-md-3 text-end">
                                        <button class="btn btn-sm btn-outline-primary" onclick="toggleEdit('phone')"><i class="fas fa-edit"></i></button>
                                    </div>
                                </div>
                                <form id="phoneForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;" class="mt-2">
                                    <input type="hidden" name="type" value="update_patient_info">
                                    <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                                    <input type="hidden" name="fullName" value="<%= patient.getFullName() != null ? patient.getFullName() : "" %>">
                                    <input type="hidden" name="dateOfBirth" value="<%= patient.getDateOfBirth() != null ? new SimpleDateFormat("yyyy-MM-dd").format(patient.getDateOfBirth()) : "" %>">
                                    <input type="hidden" name="gender" value="<%= patient.getGender() != null ? patient.getGender() : "" %>">
                                    <div class="row g-2">
                                        <div class="col-md-8">
                                            <input type="tel" name="phone" class="form-control" value="<%= patient.getPhone() != null ? patient.getPhone() : "" %>" pattern="[0-9]{10,11}" required>
                                        </div>
                                        <div class="col-md-4">
                                            <button type="submit" class="btn btn-primary btn-sm">Lưu</button>
                                            <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('phone')">Hủy</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            
                            <!-- Date of Birth -->
                            <div class="info-item">
                                <div class="row align-items-center">
                                    <div class="col-md-3"><strong>Ngày sinh</strong></div>
                                    <div class="col-md-6" id="dobDisplay">
                                        <%= patient.getDateOfBirth() != null ? new SimpleDateFormat("dd/MM/yyyy").format(patient.getDateOfBirth()) : "--" %>
                                    </div>
                                    <div class="col-md-3 text-end">
                                        <button class="btn btn-sm btn-outline-primary" onclick="toggleEdit('dob')"><i class="fas fa-edit"></i></button>
                                    </div>
                                </div>
                                <form id="dobForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;" class="mt-2">
                                    <input type="hidden" name="type" value="update_patient_info">
                                    <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                                    <input type="hidden" name="fullName" value="<%= patient.getFullName() != null ? patient.getFullName() : "" %>">
                                    <input type="hidden" name="phone" value="<%= patient.getPhone() != null ? patient.getPhone() : "" %>">
                                    <input type="hidden" name="gender" value="<%= patient.getGender() != null ? patient.getGender() : "" %>">
                                    <div class="row g-2">
                                        <div class="col-md-8">
                                            <input type="date" name="dateOfBirth" class="form-control" value="<%= patient.getDateOfBirth() != null ? new SimpleDateFormat("yyyy-MM-dd").format(patient.getDateOfBirth()) : "" %>" required>
                                        </div>
                                        <div class="col-md-4">
                                            <button type="submit" class="btn btn-primary btn-sm">Lưu</button>
                                            <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('dob')">Hủy</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            
                            <!-- Gender -->
                            <div class="info-item">
                                <div class="row align-items-center">
                                    <div class="col-md-3"><strong>Giới tính</strong></div>
                                    <div class="col-md-6" id="genderDisplay">
                                        <%= patient.getGender() != null ? (patient.getGender().equals("male") ? "Nam" : patient.getGender().equals("female") ? "Nữ" : "Khác") : "--" %>
                                    </div>
                                    <div class="col-md-3 text-end">
                                        <button class="btn btn-sm btn-outline-primary" onclick="toggleEdit('gender')"><i class="fas fa-edit"></i></button>
                                    </div>
                                </div>
                                <form id="genderForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;" class="mt-2">
                                    <input type="hidden" name="type" value="update_patient_info">
                                    <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                                    <input type="hidden" name="fullName" value="<%= patient.getFullName() != null ? patient.getFullName() : "" %>">
                                    <input type="hidden" name="phone" value="<%= patient.getPhone() != null ? patient.getPhone() : "" %>">
                                    <input type="hidden" name="dateOfBirth" value="<%= patient.getDateOfBirth() != null ? new SimpleDateFormat("yyyy-MM-dd").format(patient.getDateOfBirth()) : "" %>">
                                    <div class="row g-2">
                                        <div class="col-md-8">
                                            <select name="gender" class="form-select" required>
                                                <option value="male" <%= "male".equals(patient.getGender()) ? "selected" : "" %>>Nam</option>
                                                <option value="female" <%= "female".equals(patient.getGender()) ? "selected" : "" %>>Nữ</option>
                                                <option value="other" <%= "other".equals(patient.getGender()) ? "selected" : "" %>>Khác</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <button type="submit" class="btn btn-primary btn-sm">Lưu</button>
                                            <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('gender')">Hủy</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            
                            <% } else { %>
                            <div class="text-center py-4">
                                <i class="fas fa-user-plus text-muted" style="font-size: 48px;"></i>
                                <p class="text-muted mt-3">Chưa có thông tin bệnh nhân</p>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newPatientModal">
                                    <i class="fas fa-plus me-1"></i>Thêm thông tin
                                </button>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function toggleEdit(field) {
            const display = document.getElementById(field + 'Display');
            const form = document.getElementById(field + 'Form');
            
            if (display) {
                display.parentElement.style.display = display.parentElement.style.display === 'none' ? '' : 'none';
            }
            if (form) {
                form.style.display = form.style.display === 'none' ? 'block' : 'none';
            }
        }
        
        // Auto-hide alerts after 5 seconds
        document.querySelectorAll('.alert').forEach(alert => {
            setTimeout(() => {
                alert.classList.remove('show');
                setTimeout(() => alert.remove(), 150);
            }, 5000);
        });
    </script>
</body>
</html>
