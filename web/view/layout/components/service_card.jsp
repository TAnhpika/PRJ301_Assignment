<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Service Card Component
    Reusable service display card
    
    Usage:
    <jsp:include page="/includes/components/service_card.jsp">
        <jsp:param name="serviceName" value="Trám răng"/>
        <jsp:param name="description" value="Trám răng sâu, răng bị mẻ"/>
        <jsp:param name="price" value="500,000"/>
        <jsp:param name="duration" value="30 phút"/>
        <jsp:param name="imageUrl" value="/img/services/tram-rang.jpg"/>
        <jsp:param name="bookUrl" value="/book?service=1"/>
        <jsp:param name="detailUrl" value="/service/1"/>
    </jsp:include>
--%>
<%
    String serviceName = request.getParameter("serviceName");
    String description = request.getParameter("description");
    String price = request.getParameter("price");
    String duration = request.getParameter("duration");
    String imageUrl = request.getParameter("imageUrl");
    String bookUrl = request.getParameter("bookUrl");
    String detailUrl = request.getParameter("detailUrl");
    String category = request.getParameter("category");
    String colClass = request.getParameter("colClass");
    
    if (serviceName == null) serviceName = "Dịch vụ";
    if (description == null) description = "";
    if (colClass == null) colClass = "col-12 col-md-6 col-lg-4";
    
    String defaultImage = request.getContextPath() + "/img/default-service.jpg";
    String imgSrc = (imageUrl != null && !imageUrl.isEmpty()) ? imageUrl : defaultImage;
%>

<div class="<%= colClass %>">
    <div class="dashboard-card service-card h-100">
        <% if (imageUrl != null && !imageUrl.isEmpty()) { %>
        <div class="service-image mb-3">
            <img src="<%= imgSrc %>" 
                 alt="<%= serviceName %>" 
                 class="w-100 rounded" 
                 style="height: 180px; object-fit: cover;"
                 onerror="this.src='${pageContext.request.contextPath}/img/default-service.jpg'">
        </div>
        <% } %>
        
        <% if (category != null && !category.isEmpty()) { %>
        <span class="badge bg-primary mb-2"><%= category %></span>
        <% } %>
        
        <h5 class="mb-2"><%= serviceName %></h5>
        
        <% if (!description.isEmpty()) { %>
        <p class="text-muted small mb-3 service-description" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
            <%= description %>
        </p>
        <% } %>
        
        <div class="d-flex justify-content-between align-items-center mb-3">
            <% if (price != null && !price.isEmpty()) { %>
            <div class="service-price">
                <span class="text-primary fw-bold"><%= price %></span>
                <small class="text-muted">VNĐ</small>
            </div>
            <% } %>
            <% if (duration != null && !duration.isEmpty()) { %>
            <div class="service-duration">
                <i class="fas fa-clock text-muted me-1"></i>
                <small class="text-muted"><%= duration %></small>
            </div>
            <% } %>
        </div>
        
        <div class="d-flex gap-2">
            <% if (detailUrl != null && !detailUrl.isEmpty()) { %>
            <a href="${pageContext.request.contextPath}<%= detailUrl %>" 
               class="btn-dashboard btn-dashboard-secondary flex-grow-1">
                <i class="fas fa-info-circle me-1"></i>Chi tiết
            </a>
            <% } %>
            <% if (bookUrl != null && !bookUrl.isEmpty()) { %>
            <a href="${pageContext.request.contextPath}<%= bookUrl %>" 
               class="btn-dashboard btn-dashboard-primary flex-grow-1">
                <i class="fas fa-calendar-plus me-1"></i>Đặt lịch
            </a>
            <% } %>
        </div>
    </div>
</div>
