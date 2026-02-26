<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="doctor_header.jsp" %>
        <%@ include file="doctor_menu.jsp" %>

            <!-- Link to common dashboard CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-common.css">

            <style>
                /* Specific styles for success page using dashboard variables */
                .success-container {
                    padding-left: 282px;
                    padding-top: 15px;
                    margin-right: 50px;
                    min-height: 100vh;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                }

                #menu-toggle:checked~.success-container {
                    transform: translateX(-125px);
                    transition: transform var(--transition-normal);
                }

                .success-card {
                    background: var(--background-white);
                    border-radius: var(--border-radius-lg);
                    box-shadow: var(--shadow-lg);
                    padding: 40px;
                    text-align: center;
                    max-width: 500px;
                    width: 100%;
                    animation: fadeIn 0.5s ease;
                }

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        transform: translateY(20px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .success-icon {
                    font-size: 64px;
                    color: var(--success-color);
                    margin-bottom: 20px;
                    animation: scaleIn 0.6s ease;
                }

                @keyframes scaleIn {
                    from {
                        transform: scale(0);
                    }

                    to {
                        transform: scale(1);
                    }
                }

                .success-title {
                    font-size: 24px;
                    font-weight: 700;
                    color: var(--success-color);
                    margin-bottom: 15px;
                }

                .success-message {
                    color: var(--text-secondary);
                    margin-bottom: 30px;
                    line-height: 1.6;
                    font-size: 14px;
                }

                .success-actions {
                    display: flex;
                    gap: 15px;
                    justify-content: center;
                    flex-wrap: wrap;
                }

                .success-btn {
                    padding: 12px 24px;
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

                .success-btn-primary {
                    background-color: var(--primary-color);
                    color: var(--background-white);
                }

                .success-btn-primary:hover {
                    background-color: var(--primary-hover);
                    transform: translateY(-2px);
                    box-shadow: var(--shadow-md);
                }

                .success-btn-secondary {
                    background-color: var(--background-light);
                    color: var(--text-primary);
                    border: 1px solid var(--border-color);
                }

                .success-btn-secondary:hover {
                    background-color: var(--border-color);
                    transform: translateY(-2px);
                }

                /* Responsive */
                @media (max-width: 768px) {
                    .success-container {
                        padding-left: 20px;
                        padding-right: 20px;
                    }

                    .success-card {
                        padding: 30px 20px;
                    }

                    .success-actions {
                        flex-direction: column;
                    }

                    .success-btn {
                        width: 100%;
                        justify-content: center;
                    }
                }
            </style>

            <div class="success-container">
                <div class="success-card">
                    <div class="success-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h2 class="success-title">Lưu phiếu khám thành công!</h2>
                    <p class="success-message">
                        Phiếu khám bệnh đã được tạo và lưu vào hệ thống thành công.
                        Đơn thuốc đã được xử lý và cập nhật kho.
                    </p>
                    <div class="success-actions">
                        <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet"
                            class="success-btn success-btn-primary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                        <a href="${pageContext.request.contextPath}/completedAppointments"
                            class="success-btn success-btn-secondary">
                            <i class="fas fa-clipboard-check"></i> Xem kết quả khám
                        </a>
                    </div>
                </div>
            </div>