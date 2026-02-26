<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.PatientDAO"%>
<%@page import="dao.AppointmentDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="model.Doctors"%>
<%@page import="model.Patients"%>
<%@page import="model.Appointment"%>

<%
            String appointmentIdParam = request.getParameter("appointmentId");
            int appointmentId = 0;
            
            if (appointmentIdParam != null && !appointmentIdParam.trim().isEmpty()) {
                try {
                    appointmentId = Integer.parseInt(appointmentIdParam.trim());
                } catch (NumberFormatException e) {
                    appointmentId = 0;
                }
            }
            
            Doctors doctor = (Doctors) session.getAttribute("doctor");
            Appointment appointment = null;
            Patients patient = null;
            
            try {
                if (appointmentId > 0) {
                    appointment = AppointmentDAO.getAppointmentWithPatientInfo(appointmentId);
                    if (appointment != null) {
                        patient = PatientDAO.getPatientById(appointment.getPatientId());
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm dd/MM/yyyy");
            Date currentTime = new Date();
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Phiếu khám bệnh - Doctor</title>
    <style>
        .patient-info-card {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px;
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            border-radius: 12px;
            margin-bottom: 24px;
        }
        .patient-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .medicine-item {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            align-items: center;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/doctor/doctor_header.jsp" %>
            
            <div class="dashboard-content">
                <% if (appointmentId == 0 || doctor == null || patient == null) { %>
                <!-- Error State -->
                <div class="dashboard-card text-center py-5">
                    <i class="fas fa-exclamation-triangle text-warning" style="font-size: 64px;"></i>
                    <h4 class="mt-4 text-danger">Thiếu thông tin cần thiết</h4>
                    <div class="p-3 bg-light rounded mx-auto mt-3" style="max-width: 400px;">
                        <p class="mb-1"><strong>appointmentId:</strong> <%= appointmentId %></p>
                        <p class="mb-1"><strong>doctor:</strong> <%= doctor != null ? "OK" : "NULL" %></p>
                        <p class="mb-0"><strong>patient:</strong> <%= patient != null ? "OK" : "NULL" %></p>
                    </div>
                    <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="btn-dashboard btn-dashboard-primary mt-4">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                    </a>
                </div>
                <% } else { %>
                
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-file-medical me-2"></i>Tạo phiếu khám</h4>
                        <p class="text-muted mb-0">Mã cuộc hẹn: #<%= appointmentId %></p>
                    </div>
                    <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại
                    </a>
                </div>
                
                <!-- Patient Info -->
                <div class="patient-info-card">
                    <img src="${pageContext.request.contextPath}/img/default-avatar.png" 
                         alt="Avatar" class="patient-avatar"
                         onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                    <div class="flex-grow-1">
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Họ và tên:</strong> <%= patient.getFullName() %></p>
                                <p class="mb-0"><strong>Ngày sinh:</strong> 
                                    <%= patient.getDateOfBirth() != null ? new SimpleDateFormat("dd/MM/yyyy").format(patient.getDateOfBirth()) : "--/--/----" %>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Giới tính:</strong> 
                                    <%= patient.getGender() != null ? ("male".equals(patient.getGender()) ? "Nam" : "Nữ") : "--" %>
                                </p>
                                <p class="mb-0"><strong>Số điện thoại:</strong> 
                                    <%= patient.getPhone() != null ? patient.getPhone() : "----------" %>
                                </p>
                            </div>
                    </div>
                    </div>
                </div>

                <!-- Medical Form -->
                <form method="post" action="${pageContext.request.contextPath}/MedicalReportServlet">
                <input type="hidden" name="appointment_id" value="<%= appointmentId %>">
                    <input type="hidden" name="patient_id" value="<%= patient.getPatientId() %>">
                <input type="hidden" name="doctor_id" value="<%= doctor.getDoctorId() %>">

                    <div class="dashboard-card mb-4">
                        <h6 class="mb-4"><i class="fas fa-stethoscope me-2 text-primary"></i>Thông tin khám bệnh</h6>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Mã phiếu khám:</strong> <%= appointmentId %></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Thời gian khám:</strong> <%= timeFormat.format(currentTime) %></p>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="reexam_lan_2" id="reexam_lan_2" value="1"
                                    <%= (appointment != null && appointment.getPreviousAppointmentId() > 0) ? "checked" : "" %>>
                                <label class="form-check-label" for="reexam_lan_2">
                                    <strong>Tái khám lần 2</strong> — Bệnh nhân đã khám lần đầu, đây là lần tái khám thứ 2
                                </label>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Chuẩn đoán <span class="text-danger">*</span></label>
                            <textarea name="diagnosis" class="form-control" rows="3" placeholder="Nhập chuẩn đoán bệnh..." required></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Kế hoạch điều trị</label>
                            <textarea name="treatment_plan" class="form-control" rows="3" placeholder="Nhập kế hoạch điều trị..."></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Ghi chú thêm</label>
                            <textarea name="note" class="form-control" rows="2" placeholder="Ghi chú thêm (nếu có)..."></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Chữ ký bác sĩ</label>
                            <input type="text" name="sign" class="form-control" placeholder="Nhập tên bác sĩ ký">
                        </div>
                </div>

                    <!-- Medicine Section -->
                    <div class="dashboard-card mb-4">
                        <h6 class="mb-4"><i class="fas fa-pills me-2 text-success"></i>Đơn thuốc</h6>
                        
                    <div id="medicine-list">
                        <div class="medicine-item">
                                <select name="medicine_id" class="form-select" style="flex: 2;">
                                <option value="">Chọn thuốc</option>
                                <option value="1">Paracetamol - Kho: 500 viên</option>
                                <option value="2">Amoxicillin - Kho: 300 viên</option>
                                <option value="3">Saline 0.9% - Kho: 200 chai</option>
                                <option value="4">Loperamide - Kho: 150 viên</option>
                                <option value="5">Vitamin C - Kho: 400 viên</option>
                            </select>
                                <input type="number" name="quantity" class="form-control" placeholder="SL" min="1" style="flex: 1;">
                                <input type="text" name="usage" class="form-control" placeholder="Cách dùng" style="flex: 2;">
                                <button type="button" class="btn btn-danger btn-sm" onclick="removeMedicine(this)">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </div>
                        
                        <button type="button" class="btn btn-success btn-sm mt-3" onclick="addMedicine()">
                            <i class="fas fa-plus me-1"></i>Thêm thuốc
                        </button>
                </div>

                    <!-- Action Buttons -->
                    <div class="d-flex gap-3">
                        <button type="submit" class="btn-dashboard btn-dashboard-success flex-fill">
                            <i class="fas fa-save me-1"></i>Lưu phiếu khám
                        </button>
                        <button type="reset" class="btn-dashboard btn-dashboard-secondary">
                            <i class="fas fa-redo me-1"></i>Làm mới
                        </button>
                </div>

                    <p class="text-muted mt-3 small">
                        <i class="fas fa-info-circle me-1"></i>Vui lòng kiểm tra kỹ thông tin trước khi lưu phiếu khám.
                    </p>
                </form>
                <% } %>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>

        <script>
            function addMedicine() {
                const medicineList = document.getElementById('medicine-list');
            const newItem = document.createElement('div');
            newItem.className = 'medicine-item';
            newItem.innerHTML = `
                <select name="medicine_id" class="form-select" style="flex: 2;">
                    <option value="">Chọn thuốc</option>
                    <option value="1">Paracetamol - Kho: 500 viên</option>
                    <option value="2">Amoxicillin - Kho: 300 viên</option>
                    <option value="3">Saline 0.9% - Kho: 200 chai</option>
                    <option value="4">Loperamide - Kho: 150 viên</option>
                    <option value="5">Vitamin C - Kho: 400 viên</option>
                </select>
                <input type="number" name="quantity" class="form-control" placeholder="SL" min="1" style="flex: 1;">
                <input type="text" name="usage" class="form-control" placeholder="Cách dùng" style="flex: 2;">
                <button type="button" class="btn btn-danger btn-sm" onclick="removeMedicine(this)">
                    <i class="fas fa-times"></i>
                </button>
            `;
            medicineList.appendChild(newItem);
            }

            function removeMedicine(button) {
                const medicineList = document.getElementById('medicine-list');
                if (medicineList.children.length > 1) {
                    button.parentElement.remove();
                } else {
                    alert('Phải có ít nhất một dòng thuốc!');
                }
            }

            document.querySelector('form').addEventListener('submit', function(e) {
                const diagnosis = document.querySelector('textarea[name="diagnosis"]').value;
                if (!diagnosis.trim()) {
                    alert('Vui lòng nhập chuẩn đoán!');
                    e.preventDefault();
                    return false;
                }
            });
        </script>
    </body>
</html>
