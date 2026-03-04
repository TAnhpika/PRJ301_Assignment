<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Thành công - Happy Smile</title>
    <style>
        .success-content-wrapper {
            min-height: calc(100vh - 150px);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .success-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 50px 40px;
            text-align: center;
            max-width: 550px;
            width: 100%;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .success-icon {
            font-size: 80px;
            color: #10b981;
            margin-bottom: 25px;
            display: inline-block;
            animation: scaleIn 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
        }

        @keyframes scaleIn {
            from { transform: scale(0); }
            to { transform: scale(1); }
        }

        .success-title {
            font-size: 28px;
            font-weight: 800;
            color: #10b981;
            margin-bottom: 15px;
        }

        .success-message {
            color: #64748b;
            margin-bottom: 40px;
            line-height: 1.8;
            font-size: 16px;
        }

        .success-actions {
            display: flex;
            gap: 16px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-success-page {
            padding: 14px 28px;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
            text-decoration: none;
        }

        .btn-success-primary {
            background-color: #4E80EE;
            color: white;
            border: none;
        }

        .btn-success-primary:hover {
            background-color: #3D6FDD;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(78, 128, 238, 0.3);
            color: white;
        }

        .btn-success-secondary {
            background-color: #f8fafc;
            color: #1e293b;
            border: 1px solid #e2e8f0;
        }

        .btn-success-secondary:hover {
            background-color: #f1f5f9;
            transform: translateY(-3px);
            color: #1e293b;
        }

        @media (max-width: 576px) {
            .success-actions { flex-direction: column; }
            .btn-success-page { width: 100%; justify-content: center; }
            .success-card { padding: 40px 20px; }
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="doctor_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="doctor_header.jsp" %>
            
            <div class="dashboard-content">
                <div class="success-content-wrapper">
                    <div class="success-card">
                        <div class="success-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <h2 class="success-title">Lưu phiếu khám thành công!</h2>
                        <p class="success-message">
                            Hồ sơ bệnh án và đơn thuốc của bệnh nhân đã được lưu trữ thành công vào hệ thống.
                            Kho thuốc cũng đã được tự động cập nhật số lượng tồn kho.
                        </p>
                        <div class="success-actions">
                            <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="btn-success-page btn-success-primary">
                                <i class="fas fa-list-ul"></i> Quay lại danh sách
                            </a>
                            <a href="${pageContext.request.contextPath}/completedAppointments" class="btn-success-page btn-success-secondary">
                                <i class="fas fa-file-medical-alt"></i> Xem kết quả khám
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