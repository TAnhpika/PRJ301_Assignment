<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Thông báo - Manager</title>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/manager/manager_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/manager/manager_header.jsp" %>
            
            <div class="dashboard-content d-flex align-items-center justify-content-center" style="min-height: 70vh;">
                <div class="dashboard-card text-center p-5" style="max-width: 500px;">
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="mb-4">
                            <i class="fas fa-times-circle text-danger" style="font-size: 64px;"></i>
                        </div>
                        <h3 class="mb-3">Thất bại</h3>
                        <p class="text-muted mb-4"><%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "Đã xảy ra lỗi không xác định." %></p>
                        <button onclick="history.back()" class="btn-dashboard btn-dashboard-primary w-100">Quay lại</button>
                    <% } else { %>
                        <div class="mb-4">
                            <i class="fas fa-check-circle text-success" style="font-size: 64px;"></i>
                        </div>
                        <h3 class="mb-3">Thành công</h3>
                        <p class="text-muted mb-4"><%= request.getAttribute("successMessage") != null ? request.getAttribute("successMessage") : "Thao tác đã được thực hiện thành công." %></p>
                        <a href="<%= request.getContextPath() %>/jsp/manager/manager_danhsach.jsp" class="btn-dashboard btn-dashboard-primary w-100">Về danh sách</a>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
</body>
</html>
