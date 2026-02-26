<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String customerName = (String) request.getAttribute("customer_name");
    String medicineId = (String) request.getAttribute("medicine_id");
    String medicineName = (String) request.getAttribute("medicine_name");
    String quantity = (String) request.getAttribute("quantity");
    String price = (String) request.getAttribute("price");
    String paymentMethod = (String) request.getAttribute("payment_method");
    int total = 0;
    try {
        total = Integer.parseInt(quantity) * Integer.parseInt(price);
    } catch(Exception e) {}
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Xác nhận hóa đơn bán thuốc</title>
</head>
<body style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh;">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="dashboard-card">
                    <h5 class="text-center mb-4"><i class="fas fa-receipt me-2"></i>XÁC NHẬN HÓA ĐƠN</h5>
                    
                    <div class="mb-4 p-3" style="background: #f8f9fa; border-radius: 8px;">
                        <div class="mb-2">
                            <small class="text-muted">Khách hàng:</small><br>
                            <strong><%= customerName != null && !customerName.isEmpty() ? customerName : "Khách lẻ" %></strong>
                        </div>
                        <div>
                            <small class="text-muted">Hình thức thanh toán:</small><br>
                            <strong><%= "payos".equals(paymentMethod) ? "QR PayOS" : "Tiền mặt" %></strong>
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
                                <td><%= String.format("%,d", Integer.parseInt(price)) %> VNĐ</td>
                                <td class="fw-bold text-success"><%= String.format("%,d", total) %> VNĐ</td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <div class="stat-card success mt-4" style="padding: 15px;">
                        <div class="text-center">
                            <strong>Tổng tiền: </strong>
                            <span class="fs-4"><%= String.format("%,d", total) %> VNĐ</span>
                        </div>
                    </div>
                    
                    <form method="POST" action="<%=request.getContextPath()%>/<%= "payos".equals(paymentMethod) ? "StaffPayOSServlet" : "SellMedicineDirectServlet" %>">
                        <input type="hidden" name="customer_name" value="<%= customerName %>">
                        <input type="hidden" name="medicine_id" value="<%= medicineId %>">
                        <input type="hidden" name="medicine_name" value="<%= medicineName %>">
                        <input type="hidden" name="quantity" value="<%= quantity %>">
                        <input type="hidden" name="price" value="<%= price %>">
                        <input type="hidden" name="payment_method" value="<%= paymentMethod %>">
                        
                        <div class="d-flex gap-3 mt-4">
                            <a href="${pageContext.request.contextPath}/jsp/staff/sell_medicine_direct.jsp" class="btn btn-secondary flex-fill">
                                <i class="fas fa-arrow-left me-1"></i>Quay lại
                            </a>
                            <button type="submit" class="btn-dashboard btn-dashboard-primary flex-fill">
                                <i class="fas fa-check me-1"></i>Xác nhận & Tạo hóa đơn
                            </button>
                        </div>
                    </form>
                    
                    <p class="text-center text-muted mt-3 mb-0">
                        <i class="fas fa-info-circle me-1"></i>Kiểm tra kỹ thông tin trước khi xác nhận!
                    </p>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
</body>
</html>
