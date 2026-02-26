<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.Appointment" %>
<%@page import="java.util.List" %>
<%@page import="model.Doctors" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Lịch khám của tôi - Happy Smile</title>
    <style>
        .dashboard {
            padding: 20px 35px 30px 290px;
            max-width: 100%;
            margin: 0 auto;
        }

        h2, h3 {
            color: #2c5282;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
            box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
            border-radius: 6px;
            overflow: hidden;
            margin-bottom: 15px;
            border: 1px solid #ddd;
        }

        table thead {
            background: #4E80EE;
            color: white;
        }

        table th {
            padding: 15px 14px;
            font-weight: 600;
            text-align: left;
            font-size: 17px;
            border-right: 1px solid rgba(255, 255, 255, 0.3);
        }

        table th:last-child {
            border-right: none;
        }

        table th.col-action {
            white-space: nowrap;
            min-width: 120px;
        }

        table td {
            padding: 14px;
            border-bottom: 1px solid #ddd;
            border-right: 1px solid #ddd;
            font-size: 16px;
        }

        table td:last-child {
            border-right: none;
        }

        table tbody tr:last-child td {
            border-bottom: none;
        }

        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 20px 0;
            gap: 10px;
        }

        .pagination {
            display: flex;
            align-items: center;
            gap: 8px;
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .pagination a,
        .pagination button {
            padding: 8px 12px;
            border: 1px solid #cbd5e0;
            background: #f8fafc;
            color: #4a5568;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 36px;
            height: 36px;
        }

        .pagination a:hover,
        .pagination button:hover {
            background: #e2e8f0;
            border-color: #4E80EE;
            transform: translateY(-1px);
        }

        .pagination a.active {
            background: #4E80EE;
            color: white;
            border-color: #4E80EE;
            font-weight: 600;
        }

        .pagination button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .page-info {
            margin: 0 10px;
            color: #718096;
            font-size: 14px;
            font-weight: 500;
        }

        .empty-message {
            text-align: center;
            padding: 30px;
            color: #718096;
            background: #f8fafc;
            border-radius: 6px;
            font-size: 17px;
            margin: 15px 0;
            border: 1px dashed #cbd5e0;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
        }
        .status-booked { background: #dbeafe; color: #1d4ed8; }
        .status-completed { background: #d1fae5; color: #047857; }
        .status-cancelled { background: #fee2e2; color: #b91c1c; }
        .status-default { background: #f1f5f9; color: #475569; }

        .reason-text {
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .reason-text[title] { cursor: help; }

        .btn-report {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 6px 12px;
            font-size: 13px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
            border: 1px solid #4E80EE;
            background: #fff;
            color: #4E80EE;
        }
        .btn-report:hover {
            background: #4E80EE;
            color: #fff;
        }

        @media (max-width: 1200px) {
            .dashboard {
                padding-left: 240px;
            }
        }

        @media (max-width: 768px) {
            .dashboard {
                padding-left: 20px;
                padding-right: 20px;
            }
        }
    </style>
</head>

<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/patient/user_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/patient/user_header.jsp" %>
            
            <div class="dashboard-content">
                <div class="dashboard">
                    <h2>Danh sách lịch hẹn của bạn</h2>

                    <% 
                        List<Appointment> appointment = (List<Appointment>) request.getAttribute("appointment");
                        int itemsPerPage = 5;
                        int currentPage = 1;
                        String pageParam = request.getParameter("page");
                        if (pageParam != null && !pageParam.isEmpty()) {
                            try {
                                currentPage = Integer.parseInt(pageParam);
                            } catch (NumberFormatException e) {
                                currentPage = 1;
                            }
                        }

                        if (appointment != null && !appointment.isEmpty()) {
                            int totalItems = appointment.size();
                            int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
                            int startIndex = (currentPage - 1) * itemsPerPage;
                            int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
                            List<Appointment> pageAppointments = appointment.subList(startIndex, endIndex);
                    %>

                    <table>
                        <thead>
                            <tr>
                                <th>Bác sĩ</th>
                                <th>Ngày</th>
                                <th>Giờ</th>
                                <th>Trạng thái</th>
                                <th>Lý do</th>
                                <th class="col-action">Xem báo cáo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Appointment ap : pageAppointments) {
                                String reason = ap.getReason();
                                String reasonDisplay = (reason != null && reason.contains("|")) ? reason.substring(0, reason.indexOf("|")).trim() : (reason != null ? reason : "");
                                if (reasonDisplay.isEmpty() && reason != null) reasonDisplay = reason;
                                String status = ap.getStatus() != null ? ap.getStatus().toUpperCase() : "";
                                String statusClass = "status-default";
                                String statusLabel = ap.getStatus() != null ? ap.getStatus() : "";
                                if (status.contains("BOOKED") || status.contains("PENDING")) { statusClass = "status-booked"; statusLabel = "Đã đặt"; }
                                else if (status.contains("COMPLETED") || status.contains("DONE")) { statusClass = "status-completed"; statusLabel = "Hoàn thành"; }
                                else if (status.contains("CANCEL")) { statusClass = "status-cancelled"; statusLabel = "Đã hủy"; }
                            %>
                                <tr>
                                    <td><%= ap.getDoctorName() != null ? ap.getDoctorName() : "Chưa có thông tin" %></td>
                                    <td><%= ap.getFormattedWorkDate() %></td>
                                    <td><%= ap.getFormattedTimeRange() %></td>
                                    <td><span class="status-badge <%= statusClass %>"><%= statusLabel %></span></td>
                                    <td><span class="reason-text" title="<%= reason != null ? reason.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;") : "" %>"><%= reasonDisplay %></span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/MedicalReportDetailServlet?appointmentId=<%= ap.getAppointmentId() %>" class="btn-report">
                                            <i class="fas fa-file-medical-alt"></i> Xem báo cáo
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>

                    <!-- Pagination for personal appointments -->
                    <% if (totalPages > 1) { %>
                        <div class="pagination-container">
                            <div class="pagination">
                                <!-- Previous button -->
                                <% if (currentPage > 1) { %>
                                    <a href="?page=<%= currentPage - 1 %>">← Trước</a>
                                <% } else { %>
                                    <button disabled>← Trước</button>
                                <% } %>

                                <!-- Page numbers -->
                                <% 
                                    int startPage = Math.max(1, currentPage - 2);
                                    int endPage = Math.min(totalPages, currentPage + 2);
                                    for (int i = startPage; i <= endPage; i++) {
                                        if (i == currentPage) {
                                %>
                                    <a href="?page=<%= i %>" class="active"><%= i %></a>
                                <% } else { %>
                                    <a href="?page=<%= i %>"><%= i %></a>
                                <% } } %>

                                <!-- Next button -->
                                <% if (currentPage < totalPages) { %>
                                    <a href="?page=<%= currentPage + 1 %>">Sau →</a>
                                <% } else { %>
                                    <button disabled>Sau →</button>
                                <% } %>

                                <span class="page-info">
                                    Trang <%= currentPage %> / <%= totalPages %>
                                    (Hiển thị <%= startIndex + 1 %>-<%= endIndex %> trong <%= totalItems %> lịch hẹn)
                                </span>
                            </div>
                        </div>
                    <% } %>

                    <% } else { %>
                        <p class="empty-message">Bạn chưa có lịch hẹn nào.</p>
                    <% } %>

                    <!-- Lịch khám của người thân -->
                    <div style="margin-top: 40px;">
                        <h3>Lịch khám của người thân</h3>

                        <% 
                            List<Appointment> relativeAppointments = (List<Appointment>) request.getAttribute("relativeAppointments");
                            int relativePage = 1;
                            String relativePageParam = request.getParameter("relativePage");
                            if (relativePageParam != null && !relativePageParam.isEmpty()) {
                                try {
                                    relativePage = Integer.parseInt(relativePageParam);
                                } catch (NumberFormatException e) {
                                    relativePage = 1;
                                }
                            }

                            if (relativeAppointments != null && !relativeAppointments.isEmpty()) {
                                int relativeTotalItems = relativeAppointments.size();
                                int relativeTotalPages = (int) Math.ceil((double) relativeTotalItems / itemsPerPage);
                                int relativeStartIndex = (relativePage - 1) * itemsPerPage;
                                int relativeEndIndex = Math.min(relativeStartIndex + itemsPerPage, relativeTotalItems);
                                List<Appointment> pageRelativeAppointments = relativeAppointments.subList(relativeStartIndex, relativeEndIndex);
                        %>

                        <table>
                            <thead>
                                <tr>
                                    <th>Người khám</th>
                                    <th>Bác sĩ</th>
                                    <th>Ngày khám</th>
                                    <th>Khung giờ</th>
                                    <th>Trạng thái</th>
                                    <th class="col-action">Xem báo cáo</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Appointment ap : pageRelativeAppointments) {
                                    String status = ap.getStatus() != null ? ap.getStatus().toUpperCase() : "";
                                    String statusClass = "status-default";
                                    String statusLabel = ap.getStatus() != null ? ap.getStatus() : "";
                                    if (status.contains("BOOKED") || status.contains("PENDING")) { statusClass = "status-booked"; statusLabel = "Đã đặt"; }
                                    else if (status.contains("COMPLETED") || status.contains("DONE")) { statusClass = "status-completed"; statusLabel = "Hoàn thành"; }
                                    else if (status.contains("CANCEL")) { statusClass = "status-cancelled"; statusLabel = "Đã hủy"; }
                                %>
                                    <tr>
                                        <td><%= ap.getPatientName() != null ? ap.getPatientName() : "Chưa có thông tin" %></td>
                                        <td><%= ap.getDoctorName() != null ? ap.getDoctorName() : "Chưa có thông tin" %></td>
                                        <td><%= ap.getFormattedWorkDate() %></td>
                                        <td><%= ap.getFormattedTimeRange() %></td>
                                        <td><span class="status-badge <%= statusClass %>"><%= statusLabel %></span></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/MedicalReportDetailServlet?appointmentId=<%= ap.getAppointmentId() %>" class="btn-report">
                                                <i class="fas fa-file-medical-alt"></i> Xem báo cáo
                                            </a>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>

                        <!-- Pagination for relative appointments -->
                        <% if (relativeTotalPages > 1) { %>
                            <div class="pagination-container">
                                <div class="pagination">
                                    <!-- Previous button -->
                                    <% if (relativePage > 1) { %>
                                        <a href="?relativePage=<%= relativePage - 1 %>&page=<%= currentPage %>">← Trước</a>
                                    <% } else { %>
                                        <button disabled>← Trước</button>
                                    <% } %>

                                    <!-- Page numbers -->
                                    <% 
                                        int relativeStartPage = Math.max(1, relativePage - 2);
                                        int relativeEndPage = Math.min(relativeTotalPages, relativePage + 2);
                                        for (int i = relativeStartPage; i <= relativeEndPage; i++) {
                                            if (i == relativePage) {
                                    %>
                                        <a href="?relativePage=<%= i %>&page=<%= currentPage %>" class="active"><%= i %></a>
                                    <% } else { %>
                                        <a href="?relativePage=<%= i %>&page=<%= currentPage %>"><%= i %></a>
                                    <% } } %>

                                    <!-- Next button -->
                                    <% if (relativePage < relativeTotalPages) { %>
                                        <a href="?relativePage=<%= relativePage + 1 %>&page=<%= currentPage %>">Sau →</a>
                                    <% } else { %>
                                        <button disabled>Sau →</button>
                                    <% } %>

                                    <span class="page-info">
                                        Trang <%= relativePage %> / <%= relativeTotalPages %>
                                        (Hiển thị <%= relativeStartIndex + 1 %>-<%= relativeEndIndex %> trong <%= relativeTotalItems %> lịch hẹn)
                                    </span>
                                </div>
                            </div>
                        <% } %>

                        <% } else { %>
                            <p class="empty-message">Hiện bạn chưa có lịch khám cho người thân.</p>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
</body>
</html>
