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
                        %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <%@ include file="/view/layout/dashboard_head.jsp" %>
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
                                                    <div class="col-12">
                                                        <div class="stat-card d-flex flex-column align-items-center justify-content-center py-4">
                                                            <div class="stat-card-icon mb-3">
                                                                 <i class="fas fa-newspaper"></i>
                                                            </div>
                                                            <div class="stat-card-value">
                                                                <%= blogs.size() %>
                                                            </div>
                                                            <div class="stat-card-label">Tổng số bài viết</div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Search Filter -->
                                                <div class="dashboard-card mb-4">
                                                    <div class="row g-3 align-items-center">
                                                        <div class="col-md-12">
                                                            <div class="input-group">
                                                                <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                                                <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm blog..." onkeyup="filterTable()">
                                                            </div>
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
                                                                    <th>Ngày đăng</th>
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
                                                                    <% } else { for (BlogPost blog : blogs) { %>
                                                                        <tr>
                                                                            <td><span class="badge bg-secondary">#<%= blog.getBlogId() %></span></td>
                                                                             <td>
                                                                                 <img src="<%= blog.getImageUrl() != null && !blog.getImageUrl().isEmpty() ? blog.getImageUrl() : request.getContextPath() + "/view/assets/img/default_blog.jpg" %>"
                                                                                     class="rounded" style="width: 80px; height: 50px; object-fit: cover;"
                                                                                     alt="Blog Image"
                                                                                     onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/view/assets/img/default_blog.jpg';">
                                                                             </td>
                                                                            <td>
                                                                                <strong class="d-block mb-1"><%= blog.getTitle() %></strong>
                                                                                <small class="text-muted" style="display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                                                                    <%= blog.getContent() != null ? (blog.getContent().length() > 100 ? blog.getContent().substring(0, 100) + "..." : blog.getContent()) : "" %>
                                                                                </small>
                                                                            </td>
                                                                            <td><%= blog.getCreatedAt() %></td>
                                                                            <td>
                                                                                <button class="btn btn-sm btn-outline-danger" title="Xóa" onclick="confirmDelete(<%= blog.getBlogId() %>)">
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
                            <!-- Hidden Delete Form -->
                            <form id="deleteBlogForm" action="${pageContext.request.contextPath}/DeleteBlogServlet" method="POST" style="display: none;">
                                <input type="hidden" name="blogId" id="deleteBlogId">
                            </form>

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

                            <%@ include file="/view/layout/dashboard_scripts.jsp" %>

                                <script>
                                    function filterTable() {
                                        var searchInput = document.getElementById("searchInput").value.toLowerCase();
                                        var table = document.getElementById("blogsTable");
                                        var tr = table.getElementsByTagName("tr");

                                        for (var i = 1; i < tr.length; i++) {
                                            var show = true;

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

                                    function confirmDelete(id) {
                                        if (confirm('Bạn có chắc chắn muốn xóa bài viết này không?')) {
                                            document.getElementById('deleteBlogId').value = id;
                                            document.getElementById('deleteBlogForm').submit();
                                        }
                                    }
                                </script>
                        </body>

                        </html>