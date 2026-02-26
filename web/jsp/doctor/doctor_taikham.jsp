<%-- 
    Document   : doctor_taikham
    Trang Tái khám - layout dashboard chuẩn
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/includes/dashboard_head.jsp" %>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Tái Khám - Doctor</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-common.css">
        <style>
            .page-header {
                background: #f8fafc;
                color: #1e293b;
                padding: 20px 24px;
                border-radius: 8px;
                margin-bottom: 16px;
                border: 1px solid #e2e8f0;
            }
            .page-header h1 { margin: 0 0 4px 0; font-size: 20px; font-weight: 600; color: #334155; }
            .page-header p { margin: 0; font-size: 13px; color: #64748b; }

            .taikham-search {
                margin-bottom: 20px;
            }
            .taikham-search input {
                width: 100%;
                max-width: 300px;
                padding: 10px 14px 10px 40px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                color: #334155;
                position: relative;
            }
            .taikham-search input:focus { outline: none; border-color: #0d9488; }
            .taikham-search-wrapper { position: relative; max-width: 300px; }
            .taikham-search-wrapper i { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #64748b; font-size: 14px; pointer-events: none; z-index: 1; }
            .taikham-search-wrapper input { padding-left: 38px; }

            .patient-card-container {
                background: #fff;
                border-radius: 10px;
                border: 1px solid #e2e8f0;
                display: flex;
                align-items: center;
                padding: 16px 20px;
                margin-bottom: 12px;
                justify-content: space-between;
                transition: border-color 0.2s ease;
            }
            .patient-card-container:hover { border-color: #cbd5e1; }
            .patient-info { display: flex; align-items: center; gap: 16px; }
            .patient-avatar { border-radius: 50%; width: 56px; height: 56px; object-fit: cover; border: 2px solid #e2e8f0; }
            .patient-details { font-size: 14px; color: #475569; }
            .patient-details b { display: block; color: #1e293b; font-size: 15px; margin-bottom: 4px; }

            .btn-reexam {
                background: #0d9488;
                color: white;
                border: none;
                padding: 9px 18px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 13px;
                font-weight: 600;
                transition: background 0.2s ease;
            }
            .btn-reexam:hover { background: #0f766e; }

            .reexam-popup {
                position: absolute;
                background: white;
                border: 1px solid #e2e8f0;
                padding: 16px;
                border-radius: 10px;
                width: 260px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                display: none;
                z-index: 1000;
            }
            .reexam-popup select, .reexam-popup input[type="date"] {
                width: 100%;
                padding: 8px 10px;
                margin-top: 6px;
                margin-bottom: 10px;
                border-radius: 6px;
                border: 1px solid #e2e8f0;
                font-size: 13px;
            }
            .popup-button-group { display: flex; justify-content: space-between; gap: 10px; margin-top: 12px; }
            .popup-button-group button { padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; font-size: 13px; }
            .btn-cancel { background: #f1f5f9; color: #64748b; }
            .btn-cancel:hover { background: #e2e8f0; }
            .btn-create { background: #0d9488; color: white; }
            .btn-create:hover { background: #0f766e; }

            .pagination-wrapper { text-align: center; margin-top: 24px; }
            .pagination-wrapper span, .pagination-wrapper a {
                display: inline-block; padding: 8px 14px; margin: 0 4px; border-radius: 6px;
                background: #f1f5f9; color: #334155; text-decoration: none; font-size: 13px;
            }
            .pagination-wrapper a:hover { background: #e2e8f0; }
            .pagination-wrapper .active-page { background: #0d9488; color: white; }
        </style>
    </head>
    <body>
        <div class="dashboard-wrapper">
            <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
            <main class="dashboard-main">
                <%@ include file="/jsp/doctor/doctor_header.jsp" %>
                <div class="dashboard-content">
                    <div class="container-fluid">
                        <div class="page-header">
                            <h1><i class="fas fa-redo me-2"></i>Tái khám</h1>
                            <p class="mb-0">Quản lý và tạo yêu cầu tái khám cho bệnh nhân</p>
                        </div>

                        <div class="taikham-search">
                            <div class="taikham-search-wrapper">
                                <i class="fas fa-search"></i>
                                <input type="text" placeholder="Tìm kiếm bệnh nhân..." id="searchInput"/>
                            </div>
                        </div>

                        <div id="patientList">
                            <c:forEach var="i" begin="1" end="6">
                                <div class="patient-card-container">
                                    <div class="patient-info">
                                        <img class="patient-avatar" src="${pageContext.request.contextPath}/img/default-avatar.png" alt="avatar" onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.png'"/>
                                        <div class="patient-details">
                                            <b>Tên bệnh nhân</b>
                                            Địa chỉ: thôn A, xã B, thành phố C<br/>
                                            Giới tính: nam &nbsp;&nbsp; Tuổi: 29
                                        </div>
                                    </div>
                                    <button class="btn-reexam" onclick="showPopup(this)">Tái khám</button>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="pagination-wrapper">
                            <span>&laquo;</span>
                            <a class="active-page" href="#">1</a>
                            <a href="#">2</a>
                            <a href="#">3</a>
                            <span>&raquo;</span>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <div id="reexamPopup" class="reexam-popup">
            <label><strong>Ngày tái khám gợi ý</strong></label>
            <input type="date" id="reexamDate"/>
            <label><strong>Ghi chú</strong></label>
            <input type="text" id="reexamNote" placeholder="Ghi chú (tùy chọn)"/>
            <div class="popup-button-group">
                <button class="btn-cancel" onclick="hidePopup()">Hủy</button>
                <button class="btn-create" onclick="hidePopup()">Tạo yêu cầu</button>
            </div>
        </div>

        <%@ include file="/includes/dashboard_scripts.jsp" %>
        <script>
            function showPopup(button) {
                var popup = document.getElementById("reexamPopup");
                var rect = button.getBoundingClientRect();
                popup.style.top = (rect.bottom + window.scrollY + 8) + "px";
                popup.style.left = (rect.left + window.scrollX) + "px";
                popup.style.display = "block";
            }
            function hidePopup() {
                document.getElementById("reexamPopup").style.display = "none";
            }
            document.addEventListener('click', function(e) {
                var popup = document.getElementById("reexamPopup");
                var btn = e.target.closest('.btn-reexam');
                if (!popup.contains(e.target) && !btn) hidePopup();
            });
            document.getElementById("searchInput").addEventListener("input", function() {
                var keyword = this.value.toLowerCase();
                document.querySelectorAll(".patient-card-container").forEach(function(card) {
                    var name = (card.querySelector(".patient-details b") || {}).textContent || "";
                    card.style.display = name.toLowerCase().includes(keyword) ? "" : "none";
                });
            });
        </script>
    </body>
</html>
