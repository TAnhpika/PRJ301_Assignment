<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.StaffDAO, dao.DoctorDAO, model.Staff, model.Doctors, model.User, java.util.List, java.util.logging.Logger, java.util.logging.Level" %>
<%! private static final Logger LOGGER = Logger.getLogger("manager_danhsach.jsp");%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
    List<Doctors> doctorList = (List<Doctors>) request.getAttribute("doctorList");
    List<Staff> staffData = null;
    List<Doctors> doctorData = null;

    try {
        StaffDAO staffDAO = new StaffDAO();
        DoctorDAO doctorDAO = new DoctorDAO();
        staffData = (staffList != null) ? staffList : staffDAO.getAllStaff();
        doctorData = (doctorList != null) ? doctorList : doctorDAO.getAllDoctors();
    } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách: ", e);
        staffData = java.util.Collections.emptyList();
        doctorData = java.util.Collections.emptyList();
    }

    int doctorCount = doctorData != null ? doctorData.size() : 0;
    int staffCount = staffData != null ? staffData.size() : 0;
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Quản lý danh sách nhân viên - Manager</title>
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
                        <h4 class="mb-1"><i class="fas fa-users me-2"></i>Quản lý danh sách nhân viên</h4>
                        <p class="text-muted mb-0">Quản lý thông tin tài khoản nhân viên và bác sĩ trong hệ thống</p>
                    </div>
                    <button class="btn-dashboard btn-dashboard-primary" data-bs-toggle="modal" data-bs-target="#addModal">
                        <i class="fas fa-plus"></i> Thêm nhân viên
                    </button>
                </div>
                
                <!-- Alerts -->
                <% if (successMessage != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i><%= successMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                <% if (errorMessage != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i><%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                
                <!-- Search Box -->
                <div class="dashboard-card mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm theo tên hoặc số điện thoại..." onkeyup="searchStaff()">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div id="searchResultsInfo" class="text-muted small"></div>
                        </div>
                    </div>
                </div>
                
                <!-- Tab Navigation -->
                <ul class="nav nav-tabs mb-4" id="staffTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="doctors-tab" data-bs-toggle="tab" data-bs-target="#doctors-content" type="button" role="tab">
                            <i class="fas fa-user-md me-2"></i>Bác sĩ
                            <span class="badge bg-primary ms-2" id="doctorCount"><%= doctorCount %></span>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="staff-tab" data-bs-toggle="tab" data-bs-target="#staff-content" type="button" role="tab">
                            <i class="fas fa-users me-2"></i>Nhân viên
                            <span class="badge bg-secondary ms-2" id="staffCount"><%= staffCount %></span>
                        </button>
                    </li>
                </ul>
                
                <!-- Tab Content -->
                <div class="tab-content" id="staffTabsContent">
                    <!-- Doctors Tab -->
                    <div class="tab-pane fade show active" id="doctors-content" role="tabpanel">
                        <div class="dashboard-card">
                            <div class="table-responsive">
                                <table class="dashboard-table" id="doctorsTable">
                                    <thead>
                                        <tr>
                                            <th>Họ tên</th>
                                            <th>Email</th>
                                            <th>Số điện thoại</th>
                                            <th>Chuyên khoa</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày tạo</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody id="doctorsTableBody">
                                        <% if (doctorData.isEmpty()) { %>
                                        <tr>
                                            <td colspan="7" class="text-center py-5">
                                                <i class="fas fa-user-md text-muted" style="font-size: 48px;"></i>
                                                <p class="text-muted mt-3">Chưa có bác sĩ nào trong hệ thống</p>
                                            </td>
                                        </tr>
                                        <% } else { for (Doctors doctor : doctorData) { %>
                                        <tr class="doctor-row" data-name="<%= doctor.getFull_name() != null ? doctor.getFull_name().toLowerCase() : "" %>" data-phone="<%= doctor.getPhone() != null ? doctor.getPhone() : "" %>">
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}/view/assets/img/default-avatar.png" class="rounded-circle me-2" style="width: 36px; height: 36px; object-fit: cover;">
                                                    <span><%= doctor.getFull_name() != null ? doctor.getFull_name() : "N/A" %></span>
                                                </div>
                                            </td>
                                            <td><%= doctor.getUserEmail() != null ? doctor.getUserEmail() : "N/A" %></td>
                                            <td><%= doctor.getPhone() != null ? doctor.getPhone() : "N/A" %></td>
                                            <td><span class="badge-dashboard badge-primary"><%= doctor.getSpecialty() != null ? doctor.getSpecialty() : "N/A" %></span></td>
                                            <td>
                                                <span class="badge bg-<%= doctor.getStatus() != null && doctor.getStatus().equals("active") ? "success" : "danger" %>">
                                                    <%= doctor.getStatus() != null && doctor.getStatus().equals("active") ? "Hoạt động" : "Không hoạt động" %>
                                                </span>
                                            </td>
                                            <td><% if (doctor.getCreated_at() != null) { %><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(doctor.getCreated_at()) %><% } else { %>N/A<% } %></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-warning me-1" onclick="resetDoctorPassword(<%= doctor.getDoctor_id() %>)" title="Reset mật khẩu">
                                                    <i class="fas fa-key"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger" onclick="deleteDoctor(<%= doctor.getDoctor_id() %>)" title="Xóa">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <% } } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Staff Tab -->
                    <div class="tab-pane fade" id="staff-content" role="tabpanel">
                        <div class="dashboard-card">
                            <div class="table-responsive">
                                <table class="dashboard-table" id="staffTable">
                                    <thead>
                                        <tr>
                                            <th>Họ tên</th>
                                            <th>Email</th>
                                            <th>Số điện thoại</th>
                                            <th>Chức vụ</th>
                                            <th>Loại hợp đồng</th>
                                            <th>Ngày tạo</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody id="staffTableBody">
                                        <% if (staffData.isEmpty()) { %>
                                        <tr>
                                            <td colspan="7" class="text-center py-5">
                                                <i class="fas fa-users text-muted" style="font-size: 48px;"></i>
                                                <p class="text-muted mt-3">Chưa có nhân viên nào trong hệ thống</p>
                                            </td>
                                        </tr>
                                        <% } else { for (Staff staff : staffData) { %>
                                        <tr class="staff-row" data-name="<%= staff.getFullName() != null ? staff.getFullName().toLowerCase() : "" %>" data-phone="<%= staff.getPhone() != null ? staff.getPhone() : "" %>">
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}/view/assets/img/default-avatar.png" class="rounded-circle me-2" style="width: 36px; height: 36px; object-fit: cover;">
                                                    <span><%= staff.getFullName() != null ? staff.getFullName() : "N/A" %></span>
                                                </div>
                                            </td>
                                            <td><%= staff.getUserEmail() != null ? staff.getUserEmail() : "N/A" %></td>
                                            <td><%= staff.getPhone() != null ? staff.getPhone() : "N/A" %></td>
                                            <td><%= staff.getPosition() != null ? staff.getPosition() : "N/A" %></td>
                                            <td>
                                                <span class="badge-dashboard <%= "fulltime".equalsIgnoreCase(staff.getEmploymentType()) ? "badge-success" : "badge-warning" %>">
                                                    <%= "fulltime".equalsIgnoreCase(staff.getEmploymentType()) ? "Toàn thời gian" : "parttime".equalsIgnoreCase(staff.getEmploymentType()) ? "Bán thời gian" : "Chưa chọn" %>
                                                </span>
                                            </td>
                                            <td><% if (staff.getCreatedAt() != null) { %><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(staff.getCreatedAt()) %><% } else { %>N/A<% } %></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-warning me-1" onclick="resetStaffPassword(<%= staff.getStaffId() %>)" title="Reset mật khẩu">
                                                    <i class="fas fa-key"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger" onclick="deleteStaff(<%= staff.getStaffId() %>)" title="Xóa">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <% } } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Add Staff Modal -->
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-user-plus me-2"></i>Thêm nhân viên mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/AddStaffServlet" method="POST">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Họ tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="fullName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" name="phone" pattern="[0-9]{10}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Vai trò <span class="text-danger">*</span></label>
                            <select class="form-select" name="role" id="roleSelect" required>
                                <option value="">Chọn vai trò</option>
                                <option value="STAFF">Nhân viên</option>
                                <option value="DOCTOR">Bác sĩ</option>
                            </select>
                        </div>
                        <div class="mb-3" id="positionGroup">
                            <label class="form-label">Chuyên khoa</label>
                            <select class="form-select" name="position">
                                <option value="">Chọn chuyên khoa</option>
                                <option value="Răng – Hàm – Mặt tổng quát">Răng – Hàm – Mặt tổng quát</option>
                                <option value="Nội nha (Endodontics)">Nội nha (Endodontics)</option>
                                <option value="Chỉnh nha (Orthodontics)">Chỉnh nha (Orthodontics)</option>
                                <option value="Phẫu thuật Răng – Hàm – Mặt">Phẫu thuật Răng – Hàm – Mặt</option>
                                <option value="Phục hình răng (Prosthodontics)">Phục hình răng (Prosthodontics)</option>
                                <option value="Nha khoa thẩm mỹ">Nha khoa thẩm mỹ</option>
                            </select>
                        </div>
                        <div class="mb-3" id="staffPositionGroup" style="display: none;">
                            <label class="form-label">Chức vụ</label>
                            <input type="text" class="form-control" name="staffPosition" placeholder="Nhập chức vụ">
                        </div>
                        <div class="mb-3" id="employmentTypeGroup">
                            <label class="form-label">Loại hợp đồng</label>
                            <select class="form-select" name="employmentType">
                                <option value="">Chọn loại hợp đồng</option>
                                <option value="fulltime">Toàn thời gian</option>
                                <option value="parttime">Bán thời gian</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm nhân viên</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        let originalDoctorCount = <%= doctorCount %>;
        let originalStaffCount = <%= staffCount %>;
        
        function searchStaff() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const activeTab = document.querySelector('.tab-pane.active').id;
            
            if (activeTab === 'doctors-content') {
                searchInTable('doctor-row', searchTerm, 'doctorCount', originalDoctorCount);
            } else {
                searchInTable('staff-row', searchTerm, 'staffCount', originalStaffCount);
            }
        }
        
        function searchInTable(rowClass, searchTerm, countElementId, originalCount) {
            const rows = document.querySelectorAll('.' + rowClass);
            let visibleCount = 0;
            
            rows.forEach(row => {
                const name = row.getAttribute('data-name') || '';
                const phone = row.getAttribute('data-phone') || '';
                
                if (name.includes(searchTerm) || phone.includes(searchTerm)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            document.getElementById(countElementId).textContent = visibleCount;
            
            const info = document.getElementById('searchResultsInfo');
            if (searchTerm) {
                info.innerHTML = visibleCount > 0 
                    ? '<span class="text-success">Tìm thấy ' + visibleCount + ' kết quả</span>'
                    : '<span class="text-danger">Không tìm thấy kết quả</span>';
            } else {
                info.textContent = '';
            }
        }
        
        function deleteStaff(staffId) {
            confirmAction('Bạn có chắc chắn muốn xóa nhân viên này?', function() {
                window.location.href = '<%= request.getContextPath() %>/DeleteStaffServlet?type=staff&id=' + staffId;
            });
        }
        
        function deleteDoctor(doctorId) {
            confirmAction('Bạn có chắc chắn muốn xóa bác sĩ này?', function() {
                window.location.href = '<%= request.getContextPath() %>/DeleteStaffServlet?type=doctor&id=' + doctorId;
            });
        }
        
        function resetStaffPassword(staffId) {
            confirmAction('Bạn có chắc chắn muốn reset mật khẩu cho nhân viên này?', function() {
                window.location.href = '<%= request.getContextPath() %>/ManagerResetStaffPasswordServlet?type=staff&id=' + staffId;
            });
        }
        
        function resetDoctorPassword(doctorId) {
            confirmAction('Bạn có chắc chắn muốn reset mật khẩu cho bác sĩ này?', function() {
                window.location.href = '<%= request.getContextPath() %>/ManagerResetStaffPasswordServlet?type=doctor&id=' + doctorId;
            });
        }
        
        // Role select change handler
        document.getElementById('roleSelect').addEventListener('change', function() {
            const employmentTypeGroup = document.getElementById('employmentTypeGroup');
            const positionGroup = document.getElementById('positionGroup');
            const staffPositionGroup = document.getElementById('staffPositionGroup');
            
            if (this.value === 'STAFF') {
                employmentTypeGroup.style.display = 'block';
                positionGroup.style.display = 'none';
                staffPositionGroup.style.display = 'block';
            } else {
                employmentTypeGroup.style.display = 'none';
                positionGroup.style.display = 'block';
                staffPositionGroup.style.display = 'none';
            }
        });
        
        // Clear search when switching tabs
        document.querySelectorAll('[data-bs-toggle="tab"]').forEach(tab => {
            tab.addEventListener('shown.bs.tab', function() {
                document.getElementById('searchInput').value = '';
                searchStaff();
            });
        });
    </script>
</body>
</html>
