<%@page import="model.User"%>
<%@page import="model.Doctors"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    Doctors doctor = (Doctors) session.getAttribute("doctor");
    Integer currentUserId = (user != null) ? user.getId() : null;
    String currentUsername = (doctor != null && doctor.getFullName() != null) 
        ? doctor.getFullName() 
        : (user != null ? user.getEmail() : null);
    String currentUserRole = (user != null) ? user.getRole() : null;

    if (currentUserId == null || currentUsername == null || !"DOCTOR".equalsIgnoreCase(currentUserRole)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Tư vấn bệnh nhân - Happy Smile</title>
    <style>
        .chat-layout { height: calc(100vh - 140px); display: flex; gap: 20px; }

        /* ===== DANH SÁCH BỆNH NHÂN BÊN TRÁI ===== */
        .patients-list { width: 320px; background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; overflow: hidden; }
        .patients-list-header { padding: 18px 20px; border-bottom: 1px solid #eef2f6; background: linear-gradient(135deg, #f0f7ff 0%, #e8f0ff 100%); }
        .patients-list-body { flex: 1; overflow-y: auto; padding: 10px; }
        
        .patient-item { display: flex; align-items: center; padding: 14px 15px; margin-bottom: 6px; border-radius: 12px; cursor: pointer; transition: all 0.25s ease; border: 1.5px solid transparent; }
        .patient-item:hover { background-color: #f8f9fa; border-color: #eef2f6; }
        .patient-item.active { background-color: #eff6ff; border-color: #bfdbfe; box-shadow: 0 3px 10px rgba(37, 99, 235, 0.1); }
        
        .patient-avatar-wrapper { position: relative; margin-right: 13px; flex-shrink: 0; }
        .patient-avatar { width: 46px; height: 46px; border-radius: 50%; object-fit: cover; border: 2px solid white; box-shadow: 0 2px 5px rgba(0,0,0,0.12); background: linear-gradient(135deg, #667eea, #764ba2); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 16px; }
        .status-dot { position: absolute; bottom: 0; right: 0; width: 13px; height: 13px; background-color: #22c55e; border: 2px solid white; border-radius: 50%; }
        .patient-unread-badge { background: #ef4444; color: white; font-size: 11px; font-weight: 700; border-radius: 50%; width: 20px; height: 20px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        
        /* ===== KHUNG CHAT CHÍNH ===== */
        .chat-window { flex: 1; min-width: 0; background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; overflow: hidden; }
        .chat-header { padding: 18px 22px; border-bottom: 1px solid #eef2f6; display: flex; align-items: center; justify-content: space-between; background: white; }
        .chat-partner-avatar { width: 44px; height: 44px; border-radius: 50%; background: linear-gradient(135deg, #667eea, #764ba2); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 16px; margin-right: 12px; flex-shrink: 0; }
        
        .chat-body { flex: 1; overflow-y: auto; overflow-x: hidden; padding: 22px 25px; background-color: #f8fbfd; display: flex; flex-direction: column; gap: 12px; }
        
        .message-wrapper { display: flex; max-width: 72%; }
        .message-wrapper.me { align-self: flex-end; justify-content: flex-end; }
        .message-wrapper.other { align-self: flex-start; }
        
        .message-bubble { padding: 11px 17px; border-radius: 20px; font-size: 14.5px; line-height: 1.55; white-space: pre-wrap; word-break: break-word; box-shadow: 0 1px 4px rgba(0,0,0,0.06); }
        .message-wrapper.me .message-bubble { background: linear-gradient(135deg, #2563eb 0%, #4f46e5 100%); color: white; border-bottom-right-radius: 4px; }
        .message-wrapper.other .message-bubble { background: white; color: #1e293b; border-bottom-left-radius: 4px; border: 1px solid #e9eef4; }
        
        .system-message { text-align: center; color: #94a3b8; font-size: 12.5px; margin: 6px 0; font-style: italic; width: 100%; display: flex; justify-content: center; }
        .system-message span { background: #f1f5f9; padding: 4px 14px; border-radius: 20px; }
        
        .chat-footer { padding: 16px 20px; border-top: 1px solid #eef2f6; background: white; }
        .chat-input-wrapper { display: flex; align-items: center; background: #f8fafc; border-radius: 30px; padding: 7px 15px; border: 1.5px solid #e2e8f0; transition: all 0.25s; }
        .chat-input-wrapper:focus-within { border-color: #3b82f6; background: white; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.12); }
        .chat-input { border: none; background: transparent; flex: 1; padding: 8px; font-size: 14.5px; outline: none; }
        .btn-send { background: linear-gradient(135deg, #2563eb, #4f46e5); color: white; border: none; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.25s; flex-shrink: 0; }
        .btn-send:hover { transform: scale(1.08); box-shadow: 0 4px 12px rgba(37, 99, 235, 0.35); }
        .btn-send:disabled { background: #cbd5e1; cursor: not-allowed; transform: none; box-shadow: none; }
        
        .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; width: 100%; color: #94a3b8; gap: 10px; }
        .empty-state .icon-big { font-size: 60px; color: #e2e8f0; }
        
        .connection-status { display: inline-flex; align-items: center; gap: 6px; font-size: 12px; padding: 4px 10px; border-radius: 20px; }
        .status-online { background: #dcfce7; color: #16a34a; }
        .status-connecting { background: #fef9c3; color: #b45309; }
        .status-offline { background: #fee2e2; color: #dc2626; }
        
        /* Scrollbar */
        .chat-body::-webkit-scrollbar, .patients-list-body::-webkit-scrollbar { width: 5px; }
        .chat-body::-webkit-scrollbar-track, .patients-list-body::-webkit-scrollbar-track { background: transparent; }
        .chat-body::-webkit-scrollbar-thumb, .patients-list-body::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
        
        @media (max-width: 992px) {
            .chat-layout { flex-direction: column; height: auto; }
            .patients-list { width: 100%; height: 250px; }
            .chat-window { height: 550px; }
        }
        
        /* Typing indicator */
        .typing-indicator span { display: inline-block; width: 8px; height: 8px; border-radius: 50%; background-color: #94a3b8; margin: 0 2px; animation: bounce 1.3s infinite; }
        .typing-indicator span:nth-child(2) { animation-delay: 0.2s; }
        .typing-indicator span:nth-child(3) { animation-delay: 0.4s; }
        @keyframes bounce { 0%, 80%, 100% { transform: translateY(0); } 40% { transform: translateY(-8px); } }
    </style>
</head>

<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/doctor/doctor_header.jsp" %>
        
            <div class="dashboard-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-0 text-primary fw-bold"><i class="fas fa-comments me-2"></i>Tư vấn bệnh nhân</h4>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0 mt-1">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DoctorHomePageServlet" class="text-decoration-none">Trang chủ</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Trò chuyện</li>
                            </ol>
                        </nav>
                    </div>
                    <div>
                        <span class="connection-status status-connecting" id="connectionStatus">
                            <i class="fas fa-circle" style="font-size:8px"></i> Đang kết nối...
                        </span>
                    </div>
                </div>

                <div class="chat-layout">
                    <!-- DANH SÁCH BỆNH NHÂN ONLINE -->
                    <div class="patients-list">
                        <div class="patients-list-header">
                            <h6 class="mb-1 fw-bold text-dark"><i class="fas fa-users me-2 text-primary"></i>Bệnh nhân đang chờ</h6>
                            <small class="text-muted">Chọn để bắt đầu tư vấn</small>
                        </div>
                        <div class="patients-list-body" id="patientList">
                            <div class="text-center mt-4 text-muted">
                                <div class="spinner-border text-primary spinner-border-sm" role="status"></div>
                                <p class="mt-2 small">Đang kết nối...</p>
                            </div>
                        </div>
                    </div>

                    <!-- KHUNG CHAT -->
                    <div class="chat-window">
                        <div class="chat-header">
                            <div class="d-flex align-items-center">
                                <div class="chat-partner-avatar d-none" id="partnerAvatarDiv">
                                    <span id="partnerAvatarLetter">B</span>
                                </div>
                                <div>
                                    <h5 class="mb-0 fw-bold text-dark" id="chatPartnerName">Hộp thư tư vấn</h5>
                                    <small class="text-muted" id="chatPartnerSub">Chọn bệnh nhân từ danh sách bên trái</small>
                                </div>
                            </div>
                            <div class="d-none" id="chatHeaderActions">
                                <span class="badge bg-success-subtle text-success rounded-pill px-3 py-2">
                                    <i class="fas fa-circle me-1" style="font-size:8px"></i>Đang online
                                </span>
                            </div>
                        </div>

                        <div class="chat-body" id="chatBox">
                            <div class="empty-state" id="chatEmptyState">
                                <i class="far fa-comment-dots icon-big"></i>
                                <h5 class="fw-bold text-secondary mb-1">Sẵn sàng tư vấn</h5>
                                <p class="text-muted text-center" style="max-width:300px">Chọn bệnh nhân từ danh sách bên trái để bắt đầu cuộc hội thoại.</p>
                            </div>
                        </div>

                        <div class="chat-footer">
                            <div class="chat-input-wrapper">
                                <input type="text" id="inputMsg" class="chat-input" 
                                    placeholder="Nhập câu trả lời tư vấn..." 
                                    onkeydown="if(event.key === 'Enter' && !event.shiftKey) { event.preventDefault(); sendMessage(); }"
                                    disabled autocomplete="off">
                                <button class="btn-send ms-2" id="sendBtn" onclick="sendMessage()" disabled>
                                    <i class="fas fa-paper-plane"></i>
                                </button>
                            </div>
                            <div class="text-end mt-1">
                                <small class="text-muted" style="font-size:11px">
                                    <i class="fas fa-lock me-1"></i>Cuộc trò chuyện được mã hoá & bảo mật
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="/view/layout/dashboard_scripts.jsp" %>

    <!-- DOCTOR CHAT SCRIPT -->
    <script>
        const contextPath = "${pageContext.request.contextPath}";
        const CURRENT_USER_ID = <%= currentUserId %>;
        const CURRENT_USERNAME = "<%= currentUsername %>";
        const CURRENT_USER_ROLE = "<%= currentUserRole %>";

        let ws = null;
        let chatPartnerId = null;
        let chatPartnerName = "";
        const onlinePatients = new Map();

        const chatBox = document.getElementById("chatBox");
        const btnSend = document.getElementById("sendBtn");
        const inputMsg = document.getElementById("inputMsg");
        const chatEmptyState = document.getElementById("chatEmptyState");
        const connectionStatus = document.getElementById("connectionStatus");

        // --- WebSocket ---
        function connectWebSocket() {
            ws = new WebSocket("ws://" + window.location.host + contextPath + "/chat");

            ws.onopen = function () {
                setStatus('online', 'Đang trực tuyến');
                addSystemMsg("Đã kết nối. Bệnh nhân có thể chat với bạn.");
            };

            ws.onmessage = function (event) {
                const raw = event.data;
                const parts = raw.split('|', 6);
                const type = parts[0];

                if (type === 'patientlist') {
                    handlePatientList(raw.substring("patientlist|".length));
                    return;
                }

                // Khi bệnh nhân mới online (thông báo dạng system broadcast)
                if (type === 'system') {
                    const content = parts[5] || "";
                    // Check nếu có bệnh nhân join / leave => refresh list
                    if (content.includes("vừa online") || content.includes("vừa offline")) {
                        // Yêu cầu server gửi lại danh sách bệnh nhân
                        if (ws && ws.readyState === WebSocket.OPEN) {
                            ws.send("PATIENT_LIST_REQUEST");
                        }
                    }
                    return;
                }

                if (parts.length < 6) return;

                const senderId = parseInt(parts[1]);
                const senderName = parts[2];
                const receiverId = (parts[4] === 'null' || parts[4] === '') ? null : parseInt(parts[4]);
                const content = parts[5];

                if (type === 'chat' || type === 'history') {
                    const isFromMe = (senderId === CURRENT_USER_ID);
                    let belongsToThis = false;

                    if (isFromMe && receiverId === chatPartnerId) belongsToThis = true;
                    else if (!isFromMe && senderId === chatPartnerId && receiverId === CURRENT_USER_ID) belongsToThis = true;
                    // Nếu nhận được tin từ bệnh nhân chưa chọn → tự động chọn họ
                    else if (!isFromMe && chatPartnerId === null && receiverId === CURRENT_USER_ID) {
                        if (onlinePatients.has(senderId)) {
                            const p = onlinePatients.get(senderId);
                            selectPatient(senderId, p.name);
                            belongsToThis = true;
                        }
                    }

                    if (belongsToThis) {
                        if (chatEmptyState) chatEmptyState.style.display = 'none';
                        if (isFromMe && type === 'chat') {
                            // Already shown optimistically
                        } else if (isFromMe && type === 'history') {
                            addChatBubble(content, 'me', senderName);
                        } else {
                            addChatBubble(content, 'other', senderName);
                        }
                    } else if (!isFromMe && type === 'chat' && receiverId === CURRENT_USER_ID) {
                        // Tin từ bệnh nhân khác (không đang chọn) → badge
                        bumpUnreadBadge(senderId);
                    }
                }
            };

            ws.onclose = function () {
                setStatus('offline', 'Mất kết nối');
                addSystemMsg("Mất kết nối. Đang kết nối lại...");
                setTimeout(connectWebSocket, 3000);
            };

            ws.onerror = function (err) {
                console.error("WS Error:", err);
                setStatus('offline', 'Lỗi kết nối');
            };
        }

        window.onload = connectWebSocket;

        // --- UI Helpers ---
        function setStatus(type, text) {
            connectionStatus.className = 'connection-status status-' + type;
            connectionStatus.innerHTML = `<i class="fas fa-circle" style="font-size:8px"></i> ${text}`;
        }

        function addSystemMsg(text) {
            const div = document.createElement("div");
            div.className = "system-message";
            div.innerHTML = `<span>${text}</span>`;
            chatBox.appendChild(div);
            chatBox.scrollTop = chatBox.scrollHeight;
        }

        function addChatBubble(text, type, senderName) {
            const wrap = document.createElement("div");
            wrap.className = "message-wrapper " + type;
            const bubble = document.createElement("div");
            bubble.className = "message-bubble";
            bubble.innerText = text;
            wrap.appendChild(bubble);
            chatBox.appendChild(wrap);
            chatBox.scrollTop = chatBox.scrollHeight;
        }

        function bumpUnreadBadge(patientId) {
            const item = document.querySelector(`[data-patient-id="${patientId}"]`);
            if (!item) return;
            let badge = item.querySelector('.patient-unread-badge');
            if (!badge) {
                badge = document.createElement('div');
                badge.className = 'patient-unread-badge ms-auto';
                badge.textContent = '1';
                item.appendChild(badge);
            } else {
                badge.textContent = parseInt(badge.textContent || '0') + 1;
            }
        }

        // --- Patient List ---
        function handlePatientList(data) {
            const listDiv = document.getElementById('patientList');
            if (!listDiv) return;
            onlinePatients.clear();
            listDiv.innerHTML = '';

            let hasAny = false;
            if (data && data.trim()) {
                data.split(';').forEach(entry => {
                    const parts = entry.split(':');
                    if (parts.length >= 2) {
                        hasAny = true;
                        const id = parseInt(parts[0]);
                        const name = parts[1];
                        const role = parts[2] || 'PATIENT';
                        onlinePatients.set(id, { name, role });

                        const item = document.createElement('div');
                        item.className = 'patient-item';
                        item.dataset.patientId = id;

                        const initial = name ? name.charAt(0).toUpperCase() : 'B';
                        item.innerHTML = `
                            <div class="patient-avatar-wrapper">
                                <div class="patient-avatar">${initial}</div>
                                <div class="status-dot"></div>
                            </div>
                            <div class="flex-grow-1 overflow-hidden">
                                <h6 class="mb-0 text-truncate text-dark fw-semibold" style="font-size:14px">${name}</h6>
                                <small class="text-muted text-truncate d-block">Bệnh nhân · Đang online</small>
                            </div>
                        `;

                        item.onclick = () => selectPatient(id, name);
                        listDiv.appendChild(item);
                    }
                });
            }

            if (!hasAny) {
                listDiv.innerHTML = `
                    <div class="text-center mt-5 text-muted px-3">
                        <i class="fas fa-user-clock fs-1 mb-3 d-block" style="color:#e2e8f0"></i>
                        <p class="small">Chưa có bệnh nhân nào đang online. Họ sẽ xuất hiện ở đây khi kết nối.</p>
                    </div>
                `;
                btnSend.disabled = true;
                inputMsg.disabled = true;
            }

            // Keep active highlight
            if (chatPartnerId !== null) {
                const sel = document.querySelector(`[data-patient-id="${chatPartnerId}"]`);
                if (sel) sel.classList.add('active');
            }
        }

        function selectPatient(id, name) {
            chatPartnerId = id;
            chatPartnerName = name;

            document.getElementById('chatPartnerName').textContent = name;
            document.getElementById('chatPartnerSub').textContent = 'Bệnh nhân · Đang online';
            document.getElementById('partnerAvatarDiv').classList.remove('d-none');
            document.getElementById('partnerAvatarLetter').textContent = name.charAt(0).toUpperCase();
            document.getElementById('chatHeaderActions').classList.remove('d-none');

            // Remove unread badge
            const item = document.querySelector(`[data-patient-id="${id}"]`);
            if (item) {
                item.querySelectorAll('.patient-unread-badge').forEach(b => b.remove());
            }

            // Mark active
            document.querySelectorAll('.patient-item').forEach(i => i.classList.remove('active'));
            if (item) item.classList.add('active');

            btnSend.disabled = false;
            inputMsg.disabled = false;
            inputMsg.focus();

            // Clear and load history
            chatBox.innerHTML = '';
            addSystemMsg("Đang tải lịch sử cuộc trò chuyện...");

            if (ws && ws.readyState === WebSocket.OPEN) {
                ws.send("HISTORY_REQUEST|" + chatPartnerId);
            }
        }

        // --- Send Message ---
        function sendMessage() {
            const msg = inputMsg.value.trim();
            if (!msg) return;

            if (chatPartnerId === null) {
                addSystemMsg("Vui lòng chọn bệnh nhân để nhắn tin.");
                return;
            }

            if (ws && ws.readyState === WebSocket.OPEN) {
                ws.send(chatPartnerId + "|" + msg);
                addChatBubble(msg, 'me', CURRENT_USERNAME);
                inputMsg.value = "";
                inputMsg.focus();
            } else {
                addSystemMsg("Không có kết nối. Vui lòng chờ kết nối lại.");
            }
        }
    </script>
</body>
</html>
