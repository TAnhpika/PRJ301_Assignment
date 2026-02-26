<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Báo cáo Hệ thống - Manager</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/manager/manager_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/manager/manager_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-chart-bar me-2"></i>Báo cáo Hệ thống</h4>
                        <p class="text-muted mb-0">Báo cáo tổng hợp về hoạt động của hệ thống nha khoa</p>
                    </div>
                </div>
                
                <!-- Date Filter -->
                <div class="dashboard-card mb-4">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label">Khoảng thời gian</label>
                            <select class="form-select" id="timeRange" onchange="toggleCustomDate()">
                                <option value="today">Hôm nay</option>
                                <option value="week">Tuần này</option>
                                <option value="month" selected>Tháng này</option>
                                <option value="quarter">Quý này</option>
                                <option value="year">Năm nay</option>
                                <option value="custom">Tùy chỉnh</option>
                            </select>
                        </div>
                        <div class="col-md-3" id="startDateGroup" style="display: none;">
                            <label class="form-label">Từ ngày</label>
                            <input type="date" class="form-control" id="startDate">
                        </div>
                        <div class="col-md-3" id="endDateGroup" style="display: none;">
                            <label class="form-label">Đến ngày</label>
                            <input type="date" class="form-control" id="endDate">
                        </div>
                        <div class="col-md-3">
                            <button class="btn-dashboard btn-dashboard-primary" onclick="updateReport()">
                                <i class="fas fa-sync-alt"></i> Cập nhật
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-2">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-card-value">${totalPatients != null ? totalPatients : '0'}</div>
                            <div class="stat-card-label">Tổng bệnh nhân</div>
                            <small class="text-success"><i class="fas fa-arrow-up"></i> +${newPatientsThisMonth != null ? newPatientsThisMonth : '0'} tháng này</small>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-2">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-card-value">${totalAppointments != null ? totalAppointments : '0'}</div>
                            <div class="stat-card-label">Lịch hẹn</div>
                            <small class="text-success"><i class="fas fa-check"></i> ${completedAppointments != null ? completedAppointments : '0'} hoàn thành</small>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-2">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                            <div class="stat-card-value">${totalRevenue != null ? totalRevenue : '0'}</div>
                            <div class="stat-card-label">Doanh thu (VNĐ)</div>
                            <small class="text-success"><i class="fas fa-arrow-up"></i> +${revenueGrowth != null ? revenueGrowth : '0'}%</small>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-2">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="stat-card-value">${totalDoctors != null ? totalDoctors : '0'}</div>
                            <div class="stat-card-label">Bác sĩ</div>
                            <small class="text-muted">${activeDoctors != null ? activeDoctors : '0'} đang làm việc</small>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-2">
                        <div class="stat-card danger">
                            <div class="stat-card-icon">
                                <i class="fas fa-pills"></i>
                            </div>
                            <div class="stat-card-value">${totalMedicines != null ? totalMedicines : '0'}</div>
                            <div class="stat-card-label">Loại thuốc</div>
                            <small class="text-warning">${lowStockMedicines != null ? lowStockMedicines : '0'} cần nhập</small>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-2">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
                            <div class="stat-card-value">${totalServices != null ? totalServices : '0'}</div>
                            <div class="stat-card-label">Dịch vụ</div>
                            <small class="text-muted">${activeServices != null ? activeServices : '0'} đang hoạt động</small>
                        </div>
                    </div>
                </div>
                
                <!-- Charts Row -->
                <div class="row g-4 mb-4">
                    <div class="col-lg-8">
                        <div class="dashboard-card h-100">
                            <h6 class="mb-3"><i class="fas fa-chart-line me-2"></i>Lịch hẹn theo tháng</h6>
                            <canvas id="appointmentsChart" height="300"></canvas>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="dashboard-card h-100">
                            <h6 class="mb-3"><i class="fas fa-chart-pie me-2"></i>Doanh thu theo dịch vụ</h6>
                            <canvas id="revenueChart" height="300"></canvas>
                        </div>
                    </div>
                </div>
                
                <!-- Reports Row -->
                <div class="row g-4 mb-4">
                    <div class="col-md-6">
                        <div class="dashboard-card">
                            <h6 class="mb-3"><i class="fas fa-chart-bar me-2"></i>Thống kê lịch hẹn</h6>
                            <table class="dashboard-table">
                                <tbody>
                                    <tr>
                                        <td>Tổng lịch hẹn</td>
                                        <td class="text-end fw-bold text-primary">${totalAppointments != null ? totalAppointments : '0'}</td>
                                    </tr>
                                    <tr>
                                        <td>Đã hoàn thành</td>
                                        <td class="text-end fw-bold text-success">${completedAppointments != null ? completedAppointments : '0'}</td>
                                    </tr>
                                    <tr>
                                        <td>Đã hủy</td>
                                        <td class="text-end fw-bold text-danger">${cancelledAppointments != null ? cancelledAppointments : '0'}</td>
                                    </tr>
                                    <tr>
                                        <td>Chờ thanh toán</td>
                                        <td class="text-end fw-bold text-warning">${pendingPayments != null ? pendingPayments : '0'}</td>
                                    </tr>
                                    <tr>
                                        <td>Tỷ lệ hoàn thành</td>
                                        <td class="text-end fw-bold text-info">${completionRate != null ? completionRate : '0'}%</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="dashboard-card">
                            <h6 class="mb-3"><i class="fas fa-money-bill-wave me-2"></i>Thống kê tài chính</h6>
                            <table class="dashboard-table">
                                <tbody>
                                    <tr>
                                        <td>Tổng doanh thu</td>
                                        <td class="text-end fw-bold text-primary">${totalRevenue != null ? totalRevenue : '0'} VNĐ</td>
                                    </tr>
                                    <tr>
                                        <td>Doanh thu TB/ngày</td>
                                        <td class="text-end fw-bold text-success">${avgDailyRevenue != null ? avgDailyRevenue : '0'} VNĐ</td>
                                    </tr>
                                    <tr>
                                        <td>Dịch vụ bán chạy nhất</td>
                                        <td class="text-end fw-bold">${topService != null ? topService : 'N/A'}</td>
                                    </tr>
                                    <tr>
                                        <td>Số hóa đơn</td>
                                        <td class="text-end fw-bold text-info">${totalBills != null ? totalBills : '0'}</td>
                                    </tr>
                                    <tr>
                                        <td>Tỷ lệ thanh toán</td>
                                        <td class="text-end fw-bold text-success">${paymentRate != null ? paymentRate : '0'}%</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <!-- Export Section -->
                <div class="dashboard-card">
                    <h6 class="mb-3"><i class="fas fa-download me-2"></i>Xuất báo cáo</h6>
                    <div class="d-flex gap-3 flex-wrap">
                        <button class="btn btn-danger" onclick="exportReport('pdf')">
                            <i class="fas fa-file-pdf me-2"></i>Xuất PDF
                        </button>
                        <button class="btn btn-success" onclick="exportReport('excel')">
                            <i class="fas fa-file-excel me-2"></i>Xuất Excel
                        </button>
                        <button class="btn btn-info text-white" onclick="exportReport('csv')">
                            <i class="fas fa-file-csv me-2"></i>Xuất CSV
                        </button>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        // Toggle custom date inputs
        function toggleCustomDate() {
            var timeRange = document.getElementById('timeRange').value;
            var startDateGroup = document.getElementById('startDateGroup');
            var endDateGroup = document.getElementById('endDateGroup');
            
            if (timeRange === 'custom') {
                startDateGroup.style.display = 'block';
                endDateGroup.style.display = 'block';
            } else {
                startDateGroup.style.display = 'none';
                endDateGroup.style.display = 'none';
            }
        }
        
        // Update report data
        function updateReport() {
            var timeRange = document.getElementById('timeRange').value;
            var url = '${pageContext.request.contextPath}/ManagerReportServlet?timeRange=' + timeRange;
            
            if (timeRange === 'custom') {
                var startDate = document.getElementById('startDate').value;
                var endDate = document.getElementById('endDate').value;
                url += '&startDate=' + startDate + '&endDate=' + endDate;
            }
            
            window.location.href = url;
        }
        
        // Export report
        function exportReport(format) {
            var timeRange = document.getElementById('timeRange').value;
            var url = '${pageContext.request.contextPath}/ExportReportServlet?format=' + format + '&timeRange=' + timeRange;
            
            if (timeRange === 'custom') {
                var startDate = document.getElementById('startDate').value;
                var endDate = document.getElementById('endDate').value;
                url += '&startDate=' + startDate + '&endDate=' + endDate;
            }
            
            window.open(url, '_blank');
        }
        
        // Initialize charts
        document.addEventListener('DOMContentLoaded', function() {
            // Appointments Chart
            var appointmentsCtx = document.getElementById('appointmentsChart').getContext('2d');
            new Chart(appointmentsCtx, {
                type: 'line',
                data: {
                    labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
                    datasets: [{
                        label: 'Lịch hẹn',
                        data: [65, 78, 90, 85, 95, 110, 120, 115, 125, 135, 140, 150],
                        borderColor: '#4361ee',
                        backgroundColor: 'rgba(67, 97, 238, 0.1)',
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
            
            // Revenue Chart
            var revenueCtx = document.getElementById('revenueChart').getContext('2d');
            new Chart(revenueCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Nha khoa tổng quát', 'Chỉnh nha', 'Nha chu', 'Phục hình', 'Khác'],
                    datasets: [{
                        data: [35, 25, 20, 15, 5],
                        backgroundColor: ['#4361ee', '#3f37c9', '#4895ef', '#4cc9f0', '#7209b7']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
            
            // Set default dates
            var today = new Date().toISOString().split('T')[0];
            document.getElementById('startDate').value = today;
            document.getElementById('endDate').value = today;
        });
    </script>
</body>
</html>
