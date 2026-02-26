<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  Bridge JSP:
  - Đường dẫn cũ: /jsp/auth/signup.jsp
  - Trang đăng ký chuẩn: /jsp/auth/register.jsp
  File này chỉ dùng để forward sang register.jsp, tránh lỗi 404 cho link cũ.
--%>
<jsp:forward page="/jsp/auth/register.jsp" />

