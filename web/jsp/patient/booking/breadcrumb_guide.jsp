<%-- Breadcrumb + Hướng dẫn + Cảnh báo (error, noDoctors) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav aria-label="Luồng đặt lịch" class="mb-4">
    <ol class="breadcrumb mb-0 py-2 px-3 bg-light rounded" style="font-size: 0.9rem;">
        <li class="breadcrumb-item"><i class="fas fa-tooth me-1 text-success"></i>Dịch vụ</li>
        <li class="breadcrumb-item active" aria-current="page"><i class="fas fa-user-md me-1 text-primary"></i>Chọn bác sĩ</li>
        <li class="breadcrumb-item text-muted"><i class="fas fa-calendar-day me-1"></i>Chọn lịch</li>
        <li class="breadcrumb-item text-muted"><i class="fas fa-credit-card me-1"></i>Thanh toán</li>
    </ol>
</nav>

<div class="dashboard-card mb-4">
    <h6 class="mb-2"><i class="fas fa-info-circle me-2 text-primary"></i>Hướng dẫn</h6>
    <ul class="mb-0 text-muted">
        <li><strong>Đặt cho mình</strong>: chọn tab tương ứng trong popup.</li>
        <li><strong>Đặt cho người thân</strong>: nhập thêm thông tin người thân.</li>
        <li>Hệ thống chỉ hiển thị những ngày bác sĩ có lịch làm việc.</li>
        <c:if test="${empty selectedService}">
            <li class="mt-2"><a href="${pageContext.request.contextPath}/services"><i class="fas fa-tooth me-1"></i>Chọn dịch vụ trước</a> để được gợi ý bác sĩ đúng chuyên khoa.</li>
        </c:if>
    </ul>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger mb-4">${error}</div>
</c:if>

<c:if test="${noDoctorsForSpecialty == true}">
    <div class="alert alert-warning mb-4">
        <i class="fas fa-user-md me-2"></i>
        Chưa có bác sĩ nào phục vụ chuyên khoa <strong>${specialtyNameForMessage}</strong> trong thời gian tới.
        Vui lòng <a href="${pageContext.request.contextPath}/services">chọn dịch vụ khác</a> hoặc liên hệ phòng khám.
    </div>
</c:if>
