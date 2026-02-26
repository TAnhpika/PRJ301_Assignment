<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Modal Base Component
    Reusable Bootstrap modal template
    
    Usage:
    <jsp:include page="/includes/components/modal_base.jsp">
        <jsp:param name="modalId" value="myModal"/>
        <jsp:param name="title" value="Tiêu đề Modal"/>
        <jsp:param name="size" value="lg"/>
        <jsp:param name="showFooter" value="true"/>
        <jsp:param name="submitBtnText" value="Lưu"/>
        <jsp:param name="cancelBtnText" value="Hủy"/>
    </jsp:include>
    
    Sizes: sm, lg, xl (default: md - no class needed)
    
    Note: The modal body content should be added separately using JavaScript 
    or by including content into the modal-body div with ID: {modalId}-body
--%>
<%
    String modalId = request.getParameter("modalId");
    String title = request.getParameter("title");
    String size = request.getParameter("size");
    String showFooter = request.getParameter("showFooter");
    String submitBtnText = request.getParameter("submitBtnText");
    String cancelBtnText = request.getParameter("cancelBtnText");
    String submitBtnClass = request.getParameter("submitBtnClass");
    String onSubmit = request.getParameter("onSubmit");
    String centered = request.getParameter("centered");
    String staticBackdrop = request.getParameter("staticBackdrop");
    
    if (modalId == null) modalId = "defaultModal";
    if (title == null) title = "Modal";
    if (size == null) size = "";
    if (showFooter == null) showFooter = "true";
    if (submitBtnText == null) submitBtnText = "Lưu";
    if (cancelBtnText == null) cancelBtnText = "Hủy";
    if (submitBtnClass == null) submitBtnClass = "btn-dashboard-primary";
    if (onSubmit == null) onSubmit = "";
    if (centered == null) centered = "false";
    if (staticBackdrop == null) staticBackdrop = "false";
    
    String sizeClass = "";
    if ("sm".equals(size)) sizeClass = "modal-sm";
    else if ("lg".equals(size)) sizeClass = "modal-lg";
    else if ("xl".equals(size)) sizeClass = "modal-xl";
%>

<div class="modal fade" 
     id="<%= modalId %>" 
     tabindex="-1" 
     aria-labelledby="<%= modalId %>Label" 
     aria-hidden="true"
     <% if ("true".equals(staticBackdrop)) { %>data-bs-backdrop="static" data-bs-keyboard="false"<% } %>
>
    <div class="modal-dialog <%= sizeClass %> <% if ("true".equals(centered)) { %>modal-dialog-centered<% } %>">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="<%= modalId %>Label"><%= title %></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            <div class="modal-body" id="<%= modalId %>-body">
                <!-- Content will be inserted here -->
            </div>
            <% if ("true".equals(showFooter)) { %>
            <div class="modal-footer">
                <button type="button" class="btn-dashboard btn-dashboard-secondary" data-bs-dismiss="modal">
                    <%= cancelBtnText %>
                </button>
                <button type="button" 
                        class="btn-dashboard <%= submitBtnClass %>"
                        <% if (!onSubmit.isEmpty()) { %>onclick="<%= onSubmit %>"<% } %>
                        id="<%= modalId %>-submit">
                    <%= submitBtnText %>
                </button>
            </div>
            <% } %>
        </div>
    </div>
</div>
