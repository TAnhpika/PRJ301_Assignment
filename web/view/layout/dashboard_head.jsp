<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  dashboard_head.jsp
  - Partial dùng trong các trang dashboard (patient / doctor / staff / manager)
  - Không khai báo <html>, <head>, chỉ chứa meta + CSS chung
--%>

<!-- Meta chung cho dashboard -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Font local (DejaVu Sans) và thiết lập font toàn hệ thống -->
<%@ include file="/view/layout/font-loader.jsp" %>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Favicon -->
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/view/assets/img/dental.png">

<!-- Font Awesome 6 Icons -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

<!-- CSS dashboard chung -->
<style>
    /* Force Font Awesome to load correctly even if other styles try to override */
    .fa, .fas, .far, .fab, .fa-solid, .fa-regular, .fa-brands {
        font-family: "Font Awesome 6 Free", "Font Awesome 6 Brands" !important;
    }
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/dashboard-common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/dashboard.css">

<!-- CSS theo role (nếu có) -->

<link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/doctor.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/staff.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/manager.css">

