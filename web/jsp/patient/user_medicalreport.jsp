<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.MedicalReport, model.Prescription" %>
<%@ include file="user_header.jsp" %>
<%@ include file="user_menu.jsp" %>
<% 
    MedicalReport report = (MedicalReport) request.getAttribute("report"); 
    List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết báo cáo y tế - Happy Smile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8fafc;
        }
        .container {
            margin-left: 280px; /* Sidebar width */
            padding: 2rem;
            max-width: calc(100% - 280px);
        }
        .report-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            padding: 2.5rem;
            margin-bottom: 2rem;
            border: 1px solid #edf2f7;
        }
        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 2px solid #f1f5f9;
        }
        .report-title {
            color: #1e293b;
            font-weight: 800;
            font-size: 1.75rem;
            margin: 0;
        }
        .badge-id {
            background-color: #f1f5f9;
            color: #64748b;
            padding: 0.5rem 1rem;
            border-radius: 99px;
            font-weight: 600;
            font-size: 0.875rem;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
            margin-bottom: 3rem;
        }
        .info-item {
            margin-bottom: 1rem;
        }
        .info-label {
            display: block;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #94a3b8;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .info-value {
            font-size: 1rem;
            color: #334155;
            font-weight: 600;
        }
        .section-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        .section-title i {
            color: #3b82f6;
        }
        .clinical-section {
            background: #f8fafc;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid #3b82f6;
        }
        .prescription-table {
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }
        .table thead th {
            background-color: #f1f5f9;
            color: #475569;
            font-weight: 700;
            border: none;
            padding: 1rem;
        }
        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }
        .signature-box {
            margin-top: 4rem;
            text-align: right;
            padding-right: 2rem;
        }
        .signature-title {
            font-size: 0.875rem;
            color: #64748b;
            margin-bottom: 3rem;
        }
        .signature-name {
            font-weight: 700;
            color: #1e293b;
            font-size: 1.125rem;
            text-decoration: underline;
        }
        .btn-action {
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-pdf {
            background-color: #ef4444;
            color: white;
            border: none;
        }
        .btn-pdf:hover {
            background-color: #dc2626;
            color: white;
            transform: translateY(-2px);
        }
        .btn-back {
            background-color: #ffffff;
            color: #64748b;
            border: 1px solid #e2e8f0;
        }
        .btn-back:hover {
            background-color: #f8fafc;
            color: #1e293b;
            transform: translateY(-2px);
        }
        
        @media print {
            .container { margin-left: 0; max-width: 100%; padding: 0; }
            .btn-action, .user-menu, .user-header { display: none !important; }
            .report-card { box-shadow: none; border: none; }
        }
    </style>
</head>
<body>
    <div class="container">
        <% if (report != null) { %>
            <div class="report-card">
                <div class="report-header">
                    <h2 class="report-title">Báo Cáo Y Tế</h2>
                    <span class="badge-id">Mã BC: #<%= report.getReportId() %></span>
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Bệnh nhân</span>
                        <div class="info-value"><%= report.getPatientName() != null ? report.getPatientName() : "Chưa cập nhật" %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Bác sĩ phụ trách</span>
                        <div class="info-value"><%= report.getDoctorName() != null ? report.getDoctorName() : "Chưa cập nhật" %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ngày khám</span>
                        <div class="info-value">
                            <%= report.getCreatedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(report.getCreatedAt()) : "Chưa cập nhật" %>
                        </div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Trạng thái</span>
                        <div class="info-value text-success">Hoàn thành</div>
                    </div>
                </div>

                <div class="section-title">
                    <i class="fas fa-stethoscope"></i> Kết quả lâm sàng
                </div>
                
                <div class="clinical-section">
                    <span class="info-label">Chẩn đoán</span>
                    <div class="info-value mb-4"><%= report.getDiagnosis() != null ? report.getDiagnosis() : "Chưa có chẩn đoán" %></div>
                    
                    <span class="info-label">Phác đồ & Kế hoạch điều trị</span>
                    <div class="info-value"><%= report.getTreatmentPlan() != null ? report.getTreatmentPlan() : "Chưa có phác đồ" %></div>
                </div>

                <% if (report.getNote() != null && !report.getNote().trim().isEmpty()) { %>
                <div class="clinical-section" style="border-left-color: #f59e0b;">
                    <span class="info-label" style="color: #f59e0b;">Ghi chú từ bác sĩ</span>
                    <div class="info-value"><%= report.getNote() %></div>
                </div>
                <% } %>

                <div class="section-title mt-5">
                    <i class="fas fa-pills"></i> Đơn thuốc được kê
                </div>

                <% if (prescriptions != null && !prescriptions.isEmpty()) { %>
                    <div class="prescription-table">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th width="30%">Tên thuốc</th>
                                    <th width="15%" class="text-center">Số lượng</th>
                                    <th>Hướng dẫn sử dụng</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Prescription p : prescriptions) { %>
                                    <tr>
                                        <td class="fw-bold"><%= p.getName() != null ? p.getName() : "N/A" %></td>
                                        <td class="text-center"><%= p.getQuantity() %></td>
                                        <td class="text-muted"><%= p.getUsage() != null ? p.getUsage() : "Theo chỉ định bác sĩ" %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="alert alert-light border text-muted">
                        <i class="fas fa-info-circle me-2"></i> Không có đơn thuốc đi kèm trong báo cáo này.
                    </div>
                <% } %>

                <div class="signature-box">
                    <div class="signature-title">Bác sĩ điều trị</div>
                    <div class="signature-name"><%= report.getSign() != null ? report.getSign() : "Chưa ký tên" %></div>
                    <div class="small text-muted mt-2">Ngày: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %></div>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-5">
                <a href="${pageContext.request.contextPath}/PatientAppointments" class="btn-action btn-back">
                    <i class="fas fa-arrow-left"></i> Quay lại lịch hẹn
                </a>
                <div class="d-flex gap-2">
                    <form action="${pageContext.request.contextPath}/ExportMedicalReportServlet" method="get">
                        <input type="hidden" name="reportId" value="<%= report.getReportId() %>">
                        <button type="submit" class="btn-action btn-pdf">
                            <i class="fas fa-file-pdf"></i> Tải PDF
                        </button>
                    </form>
                    <button onclick="window.print()" class="btn btn-outline-dark btn-action">
                        <i class="fas fa-print"></i> In báo cáo
                    </button>
                </div>
            </div>

        <% } else { %>
            <div class="report-card text-center py-5">
                <i class="fas fa-search text-muted mb-4" style="font-size: 4rem;"></i>
                <h3 class="text-dark fw-bold">Không tìm thấy báo cáo</h3>
                <p class="text-muted">Rất tiếc, thông tin báo cáo bạn yêu cầu không tồn tại hoặc chưa được cập nhật.</p>
                <a href="${pageContext.request.contextPath}/PatientAppointments" class="btn btn-primary mt-3">
                    Quay lại danh sách
                </a>
            </div>
        <% } %>
    </div>
</body>
</html>
