<%-- Đặt lịch khám bệnh cho bệnh nhân/ người thân --%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>Đặt lịch khám bệnh</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        .doctor-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid #e5e7eb;
            transition: box-shadow 0.2s ease, transform 0.1s ease;
        }
        .doctor-card:hover {
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.08);
            transform: translateY(-2px);
        }
        .time-slots {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 10px;
        }
        .time-slot {
            padding: 8px 10px;
            text-align: center;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            cursor: pointer;
            background: #ffffff;
            font-size: 13px;
            transition: all 0.2s;
        }
        .time-slot:hover {
            background: #f1f5f9;
            border-color: #4361ee;
        }
        .time-slot.selected {
            background: #4361ee;
            color: #ffffff;
            border-color: #4361ee;
        }
        .time-slot.booked {
            background: #9ca3af;
            color: #ffffff;
            border-color: #6b7280;
            cursor: not-allowed;
            opacity: 0.9;
        }
        .time-slot.past {
            background: #e5e7eb;
            color: #4b5563;
            border-color: #d1d5db;
            cursor: not-allowed;
        }
        .service-item {
            border: 1px solid #e5e7eb;
            background: #f9fafb;
            padding: 12px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
            height: 100%;
        }
        .service-item:hover,
        .service-item.selected {
            border-color: #4361ee;
            background: #eff6ff;
        }
        .relative-info-card {
            border: 1px solid #e3f2fd;
            background: #f8fafc;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/patient/user_menu.jsp" %>
        <main class="dashboard-main">
            <%@ include file="/jsp/patient/user_header.jsp" %>

            <div class="dashboard-content">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-calendar-plus me-2"></i>Đặt lịch khám bệnh</h4>
                        <p class="text-muted mb-0">Chọn bác sĩ và thời gian khám phù hợp</p>
                    </div>
                </div>

                <%-- Breadcrumb + Hướng dẫn + Cảnh báo (tránh include vì thư mục booking/ có thể không được copy khi deploy) --%>
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
                <c:if test="${not empty error}"><div class="alert alert-danger mb-4">${error}</div></c:if>
                <c:if test="${noDoctorsForSpecialty == true}">
                    <div class="alert alert-warning mb-4">
                        <i class="fas fa-user-md me-2"></i>
                        Chưa có bác sĩ nào phục vụ chuyên khoa <strong>${specialtyNameForMessage}</strong> trong thời gian tới.
                        Vui lòng <a href="${pageContext.request.contextPath}/services">chọn dịch vụ khác</a> hoặc liên hệ phòng khám.
                    </div>
                </c:if>

                <%-- Dịch vụ đã chọn --%>
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

                <%-- Form tìm kiếm bác sĩ --%>
                <div class="dashboard-card mb-4">
                    <form method="GET" action="${pageContext.request.contextPath}/BookingPageServlet">
                        <c:if test="${not empty selectedService}"><input type="hidden" name="serviceId" value="${selectedService.serviceId}"/></c:if>
                        <div class="row g-3 align-items-end">
                            <div class="col-md-6">
                                <label class="form-label">Từ khóa</label>
                                <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm bác sĩ..." value="${param.keyword}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Chuyên khoa</label>
                                <select name="specialty" class="form-select" ${not empty selectedService ? 'disabled' : ''}>
                                    <option value="">Tất cả chuyên khoa</option>
                                    <c:forEach items="${specialties}" var="spec">
                                        <option value="${spec}" ${(not empty selectedService and selectedSpecialtyName == spec) or (empty selectedService and param.specialty == spec) ? 'selected' : ''}>${spec}</option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty selectedService}"><input type="hidden" name="specialty" value="${selectedService.category}"/></c:if>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn-dashboard btn-dashboard-primary w-100"><i class="fas fa-search me-1"></i>Tìm</button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Danh sách bác sĩ (nút Đặt lịch mở 1 modal chung bằng JS, tránh reload) -->
                <div class="row">
                    <c:forEach items="${doctors}" var="doctor">
                        <div class="col-md-6 mb-4">
                            <div class="doctor-card">
                                <h5 class="mb-1">${doctor.full_name}</h5>
                                <p class="mb-1"><i class="fas fa-stethoscope me-1 text-primary"></i>${doctor.specialty}</p>
                                <p class="mb-1 text-muted">SĐT: <strong>${doctor.phone}</strong></p>
                                <p class="mb-2">
                                    <span>Trạng thái: </span>
                                    <c:choose>
                                        <c:when test="${doctor.status == 'Active'}"><span class="badge bg-success"><i class="fas fa-circle fa-xs me-1"></i>Đang trực</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary"><i class="fas fa-circle fa-xs me-1"></i>Ngoại tuyến</span></c:otherwise>
                                    </c:choose>
                                </p>
                                <button type="button" class="btn btn-primary btn-sm open-booking-modal"
                                        data-doctor-id="${doctor.doctor_id}"
                                        data-doctor-name="${fn:escapeXml(doctor.full_name)}">
                                    <i class="fas fa-calendar-plus me-1"></i>Đặt lịch
                                </button>
                                <div class="mt-2">
                                    <small class="text-muted"><i class="fas fa-calendar-alt me-1"></i>Có ${fn:length(doctor.workDates)} ngày làm việc trong 14 ngày tới</small>
                                </div>
                                <script>window['workDates_${doctor.doctor_id}']=[<c:forEach items="${doctor.workDates}" var="d" varStatus="loop">"${d}"<c:if test="${!loop.last}">,</c:if></c:forEach>];</script>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Modal đặt lịch chung (1 modal cho mọi bác sĩ, mở bằng JS) -->
                <div class="modal fade" id="bookingModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="bookingModalTitle">Đặt lịch</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                            </div>
                            <div class="modal-body">
                                <ul class="nav nav-tabs" role="tablist">
                                    <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabSelf" type="button" role="tab"><i class="fas fa-user me-1"></i>Đặt cho mình</button></li>
                                    <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabRelative" type="button" role="tab"><i class="fas fa-users me-1"></i>Đặt cho người thân</button></li>
                                </ul>
                                <div class="tab-content mt-3">
                                    <div class="tab-pane fade show active" id="tabSelf">
                                        <form action="${pageContext.request.contextPath}/BookingPageServlet" method="post" class="booking-form">
                                            <input type="hidden" name="doctorId" id="modal_doctor_id" value="">
                                            <input type="hidden" name="bookingFor" value="self">
                                            <c:if test="${not empty selectedService}">
                                                <input type="hidden" name="serviceId" value="${selectedService.serviceId}">
                                                <div class="alert alert-info mb-3"><i class="fas fa-info-circle me-2"></i><strong>Dịch vụ đã chọn:</strong> ${selectedService.serviceName} (${selectedService.category})</div>
                                            </c:if>
                                            <c:if test="${empty selectedService}">
                                                <div class="mb-3">
                                                    <label class="form-label">Chọn dịch vụ</label>
                                                    <div class="row" id="modalServicesSelf"></div>
                                                    <input type="hidden" name="serviceId" id="selectedServiceId_self_modal">
                                                </div>
                                            </c:if>
                                            <div class="mb-3"><label class="form-label">Ngày khám</label><input type="text" name="workDate" class="form-control" id="work_date_picker_self_modal" required></div>
                                            <div class="mb-3 d-none" id="timeSlotsContainer_self_modal"><label class="form-label">Ca khám</label><div class="time-slots" id="timeSlots_self_modal"></div><input type="hidden" name="slotId" id="selectedSlotId_self_modal"></div>
                                            <div class="mb-3"><label class="form-label">Lý do khám</label><textarea name="reason" class="form-control" rows="3" required></textarea></div>
                                            <div class="text-end"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button><button type="submit" class="btn btn-primary">Xác nhận</button></div>
                                        </form>
                                    </div>
                                    <div class="tab-pane fade" id="tabRelative">
                                        <form action="${pageContext.request.contextPath}/BookingPageServlet" method="post" class="booking-form">
                                            <input type="hidden" name="doctorId" id="modal_doctor_id_rel" value="">
                                            <input type="hidden" name="bookingFor" value="relative">
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
                                                <div class="mb-3"><label class="form-label">Chọn dịch vụ</label><div class="row" id="modalServicesRelative"></div><input type="hidden" name="serviceId" id="selectedServiceId_relative_modal"></div>
                                            </c:if>
                                            <div class="mb-3"><label class="form-label">Ngày khám</label><input type="text" name="workDate" class="form-control" id="work_date_picker_relative_modal" required></div>
                                            <div class="mb-3 d-none" id="timeSlotsContainer_relative_modal"><label class="form-label">Ca khám</label><div class="time-slots" id="timeSlots_relative_modal"></div><input type="hidden" name="slotId" id="selectedSlotId_relative_modal"></div>
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
        </main>
    </div>

    <%@ include file="/includes/dashboard_scripts.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="${pageContext.request.contextPath}/js/booking_calendar.js"></script>
    <script>
    window.BOOKING_CONTEXT_PATH = '<c:out value="${pageContext.request.contextPath}" escapeXml="false"/>';
    (function() {
        var servicesData = [];
        <c:if test="${empty selectedService and not empty services}">
        <c:forEach items="${services}" var="s">servicesData.push({id:'${s.serviceId}',name:'${fn:escapeXml(s.serviceName)}',desc:'${fn:escapeXml(s.description)}',cat:'${fn:escapeXml(s.category)}'});</c:forEach>
        </c:if>
        document.querySelectorAll('.open-booking-modal').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var id = btn.getAttribute('data-doctor-id');
                var name = btn.getAttribute('data-doctor-name') || '';
                document.getElementById('modal_doctor_id').value = id;
                document.getElementById('modal_doctor_id_rel').value = id;
                document.getElementById('bookingModalTitle').textContent = 'Đặt lịch với ' + name;
                var m = document.getElementById('bookingModal');
                var mod = bootstrap.Modal.getOrCreateInstance(m);
                mod.show();
            });
        });
        window.bookingServicesData = servicesData;
    })();
    </script>
</body>
</html>
