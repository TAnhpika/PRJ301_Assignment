<%-- Trang Tái Khám - Doctor Dashboard --%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="model.User, model.Doctors"%>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"DOCTOR".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Tái Khám - Happy Smile</title>
    <style>
        /* ===== PAGE HEADER ===== */
        .page-title-section {
            margin-bottom: 28px;
        }
        .page-title-section h4 {
            font-size: 22px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 4px;
        }
        .page-title-section p {
            color: #64748b;
            font-size: 14px;
            margin: 0;
        }

        /* ===== SEARCH BAR ===== */
        .search-container {
            position: relative;
            max-width: 380px;
            margin-bottom: 24px;
        }
        .search-container i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 14px;
            pointer-events: none;
        }
        .search-container input {
            width: 100%;
            padding: 11px 16px 11px 40px;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            color: #334155;
            background: white;
            transition: all 0.2s ease;
            box-sizing: border-box;
        }
        .search-container input:focus {
            outline: none;
            border-color: #0d9488;
            box-shadow: 0 0 0 3px rgba(13, 148, 136, 0.1);
        }

        /* ===== PATIENT CARD ===== */
        .patient-card {
            background: white;
            border-radius: 14px;
            border: 1.5px solid #e8eef5;
            padding: 18px 22px;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            transition: all 0.25s ease;
            box-shadow: 0 1px 4px rgba(0,0,0,0.04);
        }
        .patient-card:hover {
            border-color: #0d9488;
            box-shadow: 0 4px 16px rgba(13,148,136,0.1);
            transform: translateY(-1px);
        }
        .patient-info-left {
            display: flex;
            align-items: center;
            gap: 16px;
            flex: 1;
            min-width: 0;
        }
        .patient-avatar-box {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0d9488, #0f766e);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: 700;
            flex-shrink: 0;
            box-shadow: 0 3px 8px rgba(13,148,136,0.3);
        }
        .patient-avatar-box img {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            object-fit: cover;
        }
        .patient-details-text {
            min-width: 0;
        }
        .patient-details-text .patient-name {
            font-size: 15.5px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 5px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .patient-details-text .patient-meta {
            font-size: 13px;
            color: #64748b;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }
        .patient-details-text .patient-meta span {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .patient-details-text .patient-meta i {
            color: #94a3b8;
            font-size: 12px;
        }

        /* ===== BUTTON TÁI KHÁM ===== */
        .btn-reexam {
            background: linear-gradient(135deg, #0d9488, #0f766e);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 13.5px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 7px;
            white-space: nowrap;
            transition: all 0.25s ease;
            box-shadow: 0 2px 8px rgba(13,148,136,0.25);
        }
        .btn-reexam:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(13,148,136,0.35);
        }
        .btn-reexam:active {
            transform: translateY(0);
        }

        /* ===== POPUP TÁI KHÁM ===== */
        .reexam-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.4);
            z-index: 9998;
            backdrop-filter: blur(2px);
        }
        .reexam-modal {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            border-radius: 16px;
            padding: 28px;
            width: 360px;
            max-width: calc(100vw - 32px);
            z-index: 9999;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
        }
        .modal-title {
            font-size: 17px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 4px;
        }
        .modal-subtitle {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 20px;
        }
        .modal-field {
            margin-bottom: 16px;
        }
        .modal-field label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 6px;
        }
        .modal-field input[type="date"],
        .modal-field input[type="text"],
        .modal-field textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            color: #334155;
            transition: border-color 0.2s;
            box-sizing: border-box;
        }
        .modal-field input:focus,
        .modal-field textarea:focus {
            outline: none;
            border-color: #0d9488;
            box-shadow: 0 0 0 3px rgba(13,148,136,0.1);
        }
        .modal-field textarea {
            resize: vertical;
            min-height: 72px;
        }
        .modal-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .btn-modal-cancel {
            flex: 1;
            padding: 10px;
            border: 1.5px solid #e2e8f0;
            background: white;
            color: #64748b;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-modal-cancel:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
        }
        .btn-modal-submit {
            flex: 2;
            padding: 10px;
            background: linear-gradient(135deg, #0d9488, #0f766e);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            transition: all 0.2s;
            box-shadow: 0 2px 8px rgba(13,148,136,0.2);
        }
        .btn-modal-submit:hover {
            box-shadow: 0 4px 14px rgba(13,148,136,0.3);
        }

        /* ===== EMPTY STATE ===== */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #94a3b8;
        }
        .empty-state i {
            font-size: 56px;
            margin-bottom: 16px;
            color: #e2e8f0;
        }
        .empty-state h5 {
            font-size: 16px;
            color: #64748b;
            margin-bottom: 6px;
        }

        /* ===== PAGINATION ===== */
        .pagination-section {
            margin-top: 28px;
            display: flex;
            justify-content: center;
            gap: 6px;
        }
        .pagination-section a,
        .pagination-section span {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 8px;
            background: white;
            border: 1.5px solid #e2e8f0;
            color: #64748b;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.2s;
        }
        .pagination-section a:hover {
            border-color: #0d9488;
            color: #0d9488;
        }
        .pagination-section .active-page {
            background: #0d9488;
            border-color: #0d9488;
            color: white;
        }

        /* Toast */
        .toast-notify {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: #1e293b;
            color: white;
            padding: 14px 20px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 500;
            z-index: 99999;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
            transform: translateY(80px);
            opacity: 0;
            transition: all 0.35s cubic-bezier(0.68,-0.55,0.27,1.55);
        }
        .toast-notify.show {
            transform: translateY(0);
            opacity: 1;
        }
        .toast-notify.success { background: #0d9488; }
        .toast-notify.error { background: #ef4444; }
    </style>
</head>

<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
        <main class="dashboard-main">
            <%@ include file="/jsp/doctor/doctor_header.jsp" %>

            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="page-title-section">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <h4><i class="fas fa-redo-alt me-2 text-teal" style="color:#0d9488"></i>Quản lý Tái Khám</h4>
                            <p>Xem danh sách bệnh nhân đã khám và tạo yêu cầu tái khám</p>
                        </div>
                        <div>
                            <span class="badge bg-light text-secondary border px-3 py-2" style="font-size:13px">
                                <i class="fas fa-users me-1"></i>
                                <c:choose>
                                    <c:when test="${not empty reexaminationList}">${reexaminationList.size()} bệnh nhân</c:when>
                                    <c:otherwise>0 bệnh nhân</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mt-2">
                        <ol class="breadcrumb mb-0" style="font-size:13px">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DoctorHomePageServlet" class="text-decoration-none">Trang chủ</a></li>
                            <li class="breadcrumb-item"><a href="#" class="text-decoration-none">Lịch khám</a></li>
                            <li class="breadcrumb-item active">Tái khám</li>
                        </ol>
                    </nav>
                </div>

                <!-- Search bar -->
                <div class="search-container">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên bệnh nhân...">
                </div>

                <!-- Patient List -->
                <div id="patientListContainer">
                    <c:choose>
                        <c:when test="${not empty reexaminationList}">
                            <c:forEach var="appointment" items="${reexaminationList}">
                                <div class="patient-card" data-name="${appointment.patientName}">
                                    <div class="patient-info-left">
                                        <div class="patient-avatar-box">
                                            <c:choose>
                                                <c:when test="${not empty appointment.patientAvatar}">
                                                    <img src="${pageContext.request.contextPath}/${appointment.patientAvatar}" alt="avatar">
                                                </c:when>
                                                <c:otherwise>
                                                    ${fn:substring(appointment.patientName, 0, 1)}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="patient-details-text">
                                            <div class="patient-name">${appointment.patientName}</div>
                                            <div class="patient-meta">
                                                <span><i class="fas fa-calendar-check"></i> Khám: ${appointment.appointmentDate}</span>
                                                <span><i class="fas fa-tooth"></i> ${appointment.serviceName}</span>
                                                <c:if test="${not empty appointment.gender}">
                                                    <span><i class="fas fa-venus-mars"></i> ${appointment.gender}</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                    <button class="btn-reexam" onclick="openModal('${appointment.appointmentId}', '${appointment.patientName}')">
                                        <i class="fas fa-redo-alt"></i> Đặt tái khám
                                    </button>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <%-- Nếu chưa có dữ liệu thật, hiển thị demo placeholder --%>
                            <div class="patient-card demo-card" data-name="Nguyễn Văn An">
                                <div class="patient-info-left">
                                    <div class="patient-avatar-box">N</div>
                                    <div class="patient-details-text">
                                        <div class="patient-name">Nguyễn Văn An</div>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-check"></i> Khám: 25/02/2026</span>
                                            <span><i class="fas fa-tooth"></i> Nhổ răng khôn</span>
                                            <span><i class="fas fa-venus-mars"></i> Nam</span>
                                        </div>
                                    </div>
                                </div>
                                <button class="btn-reexam" onclick="openModal('1', 'Nguyễn Văn An')">
                                    <i class="fas fa-redo-alt"></i> Đặt tái khám
                                </button>
                            </div>
                            <div class="patient-card demo-card" data-name="Trần Thị Bình">
                                <div class="patient-info-left">
                                    <div class="patient-avatar-box">T</div>
                                    <div class="patient-details-text">
                                        <div class="patient-name">Trần Thị Bình</div>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-check"></i> Khám: 26/02/2026</span>
                                            <span><i class="fas fa-tooth"></i> Trám răng</span>
                                            <span><i class="fas fa-venus-mars"></i> Nữ</span>
                                        </div>
                                    </div>
                                </div>
                                <button class="btn-reexam" onclick="openModal('2', 'Trần Thị Bình')">
                                    <i class="fas fa-redo-alt"></i> Đặt tái khám
                                </button>
                            </div>
                            <div class="patient-card demo-card" data-name="Lê Minh Cường">
                                <div class="patient-info-left">
                                    <div class="patient-avatar-box">L</div>
                                    <div class="patient-details-text">
                                        <div class="patient-name">Lê Minh Cường</div>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-check"></i> Khám: 27/02/2026</span>
                                            <span><i class="fas fa-tooth"></i> Tẩy trắng răng</span>
                                            <span><i class="fas fa-venus-mars"></i> Nam</span>
                                        </div>
                                    </div>
                                </div>
                                <button class="btn-reexam" onclick="openModal('3', 'Lê Minh Cường')">
                                    <i class="fas fa-redo-alt"></i> Đặt tái khám
                                </button>
                            </div>
                            <div class="patient-card demo-card" data-name="Phạm Thu Hà">
                                <div class="patient-info-left">
                                    <div class="patient-avatar-box">P</div>
                                    <div class="patient-details-text">
                                        <div class="patient-name">Phạm Thu Hà</div>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-check"></i> Khám: 28/02/2026</span>
                                            <span><i class="fas fa-tooth"></i> Niềng răng</span>
                                            <span><i class="fas fa-venus-mars"></i> Nữ</span>
                                        </div>
                                    </div>
                                </div>
                                <button class="btn-reexam" onclick="openModal('4', 'Phạm Thu Hà')">
                                    <i class="fas fa-redo-alt"></i> Đặt tái khám
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Empty state (hidden by default) -->
                <div class="empty-state d-none" id="emptyState">
                    <i class="fas fa-search"></i>
                    <h5>Không tìm thấy bệnh nhân</h5>
                    <p class="text-muted small">Không có bệnh nhân nào khớp với từ khoá tìm kiếm</p>
                </div>

                <!-- Pagination -->
                <div class="pagination-section">
                    <a href="#"><i class="fas fa-chevron-left" style="font-size:11px"></i></a>
                    <a href="#" class="active-page">1</a>
                    <a href="#">2</a>
                    <a href="#">3</a>
                    <a href="#"><i class="fas fa-chevron-right" style="font-size:11px"></i></a>
                </div>
            </div>
        </main>
    </div>

    <!-- Overlay -->
    <div class="reexam-overlay" id="reexamOverlay" onclick="closeModal()"></div>

    <!-- Modal Tái Khám -->
    <div class="reexam-modal" id="reexamModal">
        <div class="modal-title"><i class="fas fa-redo-alt me-2" style="color:#0d9488"></i>Tạo yêu cầu tái khám</div>
        <div class="modal-subtitle" id="modalPatientName">Bệnh nhân: —</div>

        <form id="reexamForm" action="${pageContext.request.contextPath}/ReexaminationServlet" method="POST">
            <input type="hidden" name="action" value="create">
            <input type="hidden" name="appointmentId" id="hiddenAppointmentId">

            <div class="modal-field">
                <label><i class="fas fa-calendar-alt me-1" style="color:#0d9488"></i>Ngày tái khám gợi ý</label>
                <input type="date" name="reexamDate" id="reexamDate" required>
            </div>

            <div class="modal-field">
                <label><i class="fas fa-sticky-note me-1" style="color:#0d9488"></i>Ghi chú cho bệnh nhân</label>
                <textarea name="note" id="reexamNote" placeholder="VD: Cần tái khám kiểm tra tình trạng sau điều trị..."></textarea>
            </div>

            <div class="modal-buttons">
                <button type="button" class="btn-modal-cancel" onclick="closeModal()">
                    <i class="fas fa-times me-1"></i>Hủy
                </button>
                <button type="submit" class="btn-modal-submit">
                    <i class="fas fa-check me-1"></i>Tạo yêu cầu
                </button>
            </div>
        </form>
    </div>

    <!-- Toast Notification -->
    <div class="toast-notify" id="toastNotify">
        <i class="fas fa-check-circle"></i>
        <span id="toastMsg">Đã tạo yêu cầu tái khám thành công!</span>
    </div>

    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
    <script>
        // Set default date to 2 weeks from now
        (function () {
            const d = new Date();
            d.setDate(d.getDate() + 14);
            const yyyy = d.getFullYear();
            const mm = String(d.getMonth() + 1).padStart(2, '0');
            const dd = String(d.getDate()).padStart(2, '0');
            document.getElementById('reexamDate').value = `${yyyy}-${mm}-${dd}`;
        })();

        function openModal(appointmentId, patientName) {
            document.getElementById('hiddenAppointmentId').value = appointmentId;
            document.getElementById('modalPatientName').textContent = 'Bệnh nhân: ' + patientName;
            document.getElementById('reexamOverlay').style.display = 'block';
            document.getElementById('reexamModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('reexamOverlay').style.display = 'none';
            document.getElementById('reexamModal').style.display = 'none';
        }

        // Handle form submit
        document.getElementById('reexamForm').addEventListener('submit', function (e) {
            e.preventDefault(); // Prevent real submit for demo, remove if servlet is ready
            closeModal();
            showToast('Đã tạo yêu cầu tái khám thành công!', 'success');
            // Uncomment below to actually submit:
            // this.submit();
        });

        // Search
        document.getElementById('searchInput').addEventListener('input', function () {
            const kw = this.value.toLowerCase().trim();
            const cards = document.querySelectorAll('.patient-card');
            let found = 0;
            cards.forEach(card => {
                const name = (card.dataset.name || '').toLowerCase();
                const show = !kw || name.includes(kw);
                card.style.display = show ? '' : 'none';
                if (show) found++;
            });
            document.getElementById('emptyState').classList.toggle('d-none', found > 0 || !kw);
        });

        // Toast
        function showToast(msg, type = 'success') {
            const t = document.getElementById('toastNotify');
            document.getElementById('toastMsg').textContent = msg;
            t.className = 'toast-notify ' + type;
            requestAnimationFrame(() => t.classList.add('show'));
            setTimeout(() => t.classList.remove('show'), 3500);
        }

        // Close modal on Escape
        document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });
    </script>
</body>
</html>
