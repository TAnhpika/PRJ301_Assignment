<%-- Trang Tái Khám - Doctor Dashboard --%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page import="model.User"%>
<%
    User authUser = (User) session.getAttribute("user");
    if (authUser == null || !"DOCTOR".equalsIgnoreCase(authUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
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
        .page-title-section { margin-bottom: 24px; }
        .page-title-section h4 { font-size: 21px; font-weight: 700; color: #1e293b; margin-bottom: 3px; }
        .page-title-section p { color: #64748b; font-size: 13.5px; margin: 0; }

        /* ===== SEARCH BAR ===== */
        .search-container { position: relative; max-width: 360px; margin-bottom: 22px; }
        .search-container i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 13px; pointer-events: none; }
        .search-container input {
            width: 100%; padding: 11px 16px 11px 40px;
            border: 1.5px solid #e2e8f0; border-radius: 10px; font-size: 14px;
            color: #334155; background: white; transition: all 0.2s; box-sizing: border-box;
        }
        .search-container input:focus { outline: none; border-color: #0d9488; box-shadow: 0 0 0 3px rgba(13,148,136,0.1); }

        /* ===== PATIENT CARD ===== */
        .patient-card {
            background: white; border-radius: 13px; border: 1.5px solid #e8eef5;
            padding: 17px 22px; margin-bottom: 11px; display: flex;
            align-items: center; justify-content: space-between; gap: 20px;
            transition: all 0.22s ease; box-shadow: 0 1px 4px rgba(0,0,0,0.04);
        }
        .patient-card:hover { border-color: #0d9488; box-shadow: 0 4px 14px rgba(13,148,136,0.1); transform: translateY(-1px); }
        .patient-info-left { display: flex; align-items: center; gap: 15px; flex: 1; min-width: 0; }
        .patient-avatar-box {
            width: 50px; height: 50px; border-radius: 50%; flex-shrink: 0;
            background: linear-gradient(135deg, #0d9488, #0f766e);
            display: flex; align-items: center; justify-content: center;
            color: white; font-size: 20px; font-weight: 700;
            box-shadow: 0 2px 8px rgba(13,148,136,0.28);
        }
        .patient-avatar-box img { width: 50px; height: 50px; border-radius: 50%; object-fit: cover; }
        .patient-name { font-size: 15px; font-weight: 700; color: #1e293b; margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .patient-meta { font-size: 12.5px; color: #64748b; display: flex; flex-wrap: wrap; gap: 10px; }
        .patient-meta span { display: flex; align-items: center; gap: 4px; }
        .patient-meta i { color: #94a3b8; font-size: 11px; }

        /* ===== BUTTON ===== */
        .btn-reexam {
            background: linear-gradient(135deg, #0d9488, #0f766e); color: white;
            border: none; padding: 9px 18px; border-radius: 9px; cursor: pointer;
            font-size: 13px; font-weight: 600; display: flex; align-items: center;
            gap: 6px; white-space: nowrap; transition: all 0.22s;
            box-shadow: 0 2px 8px rgba(13,148,136,0.22); flex-shrink: 0;
        }
        .btn-reexam:hover { transform: translateY(-1px); box-shadow: 0 4px 14px rgba(13,148,136,0.32); }

        /* ===== MODAL (NO HORIZONTAL SCROLL) ===== */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(15,23,42,0.45); z-index: 9998;
            backdrop-filter: blur(3px);
        }
        .modal-overlay.show { display: block; }
        .reexam-modal {
            display: none; position: fixed;
            top: 50%; left: 50%; transform: translate(-50%, -50%);
            background: white; border-radius: 16px; padding: 28px;
            width: 380px; max-width: calc(100vw - 32px);
            z-index: 9999; box-shadow: 0 20px 60px rgba(0,0,0,0.18);
        }
        .reexam-modal.show { display: block; }
        .modal-header { margin-bottom: 18px; }
        .modal-header h5 { font-size: 17px; font-weight: 700; color: #1e293b; margin-bottom: 3px; }
        .modal-header p { font-size: 13px; color: #64748b; margin: 0; }
        .modal-field { margin-bottom: 15px; }
        .modal-field label { display: block; font-size: 13px; font-weight: 600; color: #475569; margin-bottom: 6px; }
        .modal-field input[type="date"],
        .modal-field input[type="text"],
        .modal-field textarea {
            width: 100%; padding: 10px 12px; border: 1.5px solid #e2e8f0;
            border-radius: 8px; font-size: 14px; color: #334155;
            transition: border-color 0.2s; box-sizing: border-box;
        }
        .modal-field input:focus, .modal-field textarea:focus {
            outline: none; border-color: #0d9488; box-shadow: 0 0 0 3px rgba(13,148,136,0.1);
        }
        .modal-field textarea { resize: vertical; min-height: 68px; }
        .modal-actions { display: flex; gap: 10px; margin-top: 20px; }
        .btn-modal-cancel {
            flex: 1; padding: 10px; border: 1.5px solid #e2e8f0; background: white;
            color: #64748b; border-radius: 8px; font-size: 14px; font-weight: 600;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-modal-cancel:hover { background: #f8fafc; border-color: #cbd5e1; }
        .btn-modal-submit {
            flex: 2; padding: 10px; background: linear-gradient(135deg, #0d9488, #0f766e);
            color: white; border: none; border-radius: 8px; font-size: 14px; font-weight: 600;
            cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 7px;
            transition: all 0.2s; box-shadow: 0 2px 8px rgba(13,148,136,0.2);
        }
        .btn-modal-submit:hover { box-shadow: 0 4px 14px rgba(13,148,136,0.3); }

        /* ===== EMPTY STATE ===== */
        .empty-state { text-align: center; padding: 56px 20px; color: #94a3b8; }
        .empty-state i { font-size: 52px; margin-bottom: 14px; color: #e2e8f0; display: block; }
        .empty-state h5 { font-size: 16px; color: #64748b; margin-bottom: 5px; }

        /* ===== PAGINATION ===== */
        .pagination-section { margin-top: 26px; display: flex; justify-content: center; gap: 6px; }
        .pagination-section a, .pagination-section span {
            display: inline-flex; align-items: center; justify-content: center;
            width: 36px; height: 36px; border-radius: 8px; background: white;
            border: 1.5px solid #e2e8f0; color: #64748b; text-decoration: none; font-size: 13px;
            transition: all 0.2s;
        }
        .pagination-section a:hover { border-color: #0d9488; color: #0d9488; }
        .pagination-section .active-page { background: #0d9488; border-color: #0d9488; color: white; }

        /* ===== TOAST ===== */
        .toast-notify {
            position: fixed; bottom: 24px; right: 24px; padding: 13px 20px;
            border-radius: 12px; font-size: 14px; font-weight: 500; z-index: 99999;
            display: flex; align-items: center; gap: 10px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
            transform: translateY(80px); opacity: 0;
            transition: all 0.35s cubic-bezier(0.68,-0.55,0.27,1.55);
            background: #0d9488; color: white;
        }
        .toast-notify.show { transform: translateY(0); opacity: 1; }
    </style>
</head>

<body>
    <div class="dashboard-wrapper">
        <%@ include file="/view/jsp/doctor/doctor_menu.jsp" %>
        <main class="dashboard-main">
            <%@ include file="/view/jsp/doctor/doctor_header.jsp" %>

            <div class="dashboard-content">
                <!-- Header -->
                <div class="page-title-section">
                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                        <div>
                            <h4><i class="fas fa-redo-alt me-2" style="color:#0d9488"></i>Quản lý Tái Khám</h4>
                            <p>Xem danh sách bệnh nhân đã khám và tạo yêu cầu tái khám</p>
                        </div>
                    </div>
                    <nav aria-label="breadcrumb" class="mt-2">
                        <ol class="breadcrumb mb-0" style="font-size:12.5px">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DoctorHomePageServlet" class="text-decoration-none">Trang chủ</a></li>
                            <li class="breadcrumb-item active">Tái khám</li>
                        </ol>
                    </nav>
                </div>

                <!-- Search -->
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
                                        <div class="patient-avatar-box">${fn:substring(appointment.patientName,0,1)}</div>
                                        <div>
                                            <div class="patient-name">${appointment.patientName}</div>
                                            <div class="patient-meta">
                                                <span><i class="fas fa-calendar-check"></i>${appointment.appointmentDate}</span>
                                                <span><i class="fas fa-tooth"></i>${appointment.serviceName}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <button class="btn-reexam" onclick="openModal('${appointment.appointmentId}','${appointment.patientName}')">
                                        <i class="fas fa-redo-alt"></i>Đặt tái khám
                                    </button>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <%-- Demo data --%>
                            <div class="patient-card" data-name="Nguyễn Văn An">
                                <div class="patient-info-left">
                                    <div class="patient-avatar-box">N</div>
                                    <div>
                                        <div class="patient-name">Nguyễn Văn An</div>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-check"></i>25/02/2026</span>
                                            <span><i class="fas fa-tooth"></i>Nhổ răng khôn</span>
                                            <span><i class="fas fa-venus-mars"></i>Nam · 29 tuổi</span>
                                        </div>
                                    </div>
                                </div>
                                <button class="btn-reexam" onclick="openModal('1','Nguyễn Văn An')">
                                    <i class="fas fa-redo-alt"></i>Đặt tái khám
                                </button>
                            </div>
                            <div class="patient-card" data-name="Trần Thị Bình">
                                <div class="patient-info-left">
                                    <div class="patient-avatar-box">T</div>
                                    <div>
                                        <div class="patient-name">Trần Thị Bình</div>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-check"></i>26/02/2026</span>
                                            <span><i class="fas fa-tooth"></i>Trám răng</span>
                                            <span><i class="fas fa-venus-mars"></i>Nữ · 34 tuổi</span>
                                        </div>
                                    </div>
                                </div>
                                <button class="btn-reexam" onclick="openModal('2','Trần Thị Bình')">
                                    <i class="fas fa-redo-alt"></i>Đặt tái khám
                                </button>
                            </div>
                            <div class="patient-card" data-name="Lê Minh Cường">
                                <div class="patient-info-left">
                                    <div class="patient-avatar-box">L</div>
                                    <div>
                                        <div class="patient-name">Lê Minh Cường</div>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-check"></i>27/02/2026</span>
                                            <span><i class="fas fa-tooth"></i>Tẩy trắng răng</span>
                                            <span><i class="fas fa-venus-mars"></i>Nam · 41 tuổi</span>
                                        </div>
                                    </div>
                                </div>
                                <button class="btn-reexam" onclick="openModal('3','Lê Minh Cường')">
                                    <i class="fas fa-redo-alt"></i>Đặt tái khám
                                </button>
                            </div>
                            <div class="patient-card" data-name="Phạm Thu Hà">
                                <div class="patient-info-left">
                                    <div class="patient-avatar-box">P</div>
                                    <div>
                                        <div class="patient-name">Phạm Thu Hà</div>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-check"></i>28/02/2026</span>
                                            <span><i class="fas fa-tooth"></i>Niềng răng</span>
                                            <span><i class="fas fa-venus-mars"></i>Nữ · 26 tuổi</span>
                                        </div>
                                    </div>
                                </div>
                                <button class="btn-reexam" onclick="openModal('4','Phạm Thu Hà')">
                                    <i class="fas fa-redo-alt"></i>Đặt tái khám
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="empty-state d-none" id="emptyState">
                    <i class="fas fa-search"></i>
                    <h5>Không tìm thấy bệnh nhân</h5>
                    <p class="text-muted small">Không có bệnh nhân nào khớp với từ khoá tìm kiếm</p>
                </div>

                <!-- Pagination -->
                <div class="pagination-section">
                    <a href="#"><i class="fas fa-chevron-left" style="font-size:10px"></i></a>
                    <a href="#" class="active-page">1</a>
                    <a href="#">2</a>
                    <a href="#">3</a>
                    <a href="#"><i class="fas fa-chevron-right" style="font-size:10px"></i></a>
                </div>
            </div>
        </main>
    </div>

    <!-- Overlay + Modal (CENTERED, không gây scroll ngang) -->
    <div class="modal-overlay" id="modalOverlay" onclick="closeModal()"></div>
    <div class="reexam-modal" id="reexamModal">
        <div class="modal-header">
            <h5><i class="fas fa-redo-alt me-2" style="color:#0d9488"></i>Tạo yêu cầu tái khám</h5>
            <p id="modalPatientName">Bệnh nhân: —</p>
        </div>
        <form id="reexamForm" action="${pageContext.request.contextPath}/ReexaminationServlet" method="POST">
            <input type="hidden" name="action" value="create">
            <input type="hidden" name="appointmentId" id="hiddenApptId">
            <div class="modal-field">
                <label><i class="fas fa-calendar-alt me-1" style="color:#0d9488"></i>Ngày tái khám gợi ý</label>
                <input type="date" name="reexamDate" id="reexamDate" required>
            </div>
            <div class="modal-field">
                <label><i class="fas fa-sticky-note me-1" style="color:#0d9488"></i>Ghi chú cho bệnh nhân</label>
                <textarea name="note" id="reexamNote" placeholder="VD: Cần tái khám kiểm tra tình trạng sau điều trị..."></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" onclick="closeModal()"><i class="fas fa-times me-1"></i>Hủy</button>
                <button type="submit" class="btn-modal-submit"><i class="fas fa-check me-1"></i>Tạo yêu cầu</button>
            </div>
        </form>
    </div>

    <!-- Toast -->
    <div class="toast-notify" id="toastEl">
        <i class="fas fa-check-circle"></i><span id="toastMsg">Đã tạo yêu cầu tái khám!</span>
    </div>

    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
    <script>
        // Set default date = today + 14 days
        (function () {
            const d = new Date();
            d.setDate(d.getDate() + 14);
            document.getElementById('reexamDate').value = d.toISOString().split('T')[0];
        })();

        function openModal(apptId, name) {
            document.getElementById('hiddenApptId').value = apptId;
            document.getElementById('modalPatientName').textContent = 'Bệnh nhân: ' + name;
            document.getElementById('modalOverlay').classList.add('show');
            document.getElementById('reexamModal').classList.add('show');
        }

        function closeModal() {
            document.getElementById('modalOverlay').classList.remove('show');
            document.getElementById('reexamModal').classList.remove('show');
        }

        document.getElementById('reexamForm').addEventListener('submit', function (e) {
            e.preventDefault();
            closeModal();
            showToast('Đã tạo yêu cầu tái khám thành công!');
            // this.submit(); // Bỏ comment khi servlet sẵn sàng
        });

        document.getElementById('searchInput').addEventListener('input', function () {
            const kw = this.value.toLowerCase().trim();
            const cards = document.querySelectorAll('.patient-card');
            let found = 0;
            cards.forEach(c => {
                const show = !kw || (c.dataset.name || '').toLowerCase().includes(kw);
                c.style.display = show ? '' : 'none';
                if (show) found++;
            });
            document.getElementById('emptyState').classList.toggle('d-none', found > 0 || !kw);
        });

        function showToast(msg) {
            const t = document.getElementById('toastEl');
            document.getElementById('toastMsg').textContent = msg;
            requestAnimationFrame(() => t.classList.add('show'));
            setTimeout(() => t.classList.remove('show'), 3500);
        }

        document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });
    </script>
</body>
</html>
