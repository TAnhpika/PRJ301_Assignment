<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.Appointment" %>
<%@page import="java.util.List" %>
<%@page import="model.Doctors" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="model.User" %>
<%@page import="model.Patients" %>
<%@page import="dao.PatientDAO" %>
<%@page import="dao.AppointmentDAO" %>
<%@page import="dao.DoctorDAO" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Lịch khám của tôi - Happy Smile</title>
    <style>
        :root {
            --primary-color: #4E80EE;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
        }
        
        body {
            background-color: #f8fafc;
        }

        .dashboard-content {
            padding: 2rem;
        }

        .card {
            border-radius: 12px;
            overflow: hidden;
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .card-header {
            background-color: #fff;
            border-bottom: 1px solid #f1f5f9;
            padding: 1.25rem 1.5rem;
        }

        .card-header h2, .card-header h3 {
            margin-bottom: 0;
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e293b;
        }

        .table thead th {
            background-color: #f8fafc;
            color: #64748b;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-weight: 600;
            border-top: none;
            padding: 1rem 1.5rem;
        }

        .table tbody td {
            padding: 1rem 1.5rem;
            vertical-align: middle;
            color: #334155;
            font-size: 0.9375rem;
        }

        .status-badge {
            padding: 0.35em 0.8em;
            font-weight: 600;
            font-size: 0.75rem;
        }

        .btn-action {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
            font-weight: 500;
            border-radius: 8px;
            transition: all 0.2s;
        }

        .pagination .page-link {
            border: none;
            margin: 0 2px;
            border-radius: 6px;
            color: #64748b;
            font-weight: 500;
        }

        .pagination .page-item.active .page-link {
            background-color: var(--primary-color);
            color: #fff;
        }

        .reason-cell {
            max-width: 250px;
        }

        .reason-text {
            display: inline-block;
            max-width: 100%;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .empty-state {
            padding: 4rem 2rem;
            text-align: center;
        }

        .empty-state i {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 1rem;
        }
    </style>
</head>

<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/patient/user_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/patient/user_header.jsp" %>
            
            <div class="dashboard-content">
                <div class="container-fluid">
                    <div class="row mb-4">
                        <div class="col-12">
                            <h2 class="h4 fw-bold text-dark"><i class="fas fa-calendar-alt me-2 text-primary"></i>Lịch khám bệnh</h2>
                            <p class="text-muted small mb-0">Theo dõi và quản lý các lịch hẹn khám nha khoa của bạn và người thân.</p>
                        </div>
                    </div>

                    <% 
                        List<Appointment> appointment = (List<Appointment>) request.getAttribute("appointment");
                        List<Appointment> relativeAppointments = (List<Appointment>) request.getAttribute("relativeAppointments");
                        
                        // Backend data fetching fallback if accessed directly
                        if (appointment == null || relativeAppointments == null) {
                            User u = (User) session.getAttribute("user");
                            if (u != null) {
                                if (appointment == null) {
                                    Patients p = PatientDAO.getPatientByUserId(u.getId());
                                    if (p != null) {
                                        appointment = AppointmentDAO.getAppointmentsByPatientId(p.getPatientId());
                                        // Load doctor names
                                        if (appointment != null) {
                                            for (Appointment apt : appointment) {
                                                if (apt.getDoctorName() == null || apt.getDoctorName().isEmpty()) {
                                                    Doctors d = DoctorDAO.getDoctorById((int)apt.getDoctorId());
                                                    if (d != null) apt.setDoctorName(d.getFull_name());
                                                }
                                            }
                                        }
                                    }
                                }
                                if (relativeAppointments == null) {
                                    relativeAppointments = AppointmentDAO.getRelativeAppointments(u.getId());
                                    // Load doctor and patient names for relative appointments
                                    if (relativeAppointments != null) {
                                        for (Appointment apt : relativeAppointments) {
                                            if (apt.getDoctorName() == null || apt.getDoctorName().isEmpty()) {
                                                Doctors d = DoctorDAO.getDoctorById((int)apt.getDoctorId());
                                                if (d != null) apt.setDoctorName(d.getFull_name());
                                            }
                                            if (apt.getPatientName() == null || apt.getPatientName().isEmpty()) {
                                                Patients p = PatientDAO.getPatientById(apt.getPatientId());
                                                if (p != null) apt.setPatientName(p.getFullName());
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    %>

                    <%-- Personal Appointments --%>
                    <div class="card mb-5">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3><i class="fas fa-user me-2 text-primary"></i>Lịch hẹn của bạn</h3>
                            <% if (appointment != null && !appointment.isEmpty()) { %>
                                <span class="badge bg-light text-dark border"><%= appointment.size() %> cuộc hẹn</span>
                            <% } %>
                        </div>
                        <div class="card-body p-0">
                        <% 
                            int itemsPerPage = 5;
                            int currentPage = 1;
                            String pageParam = request.getParameter("page");
                            if (pageParam != null && !pageParam.isEmpty()) {
                                try {
                                    currentPage = Integer.parseInt(pageParam);
                                } catch (NumberFormatException e) {
                                    currentPage = 1;
                                }
                            }

                            if (appointment != null && !appointment.isEmpty()) {
                                int totalItems = appointment.size();
                                int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
                                int startIndex = (currentPage - 1) * itemsPerPage;
                                int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
                                List<Appointment> pageAppointments = appointment.subList(startIndex, endIndex);
                        %>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Bác sĩ</th>
                                            <th>Ngày khám</th>
                                            <th>Thời gian</th>
                                            <th>Trạng thái</th>
                                            <th>Lý do</th>
                                            <th class="text-end">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Appointment ap : pageAppointments) {
                                            String reason = ap.getReason();
                                            String reasonDisplay = (reason != null && reason.contains("|")) ? reason.substring(0, reason.indexOf("|")).trim() : (reason != null ? reason : "");
                                            if (reasonDisplay.isEmpty() && reason != null) reasonDisplay = reason;
                                            String status = ap.getStatus() != null ? ap.getStatus().toUpperCase() : "";
                                            String statusBadgeClass = "bg-secondary";
                                            String statusLabel = ap.getStatus() != null ? ap.getStatus() : "Không xác định";
                                            
                                            if (status.contains("BOOKED") || status.contains("PENDING")) { 
                                                statusBadgeClass = "bg-primary-subtle text-primary border border-primary-subtle"; 
                                                statusLabel = "Đã đặt"; 
                                            } else if (status.contains("COMPLETED") || status.contains("DONE")) { 
                                                statusBadgeClass = "bg-success-subtle text-success border border-success-subtle"; 
                                                statusLabel = "Hoàn thành"; 
                                            } else if (status.contains("CANCEL")) { 
                                                statusBadgeClass = "bg-danger-subtle text-danger border border-danger-subtle"; 
                                                statusLabel = "Đã hủy"; 
                                            }
                                        %>
                                            <tr>
                                                <td class="fw-bold">
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-primary-subtle text-primary rounded-circle me-3 d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; flex-shrink: 0;">
                                                            <i class="fas fa-user-md"></i>
                                                        </div>
                                                        <%= ap.getDoctorName() != null ? ap.getDoctorName() : "Chưa có thông tin" %>
                                                    </div>
                                                </td>
                                                <td><i class="far fa-calendar-check me-2 text-muted"></i><%= ap.getFormattedWorkDate() %></td>
                                                <td><i class="far fa-clock me-2 text-muted"></i><%= ap.getFormattedTimeRange() %></td>
                                                <td><span class="badge rounded-pill status-badge <%= statusBadgeClass %>"><%= statusLabel %></span></td>
                                                <td class="reason-cell">
                                                    <span class="reason-text text-muted small" title="<%= reason != null ? reason.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;") : "" %>">
                                                        <%= reasonDisplay %>
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/MedicalReportDetailServlet?appointmentId=<%= ap.getAppointmentId() %>" class="btn btn-outline-primary btn-sm btn-action">
                                                        <i class="fas fa-file-medical-alt me-1"></i> Báo cáo
                                                    </a>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            
                            <% if (totalPages > 1) { %>
                                <div class="card-footer bg-white py-3">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination pagination-sm justify-content-center mb-0">
                                            <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                                                <a class="page-link" href="?page=<%= currentPage - 1 %>" tabindex="-1">Trước</a>
                                            </li>
                                            <% 
                                                int startPage = Math.max(1, currentPage - 2);
                                                int endPage = Math.min(totalPages, currentPage + 2);
                                                for (int i = startPage; i <= endPage; i++) {
                                            %>
                                                <li class="page-item <%= i == currentPage ? "active" : "" %>">
                                                    <a class="page-link" href="?page=<%= i %>"><%= i %></a>
                                                </li>
                                            <% } %>
                                            <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                                                <a class="page-link" href="?page=<%= currentPage + 1 %>">Sau</a>
                                            </li>
                                        </ul>
                                    </nav>
                                    <div class="text-center mt-2">
                                        <small class="text-muted">Trang <%= currentPage %> / <%= totalPages %> (Hiển thị <%= startIndex + 1 %>-<%= endIndex %> / <%= totalItems %>)</small>
                                    </div>
                                </div>
                            <% } %>

                        <% } else { %>
                            <div class="empty-state">
                                <i class="fas fa-calendar-times"></i>
                                <h4 class="h5 text-muted">Bạn chưa có lịch hẹn nào</h4>
                                <p class="text-muted small">Hãy bắt đầu bằng cách đặt một lịch khám mới.</p>
                                <a href="${pageContext.request.contextPath}/services" class="btn btn-primary btn-sm mt-2">
                                    <i class="fas fa-plus me-1"></i> Đặt lịch ngay
                                </a>
                            </div>
                        <% } %>
                        </div>
                    </div>

                    <%-- Relative Appointments --%>
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                            <h3 class="h5 fw-bold mb-0 text-dark"><i class="fas fa-users me-2 text-primary"></i>Lịch khám của người thân</h3>
                            <% if (relativeAppointments != null && !relativeAppointments.isEmpty()) { %>
                                <span class="badge bg-light text-dark border"><%= relativeAppointments.size() %> cuộc hẹn</span>
                            <% } %>
                        </div>
                        <div class="card-body p-0">
                        <% 
                            int relativePage = 1;
                            String relativePageParam = request.getParameter("relativePage");
                            if (relativePageParam != null && !relativePageParam.isEmpty()) {
                                try {
                                    relativePage = Integer.parseInt(relativePageParam);
                                } catch (NumberFormatException e) {
                                    relativePage = 1;
                                }
                            }

                            if (relativeAppointments != null && !relativeAppointments.isEmpty()) {
                                int relativeTotalItems = relativeAppointments.size();
                                int relativeTotalPages = (int) Math.ceil((double) relativeTotalItems / itemsPerPage);
                                int relativeStartIndex = (relativePage - 1) * itemsPerPage;
                                int relativeEndIndex = Math.min(relativeStartIndex + itemsPerPage, relativeTotalItems);
                                List<Appointment> pageRelativeAppointments = relativeAppointments.subList(relativeStartIndex, relativeEndIndex);
                        %>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Người khám</th>
                                            <th>Bác sĩ</th>
                                            <th>Ngày khám</th>
                                            <th>Thời gian</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Appointment ap : pageRelativeAppointments) {
                                            String status = ap.getStatus() != null ? ap.getStatus().toUpperCase() : "";
                                            String statusBadgeClass = "bg-secondary";
                                            String statusLabel = ap.getStatus() != null ? ap.getStatus() : "Không xác định";
                                            
                                            if (status.contains("BOOKED") || status.contains("PENDING")) { 
                                                statusBadgeClass = "bg-primary-subtle text-primary border border-primary-subtle"; 
                                                statusLabel = "Đã đặt"; 
                                            } else if (status.contains("COMPLETED") || status.contains("DONE")) { 
                                                statusBadgeClass = "bg-success-subtle text-success border border-success-subtle"; 
                                                statusLabel = "Hoàn thành"; 
                                            } else if (status.contains("CANCEL")) { 
                                                statusBadgeClass = "bg-danger-subtle text-danger border border-danger-subtle"; 
                                                statusLabel = "Đã hủy"; 
                                            }
                                        %>
                                            <tr>
                                                <td class="fw-bold text-primary"><%= ap.getPatientName() != null ? ap.getPatientName() : "Chưa có thông tin" %></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-xs bg-light rounded-circle me-2 d-flex align-items-center justify-content-center" style="width: 24px; height: 24px;">
                                                            <i class="fas fa-user-md text-muted small"></i>
                                                        </div>
                                                        <%= ap.getDoctorName() != null ? ap.getDoctorName() : "Chưa có thông tin" %>
                                                    </div>
                                                </td>
                                                <td><%= ap.getFormattedWorkDate() %></td>
                                                <td><%= ap.getFormattedTimeRange() %></td>
                                                <td><span class="badge rounded-pill status-badge <%= statusBadgeClass %>"><%= statusLabel %></span></td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/MedicalReportDetailServlet?appointmentId=<%= ap.getAppointmentId() %>" class="btn btn-outline-primary btn-sm btn-action">
                                                        <i class="fas fa-file-medical-alt"></i> Báo cáo
                                                    </a>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>

                            <% if (relativeTotalPages > 1) { %>
                                <div class="card-footer bg-white py-3">
                                    <nav aria-label="Relative Page navigation">
                                        <ul class="pagination pagination-sm justify-content-center mb-0">
                                            <li class="page-item <%= relativePage == 1 ? "disabled" : "" %>">
                                                <a class="page-link" href="?relativePage=<%= relativePage - 1 %>&page=<%= currentPage %>" tabindex="-1">Trước</a>
                                            </li>
                                            <% 
                                                int relativeStartPage = Math.max(1, relativePage - 2);
                                                int relativeEndPage = Math.min(relativeTotalPages, relativePage + 2);
                                                for (int i = relativeStartPage; i <= relativeEndPage; i++) {
                                            %>
                                                <li class="page-item <%= i == relativePage ? "active" : "" %>">
                                                    <a class="page-link" href="?relativePage=<%= i %>&page=<%= currentPage %>"><%= i %></a>
                                                </li>
                                            <% } %>
                                            <li class="page-item <%= relativePage == relativeTotalPages ? "disabled" : "" %>">
                                                <a class="page-link" href="?relativePage=<%= relativePage + 1 %>&page=<%= currentPage %>">Sau</a>
                                            </li>
                                        </ul>
                                    </nav>
                                    <div class="text-center mt-2">
                                        <small class="text-muted">Trang <%= relativePage %> / <%= relativeTotalPages %> (Hiển thị <%= relativeStartIndex + 1 %>-<%= relativeEndIndex %> / <%= relativeTotalItems %>)</small>
                                    </div>
                                </div>
                            <% } %>

                        <% } else { %>
                            <div class="empty-state">
                                <i class="fas fa-users-slash"></i>
                                <h4 class="h5 text-muted">Chưa có lịch khám cho người thân</h4>
                                <p class="text-muted small">Thông tin các lịch hẹn bạn đặt hộ người thân sẽ xuất hiện tại đây.</p>
                            </div>
                        <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
</body>
</html>
