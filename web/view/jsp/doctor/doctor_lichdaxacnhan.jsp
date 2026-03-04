<%-- 
    Lịch đã được xác nhận - 1 màn hình, không cuộn
--%>
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
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Lịch đã xác nhận - Doctor</title>
    <style>
        .confirmed-screen {
            display: flex;
            flex-direction: column;
            height: calc(100vh - 140px);
            max-height: calc(100vh - 140px);
            overflow: hidden;
        }
        .confirmed-header { flex-shrink: 0; margin-bottom: 16px; }
        .confirmed-table-wrap {
            flex: 1;
            min-height: 0;
            overflow: auto;
        }
        .dashboard-table { font-size: 13px; }
        .dashboard-table th, .dashboard-table td { padding: 8px 12px; }
        .date-group .date-group-header { border-bottom: none !important; }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/view/jsp/doctor/doctor_menu.jsp" %>
        <main class="dashboard-main">
            <%@ include file="/view/jsp/doctor/doctor_header.jsp" %>
            <div class="dashboard-content">
                <div class="confirmed-screen">
                    <div class="confirmed-header d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-1"><i class="fas fa-check-circle me-2 text-success"></i>Lịch đã được xác nhận</h4>
                            <p class="text-muted mb-0 small">Danh sách ca làm việc đã được quản lý xác nhận</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/DoctorRegisterScheduleServlet" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại đăng ký
                        </a>
                    </div>
                    <div class="confirmed-table-wrap dashboard-card p-0">
                        <table class="dashboard-table table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 25%">Ngày làm việc</th>
                                    <th style="width: 50%">Ca làm việc</th>
                                    <th style="width: 25%">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="lastDate" value="" />
                                <c:forEach items="${approvedSchedules}" var="schedule" varStatus="loop">
                                    <c:set var="currDate" value="" />
                                    <c:if test="${schedule.workDate != null}">
                                        <fmt:formatDate value="${schedule.workDate}" pattern="dd/MM/yyyy" var="currDate" />
                                    </c:if>
                                    
                                    <c:if test="${currDate != lastDate}">
                                        <c:if test="${not empty lastDate}">
                                                </td>
                                                <td><span class="badge bg-success">Đã xác nhận</span></td>
                                            </tr>
                                        </c:if>
                                        
                                        <tr>
                                            <td>
                                                <i class="fas fa-calendar-day text-success me-2"></i>
                                                <strong>${currDate}</strong>
                                            </td>
                                            <td>
                                        <c:set var="lastDate" value="${currDate}" />
                                    </c:if>
                                    
                                    <c:choose>
                                        <c:when test="${schedule.slotId == 1}">
                                            <span class="badge bg-info me-1 mb-1">Sáng (8h-12h)</span>
                                        </c:when>
                                        <c:when test="${schedule.slotId == 2}">
                                            <span class="badge bg-warning text-dark me-1 mb-1">Chiều (13h-17h)</span>
                                        </c:when>
                                        <c:when test="${schedule.slotId == 3}">
                                            <span class="badge bg-primary me-1 mb-1">Cả ngày (8h-17h)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger me-1 mb-1">Nghỉ phép</span>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <c:if test="${loop.last}">
                                            </td>
                                            <td><span class="badge bg-success">Đã xác nhận</span></td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                
                                <c:if test="${empty approvedSchedules}">
                                    <tr>
                                        <td colspan="3" class="text-center py-5 text-muted">
                                            <i class="fas fa-calendar-check d-block mb-3" style="font-size: 28px;"></i>
                                            Chưa có lịch được xác nhận
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
</body>
</html>
