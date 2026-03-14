<%-- 
    doctor_changepassword.jsp
    - Modern, Premium Change Password Page for Doctors
    - Integrated with Dashboard Layout
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.User, model.Doctors"%>
<%
    User authUser = (User) session.getAttribute("user");
    if (authUser == null || !"DOCTOR".equalsIgnoreCase(authUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
        return;
    }
    String successMsg = (String) request.getAttribute("successMessage");
    if (successMsg == null) successMsg = request.getParameter("success");
    
    String errorMsg = (String) request.getAttribute("errorMessage");
    if (errorMsg == null) errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Đổi Mật Khẩu | Happy Smile</title>
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #0d9488 0%, #0f766e 100%);
            --glass-bg: rgba(255, 255, 255, 0.95);
            --glass-border: rgba(226, 232, 240, 0.8);
            --shadow-premium: 0 10px 25px -5px rgba(0, 0, 0, 0.04), 0 8px 10px -6px rgba(0, 0, 0, 0.04);
        }

        .premium-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            padding: 40px;
            box-shadow: var(--shadow-premium);
            max-width: 560px;
            margin: 20px auto;
            transition: transform 0.3s ease;
        }

        .premium-card:hover {
            transform: translateY(-2px);
        }

        .icon-box {
            width: 72px;
            height: 72px;
            background: var(--primary-gradient);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 24px;
            box-shadow: 0 8px 20px rgba(13, 148, 136, 0.2);
        }

        .icon-box i {
            font-size: 32px;
            color: white;
        }

        .form-heading h2 {
            font-size: 24px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .form-heading p {
            color: #64748b;
            font-size: 15px;
            margin-bottom: 32px;
        }

        .input-group-custom {
            margin-bottom: 24px;
            position: relative;
        }

        .input-group-custom label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
            padding-left: 4px;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-wrapper i.prefix-icon {
            position: absolute;
            left: 16px;
            color: #94a3b8;
            font-size: 18px;
            transition: color 0.3s ease;
        }

        .input-wrapper input {
            width: 100%;
            padding: 14px 48px 14px 48px;
            background: #f8fafc;
            border: 2px solid transparent;
            border-radius: 16px;
            font-size: 15px;
            color: #1e293b;
            transition: all 0.3s ease;
        }

        .input-wrapper input:focus {
            background: white;
            border-color: #0d9488;
            box-shadow: 0 0 0 4px rgba(13, 148, 136, 0.1);
            outline: none;
        }

        .input-wrapper input:focus + i.prefix-icon {
            color: #0d9488;
        }

        .toggle-password {
            position: absolute;
            right: 16px;
            color: #94a3b8;
            cursor: pointer;
            padding: 8px;
            transition: color 0.3s ease;
        }

        .toggle-password:hover {
            color: #0d9488;
        }

        /* Strength Meter */
        .strength-container {
            margin-top: -16px;
            margin-bottom: 24px;
        }

        .strength-bar {
            height: 6px;
            background: #e2e8f0;
            border-radius: 10px;
            overflow: hidden;
            display: flex;
            gap: 4px;
        }

        .strength-segment {
            flex: 1;
            height: 100%;
            background: #cbd5e1;
            transition: background 0.4s ease;
        }

        .strength-text {
            font-size: 12px;
            font-weight: 600;
            margin-top: 8px;
            display: block;
            text-align: right;
        }

        /* Buttons */
        .btn-premium {
            width: 100%;
            padding: 16px;
            background: var(--primary-gradient);
            color: white;
            border: none;
            border-radius: 16px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(13, 148, 136, 0.2);
        }

        .btn-premium:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(13, 148, 136, 0.3);
        }

        .btn-premium:active {
            transform: translateY(0);
        }

        .btn-premium:disabled {
            background: #cbd5e1;
            box-shadow: none;
            cursor: not-allowed;
            transform: none;
        }

        /* Alerts */
        .modern-alert {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px;
            border-radius: 16px;
            margin-bottom: 24px;
            font-size: 14px;
            font-weight: 500;
            animation: slideIn 0.4s ease;
        }

        @keyframes slideIn {
            from { transform: translateY(-10px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .alert-success-modern {
            background: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .alert-error-modern {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        /* Breadcrumb Section */
        .breadcrumb-section {
            padding: 24px 0;
            margin-bottom: 32px;
        }

        .breadcrumb-custom {
            display: flex;
            gap: 8px;
            align-items: center;
            font-size: 14px;
            color: #64748b;
        }

        .breadcrumb-custom a {
            color: #0d9488;
            text-decoration: none;
            font-weight: 600;
        }

        .breadcrumb-separator {
            color: #cbd5e1;
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/view/jsp/doctor/doctor_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/view/jsp/doctor/doctor_header.jsp" %>

            <div class="dashboard-content">
                <div class="container-fluid">
                    <!-- Breadcrumb -->
                    <div class="breadcrumb-section">
                        <div class="breadcrumb-custom">
                            <a href="${pageContext.request.contextPath}/DoctorHomePageServlet">Bảng điều khiển</a>
                            <span class="breadcrumb-separator">/</span>
                            <span>Tài khoản</span>
                            <span class="breadcrumb-separator">/</span>
                            <span style="color: #1e293b; font-weight: 600;">Đổi mật khẩu</span>
                        </div>
                    </div>

                    <div class="premium-card">
                        <div class="icon-box">
                            <i class="fas fa-shield-halved"></i>
                        </div>
                        
                        <div class="form-heading">
                            <h2>Bảo mật tài khoản</h2>
                            <p>Thay đổi mật khẩu định kỳ để bảo vệ tài khoản của bạn tốt hơn.</p>
                        </div>

                        <!-- Messages -->
                        <% if (successMsg != null && !successMsg.isEmpty()) { %>
                        <div class="modern-alert alert-success-modern">
                            <i class="fas fa-check-circle"></i>
                            <span><%= successMsg %></span>
                        </div>
                        <% } %>

                        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
                        <div class="modern-alert alert-error-modern">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span><%= errorMsg %></span>
                        </div>
                        <% } %>

                        <form action="${pageContext.request.contextPath}/DoctorChangePasswordServlet" method="POST" id="passwordForm">
                            <!-- Current Password -->
                            <div class="input-group-custom">
                                <label for="currentPassword">Mật khẩu hiện tại</label>
                                <div class="input-wrapper">
                                    <i class="fas fa-lock prefix-icon"></i>
                                    <input type="password" id="currentPassword" name="currentPassword" required 
                                           placeholder="Nhập mật khẩu đang sử dụng">
                                    <i class="fas fa-eye toggle-password" onclick="togglePasswordVisibility('currentPassword', this)"></i>
                                </div>
                            </div>

                            <hr style="border: 0; border-top: 1px solid #f1f5f9; margin: 32px 0;">

                            <!-- New Password -->
                            <div class="input-group-custom">
                                <label for="newPassword">Mật khẩu mới</label>
                                <div class="input-wrapper">
                                    <i class="fas fa-key prefix-icon"></i>
                                    <input type="password" id="newPassword" name="newPassword" required 
                                           placeholder="Tối thiểu 6 ký tự">
                                    <i class="fas fa-eye toggle-password" onclick="togglePasswordVisibility('newPassword', this)"></i>
                                </div>
                            </div>

                            <!-- Strength Meter -->
                            <div class="strength-container">
                                <div class="strength-bar">
                                    <div class="strength-segment" id="seg1"></div>
                                    <div class="strength-segment" id="seg2"></div>
                                    <div class="strength-segment" id="seg3"></div>
                                    <div class="strength-segment" id="seg4"></div>
                                </div>
                                <span class="strength-text" id="strengthText">Độ bảo mật: Chưa nhập</span>
                            </div>

                            <!-- Confirm Password -->
                            <div class="input-group-custom">
                                <label for="confirmPassword">Xác nhận mật khẩu</label>
                                <div class="input-wrapper">
                                    <i class="fas fa-check-double prefix-icon"></i>
                                    <input type="password" id="confirmPassword" name="confirmPassword" required 
                                           placeholder="Nhập lại mật khẩu mới">
                                    <i class="fas fa-eye toggle-password" onclick="togglePasswordVisibility('confirmPassword', this)"></i>
                                </div>
                                <span id="matchError" style="color: #ef4444; font-size: 13px; margin-top: 8px; display: none;">
                                    <i class="fas fa-times-circle me-1"></i> Mật khẩu xác nhận không khớp
                                </span>
                            </div>

                            <button type="submit" class="btn-premium" id="submitBtn">
                                <span>Cập nhật mật khẩu</span>
                                <i class="fas fa-arrow-right"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
    
    <script>
        function togglePasswordVisibility(fieldId, icon) {
            const input = document.getElementById(fieldId);
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                input.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }

        function handlePasswordInput(value) {
            updateStrengthMeter(value);
            validateMatch();
            validateForm();
        }

        function updateStrengthMeter(password) {
            const segments = [
                document.getElementById('seg1'),
                document.getElementById('seg2'),
                document.getElementById('seg3'),
                document.getElementById('seg4')
            ];
            const text = document.getElementById('strengthText');
            
            let score = 0;
            if (password.length > 5) score++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) score++;
            if (/\d/.test(password)) score++;
            if (/[^A-Za-z0-9]/.test(password)) score++;

            // Reset
            segments.forEach(s => s.style.background = '#cbd5e1');
            
            if (password.length === 0) {
                text.innerText = "Độ bảo mật: Chưa nhập";
                text.style.color = "#64748b";
                return;
            }

            const colors = ['#ef4444', '#f59e0b', '#3b82f6', '#0d9488'];
            const labels = ['Yếu 😰', 'Trung bình 😐', 'Mạnh 😊', 'Rất mạnh 💪'];

            for (let i = 0; i < score; i++) {
                segments[i].style.background = colors[score - 1];
            }
            
            text.innerText = "Độ bảo mật: " + labels[score - 1];
            text.style.color = colors[score - 1];
        }

        function validateMatch() {
            const pass = document.getElementById('newPassword').value;
            const confirm = document.getElementById('confirmPassword').value;
            const error = document.getElementById('matchError');
            
            let isMatch = true;
            if (confirm.length > 0 && pass !== confirm) {
                error.style.display = "block";
                isMatch = false;
            } else {
                error.style.display = "none";
            }
            
            // Also update form state
            validateForm();
            return isMatch;
        }

        function validateForm() {
            const pass = document.getElementById('newPassword').value;
            const confirm = document.getElementById('confirmPassword').value;
            const current = document.getElementById('currentPassword').value;
            const btn = document.getElementById('submitBtn');
            
            btn.disabled = !(pass.length >= 6 && pass === confirm && current.length > 0);
        }

        // Add proper event listeners
        document.getElementById('currentPassword').addEventListener('input', validateForm);
        document.getElementById('newPassword').addEventListener('input', function() {
            handlePasswordInput(this.value);
        });
        document.getElementById('confirmPassword').addEventListener('input', validateMatch);

        // Initial check
        validateForm();
    </script>
</body>
</html>
