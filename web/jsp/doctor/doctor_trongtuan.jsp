<%-- 
    Document   : doctor_trongtuan
    Lịch làm việc bác sĩ - layout văn phòng 1 trang, phân theo ngày
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/includes/dashboard_head.jsp" %>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch làm việc - Doctor</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-common.css">
        <style>
            .page-header {
                background: #f8fafc;
                color: #1e293b;
                padding: 20px 24px;
                border-radius: 8px;
                margin-bottom: 16px;
                border: 1px solid #e2e8f0;
            }
            .page-header h1 { margin: 0 0 4px 0; font-size: 20px; font-weight: 600; color: #334155; }
            .page-header p { margin: 0; font-size: 13px; color: #64748b; }

            .date-selector { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; flex-wrap: wrap; }
            .date-selector label { font-weight: 600; color: #334155; font-size: 13px; }
            .date-selector input[type="date"] { padding: 6px 10px; border: 1px solid #e2e8f0; border-radius: 6px; font-size: 13px; }
            .date-selector .btn-date { padding: 6px 14px; border: 1px solid #64748b; border-radius: 6px; background: #f8fafc; color: #334155; cursor: pointer; font-size: 12px; text-decoration: none; }
            .date-selector .btn-date:hover { background: #e2e8f0; color: #334155; }
            .date-selector .btn-date.today { background: #0d9488; color: white; border-color: #0d9488; }
            .date-selector .btn-date.today:hover { background: #0f766e; color: white; }
            .date-selector .btn-date.all { background: #64748b; color: white; border-color: #64748b; }
            .date-selector .btn-date.all:hover { background: #475569; color: white; }

            .date-group { margin-bottom: 20px; }
            .date-group-header {
                background: #f1f5f9;
                padding: 10px 16px;
                border-radius: 6px 6px 0 0;
                border: 1px solid #e2e8f0;
                border-bottom: none;
                font-weight: 600;
                font-size: 14px;
                color: #334155;
            }
            .date-group-header i { margin-right: 8px; color: #0d9488; }
            .date-group-body {
                border: 1px solid #e2e8f0;
                border-radius: 0 0 6px 6px;
                padding: 0;
                background: #fff;
            }
            .schedule-row {
                display: flex;
                align-items: center;
                padding: 10px 16px;
                border-bottom: 1px solid #f1f5f9;
                font-size: 13px;
            }
            .schedule-row:last-child { border-bottom: none; }
            .schedule-row:hover { background: #f8fafc; }
            .schedule-time { min-width: 100px; font-weight: 600; color: #0d9488; }
            .schedule-info { flex: 1; color: #475569; }
            .schedule-slot { font-size: 12px; color: #64748b; }
            .summary-bar {
                display: flex;
                gap: 16px;
                margin-bottom: 16px;
                padding: 12px 16px;
                background: #fff;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 13px;
            }
            .summary-bar strong { color: #334155; }
        </style>
    </head>
    <body>
        <div class="dashboard-wrapper">
            <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
            <main class="dashboard-main">
                <%@ include file="/jsp/doctor/doctor_header.jsp" %>
                <div class="dashboard-content">
                    <div class="container-fluid">
                        <div class="page-header">
                            <h1><i class="fas fa-calendar-alt me-2"></i>${pageTitle}</h1>
                            <p class="mb-0">Quản lý và xem lịch làm việc của bác sĩ</p>
                        </div>

                        <%-- Hôm nay cho link --%>
                        <jsp:useBean id="todayBean" class="java.util.Date"/>
                        <fmt:formatDate value="${todayBean}" pattern="yyyy-MM-dd" var="todayStr"/>
                        <!-- Chọn ngày: xem theo ngày hoặc tất cả -->
                        <form method="get" action="${pageContext.request.contextPath}/DoctorHaveAppointmentServlet" class="date-selector">
                            <label for="date">Chọn ngày:</label>
                            <input type="date" id="date" name="date" value="${selectedDate}" onchange="this.form.submit()">
                            <a href="${pageContext.request.contextPath}/DoctorHaveAppointmentServlet?date=${todayStr}" class="btn-date today">Hôm nay</a>
                            <a href="${pageContext.request.contextPath}/DoctorHaveAppointmentServlet" class="btn-date all">Xem tất cả</a>
                        </form>
                        <c:if test="${filterByDate and not empty selectedDateDisplay}">
                            <div class="summary-bar">
                                <span><strong>Ngày:</strong> ${selectedDateDisplay}</span>
                                <c:if test="${isToday}"><span class="badge bg-success">Hôm nay</span></c:if>
                            </div>
                        </c:if>

                        <!-- Phân theo ngày -->
                        <c:choose>
                            <c:when test="${filterByDate}">
                                <%-- Xem 1 ngày: danh sách phẳng --%>
                                <div class="date-group">
                                    <div class="date-group-header">
                                        <i class="fas fa-calendar-day"></i>
                                        <c:choose>
                                            <c:when test="${not empty selectedDateDisplay}">${selectedDateDisplay}</c:when>
                                            <c:otherwise>Chưa chọn ngày</c:otherwise>
                                        </c:choose>
                                        <span class="badge bg-secondary ms-2">${schedules != null ? schedules.size() : 0} lịch</span>
                                    </div>
                                    <div class="date-group-body">
                                        <c:forEach var="schedule" items="${schedules}">
                                            <div class="schedule-row">
                                                <span class="schedule-time">
                                                    <c:choose>
                                                        <c:when test="${schedule.timeSlot != null}">${schedule.timeSlot.startTime} - ${schedule.timeSlot.endTime}</c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <span class="schedule-info">
                                                    <c:choose>
                                                        <c:when test="${schedule.doctor != null}">${schedule.doctor.fullName} - ${schedule.doctor.specialty}</c:when>
                                                        <c:otherwise>Bác sĩ #${schedule.doctorId}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <span class="schedule-slot">Slot ${schedule.slotId}</span>
                                            </div>
                                        </c:forEach>
                                        <c:if test="${empty schedules}">
                                            <div class="schedule-row text-muted"><i class="fas fa-info-circle me-2"></i>Không có lịch trong ngày này</div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <%-- Xem tất cả: phân theo ngày --%>
                                <div class="summary-bar">
                                    <span><strong>Tổng:</strong> ${schedules != null ? schedules.size() : 0} lịch</span>
                                </div>
                                <c:set var="lastDate" value="" />
                                <c:forEach var="schedule" items="${schedules}">
                                    <c:set var="currDate" value="" />
                                    <c:if test="${schedule.workDate != null}">
                                        <fmt:formatDate value="${schedule.workDate}" pattern="dd/MM/yyyy" var="currDate" />
                                    </c:if>
                                    <c:if test="${currDate != lastDate}">
                                        <c:if test="${not empty lastDate}"></div></div></c:if>
                                        <c:set var="lastDate" value="${currDate}" />
                                        <div class="date-group">
                                            <div class="date-group-header">
                                                <i class="fas fa-calendar-day"></i>${currDate}
                                            </div>
                                            <div class="date-group-body">
                                    </c:if>
                                                <div class="schedule-row">
                                                    <span class="schedule-time">
                                                        <c:choose>
                                                            <c:when test="${schedule.timeSlot != null}">${schedule.timeSlot.startTime} - ${schedule.timeSlot.endTime}</c:when>
                                                            <c:otherwise>—</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <span class="schedule-info">
                                                        <c:choose>
                                                            <c:when test="${schedule.doctor != null}">${schedule.doctor.fullName} - ${schedule.doctor.specialty}</c:when>
                                                            <c:otherwise>Bác sĩ #${schedule.doctorId}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <span class="schedule-slot">Slot ${schedule.slotId}</span>
                                                </div>
                                </c:forEach>
                                <c:if test="${not empty lastDate}"></div></div></c:if>
                                <c:if test="${empty schedules}">
                                    <div class="date-group">
                                        <div class="date-group-body">
                                            <div class="schedule-row text-muted"><i class="fas fa-info-circle me-2"></i>Chưa có lịch làm việc</div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </div>

        <%@ include file="/includes/dashboard_scripts.jsp" %>
    </body>
</html>
