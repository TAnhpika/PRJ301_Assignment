<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page import="model.User"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    
    List<Appointment> cancelledAppointments = (List<Appointment>) request.getAttribute("cancelledAppointments");
    String error = (String) request.getAttribute("error");
    int totalCancelled = (cancelledAppointments != null) ? cancelledAppointments.size() : 0;
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Các lượt khám bị hủy - Doctor</title>
    <style>
        .cancelled-card {
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s;
            border-left: 4px solid #ef4444;
        }
        .cancelled-card:hover {
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.15);
            transform: translateY(-2px);
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
                        <h4 class="mb-1"><i class="fas fa-calendar-times me-2"></i>Các lượt khám bị hủy</h4>
                        <p class="text-muted mb-0">Tổng số: <%= totalCancelled %> lượt hủy</p>
                    </div>
                    <div class="input-group" style="max-width: 300px;">
                        <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                        <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm..." onkeyup="searchCancelledAppointments()">
                    </div>
                </div>
                
                <% if (error != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i><%= error %>
                </div>
                <% } %>
                
                <!-- Cancelled Grid -->
                <div class="row g-4" id="appointmentCards">
                    <% if (cancelledAppointments != null && !cancelledAppointments.isEmpty()) {
                        for (Appointment appointment : cancelledAppointments) {
                            String timeSlot = "N/A";
                            String workDateString = "N/A";
                            
                            try {
                                if (appointment.getStartTime() != null && appointment.getEndTime() != null) {
                                    timeSlot = appointment.getStartTime().toString() + " - " + appointment.getEndTime().toString();
                                }
                            } catch (Exception e) { }
                            
                            try {
                                if (appointment.getWorkDate() != null) {
                                    workDateString = appointment.getFormattedDate();
                                }
                            } catch (Exception e) { }
                    %>
                    <div class="col-lg-6">
                        <div class="cancelled-card">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <span class="badge bg-secondary"><%= timeSlot %> | <%= workDateString %></span>
                                <span class="badge bg-danger"><i class="fas fa-times-circle me-1"></i>Đã hủy</span>
                            </div>
                            <div class="d-flex align-items-center">
                                <img src="${pageContext.request.contextPath}/img/default-avatar.png" 
                                     class="rounded-circle me-3" style="width: 56px; height: 56px; object-fit: cover;"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1"><%= appointment.getPatientName() != null ? appointment.getPatientName() : "Không có tên" %></h6>
                                    <small class="text-muted">Mã cuộc hẹn: #<%= appointment.getAppointmentId() %></small>
                                    <p class="mb-0 mt-1 small text-danger">
                                        <i class="fas fa-info-circle me-1"></i>Lý do: <%= appointment.getReason() != null ? appointment.getReason() : "Không có ghi chú" %>
                                    </p>
                                </div>
                                <form action="${pageContext.request.contextPath}/doctor/sendNotification" method="post">
                                    <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>" />
                                    <button type="submit" class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-bell me-1"></i>Gửi thông báo
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <% } } else { %>
                    <div class="col-12">
                        <div class="dashboard-card text-center py-5">
                            <i class="fas fa-check-circle text-success" style="font-size: 64px;"></i>
                            <h5 class="mt-4 text-muted">Không có lượt khám nào bị hủy</h5>
                            <p class="text-muted">Tất cả các cuộc hẹn đều được thực hiện theo kế hoạch.</p>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function searchCancelledAppointments() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const cards = document.querySelectorAll('.cancelled-card');
            
            cards.forEach(card => {
                const text = card.textContent.toLowerCase();
                card.parentElement.style.display = text.includes(filter) ? '' : 'none';
            });
        }
    </script>
</body>
</html>
