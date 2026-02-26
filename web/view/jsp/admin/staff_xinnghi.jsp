<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.User" %>

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
    <title>Đăng ký nghỉ phép - Staff</title>
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
                        <h4 class="mb-1"><i class="fas fa-calendar-times me-2"></i>Đăng ký Nghỉ phép</h4>
                        <p class="text-muted mb-0">Đăng ký ngày nghỉ phép hàng tháng</p>
                    </div>
                    <span class="badge bg-info fs-6">
                        <i class="fas fa-calendar-alt me-1"></i>
                        Tháng ${currentMonth}/${currentYear}
                    </span>
                </div>
                
                <!-- Alerts -->
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                            <div class="stat-card-icon" style="color: white;">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-card-value" style="color: white;">${usedDays} / ${maxDays}</div>
                            <div class="stat-card-label" style="color: rgba(255,255,255,0.8);">Ngày nghỉ đã dùng</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-hourglass-half"></i>
                            </div>
                            <div class="stat-card-value">${remainingDays}</div>
                            <div class="stat-card-label">Ngày còn lại</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-briefcase"></i>
                            </div>
                            <div class="stat-card-value">
                                <c:choose>
                                    <c:when test="${employmentType eq 'fulltime'}">Full</c:when>
                                    <c:otherwise>Part</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stat-card-label">Loại hợp đồng</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-card-value">${pendingRequests != null ? pendingRequests : '0'}</div>
                            <div class="stat-card-label">Đang chờ duyệt</div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <!-- Form đăng ký -->
                    <div class="col-lg-5 mb-4">
                        <div class="dashboard-card h-100">
                            <h6 class="mb-4"><i class="fas fa-plus-circle me-2"></i>Đăng ký nghỉ phép mới</h6>
                            
                            <c:choose>
                                <c:when test="${remainingDays > 0}">
                                    <form method="post" action="${pageContext.request.contextPath}/StaffScheduleServlet">
                                        <div class="mb-4">
                                            <label class="form-label"><i class="fas fa-calendar-day me-1"></i>Ngày nghỉ phép <span class="text-danger">*</span></label>
                                            <input type="date" class="form-control" id="workDate" name="workDate" required>
                                            <small class="text-muted">Chọn ngày bạn muốn nghỉ phép</small>
                                        </div>
                                        
                                        <div class="mb-4">
                                            <label class="form-label"><i class="fas fa-comment me-1"></i>Lý do (tùy chọn)</label>
                                            <textarea class="form-control" name="reason" rows="3" placeholder="Nhập lý do nghỉ phép..."></textarea>
                                        </div>
                                        
                                        <button type="submit" class="btn-dashboard btn-dashboard-primary w-100">
                                            <i class="fas fa-paper-plane"></i> Gửi yêu cầu nghỉ phép
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        Bạn đã sử dụng hết <strong>${maxDays} ngày</strong> nghỉ phép trong tháng này.
                                        <br>Vui lòng chờ tháng sau để đăng ký nghỉ phép.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Lịch sử -->
                    <div class="col-lg-7 mb-4">
                        <div class="dashboard-card h-100">
                            <h6 class="mb-4"><i class="fas fa-history me-2"></i>Lịch sử yêu cầu nghỉ phép</h6>
                            
                            <div class="table-responsive">
                                <table class="dashboard-table">
                                    <thead>
                                        <tr>
                                            <th>Ngày nghỉ</th>
                                            <th>Loại</th>
                                            <th>Trạng thái</th>
                                            <th>Người duyệt</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty scheduleRequests}">
                                                <c:forEach var="request" items="${scheduleRequests}">
                                                    <tr>
                                                        <td>
                                                            <i class="fas fa-calendar-day me-2 text-muted"></i>
                                                            <fmt:formatDate value="${request.workDate}" pattern="dd/MM/yyyy"/>
                                                        </td>
                                                        <td>
                                                            <span class="badge ${request.requestTypeCssClass}">
                                                                ${request.requestTypeDisplayName}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="badge ${request.statusCssClass}">
                                                                ${request.statusDisplayName}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty request.approverName}">
                                                                    ${request.approverName}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <em class="text-muted">Chưa xử lý</em>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="4" class="text-center py-5">
                                                        <i class="fas fa-inbox text-muted" style="font-size: 48px;"></i>
                                                        <p class="text-muted mt-3">Chưa có yêu cầu nghỉ phép nào</p>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date();
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            
            const dateInput = document.getElementById('workDate');
            if (dateInput) {
                dateInput.min = tomorrow.toISOString().split('T')[0];
            }
        });
    </script>
</body>
</html>
