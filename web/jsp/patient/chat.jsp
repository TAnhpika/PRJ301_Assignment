<%@page import="java.util.Map" %>
<%@page import="model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    Integer currentUserId = (user != null) ? user.getId() : null;
    String currentUsername = (user != null) ? user.getEmail() : null;
    String currentUserRole = (user != null) ? user.getRole() : null;

    if (currentUserId == null || currentUsername == null || currentUsername.isEmpty() || currentUserRole == null || currentUserRole.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Tư vấn trực tuyến - Happy Smile</title>
    <style>
        .chat-layout { height: calc(100vh - 140px); display: flex; gap: 20px; }
        .doctors-list { width: 320px; background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; overflow: hidden; }
        .doctors-list-header { padding: 20px; border-bottom: 1px solid #eef2f6; background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); }
        .doctors-list-body { flex: 1; overflow-y: auto; padding: 10px; }
        .doctor-item { display: flex; align-items: center; padding: 15px; margin-bottom: 8px; border-radius: 12px; cursor: pointer; transition: all 0.3s ease; border: 1px solid transparent; }
        .doctor-item:hover { background-color: #f8f9fa; border-color: #eef2f6; }
        .doctor-item.active { background-color: #eff6ff; border-color: #cce0ff; box-shadow: 0 4px 10px rgba(67, 97, 238, 0.1); }
        .doctor-avatar-wrapper { position: relative; margin-right: 15px; flex-shrink: 0; }
        .doctor-avatar { width: 48px; height: 48px; border-radius: 50%; object-fit: cover; border: 2px solid white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .status-dot { position: absolute; bottom: 0; right: 0; width: 14px; height: 14px; background-color: #2ecc71; border: 2px solid white; border-radius: 50%; }
        
        .chat-window { flex: 1; min-width: 0; background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; overflow: hidden; }
        .chat-header { padding: 20px; border-bottom: 1px solid #eef2f6; display: flex; align-items: center; justify-content: space-between; background: linear-gradient(135deg, #ffffff 0%, #fcfdfe 100%); }
        .chat-partner-info { display: flex; align-items: center; }
        .chat-body { flex: 1; overflow-y: auto; overflow-x: hidden; padding: 25px; background-color: #f8fbfd; display: flex; flex-direction: column; gap: 15px; }
        .message-wrapper { display: flex; max-width: 75%; }
        .message-wrapper.me { align-self: flex-end; justify-content: flex-end; }
        .message-wrapper.other { align-self: flex-start; }
        
        .message-bubble { padding: 12px 18px; border-radius: 20px; font-size: 15px; line-height: 1.5; white-space: pre-wrap; word-break: break-word; box-shadow: 0 2px 6px rgba(0,0,0,0.05); }
        .message-wrapper.me .message-bubble { background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%); color: white; border-bottom-right-radius: 4px; }
        .message-wrapper.other .message-bubble { background: white; color: #2b3452; border-bottom-left-radius: 4px; border: 1px solid #eef2f6; }
        .system-message { text-align: center; color: #8e9bb0; font-size: 13px; margin: 10px 0; font-style: italic; width: 100%; display: flex; justify-content: center; }
        .system-message span { background: #f1f5f9; padding: 4px 12px; border-radius: 20px; }
        
        .chat-footer { padding: 20px; border-top: 1px solid #eef2f6; background: white; }
        .chat-input-wrapper { display: flex; align-items: center; background: #f8f9fa; border-radius: 30px; padding: 8px 15px; border: 1px solid #eef2f6; transition: border-color 0.3s; }
        .chat-input-wrapper:focus-within { border-color: #4361ee; background: white; box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.1); }
        .chat-input { border: none; background: transparent; flex: 1; padding: 8px; font-size: 15px; outline: none; }
        .btn-send { background: #4361ee; color: white; border: none; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.3s; }
        .btn-send:hover { background: #3f37c9; transform: scale(1.05); }
        .btn-send:disabled { background: #cbd5e1; cursor: not-allowed; transform: none; }
        
        .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; width: 100%; color: #8e9bb0; }
        .empty-state i { font-size: 64px; margin-bottom: 20px; color: #cbd5e1; }
        
        @media (max-width: 992px) {
            .chat-layout { flex-direction: column; height: auto; }
            .doctors-list { width: 100%; height: 300px; }
            .chat-window { height: 600px; }
        }
        
        /* Custom Scrollbar for Chat */
        .chat-body::-webkit-scrollbar, .doctors-list-body::-webkit-scrollbar { width: 6px; }
        .chat-body::-webkit-scrollbar-track, .doctors-list-body::-webkit-scrollbar-track { background: transparent; }
        .chat-body::-webkit-scrollbar-thumb, .doctors-list-body::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
        .chat-body::-webkit-scrollbar-thumb:hover, .doctors-list-body::-webkit-scrollbar-thumb:hover { background: #94a3b8; }
    </style>
</head>

<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/patient/user_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/patient/user_header.jsp" %>
        
        <div class="dashboard-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="mb-0 text-primary fw-bold"><i class="fas fa-stethoscope me-2"></i>Tư vấn trực tuyến</h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0 mt-1">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/UserHompageServlet" class="text-decoration-none">Trang chủ</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Tư vấn Bác sĩ</li>
                        </ol>
                    </nav>
                </div>
            </div>
            
            <div class="chat-layout">
                <!-- Danh sách bác sĩ online -->
                <div class="doctors-list">
                    <div class="doctors-list-header">
                        <h6 class="mb-0 fw-bold text-dark"><i class="fas fa-user-md me-2 text-primary"></i>Bác sĩ Online</h6>
                        <small class="text-muted">Nhấn vào để bắt đầu tư vấn</small>
                    </div>
                    <div class="doctors-list-body" id="doctorList">
                        <div class="text-center mt-5">
                            <div class="spinner-border text-primary spinner-border-sm" role="status"></div>
                            <p class="text-muted mt-2 small">Đang kết nối...</p>
                        </div>
                    </div>
                </div>

                <!-- Khung chat -->
                <div class="chat-window">
                    <div class="chat-header">
                        <div class="chat-partner-info">
                            <div class="doctor-avatar-wrapper me-3" id="chatPartnerAvatarWrapper" style="display: none;">
                                <img src="${pageContext.request.contextPath}/view/assets/img/default-user-avatar.png" class="doctor-avatar" alt="Doctor avatar">
                                <div class="status-dot"></div>
                            </div>
                            <div>
                                <h5 class="mb-0 fw-bold text-dark" id="chatPartnerName">Hộp thư tư vấn</h5>
                                <small class="text-muted" id="chatPartnerRole">Vui lòng chọn bác sĩ từ danh sách bên trái</small>
                            </div>
                        </div>
                        <div class="chat-actions d-none" id="chatActions">
                            <span class="badge bg-success-subtle text-success rounded-pill px-3 py-2" style="background-color: #d1e7dd; color: #0f5132 !important;">
                                <i class="fas fa-circle me-1" style="font-size:8px"></i>Đang online
                            </span>
                        </div>
                    </div>
                    
                    <div class="chat-body" id="chatBox">
                        <div class="empty-state" id="chatEmptyState">
                            <i class="far fa-comments"></i>
                            <h5 class="fw-bold text-secondary">Bắt đầu trò chuyện</h5>
                            <p class="text-muted">Gửi và nhận tin nhắn để được tư vấn sức khỏe</p>
                        </div>
                    </div>
                    
                    <div class="chat-footer">
                        <div class="chat-input-wrapper">
                            <button class="btn btn-link text-muted px-2" title="Đính kèm tệp"><i class="fas fa-paperclip"></i></button>
                            <button class="btn btn-link text-muted px-2" title="Gửi ảnh"><i class="far fa-image"></i></button>
                            <input type="text" id="inputMsg" class="chat-input" placeholder="Nhập câu hỏi của bạn..." onkeyup="if(event.keyCode === 13) sendMessage()" disabled autocomplete="off">
                            <button class="btn-send ms-2" id="sendBtn" onclick="sendMessage()" disabled>
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    </div>
    
    <%@ include file="/view/layout/dashboard_scripts.jsp" %>
    
    <!-- CHAT SCRIPT -->
    <script>
        const contextPath = "${pageContext.request.contextPath}";
        const CURRENT_USERNAME = "<%= currentUsername %>";
        const CURRENT_USER_ID = <%= currentUserId != null ? currentUserId : "null" %>;
        const CURRENT_USER_ROLE = "<%= currentUserRole %>";
        
        let ws = null;
        let chatBox = document.getElementById("chatBox");
        let btnSend = document.getElementById("sendBtn");
        let inputMsg = document.getElementById("inputMsg");
        let chatEmptyState = document.getElementById("chatEmptyState");
        let chatActionsDiv = document.getElementById("chatActions");
        
        let chatPartnerId = null; 
        let chatPartnerName = ""; 
        let chatPartnerRole = ""; 
        const onlineDoctors = new Map();

        function connectWebSocket() {
            // Sử dụng wss:// cho HTTPS, ws:// cho HTTP
            ws = new WebSocket("ws://" + window.location.host + contextPath + "/chat");

            ws.onopen = function() {
                addMessage("Hệ thống: Đã kết nối an toàn với máy chủ tư vấn.", 'system');
            };

            ws.onmessage = function(event) {
                let receivedRawMessage = event.data;
                const parts = receivedRawMessage.split('|', 6);

                if (parts[0] === 'doctorlist') {
                    handleUserList('doctor', receivedRawMessage.substring("doctorlist|".length));
                    return;
                }

                if (parts.length < 6) return; // Nếu ko đủ 6 phần thì bỏ qua

                const type = parts[0];
                const senderId = parseInt(parts[1]);
                const senderName = parts[2];
                const senderRole = parts[3];
                const receiverId = (parts[4] === 'null' || parts[4] === '') ? null : parseInt(parts[4]);
                const content = parts[5];

                if (type === 'system' || type === 'error') {
                    addMessage(content, 'system');
                } else if (type === 'chat' || type === 'history') {
                    let isFromMe = (senderId === CURRENT_USER_ID);
                    let belongsToActiveChat = false;

                    // Kiểm tra tin nhắn này có thuộc cuộc trò chuyện hiện tại đang mở ko
                    if (isFromMe) {
                        if (receiverId !== null && receiverId === chatPartnerId) { belongsToActiveChat = true; }
                    } else {
                        if (receiverId === CURRENT_USER_ID && senderId === chatPartnerId) { belongsToActiveChat = true; }
                        // Nếu nhận được tin từ bác sĩ nhưng chưa chọn ai → tự động chọn bác sĩ đó
                        else if (receiverId === CURRENT_USER_ID && chatPartnerId === null) {
                            if (onlineDoctors.has(senderId)) {
                                const d = onlineDoctors.get(senderId);
                                selectChatPartner(senderId, d.name, d.role);
                                belongsToActiveChat = true;
                            }
                        }
                    }

                    if (belongsToActiveChat) {
                        chatEmptyState.style.display = 'none';
                        if (isFromMe && type === 'chat') {
                            // Optimistic UI – bỏ qua confirm từ server
                        } else if (isFromMe && type === 'history') {
                            addMessage(content, 'me');
                        } else {
                            addMessage(content, 'other');
                        }
                    } else if (!isFromMe && receiverId === CURRENT_USER_ID && type === 'chat') {
                        // Bác sĩ nhắn tin nhưng bệnh nhân định chọn bác sĩ khác → show badge
                        const senderItem = document.querySelector(`[data-user-id="<%= "$" %>{senderId}"]`);
                        if (senderItem) {
                            let badge = senderItem.querySelector('.unread-badge');
                            if (!badge) {
                                badge = document.createElement('span');
                                badge.className = 'unread-badge badge bg-danger rounded-pill ms-auto';
                                badge.textContent = '1';
                                senderItem.appendChild(badge);
                            } else {
                                badge.textContent = parseInt(badge.textContent||'0') + 1;
                            }
                        }
                    }
                }
            };

            ws.onclose = function() {
                addMessage("Đã ngắt kết nối. Đang thử kết nối lại...", 'system');
                setTimeout(connectWebSocket, 3000); // Reconnect logic tự động
            };
            
            ws.onerror = function(error) {
                console.error("WebSocket Error:", error);
            };
        }

        window.onload = function() {
            if (CURRENT_USER_ID !== null) {
                connectWebSocket();
            }
        };

        function addMessage(text, type) {
            if(type !== 'system' && chatEmptyState) chatEmptyState.style.display = 'none';
            
            if (type === 'system') {
                let sysWrapper = document.createElement("div");
                sysWrapper.className = "system-message";
                sysWrapper.innerHTML = `<span><%= "$" %>{text}</span>`;
                chatBox.appendChild(sysWrapper);
            } else {
                let wrapperMain = document.createElement("div"); 
                wrapperMain.className = "d-flex w-100 flex-column";
                
                let wrapper = document.createElement("div");
                wrapper.classList.add('message-wrapper');
                wrapper.classList.add(type);

                let bubble = document.createElement("div");
                bubble.className = "message-bubble";
                bubble.innerText = text;
                
                wrapper.appendChild(bubble);
                wrapperMain.appendChild(wrapper);
                chatBox.appendChild(wrapperMain);
            }
            chatBox.scrollTop = chatBox.scrollHeight;
        }

        function sendMessage() {
            let msg = inputMsg.value.trim();
            if (!msg) return;

            if (CURRENT_USER_ID === null) {
                addMessage("Bạn cần đăng nhập để gửi tin nhắn.", 'system');
                return;
            }

            if (chatPartnerId === null && CURRENT_USER_ROLE === 'patient') {
                addMessage("Vui lòng chọn bác sĩ để nhắn tin.", 'system');
                return;
            }

            if (msg && ws && ws.readyState === WebSocket.OPEN) {
                const receiverToSend = chatPartnerId !== null ? chatPartnerId : 0;
                const messageToSend = receiverToSend + "|" + msg;

                addMessage(msg, 'me'); // Hiển thị lập tức cho mượt UI
                ws.send(messageToSend); // Gửi vào socket xử lý lưu DB
                inputMsg.value = "";
                inputMsg.focus();
            }
        }

        function handleUserList(userType, data) {
            const userListDiv = document.getElementById('doctorList');
            if (!userListDiv) return;

            onlineDoctors.clear();
            userListDiv.innerHTML = '';

            let hasUsers = false;
            if (data) {
                const users = data.split(';');
                users.forEach(userStr => {
                    const parts = userStr.split(':');
                    if (parts.length === 3) {
                        hasUsers = true;
                        const id = parseInt(parts[0]);
                        const name = parts[1];
                        const role = parts[2];

                        onlineDoctors.set(id, { name: name, role: role });

                        const userItem = document.createElement('div');
                        userItem.className = 'doctor-item';
                        userItem.dataset.userId = id;
                        
                        userItem.innerHTML = `
                            <div class="doctor-avatar-wrapper">
                                <img src="<%= "$" %>{contextPath}/view/assets/img/default-user-avatar.png" class="doctor-avatar" alt="Avatar">
                                <div class="status-dot"></div>
                            </div>
                            <div class="flex-grow-1 overflow-hidden">
                                <h6 class="mb-1 text-truncate text-dark fw-bold">BS. <%= "$" %>{name}</h6>
                                <p class="mb-0 small text-muted text-truncate"><%= "$" %>{role}</p>
                            </div>
                        `;

                        userItem.onclick = function() {
                            selectChatPartner(id, name, role);
                        };
                        userListDiv.appendChild(userItem);
                    }
                });
            }

            if (!hasUsers) {
                userListDiv.innerHTML = `
                    <div class="text-center mt-5 text-muted">
                        <i class="fas fa-stethoscope fs-1 mb-3 text-light" style="color:#eef2f6!important"></i>
                        <p>Hiện không có bác sĩ nào online.</p>
                    </div>
                `;
                btnSend.disabled = true;
                inputMsg.disabled = true;
            } else {
                // Tự động chọn ông bác sĩ đầu tiên nếu chưa chọn ai
                if (chatPartnerId === null || !onlineDoctors.has(chatPartnerId)) {
                    const firstDoctorId = onlineDoctors.keys().next().value;
                    if (firstDoctorId) {
                        const firstDoctorInfo = onlineDoctors.get(firstDoctorId);
                        selectChatPartner(firstDoctorId, firstDoctorInfo.name, firstDoctorInfo.role);
                    }
                }
            }
            
            // Mark the selected one as active after re-rendering list
            if (chatPartnerId !== null) {
                const selectedItem = document.querySelector(`[data-user-id="<%= "$" %>{chatPartnerId}"]`);
                if (selectedItem) selectedItem.classList.add('active');
            }
        }

        function selectChatPartner(id, name, role) {
            chatPartnerId = id;
            chatPartnerName = name;
            chatPartnerRole = role;
            
            document.getElementById('chatPartnerName').textContent = "BS. " + name;
            document.getElementById('chatPartnerRole').textContent = role; // Usually "Bác sĩ"
            document.getElementById('chatPartnerAvatarWrapper').style.display = 'block';
            chatActionsDiv.classList.remove('d-none');
            
            btnSend.disabled = false;
            inputMsg.disabled = false;
            inputMsg.focus();

            chatBox.innerHTML = ''; // Làm trắng khung chat để tải cái mới
            chatEmptyState.style.display = 'none'; 
            
            addMessage("Đang tải dữ liệu hồ sơ nhắn tin bảo mật...", 'system');

            document.querySelectorAll('.doctor-item').forEach(item => {
                item.classList.remove('active');
            });
            const selectedItem = document.querySelector(`[data-user-id="<%= "$" %>{id}"]`);
            if (selectedItem) selectedItem.classList.add('active');

            ws.send("HISTORY_REQUEST|" + chatPartnerId); // Gửi tín hiệu lấy History
        }
    </script>
</body>
</html>