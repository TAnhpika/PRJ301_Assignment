<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User authUser = (User) session.getAttribute("user");
    if (authUser == null) {
        response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
        return;
    }
    String appointmentId = request.getParameter("appointmentId");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Không Tìm Thấy Báo Cáo - Happy Smile</title>
    <style>
        .error-container {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .error-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            text-align: center;
            max-width: 500px;
            width: 100%;
            border: 1px solid #eef2f6;
        }
        .error-icon {
            width: 80px;
            height: 80px;
            background: #fff1f2;
            color: #ef4444;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            font-size: 32px;
            margin: 0 auto 24px;
        }
        .error-card h3 {
            color: #1e293b;
            font-weight: 700;
            margin-bottom: 12px;
            font-size: 20px;
        }
        .error-card p {
            color: #64748b;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border-radius: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
            font-size: 14px;
        }
        .btn-primary-custom {
            background: #4E80EE;
            color: white;
            border: none;
        }
        .btn-primary-custom:hover {
            background: #3d6edd;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(78, 128, 238, 0.2);
            color: white;
        }
        .btn-outline-custom {
            border: 1.5px solid #e2e8f0;
            color: #475569;
            background: white;
        }
        .btn-outline-custom:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
            color: #1e293b;
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <% if ("DOCTOR".equalsIgnoreCase(authUser.getRole())) { %>
            <%@ include file="/view/jsp/doctor/doctor_menu.jsp" %>
        <% } else if ("STAFF".equalsIgnoreCase(authUser.getRole())) { %>
            <%@ include file="/view/jsp/admin/staff_menu.jsp" %>
        <% } %>
        
        <main class="dashboard-main">
            <% if ("DOCTOR".equalsIgnoreCase(authUser.getRole())) { %>
                <%@ include file="/view/jsp/doctor/doctor_header.jsp" %>
            <% } else if ("STAFF".equalsIgnoreCase(authUser.getRole())) { %>
                <%@ include file="/view/jsp/admin/staff_header.jsp" %>
            <% } %>

            <div class="dashboard-content">
                <div class="error-container">
                    <div class="error-card">
                        <div class="error-icon">
                            <i class="fas fa-file-medical-alt"></i>
                        </div>
                        <h3>Chưa có kết quả khám</h3>
                        <p>
                            Lịch hẹn này chưa được bác sĩ ghi nhận kết quả khám và đơn thuốc. 
                            Vui lòng kiểm tra lại sau hoặc liên hệ bác sĩ phụ trách.
                        </p>
                        
                        <div class="d-flex gap-3 justify-content-center flex-wrap">
                            <% if ("DOCTOR".equalsIgnoreCase(authUser.getRole()) && appointmentId != null) { %>
                                <a href="${pageContext.request.contextPath}/view/jsp/doctor/doctor_phieukham.jsp?appointmentId=<%= appointmentId %>" class="btn-action btn-primary-custom">
                                    <i class="fas fa-plus"></i> Tạo phiếu khám ngay
                                </a>
                            <% } %>
                            
                            <a href="javascript:history.back()" class="btn-action btn-outline-custom">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
</body>
</html>
