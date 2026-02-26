<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String customerName = (String) request.getAttribute("customer_name");
    String medicineName = (String) request.getAttribute("medicine_name");
    Integer quantity = (Integer) request.getAttribute("quantity");
    java.math.BigDecimal price = (java.math.BigDecimal) request.getAttribute("price");
    java.math.BigDecimal total = (java.math.BigDecimal) request.getAttribute("total");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Bán thuốc thành công</title>
</head>
<body style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh;">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="dashboard-card text-center">
                    <div class="mb-4">
                        <i class="fas fa-check-circle text-success" style="font-size: 64px;"></i>
                    </div>
                    <h3 class="text-success mb-4">Bán thuốc thành công!</h3>
                    
                    <div class="text-start p-4" style="background: #f8f9fa; border-radius: 8px;">
                        <div class="mb-3">
                            <small class="text-muted">Khách hàng:</small><br>
                            <strong><%= customerName != null && !customerName.isEmpty() ? customerName : "Khách lẻ" %></strong>
                        </div>
                        <div class="mb-3">
                            <small class="text-muted">Thuốc:</small><br>
                            <strong><%= medicineName %></strong>
                        </div>
                        <div class="mb-3">
                            <small class="text-muted">Số lượng:</small><br>
                            <strong><%= quantity %></strong>
                        </div>
                        <div class="mb-3">
                            <small class="text-muted">Đơn giá:</small><br>
                            <strong><%= price != null ? String.format("%,d", price.intValue()) : "0" %> VNĐ</strong>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted">Tổng tiền:</span>
                            <span class="fs-4 fw-bold text-success"><%= total != null ? String.format("%,d", total.intValue()) : "0" %> VNĐ</span>
                        </div>
                    </div>
                    
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/jsp/staff/staff_toathuoc.jsp" class="btn-dashboard btn-dashboard-primary">
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
