<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*" %>
<%@page import="model.User" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
    <title>Quản lý Trả góp - Staff</title>
    <style>
        .accordion-item {
            border: 1px solid #e5e7eb;
            border-radius: 8px !important;
            margin-bottom: 12px;
            overflow: hidden;
        }
        .accordion-button {
            background: white;
            font-weight: 500;
        }
        .accordion-button:not(.collapsed) {
            background: #f0f9ff;
            color: #1e3a8a;
            box-shadow: none;
        }
        .installment-row {
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .installment-row:last-child {
            border-bottom: none;
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
                        <h4 class="mb-1"><i class="fas fa-credit-card me-2"></i>Quản lý Trả góp</h4>
                        <p class="text-muted mb-0">Theo dõi và thanh toán các kỳ trả góp</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/StaffPaymentServlet?action=reminders" class="btn btn-outline-primary">
                        <i class="fas fa-bell me-1"></i>Nhắc nợ
                    </a>
                </div>
                
                <!-- Installments List -->
                <div class="dashboard-card">
                    <div class="accordion" id="installmentsAccordion">
                        <c:if test="${empty installmentBills}">
                            <div class="text-center py-5">
                                <i class="fas fa-check-circle text-success" style="font-size: 48px;"></i>
                                <p class="text-muted mt-3">Chưa có kế hoạch trả góp nào.</p>
                            </div>
                        </c:if>

                        <c:forEach items="${installmentBills}" var="bill" varStatus="loop">
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="heading${loop.index}">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${loop.index}">
                                        <div class="d-flex justify-content-between align-items-center w-100 pe-3 flex-wrap">
                                            <div>
                                                <span class="badge bg-primary me-2">${bill.billId}</span>
                                                <strong>${bill.customerName}</strong> - ${bill.customerPhone}
                                            </div>
                                            <div class="d-flex align-items-center">
                                                <span class="text-danger fw-bold me-3">
                                                    <fmt:formatNumber value="${bill.totalRemaining}" type="currency" currencySymbol="" />đ còn lại
                                                </span>
                                                <span class="badge bg-info">
                                                    ${bill.installmentSummary.paidInstallments}/${bill.installmentSummary.installmentCount} kỳ
                                                </span>
                                            </div>
                                        </div>
                                    </button>
                                </h2>
                                <div id="collapse${loop.index}" class="accordion-collapse collapse" data-bs-parent="#installmentsAccordion">
                                    <div class="accordion-body">
                                        <c:forEach items="${bill.installmentDetails}" var="inst">
                                            <div class="installment-row row align-items-center">
                                                <div class="col-md-2">
                                                    <strong>Kỳ ${inst.installmentNumber}</strong><br>
                                                    <span class="badge bg-${inst.status == 'PAID' ? 'success' : 'secondary'}">${inst.status}</span>
                                                </div>
                                                <div class="col-md-3">
                                                    <small class="text-muted">Hạn:</small><br>
                                                    <fmt:formatDate value="${inst.dueDate}" pattern="dd/MM/yyyy" />
                                                </div>
                                                <div class="col-md-4">
                                                    <small class="text-muted">Phải trả:</small><br>
                                                    <strong><fmt:formatNumber value="${inst.amountDue}" type="currency" currencySymbol="" />đ</strong>
                                                </div>
                                                <div class="col-md-3 text-end">
                                                    <c:if test="${inst.status ne 'PAID'}">
                                                        <button class="btn btn-success btn-sm" onclick="openPayModal('${bill.billId}', ${inst.installmentNumber}, ${inst.amountDue}, ${inst.amountPaid})">
                                                            <i class="fas fa-hand-holding-dollar me-1"></i>Thanh toán
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${inst.status eq 'PAID'}">
                                                        <span class="text-success"><i class="fas fa-check-circle"></i> Đã thanh toán</span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Payment Modal -->
    <div class="modal fade" id="paymentModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-money-bill-wave me-2"></i>Thanh toán kỳ trả góp</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="pay_billId">
                    <input type="hidden" id="pay_period">
                    
                    <div class="row mb-3">
                        <div class="col-6">
                            <label class="form-label">Hóa đơn:</label>
                            <p class="fw-bold mb-0" id="pay_billId_display"></p>
                        </div>
                        <div class="col-6">
                            <label class="form-label">Kỳ:</label>
                            <p class="fw-bold mb-0" id="pay_period_display"></p>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Số tiền còn lại của kỳ:</label>
                        <input type="text" id="pay_remaining_display" class="form-control" readonly style="background: #f8f9fa;">
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Số tiền thanh toán: <span class="text-danger">*</span></label>
                        <input type="number" id="pay_amount" class="form-control" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Phương thức:</label>
                        <select id="pay_method" class="form-select">
                            <option value="CASH">Tiền mặt</option>
                            <option value="BANK_TRANSFER">Chuyển khoản</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Ghi chú:</label>
                        <textarea id="pay_notes" class="form-control" rows="2"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" id="confirmPaymentBtn" onclick="submitPayment()">
                        <i class="fas fa-check me-1"></i>Xác nhận
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        const f = (num) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(num);

        function openPayModal(billId, period, amountDue, amountPaid) {
            const remaining = amountDue - amountPaid;
            document.getElementById('pay_billId').value = billId;
            document.getElementById('pay_period').value = period;
            document.getElementById('pay_billId_display').innerText = billId;
            document.getElementById('pay_period_display').innerText = 'Kỳ ' + period;
            document.getElementById('pay_remaining_display').value = f(remaining);
            document.getElementById('pay_amount').value = remaining;
            new bootstrap.Modal(document.getElementById('paymentModal')).show();
        }

        function submitPayment() {
            const btn = document.getElementById('confirmPaymentBtn');
            const originalHtml = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

            fetch('${pageContext.request.contextPath}/StaffPaymentServlet?action=payInstallment', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: new URLSearchParams({
                    billId: document.getElementById('pay_billId').value,
                    period: document.getElementById('pay_period').value,
                    amount: document.getElementById('pay_amount').value,
                    paymentMethod: document.getElementById('pay_method').value,
                    notes: document.getElementById('pay_notes').value
                })
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    bootstrap.Modal.getInstance(document.getElementById('paymentModal')).hide();
                    if (typeof showToast === 'function') {
                        showToast('Thanh toán thành công!', 'success');
                    } else {
                        alert('Thanh toán thành công!');
                    }
                    setTimeout(() => window.location.reload(), 1000);
                } else {
                    alert('Lỗi: ' + (data.message || 'Thanh toán thất bại.'));
                    btn.disabled = false;
                    btn.innerHTML = originalHtml;
                }
            }).catch(err => {
                alert('Lỗi kết nối. Vui lòng thử lại.');
                btn.disabled = false;
                btn.innerHTML = originalHtml;
            });
        }
    </script>
</body>
</html>
