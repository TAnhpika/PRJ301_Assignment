<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <title>Phê duyệt lịch làm việc - Manager</title>
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
                        <h4 class="mb-1"><i class="fas fa-calendar-check me-2"></i>Phê duyệt lịch làm việc</h4>
                        <p class="text-muted mb-0">Xét duyệt yêu cầu đăng ký lịch làm việc và nghỉ phép</p>
                    </div>
                </div>

                <!-- Alerts -->
                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-md-6">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="stat-card-value">${pendingDoctorSchedules.size()}</div>
                            <div class="stat-card-label">Lịch bác sĩ chờ duyệt</div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-card-value">${pendingStaffRequests.size()}</div>
                            <div class="stat-card-label">Yêu cầu nhân viên chờ duyệt</div>
                        </div>
                    </div>
                </div>
                
                <!-- Tabs -->
                <ul class="nav nav-tabs mb-4" id="approvalTabs" role="tablist">
                                <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="doctor-tab" data-bs-toggle="tab" data-bs-target="#doctor-panel" type="button" role="tab">
                            <i class="fas fa-user-md me-2"></i>Bác sĩ
                            <span class="badge bg-primary ms-2">${pendingDoctorSchedules.size()}</span>
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                        <button class="nav-link" id="staff-tab" data-bs-toggle="tab" data-bs-target="#staff-panel" type="button" role="tab">
                            <i class="fas fa-users me-2"></i>Nhân viên
                            <span class="badge bg-success ms-2">${pendingStaffRequests.size()}</span>
                                    </button>
                                </li>
                            </ul>

                            <div class="tab-content" id="approvalTabsContent">
                                <!-- Doctor Panel -->
                    <div class="tab-pane fade show active" id="doctor-panel" role="tabpanel">
                        <div class="dashboard-card">
                                    <c:choose>
                                        <c:when test="${empty pendingDoctorSchedules}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-calendar-check text-muted" style="font-size: 48px;"></i>
                                        <h5 class="text-muted mt-3">Không có lịch bác sĩ cần phê duyệt</h5>
                                        <p class="text-muted">Hiện tại không có yêu cầu đăng ký lịch làm việc nào của bác sĩ cần phê duyệt.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                        <table class="dashboard-table">
                                            <thead>
                                                <tr>
                                                    <th>Bác sĩ</th>
                                                    <th>Ngày làm việc</th>
                                                    <th>Trạng thái</th>
                                                    <th class="text-center">Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                <c:forEach items="${pendingDoctorSchedules}" var="schedule">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <img src="${pageContext.request.contextPath}/img/default-avatar.png" class="rounded-circle me-2" style="width: 36px; height: 36px;">
                                                                <span>BS ID: ${schedule.doctorId}</span>
                                                                    </div>
                                                                </td>
                                                        <td>
                                                                    <span class="text-primary fw-medium">
                                                                <fmt:formatDate pattern="dd/MM/yyyy" value="${schedule.workDate}" />
                                                                    </span>
                                                                </td>
                                                        <td><span class="badge bg-warning"><i class="fas fa-clock me-1"></i>Chờ duyệt</span></td>
                                                        <td class="text-center">
                                                            <form action="${pageContext.request.contextPath}/ManagerApprovalStaffScheduleServlet" method="POST" class="d-inline">
                                                                <input type="hidden" name="request_type" value="doctor">
                                                                <input type="hidden" name="schedule_id" value="${schedule.scheduleId}">
                                                                <button type="submit" name="action" value="approve" class="btn btn-sm btn-success me-1" onclick="return confirm('Bạn có chắc muốn phê duyệt lịch này?')">
                                                                    <i class="fas fa-check me-1"></i>Duyệt
                                                                        </button>
                                                                <button type="submit" name="action" value="reject" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn từ chối lịch này?')">
                                                                    <i class="fas fa-times me-1"></i>Từ chối
                                                                        </button>
                                                                    </form>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                        </div>
                                </div>

                                <!-- Staff Panel -->
                    <div class="tab-pane fade" id="staff-panel" role="tabpanel">
                        <div class="dashboard-card">
                                    <c:choose>
                                        <c:when test="${empty pendingStaffRequests}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-users text-muted" style="font-size: 48px;"></i>
                                        <h5 class="text-muted mt-3">Không có yêu cầu nhân viên cần phê duyệt</h5>
                                        <p class="text-muted">Hiện tại không có yêu cầu đăng ký ca làm việc hoặc nghỉ phép nào của nhân viên cần phê duyệt.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                        <table class="dashboard-table">
                                            <thead>
                                                <tr>
                                                    <th>Nhân viên</th>
                                                    <th>Ngày</th>
                                                    <th>Loại yêu cầu</th>
                                                    <th>Trạng thái</th>
                                                    <th class="text-center">Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                <c:forEach items="${pendingStaffRequests}" var="request">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <img src="${pageContext.request.contextPath}/img/default-avatar.png" class="rounded-circle me-2" style="width: 36px; height: 36px;">
                                                                <div>
                                                                    <strong>${request.staffName}</strong>
                                                                    <br>
                                                                    <span class="badge-dashboard ${request.employmentType == 'fulltime' ? 'badge-primary' : 'badge-warning'}" style="font-size: 10px;">
                                                                        ${request.employmentType == 'fulltime' ? 'Full-time' : 'Part-time'}
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="text-primary fw-medium">
                                                                <fmt:formatDate pattern="dd/MM/yyyy" value="${request.workDate}" />
                                                                    </span>
                                                                </td>
                                                        <td>
                                                                    <c:choose>
                                                                <c:when test="${request.employmentType eq 'fulltime' && empty request.slotId}">
                                                                    <span class="badge bg-warning"><i class="fas fa-calendar-times me-1"></i>Nghỉ phép cả ngày</span>
                                                                        </c:when>
                                                                <c:when test="${request.employmentType eq 'parttime' && not empty request.slotId}">
                                                                    <span class="badge bg-info">
                                                                        <i class="fas fa-briefcase me-1"></i>Đăng ký ca ${request.slotId}
                                                                        <c:if test="${not empty request.slotTime}">
                                                                            <br><small>${request.slotTime}</small>
                                                                                </c:if>
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                    <span class="badge bg-secondary">Không xác định</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                        <td><span class="badge bg-warning"><i class="fas fa-clock me-1"></i>Chờ duyệt</span></td>
                                                        <td class="text-center">
                                                            <form action="${pageContext.request.contextPath}/ManagerApprovalStaffScheduleServlet" method="POST" class="d-inline">
                                                                <input type="hidden" name="request_type" value="staff">
                                                                <input type="hidden" name="schedule_id" value="${request.scheduleId}">
                                                                <button type="submit" name="action" value="approve" class="btn btn-sm btn-success me-1" onclick="return confirm('Bạn có chắc muốn phê duyệt yêu cầu này?')">
                                                                    <i class="fas fa-check me-1"></i>Duyệt
                                                                        </button>
                                                                <button type="submit" name="action" value="reject" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn từ chối yêu cầu này?')">
                                                                    <i class="fas fa-times me-1"></i>Từ chối
                                                                        </button>
                                                                    </form>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
        </main>
                </div>

    <%@ include file="/includes/dashboard_scripts.jsp" %>

                <script>
        document.addEventListener('DOMContentLoaded', function() {
                        const doctorCount = parseInt('${pendingDoctorSchedules.size()}') || 0;
                        const staffCount = parseInt('${pendingStaffRequests.size()}') || 0;

            // Auto-switch to staff tab if no doctor schedules but has staff requests
                        if (doctorCount === 0 && staffCount > 0) {
                            const staffTab = new bootstrap.Tab(document.getElementById('staff-tab'));
                            staffTab.show();
                        }
                    });
                </script>
            </body>
            </html>
