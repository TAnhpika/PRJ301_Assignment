<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Confirm Modal Component
    Reusable confirmation dialog modal
    
    Usage:
    <jsp:include page="/includes/components/confirm_modal.jsp">
        <jsp:param name="modalId" value="deleteConfirmModal"/>
        <jsp:param name="title" value="Xác nhận xóa"/>
        <jsp:param name="message" value="Bạn có chắc chắn muốn xóa?"/>
        <jsp:param name="confirmText" value="Xóa"/>
        <jsp:param name="confirmVariant" value="danger"/>
    </jsp:include>
    
    To trigger: 
    <button data-bs-toggle="modal" data-bs-target="#deleteConfirmModal">Delete</button>
    
    To handle confirm:
    document.getElementById('deleteConfirmModal-confirm').onclick = function() { ... }
--%>
<%
    String modalId = request.getParameter("modalId");
    String title = request.getParameter("title");
    String message = request.getParameter("message");
    String confirmText = request.getParameter("confirmText");
    String cancelText = request.getParameter("cancelText");
    String confirmVariant = request.getParameter("confirmVariant");
    String icon = request.getParameter("icon");
    String iconColor = request.getParameter("iconColor");
    
    if (modalId == null) modalId = "confirmModal";
    if (title == null) title = "Xác nhận";
    if (message == null) message = "Bạn có chắc chắn muốn thực hiện thao tác này?";
    if (confirmText == null) confirmText = "Xác nhận";
    if (cancelText == null) cancelText = "Hủy";
    if (confirmVariant == null) confirmVariant = "primary";
    if (icon == null) icon = "fa-question-circle";
    if (iconColor == null) {
        switch (confirmVariant) {
            case "danger": iconColor = "danger"; break;
            case "warning": iconColor = "warning"; break;
            default: iconColor = "primary";
        }
    }
%>

<div class="modal fade" id="<%= modalId %>" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body text-center py-4">
                <i class="fas <%= icon %> fa-4x text-<%= iconColor %> mb-3"></i>
                <h5 class="mb-3"><%= title %></h5>
                <p class="text-muted mb-0" id="<%= modalId %>-message"><%= message %></p>
            </div>
            <div class="modal-footer justify-content-center border-0">
                <button type="button" class="btn-dashboard btn-dashboard-secondary" data-bs-dismiss="modal">
                    <%= cancelText %>
                </button>
                <button type="button" class="btn-dashboard btn-dashboard-<%= confirmVariant %>" id="<%= modalId %>-confirm">
                    <%= confirmText %>
                </button>
            </div>
        </div>
    </div>
</div>
