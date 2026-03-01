<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.*"%>
<%@page import="java.util.*"%>
<%@page import="model.User"%>
<%
    User authUser = (User) session.getAttribute("user");
    if (authUser == null || !"DOCTOR".equalsIgnoreCase(authUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
        return;
    }
    MedicalReport report          = (MedicalReport) request.getAttribute("report");
    Patients patient              = (Patients)      request.getAttribute("patient");
    Doctors  doctor               = (Doctors)       request.getAttribute("doctor");
    List<PrescriptionDetail> rxList = (List<PrescriptionDetail>) request.getAttribute("prescriptions");
    String   timeSlot             = (String)  request.getAttribute("timeSlot");
    Integer  appointmentId        = (Integer) request.getAttribute("appointmentId");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Báo Cáo Y Tế - Happy Smile</title>
    <style>
        /* ===== PAGE ===== */
        .page-title-section { margin-bottom: 24px; }
        .page-title-section h4 { font-size: 21px; font-weight: 700; color: #1e293b; margin-bottom: 3px; }
        .page-title-section p  { color: #64748b; font-size: 13.5px; margin: 0; }

        /* ===== REPORT CARD ===== */
        .report-card {
            background: white; border-radius: 16px; border: 1.5px solid #e8eef5;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05); overflow: hidden; margin-bottom: 20px;
        }
        .report-card-header {
            display: flex; align-items: center; justify-content: space-between;
            padding: 18px 24px; border-bottom: 1.5px solid #f1f5f9;
            gap: 12px; flex-wrap: wrap;
        }
        .report-card-header h5 {
            font-size: 15.5px; font-weight: 700; color: #1e293b; margin: 0;
            display: flex; align-items: center; gap: 8px;
        }
        .report-card-header h5 i { color: #0d9488; }
        .report-card-body { padding: 0; }

        /* ===== INFO GRID ===== */
        .info-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 0;
        }
        .info-item {
            display: flex; flex-direction: column; gap: 3px;
            padding: 14px 24px; border-bottom: 1px solid #f1f5f9;
        }
        .info-item:nth-child(odd)  { border-right: 1px solid #f1f5f9; }
        .info-item-label {
            font-size: 11.5px; font-weight: 600; color: #94a3b8;
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .info-item-value { font-size: 14px; color: #1e293b; font-weight: 500; }

        /* Full-width row */
        .info-item-full {
            grid-column: 1 / -1; border-right: none !important;
        }
        .info-item-full .info-item-value {
            white-space: pre-wrap; line-height: 1.6;
        }

        /* ===== PRESCRIPTION TABLE ===== */
        .rx-table { width: 100%; border-collapse: collapse; }
        .rx-table thead tr { background: #f8fafc; }
        .rx-table th {
            padding: 12px 20px; font-size: 12px; font-weight: 700;
            color: #64748b; text-transform: uppercase; letter-spacing: 0.5px;
            text-align: left; border-bottom: 1.5px solid #e8eef5;
        }
        .rx-table td {
            padding: 13px 20px; font-size: 13.5px; color: #334155;
            border-bottom: 1px solid #f1f5f9;
        }
        .rx-table tbody tr:last-child td { border-bottom: none; }
        .rx-table tbody tr:hover td { background: #f8fafc; }
        .rx-badge {
            display: inline-flex; align-items: center; justify-content: center;
            width: 24px; height: 24px; background: #e0f2fe; color: #0369a1;
            border-radius: 6px; font-size: 12px; font-weight: 700;
        }
        .rx-name-cell { font-weight: 600; color: #1e293b; }

        /* ===== EMPTY ===== */
        .empty-rx {
            padding: 40px 24px; text-align: center; color: #94a3b8;
        }
        .empty-rx i { font-size: 40px; color: #e2e8f0; display: block; margin-bottom: 12px; }

        /* ===== STATUS BADGE ===== */
        .status-badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;
        }
        .badge-teal  { background: #ccfbf1; color: #0f766e; }
        .badge-blue  { background: #dbeafe; color: #1d4ed8; }

        /* ===== ACTION BUTTONS ===== */
        .btn-edit {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600;
            cursor: pointer; border: none; transition: all 0.2s;
            background: linear-gradient(135deg, #0d9488, #0f766e);
            color: white; box-shadow: 0 2px 8px rgba(13,148,136,0.25);
        }
        .btn-edit:hover { box-shadow: 0 4px 14px rgba(13,148,136,0.35); transform: translateY(-1px); }
        .btn-delete {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600;
            cursor: pointer; border: 1.5px solid #fca5a5; transition: all 0.2s;
            background: #fef2f2; color: #ef4444;
        }
        .btn-delete:hover { background: #ef4444; color: white; border-color: #ef4444; }
        .btn-back {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 9px 18px; border-radius: 8px; font-size: 13px; font-weight: 600;
            cursor: pointer; border: 1.5px solid #e2e8f0; background: white;
            color: #475569; text-decoration: none; transition: all 0.2s;
        }
        .btn-back:hover { background: #f8fafc; border-color: #cbd5e1; color: #334155; }

        /* ===== EDIT FORM ===== */
        #editSection { display: none; }
        .form-label-sm { font-size: 12.5px; font-weight: 600; color: #475569; margin-bottom: 5px; display: block; }
        .form-ctrl {
            width: 100%; padding: 10px 13px; border: 1.5px solid #e2e8f0;
            border-radius: 8px; font-size: 14px; color: #334155;
            transition: border-color 0.2s; box-sizing: border-box; resize: vertical;
        }
        .form-ctrl:focus { outline: none; border-color: #0d9488; box-shadow: 0 0 0 3px rgba(13,148,136,0.1); }
        .form-row { margin-bottom: 14px; }

        /* ===== ALERT ===== */
        .alert-msg {
            padding: 12px 18px; border-radius: 10px; font-size: 13.5px;
            display: flex; align-items: center; gap: 9px; margin-bottom: 16px;
        }
        .alert-ok  { background: #ecfdf5; color: #065f46; border: 1.5px solid #a7f3d0; }
        .alert-err { background: #fef2f2; color: #991b1b; border: 1.5px solid #fca5a5; }

        /* ===== CONFIRM MODAL ===== */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(15,23,42,0.45); z-index: 9998; backdrop-filter: blur(3px);
        }
        .modal-overlay.show { display: flex; align-items: center; justify-content: center; }
        .modal-box {
            background: white; border-radius: 16px; padding: 28px;
            max-width: 400px; width: calc(100% - 32px);
            box-shadow: 0 20px 60px rgba(0,0,0,0.18);
        }
        .modal-box h5 { font-size: 17px; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
        .modal-box p  { font-size: 13.5px; color: #64748b; margin-bottom: 20px; }
        .modal-actions { display: flex; gap: 10px; }
    </style>
</head>
<body>
<div class="dashboard-wrapper">
    <%@ include file="/view/jsp/doctor/doctor_menu.jsp" %>
    <main class="dashboard-main">
        <%@ include file="/view/jsp/doctor/doctor_header.jsp" %>

        <div class="dashboard-content">
            <!-- Page header -->
            <div class="page-title-section">
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                    <div>
                        <h4><i class="fas fa-file-medical me-2" style="color:#0d9488"></i>Báo Cáo Y Tế</h4>
                        <p>Chi tiết kết quả khám bệnh và đơn thuốc</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="btn-back">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </div>
                <nav aria-label="breadcrumb" class="mt-2">
                    <ol class="breadcrumb mb-0" style="font-size:12.5px">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DoctorHomePageServlet" class="text-decoration-none">Trang chủ</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="text-decoration-none">Lịch khám</a></li>
                        <li class="breadcrumb-item active">Báo cáo y tế</li>
                    </ol>
                </nav>
            </div>

            <% String msg = request.getParameter("message"); %>
            <% if ("success".equals(msg)) { %>
            <div class="alert-msg alert-ok"><i class="fas fa-check-circle"></i> Cập nhật báo cáo thành công!</div>
            <% } else if ("error".equals(msg)) { %>
            <div class="alert-msg alert-err"><i class="fas fa-exclamation-circle"></i> Có lỗi xảy ra khi cập nhật!</div>
            <% } %>

            <% if (report == null) { %>
            <div class="report-card">
                <div style="padding:60px 24px;text-align:center;color:#94a3b8">
                    <i class="fas fa-file-times" style="font-size:52px;color:#e2e8f0;display:block;margin-bottom:16px"></i>
                    <h5 style="color:#64748b;margin-bottom:6px">Không tìm thấy báo cáo y tế</h5>
                    <p style="font-size:13px">Cuộc hẹn này chưa có kết quả khám được ghi nhận.</p>
                    <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="btn-back mt-2">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                    </a>
                </div>
            </div>
            <% } else { %>

            <!-- ===== VIEW MODE ===== -->
            <div id="viewSection">
                <!-- Card: Thông tin báo cáo -->
                <div class="report-card">
                    <div class="report-card-header">
                        <h5><i class="fas fa-clipboard-list"></i> Thông tin Báo Cáo
                            <span class="status-badge badge-teal ms-2"><i class="fas fa-circle" style="font-size:7px"></i> Hoàn thành</span>
                        </h5>
                        <div class="d-flex gap-2">
                            <button class="btn-edit" onclick="showEdit()"><i class="fas fa-pencil-alt"></i> Chỉnh sửa</button>
                            <button class="btn-delete" onclick="showDeleteModal()"><i class="fas fa-trash-alt"></i> Xóa</button>
                        </div>
                    </div>
                    <div class="report-card-body">
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-item-label">Mã báo cáo</span>
                                <span class="info-item-value">#<%= report.getReportId() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-item-label">Mã cuộc hẹn</span>
                                <span class="info-item-value">#<%= appointmentId != null ? appointmentId : report.getAppointmentId() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-item-label">Khung giờ khám</span>
                                <span class="info-item-value"><i class="fas fa-clock me-1 text-muted"></i><%= timeSlot != null ? timeSlot : "Không rõ" %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-item-label">Ngày tạo báo cáo</span>
                                <span class="info-item-value"><i class="fas fa-calendar me-1 text-muted"></i><%= report.getCreatedAt() %></span>
                            </div>
                            <div class="info-item info-item-full">
                                <span class="info-item-label">Chẩn đoán</span>
                                <span class="info-item-value"><%= report.getDiagnosis() != null ? report.getDiagnosis() : "Chưa có chẩn đoán" %></span>
                            </div>
                            <div class="info-item info-item-full">
                                <span class="info-item-label">Kế hoạch điều trị</span>
                                <span class="info-item-value"><%= report.getTreatmentPlan() != null ? report.getTreatmentPlan() : "Chưa có kế hoạch điều trị" %></span>
                            </div>
                            <div class="info-item info-item-full">
                                <span class="info-item-label">Ghi chú</span>
                                <span class="info-item-value"><%= report.getNote() != null ? report.getNote() : "Không có ghi chú" %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-item-label">Chữ ký bác sĩ</span>
                                <span class="info-item-value"><%= report.getSign() != null ? report.getSign() : "Chưa ký" %></span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Card: Bệnh nhân + bác sĩ (2 col) -->
                <div class="d-flex gap-3 flex-wrap mb-4">
                    <!-- Bệnh nhân -->
                    <div class="report-card flex-1" style="min-width:260px">
                        <div class="report-card-header">
                            <h5><i class="fas fa-user"></i> Bệnh Nhân</h5>
                        </div>
                        <div class="report-card-body">
                            <% if (patient != null) { %>
                            <div class="info-grid" style="grid-template-columns:1fr">
                                <div class="info-item info-item-full" style="border-right:none">
                                    <span class="info-item-label">Họ và tên</span>
                                    <span class="info-item-value fw-bold"><%= patient.getFullName() %></span>
                                </div>
                                <div class="info-item info-item-full" style="border-right:none">
                                    <span class="info-item-label">Ngày sinh</span>
                                    <span class="info-item-value"><%= patient.getDateOfBirth() %></span>
                                </div>
                                <div class="info-item info-item-full" style="border-right:none">
                                    <span class="info-item-label">Giới tính</span>
                                    <span class="info-item-value"><%= patient.getGender() %></span>
                                </div>
                                <div class="info-item info-item-full" style="border-right:none;border-bottom:none">
                                    <span class="info-item-label">Số điện thoại</span>
                                    <span class="info-item-value"><%= patient.getPhone() %></span>
                                </div>
                            </div>
                            <% } else { %>
                            <div style="padding:24px;text-align:center;color:#94a3b8">Không tìm thấy thông tin bệnh nhân</div>
                            <% } %>
                        </div>
                    </div>

                    <!-- Bác sĩ -->
                    <div class="report-card flex-1" style="min-width:260px">
                        <div class="report-card-header">
                            <h5><i class="fas fa-user-md"></i> Bác Sĩ Khám</h5>
                        </div>
                        <div class="report-card-body">
                            <% if (doctor != null) { %>
                            <div class="info-grid" style="grid-template-columns:1fr">
                                <div class="info-item info-item-full" style="border-right:none">
                                    <span class="info-item-label">Họ và tên</span>
                                    <span class="info-item-value fw-bold"><%= doctor.getFullName() %></span>
                                </div>
                                <div class="info-item info-item-full" style="border-right:none">
                                    <span class="info-item-label">Chuyên khoa</span>
                                    <span class="info-item-value">
                                        <span class="status-badge badge-blue"><i class="fas fa-stethoscope" style="font-size:10px"></i> <%= doctor.getSpecialty() %></span>
                                    </span>
                                </div>
                                <div class="info-item info-item-full" style="border-right:none;border-bottom:none">
                                    <span class="info-item-label">Mã bác sĩ</span>
                                    <span class="info-item-value">#<%= doctor.getDoctorId() %></span>
                                </div>
                            </div>
                            <% } else { %>
                            <div style="padding:24px;text-align:center;color:#94a3b8">Không tìm thấy thông tin bác sĩ</div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Card: Đơn thuốc -->
                <div class="report-card">
                    <div class="report-card-header">
                        <h5><i class="fas fa-pills"></i> Đơn Thuốc
                            <% if (rxList != null && !rxList.isEmpty()) { %>
                            <span class="status-badge badge-blue ms-2"><%= rxList.size() %> loại thuốc</span>
                            <% } %>
                        </h5>
                    </div>
                    <div class="report-card-body">
                        <% if (rxList != null && !rxList.isEmpty()) { %>
                        <table class="rx-table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Tên thuốc</th>
                                    <th>Số lượng</th>
                                    <th>Đơn vị</th>
                                    <th>Cách dùng</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int idx = 1; for (PrescriptionDetail rx : rxList) { %>
                                <tr>
                                    <td><span class="rx-badge"><%= idx++ %></span></td>
                                    <td class="rx-name-cell"><i class="fas fa-capsules me-1 text-muted"></i><%= rx.getMedicineName() %></td>
                                    <td><strong><%= rx.getQuantity() %></strong></td>
                                    <td><%= rx.getUnit() != null ? rx.getUnit() : "—" %></td>
                                    <td><%= rx.getUsage() != null ? rx.getUsage() : "Theo chỉ dẫn bác sĩ" %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                        <% } else { %>
                        <div class="empty-rx">
                            <i class="fas fa-prescription-bottle-alt"></i>
                            <p style="font-size:14px;color:#64748b;margin:0">Không có đơn thuốc nào được kê cho lần khám này</p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- ===== EDIT MODE ===== -->
            <div id="editSection">
                <div class="report-card">
                    <div class="report-card-header">
                        <h5><i class="fas fa-pencil-alt"></i> Chỉnh Sửa Báo Cáo</h5>
                        <button class="btn-back" onclick="hideEdit()"><i class="fas fa-times"></i> Hủy</button>
                    </div>
                    <div style="padding:24px">
                        <form action="${pageContext.request.contextPath}/UpdateMedicalReportServlet"
                              method="POST" onsubmit="return confirm('Bạn có chắc muốn lưu thay đổi này?')">
                            <input type="hidden" name="reportId" value="<%= report.getReportId() %>">

                            <div class="form-row">
                                <label class="form-label-sm">Chẩn đoán <span style="color:#ef4444">*</span></label>
                                <textarea class="form-ctrl" name="diagnosis" rows="3" required><%= report.getDiagnosis() != null ? report.getDiagnosis() : "" %></textarea>
                            </div>
                            <div class="form-row">
                                <label class="form-label-sm">Kế hoạch điều trị</label>
                                <textarea class="form-ctrl" name="treatmentPlan" rows="3"><%= report.getTreatmentPlan() != null ? report.getTreatmentPlan() : "" %></textarea>
                            </div>
                            <div class="form-row">
                                <label class="form-label-sm">Ghi chú</label>
                                <textarea class="form-ctrl" name="note" rows="2"><%= report.getNote() != null ? report.getNote() : "" %></textarea>
                            </div>
                            <div class="form-row">
                                <label class="form-label-sm">Chữ ký bác sĩ</label>
                                <input class="form-ctrl" type="text" name="sign" value="<%= report.getSign() != null ? report.getSign() : "" %>">
                            </div>
                            <div class="d-flex gap-2 mt-3">
                                <button type="submit" class="btn-edit"><i class="fas fa-save"></i> Lưu thay đổi</button>
                                <button type="button" class="btn-back" onclick="hideEdit()"><i class="fas fa-times"></i> Hủy</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <% } %>
        </div>
    </main>
</div>

<!-- Delete Confirm Modal -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal-box">
        <h5><i class="fas fa-exclamation-triangle me-2" style="color:#ef4444"></i>Xác nhận xóa</h5>
        <p>Bạn có chắc muốn xóa báo cáo y tế này? Thao tác này sẽ xóa toàn bộ báo cáo và đơn thuốc liên quan và <strong>không thể hoàn tác</strong>.</p>
        <div class="modal-actions">
            <button class="btn-back flex-fill" onclick="hideDeleteModal()"><i class="fas fa-times"></i> Hủy</button>
            <a href="${pageContext.request.contextPath}/DeleteMedicalReportServlet?reportId=<%= report != null ? report.getReportId() : 0 %>"
               style="flex:2" class="btn-delete justify-content-center text-decoration-none">
                <i class="fas fa-trash-alt"></i> Xác nhận xóa
            </a>
        </div>
    </div>
</div>

<%@ include file="/view/layout/dashboard_scripts.jsp" %>
<script>
    function showEdit()  { document.getElementById('viewSection').style.display='none'; document.getElementById('editSection').style.display='block'; }
    function hideEdit()  { document.getElementById('viewSection').style.display='block'; document.getElementById('editSection').style.display='none'; }
    function showDeleteModal() { document.getElementById('deleteModal').classList.add('show'); }
    function hideDeleteModal() { document.getElementById('deleteModal').classList.remove('show'); }
    document.getElementById('deleteModal').addEventListener('click', function(e){ if(e.target===this) hideDeleteModal(); });
    document.addEventListener('keydown', e=>{ if(e.key==='Escape') hideDeleteModal(); });
</script>
</body>
</html>
