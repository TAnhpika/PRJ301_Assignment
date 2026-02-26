<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/includes/dashboard_head.jsp" %>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch trong ngày - Doctor</title>
        <style>
            /* --- Giao diện văn phòng: tông trung tính, ít màu chói --- */
            .container {
                max-width: 100%;
            }
            .title {
                display: flex;
                margin-bottom: 16px;
                justify-content: space-between;
                align-items: center;
                gap: 20px;
            }

            .title-1, .title-2 {
                flex: 1;
                text-align: center;
            }

            .title-1 h3, .title-2 h3 {
                margin: 0;
                padding: 12px 16px;
                color: #1e293b;
                border-radius: 8px;
                font-size: 15px;
                font-weight: 600;
                border: 1px solid #e2e8f0;
                background: #f8fafc;
            }

            .title-1 h3 {
                border-left: 4px solid #64748b;
                background: #f1f5f9;
            }

            .title-2 h3 {
                border-left: 4px solid #0d9488;
                background: #f0fdfa;
            }

            .content { margin-bottom: 15px; }
            .content p { color: #475569; }
            .content h2 {
                color: #334155;
                margin-bottom: 20px;
                font-size: 22px;
                font-weight: 600;
            }
            .content .subtitle {
                color: #64748b;
                font-size: 14px;
                margin-bottom: 20px;
            }

            .refresh-info {
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 8px 12px;
                font-size: 12px;
                color: #64748b;
                margin-bottom: 20px;
                text-align: center;
            }

            .debug-info {
                background: #f1f5f9;
                border: 1px solid #cbd5e1;
                border-radius: 8px;
                padding: 10px;
                margin-bottom: 20px;
                font-size: 12px;
            }
            .debug-info h5 { color: #475569; margin: 0 0 10px 0; }

            .alert {
                padding: 12px;
                margin-bottom: 20px;
                border-radius: 6px;
                border: 1px solid transparent;
            }
            .alert-danger {
                color: #991b1b;
                background: #fef2f2;
                border-color: #fecaca;
            }
            .alert-info {
                color: #155e75;
                background: #f0f9ff;
                border-color: #bae6fd;
            }

            .badge-test {
                background: #fef3c7;
                color: #92400e;
                padding: 2px 6px;
                border-radius: 4px;
                font-size: 10px;
                font-weight: 600;
                margin-left: 5px;
            }

            .status-filter {
                margin-top: 10px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .cards {
                display: flex;
                gap: 20px;
                min-height: 400px;
                align-items: stretch;
            }

            .cards-column {
                flex: 1;
                display: flex;
                flex-direction: column;
                gap: 16px;
                min-height: 400px;
                max-width: calc(50% - 10px);
            }

            .single-card {
                background: #fff;
                padding: 18px;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.06);
                transition: border-color 0.2s ease, box-shadow 0.2s ease;
                height: fit-content;
                min-height: 200px;
            }

            .single-card:hover {
                border-color: #cbd5e1;
                box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            }

            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .badge {
                padding: 4px 10px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
            }
            .badge.waiting {
                background: #e0f2fe;
                color: #0369a1;
            }
            .badge.done {
                background: #ccfbf1;
                color: #0f766e;
            }
            .badge.cancelled {
                background: #fee2e2;
                color: #b91c1c;
            }

            .info {
                display: flex;
                margin-top: 12px;
                gap: 12px;
            }
            .info img {
                width: 56px;
                height: 56px;
                border-radius: 50%;
                object-fit: cover;
                border: 1px solid #e2e8f0;
            }
            .info-details { flex: 1; }
            .info-details p {
                margin: 4px 0;
                font-size: 14px;
                color: #475569;
            }

            .actions {
                margin-top: 14px;
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }
            .actions button, .actions a {
                padding: 8px 14px;
                border: 1px solid transparent;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 500;
                cursor: pointer;
                transition: background 0.2s ease, border-color 0.2s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }
            .btn-blue {
                background: #4E80EE;
                color: #fff;
                border-color: #4E80EE;
            }
            .btn-blue:hover {
                background: #3D6FDD;
                border-color: #3D6FDD;
            }
            .btn-green {
                background: #0d9488;
                color: #fff;
                border-color: #0d9488;
            }
            .btn-green:hover {
                background: #0f766e;
                border-color: #0f766e;
            }
            .btn-red {
                background: #dc2626;
                color: #fff;
                border-color: #dc2626;
            }
            .btn-red:hover {
                background: #b91c1c;
                border-color: #b91c1c;
            }
            .btn-gray {
                background: #f1f5f9;
                color: #475569;
                border-color: #e2e8f0;
            }
            .btn-gray:hover {
                background: #e2e8f0;
                border-color: #cbd5e1;
            }

            .no-appointments {
                text-align: center;
                padding: 40px;
                color: #64748b;
                background: #f8fafc;
                border-radius: 8px;
                border: 1px dashed #e2e8f0;
                min-height: 150px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }
            .no-appointments i {
                font-size: 40px;
                margin-bottom: 12px;
                color: #cbd5e1;
            }
            .no-appointments h4 { margin: 0 0 8px 0; color: #64748b; font-weight: 600; }
            .no-appointments p { margin: 0; font-size: 14px; color: #94a3b8; }

            .stats {
                display: flex;
                gap: 16px;
                margin-bottom: 24px;
            }

            .stat-card {
                background: #fff;
                padding: 18px 20px;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.06);
                flex: 1;
                text-align: center;
                cursor: default;
                transition: border-color 0.2s ease;
            }

            .stat-card:hover {
                border-color: #cbd5e1;
            }

            .stat-card.clickable {
                cursor: pointer;
            }

            .stat-card.completed {
                border-left: 4px solid #0d9488;
            }

            .stat-card.completed::after {
                content: "Xem kết quả";
                display: block;
                margin-top: 6px;
                font-size: 11px;
                color: #0d9488;
                opacity: 0;
                transition: opacity 0.2s ease;
            }

            .stat-card.completed:hover::after {
                opacity: 1;
            }

            .stat-number {
                font-size: 26px;
                font-weight: 700;
                color: #334155;
                letter-spacing: -0.02em;
            }

            .stat-label {
                font-size: 13px;
                color: #64748b;
                margin-top: 6px;
                font-weight: 500;
            }

            /* Date selector */
            .date-selector {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }
            .date-selector label {
                font-weight: 600;
                color: #334155;
                font-size: 14px;
            }
            .date-selector input[type="date"] {
                padding: 8px 12px;
                border: 1px solid #e2e8f0;
                border-radius: 6px;
                font-size: 14px;
                color: #334155;
            }
            .date-selector .btn-date {
                padding: 8px 16px;
                border: 1px solid #64748b;
                border-radius: 6px;
                background: #f8fafc;
                color: #334155;
                cursor: pointer;
                font-size: 13px;
                font-weight: 500;
            }
            .date-selector .btn-date:hover {
                background: #e2e8f0;
            }
            .date-selector .btn-date.today {
                background: #0d9488;
                color: white;
                border-color: #0d9488;
            }
            .date-selector .btn-date.today:hover {
                background: #0f766e;
            }
            .date-current-label {
                font-size: 16px;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 16px;
            }
            .date-current-label .badge-today {
                background: #0d9488;
                color: white;
                padding: 2px 8px;
                border-radius: 4px;
                font-size: 12px;
                margin-left: 8px;
            }

        </style>
    </head>
    <body>
        <div class="dashboard-wrapper">
            <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
            <main class="dashboard-main">
                <%@ include file="/jsp/doctor/doctor_header.jsp" %>
                <div class="dashboard-content">
                    <div class="container">

            <%
                List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                String error = (String) request.getAttribute("error");
                String selectedDate = (String) request.getAttribute("selectedDate");
                String selectedDateDisplay = (String) request.getAttribute("selectedDateDisplay");
                Boolean isToday = (Boolean) request.getAttribute("isToday");
                Integer userId = (Integer) request.getAttribute("userId");
                
                if (selectedDate == null) selectedDate = "";
                if (selectedDateDisplay == null) selectedDateDisplay = "";
                if (isToday == null) isToday = false;
                
                int totalAppointments = appointments != null ? appointments.size() : 0;
                int waitingCount = 0;
                int completedCount = 0;
                int cancelledCount = 0;
                int todayCount = 0;
                
                if (appointments != null) {
                    for (Appointment app : appointments) {
                        if ("booked".equalsIgnoreCase(app.getStatus())) {
                            waitingCount++;
                        } else if ("completed".equalsIgnoreCase(app.getStatus())) {
                            completedCount++;
                        } else if ("cancelled".equalsIgnoreCase(app.getStatus())) {
                            cancelledCount++;
                        }
                    }
                    todayCount = isToday ? totalAppointments : 0;
                }
            %>

            <!-- Date selector: ngày hiện tại / theo lịch -->
            <div class="date-current-label">
                Lịch khám ngày: <strong><%= selectedDateDisplay.isEmpty() ? "—" : selectedDateDisplay %></strong>
                <% if (isToday) { %><span class="badge-today">Hôm nay</span><% } %>
            </div>
            <form method="get" action="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="date-selector">
                <label for="date">Chọn ngày:</label>
                <input type="date" id="date" name="date" value="<%= selectedDate %>" onchange="this.form.submit()">
                <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="btn-date today">Hôm nay</a>
            </form>

            <!-- Statistics -->
            <div class="stats">
                <div class="stat-card">
                    <div class="stat-number"><%=totalAppointments%></div>
                    <div class="stat-label">Tổng lượt khám</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%=todayCount%></div>
                    <div class="stat-label">Hôm nay</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%=waitingCount%></div>
                    <div class="stat-label">Đang chờ</div>
                </div>
                <div class="stat-card clickable completed" onclick="viewCompletedAppointments()">
                    <div class="stat-number"><%=completedCount%></div>
                    <div class="stat-label">Đã khám</div>
                </div>
            </div>

            <div class="title">
                <div class="title-1">
                    <h3>Đang chờ khám (<%=waitingCount%>)</h3>
                </div>
                <div class="title-2">
                    <h3>Đã khám xong (<%=completedCount%>)</h3>
                </div>
            </div>

            <div class="cards">
                <!-- Cột Đang chờ khám -->
                <div class="cards-column">
                    <%
                        boolean hasWaitingAppointments = false;
                        if (appointments != null && !appointments.isEmpty()) {
                            for (Appointment appointment : appointments) {
                                String status = appointment.getStatus();
                                
                                // Chỉ hiển thị appointments đang chờ (Đã đặt)
                                if ("booked".equalsIgnoreCase(status)) {
                                    hasWaitingAppointments = true;
                                    String badgeClass = "waiting";
                                    String statusText = "Đang chờ";
                                    
                                    // Lấy thời gian từ database thay vì hard-code
                                    String timeSlot = "N/A";
                                    if (appointment.getStartTime() != null && appointment.getEndTime() != null) {
                                        timeSlot = appointment.getStartTime() + " - " + appointment.getEndTime();
                                    }
                    %>

                    <div class="single-card">
                        <div class="card-header">
                            <p><strong><%=timeSlot%></strong></p>
                            <span class="badge <%=badgeClass%>"><%=statusText%></span>
                        </div>
                        <div class="info">
                            <img src="${pageContext.request.contextPath}/img/default-avatar.png" alt="avatar" style="width: 64px; height: 64px; object-fit: cover;" onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                            <div class="info-details">
                                <p><strong>Bệnh nhân: <%=appointment.getPatientName() != null ? appointment.getPatientName() : "Không có tên"%></strong></p>
                                <p>Mã cuộc hẹn: <%=appointment.getAppointmentId()%></p>
                                <p>Ngày khám: <%=appointment.getFormattedDate()%></p>
                                <p>Lý do: <%=appointment.getReason() != null ? appointment.getReason() : "Không có ghi chú"%></p>
                            </div>
                        </div>
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/jsp/doctor/doctor_phieukham.jsp?appointmentId=<%=appointment.getAppointmentId()%>" class="btn-blue">
                                <i class="fas fa-file-medical"></i> Tạo phiếu khám
                            </a>
                            <form method="post" action="${pageContext.request.contextPath}/updateAppointmentStatus" style="display: inline;">
                                <input type="hidden" name="appointmentId" value="<%=appointment.getAppointmentId()%>">
                                <input type="hidden" name="status" value="completed">
                                <button type="submit" class="btn-red" onclick="return confirm('Xác nhận hoàn tất cuộc hẹn #<%=appointment.getAppointmentId()%>?')">
                                    Đang chờ Khám
                                </button>
                            </form>
                           

                            <button class="btn-gray" onclick="viewDetails(<%=appointment.getAppointmentId()%>)" title="Chi tiết">
                                <i class="fas fa-info-circle"></i>
                            </button>
                        </div>
                    </div>

                    <%
                                }
                            }
                        }
                        
                        // Nếu không có appointments đang chờ
                        if (!hasWaitingAppointments) {
                    %>
                    <div class="no-appointments">
                        <i class="fas fa-clock"></i>
                        <h4>Không có lịch hẹn đang chờ</h4>

                    </div>
                    <%
                        }
                    %>
                </div>

                <!-- Cột Đã khám xong -->
                <div class="cards-column">
                    <%
                        boolean hasCompletedAppointments = false;
                        if (appointments != null && !appointments.isEmpty()) {
                            for (Appointment appointment : appointments) {
                                String status = appointment.getStatus();
                                
                                // Chỉ hiển thị appointments đã hoàn tất
                                if ("completed".equalsIgnoreCase(status)) {
                                    hasCompletedAppointments = true;
                                    String badgeClass = "done";
                                    String statusText = "Khám xong";
                                    
                                    // Lấy thời gian từ database thay vì hard-code
                                    String timeSlot = "N/A";
                                    if (appointment.getStartTime() != null && appointment.getEndTime() != null) {
                                        timeSlot = appointment.getStartTime() + " - " + appointment.getEndTime();
                                    }
                    %>

                    <div class="single-card">
                        <div class="card-header">
                            <p><strong><%=timeSlot%></strong></p>
                            <span class="badge <%=badgeClass%>"><%=statusText%></span>
                        </div>
                        <div class="info">
                            <img src="${pageContext.request.contextPath}/img/default-avatar.png" alt="avatar" style="width: 64px; height: 64px; object-fit: cover;" onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                            <div class="info-details">
                                <p><strong>Bệnh nhân: <%=appointment.getPatientName() != null ? appointment.getPatientName() : "Không có tên"%></strong></p>
                                <p>Mã cuộc hẹn: #<%=appointment.getAppointmentId()%></p>
                                <p>Ngày khám: <%=appointment.getFormattedDate()%></p>
                                <p>Lý do: <%=appointment.getReason() != null ? appointment.getReason() : "Không có ghi chú"%></p>
                            </div>
                        </div>
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/ViewReportServlet?appointmentId=<%=appointment.getAppointmentId()%>" class="btn-gray">
                                <i class="fas fa-eye"></i> Xem phiếu khám
                            </a>
                            <button class="btn-gray" onclick="viewDetails(<%=appointment.getAppointmentId()%>)" title="Chi tiết">
                                <i class="fas fa-info-circle"></i>
                            </button>
                        </div>
                    </div>

                    <%
                                }
                            }
                        }
                        
                        // Nếu không có appointments đã hoàn tất
                        if (!hasCompletedAppointments) {
                    %>
                    <div class="no-appointments">
                        <i class="fas fa-check-circle"></i>
                        <h4>Chưa có ca khám hoàn tất</h4>

                    </div>
                    <%
                        }
                    %>
                </div>                          
            </div>
                    </div>
                </div>
            </main>
        </div>

        <%@ include file="/includes/dashboard_scripts.jsp" %>
        <script>
            // Auto refresh every 5 minutes để cập nhật dữ liệu mới
            setTimeout(function () {
                location.reload();
            }, 300000);

            function viewCompletedAppointments() {
                // Chuyển tới trang xem kết quả khám
                window.location.href = '${pageContext.request.contextPath}/completedAppointments';
            }

            // Simple hover effects (optional)
            document.addEventListener('DOMContentLoaded', function () {
                // Add any simple effects here if needed
            });
        </script>
    </body>
</html>
