<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="model.User" %>
<%@page import="model.Service" %>
<%@page import="java.util.List" %>
<%@page import="dao.ServiceDAO" %>

<%
    User user = (User) session.getAttribute("user");

    // Nếu user truy cập trực tiếp URL .jsp (không qua ServiceServlet),
    // thì request sẽ không có sẵn attributes "services" và "categories" -> trang bị rỗng.
    // Fallback: tự load data từ DB để render được ngay trên URI .jsp.
    if (request.getAttribute("services") == null) {
        List<Service> services = ServiceDAO.getActiveServices();
        request.setAttribute("services", services);
    }
    if (request.getAttribute("categories") == null) {
        List<String> categories = ServiceDAO.getAllCategories();
        request.setAttribute("categories", categories);
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Dịch vụ Nha khoa - Happy Smile</title>
    <style>
        .service-card {
            border: 1px solid #e5e7eb;
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
            height: 100%;
        }
        .service-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(67, 97, 238, 0.15);
            border-color: #4361ee;
        }
        .service-image {
            height: 200px;
            object-fit: cover;
            width: 100%;
        }
        .service-placeholder {
            height: 200px;
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .service-category {
            background: linear-gradient(45deg, #4361ee, #3f37c9);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .price-tag {
            font-size: 20px;
            font-weight: 700;
            color: #059669;
        }
        .category-btn {
            margin: 5px;
            border-radius: 25px;
            padding: 8px 20px;
            border: 2px solid #e5e7eb;
            color: #6b7280;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .category-btn:hover {
            border-color: #4361ee;
            color: #4361ee;
        }
        .category-btn.active {
            background: linear-gradient(45deg, #4361ee, #3f37c9);
            border-color: #4361ee;
            color: white;
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/patient/user_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/patient/user_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Header Banner -->
                <div class="dashboard-card mb-4" style="background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%); color: white;">
                    <div class="text-center py-4">
                        <h2 class="mb-2"><i class="fas fa-tooth me-2"></i>Dịch vụ Nha khoa</h2>
                        <p class="mb-0 opacity-75">Chăm sóc răng miệng toàn diện với đội ngũ bác sĩ chuyên nghiệp</p>
                        <p class="mb-0 mt-2 small opacity-90"><i class="fas fa-route me-1"></i>Chọn dịch vụ → bấm <strong>Đặt lịch</strong> → chọn bác sĩ &amp; thời gian → thanh toán</p>
                    </div>
                </div>
                
                <!-- Search & Filter -->
                <div class="dashboard-card mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-6 mb-3 mb-md-0">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm dịch vụ...">
                            </div>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <button class="btn btn-outline-primary me-2" onclick="showAllServices()">
                                <i class="fas fa-list me-1"></i>Tất cả
                            </button>
                            <button class="btn btn-primary" onclick="resetSearch()">
                                <i class="fas fa-refresh me-1"></i>Làm mới
                            </button>
                        </div>
                    </div>
                    
                    <!-- Category Filter -->
                    <div class="mt-4">
                        <h6 class="mb-3"><i class="fas fa-filter me-2"></i>Lọc theo danh mục:</h6>
                        <button class="category-btn active" data-category="">Tất cả</button>
                        <c:forEach var="category" items="${categories}">
                            <button class="category-btn" data-category="${category}">${category}</button>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- Services Grid -->
                <div class="row g-4" id="servicesContainer">
                    <c:forEach var="service" items="${services}">
                        <div class="col-lg-4 col-md-6 service-item" data-category="${service.category}" data-name="${service.serviceName}" data-service-id="${service.serviceId}">
                            <div class="service-card dashboard-card p-0">
                                <c:choose>
                                    <c:when test="${not empty service.image}">
                                        <img src="${service.image}" class="service-image" alt="${service.serviceName}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="service-placeholder">
                                            <i class="fas fa-tooth fa-4x text-primary opacity-50"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="p-4">
                                    <div class="mb-2">
                                        <span class="service-category">${service.category}</span>
                                    </div>
                                    <h5 class="mb-2">${service.serviceName}</h5>
                                    <p class="text-muted small mb-3">
                                        <c:choose>
                                            <c:when test="${not empty service.description}">
                                                ${service.description}
                                            </c:when>
                                            <c:otherwise>
                                                <em>Chưa có mô tả chi tiết</em>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="price-tag">
                                            <fmt:formatNumber value="${service.price}" type="number" groupingUsed="true" /> VNĐ
                                        </span>
                                        <div>
                                            <button class="btn btn-sm btn-outline-primary view-detail-btn me-2" data-service-id="${service.serviceId}">
                                                <i class="fas fa-eye me-1"></i>Chi tiết
                                            </button>
                                            <a href="${pageContext.request.contextPath}/BookingPageServlet?serviceId=${service.serviceId}" class="btn btn-sm btn-primary">
                                                <i class="fas fa-calendar-plus me-1"></i>Đặt lịch
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <!-- No Results -->
                <div id="noResults" class="dashboard-card text-center py-5" style="display: none;">
                    <i class="fas fa-search text-muted" style="font-size: 48px;"></i>
                    <h5 class="mt-3 text-muted">Không tìm thấy dịch vụ nào</h5>
                    <p class="text-muted">Vui lòng thử tìm kiếm với từ khóa khác</p>
                </div>
                
                <!-- Back to Home -->
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/UserHompageServlet" class="btn btn-outline-primary">
                        <i class="fas fa-home me-2"></i>Về trang chủ
                    </a>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Service Detail Modal -->
    <div class="modal fade" id="serviceDetailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-info-circle me-2"></i>Chi tiết dịch vụ</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="serviceDetailContent">
                    <div class="text-center py-4">
                        <div class="spinner-border text-primary" role="status"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <a href="#" id="bookingLink" class="btn btn-success" onclick="goToBooking()">
                        <i class="fas fa-calendar-plus me-1"></i>Đặt lịch khám
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        let currentServiceId = null;

        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            filterServices(searchTerm, '');
        });

        document.querySelectorAll('.category-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                const category = this.dataset.category;
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                filterServices(searchTerm, category);
            });
        });

        function filterServices(searchTerm, category) {
            const serviceItems = document.querySelectorAll('.service-item');
            let visibleCount = 0;

            serviceItems.forEach(item => {
                const serviceName = item.dataset.name.toLowerCase();
                const serviceCategory = item.dataset.category;
                const matchesSearch = searchTerm === '' || serviceName.includes(searchTerm);
                const matchesCategory = category === '' || serviceCategory === category;

                if (matchesSearch && matchesCategory) {
                    item.style.display = 'block';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });

            document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
        }

        function showAllServices() {
            document.getElementById('searchInput').value = '';
            document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
            document.querySelector('.category-btn[data-category=""]').classList.add('active');
            filterServices('', '');
        }

        function resetSearch() {
            showAllServices();
        }

        document.querySelectorAll('.view-detail-btn').forEach(button => {
            button.addEventListener('click', function() {
                const serviceId = this.getAttribute('data-service-id');
                viewServiceDetail(serviceId);
            });
        });

        function goToBooking() {
            if (currentServiceId) {
                window.location.href = '${pageContext.request.contextPath}/BookingPageServlet?serviceId=' + currentServiceId;
            } else {
                window.location.href = '${pageContext.request.contextPath}/BookingPageServlet';
            }
        }

        function viewServiceDetail(serviceId) {
            currentServiceId = serviceId;
            const modal = new bootstrap.Modal(document.getElementById('serviceDetailModal'));
            document.getElementById('serviceDetailContent').innerHTML = '<div class="text-center py-4"><div class="spinner-border text-primary"></div></div>';
            modal.show();

            fetch('${pageContext.request.contextPath}/services?action=detail&id=' + serviceId + '&format=json')
                .then(response => response.json())
                .then(service => {
                    const priceStr = new Intl.NumberFormat('vi-VN').format(service.price);
                    document.getElementById('serviceDetailContent').innerHTML = `
                        <div class="row">
                            <div class="col-md-4">
                                <%= "$" %>{service.image
                                    ? '<img src="' + service.image + '" class="img-fluid rounded" alt="' + service.serviceName + '">'
                                    : '<div class="bg-light p-5 text-center rounded"><i class="fas fa-tooth fa-4x text-muted"></i></div>'
                                }
                            </div>
                            <div class="col-md-8">
                                <h4 class="text-primary"><i class="fas fa-tooth me-2"></i><%= "$" %>{service.serviceName}</h4>
                                <span class="badge bg-primary mb-3"><%= "$" %>{service.category}</span>
                                <div class="mb-3">
                                    <h6 class="text-muted">Mô tả dịch vụ:</h6>
                                    <p><%= "$" %>{service.description || 'Chưa có mô tả chi tiết'}</p>
                                </div>
                                <div class="mb-3">
                                    <h6 class="text-muted">Giá dịch vụ:</h6>
                                    <span class="fs-4 fw-bold text-success"><%= "$" %>{priceStr} VNĐ</span>
                                </div>
                                <div class="alert alert-info">
                                    <h6><i class="fas fa-lightbulb me-1"></i>Lưu ý:</h6>
                                    <ul class="mb-0 small">
                                        <li>Vui lòng đến đúng giờ hẹn</li>
                                        <li>Mang theo CMND/CCCD khi đến khám</li>
                                        <li>Có thể hủy lịch trước 24h</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    `;
                })
                .catch(error => {
                    document.getElementById('serviceDetailContent').innerHTML = `
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>Không thể tải thông tin dịch vụ.
                        </div>
                    `;
                });
        }
    </script>
</body>
</html>
