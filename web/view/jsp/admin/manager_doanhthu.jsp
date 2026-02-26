<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.BillDAO,model.Bill,java.util.List,model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    
    BillDAO billDAO = new BillDAO();
    List<Bill> bills = billDAO.getAllBills();
    
    // Tính tổng doanh thu
    double totalRevenue = 0;
    for (Bill bill : bills) {
        totalRevenue += bill.getAmount();
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Doanh thu - Manager</title>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/manager/manager_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/manager/manager_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-coins me-2"></i>Quản lý doanh thu</h4>
                        <p class="text-muted mb-0">Theo dõi doanh thu và hóa đơn trong hệ thống</p>
                    </div>
                    <button class="btn-dashboard btn-dashboard-secondary" onclick="window.print()">
                        <i class="fas fa-download"></i> Xuất báo cáo
                    </button>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-md-6 col-xl-4">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-coins"></i>
                            </div>
                            <div class="stat-card-value"><%= String.format("%,.0f", totalRevenue) %></div>
                            <div class="stat-card-label">Tổng doanh thu (VNĐ)</div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-xl-4">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-file-invoice"></i>
                            </div>
                            <div class="stat-card-value"><%= bills.size() %></div>
                            <div class="stat-card-label">Tổng số hóa đơn</div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-xl-4">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-calculator"></i>
                            </div>
                            <div class="stat-card-value"><%= bills.size() > 0 ? String.format("%,.0f", totalRevenue / bills.size()) : "0" %></div>
                            <div class="stat-card-label">Trung bình/hóa đơn (VNĐ)</div>
                        </div>
                    </div>
                </div>
                
                <!-- Bills Table -->
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <h5 class="dashboard-card-title">
                            <i class="fas fa-list text-primary me-2"></i>
                            Danh sách hóa đơn
                        </h5>
                        <div class="input-group" style="width: 300px;">
                            <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                            <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm..." onkeyup="filterTable()">
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="dashboard-table" id="billsTable">
                            <thead>
                                <tr>
                                    <th>Mã hóa đơn</th>
                                    <th>Mã bệnh nhân</th>
                                    <th>Tổng tiền</th>
                                    <th>Ngày tạo</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (bills.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="text-center py-5">
                                        <i class="fas fa-file-invoice text-muted" style="font-size: 48px;"></i>
                                        <p class="text-muted mt-3">Chưa có hóa đơn nào trong hệ thống</p>
                                    </td>
                                </tr>
                                <% } else { for (Bill bill : bills) { %>
                                <tr>
                                    <td><span class="badge bg-primary">#<%= bill.getBillId() %></span></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/view/assets/img/default-avatar.png" class="rounded-circle me-2" style="width: 32px; height: 32px;">
                                            <span>BN#<%= bill.getPatientId() %></span>
                                        </div>
                                    </td>
                                    <td><strong class="text-success"><%= String.format("%,.0f", bill.getAmount()) %> VNĐ</strong></td>
                                    <td><%= bill.getCreatedAt() %></td>
                                    <td><span class="badge bg-success">Đã thanh toán</span></td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function filterTable() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toLowerCase();
            var table = document.getElementById("billsTable");
            var tr = table.getElementsByTagName("tr");

            for (var i = 1; i < tr.length; i++) {
                var td = tr[i].getElementsByTagName("td");
                var show = false;
                
                for (var j = 0; j < td.length; j++) {
                    if (td[j]) {
                        var txtValue = td[j].textContent || td[j].innerText;
                        if (txtValue.toLowerCase().indexOf(filter) > -1) {
                            show = true;
                            break;
                        }
                    }
                }
                
                tr[i].style.display = show ? "" : "none";
            }
        }
    </script>
</body>
</html>
