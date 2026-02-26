<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
    <title>Nhắc nợ Khách hàng - Staff</title>
    <style>
        .reminder-row {
            padding: 16px;
            margin: 8px 0;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            transition: all 0.2s;
        }
        .reminder-row:hover {
            background-color: #f8fafc;
            border-color: #4361ee;
        }
        .reminder-row.urgent {
            border-left: 5px solid #dc2626;
            background: linear-gradient(135deg, #fef2f2 0%, #ffffff 100%);
        }
        .reminder-row.due-soon {
            border-left: 5px solid #f59e0b;
            background: linear-gradient(135deg, #fffbeb 0%, #ffffff 100%);
        }
        .reminder-row.normal {
            border-left: 5px solid #4361ee;
        }
        .contact-btn {
            margin: 2px;
            border-radius: 6px;
            font-size: 12px;
            padding: 6px 12px;
            border: none;
            color: white;
            cursor: pointer;
        }
        .btn-sms { background: #10b981; }
        .btn-call { background: #3b82f6; }
        .btn-email { background: #8b5cf6; }
        .bill-id {
            font-family: monospace;
            background: #f1f5f9;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 12px;
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
                        <h4 class="mb-1"><i class="fas fa-bell me-2"></i>Nhắc nợ Khách hàng</h4>
                        <p class="text-muted mb-0">Quản lý và gửi thông báo nhắc nợ</p>
                    </div>
                    <div>
                        <button class="btn btn-success me-2" onclick="sendBulkReminders()">
                            <i class="fas fa-paper-plane me-1"></i>Gửi hàng loạt
                        </button>
                        <a href="${pageContext.request.contextPath}/StaffPaymentServlet?action=installments" class="btn btn-outline-primary">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại
                        </a>
                    </div>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card danger">
                            <div class="stat-card-icon">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="stat-card-value">8</div>
                            <div class="stat-card-label">Quá hạn</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-card-value">5</div>
                            <div class="stat-card-label">Sắp đến hạn</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-card-value">12</div>
                            <div class="stat-card-label">Đã nhắc hôm nay</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="stat-card-value">85%</div>
                            <div class="stat-card-label">Tỷ lệ phản hồi</div>
                        </div>
                    </div>
                </div>
                
                <!-- Filter Tabs -->
                <ul class="nav nav-pills mb-4">
                    <li class="nav-item">
                        <button class="nav-link active" data-filter="all" onclick="filterReminders('all')">Tất cả (25)</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-filter="urgent" onclick="filterReminders('urgent')">Khẩn cấp (8)</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-filter="due-soon" onclick="filterReminders('due-soon')">Sắp đến hạn (5)</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-filter="normal" onclick="filterReminders('normal')">Bình thường (12)</button>
                    </li>
                </ul>
                
                <!-- Main Content -->
                <div class="dashboard-card">
                    <h6 class="mb-3"><i class="fas fa-list me-2"></i>Danh sách khách hàng cần nhắc nợ</h6>
                    
                    <!-- Search -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" id="searchInput" class="form-control" placeholder="Tìm theo mã HĐ, tên, SĐT..." onkeyup="searchReminders()">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select id="reminderTypeFilter" class="form-select" onchange="searchReminders()">
                                <option value="">Tất cả loại nhắc</option>
                                <option value="SMS">SMS</option>
                                <option value="CALL">Điện thoại</option>
                                <option value="EMAIL">Email</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Reminders List -->
                    <div id="remindersList">
                        <!-- Urgent -->
                        <div class="reminder-row urgent" data-priority="urgent">
                            <div class="row align-items-center">
                                <div class="col-md-1 text-center">
                                    <i class="fas fa-exclamation-triangle fa-2x text-danger"></i>
                                </div>
                                <div class="col-md-3">
                                    <span class="bill-id">BILL_FDEF5983</span>
                                    <p class="mb-1 mt-2"><strong>Nguyễn Văn A</strong></p>
                                    <small class="text-muted"><i class="fas fa-phone me-1"></i>0123456789</small>
                                </div>
                                <div class="col-md-2 text-center">
                                    <strong class="text-danger">833,333 VNĐ</strong><br>
                                    <small class="text-muted">Kỳ 3/6</small>
                                </div>
                                <div class="col-md-2">
                                    <span class="badge bg-danger">Quá hạn 7 ngày</span><br>
                                    <small class="text-muted">Hạn: 15/08/2024</small>
                                </div>
                                <div class="col-md-2">
                                    <small class="text-muted">Lần nhắc cuối:</small><br>
                                    <strong>20/08/2024</strong> <span class="badge bg-info">SMS</span>
                                </div>
                                <div class="col-md-2">
                                    <button class="contact-btn btn-sms" onclick="sendReminder('BILL_FDEF5983', 'SMS')"><i class="fas fa-sms me-1"></i>SMS</button>
                                    <button class="contact-btn btn-call" onclick="sendReminder('BILL_FDEF5983', 'CALL')"><i class="fas fa-phone me-1"></i>Gọi</button>
                                    <button class="contact-btn btn-email" onclick="sendReminder('BILL_FDEF5983', 'EMAIL')"><i class="fas fa-envelope me-1"></i>Email</button>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Due Soon -->
                        <div class="reminder-row due-soon" data-priority="due-soon">
                            <div class="row align-items-center">
                                <div class="col-md-1 text-center">
                                    <i class="fas fa-clock fa-2x text-warning"></i>
                                </div>
                                <div class="col-md-3">
                                    <span class="bill-id">BILL_ABC12345</span>
                                    <p class="mb-1 mt-2"><strong>Trần Thị B</strong></p>
                                    <small class="text-muted"><i class="fas fa-phone me-1"></i>0987654321</small>
                                </div>
                                <div class="col-md-2 text-center">
                                    <strong class="text-warning">833,333 VNĐ</strong><br>
                                    <small class="text-muted">Kỳ 7/12</small>
                                </div>
                                <div class="col-md-2">
                                    <span class="badge bg-warning text-dark">Còn 2 ngày</span><br>
                                    <small class="text-muted">Hạn: 25/08/2024</small>
                                </div>
                                <div class="col-md-2">
                                    <small class="text-muted">Lần nhắc cuối:</small><br>
                                    <strong>18/08/2024</strong> <span class="badge bg-success">Gọi điện</span>
                                </div>
                                <div class="col-md-2">
                                    <button class="contact-btn btn-sms" onclick="sendReminder('BILL_ABC12345', 'SMS')"><i class="fas fa-sms me-1"></i>SMS</button>
                                    <button class="contact-btn btn-call" onclick="sendReminder('BILL_ABC12345', 'CALL')"><i class="fas fa-phone me-1"></i>Gọi</button>
                                    <button class="contact-btn btn-email" onclick="sendReminder('BILL_ABC12345', 'EMAIL')"><i class="fas fa-envelope me-1"></i>Email</button>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Normal -->
                        <div class="reminder-row normal" data-priority="normal">
                            <div class="row align-items-center">
                                <div class="col-md-1 text-center">
                                    <i class="fas fa-info-circle fa-2x text-primary"></i>
                                </div>
                                <div class="col-md-3">
                                    <span class="bill-id">BILL_DEF78901</span>
                                    <p class="mb-1 mt-2"><strong>Lê Văn C</strong></p>
                                    <small class="text-muted"><i class="fas fa-phone me-1"></i>0369852741</small>
                                </div>
                                <div class="col-md-2 text-center">
                                    <strong class="text-primary">750,000 VNĐ</strong><br>
                                    <small class="text-muted">Kỳ 2/9</small>
                                </div>
                                <div class="col-md-2">
                                    <span class="badge bg-primary">Còn 5 ngày</span><br>
                                    <small class="text-muted">Hạn: 28/08/2024</small>
                                </div>
                                <div class="col-md-2">
                                    <small class="text-muted">Lần nhắc cuối:</small><br>
                                    <strong>15/08/2024</strong> <span class="badge bg-secondary">Email</span>
                                </div>
                                <div class="col-md-2">
                                    <button class="contact-btn btn-sms" onclick="sendReminder('BILL_DEF78901', 'SMS')"><i class="fas fa-sms me-1"></i>SMS</button>
                                    <button class="contact-btn btn-call" onclick="sendReminder('BILL_DEF78901', 'CALL')"><i class="fas fa-phone me-1"></i>Gọi</button>
                                    <button class="contact-btn btn-email" onclick="sendReminder('BILL_DEF78901', 'EMAIL')"><i class="fas fa-envelope me-1"></i>Email</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Bulk Actions -->
                    <div class="row g-3 mt-4">
                        <div class="col-md-3">
                            <button class="btn btn-warning w-100" onclick="selectUrgentReminders()">
                                <i class="fas fa-exclamation-triangle me-1"></i>Chọn tất cả quá hạn
                            </button>
                        </div>
                        <div class="col-md-3">
                            <button class="btn btn-info w-100 text-white" onclick="sendBulkSMS()">
                                <i class="fas fa-sms me-1"></i>Gửi SMS hàng loạt
                            </button>
                        </div>
                        <div class="col-md-3">
                            <button class="btn btn-success w-100" onclick="generateReport()">
                                <i class="fas fa-file-alt me-1"></i>Báo cáo nhắc nợ
                            </button>
                        </div>
                        <div class="col-md-3">
                            <button class="btn btn-secondary w-100" onclick="exportToExcel()">
                                <i class="fas fa-file-excel me-1"></i>Xuất Excel
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Reminder Modal -->
    <div class="modal fade" id="reminderModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-bell me-2"></i>Gửi thông báo nhắc nợ</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="reminderForm">
                        <input type="hidden" id="reminderBillId">
                        <input type="hidden" id="reminderType">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Hóa đơn:</label>
                                <input type="text" id="reminderBillIdDisplay" class="form-control-plaintext bill-id" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Loại thông báo:</label>
                                <input type="text" id="reminderTypeDisplay" class="form-control-plaintext" readonly>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Nội dung thông báo:</label>
                            <textarea id="reminderMessage" class="form-control" rows="6">Kính chào Quý khách,

Phòng khám nha khoa DentCare thông báo Quý khách có kỳ trả góp đến hạn thanh toán.

Vui lòng liên hệ hotline 0123456789 để thanh toán.

Xin cảm ơn Quý khách!</textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Lên lịch gửi:</label>
                            <select id="reminderSchedule" class="form-select">
                                <option value="now">Gửi ngay</option>
                                <option value="1hour">Sau 1 giờ</option>
                                <option value="1day">Sau 1 ngày</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="submitReminder()">
                        <i class="fas fa-paper-plane me-1"></i>Gửi thông báo
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function filterReminders(priority) {
            document.querySelectorAll('.nav-pills .nav-link').forEach(link => link.classList.remove('active'));
            document.querySelector('[data-filter="' + priority + '"]').classList.add('active');

            document.querySelectorAll('.reminder-row').forEach(row => {
                row.style.display = (priority === 'all' || row.dataset.priority === priority) ? '' : 'none';
            });
        }

        function searchReminders() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            document.querySelectorAll('.reminder-row').forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            });
        }

        function sendReminder(billId, type) {
            document.getElementById('reminderBillId').value = billId;
            document.getElementById('reminderType').value = type;
            document.getElementById('reminderBillIdDisplay').value = billId;
            document.getElementById('reminderTypeDisplay').value = type;
            new bootstrap.Modal(document.getElementById('reminderModal')).show();
        }

        function submitReminder() {
            const billId = document.getElementById('reminderBillId').value;
            const type = document.getElementById('reminderType').value;
            alert('Đã gửi thông báo ' + type + ' cho hóa đơn ' + billId + ' thành công!');
            bootstrap.Modal.getInstance(document.getElementById('reminderModal')).hide();
        }

        function selectUrgentReminders() { alert('Đã chọn tất cả hóa đơn quá hạn'); }
        function sendBulkSMS() { if (confirm('Gửi SMS cho tất cả?')) alert('Đã gửi SMS hàng loạt!'); }
        function sendBulkReminders() { if (confirm('Gửi thông báo cho tất cả?')) alert('Đã gửi thông báo hàng loạt!'); }
        function generateReport() { alert('Đang tạo báo cáo...'); }
        function exportToExcel() { alert('Đang xuất Excel...'); }
    </script>
</body>
</html>
