<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="dao.DoctorDAO" %>
        <%@ page import="model.Doctors" %>
            <%@ page import="model.User" %>
                <%@ page import="java.util.List" %>

                    <% User user=(User) session.getAttribute("user"); if (user==null ||
                        !"MANAGER".equals(user.getRole())) { response.sendRedirect(request.getContextPath()
                        + "/jsp/auth/login.jsp" ); return; } List<Doctors> doctors = DoctorDAO.getAllDoctors();

                        int activeCount = 0;
                        int leaveCount = 0;
                        for (Doctors d : doctors) {
                        if ("ACTIVE".equals(d.getStatus())) activeCount++;
                        if ("ON_LEAVE".equals(d.getStatus())) leaveCount++;
                        }
                        %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <%@ include file="/includes/dashboard_head.jsp" %>
                                <title>Quản lý Bác sĩ - Manager</title>

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
                                                        <h4 class="mb-1"><i class="fas fa-user-md me-2"></i>Quản lý Bác
                                                            sĩ</h4>
                                                        <p class="text-muted mb-0">Danh sách và thông tin chi tiết các
                                                            bác sĩ</p>
                                                    </div>
                                                    <button class="btn-dashboard btn-dashboard-primary"
                                                        data-bs-toggle="modal" data-bs-target="#addDoctorModal">
                                                        <i class="fas fa-plus"></i> Thêm bác sĩ
                                                    </button>
                                                </div>

                                                <!-- Stats Cards -->
                                                <div class="row g-4 mb-4">
                                                    <div class="col-12 col-sm-6 col-xl-3">
                                                        <div class="stat-card">
                                                            <div class="stat-card-icon">
                                                                <i class="fas fa-user-md"></i>
                                                            </div>
                                                            <div class="stat-card-value">
                                                                <%= doctors.size() %>
                                                            </div>
                                                            <div class="stat-card-label">Tổng số bác sĩ</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-sm-6 col-xl-3">
                                                        <div class="stat-card success">
                                                            <div class="stat-card-icon">
                                                                <i class="fas fa-check-circle"></i>
                                                            </div>
                                                            <div class="stat-card-value">
                                                                <%= activeCount %>
                                                            </div>
                                                            <div class="stat-card-label">Đang làm việc</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-sm-6 col-xl-3">
                                                        <div class="stat-card warning">
                                                            <div class="stat-card-icon">
                                                                <i class="fas fa-clock"></i>
                                                            </div>
                                                            <div class="stat-card-value">
                                                                <%= leaveCount %>
                                                            </div>
                                                            <div class="stat-card-label">Đang nghỉ phép</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-sm-6 col-xl-3">
                                                        <div class="stat-card danger">
                                                            <div class="stat-card-icon">
                                                                <i class="fas fa-user-slash"></i>
                                                            </div>
                                                            <div class="stat-card-value">
                                                                <%= doctors.size() - activeCount - leaveCount %>
                                                            </div>
                                                            <div class="stat-card-label">Không hoạt động</div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Filters -->
                                                <div class="dashboard-card mb-4">
                                                    <div class="row g-3">
                                                        <div class="col-md-4">
                                                            <div class="input-group">
                                                                <span class="input-group-text bg-white"><i
                                                                        class="fas fa-search text-muted"></i></span>
                                                                <input type="text" class="form-control" id="searchInput"
                                                                    placeholder="Tìm kiếm bác sĩ..."
                                                                    onkeyup="filterDoctors()">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <select class="form-select" id="specialtyFilter"
                                                                onchange="filterDoctors()">
                                                                <option value="">Tất cả chuyên khoa</option>
                                                                <option value="Nha khoa tổng quát">Nha khoa tổng quát
                                                                </option>
                                                                <option value="Chỉnh nha">Chỉnh nha</option>
                                                                <option value="Nha chu">Nha chu</option>
                                                                <option value="Phục hình răng">Phục hình răng</option>
                                                                <option value="Nội nha">Nội nha</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <select class="form-select" id="statusFilter"
                                                                onchange="filterDoctors()">
                                                                <option value="">Tất cả trạng thái</option>
                                                                <option value="ACTIVE">Đang làm việc</option>
                                                                <option value="ON_LEAVE">Nghỉ phép</option>
                                                                <option value="INACTIVE">Không hoạt động</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Doctors Grid -->
                                                <div class="row g-4" id="doctorsGrid">
                                                    <% if (doctors.isEmpty()) { %>
                                                        <div class="col-12">
                                                            <div class="dashboard-card text-center py-5">
                                                                <i class="fas fa-user-md text-muted"
                                                                    style="font-size: 48px;"></i>
                                                                <p class="text-muted mt-3">Chưa có bác sĩ nào trong hệ
                                                                    thống</p>
                                                            </div>
                                                        </div>
                                                        <% } else { for (Doctor doctor : doctors) { %>
                                                            <div class="col-md-6 col-lg-4 doctor-item"
                                                                data-specialty="<%= doctor.getSpecialty() %>"
                                                                data-status="<%= doctor.getStatus() %>"
                                                                data-name="<%= doctor.getName().toLowerCase() %>">
                                                                <div class="doctor-card">
                                                                    <div class="d-flex align-items-center mb-3">
                                                                        <img src="<%= doctor.getAvatar() != null ? doctor.getAvatar() : request.getContextPath() + "
                                                                            /img/default-avatar.png" %>"
                                                                        class="doctor-avatar me-3" alt="Doctor Avatar">
                                                                        <div>
                                                                            <h6 class="mb-1">
                                                                                <%= doctor.getName() %>
                                                                            </h6>
                                                                            <span class="text-muted"
                                                                                style="font-size: 13px;">
                                                                                <%= doctor.getSpecialty() %>
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-3">
                                                                        <span class="specialty-badge">
                                                                            <i class="fas fa-graduation-cap"></i>
                                                                            <%= doctor.getDegree() %>
                                                                        </span>
                                                                        <span class="specialty-badge">
                                                                            <i class="fas fa-clock"></i>
                                                                            <%= doctor.getExperience() %> năm KN
                                                                        </span>
                                                                    </div>
                                                                    <div class="mb-3" style="font-size: 13px;">
                                                                        <p class="mb-1"><i
                                                                                class="fas fa-envelope me-2 text-muted"></i>
                                                                            <%= doctor.getEmail() %>
                                                                        </p>
                                                                        <p class="mb-0"><i
                                                                                class="fas fa-phone me-2 text-muted"></i>
                                                                            <%= doctor.getPhone() %>
                                                                        </p>
                                                                    </div>
                                                                    <div
                                                                        class="d-flex justify-content-between align-items-center">
                                                                        <span class="badge bg-<%= "
                                                                            ACTIVE".equals(doctor.getStatus())
                                                                            ? "success" : "ON_LEAVE"
                                                                            .equals(doctor.getStatus()) ? "warning"
                                                                            : "danger" %>">
                                                                            <%= "ACTIVE" .equals(doctor.getStatus())
                                                                                ? "Đang làm việc" : "ON_LEAVE"
                                                                                .equals(doctor.getStatus())
                                                                                ? "Nghỉ phép" : "Không hoạt động" %>
                                                                        </span>
                                                                        <div>
                                                                            <button
                                                                                class="btn btn-sm btn-outline-info me-1"
                                                                                title="Xem lịch">
                                                                                <i class="fas fa-calendar-alt"></i>
                                                                            </button>
                                                                            <button
                                                                                class="btn btn-sm btn-outline-warning me-1"
                                                                                title="Chỉnh sửa">
                                                                                <i class="fas fa-edit"></i>
                                                                            </button>
                                                                            <button
                                                                                class="btn btn-sm btn-outline-danger"
                                                                                title="Xóa"
                                                                                onclick="confirmAction('Bạn có chắc muốn xóa bác sĩ này?', function() { deleteDoctorAction(<%= doctor.getUserId() %>); })">
                                                                                <i class="fas fa-trash"></i>
                                                                            </button>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <% } } %>
                                                </div>
                                            </div>
                                    </main>
                            </div>

                            <!-- Add Doctor Modal -->
                            <div class="modal fade" id="addDoctorModal" tabindex="-1">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Thêm bác sĩ mới</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/AddDoctorServlet"
                                            method="POST">
                                            <div class="modal-body">
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Họ tên <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="name" required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Email <span
                                                                class="text-danger">*</span></label>
                                                        <input type="email" class="form-control" name="email" required>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Số điện thoại <span
                                                                class="text-danger">*</span></label>
                                                        <input type="tel" class="form-control" name="phone" required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Chuyên khoa <span
                                                                class="text-danger">*</span></label>
                                                        <select class="form-select" name="specialty" required>
                                                            <option value="Nha khoa tổng quát">Nha khoa tổng quát
                                                            </option>
                                                            <option value="Chỉnh nha">Chỉnh nha</option>
                                                            <option value="Nha chu">Nha chu</option>
                                                            <option value="Phục hình răng">Phục hình răng</option>
                                                            <option value="Nội nha">Nội nha</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Bằng cấp <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="degree" required
                                                            placeholder="VD: Thạc sĩ, Tiến sĩ">
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Kinh nghiệm (năm) <span
                                                                class="text-danger">*</span></label>
                                                        <input type="number" class="form-control" name="experience"
                                                            required min="0">
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Mật khẩu <span
                                                                class="text-danger">*</span></label>
                                                        <input type="password" class="form-control" name="password"
                                                            required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Xác nhận mật khẩu <span
                                                                class="text-danger">*</span></label>
                                                        <input type="password" class="form-control"
                                                            name="confirmPassword" required>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Mô tả</label>
                                                    <textarea class="form-control" name="description" rows="3"
                                                        placeholder="Giới thiệu về bác sĩ..."></textarea>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Hủy</button>
                                                <button type="submit" class="btn btn-primary">Thêm bác sĩ</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <%@ include file="/includes/dashboard_scripts.jsp" %>

                                <script>
                                    function filterDoctors() {
                                        var searchInput = document.getElementById("searchInput").value.toLowerCase();
                                        var specialtyFilter = document.getElementById("specialtyFilter").value;
                                        var statusFilter = document.getElementById("statusFilter").value;
                                        var items = document.getElementsByClassName("doctor-item");

                                        for (var i = 0; i < items.length; i++) {
                                            var specialty = items[i].getAttribute("data-specialty");
                                            var status = items[i].getAttribute("data-status");
                                            var name = items[i].getAttribute("data-name");
                                            var show = true;

                                            if (specialtyFilter && specialty !== specialtyFilter) {
                                                show = false;
                                            }

                                            if (statusFilter && status !== statusFilter) {
                                                show = false;
                                            }

                                            if (searchInput && name.indexOf(searchInput) === -1) {
                                                show = false;
                                            }

                                            items[i].style.display = show ? "" : "none";
                                        }
                                    }

                                    function deleteDoctorAction(doctorId) {
                                        window.location.href = '${pageContext.request.contextPath}/DeleteDoctorServlet?id=' + doctorId;
                                    }
                                </script>
                        </body>

                        </html>