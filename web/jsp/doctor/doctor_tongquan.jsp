<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page import="model.Doctors" %>
<%@ page import="model.User" %>
<%@ page import="model.Appointment" %>
<%@ page import="controller.profile.DoctorHomePageServlet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>

<%
    // Lấy dữ liệu từ servlet thông qua request attributes
    String doctorName = (String) request.getAttribute("doctorName");
    String doctorGender = (String) request.getAttribute("doctorGender");
    String doctorSpecialty = (String) request.getAttribute("doctorSpecialty");
    String doctorPhone = (String) request.getAttribute("doctorPhone");
    String avatarPath = (String) request.getAttribute("avatarPath");
    Boolean isActiveObj = (Boolean) request.getAttribute("isActive");
    boolean isActive = isActiveObj != null ? isActiveObj : false;

    // Kiểm tra xem có dữ liệu từ servlet không
    if (doctorName == null) {
        response.sendRedirect("DoctorTongQuanServlet");
        return;
    }

    // Lấy dữ liệu thống kê
    List<Appointment> waitingAppointments = (List<Appointment>) request.getAttribute("waitingAppointments");
    Integer waitingCountObj = (Integer) request.getAttribute("waitingCount");
    int waitingCount = waitingCountObj != null ? waitingCountObj : 0;

    List<Appointment> cancelledAppointments = (List<Appointment>) request.getAttribute("cancelledAppointments");
    Integer cancelledCountObj = (Integer) request.getAttribute("cancelledCount");
    int cancelledCount = cancelledCountObj != null ? cancelledCountObj : 0;

    // Khởi tạo list rỗng nếu null
    if (waitingAppointments == null) waitingAppointments = new ArrayList<>();
    if (cancelledAppointments == null) cancelledAppointments = new ArrayList<>();
%>

