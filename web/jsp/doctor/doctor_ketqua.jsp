<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="model.Appointment" %>
<%@page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    List<Appointment> completedAppointments = (List<Appointment>) request.getAttribute("completedAppointments");
    String error = (String) request.getAttribute("error");
    String selectedDate = (String) request.getAttribute("selectedDate");
    String selectedDateDisplay = (String) request.getAttribute("selectedDateDisplay");
    Boolean isToday = (Boolean) request.getAttribute("isToday");
    if (selectedDate == null) selectedDate = "";
    if (selectedDateDisplay == null) selectedDateDisplay = "";
    if (isToday == null) isToday = false;
    int totalCompleted = (completedAppointments != null) ? completedAppointments.size() : 0;
%>

                            <!DOCTYPE html>
                            <html lang="vi">

                            <head>
                                <%@ include file="/includes/dashboard_head.jsp" %>
                                    <title>Kết quả khám - Doctor</title>
                                    <link rel="stylesheet"
                                        href="${pageContext.request.contextPath}/css/dashboard-common.css">
                                    <style>
                                        /* Giao diện văn phòng: tông trung tính, ít màu chói */
                                        .results-header {
                                            background: #f8fafc;
                                            color: #1e293b;
                                            padding: 24px 28px;
                                            border-radius: 10px;
                                            margin-bottom: 20px;
                                            border: 1px solid #e2e8f0;
                                            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
                                        }
                                        .results-header h4 { margin: 0 0 6px 0; font-size: 22px; font-weight: 600; color: #334155; }
                                        .results-header p { margin: 0; font-size: 14px; color: #64748b; }

                                        .date-current-label { font-size: 15px; font-weight: 600; color: #1e293b; margin-bottom: 12px; }
                                        .date-current-label .badge-today { background: #0d9488; color: white; padding: 2px 8px; border-radius: 4px; font-size: 12px; margin-left: 8px; }

                                        .date-selector { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; flex-wrap: wrap; }
                                        .date-selector label { font-weight: 600; color: #334155; font-size: 14px; }
                                        .date-selector input[type="date"] { padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; font-size: 14px; color: #334155; }
                                        .date-selector .btn-date { padding: 8px 16px; border: 1px solid #64748b; border-radius: 6px; background: #f8fafc; color: #334155; cursor: pointer; font-size: 13px; font-weight: 500; text-decoration: none; }
                                        .date-selector .btn-date:hover { background: #e2e8f0; color: #334155; }
                                        .date-selector .btn-date.today { background: #0d9488; color: white; border-color: #0d9488; }
                                        .date-selector .btn-date.today:hover { background: #0f766e; color: white; }

                                        .search-filter-bar {
                                            background: #fff;
                                            padding: 16px 20px;
                                            border-radius: 10px;
                                            border: 1px solid #e2e8f0;
                                            margin-bottom: 20px;
                                            display: flex;
                                            gap: 16px;
                                            align-items: center;
                                            flex-wrap: wrap;
                                        }
                                        .search-box { flex: 1; min-width: 260px; position: relative; }
                                        .search-box input {
                                            width: 100%;
                                            padding: 10px 14px 10px 40px;
                                            border: 1px solid #e2e8f0;
                                            border-radius: 8px;
                                            font-size: 14px;
                                            color: #334155;
                                        }
                                        .search-box input:focus { outline: none; border-color: #0d9488; box-shadow: 0 0 0 2px rgba(13, 148, 136, 0.15); }
                                        .search-box i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #64748b; font-size: 14px; }

                                        .filter-stats {
                                            display: flex; gap: 8px; align-items: center;
                                            padding: 8px 14px; background: #f0fdfa; border: 1px solid #ccfbf1;
                                            border-radius: 8px; color: #0d9488; font-weight: 600; font-size: 13px;
                                        }

                                        .result-card {
                                            background: #fff;
                                            border: 1px solid #e2e8f0;
                                            border-radius: 10px;
                                            padding: 20px 22px;
                                            margin-bottom: 14px;
                                            border-left: 4px solid #0d9488;
                                            transition: border-color 0.2s ease, box-shadow 0.2s ease;
                                        }
                                        .result-card:hover { border-color: #cbd5e1; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }

                                        .result-card-header {
                                            display: flex; justify-content: space-between; align-items: center;
                                            margin-bottom: 14px; padding-bottom: 14px; border-bottom: 1px solid #e2e8f0;
                                        }
                                        .result-time-badge {
                                            display: inline-flex; align-items: center; gap: 6px;
                                            background: #f1f5f9; color: #334155;
                                            padding: 6px 12px; border-radius: 6px; font-size: 13px; font-weight: 600;
                                            border: 1px solid #e2e8f0;
                                        }
                                        .result-status-badge {
                                            display: inline-flex; align-items: center; gap: 6px;
                                            background: #f0fdfa; color: #0d9488;
                                            padding: 6px 12px; border-radius: 6px; font-size: 13px; font-weight: 600;
                                            border: 1px solid #ccfbf1;
                                        }

                                        .result-card-body { display: flex; align-items: center; gap: 18px; }
                                        .result-avatar { width: 56px; height: 56px; border-radius: 50%; object-fit: cover; border: 2px solid #e2e8f0; flex-shrink: 0; }
                                        .result-info { flex: 1; }
                                        .result-patient-name { font-size: 16px; font-weight: 600; color: #1e293b; margin: 0 0 4px 0; }
                                        .result-appointment-id { font-size: 12px; color: #64748b; margin-bottom: 6px; }
                                        .result-reason { display: flex; align-items: center; gap: 8px; color: #64748b; font-size: 13px; margin: 0; }
                                        .result-reason i { color: #0d9488; }

                                        .result-action-btn {
                                            padding: 9px 18px; background: #0d9488; color: white;
                                            border: none; border-radius: 8px; font-size: 13px; font-weight: 600;
                                            cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;
                                            transition: background 0.2s ease;
                                        }
                                        .result-action-btn:hover { background: #0f766e; color: white; }

                                        .empty-state {
                                            background: #fff; border-radius: 10px; padding: 48px 24px; text-align: center;
                                            border: 1px solid #e2e8f0;
                                        }
                                        .empty-state-icon { font-size: 56px; color: #cbd5e1; margin-bottom: 16px; }
                                        .empty-state h5 { color: #475569; font-size: 18px; font-weight: 600; margin-bottom: 8px; }
                                        .empty-state p { color: #94a3b8; font-size: 14px; margin: 0; }

                                        @media (max-width: 768px) {
                                            .results-header { padding: 20px; }
                                            .search-filter-bar { flex-direction: column; align-items: stretch; }
                                            .search-box { min-width: 100%; }
                                            .result-card-body { flex-direction: column; text-align: center; }
                                            .result-action-btn { width: 100%; justify-content: center; }
                                        }
                                    </style>
                            </head>

                            <body>
                                <div class="dashboard-wrapper">
                                    <%@ include file="/jsp/doctor/doctor_menu.jsp" %>

                                        <main class="dashboard-main">
                                            <%@ include file="/jsp/doctor/doctor_header.jsp" %>

                                                <div class="dashboard-content">
                                                    <div class="results-header">
                                                        <h4><i class="fas fa-clipboard-check me-2"></i>Kết quả khám bệnh</h4>
                                                        <p>Quản lý và xem chi tiết các cuộc hẹn đã hoàn thành</p>
                                                    </div>

                                                    <!-- Chọn ngày: hiện tại / theo lịch -->
                                                    <div class="date-current-label">
                                                        Kết quả khám ngày: <strong><%= selectedDateDisplay.isEmpty() ? "—" : selectedDateDisplay %></strong>
                                                        <% if (isToday) { %><span class="badge-today">Hôm nay</span><% } %>
                                                    </div>
                                                    <form method="get" action="${pageContext.request.contextPath}/completedAppointments" class="date-selector">
                                                        <label for="date">Chọn ngày:</label>
                                                        <input type="date" id="date" name="date" value="<%= selectedDate %>" onchange="this.form.submit()">
                                                        <a href="${pageContext.request.contextPath}/completedAppointments" class="btn-date today">Hôm nay</a>
                                                    </form>

                                                    <!-- Search & Filter Bar -->
                                                    <div class="search-filter-bar">
                                                        <div class="search-box">
                                                            <i class="fas fa-search"></i>
                                                            <input type="text" id="searchInput"
                                                                placeholder="Tìm kiếm theo tên bệnh nhân, mã cuộc hẹn..."
                                                                onkeyup="searchCompletedAppointments()">
                                                        </div>
                                                        <div class="filter-stats">
                                                            <i class="fas fa-check-circle"></i>
                                                            <span id="resultCount">
                                                                <%= totalCompleted %> kết quả
                                                            </span>
                                                        </div>
                                                    </div>

                                                    <% if (error !=null) { %>
                                                        <div class="alert alert-danger">
                                                            <i class="fas fa-exclamation-circle me-2"></i>
                                                            <%= error %>
                                                        </div>
                                                        <% } %>

                                                            <!-- Results Grid -->
                                                            <div id="appointmentCards">
                                                                <% if (completedAppointments != null && !completedAppointments.isEmpty()) {
                                                                    for (Appointment appointment : completedAppointments) {
                                                                        String timeSlot = "N/A";
                                                                        String workDateString = "N/A";
                                                                        if (appointment.getStartTime() != null && appointment.getEndTime() != null) {
                                                                            timeSlot = appointment.getStartTime() + " - " + appointment.getEndTime();
                                                                        }
                                                                        if (appointment.getWorkDate() != null) {
                                                                            workDateString = appointment.getFormattedDate();
                                                                        }
                                                                %>
                                                                    <div class="result-card">
                                                                        <div class="result-card-header">
                                                                            <span class="result-time-badge">
                                                                                <i class="fas fa-clock"></i>
                                                                                <%= timeSlot %> | <%= workDateString %>
                                                                            </span>
                                                                            <span class="result-status-badge">
                                                                                <i class="fas fa-check-circle"></i>
                                                                                Hoàn thành
                                                                            </span>
                                                                        </div>
                                                                        <div class="result-card-body">
                                                                            <img src="${pageContext.request.contextPath}/img/default-avatar.png" class="result-avatar"
                                                                                onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'" alt="avatar">
                                                                            <div class="result-info">
                                                                                <h6 class="result-patient-name"><%= appointment.getPatientName() != null ? appointment.getPatientName() : "Không có tên" %></h6>
                                                                                <div class="result-appointment-id">#<%= appointment.getAppointmentId() %></div>
                                                                                <p class="result-reason">
                                                                                    <i class="fas fa-comment-medical"></i>
                                                                                    <%= appointment.getReason() != null ? appointment.getReason() : "Khám tổng quát" %>
                                                                                </p>
                                                                            </div>
                                                                            <a href="${pageContext.request.contextPath}/ViewReportServlet?appointmentId=<%= appointment.getAppointmentId() %>" class="result-action-btn">
                                                                                <i class="fas fa-file-medical"></i>
                                                                                Xem kết quả
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                <% }
                                                                } else { %>
                                                                        <div class="empty-state">
                                                                            <div class="empty-state-icon">
                                                                                <i class="fas fa-clipboard-check"></i>
                                                                            </div>
                                                                            <h5>Chưa có kết quả khám nào</h5>
                                                                            <p>Danh sách kết quả khám sẽ hiển thị sau
                                                                                khi hoàn thành các cuộc hẹn.</p>
                                                                        </div>
                                                                        <% } %>
                                                            </div>
                                                </div>
                                        </main>
                                </div>

                                <%@ include file="/includes/dashboard_scripts.jsp" %>

                                    <script>
                                        function searchCompletedAppointments() {
                                            const input = document.getElementById('searchInput');
                                            const filter = input.value.toLowerCase();
                                            const cards = document.querySelectorAll('.result-card');

                                            let visibleCount = 0;
                                            cards.forEach(card => {
                                                const text = card.textContent.toLowerCase();
                                                const isVisible = text.includes(filter);
                                                card.style.display = isVisible ? '' : 'none';
                                                if (isVisible) visibleCount++;
                                            });

                                            // Update count
                                            const countElement = document.getElementById('resultCount');
                                            if (countElement) {
                                                countElement.textContent = visibleCount + ' kết quả';
                                            }
                                        }
                                    </script>
                            </body>

                            </html>