<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.PatientDAO,dao.BillDAO,dao.MedicineDAO,model.Patients,model.Bill,model.Medicine,java.util.List,model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    
    PatientDAO patientDAO = new PatientDAO();
    List<Patients> patients = patientDAO.getAll();
    
    BillDAO billDAO = new BillDAO();
    List<Bill> bills = billDAO.getAllBills();
    
    List<Medicine> medicines = MedicineDAO.getAllMedicine();
    
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
    <title>Báo cáo thống kê - Manager</title>
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
                        <h4 class="mb-1"><i class="fas fa-chart-line me-2"></i>Báo cáo thống kê</h4>
                        <p class="text-muted mb-0">Tổng hợp dữ liệu từ các bảng chính trong hệ thống</p>
                    </div>
                    <button class="btn-dashboard btn-dashboard-secondary" onclick="window.print()">
                        <i class="fas fa-print"></i> In báo cáo
                    </button>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-card-value"><%= patients.size() %></div>
                            <div class="stat-card-label">Tổng bệnh nhân</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-file-invoice-dollar"></i>
                            </div>
                            <div class="stat-card-value"><%= bills.size() %></div>
                            <div class="stat-card-label">Tổng hóa đơn</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-pills"></i>
                            </div>
                            <div class="stat-card-value"><%= medicines.size() %></div>
                            <div class="stat-card-label">Loại thuốc</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-coins"></i>
                            </div>
                            <div class="stat-card-value"><%= String.format("%,.0f", totalRevenue) %></div>
                            <div class="stat-card-label">Doanh thu (VNĐ)</div>
                        </div>
                    </div>
                </div>
                
                <!-- Patients Table -->
                <div class="dashboard-card mb-4">
                    <div class="dashboard-card-header">
                        <h5 class="dashboard-card-title">
                            <i class="fas fa-users text-primary me-2"></i>
                            Danh sách bệnh nhân (<%= patients.size() %>)
                        </h5>
                    </div>
                    <div class="table-responsive">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>Mã BN</th>
                                    <th>Họ tên</th>
                                    <th>Ngày sinh</th>
                                    <th>Giới tính</th>
                                    <th>SĐT</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (patients.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">Chưa có dữ liệu</td>
                                </tr>
                                <% } else { for (Patients p : patients) { %>
                                <tr>
                                    <td><span class="badge bg-primary">#<%= p.getPatientId() %></span></td>
                                    <td><%= p.getFullName() != null ? p.getFullName() : "N/A" %></td>
                                    <td><%= p.getDateOfBirth() != null ? p.getDateOfBirth() : "N/A" %></td>
                                    <td>
                                        <span class="badge-dashboard <%= "male".equals(p.getGender()) ? "badge-primary" : "badge-danger" %>">
                                            <%= "male".equals(p.getGender()) ? "Nam" : "female".equals(p.getGender()) ? "Nữ" : "Khác" %>
                                        </span>
                                    </td>
                                    <td><%= p.getPhone() != null ? p.getPhone() : "N/A" %></td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Bills Table -->
                <div class="dashboard-card mb-4">
                    <div class="dashboard-card-header">
                        <h5 class="dashboard-card-title">
                            <i class="fas fa-file-invoice-dollar text-success me-2"></i>
                            Danh sách hóa đơn (<%= bills.size() %>)
                        </h5>
                    </div>
                    <div class="table-responsive">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>Mã hóa đơn</th>
                                    <th>Mã bệnh nhân</th>
                                    <th>Tổng tiền</th>
                                    <th>Ngày tạo</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (bills.isEmpty()) { %>
                                <tr>
                                    <td colspan="4" class="text-center py-4 text-muted">Chưa có dữ liệu</td>
                                </tr>
                                <% } else { for (Bill bill : bills) { %>
                                <tr>
                                    <td><span class="badge bg-success">#<%= bill.getBillId() %></span></td>
                                    <td><%= bill.getPatientId() %></td>
                                    <td><strong class="text-success"><%= String.format("%,.0f", bill.getAmount()) %> VNĐ</strong></td>
                                    <td><%= bill.getCreatedAt() %></td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Medicines Table -->
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <h5 class="dashboard-card-title">
                            <i class="fas fa-pills text-warning me-2"></i>
                            Danh sách thuốc (<%= medicines.size() %>)
                        </h5>
                    </div>
                    <div class="table-responsive">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>Mã thuốc</th>
                                    <th>Tên thuốc</th>
                                    <th>Số lượng tồn</th>
                                    <th>Đơn vị tính</th>
                                    <th>Mô tả</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (medicines.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">Chưa có dữ liệu</td>
                                </tr>
                                <% } else { for (Medicine med : medicines) { %>
                                <tr>
                                    <td><span class="badge bg-warning text-dark">#<%= med.getMedicineId() %></span></td>
                                    <td><strong><%= med.getName() %></strong></td>
                                    <td>
                                        <span class="badge <%= med.getQuantityInStock() < 10 ? "bg-danger" : "bg-success" %>">
                                            <%= med.getQuantityInStock() %>
                                        </span>
                                    </td>
                                    <td><%= med.getUnit() %></td>
                                    <td><small class="text-muted"><%= med.getDescription() != null ? med.getDescription() : "N/A" %></small></td>
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
</body>
</html>