<%!
    public String getTimeSlot(int slotId) {
        return DoctorHomePageServlet.getTimeSlot(slotId);
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Tổng quan - Doctor Dashboard</title>
    </head>
    <body>
    <div class="dashboard-wrapper">
        <!-- Sidebar Menu -->
        <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
        
        <!-- Main Content -->
        <main class="dashboard-main">
            <!-- Header -->
            <%@ include file="/jsp/doctor/doctor_header.jsp" %>
            
            <!-- Page Content -->
            <div class="dashboard-content">
                <!-- Page Title -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1">Tổng quan</h4>
                        <p class="text-muted mb-0">Chào mừng trở lại, <%= doctorName %>!</p>
                    </div>
                    <div>
                        <span class="badge bg-light text-dark">
                            <i class="fas fa-calendar me-1"></i>
                            <%= new SimpleDateFormat("dd/MM/yyyy").format(new Date()) %>
                        </span>
                    </div>
                </div>
                
                <!-- Stats Cards Row -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-clock"></i>
                            </div>
                            <div class="stat-card-value"><%= waitingCount %></div>
                            <div class="stat-card-label">Đang chờ khám</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-card-value">0</div>
                            <div class="stat-card-label">Đã khám hôm nay</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card danger">
                            <div class="stat-card-icon">
                                <i class="fas fa-calendar-times"></i>
                            </div>
                            <div class="stat-card-value"><%= cancelledCount %></div>
                            <div class="stat-card-label">Lịch bị huỷ</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-comments"></i>
                            </div>
                            <div class="stat-card-value">3</div>
                            <div class="stat-card-label">Yêu cầu tư vấn</div>
                        </div>
                    </div>
                </div>

                <!-- Main Content Row -->
                <div class="row g-4">
                    <!-- Doctor Info Card -->
                    <div class="col-12 col-lg-4">
                        <div class="dashboard-card">
                            <div class="text-center mb-4">
                                <img src="<%= avatarPath != null ? avatarPath : request.getContextPath() + "/img/default-avatar.png" %>" 
                                     alt="Avatar" 
                                     class="rounded-circle mb-3"
                                     style="width: 80px; height: 80px; object-fit: cover; border: 3px solid var(--primary-color);"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                                <h5 class="mb-1"><%= doctorName %></h5>
                                <span class="badge-dashboard badge-primary">Bác sĩ <%= doctorSpecialty %></span>
                            </div>
                            <div class="border-top pt-3">
                                <div class="d-flex align-items-center mb-3">
                                    <i class="fas fa-venus-mars text-primary me-3"></i>
                                    <div>
                                        <small class="text-muted d-block">Giới tính</small>
                                        <span><%= doctorGender %></span>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center mb-3">
                                    <i class="fas fa-phone text-primary me-3"></i>
                                    <div>
                                        <small class="text-muted d-block">Số điện thoại</small>
                                        <span><%= doctorPhone %></span>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center">
                                    <i class="fas fa-circle <%= isActive ? "text-success" : "text-danger" %> me-3"></i>
                                    <div>
                                        <small class="text-muted d-block">Trạng thái</small>
                                        <span id="statusLabel" class="<%= isActive ? "text-success" : "text-danger" %>">
                                            <%= isActive ? "Đang trực" : "Không trực" %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Status Toggle -->
                            <div class="mt-4 p-3 bg-light rounded">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="small">Cập nhật trạng thái trực</span>
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="statusToggle" 
                                               <%= isActive ? "checked" : "" %> style="cursor: pointer;">
                                    </div>
                                </div>
            </div>
                            
                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/EditDoctorServlet" class="btn-dashboard btn-dashboard-secondary w-100">
                                    <i class="fas fa-cog"></i> Cài đặt tài khoản
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Waiting Patients -->
                    <div class="col-12 col-lg-8">
                        <div class="dashboard-card">
                            <div class="dashboard-card-header">
                                <h5 class="dashboard-card-title">
                                    <i class="fas fa-user-clock text-primary me-2"></i>
                                    Đang chờ khám (<%= waitingCount %>)
                                </h5>
                                <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="btn-dashboard btn-dashboard-primary btn-sm">
                                    Xem tất cả
                                </a>
                            </div>

                <% if (waitingAppointments.size() > 0) {
                                int displayCount = Math.min(4, waitingAppointments.size());
                        for (int i = 0; i < displayCount; i++) {
                            Appointment appointment = waitingAppointments.get(i);
                            String timeSlot = getTimeSlot(appointment.getSlotId());
                            String patientName = appointment.getPatientName() != null ? appointment.getPatientName() : "Bệnh nhân #" + appointment.getPatientId();
                            String patientGender = "";
                            if ("male".equals(appointment.getPatientGender())) {
                                patientGender = "Nam";
                            } else if ("female".equals(appointment.getPatientGender())) {
                                patientGender = "Nữ";
                            }

                            String ageInfo = "";
                            if (appointment.getPatientDateOfBirth() != null) {
                                Calendar now = Calendar.getInstance();
                                Calendar birth = Calendar.getInstance();
                                birth.setTime(appointment.getPatientDateOfBirth());
                                int age = now.get(Calendar.YEAR) - birth.get(Calendar.YEAR);
                                if (now.get(Calendar.DAY_OF_YEAR) < birth.get(Calendar.DAY_OF_YEAR)) {
                                    age--;
                                }
                                        ageInfo = patientGender + " • " + age + " tuổi";
                            } else {
                                        ageInfo = patientGender.isEmpty() ? "Chưa cập nhật" : patientGender;
                                    }
                            %>
                            <div class="d-flex align-items-center p-3 border-bottom">
                                <img src="${pageContext.request.contextPath}/img/default-avatar.png" 
                                     class="rounded-circle me-3" 
                                     style="width: 48px; height: 48px; object-fit: cover;">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1"><%= patientName %></h6>
                                    <small class="text-muted"><%= ageInfo %></small>
                    </div>
                                <div class="text-end">
                                    <span class="badge bg-primary"><%= timeSlot %></span>
                                    <a href="${pageContext.request.contextPath}/jsp/doctor/doctor_phieukham.jsp?appointmentId=<%= appointment.getAppointmentId() %>" 
                                       class="btn btn-sm btn-outline-primary ms-2">
                                        <i class="fas fa-stethoscope"></i> Khám
                                    </a>
                    </div>
                </div>
                            <% } } else { %>
                            <div class="text-center py-5">
                                <i class="fas fa-calendar-check text-muted" style="font-size: 48px;"></i>
                                <p class="text-muted mt-3">Không có bệnh nhân đang chờ khám</p>
            </div>
                            <% } %>
                </div>

                        <!-- Cancelled Appointments -->
                        <div class="dashboard-card mt-4">
                            <div class="dashboard-card-header">
                                <h5 class="dashboard-card-title">
                                    <i class="fas fa-calendar-times text-danger me-2"></i>
                                    Lịch đã bị huỷ (<%= cancelledCount %>)
                                </h5>
                                <a href="${pageContext.request.contextPath}/cancelledAppointments" class="btn-dashboard btn-dashboard-secondary btn-sm">
                                    Xem tất cả
                                </a>
            </div>

                <% if (cancelledAppointments.size() > 0) {
                                int displayCancelledCount = Math.min(3, cancelledAppointments.size());
                        for (int i = 0; i < displayCancelledCount; i++) {
                            Appointment cancelledApp = cancelledAppointments.get(i);
                            String timeSlot = getTimeSlot(cancelledApp.getSlotId());
                            String patientName = cancelledApp.getPatientName() != null ? cancelledApp.getPatientName() : "Bệnh nhân #" + cancelledApp.getPatientId();
                            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                            String workDateString = (cancelledApp.getWorkDate() != null)
                                    ? cancelledApp.getWorkDate().format(dateFormatter) : "N/A";
                %>
                            <div class="d-flex align-items-center p-3 border-bottom">
                                <img src="${pageContext.request.contextPath}/img/default-avatar.png" 
                                     class="rounded-circle me-3" 
                                     style="width: 40px; height: 40px; object-fit: cover;">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1"><%= patientName %></h6>
                                    <small class="text-muted">
                                        Lý do: <%= cancelledApp.getReason() != null ? cancelledApp.getReason() : "Không rõ" %>
                                    </small>
                                </div>
                                <span class="badge bg-danger"><%= timeSlot %> | <%= workDateString %></span>
                    </div>
                            <% } } else { %>
                            <div class="text-center py-4">
                                <i class="fas fa-check-circle text-success" style="font-size: 32px;"></i>
                                <p class="text-muted mt-2 mb-0">Không có lịch hẹn bị huỷ</p>
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
    document.addEventListener('DOMContentLoaded', function() {
    const statusToggle = document.getElementById('statusToggle');
    const statusLabel = document.getElementById('statusLabel');

    if (statusToggle && statusLabel) {
            statusToggle.addEventListener('change', function() {
            const isChecked = this.checked;
            const newStatus = isChecked ? 'Active' : 'Inactive';

            statusLabel.textContent = 'Đang cập nhật...';
            statusToggle.disabled = true;

            fetch('<%= request.getContextPath() %>/updateDoctorStatus', { 
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'status=' + encodeURIComponent(newStatus)
            })
                .then(response => response.json())
            .then(data => {
                if (data.success) {
                        statusLabel.textContent = isChecked ? 'Đang trực' : 'Không trực';
                        statusLabel.className = isChecked ? 'text-success' : 'text-danger';
                        showToast('Cập nhật trạng thái thành công!', 'success');
                } else {
                    statusToggle.checked = !isChecked;
                        showToast(data.message || 'Cập nhật thất bại!', 'error');
                }
            })
            .catch(error => {
                statusToggle.checked = !isChecked;
                    showToast('Lỗi kết nối. Vui lòng thử lại!', 'error');
            })
            .finally(() => {
                statusToggle.disabled = false;
            });
        });
    }
});
</script>
</body>
</html>
