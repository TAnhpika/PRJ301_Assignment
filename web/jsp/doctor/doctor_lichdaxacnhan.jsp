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
    <%@ include file="/includes/dashboard_head.jsp" %>
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
        <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
        <main class="dashboard-main">
            <%@ include file="/jsp/doctor/doctor_header.jsp" %>
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
                    <div class="confirmed-table-wrap">
                        <c:set var="lastDate" value="" />
                        <c:forEach items="${approvedSchedules}" var="schedule">
                            <c:set var="currDate" value="" />
                            <c:if test="${schedule.workDate != null}">
                                <fmt:formatDate value="${schedule.workDate}" pattern="dd/MM/yyyy" var="currDate" />
                            </c:if>
                            <c:if test="${currDate != lastDate}">
                                <c:if test="${not empty lastDate}"></tbody></table></div></c:if>
                                <c:set var="lastDate" value="${currDate}" />
                                <div class="date-group mb-3">
                                    <div class="date-group-header bg-light px-3 py-2 rounded-top border">
                                        <i class="fas fa-calendar-day me-2 text-success"></i><strong>${currDate}</strong>
                                    </div>
                                    <table class="dashboard-table table table-hover mb-0 rounded-bottom overflow-hidden">
                                        <thead class="table-light"><tr><th>Ca làm việc</th><th>Trạng thái</th></tr></thead>
                                        <tbody>
                            </c:if>
                                        <tr>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${schedule.slotId == 1}">
                                                        <span class="badge bg-info">Sáng (8h-12h)</span>
                                                    </c:when>
                                                    <c:when test="${schedule.slotId == 2}">
                                                        <span class="badge bg-warning text-dark">Chiều (13h-17h)</span>
                                                    </c:when>
                                                    <c:when test="${schedule.slotId == 3}">
                                                        <span class="badge bg-primary">Cả ngày (8h-17h)</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Khác</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><span class="badge bg-success">Đã xác nhận</span></td>
                                        </tr>
                        </c:forEach>
                        <c:if test="${not empty lastDate}"></tbody></table></div></c:if>
                        <c:if test="${empty approvedSchedules}">
                            <div class="text-center text-muted py-5">
                                <i class="fas fa-calendar-check" style="font-size: 28px;"></i>
                                <p class="mt-2 mb-0">Chưa có lịch được xác nhận</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <%@ include file="/includes/dashboard_scripts.jsp" %>
</body>
</html>
