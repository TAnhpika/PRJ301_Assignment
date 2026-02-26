<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.PatientDAO" %>
<%@ page import="model.Patients" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    List<Patients> patients = (List<Patients>) request.getAttribute("patients");
    if (patients == null) patients = new java.util.ArrayList<>();
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Danh sách Bệnh nhân - Staff</title>
    <style>
        .patient-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/staff/staff_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/staff/staff_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-users me-2"></i>Danh sách Bệnh nhân</h4>
                        <p class="text-muted mb-0">Quản lý và xem thông tin bệnh nhân</p>
                    </div>
                </div>
                
                <!-- Stats Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-card-value"><%= patients.size() %></div>
                            <div class="stat-card-label">Tổng bệnh nhân</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card info">
                            <div class="stat-card-icon">
                                <i class="fas fa-mars"></i>
                            </div>
                            <div class="stat-card-value">
                                <%= patients.stream().filter(p -> "Nam".equalsIgnoreCase(p.getGender()) || "male".equalsIgnoreCase(p.getGender())).count() %>
                            </div>
                            <div class="stat-card-label">Nam</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card success">
                            <div class="stat-card-icon">
                                <i class="fas fa-venus"></i>
                            </div>
                            <div class="stat-card-value">
                                <%= patients.stream().filter(p -> "Nữ".equalsIgnoreCase(p.getGender()) || "female".equalsIgnoreCase(p.getGender())).count() %>
                            </div>
                            <div class="stat-card-label">Nữ</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card warning">
                            <div class="stat-card-icon">
                                <i class="fas fa-genderless"></i>
                            </div>
                            <div class="stat-card-value">
                                <%= patients.stream().filter(p -> !"Nam".equalsIgnoreCase(p.getGender()) && !"Nữ".equalsIgnoreCase(p.getGender()) && !"male".equalsIgnoreCase(p.getGender()) && !"female".equalsIgnoreCase(p.getGender())).count() %>
                            </div>
                            <div class="stat-card-label">Khác</div>
                        </div>
                    </div>
                </div>
                
                <!-- Filters -->
                <div class="dashboard-card mb-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm bệnh nhân..." onkeyup="filterTable()">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="genderFilter" onchange="filterTable()">
                                <option value="">Tất cả giới tính</option>
                                <option value="male">Nam</option>
                                <option value="female">Nữ</option>
                                <option value="other">Khác</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- Patients Table -->
                <div class="dashboard-card">
                    <div class="table-responsive">
                        <table class="dashboard-table" id="patientsTable">
                            <thead>
                                <tr>
                                    <th style="width: 60px;">ID</th>
                                    <th>Bệnh nhân</th>
                                    <th>Giới tính</th>
                                    <th>Ngày sinh</th>
                                    <th>Số điện thoại</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (patients.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <i class="fas fa-users text-muted" style="font-size: 48px;"></i>
                                        <p class="text-muted mt-3">Không có dữ liệu bệnh nhân</p>
                                    </td>
                                </tr>
                                <% } else { for (Patients patient : patients) { %>
                                <tr data-gender="<%= patient.getGender() != null ? patient.getGender().toLowerCase() : "" %>">
                                    <td><span class="badge bg-secondary">#<%= patient.getPatientId() %></span></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/img/default-avatar.png" class="patient-avatar me-3" alt="Avatar">
                                            <div>
                                                <strong><%= patient.getFullName() %></strong>
                                                <small class="text-muted d-block">ID: <%= patient.getId() %></small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-<%= "Nam".equalsIgnoreCase(patient.getGender()) || "male".equalsIgnoreCase(patient.getGender()) ? "info" : "Nữ".equalsIgnoreCase(patient.getGender()) || "female".equalsIgnoreCase(patient.getGender()) ? "success" : "secondary" %>">
                                            <%= patient.getGender() != null ? patient.getGender() : "N/A" %>
                                        </span>
                                    </td>
                                    <td><%= patient.getDateOfBirth() != null ? dateFormat.format(patient.getDateOfBirth()) : "N/A" %></td>
                                    <td><%= patient.getPhone() != null ? patient.getPhone() : "N/A" %></td>
                                    <td><%= patient.getCreatedAt() != null ? dateFormat.format(patient.getCreatedAt()) : "N/A" %></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-info me-1" onclick="viewPatient(<%= patient.getPatientId() %>)" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-warning me-1" onclick="editPatient(<%= patient.getPatientId() %>)" title="Chỉnh sửa">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" onclick="confirmAction('Bạn có chắc muốn xóa bệnh nhân này?', function() { deletePatient(<%= patient.getPatientId() %>); })" title="Xóa">
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
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        function filterTable() {
            var searchInput = document.getElementById("searchInput").value.toLowerCase();
            var genderFilter = document.getElementById("genderFilter").value;
            var table = document.getElementById("patientsTable");
            var tr = table.getElementsByTagName("tr");

            for (var i = 1; i < tr.length; i++) {
                var gender = tr[i].getAttribute("data-gender");
                var show = true;
                
                if (genderFilter) {
                    if (genderFilter === "male" && gender !== "male" && gender !== "nam") show = false;
                    else if (genderFilter === "female" && gender !== "female" && gender !== "nữ") show = false;
                    else if (genderFilter === "other" && (gender === "male" || gender === "female" || gender === "nam" || gender === "nữ")) show = false;
                }
                
                if (searchInput) {
                    var textContent = tr[i].textContent || tr[i].innerText;
                    if (textContent.toLowerCase().indexOf(searchInput) === -1) {
                        show = false;
                    }
                }
                
                tr[i].style.display = show ? "" : "none";
            }
        }
        
        function viewPatient(patientId) {
            window.location.href = '${pageContext.request.contextPath}/jsp/staff/staff_view_patient_detail.jsp?id=' + patientId;
        }
        
        function editPatient(patientId) {
            window.location.href = '${pageContext.request.contextPath}/jsp/staff/staff_edit_patient.jsp?id=' + patientId;
        }
        
        function deletePatient(patientId) {
            window.location.href = '${pageContext.request.contextPath}/DeletePatientServlet?id=' + patientId;
        }
    </script>
</body>
</html>
