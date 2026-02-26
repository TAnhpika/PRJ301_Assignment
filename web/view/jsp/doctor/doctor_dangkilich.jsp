<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.User"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Đăng ký lịch làm việc - Doctor</title>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/doctor/doctor_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-calendar-alt me-2"></i>Đăng ký lịch nghỉ</h4>
                        <p class="text-muted mb-0">Đăng ký ngày nghỉ và xem lịch làm việc</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại
                    </a>
                </div>
                
                <div class="row g-4">
                    <!-- Register Form -->
                    <div class="col-lg-6">
                        <div class="dashboard-card">
                            <h6 class="mb-4"><i class="fas fa-calendar-times me-2 text-warning"></i>Đăng ký ngày nghỉ</h6>
                            
                            <form action="${pageContext.request.contextPath}/DoctorRegisterScheduleServlet" method="POST">
                                <div class="mb-3">
                                    <label class="form-label">Mã bác sĩ <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="doctor_id" required 
                                           value="${param.doctor_id != null ? param.doctor_id : ''}">
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Ngày nghỉ <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" name="work_date" required>
                                </div>
                                
                                <input type="hidden" name="request_type" value="leave">
                                
                                <button type="submit" class="btn-dashboard btn-dashboard-primary w-100">
                                    <i class="fas fa-paper-plane me-1"></i>Đăng ký nghỉ
                                </button>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Phân loại ngày nghỉ -->
                    <div class="col-lg-6">
                        <div class="dashboard-card">
                            <h6 class="mb-4"><i class="fas fa-filter me-2 text-info"></i>Phân loại ngày nghỉ</h6>

                            <%-- Tóm tắt theo trạng thái --%>
                            <div class="d-flex gap-3 mb-4 flex-wrap">
                                <div class="badge bg-warning text-dark px-3 py-2">
                                    <i class="fas fa-clock me-1"></i>Chờ duyệt: ${leavePending != null ? leavePending.size() : 0}
                                </div>
                                <div class="badge bg-success px-3 py-2">
                                    <i class="fas fa-check me-1"></i>Đã duyệt: ${leaveApproved != null ? leaveApproved.size() : 0}
                                </div>
                                <div class="badge bg-danger px-3 py-2">
                                    <i class="fas fa-times me-1"></i>Từ chối: ${leaveRejected != null ? leaveRejected.size() : 0}
                                </div>
                            </div>

                            <%-- Nhóm Chờ duyệt --%>
                            <h6 class="text-warning mt-3 mb-2"><i class="fas fa-clock me-1"></i>Chờ duyệt</h6>
                            <table class="dashboard-table table-sm mb-3">
                                <thead><tr><th>Ngày nghỉ</th><th>Trạng thái</th></tr></thead>
                                <tbody>
                                    <c:forEach items="${leavePending}" var="s">
                                        <tr>
                                            <td><fmt:formatDate value="${s.workDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><span class="badge bg-warning text-dark">Chờ duyệt</span></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty leavePending}">
                                        <tr><td colspan="2" class="text-muted small">Chưa có</td></tr>
                                    </c:if>
                                </tbody>
                            </table>

                            <%-- Nhóm Đã duyệt --%>
                            <h6 class="text-success mt-3 mb-2"><i class="fas fa-check me-1"></i>Đã duyệt</h6>
                            <table class="dashboard-table table-sm mb-3">
                                <thead><tr><th>Ngày nghỉ</th><th>Trạng thái</th></tr></thead>
                                <tbody>
                                    <c:forEach items="${leaveApproved}" var="s">
                                        <tr>
                                            <td><fmt:formatDate value="${s.workDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><span class="badge bg-success">Đã duyệt</span></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty leaveApproved}">
                                        <tr><td colspan="2" class="text-muted small">Chưa có</td></tr>
                                    </c:if>
                                </tbody>
                            </table>

                            <%-- Nhóm Từ chối --%>
                            <h6 class="text-danger mt-3 mb-2"><i class="fas fa-times me-1"></i>Từ chối</h6>
                            <table class="dashboard-table table-sm">
                                <thead><tr><th>Ngày nghỉ</th><th>Trạng thái</th></tr></thead>
                                <tbody>
                                    <c:forEach items="${leaveRejected}" var="s">
                                        <tr>
                                            <td><fmt:formatDate value="${s.workDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><span class="badge bg-danger">Từ chối</span></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty leaveRejected}">
                                        <tr><td colspan="2" class="text-muted small">Chưa có</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <%-- Nút mở màn hình Lịch đã xác nhận (riêng 1 trang, không cuộn) --%>
                <div class="mt-4 text-center">
                    <a href="${pageContext.request.contextPath}/DoctorRegisterScheduleServlet?page=confirmed" class="btn btn-success">
                        <i class="fas fa-check-circle me-2"></i>Xem lịch đã được xác nhận
                        <span class="badge bg-light text-success ms-2">${approvedSchedules != null ? approvedSchedules.size() : 0}</span>
                    </a>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
</body>
</html>
