<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="doctor_header.jsp" %>
        <%@ include file="doctor_menu.jsp" %>

            <!-- Link to common dashboard CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-common.css">

            <%
                String errorType = request.getParameter("error");
                String errorTitle = "Đã xảy ra lỗi";
                String errorMessage = "Không thể xử lý yêu cầu của bạn lúc này.";
                String errorIcon = "fa-exclamation-triangle";
                String errorColor = "#DC3545";
                Object errorMsg = request.getAttribute("errorMessage");
                if (errorMsg == null) {
                    errorMsg = request.getAttribute("error");
                }
                if (errorMsg != null) {
                    errorMessage = errorMsg.toString();
                }
                if ("missing_params".equals(errorType)) {
                    errorTitle = "Thiếu thông tin";
                    errorMessage = "Vui lòng cung cấp đầy đủ thông tin để xem báo cáo.";
                    errorIcon = "fa-info-circle";
                    errorColor = "#FFC107";
                } else if ("invalid_id".equals(errorType)) {
                    errorTitle = "Thông tin không hợp lệ";
                    errorMessage = "ID báo cáo hoặc cuộc hẹn không đúng định dạng.";
                    errorIcon = "fa-times-circle";
                    errorColor = "#DC3545";
                } else if ("system_error".equals(errorType)) {
                    errorTitle = "Lỗi hệ thống";
                    errorMessage = "Hệ thống đang gặp sự cố. Vui lòng thử lại sau hoặc liên hệ bộ phận kỹ thuật.";
                    errorIcon = "fa-server";
                    errorColor = "#DC3545";
                }
            %>

                <style>
                    .error-container {
                        padding-left: 282px;
                        padding-top: 15px;
                        margin-right: 50px;
                        min-height: 100vh;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        background: var(--background-light);
                    }

                    #menu-toggle:checked~.error-container {
                        transform: translateX(-125px);
                        transition: transform var(--transition-normal);
                    }

                    .error-card {
                        background: var(--background-white);
                        border-radius: var(--border-radius-lg);
                        box-shadow: var(--shadow-lg);
                        padding: 48px 40px;
                        text-align: center;
                        max-width: 600px;
                        width: 100%;
                        animation: fadeInUp 0.5s ease;
                    }

                    @keyframes fadeInUp {
                        from {
                            opacity: 0;
                            transform: translateY(30px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .error-icon-wrapper {
                        width: 100px;
                        height: 100px;
                        margin: 0 auto 24px;
                        background: linear-gradient(135deg, <%=errorColor %>15 0%, <%=errorColor %>25 100%);
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        animation: pulse 2s ease-in-out infinite;
                    }

                    @keyframes pulse {

                        0%,
                        100% {
                            transform: scale(1);
                        }

                        50% {
                            transform: scale(1.05);
                        }
                    }

                    .error-icon {
                        font-size: 48px;
                        color: <%=errorColor %>;
                    }

                    .error-title {
                        font-size: 24px;
                        font-weight: 700;
                        color: var(--text-primary);
                        margin-bottom: 12px;
                    }

                    .error-message {
                        color: var(--text-secondary);
                        margin-bottom: 32px;
                        line-height: 1.6;
                        font-size: 15px;
                    }

                    .error-code {
                        display: inline-block;
                        background: var(--background-light);
                        color: var(--text-muted);
                        padding: 6px 12px;
                        border-radius: var(--border-radius);
                        font-size: 12px;
                        font-family: 'Courier New', monospace;
                        margin-bottom: 24px;
                    }

                    .error-actions {
                        display: flex;
                        gap: 12px;
                        justify-content: center;
                        flex-wrap: wrap;
                    }

                    .error-btn {
                        padding: 12px 28px;
                        border: none;
                        border-radius: var(--border-radius);
                        font-size: 14px;
                        font-weight: 600;
                        cursor: pointer;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        transition: all var(--transition-fast);
                    }

                    .error-btn-primary {
                        background-color: var(--primary-color);
                        color: var(--background-white);
                    }

                    .error-btn-primary:hover {
                        background-color: var(--primary-hover);
                        transform: translateY(-2px);
                        box-shadow: var(--shadow-md);
                    }

                    .error-btn-secondary {
                        background-color: var(--background-light);
                        color: var(--text-primary);
                        border: 1px solid var(--border-color);
                    }

                    .error-btn-secondary:hover {
                        background-color: var(--border-color);
                        transform: translateY(-2px);
                    }

                    .error-help {
                        margin-top: 32px;
                        padding-top: 24px;
                        border-top: 1px solid var(--border-color);
                    }

                    .error-help-title {
                        font-size: 13px;
                        font-weight: 600;
                        color: var(--text-secondary);
                        margin-bottom: 12px;
                    }

                    .error-help-items {
                        display: flex;
                        gap: 24px;
                        justify-content: center;
                        flex-wrap: wrap;
                    }

                    .error-help-item {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        color: var(--text-muted);
                        font-size: 13px;
                        text-decoration: none;
                        transition: color var(--transition-fast);
                    }

                    .error-help-item:hover {
                        color: var(--primary-color);
                    }

                    .error-help-item i {
                        font-size: 16px;
                    }

                    /* Responsive */
                    @media (max-width: 768px) {
                        .error-container {
                            padding-left: 20px;
                            padding-right: 20px;
                        }

                        .error-card {
                            padding: 36px 24px;
                        }

                        .error-actions {
                            flex-direction: column;
                        }

                        .error-btn {
                            width: 100%;
                            justify-content: center;
                        }
                    }
                </style>

                <div class="error-container">
                    <div class="error-card">
                        <div class="error-icon-wrapper">
                            <i class="fas <%= errorIcon %> error-icon"></i>
                        </div>

                        <h2 class="error-title">
                            <%= errorTitle %>
                        </h2>
                        <p class="error-message">
                            <%= errorMessage %>
                        </p>

                        <% if (errorType !=null) { %>
                            <div class="error-code">
                                <i class="fas fa-code"></i> ERROR_CODE: <%= errorType.toUpperCase() %>
                            </div>
                            <% } %>

                                <div class="error-actions">
                                    <a href="javascript:history.back()" class="error-btn error-btn-secondary">
                                        <i class="fas fa-arrow-left"></i> Quay lại
                                    </a>
                                    <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet"
                                        class="error-btn error-btn-primary">
                                        <i class="fas fa-home"></i> Về trang chủ
                                    </a>
                                </div>

                                <div class="error-help">
                                    <div class="error-help-title">Cần hỗ trợ?</div>
                                    <div class="error-help-items">
                                        <a href="tel:1900xxxx" class="error-help-item">
                                            <i class="fas fa-phone"></i>
                                            <span>1900-xxxx</span>
                                        </a>
                                        <a href="mailto:support@clinic.com" class="error-help-item">
                                            <i class="fas fa-envelope"></i>
                                            <span>support@clinic.com</span>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/help" class="error-help-item">
                                            <i class="fas fa-question-circle"></i>
                                            <span>Trung tâm trợ giúp</span>
                                        </a>
                                    </div>
                                </div>
                    </div>
                </div>