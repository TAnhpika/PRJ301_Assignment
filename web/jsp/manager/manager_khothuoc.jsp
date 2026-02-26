<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.MedicineDAO,model.Medicine,java.util.List,model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    
    List<Medicine> medicines = MedicineDAO.getAllMedicine();
    
    // Count low stock medicines
    int lowStockCount = 0;
    for (Medicine med : medicines) {
        if (med.getQuantityInStock() < 10) lowStockCount++;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Kho thuốc - Manager</title>
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
                        <h4 class="mb-1"><i class="fas fa-pills me-2"></i>Quản lý kho thuốc</h4>
                        <p class="text-muted mb-0">Theo dõi và quản lý thuốc trong kho</p>
                    </div>
                    <button class="btn-dashboard btn-dashboard-primary" data-bs-toggle="modal" data-bs-target="#addMedicineModal">
                        <i class="fas fa-plus"></i> Thêm thuốc mới
                    </button>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-pills"></i>
                            </div>
                            <div class="stat-card-value"><%= medicines.size() %></div>
                            <div class="stat-card-label">Tổng số loại thuốc</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="stat-card danger">
                            <div class="stat-card-icon">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="stat-card-value"><%= lowStockCount %></div>
                            <div class="stat-card-label">Thuốc sắp hết</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="stat-card-value"><%= medicines.size() - lowStockCount %></div>
                            <div class="stat-card-label">Đủ hàng</div>
                        </div>
                    </div>
                </div>
                
                <!-- Search Box -->
                <div class="dashboard-card mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm thuốc..." onkeyup="filterTable()">
                            </div>
                        </div>
                        <div class="col-md-6 text-md-end mt-3 mt-md-0">
                            <span class="text-muted">Tổng: <strong><%= medicines.size() %></strong> loại thuốc</span>
                        </div>
                    </div>
        </div>
                
                <!-- Medicines Table -->
                <div class="dashboard-card">
                    <div class="table-responsive">
                        <table class="dashboard-table" id="medicineTable">
            <thead>
                <tr>
                    <th>Mã thuốc</th>
                    <th>Tên thuốc</th>
                                    <th>Số lượng tồn</th>
                    <th>Đơn vị</th>
                                    <th>Mô tả</th>
                                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                                <% if (medicines.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <i class="fas fa-pills text-muted" style="font-size: 48px;"></i>
                                        <p class="text-muted mt-3">Chưa có thuốc nào trong kho</p>
                                    </td>
                                </tr>
                                <% } else { for (Medicine med : medicines) { %>
                                <tr>
                                    <td><span class="badge bg-primary">#<%= med.getMedicineId() %></span></td>
                                    <td><strong><%= med.getName() %></strong></td>
                                    <td>
                                        <span class="badge <%= med.getQuantityInStock() < 10 ? "bg-danger" : med.getQuantityInStock() < 50 ? "bg-warning" : "bg-success" %>">
                                            <%= med.getQuantityInStock() %>
                                        </span>
                                        <% if (med.getQuantityInStock() < 10) { %>
                                        <i class="fas fa-exclamation-triangle text-danger ms-1" title="Sắp hết hàng"></i>
                                        <% } %>
                                    </td>
                    <td><%= med.getUnit() %></td>
                                    <td><small class="text-muted"><%= med.getDescription() != null ? med.getDescription() : "N/A" %></small></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary me-1" title="Chỉnh sửa">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-success" title="Nhập thêm">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </td>
                </tr>
                                <% } } %>
            </tbody>
        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Add Medicine Modal -->
    <div class="modal fade" id="addMedicineModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Thêm thuốc mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/AddMedicineServlet" method="POST">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Tên thuốc <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" name="quantity" min="0" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Đơn vị <span class="text-danger">*</span></label>
                                <select class="form-select" name="unit" required>
                                    <option value="Viên">Viên</option>
                                    <option value="Hộp">Hộp</option>
                                    <option value="Chai">Chai</option>
                                    <option value="Tuýp">Tuýp</option>
                                    <option value="Gói">Gói</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" name="description" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm thuốc</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function filterTable() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toLowerCase();
            var table = document.getElementById("medicineTable");
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
