<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Lịch trong ngày - Bác sĩ</title>
    <style>
        .stat-card-custom {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background: #fff;
            padding: 1.5rem;
            height: 100%;
        }
        .stat-card-custom:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 1rem;
        }
        .appointment-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            margin-bottom: 1rem;
            transition: all 0.2s ease;
        }
        .appointment-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .card-waiting { border-left: 4px solid #4E80EE; }
        .card-completed { border-left: 4px solid #10b981; }
        
        .patient-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #f8fafc;
        }
        .column-header {
            background-color: #f8fafc;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .column-header h3 {
            font-size: 1.1rem;
            font-weight: 700;
            margin: 0;
            color: #1e293b;
        }
        .btn-action {
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
            font-weight: 600;
            border-radius: 8px;
        }
        .empty-state {
            padding: 3rem;
            text-align: center;
            background: #f8fafc;
            border-radius: 12px;
            border: 2px dashed #e2e8f0;
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
                    
                    <%-- Dữ liệu Java --%>
                    <%
                        List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                        String selectedDate = (String) request.getAttribute("selectedDate");
                        String selectedDateDisplay = (String) request.getAttribute("selectedDateDisplay");
                        Boolean isToday = (Boolean) request.getAttribute("isToday");
                        
                        int total = appointments != null ? appointments.size() : 0;
                        int waiting = 0;
                        int completed = 0;
                        if (appointments != null) {
                            for (Appointment a : appointments) {
                                String status = a.getStatus() != null ? a.getStatus().trim() : "";
                                if ("booked".equalsIgnoreCase(status)) waiting++;
                                else if ("completed".equalsIgnoreCase(status)) completed++;
                            }
                        }
                    %>

                    <%-- Header Section --%>
                    <div class="row align-items-center mb-4 g-3">
                        <div class="col-md-6">
                            <h2 class="h4 fw-bold text-dark m-0">
                                <i class="fas fa-calendar-day me-2 text-primary"></i>
                                Lịch khám ngày: <%= selectedDateDisplay %> 
                                <% if (Boolean.TRUE.equals(isToday)) { %>
                                    <span class="badge bg-success-subtle text-success ms-2 fs-6">Hôm nay</span>
                                <% } %>
                            </h2>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <form method="get" action="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="d-inline-flex align-items-center gap-2">
                                <label class="small fw-bold text-muted d-none d-sm-block">Chọn ngày:</label>
                                <input type="date" name="date" class="form-control form-control-sm w-auto" value="<%= selectedDate %>" onchange="this.form.submit()">
                                <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="btn btn-sm btn-primary">Hôm nay</a>
                            </form>
                        </div>
                    </div>

                    <%-- Stats Section --%>
                    <div class="row mb-5 g-4">
                        <div class="col-xl-3 col-sm-6">
                            <div class="stat-card-custom">
                                <div class="stat-icon bg-primary-subtle text-primary">
                                    <i class="fas fa-users"></i>
                                </div>
                                <h3 class="h2 fw-bold mb-1"><%= total %></h3>
                                <p class="text-muted small mb-0 fw-medium">Tổng lượt khám</p>
                            </div>
                        </div>
                        <div class="col-xl-3 col-sm-6">
                            <div class="stat-card-custom">
                                <div class="stat-icon bg-info-subtle text-info">
                                    <i class="fas fa-calendar-check"></i>
                                </div>
                                <h3 class="h2 fw-bold mb-1"><%= total %></h3>
                                <p class="text-muted small mb-0 fw-medium">Tổng lịch trong ngày</p>
                            </div>
                        </div>
                        <div class="col-xl-3 col-sm-6">
                            <div class="stat-card-custom">
                                <div class="stat-icon bg-warning-subtle text-warning">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <h3 class="h2 fw-bold mb-1"><%= waiting %></h3>
                                <p class="text-muted small mb-0 fw-medium">Đang chờ khám</p>
                            </div>
                        </div>
                        <div class="col-xl-3 col-sm-6">
                            <div class="stat-card-custom">
                                <div class="stat-icon bg-success-subtle text-success">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <h3 class="h2 fw-bold mb-1"><%= completed %></h3>
                                <p class="text-muted small mb-0 fw-medium">Đã khám xong</p>
                            </div>
                        </div>
                    </div>

                    <%-- Two-Column Layout --%>
                    <div class="row g-4">
                        <%-- Cột Đang chờ khám --%>
                        <div class="col-lg-6">
                            <div class="column-header">
                                <h3><i class="fas fa-hourglass-half me-2 text-warning"></i>Đang chờ khám</h3>
                                <span class="badge bg-warning text-white rounded-pill px-3"><%= waiting %> ca</span>
                            </div>
                            
                            <div class="appointment-list">
                                <%
                                    boolean hasWaiting = false;
                                    if (appointments != null) {
                                        for (Appointment app : appointments) {
                                            String status = app.getStatus() != null ? app.getStatus().trim() : "";
                                            if ("booked".equalsIgnoreCase(status)) {
                                                hasWaiting = true;
                                                String timeStr = app.getStartTime() + " - " + app.getEndTime();
                                %>
                                <div class="card appointment-card card-waiting">
                                    <div class="card-body p-4">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <div class="d-flex align-items-center gap-2 text-primary fw-bold">
                                                <i class="far fa-clock"></i>
                                                <span><%= timeStr %></span>
                                            </div>
                                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2">Chờ khám</span>
                                        </div>
                                        
                                        <div class="d-flex align-items-center mb-3">
                                            <img src="${pageContext.request.contextPath}/view/assets/img/default-user-avatar.png" class="patient-avatar me-3" alt="Patient">
                                            <div>
                                                <h5 class="mb-1 fw-bold text-dark"><%= app.getPatientName() %></h5>
                                                <p class="mb-0 text-muted small">Mã BN: #<%= app.getPatientId() %> | Mã LH: #<%= app.getAppointmentId() %></p>
                                            </div>
                                        </div>
                                        
                                        <div class="bg-light p-2 rounded mb-3 small border">
                                            <span class="fw-bold text-secondary">Lý do:</span> <%= app.getReason() %>
                                        </div>
                                        
                                        <div class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/jsp/doctor/doctor_phieukham.jsp?appointmentId=<%=app.getAppointmentId()%>" class="btn btn-primary btn-action flex-grow-1 shadow-sm">
                                                <i class="fas fa-file-signature me-1"></i> Tạo phiếu khám
                                            </a>
                                            <form method="post" action="${pageContext.request.contextPath}/updateAppointmentStatus" class="d-inline">
                                                <input type="hidden" name="appointmentId" value="<%=app.getAppointmentId()%>">
                                                <input type="hidden" name="status" value="completed">
                                                <button type="submit" class="btn btn-success btn-action shadow-sm" onclick="return confirm('Xác nhận BN <%= app.getPatientName() %> đã khám xong?')">
                                                    <i class="fas fa-check"></i> Xong
                                                </button>
                                            </form>
                                            <button class="btn btn-outline-secondary btn-action" title="Chi tiết" onclick="location.href='${pageContext.request.contextPath}/AppointmentDetail?id=<%= app.getAppointmentId() %>'">
                                                <i class="fas fa-info-circle"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <%
                                            }
                                        }
                                    }
                                    if (!hasWaiting) {
                                %>
                                <div class="empty-state">
                                    <div class="stat-icon bg-light text-muted mx-auto" style="width: 80px; height: 80px; font-size: 40px;">
                                        <i class="fas fa-calendar-check"></i>
                                    </div>
                                    <h5 class="fw-bold text-dark mt-3">Không có lịch chờ</h5>
                                    <p class="text-muted px-4 mb-0">Tất cả bệnh nhân trong danh sách chờ đã được bác sĩ tiếp nhận hoặc chưa có lịch hẹn mới.</p>
                                </div>
                                <% } %>
                            </div>
                        </div>

                        <%-- Cột Đã khám xong --%>
                        <div class="col-lg-6">
                            <div class="column-header">
                                <h3><i class="fas fa-check-double me-2 text-success"></i>Đã khám xong</h3>
                                <span class="badge bg-success text-white rounded-pill px-3"><%= completed %> ca</span>
                            </div>
                            
                            <div class="appointment-list">
                                <%
                                    boolean hasCompleted = false;
                                    if (appointments != null) {
                                        for (Appointment app : appointments) {
                                            String status = app.getStatus() != null ? app.getStatus().trim() : "";
                                            if ("completed".equalsIgnoreCase(status)) {
                                                hasCompleted = true;
                                                String timeStr = app.getStartTime() + " - " + app.getEndTime();
                                %>
                                <div class="card appointment-card card-completed opacity-75">
                                    <div class="card-body p-4">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <div class="d-flex align-items-center gap-2 text-success fw-bold">
                                                <i class="far fa-clock"></i>
                                                <span><%= timeStr %></span>
                                            </div>
                                            <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2">Hoàn tất</span>
                                        </div>
                                        
                                        <div class="d-flex align-items-center mb-3">
                                            <img src="${pageContext.request.contextPath}/view/assets/img/default-user-avatar.png" class="patient-avatar me-3" alt="Patient">
                                            <div>
                                                <h5 class="mb-1 fw-bold text-dark text-decoration-line-through"><%= app.getPatientName() %></h5>
                                                <p class="mb-0 text-muted small">Mã BN: #<%= app.getPatientId() %> | Mã LH: #<%= app.getAppointmentId() %></p>
                                            </div>
                                        </div>
                                        
                                        <div class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/ViewReportServlet?appointmentId=<%=app.getAppointmentId()%>" class="btn btn-outline-success btn-action flex-grow-1">
                                                <i class="fas fa-eye me-1"></i> Xem kết quả khám
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <%
                                            }
                                        }
                                    }
                                    if (!hasCompleted) {
                                %>
                                <div class="empty-state">
                                    <div class="stat-icon bg-light text-muted mx-auto" style="width: 80px; height: 80px; font-size: 40px;">
                                        <i class="fas fa-notes-medical"></i>
                                    </div>
                                    <h5 class="fw-bold text-dark mt-3">Chưa có ca hoàn tất</h5>
                                    <p class="text-muted px-4 mb-0">Danh sách các bệnh nhân đã hoàn thành bước khám và điều trị sẽ xuất hiện tại đây.</p>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
        </main>
    </div>

    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
    <script>
        // Tự động tải lại trang sau mỗi 5 phút
        setTimeout(function () {
            location.reload();
        }, 300000);
    </script>
</body>
</html>
