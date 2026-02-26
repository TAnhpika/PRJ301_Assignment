<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
                <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                            <%@ page import="dao.ServiceDAO" %>
                                <%@ page import="model.Service" %>
<%@ page import="model.User" %>
                                    <%@ page import="java.util.List" %>

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
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Đặt lịch hẹn - Staff</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
                                            <style>
                                                .step-indicator {
                                                    display: flex;
                                                    justify-content: space-between;
                                                    margin-bottom: 30px;
                                                }
                                                .step {
                                                    flex: 1;
                                                    text-align: center;
            padding: 12px;
                                                    background: #e9ecef;
            border-radius: 8px;
                                                    margin: 0 5px;
            transition: all 0.3s;
                                                }
                                                .step.active {
            background: #4361ee;
                                                    color: white;
                                                }
                                                .step.completed {
            background: #10b981;
                                                    color: white;
                                                }
        .form-step {
            display: none;
        }
        .form-step.active {
            display: block;
        }
        .patient-item, .service-item {
            border: 2px solid #e5e7eb;
                                                    border-radius: 8px;
                                                    padding: 15px;
                                                    margin: 10px 0;
                                                    cursor: pointer;
                                                    transition: all 0.3s;
                                                }
        .patient-item:hover, .service-item:hover {
            border-color: #4361ee;
            background: #f0f9ff;
        }
        .patient-item.selected, .service-item.selected {
            border-color: #4361ee;
            background: #4361ee;
            color: white;
        }
                                                .time-slots {
                                                    display: grid;
                                                    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
                                                    gap: 10px;
                                                }
                                                .time-slot {
            padding: 12px;
                                                    text-align: center;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
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
        /* Slot đã được đặt: màu xám, không chọn được */
        .time-slot.booked {
            background: #9ca3af;
            border-color: #6b7280;
            color: #ffffff;
            cursor: not-allowed;
            opacity: 0.9;
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
                        <h4 class="mb-1"><i class="fas fa-calendar-plus me-2"></i>Quản lý Đặt lịch</h4>
                        <p class="text-muted mb-0">Đặt lịch hẹn cho bệnh nhân</p>
                    </div>
                    <button class="btn-dashboard btn-dashboard-primary" data-bs-toggle="modal" data-bs-target="#newAppointmentModal">
                        <i class="fas fa-plus"></i> Đặt lịch mới
                                                    </button>
                                                </div>

                <!-- Alerts -->
                                                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                                        <i class="fas fa-check-circle me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                                    </div>
                                                </c:if>

                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-card-value">${fn:length(todayAppointments) != null ? fn:length(todayAppointments) : '0'}</div>
                            <div class="stat-card-label">Hôm nay</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="stat-card-value">${confirmedCount != null ? confirmedCount : '0'}</div>
                            <div class="stat-card-label">Đã xác nhận</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-card-value">${pendingCount != null ? pendingCount : '0'}</div>
                            <div class="stat-card-label">Chờ xác nhận</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-tasks"></i>
                            </div>
                            <div class="stat-card-value">${completedCount != null ? completedCount : '0'}</div>
                            <div class="stat-card-label">Hoàn thành</div>
                        </div>
                    </div>
                </div>
                
                <!-- Search Section -->
                <div class="dashboard-card mb-4">
                    <h6 class="mb-3"><i class="fas fa-search me-2"></i>Tìm kiếm lịch hẹn</h6>
                    <form method="GET" action="${pageContext.request.contextPath}/StaffBookingServlet">
                                                        <div class="row g-3">
                                                            <div class="col-md-3">
                                <input type="text" name="patientName" class="form-control" placeholder="Tên bệnh nhân">
                                                            </div>
                                                            <div class="col-md-3">
                                <input type="date" name="appointmentDate" class="form-control">
                                                            </div>
                                                            <div class="col-md-3">
                                                                <select name="status" class="form-select">
                                                                    <option value="">Tất cả trạng thái</option>
                                                                    <option value="BOOKED">Đã đặt lịch</option>
                                                                    <option value="COMPLETED">Hoàn thành</option>
                                                                    <option value="CANCELLED">Đã hủy</option>
                                    <option value="WAITING_PAYMENT">Chờ thanh toán</option>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-3">
                                <button type="submit" class="btn-dashboard btn-dashboard-primary w-100">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>

                <!-- Appointments Table -->
                <div class="dashboard-card">
                    <h6 class="mb-3"><i class="fas fa-list me-2"></i>Danh sách lịch hẹn hôm nay</h6>
                                                    <div class="table-responsive">
                        <table class="dashboard-table">
                            <thead>
                                                                <tr>
                                                                    <th>STT</th>
                                                                    <th>Thời gian</th>
                                                                    <th>Bệnh nhân</th>
                                                                    <th>Bác sĩ</th>
                                                                    <th>Dịch vụ</th>
                                                                    <th>Trạng thái</th>
                                                                    <th>Thao tác</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:choose>
                                                                    <c:when test="${empty todayAppointments}">
                                                                        <tr>
                                            <td colspan="7" class="text-center py-5">
                                                <i class="fas fa-calendar-times text-muted" style="font-size: 48px;"></i>
                                                <p class="text-muted mt-3">Chưa có lịch hẹn nào hôm nay</p>
                                                                            </td>
                                                                        </tr>
                                                                    </c:when>
                                                                    <c:otherwise>
                                        <c:forEach items="${todayAppointments}" var="apt" varStatus="status">
                                                                            <tr>
                                                                                <td>${status.index + 1}</td>
                                                                                <td>
                                                    <strong>${apt.workDate}</strong><br>
                                                    <small class="text-muted">${apt.startTime} - ${apt.endTime}</small>
                                                                                </td>
                                                                                <td>
                                                                                    <strong>${apt.patientName}</strong><br>
                                                    <small class="text-muted">${apt.patientPhone}</small>
                                                                                </td>
                                                                                <td>${apt.doctorName}</td>
                                                                                <td>${apt.serviceName}</td>
                                                                                <td>
                                                    <span class="badge bg-${apt.status == 'BOOKED' ? 'success' : apt.status == 'WAITING_PAYMENT' ? 'warning' : apt.status == 'COMPLETED' ? 'primary' : 'danger'}">
                                                        ${apt.status == 'BOOKED' ? 'Đã đặt' : apt.status == 'WAITING_PAYMENT' ? 'Chờ TT' : apt.status == 'COMPLETED' ? 'Hoàn thành' : 'Đã hủy'}
                                                                                    </span>
                                                                                </td>
                                                                                <td>
                                                    <button class="btn btn-sm btn-outline-info me-1" title="Xem" onclick="viewAppointmentDetail('${apt.appointmentId}')">
                                                                                        <i class="fas fa-eye"></i>
                                                                                    </button>
                                                    <c:if test="${apt.status != 'COMPLETED' && apt.status != 'CANCELLED'}">
                                                        <button class="btn btn-sm btn-outline-success me-1" title="Xác nhận" onclick="confirmAppointment('${apt.appointmentId}')">
                                                                                            <i class="fas fa-check"></i>
                                                                                        </button>
                                                        <button class="btn btn-sm btn-outline-danger" title="Hủy" onclick="cancelAppointment('${apt.appointmentId}')">
                                                                                            <i class="fas fa-times"></i>
                                                                                        </button>
                                                                                    </c:if>
                                                                                </td>
                                                                            </tr>
                                                                        </c:forEach>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
            </div>
        </main>
                                            </div>

                                            <!-- Modal đặt lịch mới -->
    <div class="modal fade" id="newAppointmentModal" tabindex="-1">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-calendar-plus me-2"></i>Đặt lịch hẹn mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                    <!-- Step Indicator -->
                                                            <div class="step-indicator">
                        <div class="step active" id="step1">1. Chọn bệnh nhân</div>
                                                                <div class="step" id="step2">2. Chọn dịch vụ</div>
                        <div class="step" id="step3">3. Chọn bác sĩ & thời gian</div>
                                                                <div class="step" id="step4">4. Xác nhận</div>
                                                            </div>

                    <form id="appointmentForm" action="${pageContext.request.contextPath}/StaffBookingServlet" method="post">
                        <input type="hidden" name="action" value="book_appointment">

                                                                <!-- Bước 1: Chọn bệnh nhân -->
                                                                <div class="form-step active" id="step1Content">
                                                                    <h6>Tìm kiếm và chọn bệnh nhân</h6>
                                                                    <div class="row mb-3">
                                <div class="col-md-8">
                                    <input type="text" id="patientSearch" class="form-control" placeholder="Nhập tên hoặc số điện thoại">
                                                                        </div>
                                <div class="col-md-4">
                                    <button type="button" class="btn btn-outline-primary w-100" onclick="searchPatients()">
                                        <i class="fas fa-search me-1"></i>Tìm kiếm
                                                                            </button>
                                                                        </div>
                                                                    </div>
                            <div id="patientResults"></div>
                            <input type="hidden" name="patientId" id="selectedPatientId">
                                                                </div>

                                                                <!-- Bước 2: Chọn dịch vụ -->
                                                                <div class="form-step" id="step2Content">
                                                                    <h6>Chọn dịch vụ khám</h6>
                                                                    <div class="row">
                                <c:forEach items="${services}" var="service">
                                                                                    <div class="col-md-6 mb-2">
                                        <div class="service-item" data-service-id="${service.serviceId}" data-service-name="${service.serviceName}" data-service-price="${service.price}" onclick="selectService(this)">
                                            <h6 class="mb-1">${service.serviceName}</h6>
                                            <small class="text-muted">${service.description}</small>
                                            <div class="d-flex justify-content-between mt-2">
                                                <span class="badge bg-info">${service.category}</span>
                                                <strong class="text-success"><fmt:formatNumber value="${service.price}" pattern="#,##0"/> VNĐ</strong>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </c:forEach>
                                                                    </div>
                            <input type="hidden" name="serviceId" id="selectedServiceId">
                                                                </div>

                                                                <!-- Bước 3: Chọn bác sĩ và thời gian -->
                                                                <div class="form-step" id="step3Content">
                                                                    <h6>Chọn bác sĩ và thời gian</h6>
                                                                    <div class="row mb-3">
                                                                        <div class="col-md-6">
                                    <label class="form-label">Chọn bác sĩ:</label>
                                    <select name="doctorId" id="doctorSelect" class="form-select" onchange="loadTimeSlots()">
                                        <option value="">-- Chọn bác sĩ --</option>
                                        <c:forEach items="${doctors}" var="doctor">
                                            <option value="${doctor.doctorId}">${doctor.fullName} - ${doctor.specialty}</option>
                                                                                        </c:forEach>
                                                                            </select>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label class="form-label">Chọn ngày:</label>
                                    <input type="date" name="workDate" id="workDateInput" class="form-control" onchange="loadTimeSlots()">
                                                                        </div>
                                                                    </div>
                                                                    <div id="timeSlotsContainer" style="display: none;">
                                                                        <label class="form-label">Chọn giờ khám:</label>
                                <div class="time-slots" id="timeSlots"></div>
                                                                        </div>
                            <input type="hidden" name="slotId" id="selectedSlotId">
                                                                </div>

                        <!-- Bước 4: Xác nhận -->
                                                                <div class="form-step" id="step4Content">
                            <h6>Xác nhận thông tin</h6>
                            <div class="dashboard-card mb-3" id="appointmentSummary"></div>
                                                                    <div class="mb-3">
                                <label class="form-label">Lý do khám / Ghi chú:</label>
                                <textarea name="reason" class="form-control" rows="3" placeholder="Nhập lý do khám..."></textarea>
                                                                    </div>
                                                                </div>
                                                            </form>
                                                        </div>
                                                        <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="prevBtn" onclick="previousStep()" style="display: none;">
                                                                <i class="fas fa-arrow-left me-1"></i>Quay lại
                                                            </button>
                    <button type="button" class="btn btn-primary" id="nextBtn" onclick="nextStep()">
                                                                Tiếp theo<i class="fas fa-arrow-right ms-1"></i>
                                                            </button>
                    <button type="submit" class="btn btn-success" id="submitBtn" form="appointmentForm" style="display: none;">
                                                                <i class="fas fa-check me-1"></i>Đặt lịch
                                                            </button>
                                                    </div>
                                                </div>
                                            </div>
                                            </div>

    <%@ include file="/includes/dashboard_scripts.jsp" %>
                                            <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
                                            <script>
                                                let currentStep = 1;
                                                const totalSteps = 4;
                                                let selectedPatient = null;
                                                let selectedService = null;
                                                let selectedDoctor = null;
                                                let selectedSlot = null;

        document.addEventListener('DOMContentLoaded', function() {
                                                    flatpickr("#workDateInput", {
                                                        dateFormat: "Y-m-d",
                minDate: "today"
                                                    });
                                                });

                                                function nextStep() {
                                                    if (validateCurrentStep()) {
                                                        if (currentStep < totalSteps) {
                                                            document.getElementById('step' + currentStep + 'Content').classList.remove('active');
                                                            document.getElementById('step' + currentStep).classList.remove('active');
                                                            document.getElementById('step' + currentStep).classList.add('completed');
                                                            currentStep++;
                                                            document.getElementById('step' + currentStep + 'Content').classList.add('active');
                                                            document.getElementById('step' + currentStep).classList.add('active');
                                                            updateButtons();
                    if (currentStep === 4) updateAppointmentSummary();
                                                        }
                                                    }
                                                }

                                                function previousStep() {
                                                    if (currentStep > 1) {
                                                        document.getElementById('step' + currentStep + 'Content').classList.remove('active');
                                                        document.getElementById('step' + currentStep).classList.remove('active');
                                                        currentStep--;
                                                        document.getElementById('step' + currentStep + 'Content').classList.add('active');
                                                        document.getElementById('step' + currentStep).classList.remove('completed');
                                                        document.getElementById('step' + currentStep).classList.add('active');
                                                        updateButtons();
                                                    }
                                                }

                                                function updateButtons() {
            document.getElementById('prevBtn').style.display = currentStep > 1 ? 'inline-block' : 'none';
            document.getElementById('nextBtn').style.display = currentStep < totalSteps ? 'inline-block' : 'none';
            document.getElementById('submitBtn').style.display = currentStep === totalSteps ? 'inline-block' : 'none';
        }

                                                function validateCurrentStep() {
                                                    switch (currentStep) {
                case 1: if (!selectedPatient) { alert('Vui lòng chọn bệnh nhân'); return false; } break;
                case 2: if (!selectedService) { alert('Vui lòng chọn dịch vụ'); return false; } break;
                case 3: if (!selectedDoctor || !selectedSlot) { alert('Vui lòng chọn bác sĩ và thời gian'); return false; } break;
                                                    }
                                                    return true;
                                                }

                                                function searchPatients() {
                                                    const searchTerm = document.getElementById('patientSearch').value;
            if (!searchTerm.trim()) { alert('Vui lòng nhập thông tin tìm kiếm'); return; }
            document.getElementById('patientResults').innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tìm...</div>';
                                                    fetch('${pageContext.request.contextPath}/StaffBookingServlet?action=search_patient&format=json&phone=' + encodeURIComponent(searchTerm))
                .then(r => r.json())
                                                        .then(patients => {
                                                    let html = '';
                                                    if (patients && patients.length > 0) {
                        patients.forEach(p => {
                            html += '<div class="patient-item" data-patient-id="' + p.patientId + '" data-patient-name="' + p.fullName + '" data-patient-phone="' + p.phone + '" onclick="selectPatient(this)">' +
                                '<strong>' + p.fullName + '</strong><br><small class="text-muted">SĐT: ' + p.phone + '</small></div>';
                                                        });
                                                    } else {
                        html = '<div class="text-center text-muted">Không tìm thấy bệnh nhân</div>';
                                                    }
                                                    document.getElementById('patientResults').innerHTML = html;
                });
        }

        function selectPatient(el) {
            selectedPatient = { id: el.dataset.patientId, name: el.dataset.patientName, phone: el.dataset.patientPhone };
            document.getElementById('selectedPatientId').value = selectedPatient.id;
            document.querySelectorAll('.patient-item').forEach(i => i.classList.remove('selected'));
            el.classList.add('selected');
        }

        function selectService(el) {
            selectedService = { id: el.dataset.serviceId, name: el.dataset.serviceName, price: parseFloat(el.dataset.servicePrice) };
            document.getElementById('selectedServiceId').value = selectedService.id;
            document.querySelectorAll('.service-item').forEach(i => i.classList.remove('selected'));
            el.classList.add('selected');
                                                }

                                                function loadTimeSlots() {
                                                    const doctorId = document.getElementById('doctorSelect').value;
                                                    const workDate = document.getElementById('workDateInput').value;
                                                    if (doctorId && workDate) {
                                                        selectedDoctor = doctorId;
                document.getElementById('timeSlots').innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tải...</div>';
                                                        document.getElementById('timeSlotsContainer').style.display = 'block';
                fetch('${pageContext.request.contextPath}/StaffBookingServlet?action=get_timeslots&doctorId=' + doctorId + '&workDate=' + workDate)
                    .then(r => r.json())
                                                            .then(slots => {
                                                                let html = '';
                                                                if (slots.length === 0) {
                            html = '<div class="alert alert-warning">Không có khung giờ khả dụng</div>';
                                                                } else {
                            slots.forEach(s => {
                                html += '<div class="time-slot' + (s.isBooked ? ' booked' : '') + '" data-slot-id="' + s.slotId + '" data-start-time="' + s.startTime + '" data-end-time="' + s.endTime + '"' + (!s.isBooked ? ' onclick="selectTimeSlot(this)"' : '') + '>' +
                                    '<strong>' + s.startTime + ' - ' + s.endTime + '</strong></div>';
                            });
                        }
                                                                document.getElementById('timeSlots').innerHTML = html;
                    });
            }
        }

        function selectTimeSlot(el) {
            if (el.classList.contains('booked')) return;
            selectedSlot = { slotId: el.dataset.slotId, startTime: el.dataset.startTime, endTime: el.dataset.endTime };
            document.getElementById('selectedSlotId').value = selectedSlot.slotId;
            document.querySelectorAll('.time-slot').forEach(s => s.classList.remove('selected'));
            el.classList.add('selected');
                                                }

                                                function updateAppointmentSummary() {
                                                    const doctorSelect = document.getElementById('doctorSelect');
                                                    const workDate = document.getElementById('workDateInput').value;
            document.getElementById('appointmentSummary').innerHTML = 
                '<p><strong>Bệnh nhân:</strong> ' + (selectedPatient ? selectedPatient.name + ' - ' + selectedPatient.phone : 'Chưa chọn') + '</p>' +
                '<p><strong>Dịch vụ:</strong> ' + (selectedService ? selectedService.name + ' - ' + selectedService.price.toLocaleString() + ' VNĐ' : 'Chưa chọn') + '</p>' +
                                                        '<p><strong>Bác sĩ:</strong> ' + (selectedDoctor ? doctorSelect.options[doctorSelect.selectedIndex].text : 'Chưa chọn') + '</p>' +
                '<p><strong>Thời gian:</strong> ' + workDate + ' ' + (selectedSlot ? selectedSlot.startTime + ' - ' + selectedSlot.endTime : 'Chưa chọn') + '</p>';
        }

        function viewAppointmentDetail(id) { window.location.href = '${pageContext.request.contextPath}/StaffBookingServlet?action=get_detail&appointmentId=' + id; }
        function confirmAppointment(id) { if (confirm('Xác nhận lịch hẹn này?')) { window.location.href = '${pageContext.request.contextPath}/StaffBookingServlet?action=confirm&appointmentId=' + id; } }
        function cancelAppointment(id) { if (confirm('Hủy lịch hẹn này?')) { window.location.href = '${pageContext.request.contextPath}/StaffBookingServlet?action=cancel&appointmentId=' + id; } }
                                            </script>
                                        </body>
                                        </html>
