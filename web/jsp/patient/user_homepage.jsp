<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   <%@page import="model.Appointment" %>
<%@page import="model.Doctors" %>
<%@page import="model.Patients" %>
<%@page import="model.BlogPost" %>
<%@page import="model.User" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>

<%
    Patients patient = (Patients) session.getAttribute("patient");
    User user = (User) session.getAttribute("user");
    List<Appointment> upcomingAppointments = (List<Appointment>) request.getAttribute("upcomingAppointments");
    List<Doctors> doctors = (List<Doctors>) request.getAttribute("doctors");
    List<BlogPost> latestBlogs = (List<BlogPost>) request.getAttribute("latestBlogs");
    Integer totalVisits = (Integer) request.getAttribute("totalVisits");
    
    String patientName = patient != null ? patient.getFullName() : (user != null ? user.getUsername() : "Khách");
    String patientAvatar = patient != null && patient.getAvatar() != null 
        ? patient.getAvatar() 
        : (user != null && user.getAvatar() != null ? user.getAvatar() : null);
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Trang chủ - Happy Smile</title>
    </head>
    <body>
        <div class="dashboard-wrapper">
        <!-- Sidebar Menu -->
        <%@ include file="/jsp/patient/user_menu.jsp" %>
        
        <!-- Main Content -->
        <main class="dashboard-main">
            <!-- Header -->
            <%@ include file="/jsp/patient/user_header.jsp" %>
            
            <!-- Page Content -->
            <div class="dashboard-content">
                <!-- Page Title -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1">Xin chào, <%= patientName %>!</h4>
                        <p class="text-muted mb-0">Chúc bạn một ngày tốt lành</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/services" class="btn-dashboard btn-dashboard-primary">
                        <i class="fas fa-calendar-plus"></i> Đặt lịch khám
                    </a>
                </div>
                
                <!-- Stats Cards Row -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-card-value">
                                <%= upcomingAppointments != null ? upcomingAppointments.size() : 0 %>
                            </div>
                            <div class="stat-card-label">Lịch hẹn sắp tới</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-clipboard-check"></i>
                            </div>
                            <div class="stat-card-value"><%= totalVisits != null ? totalVisits : 0 %></div>
                            <div class="stat-card-label">Lần khám tại đây</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="stat-card-value"><%= doctors != null ? doctors.size() : 0 %></div>
                            <div class="stat-card-label">Bác sĩ đang trực</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-file-medical"></i>
                            </div>
                            <div class="stat-card-value">0</div>
                            <div class="stat-card-label">Hồ sơ y tế</div>
                        </div>
                    </div>
                </div>
                
                <!-- Main Content Row -->
                <div class="row g-4">
                    <!-- Upcoming Appointments -->
                    <div class="col-12 col-lg-8">
                        <div class="dashboard-card" style="background: linear-gradient(135deg, #4E80EE 0%, #3D6FDD 100%); color: white;">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h5 class="mb-0">
                                    <i class="fas fa-calendar-alt me-2"></i>
                                    Lịch khám sắp tới
                                </h5>
                                <a href="${pageContext.request.contextPath}/PatientAppointments" class="btn btn-light btn-sm">
                                    Xem tất cả
                                </a>
                            </div>
                            
                        <% if (upcomingAppointments != null && !upcomingAppointments.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-borderless mb-0" style="color: white;">
                            <thead>
                                        <tr style="opacity: 0.8;">
                                    <th>Bác sĩ</th>
                                    <th>Ngày khám</th>
                                    <th>Khung giờ</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                        <% for (Appointment ap : upcomingAppointments) { %>
                                        <tr>
                                            <td><%= ap.getDoctorName() %></td>
                                            <td><%= ap.getWorkDate().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %></td>
                                            <td><%= ap.getStartTime() %> - <%= ap.getEndTime() %></td>
                                            <td>
                                                <span class="badge bg-light text-primary"><%= ap.getStatus() %></span>
                                            </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-4">
                                <i class="fas fa-calendar-xmark" style="font-size: 48px; opacity: 0.5;"></i>
                                <p class="mt-3 mb-0" style="opacity: 0.8;">Hiện bạn chưa có lịch khám sắp tới</p>
                                <a href="${pageContext.request.contextPath}/services" class="btn btn-light mt-3">
                                    Đặt lịch ngay
                                </a>
                    </div>
                            <% } %>
                </div>

                        <!-- Active Doctors -->
                        <div class="dashboard-card mt-4">
                            <div class="dashboard-card-header">
                                <h5 class="dashboard-card-title">
                                    <i class="fas fa-user-md text-success me-2"></i>
                                    Bác sĩ đang trực
                                </h5>
                </div>

                            <div class="row g-3">
                                <% if (doctors != null && !doctors.isEmpty()) {
                                    int count = 0;
                                    for (Doctors doc : doctors) {
                                        if (count++ >= 4) break;
                                %>
                                <div class="col-12 col-md-6">
                                    <div class="d-flex align-items-center p-3 bg-light rounded">
                                        <img src="${pageContext.request.contextPath}/img/default-avatar.png" 
                                             class="rounded-circle me-3" 
                                             style="width: 50px; height: 50px; object-fit: cover;">
                                        <div class="flex-grow-1">
                                            <h6 class="mb-1">BS. <%= doc.getFull_name() %></h6>
                                            <small class="text-muted"><%= doc.getSpecialty() %></small>
                                        </div>
                                        <span class="badge bg-success">
                                            <i class="fas fa-circle fa-xs me-1"></i>Đang trực
                                        </span>
                                    </div>
                                </div>
                                <% } } else { %>
                                <div class="col-12 text-center py-4">
                                    <p class="text-muted mb-0">Không có bác sĩ nào đang trực</p>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Sidebar Column -->
                    <div class="col-12 col-lg-4">
                        <!-- User Profile Card -->
                        <div class="dashboard-card">
                            <div class="text-center mb-4">
                                <% if (patientAvatar != null) { %>
                                <img src="${pageContext.request.contextPath}<%= patientAvatar %>" 
                                     alt="Avatar" 
                                     class="rounded-circle mb-3"
                                     style="width: 80px; height: 80px; object-fit: cover; border: 3px solid var(--primary-color);"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                                <% } else { %>
                                <div class="bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                                     style="width: 80px; height: 80px; font-size: 32px;">
                                    <%= patientName.substring(0, 1).toUpperCase() %>
                                </div>
                                <% } %>
                                <h5 class="mb-1"><%= patientName %></h5>
                                <span class="badge-dashboard badge-primary">Bệnh nhân</span>
                </div>

                            <% if (patient != null) { 
                            String formattedDob = "--";
                            Date dob = patient.getDateOfBirth();
                            if (dob != null) {
                                    formattedDob = new SimpleDateFormat("dd/MM/yyyy").format(dob);
                                }
                            %>
                            <div class="border-top pt-3">
                                <div class="d-flex align-items-center mb-3">
                                    <i class="fas fa-phone text-primary me-3"></i>
                                    <div>
                                        <small class="text-muted d-block">Điện thoại</small>
                                        <span><%= patient.getPhone() != null ? patient.getPhone() : "Chưa cập nhật" %></span>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center mb-3">
                                    <i class="fas fa-birthday-cake text-primary me-3"></i>
                                    <div>
                                        <small class="text-muted d-block">Ngày sinh</small>
                                        <span><%= formattedDob %></span>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center">
                                    <i class="fas fa-venus-mars text-primary me-3"></i>
                                    <div>
                                        <small class="text-muted d-block">Giới tính</small>
                                        <span><%= patient.getGender() != null ? patient.getGender() : "Chưa cập nhật" %></span>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                            
                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/jsp/patient/user_taikhoan.jsp" class="btn-dashboard btn-dashboard-secondary w-100">
                                    <i class="fas fa-edit"></i> Chỉnh sửa hồ sơ
                                </a>
                            </div>
                        </div>
                        
                        <!-- Latest News -->
                        <div class="dashboard-card mt-4">
                            <div class="dashboard-card-header">
                                <h5 class="dashboard-card-title">
                                    <i class="fas fa-newspaper text-info me-2"></i>
                                    Tin tức mới nhất
                                </h5>
                </div>

                            <% if (latestBlogs != null && !latestBlogs.isEmpty()) {
                                int blogCount = 0;
                                for (BlogPost blog : latestBlogs) {
                                    if (blogCount++ >= 2) break;
                            %>
                            <div class="d-flex mb-3 pb-3 border-bottom">
                                <img src="${pageContext.request.contextPath}/<%= blog.getImageUrl() %>" 
                                     class="rounded me-3" 
                                     style="width: 60px; height: 60px; object-fit: cover;"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'">
                                <div>
                                    <h6 class="mb-1 small"><%= blog.getTitle() %></h6>
                                    <small class="text-muted"><%= blog.getCreatedAt().toString().substring(0, 10) %></small>
                                </div>
                            </div>
                            <% } %>
                            <a href="${pageContext.request.contextPath}/blog" class="btn-dashboard btn-dashboard-secondary w-100">
                                Xem tất cả tin tức
                            </a>
                            <% } else { %>
                            <p class="text-muted text-center mb-0">Chưa có bài viết nào</p>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        </div>
    
    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
    </body>
</html>
