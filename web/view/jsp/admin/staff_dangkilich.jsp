<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ page import="model.User" %>

                <% User user=(User) session.getAttribute("user"); if (user==null || !"STAFF".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp" ); return; } %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <%@ include file="/includes/dashboard_head.jsp" %>
                            <title>Đăng ký lịch làm việc - Staff</title>

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
                                                    <h4 class="mb-1"><i class="fas fa-calendar-plus me-2"></i>Đăng ký
                                                        Lịch làm việc</h4>
                                                    <p class="text-muted mb-0">Đăng ký ca làm việc hàng tháng</p>
                                                </div>
                                                <div class="d-flex align-items-center gap-2">
                                                    <button class="btn btn-outline-primary btn-sm"
                                                        onclick="changeMonth(-1)">
                                                        <i class="fas fa-chevron-left"></i>
                                                    </button>
                                                    <span class="badge bg-primary fs-6 px-3 py-2">
                                                        <i class="fas fa-calendar-alt me-1"></i>
                                                        Tháng ${currentMonth}/${currentYear}
                                                    </span>
                                                    <button class="btn btn-outline-primary btn-sm"
                                                        onclick="changeMonth(1)">
                                                        <i class="fas fa-chevron-right"></i>
                                                    </button>
                                                </div>
                                            </div>

                                            <!-- Alerts -->
                                            <c:if test="${not empty sessionScope.success}">
                                                <div class="alert alert-success alert-dismissible fade show"
                                                    role="alert">
                                                    <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="alert"></button>
                                                </div>
                                                <c:remove var="success" scope="session" />
                                            </c:if>
                                            <c:if test="${not empty sessionScope.error}">
                                                <div class="alert alert-danger alert-dismissible fade show"
                                                    role="alert">
                                                    <i
                                                        class="fas fa-exclamation-triangle me-2"></i>${sessionScope.error}
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="alert"></button>
                                                </div>
                                                <c:remove var="error" scope="session" />
                                            </c:if>

                                            <div class="row">
                                                <!-- Calendar -->
                                                <div class="col-lg-8 mb-4">
                                                    <div class="dashboard-card">
                                                        <h6 class="mb-3"><i class="fas fa-calendar me-2"></i>Lịch làm
                                                            việc tháng ${currentMonth}/${currentYear}</h6>

                                                        <!-- Calendar Grid -->
                                                        <div class="row g-0 text-center fw-bold mb-2"
                                                            style="background: linear-gradient(135deg, #4361ee 0%, #7c3aed 100%); color: white; border-radius: 8px;">
                                                            <div class="col py-2">CN</div>
                                                            <div class="col py-2">T2</div>
                                                            <div class="col py-2">T3</div>
                                                            <div class="col py-2">T4</div>
                                                            <div class="col py-2">T5</div>
                                                            <div class="col py-2">T6</div>
                                                            <div class="col py-2">T7</div>
                                                        </div>

                                                        <div class="row g-1">
                                                            <c:forEach begin="1" end="35" var="day">
                                                                <div class="col" style="min-height: 70px;">
                                                                    <c:if test="${day <= 31}">
                                                                        <div class="calendar-day rounded text-center">
                                                                            <div class="day-number">${day}</div>
                                                                            <c:forEach var="schedule"
                                                                                items="${scheduleRequests}">
                                                                                <fmt:formatDate
                                                                                    value="${schedule.workDate}"
                                                                                    pattern="d" var="scheduleDay" />
                                                                                <c:if test="${scheduleDay == day}">
                                                                                    <span
                                                                                        class="schedule-badge">${schedule.slotName
                                                                                        != null ? schedule.slotName :
                                                                                        'Nghỉ'}</span>
                                                                                </c:if>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Form đăng ký -->
                                                <div class="col-lg-4 mb-4">
                                                    <div class="dashboard-card">
                                                        <h6 class="mb-4"><i class="fas fa-plus-circle me-2"></i>Đăng ký
                                                            ca làm việc</h6>

                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/StaffScheduleServlet"
                                                            id="workForm">
                                                            <div class="mb-3">
                                                                <label class="form-label"><i
                                                                        class="fas fa-calendar-day me-1"></i>Ngày làm
                                                                    việc <span class="text-danger">*</span></label>
                                                                <input type="date" class="form-control" id="workDate"
                                                                    name="workDate" required>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label class="form-label"><i
                                                                        class="fas fa-clock me-1"></i>Chọn ca làm việc
                                                                    <span class="text-danger">*</span></label>
                                                                <input type="hidden" id="slotId" name="slotId" required>

                                                                <c:choose>
                                                                    <c:when test="${empty timeSlots}">
                                                                        <div class="alert alert-info">
                                                                            <i class="fas fa-info-circle me-2"></i>Không
                                                                            có ca làm việc nào
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:forEach var="timeSlot" items="${timeSlots}">
                                                                            <div class="time-slot-card"
                                                                                onclick="selectTimeSlot('${timeSlot.slotId}', this)">
                                                                                <div
                                                                                    class="d-flex justify-content-between align-items-center">
                                                                                    <div>
                                                                                        <strong>${timeSlot.slotName}</strong><br>
                                                                                        <small
                                                                                            class="text-muted">${timeSlot.displayTime}</small>
                                                                                    </div>
                                                                                    <i
                                                                                        class="fas fa-check-circle text-success d-none check-icon"></i>
                                                                                </div>
                                                                            </div>
                                                                        </c:forEach>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>

                                                            <button type="submit"
                                                                class="btn-dashboard btn-dashboard-primary w-100">
                                                                <i class="fas fa-paper-plane"></i> Đăng ký ca làm việc
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Lịch sử -->
                                            <div class="dashboard-card">
                                                <h6 class="mb-4"><i class="fas fa-history me-2"></i>Lịch sử đăng ký ca
                                                    làm việc</h6>

                                                <div class="table-responsive">
                                                    <table class="dashboard-table">
                                                        <thead>
                                                            <tr>
                                                                <th>Ngày làm việc</th>
                                                                <th>Ca làm việc</th>
                                                                <th>Loại yêu cầu</th>
                                                                <th>Trạng thái</th>
                                                                <th>Ngày tạo</th>
                                                                <th>Người duyệt</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:choose>
                                                                <c:when test="${not empty scheduleRequests}">
                                                                    <c:forEach var="request"
                                                                        items="${scheduleRequests}">
                                                                        <tr>
                                                                            <td><i
                                                                                    class="fas fa-calendar-day me-2 text-muted"></i>
                                                                                <fmt:formatDate
                                                                                    value="${request.workDate}"
                                                                                    pattern="dd/MM/yyyy" />
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${not empty request.slotName}">
                                                                                        <span
                                                                                            class="badge bg-info">${request.slotName}</span>
                                                                                    </c:when>
                                                                                    <c:otherwise><em
                                                                                            class="text-muted">Không có
                                                                                            ca</em></c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td><span
                                                                                    class="badge ${request.requestTypeCssClass}">${request.requestTypeDisplayName}</span>
                                                                            </td>
                                                                            <td><span
                                                                                    class="badge ${request.statusCssClass}">${request.statusDisplayName}</span>
                                                                            </td>
                                                                            <td>
                                                                                <fmt:formatDate
                                                                                    value="${request.createdAt}"
                                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${not empty request.approverName}">
                                                                                        ${request.approverName}</c:when>
                                                                                    <c:otherwise><em
                                                                                            class="text-muted">Chưa xử
                                                                                            lý</em></c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <tr>
                                                                        <td colspan="6" class="text-center py-5">
                                                                            <i class="fas fa-inbox text-muted"
                                                                                style="font-size: 48px;"></i>
                                                                            <p class="text-muted mt-3">Chưa có đăng ký
                                                                                ca làm việc nào</p>
                                                                        </td>
                                                                    </tr>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                </main>
                        </div>

                        <%@ include file="/includes/dashboard_scripts.jsp" %>

                            <script>
                                function selectTimeSlot(slotId, element) {
                                    document.querySelectorAll('.time-slot-card').forEach(card => {
                                        card.classList.remove('selected');
                                        card.querySelector('.check-icon').classList.add('d-none');
                                    });
                                    element.classList.add('selected');
                                    element.querySelector('.check-icon').classList.remove('d-none');
                                    document.getElementById('slotId').value = parseInt(slotId);
                                }

                                function changeMonth(direction) {
                                    const currentMonth = parseInt('${currentMonth}');
                                    const currentYear = parseInt('${currentYear}');
                                    let newMonth = currentMonth + direction;
                                    let newYear = currentYear;
                                    if (newMonth > 12) { newMonth = 1; newYear++; }
                                    else if (newMonth < 1) { newMonth = 12; newYear--; }
                                    window.location.href = '${pageContext.request.contextPath}/StaffScheduleServlet?month=' + newMonth + '&year=' + newYear;
                                }

                                document.addEventListener('DOMContentLoaded', function () {
                                    const today = new Date();
                                    const tomorrow = new Date(today);
                                    tomorrow.setDate(tomorrow.getDate() + 1);
                                    const dateInput = document.getElementById('workDate');
                                    if (dateInput) {
                                        dateInput.min = tomorrow.toISOString().split('T')[0];
                                    }
                                });

                                document.getElementById('workForm').addEventListener('submit', function (e) {
                                    const slotId = document.getElementById('slotId').value;
                                    if (!slotId) {
                                        e.preventDefault();
                                        alert('Vui lòng chọn ca làm việc!');
                                        return false;
                                    }
                                });
                            </script>
                    </body>

                    </html>