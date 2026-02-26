<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>

                    <!DOCTYPE html>
<html lang="vi">
                    <head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Quản lý Hàng đợi - Staff</title>
                        <style>
        .queue-item {
                                border: 1px solid #e5e7eb;
                                border-radius: 12px;
            padding: 16px;
            margin-bottom: 12px;
            transition: all 0.2s;
        }
        .queue-item:hover {
            border-color: #4361ee;
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.1);
        }
                            .patient-number {
                                width: 48px;
                                height: 48px;
                                border-radius: 50%;
                                background: #dbeafe;
                                color: #1d4ed8;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-weight: 700;
                                font-size: 18px;
                            }
                            .status-badge {
                                padding: 4px 12px;
                                border-radius: 20px;
            font-size: 12px;
                                font-weight: 600;
        }
        .status-badge.booked { background: #dbeafe; color: #1d4ed8; }
        .status-badge.completed { background: #d1fae5; color: #059669; }
        .status-badge.cancelled { background: #fee2e2; color: #dc2626; }
                            .status-select {
                                padding: 6px 10px;
                                border: 1px solid #dbeafe;
                                border-radius: 6px;
                                background: white;
            font-size: 12px;
                                min-width: 130px;
        }
        .action-btn {
                                width: 32px;
                                height: 32px;
                                border-radius: 50%;
                                border: none;
                                background: transparent;
                                cursor: pointer;
                                transition: all 0.2s;
                            }
        .action-btn:hover { background: #f0f9ff; }
                        </style>
                    </head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/staff/staff_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/staff/staff_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                        <h4 class="mb-1"><i class="fas fa-users me-2"></i>Quản lý Hàng đợi</h4>
                        <p class="text-muted mb-0">Danh sách bệnh nhân - <span id="current-time"></span></p>
                                </div>
                    <a href="${pageContext.request.contextPath}/StaffHandleQueueServlet" class="btn btn-outline-primary">
                        <i class="fas fa-sync-alt me-1"></i>Làm mới
                                </a>
                            </div>

                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card primary">
                            <div class="stat-card-icon"><i class="fas fa-users"></i></div>
                            <div class="stat-card-value">${totalAppointments}</div>
                            <div class="stat-card-label">Tổng số</div>
                                    </div>
                                </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon"><i class="fas fa-calendar-check"></i></div>
                            <div class="stat-card-value">${bookedCount}</div>
                            <div class="stat-card-label">Đã đặt lịch</div>
                                    </div>
                                </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon"><i class="fas fa-check-circle"></i></div>
                            <div class="stat-card-value">${completedCount}</div>
                            <div class="stat-card-label">Hoàn thành</div>
                                    </div>
                                </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card danger">
                            <div class="stat-card-icon"><i class="fas fa-times-circle"></i></div>
                            <div class="stat-card-value">${cancelledCount}</div>
                            <div class="stat-card-label">Đã hủy</div>
                                        </div>
                                    </div>
                            </div>

                            <!-- Queue List -->
                <div class="dashboard-card">
                    <h6 class="mb-4"><i class="fas fa-list me-2"></i>Danh sách hàng đợi - <span id="current-date"></span></h6>
                    
                                    <c:choose>
                                        <c:when test="${not empty appointments}">
                                            <c:forEach var="appointment" items="${appointments}" varStatus="status">
                                                <div class="queue-item">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <div class="patient-number">${status.index + 1}</div>
                                                        </div>
                                        <div class="col">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h6 class="mb-0">${appointment.patientName}</h6>
                                                                <c:choose>
                                                    <c:when test="${appointment.status == 'BOOKED' || appointment.status == 'WAITING_PAYMENT'}">
                                                        <span class="status-badge booked">Đã đặt lịch</span>
                                                                    </c:when>
                                                                    <c:when test="${appointment.status == 'COMPLETED'}">
                                                        <span class="status-badge completed">Hoàn thành</span>
                                                                    </c:when>
                                                                    <c:when test="${appointment.status == 'CANCELLED'}">
                                                        <span class="status-badge cancelled">Đã hủy</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                        <span class="status-badge">${appointment.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                            <div class="row g-3">
                                                <div class="col-md-3">
                                                    <small class="text-muted"><i class="fas fa-user-md me-1"></i>${appointment.doctorName}</small>
                                                                </div>
                                                <div class="col-md-3">
                                                    <small class="text-muted"><i class="fas fa-tooth me-1"></i>${appointment.serviceName}</small>
                                                                </div>
                                                <div class="col-md-3">
                                                    <small class="text-muted"><i class="fas fa-calendar me-1"></i>${appointment.workDate}</small>
                                                                </div>
                                                <div class="col-md-3">
                                                    <small class="text-muted"><i class="fas fa-phone me-1"></i>${appointment.patientPhone}</small>
                                                                </div>
                                                            </div>
                                                        </div>
                                        <div class="col-auto">
                                            <div class="d-flex align-items-center gap-2">
                                                <select class="status-select" onchange="updateStatus(${appointment.appointmentId}, this.value)">
                                                    <option value="BOOKED" ${appointment.status == 'BOOKED' || appointment.status == 'WAITING_PAYMENT' ? 'selected' : ''}>📅 Đã đặt lịch</option>
                                                    <option value="COMPLETED" ${appointment.status == 'COMPLETED' ? 'selected' : ''}>✅ Hoàn thành</option>
                                                    <option value="CANCELLED" ${appointment.status == 'CANCELLED' ? 'selected' : ''}>❌ Đã hủy</option>
                                                                </select>
                                                <button class="action-btn" onclick="callPatient('${appointment.patientPhone}')" title="Gọi điện">
                                                    <i class="fas fa-phone text-primary"></i>
                                                            </button>
                                                <button class="action-btn" onclick="copyPhone('${appointment.patientPhone}')" title="Copy SĐT">
                                                    <i class="fas fa-copy text-success"></i>
                                                            </button>
                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-calendar-times text-muted" style="font-size: 48px;"></i>
                                <h5 class="mt-3 text-muted">Chưa có lịch hẹn</h5>
                                <p class="text-muted">Hiện tại không có lịch hẹn nào trong hệ thống.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
        </main>
                        </div>
    
    <%@ include file="/view/layout/dashboard_scripts.jsp" %>

                        <script>
                            function updateCurrentTime() {
                                const now = new Date();
            document.getElementById('current-time').textContent = now.toLocaleTimeString('vi-VN');
            document.getElementById('current-date').textContent = now.toLocaleDateString('vi-VN');
        }
                            updateCurrentTime();
                            setInterval(updateCurrentTime, 1000);

        function updateStatus(appointmentId, newStatus) {
            fetch('${pageContext.request.contextPath}/StaffHandleQueueServlet', {
                                        method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=update_status&appointmentId=' + appointmentId + '&newStatus=' + newStatus
            }).then(response => {
                if (response.ok) {
                    if (typeof showToast === 'function') {
                        showToast('Cập nhật thành công!', 'success');
                    }
                    setTimeout(() => window.location.reload(), 500);
                }
            }).catch(err => {
                alert('Lỗi cập nhật trạng thái!');
            });
        }

        function callPatient(phone) {
            const cleanPhone = phone.replace(/\s+/g, '').replace(/[^\d+]/g, '');
            window.open('tel:' + cleanPhone, '_self');
        }

        function copyPhone(phone) {
            const cleanPhone = phone.replace(/\s+/g, '').replace(/[^\d+]/g, '');
                                if (navigator.clipboard) {
                                    navigator.clipboard.writeText(cleanPhone).then(() => {
                    if (typeof showToast === 'function') {
                        showToast('Đã copy số điện thoại!', 'success');
                    } else {
                        alert('Đã copy: ' + cleanPhone);
                    }
                                    });
                                } else {
                prompt('Copy số điện thoại:', cleanPhone);
            }
        }
                        </script>
                    </body>
                    </html>
