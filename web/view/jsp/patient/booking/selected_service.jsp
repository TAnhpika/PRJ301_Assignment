<%-- Khối dịch vụ đã chọn --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty selectedService}">
    <div class="dashboard-card mb-4" style="border: 2px solid #4361ee; background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h6 class="mb-2"><i class="fas fa-check-circle me-2 text-success"></i>Dịch vụ đã chọn</h6>
                <h5 class="mb-2 text-primary">${selectedService.serviceName}</h5>
                <small class="text-muted d-block mb-2">${selectedService.description}</small>
                <span class="badge bg-primary">${selectedService.category}</span>
                <p class="text-muted small mt-2 mb-0">
                    <i class="fas fa-info-circle me-1"></i>
                    Vui lòng chọn bác sĩ phục vụ chuyên khoa <strong>${selectedService.category}</strong> và thời gian khám phù hợp
                </p>
            </div>
            <div class="col-md-4 text-md-end mt-3 mt-md-0">
                <h4 class="text-success mb-0 fw-bold">50,000 VNĐ</h4>
                <small class="text-muted">Giá cố định</small>
            </div>
        </div>
    </div>
</c:if>
