<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ManagerDAO" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="model.Manager" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    Manager manager = ManagerDAO.getManagerInfo(user.getId());
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Tổng quan - Manager Dashboard</title>
</head>
<body>
    <div class="dashboard-wrapper">
        <!-- Sidebar Menu -->
        <%@ include file="/jsp/manager/manager_menu.jsp" %>
        
        <!-- Main Content -->
        <main class="dashboard-main">
            <!-- Header -->
            <%@ include file="/jsp/manager/manager_header.jsp" %>
            
            <!-- Page Content -->
            <div class="dashboard-content">
                <!-- Page Title -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1">Tổng quan phòng khám</h4>
                        <p class="text-muted mb-0">Chào mừng trở lại, <%= manager != null ? manager.getName() : user.getUsername() %>!</p>
                    </div>
                    <div>
                        <span class="badge bg-light text-dark">
                            <i class="fas fa-calendar me-1"></i>
                            <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
                        </span>
                    </div>
                </div>
                
                <!-- Stats Cards Row -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-card-value">150</div>
                            <div class="stat-card-label">Tổng số bệnh nhân</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="stat-card-value">12</div>
                            <div class="stat-card-label">Bác sĩ</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-nurse"></i>
                            </div>
                            <div class="stat-card-value">25</div>
                            <div class="stat-card-label">Nhân viên</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-card-value">45</div>
                            <div class="stat-card-label">Lượt khám hôm nay</div>
                        </div>
                    </div>
                </div>
                
                <!-- Main Content Row -->
                <div class="row g-4">
                    <!-- Recent Activities -->
                    <div class="col-12 col-lg-8">
                        <div class="dashboard-card">
                            <div class="dashboard-card-header">
                                <h5 class="dashboard-card-title">
                                    <i class="fas fa-clock text-primary me-2"></i>
                                    Hoạt động gần đây
                                </h5>
                            </div>
                            <div class="table-responsive">
                                <table class="dashboard-table">
                                    <thead>
                                        <tr>
                                            <th>Thời gian</th>
                                            <th>Hoạt động</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><small class="text-muted">10:30 AM</small></td>
                                            <td>Bác sĩ Nguyễn Văn A đã cập nhật hồ sơ bệnh nhân</td>
                                            <td><span class="badge-dashboard badge-success">Hoàn thành</span></td>
                                        </tr>
                                        <tr>
                                            <td><small class="text-muted">09:45 AM</small></td>
                                            <td>Nhân viên mới đã được thêm vào hệ thống</td>
                                            <td><span class="badge-dashboard badge-success">Hoàn thành</span></td>
                                        </tr>
                                        <tr>
                                            <td><small class="text-muted">09:00 AM</small></td>
                                            <td>Blog y khoa mới đang chờ kiểm duyệt</td>
                                            <td><span class="badge-dashboard badge-warning">Chờ duyệt</span></td>
                                        </tr>
                                        <tr>
                                            <td><small class="text-muted">08:30 AM</small></td>
                                            <td>Cập nhật kho thuốc thành công</td>
                                            <td><span class="badge-dashboard badge-success">Hoàn thành</span></td>
                                        </tr>
                                        <tr>
                                            <td><small class="text-muted">08:00 AM</small></td>
                                            <td>Hệ thống khởi động thành công</td>
                                            <td><span class="badge-dashboard badge-primary">Hệ thống</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Quick Actions -->
                    <div class="col-12 col-lg-4">
                        <div class="dashboard-card">
                            <div class="dashboard-card-header">
                                <h5 class="dashboard-card-title">
                                    <i class="fas fa-bolt text-warning me-2"></i>
                                    Thao tác nhanh
                                </h5>
                            </div>
                            <div class="d-grid gap-2">
                                <a href="${pageContext.request.contextPath}/jsp/manager/manager_danhsach.jsp" class="btn-dashboard btn-dashboard-primary w-100">
                                    <i class="fas fa-user-plus"></i>
                                    Thêm nhân viên mới
                                </a>
                                <a href="${pageContext.request.contextPath}/ScheduleApprovalServlet" class="btn-dashboard btn-dashboard-secondary w-100">
                                    <i class="fas fa-calendar-alt"></i>
                                    Phân công lịch làm việc
                                </a>
                                <a href="${pageContext.request.contextPath}/jsp/manager/manager_blogs.jsp" class="btn-dashboard btn-dashboard-secondary w-100">
                                    <i class="fas fa-check-circle"></i>
                                    Duyệt blog y khoa
                                </a>
                                <a href="${pageContext.request.contextPath}/jsp/manager/manager_thongke.jsp" class="btn-dashboard btn-dashboard-secondary w-100">
                                    <i class="fas fa-chart-bar"></i>
                                    Xem báo cáo thống kê
                                </a>
                            </div>
                        </div>
                        
                        <!-- Notifications Card -->
                        <div class="dashboard-card mt-4">
                            <div class="dashboard-card-header">
                                <h5 class="dashboard-card-title">
                                    <i class="fas fa-bell text-danger me-2"></i>
                                    Thông báo mới
                                </h5>
                            </div>
                            <div class="list-group list-group-flush">
                                <div class="list-group-item border-0 px-0">
                                    <div class="d-flex align-items-start">
                                        <div class="bg-primary rounded-circle p-2 me-3">
                                            <i class="fas fa-user text-white" style="font-size: 12px;"></i>
                                        </div>
                                        <div>
                                            <p class="mb-1 small">3 nhân viên yêu cầu đổi ca</p>
                                            <small class="text-muted">5 phút trước</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="list-group-item border-0 px-0">
                                    <div class="d-flex align-items-start">
                                        <div class="bg-success rounded-circle p-2 me-3">
                                            <i class="fas fa-pills text-white" style="font-size: 12px;"></i>
                                        </div>
                                        <div>
                                            <p class="mb-1 small">Thuốc sắp hết hạn cần kiểm tra</p>
                                            <small class="text-muted">1 giờ trước</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
</body>
</html>
