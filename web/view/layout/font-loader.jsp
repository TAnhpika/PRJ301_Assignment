<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  Font loader dùng chung cho layout (không dùng thư mục /includes nữa).
  Font và CSS lấy từ: /view/assets/font và /view/assets/css/global-fonts.css
--%>
<style>
    @font-face {
        font-family: 'DejaVu Sans';
        src: url('${pageContext.request.contextPath}/view/assets/font/DejaVuSans.ttf') format('truetype');
        font-weight: normal;
        font-style: normal;
    }
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/global-fonts.css">

