<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Quản lý lịch hẹn - Doctor</title>
    <style>
        .appointment-card {
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s;
        }
        .appointment-card:hover {
            box-shadow: 0 4px 15px rgba(67, 97, 238, 0.1);
            transform: translateY(-2px);
        }
        .appointment-card.booked { border-left: 4px solid #3b82f6; }
        .appointment-card.completed { border-left: 4px solid #10b981; }
        .appointment-card.cancelled { border-left: 4px solid #ef4444; }
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-booked { background: #dbeafe; color: #1e40af; }
        .status-completed { background: #d1fae5; color: #065f46; }
        .status-cancelled { background: #fee2e2; color: #991b1b; }
        .time-badge {
            background: linear-gradient(45deg, #4361ee, #3f37c9);
            color: white;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/doctor/doctor_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-calendar-check me-2"></i>Quản lý lịch hẹn</h4>
                        <p class="text-muted mb-0">Theo dõi và quản lý lịch hẹn bệnh nhân</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/jsp/doctor/doctor_dangkilich.jsp" class="btn btn-warning">
                        <i class="fas fa-calendar-times me-1"></i>Đăng ký nghỉ
                    </a>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card primary">
                            <div class="stat-card-icon"><i class="fas fa-calendar"></i></div>
                            <div class="stat-card-value">${stats.total}</div>
                            <div class="stat-card-label">Tổng lịch hẹn</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon"><i class="fas fa-clock"></i></div>
                            <div class="stat-card-value">${stats.booked}</div>
                            <div class="stat-card-label">Đã đặt</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon"><i class="fas fa-check-circle"></i></div>
                            <div class="stat-card-value">${stats.completed}</div>
                            <div class="stat-card-label">Hoàn thành</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card danger">
                            <div class="stat-card-icon"><i class="fas fa-times-circle"></i></div>
                            <div class="stat-card-value">${stats.cancelled}</div>
                            <div class="stat-card-label">Đã hủy</div>
                        </div>
                    </div>
                </div>
                
                <!-- Filter Section -->
                <div class="dashboard-card mb-4">
                    <form id="filterForm" method="GET">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-select" onchange="this.form.submit()">
                                    <option value="">Tất cả</option>
                                    <option value="BOOKED" ${param.status == 'BOOKED' ? 'selected' : ''}>Đã đặt</option>
                                    <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                                    <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Từ ngày</label>
                                <input type="date" name="fromDate" class="form-control" value="${param.fromDate}" onchange="this.form.submit()">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Đến ngày</label>
                                <input type="date" name="toDate" class="form-control" value="${param.toDate}" onchange="this.form.submit()">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Tìm kiếm</label>
                                <input type="text" name="search" class="form-control" placeholder="Tên bệnh nhân..." value="${param.search}">
                            </div>
                        </div>
                    </form>
                </div>
                
                <!-- Appointments List -->
                <div class="dashboard-card">
                    <h6 class="mb-4"><i class="fas fa-list me-2"></i>Danh sách lịch hẹn</h6>
                    
                    <c:forEach items="${appointments}" var="appointment">
                        <div class="appointment-card ${appointment.status.toLowerCase()}">
                            <div class="row align-items-center">
                                <div class="col-md-3">
                                    <h6 class="mb-1">
                                        <i class="fas fa-user me-2 text-primary"></i>${appointment.patientName}
                                    </h6>
                                    <small class="text-muted"><i class="fas fa-phone me-1"></i>${appointment.patientPhone}</small>
                                </div>
                                <div class="col-md-2">
                                    <span class="time-badge">
                                        <i class="fas fa-clock me-1"></i>${appointment.timeSlot}
                                    </span>
                                </div>
                                <div class="col-md-2">
                                    <span class="status-badge status-${appointment.status.toLowerCase()}">
                                        ${appointment.statusDisplay}
                                    </span>
                                </div>
                                <div class="col-md-2">
                                    <small class="text-muted">
                                        <i class="fas fa-calendar me-1"></i>
                                        <fmt:formatDate value="${appointment.workDate}" pattern="dd/MM/yyyy" />
                                    </small>
                                </div>
                                <div class="col-md-3 text-end">
                                    <c:if test="${appointment.status == 'BOOKED'}">
                                        <button class="btn btn-sm btn-outline-primary me-1" onclick="viewAppointment(${appointment.appointmentId})">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-warning" onclick="showRescheduleModal(${appointment.appointmentId})">
                                            <i class="fas fa-exchange-alt"></i>
                                        </button>
                                    </c:if>
                                    <c:if test="${appointment.status == 'COMPLETED'}">
                                        <button class="btn btn-sm btn-outline-success" onclick="viewReport(${appointment.appointmentId})">
                                            <i class="fas fa-file-medical"></i> Báo cáo
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                            <c:if test="${not empty appointment.reason}">
                                <div class="mt-2">
                                    <small class="text-muted"><i class="fas fa-comment me-1"></i>Lý do: ${appointment.reason}</small>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                    
                    <c:if test="${empty appointments}">
                        <div class="text-center py-5">
                            <i class="fas fa-calendar-times text-muted" style="font-size: 48px;"></i>
                            <h5 class="mt-3 text-muted">Không có lịch hẹn nào</h5>
                            <p class="text-muted">Hãy thử thay đổi bộ lọc để tìm kiếm</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Reschedule Modal -->
    <div class="modal fade" id="rescheduleModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-exchange-alt me-2"></i>Chuyển lịch hẹn</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="rescheduleContent">
                    <div class="text-center py-4">
                        <div class="spinner-border text-primary" role="status"></div>
                        <p class="mt-2 text-muted">Đang tải...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function viewAppointment(appointmentId) {
            window.open('${pageContext.request.contextPath}/jsp/doctor/doctor_phieukham.jsp?appointmentId=' + appointmentId, '_blank');
        }

        function viewReport(appointmentId) {
            window.open('${pageContext.request.contextPath}/jsp/doctor/doctor_viewMedicalReport.jsp?appointmentId=' + appointmentId, '_blank');
        }

        function showRescheduleModal(appointmentId) {
            const modal = new bootstrap.Modal(document.getElementById('rescheduleModal'));
            modal.show();
            loadRescheduleContent(appointmentId);
        }

        function loadRescheduleContent(appointmentId) {
            const content = document.getElementById('rescheduleContent');
            content.innerHTML = '<div class="text-center py-4"><div class="spinner-border text-primary"></div></div>';

            fetch('${pageContext.request.contextPath}/RescheduleAppointmentServlet?action=get_reschedule_options&appointmentId=' + appointmentId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        displayRescheduleOptions(data, appointmentId);
                    } else {
                        content.innerHTML = '<div class="alert alert-danger">' + data.message + '</div>';
                    }
                })
                .catch(error => {
                    content.innerHTML = '<div class="alert alert-danger">Có lỗi xảy ra khi tải thông tin</div>';
                });
        }

        function displayRescheduleOptions(data, appointmentId) {
            const content = document.getElementById('rescheduleContent');
            let html = '<div class="mb-4"><h6>Thông tin lịch hẹn hiện tại:</h6><div class="alert alert-info"><strong>Bệnh nhân:</strong> ' + data.currentAppointment.patientName + '<br><strong>Thời gian:</strong> ' + data.currentAppointment.timeSlot + '<br><strong>Ngày:</strong> ' + data.currentAppointment.workDate + '</div></div>';

            if (data.availableDoctors && data.availableDoctors.length > 0) {
                html += '<h6>Chọn bác sĩ thay thế:</h6><div class="row">';
                data.availableDoctors.forEach(doctor => {
                    html += '<div class="col-md-6 mb-3"><div class="dashboard-card"><h6>' + doctor.fullName + '</h6><p class="text-muted small">' + doctor.specialty + '</p><button class="btn btn-sm btn-primary" onclick="selectReplacementDoctor(' + appointmentId + ', ' + doctor.doctorId + ')">Chọn bác sĩ này</button></div></div>';
                });
                html += '</div>';
            } else {
                html += '<div class="alert alert-warning"><i class="fas fa-exclamation-triangle me-2"></i>Không có bác sĩ thay thế khả dụng.</div>';
            }

            html += '<div class="text-end mt-4"><button class="btn btn-secondary me-2" data-bs-dismiss="modal">Đóng</button><button class="btn btn-warning" onclick="autoReschedule(' + appointmentId + ')"><i class="fas fa-magic me-1"></i>Tự động chuyển lịch</button></div>';
            content.innerHTML = html;
        }

        function selectReplacementDoctor(appointmentId, newDoctorId) {
            if (confirm('Bạn có chắc chắn muốn chuyển lịch hẹn sang bác sĩ này?')) {
                performReschedule(appointmentId, newDoctorId);
            }
        }

        function autoReschedule(appointmentId) {
            if (confirm('Hệ thống sẽ tự động tìm bác sĩ thay thế phù hợp nhất. Tiếp tục?')) {
                performReschedule(appointmentId, null);
            }
        }

        function performReschedule(appointmentId, newDoctorId) {
            const formData = new FormData();
            formData.append('action', 'auto_reschedule');
            formData.append('appointmentId', appointmentId);
            if (newDoctorId) formData.append('newDoctorId', newDoctorId);

            fetch('${pageContext.request.contextPath}/RescheduleAppointmentServlet', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    if (typeof showToast === 'function') {
                        showToast('Chuyển lịch thành công!', 'success');
                    } else {
                        alert('Chuyển lịch thành công!');
                    }
                    bootstrap.Modal.getInstance(document.getElementById('rescheduleModal')).hide();
                    window.location.reload();
                } else {
                    alert('Có lỗi xảy ra: ' + data.message);
                }
            })
            .catch(error => {
                alert('Có lỗi xảy ra khi chuyển lịch hẹn');
            });
        }
    </script>
</body>
</html>
