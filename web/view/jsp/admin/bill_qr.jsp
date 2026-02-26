<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.math.BigDecimal" %>
<%@page import="model.Bill" %>
<%
    Bill bill = (Bill) request.getAttribute("bill");
    String medicineName = (String) request.getAttribute("medicineName");
    Integer quantity = (Integer) request.getAttribute("quantity");
    BigDecimal price = (BigDecimal) request.getAttribute("price");
    BigDecimal total = (BigDecimal) request.getAttribute("total");
    String qrCode = (String) request.getAttribute("qrCode");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Hóa đơn bán thuốc - QR PayOS</title>
</head>
<body style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh;">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="dashboard-card">
                    <h5 class="text-center mb-4"><i class="fas fa-receipt me-2"></i>HÓA ĐƠN BÁN THUỐC</h5>
                    
                    <div class="mb-4 p-3" style="background: #f8f9fa; border-radius: 8px;">
                        <div class="mb-2">
                            <small class="text-muted">Mã hóa đơn:</small><br>
                            <strong class="text-primary"><%= bill != null ? bill.getBillId() : "" %></strong>
                        </div>
                        <div>
                            <small class="text-muted">Khách hàng:</small><br>
                            <strong><%= bill != null ? bill.getCustomerName() : "" %></strong>
                        </div>
                    </div>
                    
                    <table class="dashboard-table">
                        <thead>
                            <tr>
                                <th>Thuốc</th>
                                <th>Số lượng</th>
                                <th>Đơn giá</th>
                                <th>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><%= medicineName %></td>
                                <td><%= quantity %></td>
                                <td><%= price != null ? String.format("%,d", price.intValue()) : "" %> VNĐ</td>
                                <td class="fw-bold text-success"><%= total != null ? String.format("%,d", total.intValue()) : "" %> VNĐ</td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <div class="stat-card success mt-4" style="padding: 15px;">
                        <div class="text-center">
                            <strong>Tổng tiền: </strong>
                            <span class="fs-4"><%= total != null ? String.format("%,d", total.intValue()) : "" %> VNĐ</span>
                        </div>
                    </div>
                    
                    <!-- QR Code Section -->
                    <div class="text-center mt-4 p-4" style="background: #f0f9ff; border-radius: 12px;">
                        <h6 class="mb-3"><i class="fas fa-qrcode me-2"></i>Quét mã QR để thanh toán qua PayOS</h6>
                        <% if (qrCode != null && !qrCode.isEmpty()) { %>
                        <img src="<%= qrCode %>" alt="QR PayOS" style="width: 220px; height: 220px; border-radius: 8px; border: 2px solid #4361ee;">
                        <% } else { %>
                        <div class="alert alert-danger mt-3">
                            <i class="fas fa-exclamation-circle me-2"></i>Không tạo được mã QR. Vui lòng thử lại!
                        </div>
                        <% } %>
                    </div>
                    
                    <p class="text-center text-muted mt-4 mb-3">
                        <i class="fas fa-info-circle me-1"></i>Sau khi thanh toán thành công, vui lòng báo cho nhân viên để xác nhận và nhận thuốc.
                    </p>
                    
                    <div class="text-center">
                        <a href="${pageContext.request.contextPath}/jsp/staff/staff_toathuoc.jsp" class="btn-dashboard btn-dashboard-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại bán hàng
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
</body>
</html>
