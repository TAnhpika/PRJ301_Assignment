<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Quản lý lịch trình - Manager</title>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/manager/manager_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/manager/manager_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-calendar-alt me-2"></i>Quản lý lịch trình hệ thống</h4>
                        <p class="text-muted mb-0">Xem toàn bộ lịch trình bao gồm lịch hẹn, lịch bác sĩ và lịch nhân viên</p>
                    </div>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-card-value">${totalAppointments != null ? totalAppointments : 0}</div>
                            <div class="stat-card-label">Tổng lịch hẹn</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-calendar-day"></i>
                            </div>
                            <div class="stat-card-value">${todayAppointments != null ? todayAppointments : 0}</div>
                            <div class="stat-card-label">Lịch hẹn hôm nay</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-card-value">${pendingSchedules != null ? pendingSchedules : 0}</div>
                            <div class="stat-card-label">Lịch chờ duyệt</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="stat-card-value">${activeDoctors != null ? activeDoctors : 0}</div>
                            <div class="stat-card-label">Bác sĩ hoạt động</div>
                        </div>
                    </div>
                </div>
                
                <!-- Filters -->
                <div class="dashboard-card mb-4">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label">Loại lịch trình</label>
                            <select class="form-select" id="scheduleType" onchange="filterSchedule()">
                                <option value="all">Tất cả</option>
                                <option value="appointments">Lịch hẹn</option>
                                <option value="doctor">Lịch bác sĩ</option>
                                <option value="staff">Lịch nhân viên</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Từ ngày</label>
                            <input type="date" class="form-control" id="startDate" onchange="filterSchedule()">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Đến ngày</label>
                            <input type="date" class="form-control" id="endDate" onchange="filterSchedule()">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-select" id="status" onchange="filterSchedule()">
                                <option value="all">Tất cả</option>
                                <option value="BOOKED">Đã đặt</option>
                                <option value="COMPLETED">Hoàn thành</option>
                                <option value="CANCELLED">Đã hủy</option>
                                <option value="pending">Chờ duyệt</option>
                                <option value="approved">Đã duyệt</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button class="btn-dashboard btn-dashboard-secondary w-100" onclick="resetFilters()">
                                <i class="fas fa-redo"></i> Làm mới
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Schedule Tabs -->
                <ul class="nav nav-tabs mb-4" id="scheduleTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="list-tab" data-bs-toggle="tab" data-bs-target="#list-content" type="button" role="tab">
                            <i class="fas fa-list me-2"></i>Danh sách
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="calendar-tab" data-bs-toggle="tab" data-bs-target="#calendar-content" type="button" role="tab">
                            <i class="fas fa-calendar me-2"></i>Lịch
                        </button>
                    </li>
                </ul>
                
                <div class="tab-content" id="scheduleTabsContent">
                    <!-- List View -->
                    <div class="tab-pane fade show active" id="list-content" role="tabpanel">
                        <div class="dashboard-card">
                            <div class="table-responsive">
                                <table class="dashboard-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Loại</th>
                                            <th>Người liên quan</th>
                                            <th>Ngày</th>
                                            <th>Giờ</th>
                                            <th>Trạng thái</th>
                                            <th>Ghi chú</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Appointments -->
                                        <c:forEach var="appointment" items="${appointmentList}">
                                            <tr>
                                                <td><span class="badge bg-primary">#${appointment.appointmentId}</span></td>
                                                <td><i class="fas fa-calendar-check text-primary me-1"></i> Lịch hẹn</td>
                                                <td>
                                                    <strong>BN:</strong> ${appointment.patientName}<br>
                                                    <small class="text-muted"><strong>BS:</strong> ${appointment.doctorName}</small>
                                                </td>
                                                <td>${appointment.workDate}</td>
                                                <td>${appointment.timeSlot}</td>
                                                <td>
                                                    <span class="badge bg-${appointment.status == 'BOOKED' ? 'warning' : appointment.status == 'COMPLETED' ? 'success' : 'danger'}">
                                                        ${appointment.status}
                                                    </span>
                                                </td>
                                                <td><small>${appointment.reason}</small></td>
                                            </tr>
                                        </c:forEach>
                                        
                                        <!-- Doctor Schedules -->
                                        <c:forEach var="doctorSchedule" items="${doctorScheduleList}">
                                            <tr>
                                                <td><span class="badge bg-info">#${doctorSchedule.scheduleId}</span></td>
                                                <td><i class="fas fa-user-md text-info me-1"></i> Lịch bác sĩ</td>
                                                <td><strong>BS:</strong> ${doctorSchedule.doctorName}</td>
                                                <td>${doctorSchedule.workDate}</td>
                                                <td>${doctorSchedule.timeSlot}</td>
                                                <td>
                                                    <span class="badge bg-${doctorSchedule.status == 'approved' ? 'success' : doctorSchedule.status == 'pending' ? 'warning' : 'danger'}">
                                                        ${doctorSchedule.status}
                                                    </span>
                                                </td>
                                                <td><small>Lịch làm việc bác sĩ</small></td>
                                            </tr>
                                        </c:forEach>
                                        
                                        <!-- Staff Schedules -->
                                        <c:forEach var="staffSchedule" items="${staffScheduleList}">
                                            <tr>
                                                <td><span class="badge bg-secondary">#${staffSchedule.scheduleId}</span></td>
                                                <td><i class="fas fa-user-tie text-secondary me-1"></i> Lịch nhân viên</td>
                                                <td><strong>NV:</strong> ${staffSchedule.staffName}</td>
                                                <td>${staffSchedule.workDate}</td>
                                                <td>${staffSchedule.timeSlot}</td>
                                                <td>
                                                    <span class="badge bg-${staffSchedule.status == 'approved' ? 'success' : staffSchedule.status == 'pending' ? 'warning' : 'danger'}">
                                                        ${staffSchedule.status}
                                                    </span>
                                                </td>
                                                <td><small>Lịch làm việc nhân viên</small></td>
                                            </tr>
                                        </c:forEach>
                                        
                                        <c:if test="${empty appointmentList && empty doctorScheduleList && empty staffScheduleList}">
                                            <tr>
                                                <td colspan="7" class="text-center py-5">
                                                    <i class="fas fa-calendar-times text-muted" style="font-size: 48px;"></i>
                                                    <p class="text-muted mt-3">Chưa có lịch trình nào</p>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Calendar View -->
                    <div class="tab-pane fade" id="calendar-content" role="tabpanel">
                        <div class="dashboard-card">
                            <div id="calendarView" class="p-3">
                                <!-- Calendar will be generated by JavaScript -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function filterSchedule() {
            var type = document.getElementById('scheduleType').value;
            var startDate = document.getElementById('startDate').value;
            var endDate = document.getElementById('endDate').value;
            var status = document.getElementById('status').value;
            
            // Reload page with filters
            var url = '${pageContext.request.contextPath}/ManagerScheduleServlet?type=' + type + '&startDate=' + startDate + '&endDate=' + endDate + '&status=' + status;
            window.location.href = url;
        }
        
        function resetFilters() {
            document.getElementById('scheduleType').value = 'all';
            document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.getElementById('status').value = 'all';
            window.location.href = '${pageContext.request.contextPath}/ManagerScheduleServlet';
        }
        
        // Initialize calendar when tab is shown
        document.getElementById('calendar-tab').addEventListener('shown.bs.tab', function() {
            generateCalendar();
        });
        
        function generateCalendar() {
            var calendarView = document.getElementById('calendarView');
            var currentDate = new Date();
            var year = currentDate.getFullYear();
            var month = currentDate.getMonth();
            
            var monthNames = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 
                              'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
            
            var html = '<h5 class="text-center mb-4">' + monthNames[month] + ' ' + year + '</h5>';
            html += '<div class="row text-center fw-bold mb-2">';
            var daysOfWeek = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
            for (var i = 0; i < 7; i++) {
                html += '<div class="col">' + daysOfWeek[i] + '</div>';
            }
            html += '</div>';
            
            var firstDay = new Date(year, month, 1);
            var lastDay = new Date(year, month + 1, 0);
            var startDate = new Date(firstDay);
            startDate.setDate(startDate.getDate() - firstDay.getDay());
            
            html += '<div class="row">';
            for (var i = 0; i < 42; i++) {
                var currentDay = new Date(startDate);
                currentDay.setDate(startDate.getDate() + i);
                
                var isToday = currentDay.toDateString() === new Date().toDateString();
                var isOtherMonth = currentDay.getMonth() !== month;
                
                var cellClass = 'col p-2 border text-center';
                if (isToday) cellClass += ' bg-primary text-white';
                else if (isOtherMonth) cellClass += ' text-muted bg-light';
                
                html += '<div class="' + cellClass + '">' + currentDay.getDate() + '</div>';
                
                if ((i + 1) % 7 === 0) {
                    html += '</div>';
                    if (i < 41) html += '<div class="row">';
                }
            }
            
            calendarView.innerHTML = html;
        }
        
        // Set today's date for filters
        document.addEventListener('DOMContentLoaded', function() {
            var today = new Date().toISOString().split('T')[0];
            if (!document.getElementById('startDate').value) {
                document.getElementById('startDate').value = today;
            }
            if (!document.getElementById('endDate').value) {
                document.getElementById('endDate').value = today;
            }
        });
    </script>
</body>
</html>
