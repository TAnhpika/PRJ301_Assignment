<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="dao.BlogDAO" %>
        <%@ page import="model.BlogPost" %>
            <%@ page import="model.User" %>
                <%@ page import="java.util.List" %>
                <%@ page import="java.sql.SQLException" %>

                    <% User user=(User) session.getAttribute("user"); if (user==null ||
                        !"MANAGER".equals(user.getRole())) { response.sendRedirect(request.getContextPath()
                        + "/jsp/auth/login.jsp" ); return; }
                        List<BlogPost> blogs = null;
                        try { blogs = BlogDAO.getAllPosts(); } catch (SQLException e) { blogs = new java.util.ArrayList<>(); }
                        int pendingCount = 0;
                        int approvedCount = (blogs != null) ? blogs.size() : 0;
                        %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <%@ include file="/includes/dashboard_head.jsp" %>
                                <title>Kiểm duyệt Blog - Manager</title>
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
                                                        <h4 class="mb-1"><i class="fas fa-blog me-2"></i>Kiểm duyệt Blog
                                                            Y khoa</h4>
                                                        <p class="text-muted mb-0">Quản lý và kiểm duyệt các bài viết y
                                                            khoa</p>
                                                    </div>
                                                    <button class="btn-dashboard btn-dashboard-primary"
                                                        data-bs-toggle="modal" data-bs-target="#addBlogModal">
                                                        <i class="fas fa-plus"></i> Thêm blog mới
                                                    </button>
                                                </div>

                                                <!-- Stats Cards -->
                                                <div class="row g-4 mb-4">
                                                    <div class="col-12 col-sm-6 col-xl-4">
                                                        <div class="stat-card">
                                                            <div class="stat-card-icon">
                                                                <i class="fas fa-newspaper"></i>
                                                            </div>
                                                            <div class="stat-card-value">
                                                                <%= blogs.size() %>
                                                            </div>
                                                            <div class="stat-card-label">Tổng số bài viết</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-sm-6 col-xl-4">
                                                        <div class="stat-card warning">
                                                            <div class="stat-card-icon">
                                                                <i class="fas fa-clock"></i>
                                                            </div>
                                                            <div class="stat-card-value">
                                                                <%= pendingCount %>
                                                            </div>
                                                            <div class="stat-card-label">Chờ duyệt</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-sm-6 col-xl-4">
                                                        <div class="stat-card success">
                                                            <div class="stat-card-icon">
                                                                <i class="fas fa-check-circle"></i>
                                                            </div>
                                                            <div class="stat-card-value">
                                                                <%= approvedCount %>
                                                            </div>
                                                            <div class="stat-card-label">Đã duyệt</div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Filters -->
                                                <div class="dashboard-card mb-4">
                                                    <div class="row g-3 align-items-center">
                                                        <div class="col-md-4">
                                                            <div class="input-group">
                                                                <span class="input-group-text bg-white"><i
                                                                        class="fas fa-search text-muted"></i></span>
                                                                <input type="text" class="form-control" id="searchInput"
                                                                    placeholder="Tìm kiếm blog..."
                                                                    onkeyup="filterTable()">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <select class="form-select" id="categoryFilter"
                                                                onchange="filterTable()">
                                                                <option value="">Tất cả danh mục</option>
                                                                <option value="HEALTH_TIPS">Mẹo sức khỏe</option>
                                                                <option value="DISEASE_INFO">Thông tin bệnh</option>
                                                                <option value="NUTRITION">Dinh dưỡng</option>
                                                                <option value="MEDICAL_NEWS">Tin tức y tế</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <select class="form-select" id="statusFilter"
                                                                onchange="filterTable()">
                                                                <option value="">Tất cả trạng thái</option>
                                                                <option value="PENDING">Chờ duyệt</option>
                                                                <option value="APPROVED">Đã duyệt</option>
                                                                <option value="REJECTED">Từ chối</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Blogs Table -->
                                                <div class="dashboard-card">
                                                    <div class="table-responsive">
                                                        <table class="dashboard-table" id="blogsTable">
                                                            <thead>
                                                                <tr>
                                                                    <th style="width: 50px;">ID</th>
                                                                    <th style="width: 100px;">Ảnh</th>
                                                                    <th>Tiêu đề</th>
                                                                    <th>Tác giả</th>
                                                                    <th>Danh mục</th>
                                                                    <th>Ngày đăng</th>
                                                                    <th>Trạng thái</th>
                                                                    <th>Thao tác</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% if (blogs.isEmpty()) { %>
                                                                    <tr>
                                                                        <td colspan="8" class="text-center py-5">
                                                                            <i class="fas fa-newspaper text-muted"
                                                                                style="font-size: 48px;"></i>
                                                                            <p class="text-muted mt-3">Chưa có bài viết
                                                                                nào</p>
                                                                        </td>
                                                                    </tr>
                                                                    <% } else { for (Blog blog : blogs) { %>
                                                                        <tr data-category="<%= blog.getCategory() %>"
                                                                            data-status="<%= blog.getStatus() %>">
                                                                            <td><span class="badge bg-secondary">#<%=
                                                                                        blog.getId() %></span></td>
                                                                            <td>
                                                                                <img src="<%= blog.getImage() != null ? blog.getImage() : request.getContextPath() + "
                                                                                    /img/default-blog.jpg" %>"
                                                                                class="rounded" style="width: 80px;
                                                                                height: 50px; object-fit: cover;"
                                                                                alt="Blog Image">
                                                                            </td>
                                                                            <td>
                                                                                <strong class="d-block mb-1">
                                                                                    <%= blog.getTitle() %>
                                                                                </strong>
                                                                                <small class="text-muted"
                                                                                    style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                                                                    <%= blog.getContent() !=null ?
                                                                                        blog.getContent().substring(0,
                                                                                        Math.min(100,
                                                                                        blog.getContent().length()))
                                                                                        + "..." : "" %>
                                                                                </small>
                                                                            </td>
                                                                            <td>
                                                                                <%= blog.getAuthor() %>
                                                                            </td>
                                                                            <td><span
                                                                                    class="badge-dashboard badge-info">
                                                                                    <%= blog.getCategory() %>
                                                                                </span></td>
                                                                            <td>
                                                                                <%= blog.getCreatedAt() %>
                                                                            </td>
                                                                            <td>
                                                                                <span class="badge bg-<%= "
                                                                                    PENDING".equals(blog.getStatus())
                                                                                    ? "warning" : "APPROVED"
                                                                                    .equals(blog.getStatus())
                                                                                    ? "success" : "danger" %>">
                                                                                    <%= "PENDING"
                                                                                        .equals(blog.getStatus())
                                                                                        ? "Chờ duyệt" : "APPROVED"
                                                                                        .equals(blog.getStatus())
                                                                                        ? "Đã duyệt" : "Từ chối" %>
                                                                                </span>
                                                                            </td>
                                                                            <td>
                                                                                <button
                                                                                    class="btn btn-sm btn-outline-info me-1"
                                                                                    title="Xem chi tiết">
                                                                                    <i class="fas fa-eye"></i>
                                                                                </button>
                                                                                <% if
                                                                                    (!"APPROVED".equals(blog.getStatus()))
                                                                                    { %>
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-success me-1"
                                                                                        title="Duyệt">
                                                                                        <i class="fas fa-check"></i>
                                                                                    </button>
                                                                                    <% } %>
                                                                                        <% if
                                                                                            (!"REJECTED".equals(blog.getStatus()))
                                                                                            { %>
                                                                                            <button
                                                                                                class="btn btn-sm btn-outline-danger"
                                                                                                title="Từ chối">
                                                                                                <i
                                                                                                    class="fas fa-times"></i>
                                                                                            </button>
                                                                                            <% } %>
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

                            <!-- Add Blog Modal -->
                            <div class="modal fade" id="addBlogModal" tabindex="-1">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Thêm blog mới</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/AddBlogServlet" method="POST"
                                            enctype="multipart/form-data">
                                            <div class="modal-body">
                                                <div class="mb-3">
                                                    <label class="form-label">Tiêu đề <span
                                                            class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" name="title" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Danh mục <span
                                                            class="text-danger">*</span></label>
                                                    <select class="form-select" name="category" required>
                                                        <option value="HEALTH_TIPS">Mẹo sức khỏe</option>
                                                        <option value="DISEASE_INFO">Thông tin bệnh</option>
                                                        <option value="NUTRITION">Dinh dưỡng</option>
                                                        <option value="MEDICAL_NEWS">Tin tức y tế</option>
                                                    </select>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Nội dung <span
                                                            class="text-danger">*</span></label>
                                                    <textarea class="form-control" name="content" rows="8"
                                                        required></textarea>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Ảnh bìa</label>
                                                    <input type="file" class="form-control" name="image"
                                                        accept="image/*">
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Hủy</button>
                                                <button type="submit" class="btn btn-primary">Thêm blog</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <%@ include file="/includes/dashboard_scripts.jsp" %>

                                <script>
                                    function filterTable() {
                                        var searchInput = document.getElementById("searchInput").value.toLowerCase();
                                        var categoryFilter = document.getElementById("categoryFilter").value;
                                        var statusFilter = document.getElementById("statusFilter").value;
                                        var table = document.getElementById("blogsTable");
                                        var tr = table.getElementsByTagName("tr");

                                        for (var i = 1; i < tr.length; i++) {
                                            var category = tr[i].getAttribute("data-category");
                                            var status = tr[i].getAttribute("data-status");
                                            var td = tr[i].getElementsByTagName("td");
                                            var show = true;

                                            // Category filter
                                            if (categoryFilter && category !== categoryFilter) {
                                                show = false;
                                            }

                                            // Status filter
                                            if (statusFilter && status !== statusFilter) {
                                                show = false;
                                            }

                                            // Search filter
                                            if (searchInput) {
                                                var textContent = tr[i].textContent || tr[i].innerText;
                                                if (textContent.toLowerCase().indexOf(searchInput) === -1) {
                                                    show = false;
                                                }
                                            }

                                            tr[i].style.display = show ? "" : "none";
                                        }
                                    }
                                </script>
                        </body>

                        </html>