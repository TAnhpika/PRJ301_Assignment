// Booking Calendar – 1 modal chung, mở bằng JS (tránh reload)
document.addEventListener('DOMContentLoaded', function () {
    var modalEl = document.getElementById('bookingModal');
    if (!modalEl) return;

    var selfPicker, relativePicker;

    modalEl.addEventListener('shown.bs.modal', function () {
        var doctorId = document.getElementById('modal_doctor_id') && document.getElementById('modal_doctor_id').value;
        if (!doctorId) return;

        var workDates = window['workDates_' + doctorId] || [];

        // Destroy previous flatpickr
        [selfPicker, relativePicker].forEach(function (fp) { if (fp && fp.destroy) fp.destroy(); });

        var selfInput = document.getElementById('work_date_picker_self_modal');
        var relInput = document.getElementById('work_date_picker_relative_modal');
        if (selfInput) {
            selfInput.value = '';
            document.getElementById('timeSlotsContainer_self_modal').classList.add('d-none');
            document.getElementById('timeSlots_self_modal').innerHTML = '';
            document.getElementById('selectedSlotId_self_modal').value = '';
            selfPicker = flatpickr(selfInput, {
                dateFormat: 'Y-m-d',
                enable: workDates,
                minDate: 'today',
                locale: { firstDayOfWeek: 1 },
                onChange: function (_, dateStr) { updateSchedules(dateStr, doctorId, 'self', true); }
            });
        }
        if (relInput) {
            relInput.value = '';
            document.getElementById('timeSlotsContainer_relative_modal').classList.add('d-none');
            document.getElementById('timeSlots_relative_modal').innerHTML = '';
            document.getElementById('selectedSlotId_relative_modal').value = '';
            relativePicker = flatpickr(relInput, {
                dateFormat: 'Y-m-d',
                enable: workDates,
                minDate: 'today',
                locale: { firstDayOfWeek: 1 },
                onChange: function (_, dateStr) { updateSchedules(dateStr, doctorId, 'relative', true); }
            });
        }

        // Nếu chưa chọn dịch vụ: fill danh sách dịch vụ trong modal
        var services = window.bookingServicesData || [];
        if (services.length) {
            fillServiceList('modalServicesSelf', 'selectedServiceId_self_modal');
            fillServiceList('modalServicesRelative', 'selectedServiceId_relative_modal');
        }
    });

    function fillServiceList(containerId, hiddenId) {
        var container = document.getElementById(containerId);
        var hidden = document.getElementById(hiddenId);
        if (!container || !hidden) return;
        container.innerHTML = '';
        (window.bookingServicesData || []).forEach(function (s) {
            var d = document.createElement('div');
            d.className = 'col-md-6 mb-2';
            d.innerHTML = '<div class="service-item">' +
                '<h6 class="mb-1 text-primary">' + (s.name || '') + '</h6>' +
                '<p class="text-muted small mb-2">' + (s.desc || '') + '</p>' +
                '<div class="d-flex justify-content-between align-items-center">' +
                '<span class="badge bg-info">' + (s.cat || '') + '</span>' +
                '<strong class="text-success">50,000 VNĐ</strong></div></div>';
            d.querySelector('.service-item').addEventListener('click', function () {
                container.querySelectorAll('.service-item').forEach(function (c) { c.classList.remove('selected'); });
                this.classList.add('selected');
                hidden.value = s.id;
            });
            container.appendChild(d);
        });
    }
});

function updateSchedules(selectedDate, doctorId, tabType, useModal) {
    var contextPath = (document.querySelector('meta[name="context-path"]') && document.querySelector('meta[name="context-path"]').getAttribute('content')) || window.BOOKING_CONTEXT_PATH || '';
    var url = contextPath + '/BookingPageServlet?ajax=true&doctorId=' + encodeURIComponent(doctorId) + '&workDate=' + encodeURIComponent(selectedDate);

    var suffix = useModal ? tabType + '_modal' : tabType + '_' + doctorId;
    var container = document.getElementById('timeSlotsContainer_' + suffix);
    var timeSlotsDiv = document.getElementById('timeSlots_' + suffix);

    if (container) {
        container.classList.remove('d-none');
        container.style.display = 'block';
    }
    if (timeSlotsDiv) {
        timeSlotsDiv.innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tải khung giờ...</div>';
    }

    fetch(url)
        .then(function (r) {
            if (!r.ok) throw new Error('HTTP ' + r.status);
            var ct = r.headers.get('content-type') || '';
            if (ct.indexOf('application/json') === -1) throw new Error('Phản hồi không phải JSON');
            return r.json();
        })
        .then(function (slots) {
            renderTimeSlots(Array.isArray(slots) ? slots : [], tabType, doctorId, useModal);
        })
        .catch(function (err) {
            console.error('Error loading timeslots:', err);
            if (timeSlotsDiv) {
                timeSlotsDiv.innerHTML = '<div class="alert alert-danger">Có lỗi khi tải khung giờ. Kiểm tra kết nối hoặc thử lại.</div>';
            }
        });
}

function renderTimeSlots(slots, tabType, doctorId, useModal) {
    var suffix = useModal ? tabType + '_modal' : tabType + '_' + doctorId;
    var timeSlotsDiv = document.getElementById('timeSlots_' + suffix);
    if (!timeSlotsDiv) return;

    var html = '';
    if (!slots || slots.length === 0) {
        html = '<div class="alert alert-warning">Không có khung giờ nào khả dụng cho ngày này</div>';
    } else {
        slots.forEach(function (slot) {
            var cls = 'time-slot';
            var click = '';
            var status = '';
            if (slot.isBooked) {
                cls += ' booked';
                status = '<small class="text-white-50">Slot đã được đặt. Vui lòng chọn slot khác!</small>';
            } else if (slot.isPast) {
                cls += ' past';
                status = '<small class="text-secondary">Đã quá giờ khám</small>';
            } else {
                var ext = useModal ? ', true' : '';
                click = 'onclick="selectTimeSlot(' + slot.slotId + ', \'' + (slot.startTime || '') + '\', \'' + (slot.endTime || '') + '\', \'' + doctorId + '\', \'' + tabType + '\'' + (useModal ? ', true' : '') + ')"';
                status = '<small class="text-success">Còn trống</small>';
            }
            html += '<div class="' + cls + '" ' + click + '><strong>' + (slot.startTime || '') + ' - ' + (slot.endTime || '') + '</strong><br>' + status + '</div>';
        });
    }
    timeSlotsDiv.innerHTML = html;
}

function selectTimeSlot(slotId, startTime, endTime, doctorId, tabType, useModal) {
    if (event && event.currentTarget && event.currentTarget.classList.contains('booked')) {
        alert('Slot đã được đặt. Vui lòng chọn slot khác!');
        return;
    }
    var suffix = (useModal === true) ? tabType + '_modal' : tabType + '_' + doctorId;
    var hidden = document.getElementById('selectedSlotId_' + suffix);
    if (hidden) hidden.value = slotId;
    var container = document.getElementById('timeSlots_' + suffix);
    if (container) {
        container.querySelectorAll('.time-slot:not(.booked)').forEach(function (s) { s.classList.remove('selected'); });
        if (event && event.currentTarget) event.currentTarget.classList.add('selected');
    }
}

function selectService(element, serviceId, serviceName, servicePrice, tabType) {
    var tab = element && element.closest('.tab-pane');
    if (tab) tab.querySelectorAll('.service-item').forEach(function (c) { c.classList.remove('selected'); });
    if (element) element.classList.add('selected');
    var hidden = document.getElementById('selectedServiceId_' + tabType);
    if (hidden) hidden.value = serviceId;
}
