<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.AppointmentDAO" %>
<%@page import="model.Appointment" %>
<%@page import="model.User" %>
<%@page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    if (appointments == null) appointments = new java.util.ArrayList<>();
    
    int confirmedCount = 0;
    int pendingCount = 0;
    int cancelledCount = 0;
    for (Appointment ap : appointments) {
        if ("BOOKED".equals(ap.getStatus())) confirmedCount++;
        else if ("WAITING".equals(ap.getStatus()) || "WAITING_PAYMENT".equals(ap.getStatus())) pendingCount++;
        else if ("CANCELLED".equals(ap.getStatus())) cancelledCount++;
    }
%>
<%! 
    public String escapeJsString(String s) { 
        if (s==null) return ""; 
        return s.replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"");
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Quản lý Lịch hẹn - Staff</title>
    <style>
        .time-slot {
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            background: white;
        }
        .time-slot:hover {
            border-color: #3b82f6;
            background: #f0f9ff;
        }
        .time-slot.selected {
            background: #4361ee;
            color: white;
            border-color: #4361ee;
        }
        /* Slot đã được đặt: màu xám */
        .time-slot.booked {
            background: #9ca3af;
            border-color: #6b7280;
            color: #ffffff;
            cursor: not-allowed;
            opacity: 0.9;
        }
        .time-slot.past {
            background: #e5e7eb;
            color: #6b7280;
            cursor: not-allowed;
            opacity: 0.7;
        }
        .time-slot-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }
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
                        <h4 class="mb-1"><i class="fas fa-calendar-alt me-2"></i>Quản lý Lịch hẹn</h4>
                        <p class="text-muted mb-0">Quản lý đổi lịch và hủy lịch hẹn khám</p>
                    </div>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-card-value"><%= appointments.size() %></div>
                            <div class="stat-card-label">Tổng lịch hẹn</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="stat-card-value"><%= confirmedCount %></div>
                            <div class="stat-card-label">Đã xác nhận</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-card-value"><%= pendingCount %></div>
                            <div class="stat-card-label">Chờ xác nhận</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card danger">
                            <div class="stat-card-icon">
                                <i class="fas fa-times-circle"></i>
                            </div>
                            <div class="stat-card-value"><%= cancelledCount %></div>
                            <div class="stat-card-label">Đã hủy</div>
                        </div>
                    </div>
                </div>
                
                <!-- Tabs -->
                <div class="dashboard-card">
                    <ul class="nav nav-tabs mb-4" id="manageTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="list-tab" data-bs-toggle="tab" data-bs-target="#listTabContent" type="button" role="tab">
                                <i class="fas fa-list me-2"></i>Danh sách lịch hẹn
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="reschedule-tab" data-bs-toggle="tab" data-bs-target="#rescheduleTabContent" type="button" role="tab">
                                <i class="fas fa-exchange-alt me-2"></i>Đổi lịch
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="cancel-tab" data-bs-toggle="tab" data-bs-target="#cancelTabContent" type="button" role="tab">
                                <i class="fas fa-ban me-2"></i>Hủy lịch
                            </button>
                        </li>
                    </ul>
                    
                    <div class="tab-content" id="manageTabsContent">
                        <!-- Tab 1: Danh sách lịch hẹn -->
                        <div class="tab-pane fade show active" id="listTabContent" role="tabpanel">
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                        <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm tên, SĐT..." onkeyup="filterTable()">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select" id="statusFilter" onchange="filterTable()">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="BOOKED">Đã xác nhận</option>
                                        <option value="WAITING">Chờ xác nhận</option>
                                        <option value="CANCELLED">Đã hủy</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="table-responsive">
                                <table class="dashboard-table" id="appointmentsTable">
                                    <thead>
                                        <tr>
                                            <th>Bệnh nhân</th>
                                            <th>Ngày</th>
                                            <th>Giờ</th>
                                            <th>Dịch vụ</th>
                                            <th>Bác sĩ</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (appointments.isEmpty()) { %>
                                        <tr>
                                            <td colspan="7" class="text-center py-5">
                                                <i class="fas fa-calendar-times text-muted" style="font-size: 48px;"></i>
                                                <p class="text-muted mt-3">Chưa có lịch hẹn nào</p>
                                            </td>
                                        </tr>
                                        <% } else { for (Appointment ap : appointments) { %>
                                        <tr data-status="<%= ap.getStatus() %>">
                                            <td><strong><%= ap.getPatientName() %></strong></td>
                                            <td><%= ap.getWorkDate() %></td>
                                            <td><%= ap.getStartTime() %></td>
                                            <td><%= ap.getServiceName() %></td>
                                            <td><%= ap.getDoctorName() %></td>
                                            <td>
                                                <% if ("BOOKED".equals(ap.getStatus())) { %>
                                                    <span class="badge bg-success">Đã xác nhận</span>
                                                <% } else if ("WAITING".equals(ap.getStatus()) || "WAITING_PAYMENT".equals(ap.getStatus())) { %>
                                                    <span class="badge bg-warning text-dark">Chờ xác nhận</span>
                                                <% } else if ("CANCELLED".equals(ap.getStatus())) { %>
                                                    <span class="badge bg-danger">Đã hủy</span>
                                                <% } else { %>
                                                    <span class="badge bg-secondary"><%= ap.getStatus() %></span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <% if (!"CANCELLED".equals(ap.getStatus())) { %>
                                                <button class="btn btn-sm btn-outline-primary me-1" onclick="switchToReschedule('<%= ap.getAppointmentId() %>')">
                                                    <i class="fas fa-exchange-alt"></i> Đổi
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger" onclick="switchToCancel('<%= ap.getAppointmentId() %>')">
                                                    <i class="fas fa-ban"></i> Hủy
                                                </button>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% } } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Tab 2: Đổi lịch -->
                        <div class="tab-pane fade" id="rescheduleTabContent" role="tabpanel">
                            <form id="rescheduleForm" method="post" action="<%=request.getContextPath()%>/CancelAppointmentServlet">
                                <input type="hidden" name="reschedule" value="1" />
                                <input type="hidden" name="doctorId" id="rescheduleDoctorId">
                                <input type="hidden" name="serviceId" id="rescheduleServiceId">
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Chọn lịch hẹn cần đổi <span class="text-danger">*</span></label>
                                        <select id="rescheduleAppointmentId" name="appointmentId" class="form-select" required onchange="onRescheduleAppointmentChange()">
                                            <option value="">-- Chọn lịch hẹn --</option>
                                            <% for (Appointment ap : appointments) { 
                                                if (!"CANCELLED".equals(ap.getStatus())) { %>
                                            <option value="<%= ap.getAppointmentId() %>" 
                                                    data-doctor-id="<%= ap.getDoctorId() %>" 
                                                    data-service-id="<%= ap.getServiceId() %>">
                                                <%= ap.getPatientName() %> - <%= ap.getWorkDate() %> <%= ap.getStartTime() %>
                                            </option>
                                            <% } } %>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Chọn ngày mới <span class="text-danger">*</span></label>
                                        <input type="date" id="rescheduleDatePicker" name="workDate" class="form-control" required 
                                               onchange="if(this.value) updateStaffSlots(getSelectedDoctorId(), this.value, 'rescheduleSlotGrid')">
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Chọn ca khám mới <span class="text-danger">*</span></label>
                                    <div class="time-slot-grid" id="rescheduleSlotGrid">
                                        <div class="text-muted">Vui lòng chọn ngày để xem các ca khám</div>
                                    </div>
                                    <input type="hidden" name="slotId" id="rescheduleSlotId">
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Lý do đổi lịch <span class="text-danger">*</span></label>
                                    <textarea name="reason" class="form-control" rows="3" required placeholder="Nhập lý do đổi lịch..."></textarea>
                                </div>
                                
                                <div class="text-end">
                                    <button type="submit" class="btn-dashboard btn-dashboard-primary">
                                        <i class="fas fa-check"></i> Xác nhận đổi lịch
                                    </button>
                                </div>
                            </form>
                        </div>
                        
                        <!-- Tab 3: Hủy lịch -->
                        <div class="tab-pane fade" id="cancelTabContent" role="tabpanel">
                            <form id="cancelForm" method="post" action="<%=request.getContextPath()%>/CancelAppointmentServlet">
                                <div class="mb-3">
                                    <label class="form-label">Chọn lịch hẹn cần hủy <span class="text-danger">*</span></label>
                                    <select id="cancelAppointmentId" name="appointmentId" class="form-select" required>
                                        <option value="">-- Chọn lịch hẹn --</option>
                                        <% for (Appointment ap : appointments) { 
                                            if (!"CANCELLED".equals(ap.getStatus())) { %>
                                        <option value="<%= ap.getAppointmentId() %>">
                                            <%= ap.getPatientName() %> - <%= ap.getWorkDate() %> <%= ap.getStartTime() %>
                                        </option>
                                        <% } } %>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Lý do hủy lịch <span class="text-danger">*</span></label>
                                    <select name="cancelReason" class="form-select" required>
                                        <option value="">Chọn lý do hủy</option>
                                        <option value="Bận việc">Bận việc</option>
                                        <option value="Không còn nhu cầu">Không còn nhu cầu</option>
                                        <option value="Bệnh nhân yêu cầu">Bệnh nhân yêu cầu</option>
                                        <option value="Khác">Khác</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Ghi chú thêm</label>
                                    <textarea name="cancelNote" class="form-control" rows="2" placeholder="Ghi chú thêm (nếu có)..."></textarea>
                                </div>
                                
                                <div class="text-end">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="fas fa-ban"></i> Xác nhận hủy lịch
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function filterTable() {
            var searchInput = document.getElementById("searchInput").value.toLowerCase();
            var statusFilter = document.getElementById("statusFilter").value;
            var table = document.getElementById("appointmentsTable");
            var tr = table.getElementsByTagName("tr");

            for (var i = 1; i < tr.length; i++) {
                var status = tr[i].getAttribute("data-status");
                var show = true;
                
                if (statusFilter && status !== statusFilter && 
                    !(statusFilter === "WAITING" && status === "WAITING_PAYMENT")) {
                    show = false;
                }
                
                if (searchInput) {
                    var textContent = tr[i].textContent || tr[i].innerText;
                    if (textContent.toLowerCase().indexOf(searchInput) === -1) {
                        show = false;
                    }
                }
                
                tr[i].style.display = show ? "" : "none";
            }
        }
        
        function updateStaffSlots(doctorId, workDate, containerId) {
            if (!doctorId || !workDate) return;
            var url = '${pageContext.request.contextPath}/CancelAppointmentServlet?action=getSlots&doctorId=' + doctorId + '&workDate=' + workDate;
            fetch(url)
                .then(res => res.json())
                .then(slots => {
                    var html = '';
                    slots.forEach(slot => {
                        var slotClass = 'time-slot';
                        var statusText = '';
                        var clickHandler = '';
                        if (slot.isBooked) {
                            slotClass += ' booked';
                            statusText = '<small class="text-danger">Đã đặt</small>';
                        } else if (slot.isPast) {
                            slotClass += ' past';
                            statusText = '<small class="text-secondary">Đã qua</small>';
                        } else {
                            clickHandler = 'onclick="selectStaffSlot(' + slot.slotId + ', \'' + slot.startTime + '\', \'' + slot.endTime + '\')"';
                            statusText = '<small class="text-success">Trống</small>';
                        }
                        html += '<div class="' + slotClass + '" ' + clickHandler + '>' +
                            '<strong>' + slot.startTime + ' - ' + slot.endTime + '</strong><br>' +
                            statusText +
                            '</div>';
                    });
                    document.getElementById(containerId).innerHTML = html;
                });
        }
        
        function selectStaffSlot(slotId, startTime, endTime) {
            if (event.currentTarget.classList.contains('booked') || 
                event.currentTarget.classList.contains('past')) {
                return;
            }
            document.getElementById('rescheduleSlotId').value = slotId;
            document.querySelectorAll('.time-slot:not(.booked):not(.past)').forEach(slot => slot.classList.remove('selected'));
            event.currentTarget.classList.add('selected');
        }
        
        function getSelectedDoctorId() {
            var select = document.getElementById('rescheduleAppointmentId');
            if (!select) return '';
            var selectedOption = select.options[select.selectedIndex];
            return selectedOption ? selectedOption.getAttribute('data-doctor-id') : '';
        }
        
        function switchToReschedule(appointmentId) {
            var tab = new bootstrap.Tab(document.getElementById('reschedule-tab'));
            tab.show();
            var select = document.getElementById('rescheduleAppointmentId');
            if (select) {
                select.value = appointmentId;
                onRescheduleAppointmentChange();
            }
        }
        
        function switchToCancel(appointmentId) {
            var tab = new bootstrap.Tab(document.getElementById('cancel-tab'));
            tab.show();
            document.getElementById('cancelAppointmentId').value = appointmentId;
        }
        
        function onRescheduleAppointmentChange() {
            var select = document.getElementById('rescheduleAppointmentId');
            if (!select) return;
            var selectedOption = select.options[select.selectedIndex];
            var doctorId = selectedOption.getAttribute('data-doctor-id') || '';
            var serviceId = selectedOption.getAttribute('data-service-id') || '';
            document.getElementById('rescheduleDoctorId').value = doctorId;
            document.getElementById('rescheduleServiceId').value = serviceId;
            document.getElementById('rescheduleDatePicker').value = '';
            document.getElementById('rescheduleSlotGrid').innerHTML = '<div class="text-muted">Vui lòng chọn ngày để xem các ca khám</div>';
        }
        
        window.addEventListener('DOMContentLoaded', function() {
            onRescheduleAppointmentChange();
        });
    </script>
</body>
</html>
