<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Quản lý khách hàng - Manager</title>
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
                        <h4 class="mb-1"><i class="fas fa-users me-2"></i>Quản lý danh sách khách hàng</h4>
                        <p class="text-muted mb-0">Xem thông tin tài khoản khách hàng đã đăng ký trong hệ thống</p>
                    </div>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-card-value">${totalCustomers != null ? totalCustomers : 0}</div>
                            <div class="stat-card-label">Tổng số khách hàng</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-check"></i>
                            </div>
                            <div class="stat-card-value">${activeCustomers != null ? activeCustomers : 0}</div>
                            <div class="stat-card-label">Khách hàng hoạt động</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="stat-card-value">${newCustomersThisMonth != null ? newCustomersThisMonth : 0}</div>
                            <div class="stat-card-label">Khách hàng mới tháng này</div>
                        </div>
                    </div>
                </div>
                
                <!-- Search Box -->
                <div class="dashboard-card mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm theo tên hoặc số điện thoại..." onkeyup="filterTable()">
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Customer Table -->
                <div class="dashboard-card">
                    <div class="table-responsive">
                        <table class="dashboard-table" id="customerTable">
                            <thead>
                                <tr>
                                    <th>Avatar</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Số điện thoại</th>
                                    <th>Ngày sinh</th>
                                    <th>Giới tính</th>
                                    <th>Ngày đăng ký</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty patientList}">
                                        <c:forEach var="patient" items="${patientList}">
                                            <tr>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty patient.avatar}">
                                                            <img src="${patient.avatar}" alt="Avatar" class="rounded-circle" style="width: 40px; height: 40px; object-fit: cover;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}/view/assets/img/default-avatar.png" alt="Avatar" class="rounded-circle" style="width: 40px; height: 40px; object-fit: cover;">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><strong>${patient.fullName}</strong></td>
                                                <td>${patient.email}</td>
                                                <td>${patient.phone}</td>
                                                <td>${patient.dateOfBirth}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${patient.gender == 'male'}">
                                                            <span class="badge-dashboard badge-primary">Nam</span>
                                                        </c:when>
                                                        <c:when test="${patient.gender == 'female'}">
                                                            <span class="badge-dashboard badge-danger">Nữ</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-dashboard badge-secondary">Khác</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${patient.createdAt}</td>
                                                <td><span class="badge bg-success">Hoạt động</span></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" class="text-center py-5">
                                                <i class="fas fa-users text-muted" style="font-size: 48px;"></i>
                                                <p class="text-muted mt-3">Chưa có khách hàng nào trong hệ thống</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav class="mt-4">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="ManagerCustomerListServlet?page=${currentPage - 1}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="ManagerCustomerListServlet?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="ManagerCustomerListServlet?page=${currentPage + 1}">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function filterTable() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toLowerCase();
            var table = document.getElementById("customerTable");
            var tr = table.getElementsByTagName("tr");

            for (var i = 1; i < tr.length; i++) {
                var td = tr[i].getElementsByTagName("td");
                var show = false;
                
                for (var j = 0; j < td.length; j++) {
                    var cell = td[j];
                    if (cell) {
                        var txtValue = cell.textContent || cell.innerText;
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
