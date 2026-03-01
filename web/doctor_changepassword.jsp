<%-- Đổi Mật Khẩu Bác Sĩ --%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.User, model.Doctors"%>
<%
    User authUser = (User) session.getAttribute("user");
    if (authUser == null || !"DOCTOR".equalsIgnoreCase(authUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
        return;
    }
    String successMsg = request.getParameter("success");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Đổi Mật Khẩu - Happy Smile</title>
    <style>
        .page-title-section { margin-bottom: 28px; }
        .page-title-section h4 { font-size: 21px; font-weight: 700; color: #1e293b; margin-bottom: 3px; }
        .page-title-section p  { color: #64748b; font-size: 13.5px; margin: 0; }

        /* Card form */
        .change-pw-card {
            background: white;
            border-radius: 16px;
            border: 1.5px solid #e8eef5;
            padding: 36px 40px;
            max-width: 520px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        }

        .pw-icon-header {
            width: 64px; height: 64px;
            background: linear-gradient(135deg, #0d9488, #0f766e);
            border-radius: 16px;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 20px;
            box-shadow: 0 4px 14px rgba(13,148,136,0.3);
        }
        .pw-icon-header i { font-size: 28px; color: white; }

        .form-label-custom {
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 6px;
            display: block;
        }

        .pw-input-wrapper {
            position: relative;
            margin-bottom: 18px;
        }
        .pw-input-wrapper input {
            width: 100%;
            padding: 11px 44px 11px 14px;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            color: #334155;
            transition: border-color 0.2s, box-shadow 0.2s;
            box-sizing: border-box;
            background: #fafbfc;
        }
        .pw-input-wrapper input:focus {
            outline: none;
            border-color: #0d9488;
            background: white;
            box-shadow: 0 0 0 3px rgba(13,148,136,0.1);
        }
        .pw-toggle {
            position: absolute;
            right: 13px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #94a3b8;
            font-size: 15px;
            background: none;
            border: none;
            padding: 4px;
        }
        .pw-toggle:hover { color: #475569; }

        /* Strength meter */
        .strength-bar-wrapper { margin-top: -10px; margin-bottom: 14px; }
        .strength-bar {
            height: 4px;
            border-radius: 4px;
            background: #e2e8f0;
            overflow: hidden;
            margin-bottom: 4px;
        }
        .strength-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.35s ease, background 0.35s ease;
            width: 0%;
        }
        .strength-label { font-size: 12px; color: #64748b; }

        /* Rules */
        .pw-rules { background: #f8fafc; border-radius: 10px; padding: 14px 16px; margin-bottom: 20px; }
        .pw-rules p { font-size: 12.5px; color: #64748b; margin: 0 0 6px 0; font-weight: 600; }
        .pw-rule {
            display: flex; align-items: center; gap: 7px;
            font-size: 12.5px; color: #94a3b8; margin-bottom: 4px;
            transition: color 0.2s;
        }
        .pw-rule i { font-size: 11px; transition: color 0.2s; }
        .pw-rule.valid { color: #0d9488; }
        .pw-rule.valid i { color: #0d9488; }
        .pw-rule i.fa-circle { color: #e2e8f0; }
        .pw-rule.valid i.fa-check-circle { color: #0d9488; }

        /* Alert */
        .alert-custom {
            padding: 12px 16px; border-radius: 10px; font-size: 13.5px;
            margin-bottom: 20px; display: flex; align-items: center; gap: 10px;
        }
        .alert-success { background: #ecfdf5; color: #065f46; border: 1.5px solid #a7f3d0; }
        .alert-danger  { background: #fef2f2; color: #991b1b; border: 1.5px solid #fca5a5; }

        /* Submit button */
        .btn-submit-pw {
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #0d9488, #0f766e);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.25s;
            box-shadow: 0 3px 12px rgba(13,148,136,0.3);
            margin-top: 8px;
        }
        .btn-submit-pw:hover:not(:disabled) {
            box-shadow: 0 5px 18px rgba(13,148,136,0.4);
            transform: translateY(-1px);
        }
        .btn-submit-pw:disabled {
            opacity: 0.55;
            cursor: not-allowed;
            transform: none;
        }

        .divider-text {
            text-align: center;
            color: #94a3b8;
            font-size: 12.5px;
            margin: 16px 0;
            position: relative;
        }
        .divider-text::before, .divider-text::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 38%;
            height: 1px;
            background: #e2e8f0;
        }
        .divider-text::before { left: 0; }
        .divider-text::after { right: 0; }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/view/jsp/doctor/doctor_menu.jsp" %>
        <main class="dashboard-main">
            <%@ include file="/view/jsp/doctor/doctor_header.jsp" %>

            <div class="dashboard-content">
                <!-- Header -->
                <div class="page-title-section">
                    <h4><i class="fas fa-lock me-2" style="color:#0d9488"></i>Đổi mật khẩu</h4>
                    <p>Cập nhật mật khẩu để bảo mật tài khoản của bạn</p>
                    <nav aria-label="breadcrumb" class="mt-2">
                        <ol class="breadcrumb mb-0" style="font-size:12.5px">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DoctorHomePageServlet" class="text-decoration-none">Trang chủ</a></li>
                            <li class="breadcrumb-item active">Đổi mật khẩu</li>
                        </ol>
                    </nav>
                </div>

                <div class="change-pw-card">
                    <!-- Icon header -->
                    <div class="pw-icon-header">
                        <i class="fas fa-key"></i>
                    </div>
                    <h5 style="font-size:18px;font-weight:700;color:#1e293b;margin-bottom:4px">Đổi mật khẩu</h5>
                    <p style="font-size:13px;color:#64748b;margin-bottom:24px">Nhập mật khẩu hiện tại và mật khẩu mới của bạn</p>

                    <!-- Alert messages -->
                    <% if (successMsg != null && !successMsg.isBlank()) { %>
                    <div class="alert-custom alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span><%= java.net.URLDecoder.decode(successMsg, "UTF-8") %></span>
                    </div>
                    <% } %>
                    <% if (errorMsg != null && !errorMsg.isBlank()) { %>
                    <div class="alert-custom alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        <span><%= java.net.URLDecoder.decode(errorMsg, "UTF-8") %></span>
                    </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/DoctorChangePasswordServlet"
                          method="POST" id="pwForm" novalidate>

                        <!-- Mật khẩu hiện tại -->
                        <label class="form-label-custom" for="currentPassword">
                            <i class="fas fa-lock me-1" style="color:#0d9488"></i>Mật khẩu hiện tại
                        </label>
                        <div class="pw-input-wrapper">
                            <input type="password" id="currentPassword" name="currentPassword"
                                   placeholder="Nhập mật khẩu hiện tại" required autocomplete="current-password">
                            <button type="button" class="pw-toggle" onclick="togglePw('currentPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>

                        <div class="divider-text">Mật khẩu mới</div>

                        <!-- Mật khẩu mới -->
                        <label class="form-label-custom" for="newPassword">
                            <i class="fas fa-key me-1" style="color:#0d9488"></i>Mật khẩu mới
                        </label>
                        <div class="pw-input-wrapper">
                            <input type="password" id="newPassword" name="newPassword"
                                   placeholder="Tối thiểu 6 ký tự" required autocomplete="new-password"
                                   oninput="checkStrength(this.value); validateForm();">
                            <button type="button" class="pw-toggle" onclick="togglePw('newPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>

                        <!-- Strength meter -->
                        <div class="strength-bar-wrapper">
                            <div class="strength-bar">
                                <div class="strength-fill" id="strengthFill"></div>
                            </div>
                            <span class="strength-label" id="strengthLabel"></span>
                        </div>

                        <!-- Password rules -->
                        <div class="pw-rules">
                            <p><i class="fas fa-shield-alt me-1" style="color:#0d9488"></i>Yêu cầu mật khẩu:</p>
                            <div class="pw-rule" id="rule-len">
                                <i class="fas fa-circle"></i> Ít nhất 6 ký tự
                            </div>
                            <div class="pw-rule" id="rule-upper">
                                <i class="fas fa-circle"></i> Có chữ hoa (khuyến nghị)
                            </div>
                            <div class="pw-rule" id="rule-num">
                                <i class="fas fa-circle"></i> Có chữ số (khuyến nghị)
                            </div>
                        </div>

                        <!-- Xác nhận mật khẩu -->
                        <label class="form-label-custom" for="confirmPassword">
                            <i class="fas fa-check-double me-1" style="color:#0d9488"></i>Xác nhận mật khẩu mới
                        </label>
                        <div class="pw-input-wrapper">
                            <input type="password" id="confirmPassword" name="confirmPassword"
                                   placeholder="Nhập lại mật khẩu mới" required autocomplete="new-password"
                                   oninput="validateForm();">
                            <button type="button" class="pw-toggle" onclick="togglePw('confirmPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div id="matchMsg" style="font-size:12px;margin-top:-12px;margin-bottom:14px;display:none"></div>

                        <button type="submit" class="btn-submit-pw" id="submitBtn" disabled>
                            <i class="fas fa-save"></i> Lưu mật khẩu mới
                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
    <script>
        function togglePw(fieldId, btn) {
            const input = document.getElementById(fieldId);
            const icon  = btn.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'fas fa-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'fas fa-eye';
            }
        }

        function checkStrength(pw) {
            const fill  = document.getElementById('strengthFill');
            const label = document.getElementById('strengthLabel');
            let score = 0;
            if (pw.length >= 6)  { score++; setRule('rule-len', true); }
            else                 { setRule('rule-len', false); }
            if (/[A-Z]/.test(pw)) { score++; setRule('rule-upper', true); }
            else                  { setRule('rule-upper', false); }
            if (/[0-9]/.test(pw)) { score++; setRule('rule-num', true); }
            else                  { setRule('rule-num', false); }
            if (/[^A-Za-z0-9]/.test(pw)) score++;

            const levels = [
                { w: '0%',   bg: 'transparent', txt: '' },
                { w: '25%',  bg: '#ef4444',      txt: '😰 Yếu' },
                { w: '50%',  bg: '#f59e0b',      txt: '😐 Trung bình' },
                { w: '75%',  bg: '#3b82f6',      txt: '😊 Khá' },
                { w: '100%', bg: '#0d9488',      txt: '💪 Mạnh' },
            ];
            const lvl = levels[Math.min(score, 4)];
            fill.style.width      = lvl.w;
            fill.style.background = lvl.bg;
            label.textContent     = pw.length ? lvl.txt : '';
        }

        function setRule(id, valid) {
            const el = document.getElementById(id);
            const ic = el.querySelector('i');
            if (valid) {
                el.classList.add('valid');
                ic.className = 'fas fa-check-circle';
            } else {
                el.classList.remove('valid');
                ic.className = 'fas fa-circle';
            }
        }

        function validateForm() {
            const cur     = document.getElementById('currentPassword').value.trim();
            const newPw   = document.getElementById('newPassword').value;
            const confPw  = document.getElementById('confirmPassword').value;
            const matchEl = document.getElementById('matchMsg');
            const btn     = document.getElementById('submitBtn');

            let ok = true;

            if (newPw.length > 0 && confPw.length > 0) {
                if (newPw === confPw) {
                    matchEl.style.display = 'block';
                    matchEl.style.color   = '#0d9488';
                    matchEl.innerHTML     = '<i class="fas fa-check-circle me-1"></i>Mật khẩu khớp';
                } else {
                    matchEl.style.display = 'block';
                    matchEl.style.color   = '#ef4444';
                    matchEl.innerHTML     = '<i class="fas fa-times-circle me-1"></i>Mật khẩu không khớp';
                    ok = false;
                }
            } else {
                matchEl.style.display = 'none';
                if (!confPw.length) ok = false;
            }

            if (!cur || newPw.length < 6) ok = false;

            btn.disabled = !ok;
        }

        // Cũng bind currentPassword oninput
        document.getElementById('currentPassword').addEventListener('input', validateForm);
    </script>
</body>
</html>
