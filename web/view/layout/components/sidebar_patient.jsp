<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%--============================================PATIENT SIDEBAR - REFACTORED
        VERSION============================================File: sidebar_patient.jsp Purpose: Sidebar navigation cho
        role PATIENT Encoding: UTF-8 (đảm bảo hiển thị đúng tiếng Việt) Include từ: /jsp/patient/user_menu.jsp ✅
        Features: - Hardcode tất cả text tiếng Việt (không dùng parameter) - Font DejaVu Sans được apply - Clean code,
        dễ maintain - Responsive, accessible ⚠️ IMPORTANT: File này PHẢI được save với UTF-8 encoding (không có
        BOM)============================================--%>

        <nav class="dashboard-sidebar" id="sideMenu">
            <!-- Sidebar Header / Logo (click về Trang chủ) -->
            <div class="sidebar-header">
                <a href="${pageContext.request.contextPath}/UserHompageServlet" class="sidebar-logo"
                    title="Về trang chủ">
                    <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo Happy Smile">
                    <span class="sidebar-logo-text">HAPPY <em>Smile</em></span>
                </a>
            </div>

            <!-- Sidebar Menu -->
            <div class="sidebar-menu">

                <!-- ============================================
             SECTION 1: TỔNG QUAN (Overview)
             ============================================ -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Tổng quan</div>

                    <a href="${pageContext.request.contextPath}/UserHompageServlet" class="sidebar-item"
                        id="sidebar-home">
                        <i class="fas fa-home"></i>
                        <span>Trang chủ</span>
                    </a>
                </div>

                <!-- ============================================
             SECTION 2: DỊCH VỤ (Services)
             ============================================ -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Dịch vụ</div>

                    <a href="${pageContext.request.contextPath}/jsp/patient/user_services.jsp" class="sidebar-item" id="sidebar-services">
                        <i class="fas fa-tooth"></i>
                        <span>Dịch vụ Nha khoa</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/jsp/patient/user_datlich_bacsi.jsp" class="sidebar-item"
                        id="sidebar-appointments">
                        <i class="fas fa-calendar-check"></i>
                        <span>Lịch khám của tôi</span>
                    </a>
                </div>

                <!-- ============================================
             SECTION 3: TƯ VẤN (Consultation)
             ============================================ -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Tư vấn</div>

                    <div class="sidebar-dropdown" id="sidebar-consultation-dropdown">
                        <div class="sidebar-item sidebar-dropdown-toggle" onclick="toggleDropdown(this)" role="button"
                            aria-expanded="false" aria-controls="consultation-menu">
                            <i class="fas fa-headset"></i>
                            <span>Tư vấn</span>
                            <i class="fas fa-chevron-down ms-auto" style="font-size: 10px;"></i>
                        </div>
                        <div class="sidebar-dropdown-menu" id="consultation-menu">
                            <a href="${pageContext.request.contextPath}/jsp/patient/user_chatAI.jsp"
                                class="sidebar-dropdown-item" id="sidebar-ai-consultation">
                                <i class="fas fa-robot me-2"></i>
                                Tư vấn với AI
                            </a>
                            <a href="${pageContext.request.contextPath}/public/chat.jsp" class="sidebar-dropdown-item"
                                id="sidebar-doctor-chat">
                                <i class="fas fa-user-md me-2"></i>
                                Nhắn tin với bác sĩ
                            </a>
                        </div>
                    </div>
                </div>

                <!-- ============================================
             SECTION 4: TÀI KHOẢN (Account)
             ============================================ -->
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Tài khoản</div>

                    <a href="${pageContext.request.contextPath}/jsp/patient/user_taikhoan.jsp" class="sidebar-item"
                        id="sidebar-account">
                        <i class="fas fa-user-circle"></i>
                        <span>Tài khoản của tôi</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/jsp/patient/user_datlich_bacsi.jsp" class="sidebar-item"
                        id="sidebar-medical-record">
                        <i class="fas fa-file-medical"></i>
                        <span>Hồ sơ y tế</span>
                    </a>

                </div>
            </div>
        </nav>
        <%-- Style & script cho sidebar đã chuyển sang dashboard.css và dashboard-simple.js --%>