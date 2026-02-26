<%-- 1 thẻ bác sĩ + modal đặt lịch (dùng trong c:forEach, cần biến ${doctor}) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="col-md-6 mb-4">
    <div class="doctor-card">
        <h5 class="mb-1">${doctor.full_name}</h5>
        <p class="mb-1"><i class="fas fa-stethoscope me-1 text-primary"></i>${doctor.specialty}</p>
        <p class="mb-1 text-muted">SĐT: <strong>${doctor.phone}</strong></p>
        <p class="mb-2">
            <span>Trạng thái: </span>
            <c:choose>
                <c:when test="${doctor.status == 'Active'}">
                    <span class="badge bg-success"><i class="fas fa-circle fa-xs me-1"></i>Đang trực</span>
                </c:when>
                <c:otherwise>
                    <span class="badge bg-secondary"><i class="fas fa-circle fa-xs me-1"></i>Ngoại tuyến</span>
                </c:otherwise>
            </c:choose>
        </p>
        <button class="btn btn-primary btn-sm btn-booking-modal" type="button"
                data-bs-toggle="modal" data-bs-target="#bookingModal${doctor.doctor_id}"
                data-doctor-id="${doctor.doctor_id}"
                onclick="event.preventDefault(); event.stopPropagation();">
            <i class="fas fa-calendar-plus me-1"></i>Đặt lịch
        </button>
        <div class="mt-2">
            <small class="text-muted">
                <i class="fas fa-calendar-alt me-1"></i>
                Có ${fn:length(doctor.workDates)} ngày làm việc trong 14 ngày tới
            </small>
        </div>

        <script>
            window['workDates_${doctor.doctor_id}'] = [
                <c:forEach items="${doctor.workDates}" var="d" varStatus="loop">
                    "${d}"<c:if test="${!loop.last}">,</c:if>
                </c:forEach>
            ];
        </script>

        <!-- Modal đặt lịch -->
        <div class="modal fade" id="bookingModal${doctor.doctor_id}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Đặt lịch với ${doctor.full_name}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <ul class="nav nav-tabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#self-${doctor.doctor_id}" type="button" role="tab"><i class="fas fa-user me-1"></i>Đặt cho mình</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#relative-${doctor.doctor_id}" type="button" role="tab"><i class="fas fa-users me-1"></i>Đặt cho người thân</button>
                            </li>
                        </ul>
                        <div class="tab-content mt-3">
                            <div class="tab-pane fade show active" id="self-${doctor.doctor_id}">
                                <form action="${pageContext.request.contextPath}/BookingPageServlet" method="post">
                                    <input type="hidden" name="doctorId" value="${doctor.doctor_id}">
                                    <input type="hidden" name="bookingFor" value="self">
                                    <c:if test="${not empty selectedService}">
                                        <input type="hidden" name="serviceId" value="${selectedService.serviceId}">
                                        <div class="alert alert-info mb-3"><i class="fas fa-info-circle me-2"></i><strong>Dịch vụ đã chọn:</strong> ${selectedService.serviceName} (${selectedService.category})</div>
                                    </c:if>
                                    <c:if test="${empty selectedService}">
                                        <div class="mb-3">
                                            <label class="form-label">Chọn dịch vụ</label>
                                            <div class="row">
                                                <c:forEach items="${services}" var="service">
                                                    <div class="col-md-6 mb-2">
                                                        <div class="service-item" onclick="selectService(this, '${service.serviceId}', '${fn:escapeXml(service.serviceName)}', '50000', 'self_${doctor.doctor_id}')">
                                                            <h6 class="mb-1 text-primary">${service.serviceName}</h6>
                                                            <p class="text-muted small mb-2">${service.description}</p>
                                                            <div class="d-flex justify-content-between align-items-center">
                                                                <span class="badge bg-info">${service.category}</span>
                                                                <strong class="text-success">50,000 VNĐ</strong>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            <input type="hidden" name="serviceId" id="selectedServiceId_self_${doctor.doctor_id}">
                                        </div>
                                    </c:if>
                                    <div class="mb-3"><label class="form-label">Ngày khám</label><input type="text" name="workDate" class="form-control" id="work_date_picker_self_${doctor.doctor_id}" required></div>
                                    <div class="mb-3 d-none" id="timeSlotsContainer_self_${doctor.doctor_id}"><label class="form-label">Ca khám</label><div class="time-slots" id="timeSlots_self_${doctor.doctor_id}"></div><input type="hidden" name="slotId" id="selectedSlotId_self_${doctor.doctor_id}"></div>
                                    <div class="mb-3"><label class="form-label">Lý do khám</label><textarea name="reason" class="form-control" rows="3" required></textarea></div>
                                    <div class="text-end"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button><button type="submit" class="btn btn-primary">Xác nhận</button></div>
                                </form>
                            </div>
                            <div class="tab-pane fade" id="relative-${doctor.doctor_id}">
                                <form action="${pageContext.request.contextPath}/BookingPageServlet" method="post">
                                    <input type="hidden" name="doctorId" value="${doctor.doctor_id}"><input type="hidden" name="bookingFor" value="relative">
                                    <c:if test="${not empty selectedService}"><input type="hidden" name="serviceId" value="${selectedService.serviceId}"></c:if>
                                    <div class="relative-info-card p-3 mb-3">
                                        <div class="row g-3">
                                            <div class="col-md-6"><label class="form-label">Họ tên người thân</label><input type="text" name="relativeName" class="form-control"></div>
                                            <div class="col-md-6"><label class="form-label">Số điện thoại</label><input type="tel" name="relativePhone" class="form-control"></div>
                                            <div class="col-md-4"><label class="form-label">Ngày sinh</label><input type="date" name="relativeDob" class="form-control"></div>
                                            <div class="col-md-4"><label class="form-label">Giới tính</label><select name="relativeGender" class="form-select"><option value="">Chọn</option><option value="Nam">Nam</option><option value="Nữ">Nữ</option><option value="Khác">Khác</option></select></div>
                                            <div class="col-md-4"><label class="form-label">Mối quan hệ</label><select name="relativeRelationship" class="form-select"><option value="">Chọn</option><option value="Cha">Cha</option><option value="Mẹ">Mẹ</option><option value="Con">Con</option><option value="Anh">Anh</option><option value="Chị">Chị</option><option value="Em">Em</option><option value="Vợ">Vợ</option><option value="Chồng">Chồng</option><option value="Khác">Khác</option></select></div>
                                        </div>
                                    </div>
                                    <c:if test="${not empty selectedService}"><div class="alert alert-info mb-3"><i class="fas fa-info-circle me-2"></i><strong>Dịch vụ đã chọn:</strong> ${selectedService.serviceName} (${selectedService.category})</div></c:if>
                                    <c:if test="${empty selectedService}">
                                        <div class="mb-3"><label class="form-label">Chọn dịch vụ</label><div class="row">
                                            <c:forEach items="${services}" var="service">
                                                <div class="col-md-6 mb-2"><div class="service-item" onclick="selectService(this, '${service.serviceId}', '${fn:escapeXml(service.serviceName)}', '50000', 'relative_${doctor.doctor_id}')"><h6 class="mb-1 text-primary">${service.serviceName}</h6><p class="text-muted small mb-2">${service.description}</p><div class="d-flex justify-content-between align-items-center"><span class="badge bg-info">${service.category}</span><strong class="text-success">50,000 VNĐ</strong></div></div></div>
                                            </c:forEach>
                                        </div><input type="hidden" name="serviceId" id="selectedServiceId_relative_${doctor.doctor_id}"></div>
                                    </c:if>
                                    <div class="mb-3"><label class="form-label">Ngày khám</label><input type="text" name="workDate" class="form-control" id="work_date_picker_relative_${doctor.doctor_id}" required></div>
                                    <div class="mb-3 d-none" id="timeSlotsContainer_relative_${doctor.doctor_id}"><label class="form-label">Ca khám</label><div class="time-slots" id="timeSlots_relative_${doctor.doctor_id}"></div><input type="hidden" name="slotId" id="selectedSlotId_relative_${doctor.doctor_id}"></div>
                                    <div class="mb-3"><label class="form-label">Lý do khám</label><textarea name="reason" class="form-control" rows="3" required></textarea></div>
                                    <div class="text-end"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button><button type="submit" class="btn btn-primary">Xác nhận</button></div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
