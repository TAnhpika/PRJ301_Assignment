<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor.css">
    <title>${pageTitle}</title>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
        <main class="dashboard-main">
            <%@ include file="/jsp/doctor/doctor_header.jsp" %>
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="doctor-page-header mb-4">
                    <h1 class="d-flex align-items-center justify-content-center gap-2 flex-wrap">
                        <i class="fas fa-user-md"></i> Chỉnh sửa thông tin bác sĩ
                    </h1>
                    <p class="mb-0">Cập nhật thông tin cá nhân của bác sĩ</p>
                </div>

                <!-- Doctor Edit Form -->
                <div class="doctor-caidat">
                    <div class="doctor-info">
                        <h4 class="mb-0">Thông tin bác sĩ</h4>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="error-message"><c:out value="${errorMessage}"/></div>
                    </c:if>

                    <div class="form-group">
                        <c:choose>
                            <c:when test="${not empty doctor}">
                                <form action="${pageContext.request.contextPath}/EditDoctorServlet" method="post">
                                    <input type="hidden" name="user_id" value="<c:out value='${doctor.user_id}'/>">

                                    <c:if test="${not empty doctor.avatar}">
                                        <img src="<c:out value='${doctor.avatar}'/>" alt="Avatar" class="avatar-img">
                                    </c:if>
                                    <c:if test="${empty doctor.avatar}">
                                        <p class="text-muted small mb-2">Chưa có ảnh đại diện</p>
                                    </c:if>

                                    <label for="doctorId">ID Bác Sĩ</label>
                                    <input type="text" id="doctorId" name="doctorId" value="<c:out value='${doctor.doctorId}'/>" readonly>

                                    <label for="fullName">Họ Tên</label>
                                    <input type="text" id="fullName" name="full_name" value="<c:out value='${doctor.fullName}'/>" required>

                                    <label for="specialty">Chuyên Khoa</label>
                                    <input type="text" id="specialty" name="specialty" value="<c:out value='${doctor.specialty}'/>" required>

                                    <label for="phone">Số Điện Thoại</label>
                                    <input type="text" id="phone" name="phone" value="<c:out value='${doctor.phone}'/>" required>

                                    <label for="address">Địa Chỉ</label>
                                    <input type="text" id="address" name="address" value="<c:out value='${doctor.address}'/>">

                                    <label for="dateOfBirth">Ngày Sinh</label>
                                    <input type="date" id="dateOfBirth" name="date_of_birth"
                                           value="<fmt:formatDate value='${doctor.date_of_birth}' pattern='yyyy-MM-dd'/>">

                                    <label for="gender">Giới Tính</label>
                                    <select id="gender" name="gender" required>
                                        <option value="male" <c:if test="${doctor.gender == 'Nam' || doctor.gender == 'male'}">selected</c:if>>Nam</option>
                                        <option value="female" <c:if test="${doctor.gender == 'Nữ' || doctor.gender == 'female'}">selected</c:if>>Nữ</option>
                                        <option value="other" <c:if test="${doctor.gender == 'Khác' || doctor.gender == 'other'}">selected</c:if>>Khác</option>
                                    </select>

                                    <label for="licenseNumber">Số Giấy Phép</label>
                                    <input type="text" id="licenseNumber" name="license_number" value="<c:out value='${doctor.license_number}'/>" required>

                                    <label for="status">Trạng Thái</label>
                                    <select id="status" name="status" required>
                                        <option value="Active" <c:if test="${doctor.status == 'Active'}">selected</c:if>>Hoạt động</option>
                                        <option value="Inactive" <c:if test="${doctor.status == 'Inactive'}">selected</c:if>>Không hoạt động</option>
                                    </select>

                                    <div class="form-group text-center mt-3">
                                        <a href="${pageContext.request.contextPath}/doctor_changepassword.jsp" class="btn btn-warning">
                                            <i class="fas fa-key me-1"></i> Đổi mật khẩu
                                        </a>
                                    </div>

                                    <div class="form-group d-flex gap-2 flex-wrap">
                                        <input type="submit" value="Cập nhật thông tin" class="btn btn-primary">
                                    </div>
                                </form>

                                <div class="extra">
                                    <a href="${pageContext.request.contextPath}/doctor_trangcanhan">Quay lại hồ sơ</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="error-message">
                                    Không tìm thấy thông tin bác sĩ.
                                    <a href="${pageContext.request.contextPath}/doctor_trangcanhan">Quay lại hồ sơ</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <%@ include file="/includes/dashboard_scripts.jsp" %>
</body>
</html>
