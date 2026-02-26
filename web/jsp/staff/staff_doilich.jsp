<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Appointment" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Đổi lịch hẹn - Staff</title>
    <style>
        .time-slot {
            display: inline-block;
            margin: 4px;
            padding: 10px 18px;
            border-radius: 8px;
            border: 2px solid #e5e7eb;
            background: white;
            cursor: pointer;
            transition: all 0.2s;
        }
        .time-slot:hover {
            border-color: #4361ee;
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
            color: #ffffff;
            border-color: #6b7280;
            cursor: not-allowed;
            opacity: 0.9;
        }
        .time-slot.past {
            background: #e5e7eb;
            color: #6b7280;
            cursor: not-allowed;
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
                        <h4 class="mb-1"><i class="fas fa-exchange-alt me-2"></i>Đổi lịch hẹn</h4>
                        <p class="text-muted mb-0">Đổi lịch hẹn cho bệnh nhân</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/StaffAppointmentServlet" class="btn btn-outline-primary">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại
                    </a>
                </div>
                
                <div class="row">
                    <div class="col-lg-8 mx-auto">
                        <div class="dashboard-card">
                            <h6 class="mb-4"><i class="fas fa-calendar-alt me-2"></i>Thông tin đổi lịch</h6>
                            
                            <form id="rescheduleForm" method="post" action="${pageContext.request.contextPath}/RescheduleAppointmentServlet">
                                <div class="mb-4">
                                    <label class="form-label">Chọn lịch hẹn cần đổi <span class="text-danger">*</span></label>
                                    <select id="appointmentId" name="appointmentId" class="form-select" required onchange="onAppointmentChange()">
                                        <option value="">-- Chọn lịch hẹn --</option>
                                        <% if (appointments != null) {
                                            for (Appointment ap : appointments) { %>
                                        <option value="<%= ap.getAppointmentId() %>" data-doctor-id="<%= ap.getDoctorId() %>">
                                            [#<%= ap.getAppointmentId() %>] <%= ap.getPatientName() %> - BS: <%= ap.getDoctorName() %> - Ngày: <%= ap.getFormattedDate() %> - Ca: <%= ap.getFormattedTime() %>
                                        </option>
                                        <% } } %>
                                    </select>
                                </div>
                                
                                <div class="mb-4">
                                    <label class="form-label">Chọn ngày mới <span class="text-danger">*</span></label>
                                    <input type="date" id="newDate" name="newDate" class="form-control" required onchange="loadStaffSlots()">
                                </div>
                                
                                <div class="mb-4">
                                    <label class="form-label">Chọn ca khám mới <span class="text-danger">*</span></label>
                                    <div id="slotGrid" class="p-3 bg-light rounded">
                                        <p class="text-muted mb-0">Vui lòng chọn lịch hẹn và ngày mới để xem các ca khám</p>
                                    </div>
                                    <input type="hidden" name="newSlotId" id="newSlotId">
                                </div>
                                
                                <div class="mb-4">
                                    <label class="form-label">Lý do đổi lịch</label>
                                    <textarea name="reason" class="form-control" rows="3" placeholder="Nhập lý do đổi lịch (tùy chọn)..."></textarea>
                                </div>
                                
                                <div class="text-end">
                                    <button type="submit" class="btn-dashboard btn-dashboard-primary">
                                        <i class="fas fa-check"></i> Xác nhận đổi lịch
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
    
    <%-- Build JS map: appointmentId -> doctorId --%>
    <% 
        StringBuilder mapBuilder = new StringBuilder("{");
        if (appointments != null) {
            for (int i = 0; i < appointments.size(); i++) {
                Appointment ap = appointments.get(i);
                mapBuilder.append("\"").append(ap.getAppointmentId()).append("\":").append(ap.getDoctorId());
                if (i < appointments.size() - 1) mapBuilder.append(",");
            }
        }
        mapBuilder.append("}");
    %>
    
    <script>
        let appointmentDoctorMap = <%= mapBuilder.toString() %>;

        // Set min date to tomorrow
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date();
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            document.getElementById('newDate').min = tomorrow.toISOString().split('T')[0];
        });

        function onAppointmentChange() {
            document.getElementById('slotGrid').innerHTML = '<p class="text-muted mb-0">Vui lòng chọn ngày mới để xem các ca khám</p>';
            document.getElementById('newSlotId').value = '';
        }

        function loadStaffSlots() {
            const appointmentId = document.getElementById('appointmentId').value;
            const doctorId = appointmentDoctorMap[appointmentId];
            const date = document.getElementById('newDate').value;
            
            if (!doctorId || !date || !appointmentId) return;
            
            document.getElementById('slotGrid').innerHTML = '<div class="text-center py-3"><i class="fas fa-spinner fa-spin"></i> Đang tải...</div>';
            
            fetch('${pageContext.request.contextPath}/GetAvailableSlotsServlet?doctorId=' + doctorId + '&date=' + date + '&appointmentId=' + appointmentId)
                .then(res => res.json())
                .then(data => renderSlotGrid(data))
                .catch(err => {
                    document.getElementById('slotGrid').innerHTML = '<span class="text-danger">Lỗi tải ca khám!</span>';
                });
        }

        function renderSlotGrid(slots) {
            const grid = document.getElementById('slotGrid');
            
            if (!slots || slots.length === 0) {
                grid.innerHTML = '<span class="text-danger">Không còn ca khám trống!</span>';
                return;
            }
            
            let html = '';
            slots.forEach(slot => {
                const isBooked = slot.isBooked || false;
                const isPast = slot.isPast || false;
                let slotClass = 'time-slot';
                let onclick = '';
                
                if (isBooked) {
                    slotClass += ' booked';
                } else if (isPast) {
                    slotClass += ' past';
                } else {
                    onclick = 'onclick="selectSlot(' + slot.slotId + ', this)"';
                }
                
                html += '<button type="button" class="' + slotClass + '" ' + onclick + '>' + slot.startTime + ' - ' + slot.endTime + '</button>';
            });
            
            grid.innerHTML = html;
        }

        function selectSlot(slotId, btn) {
            document.querySelectorAll('.time-slot').forEach(e => e.classList.remove('selected'));
            btn.classList.add('selected');
            document.getElementById('newSlotId').value = slotId;
        }

        document.getElementById('rescheduleForm').addEventListener('submit', function(e) {
            const slotId = document.getElementById('newSlotId').value;
            if (!slotId) {
                e.preventDefault();
                alert('Vui lòng chọn ca khám mới!');
                return false;
            }
        });
    </script>
</body>
</html>
