<%-- Form tìm kiếm / lọc bác sĩ --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="dashboard-card mb-4">
    <form method="GET" action="${pageContext.request.contextPath}/BookingPageServlet">
        <c:if test="${not empty selectedService}">
            <input type="hidden" name="serviceId" value="${selectedService.serviceId}"/>
        </c:if>
        <div class="row g-3 align-items-end">
            <div class="col-md-6">
                <label class="form-label">Từ khóa</label>
                <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm bác sĩ..." value="${param.keyword}">
            </div>
            <div class="col-md-4">
                <label class="form-label">Chuyên khoa</label>
                <select name="specialty" class="form-select" ${not empty selectedService ? 'disabled' : ''}>
                    <option value="">Tất cả chuyên khoa</option>
                    <c:forEach items="${specialties}" var="spec">
                        <option value="${spec}" ${(not empty selectedService and selectedSpecialtyName == spec) or (empty selectedService and param.specialty == spec) ? 'selected' : ''}>${spec}</option>
                    </c:forEach>
                </select>
                <c:if test="${not empty selectedService}">
                    <input type="hidden" name="specialty" value="${selectedService.category}"/>
                </c:if>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn-dashboard btn-dashboard-primary w-100">
                    <i class="fas fa-search me-1"></i>Tìm
                </button>
            </div>
        </div>
    </form>
</div>
