<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.User, model.Doctors"%>
<%
    User authUser = (User) session.getAttribute("user");
    if (authUser == null || !"DOCTOR".equalsIgnoreCase(authUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
        return;
    }
    int currentUserId = authUser.getId();
    String currentUsername = authUser.getUsername() != null ? authUser.getUsername() : authUser.getEmail();
    String currentRole = authUser.getRole();

    Doctors doctorObj = (Doctors) session.getAttribute("doctor");
    String doctorDisplay = doctorObj != null ? doctorObj.getFullName() : currentUsername;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Tư vấn Chat - Happy Smile</title>
    <style>
        /* ===== CHAT LAYOUT ===== */
        .chat-page-wrapper {
            display: flex; flex-direction: column; height: calc(100vh - 120px);
        }
        .chat-layout {
            display: flex; gap: 20px; flex: 1; min-height: 0;
        }

        /* ===== SIDEBAR PATIENTS ===== */
        .patients-panel {
            width: 300px; flex-shrink: 0;
            background: white; border-radius: 16px;
            border: 1.5px solid #e8eef5;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            display: flex; flex-direction: column; overflow: hidden;
        }
        .panel-header {
            padding: 16px 20px; border-bottom: 1.5px solid #f1f5f9;
            background: linear-gradient(135deg, #0d9488, #0f766e);
        }
        .panel-header h6 { color: white; font-size: 14px; font-weight: 700; margin: 0; }
        .panel-header small { color: rgba(255,255,255,0.8); font-size: 12px; }
        .panel-search {
            padding: 12px 14px; border-bottom: 1px solid #f1f5f9; position: relative;
        }
        .panel-search input {
            width: 100%; padding: 8px 12px 8px 36px;
            border: 1.5px solid #e2e8f0; border-radius: 10px;
            font-size: 13px; color: #334155; box-sizing: border-box;
            background: #f8fafc;
        }
        .panel-search input:focus { outline: none; border-color: #0d9488; background: white; }
        .panel-search i { position: absolute; left: 26px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 13px; }
        .patients-list { flex: 1; overflow-y: auto; padding: 8px; }

        .patient-item {
            display: flex; align-items: center; gap: 12px;
            padding: 12px 14px; border-radius: 12px;
            cursor: pointer; transition: all 0.2s;
            border: 1.5px solid transparent; margin-bottom: 4px;
        }
        .patient-item:hover { background: #f8fafc; border-color: #e8eef5; }
        .patient-item.active { background: #f0fdf4; border-color: #a7f3d0; }
        .patient-item.active .pi-name { color: #0f766e; }
        .patient-avatar {
            width: 46px; height: 46px; border-radius: 50%;
            object-fit: cover; border: 2px solid #e2e8f0; flex-shrink: 0;
        }
        .patient-item.active .patient-avatar { border-color: #0d9488; }
        .pi-info { flex: 1; min-width: 0; }
        .pi-name { font-size: 13.5px; font-weight: 700; color: #1e293b; margin-bottom: 2px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .pi-role { font-size: 11.5px; color: #64748b; }
        .online-dot {
            width: 9px; height: 9px; background: #22c55e;
            border-radius: 50%; flex-shrink: 0;
            box-shadow: 0 0 0 2px white, 0 0 0 3px #22c55e40;
        }
        .unread-badge {
            background: #ef4444; color: white; font-size: 10px;
            font-weight: 700; padding: 1px 6px; border-radius: 20px;
            min-width: 18px; text-align: center;
        }

        .no-patients {
            padding: 40px 20px; text-align: center; color: #94a3b8;
        }
        .no-patients i { font-size: 40px; color: #e2e8f0; display: block; margin-bottom: 12px; }

        /* ===== CHAT WINDOW ===== */
        .chat-window {
            flex: 1; min-width: 0;
            background: white; border-radius: 16px;
            border: 1.5px solid #e8eef5;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            display: flex; flex-direction: column; overflow: hidden;
        }
        .chat-header {
            padding: 14px 20px; border-bottom: 1.5px solid #f1f5f9;
            display: flex; align-items: center; justify-content: space-between;
            background: white;
        }
        .chat-partner-info { display: flex; align-items: center; gap: 12px; }
        .chat-partner-info img { width: 42px; height: 42px; border-radius: 50%; border: 2px solid #e2e8f0; }
        .cp-name { font-size: 15px; font-weight: 700; color: #1e293b; }
        .cp-status { font-size: 12px; color: #22c55e; display: flex; align-items: center; gap: 4px; }
        .cp-status::before { content: ''; width: 7px; height: 7px; background: #22c55e; border-radius: 50%; }

        .conn-badge {
            display: flex; align-items: center; gap: 6px;
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
        }
        .conn-badge.connected   { background: #ecfdf5; color: #0f766e; }
        .conn-badge.connecting  { background: #fef9c3; color: #854d0e; }
        .conn-badge.disconnected{ background: #fef2f2; color: #991b1b; }

        /* ===== MESSAGES ===== */
        .chat-body {
            flex: 1; overflow-y: auto; padding: 20px;
            background: #f8fbfd; display: flex; flex-direction: column; gap: 12px;
        }
        .chat-body::-webkit-scrollbar { width: 5px; }
        .chat-body::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }

        .empty-chat {
            display: flex; flex-direction: column; align-items: center;
            justify-content: center; flex: 1; color: #94a3b8; text-align: center;
            padding: 40px;
        }
        .empty-chat i { font-size: 56px; color: #e2e8f0; margin-bottom: 14px; }

        .msg-row { display: flex; align-items: flex-end; gap: 8px; }
        .msg-row.me { flex-direction: row-reverse; }
        .msg-avatar { width: 32px; height: 32px; border-radius: 50%; object-fit: cover; flex-shrink: 0; }
        .msg-bubble {
            width: fit-content; max-width: 100%;
            padding: 10px 16px;
            border-radius: 18px; font-size: 14px; line-height: 1.55;
            white-space: pre-wrap; word-break: break-word;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06);
        }
        .msg-row.me  .msg-bubble { background: linear-gradient(135deg, #0d9488, #0f766e); color: white; border-bottom-right-radius: 4px; }
        .msg-row.other .msg-bubble { background: white; color: #1e293b; border: 1px solid #e8eef5; border-bottom-left-radius: 4px; }
        .msg-time { font-size: 10.5px; color: #94a3b8; margin-top: 4px; }
        .msg-row.me   .msg-col { align-items: flex-end; }
        .msg-row.other .msg-col { align-items: flex-start; }
        .msg-col { display: flex; flex-direction: column; max-width: 75%; }

        .system-msg {
            text-align: center; font-size: 12px; color: #94a3b8;
            font-style: italic; display: flex; justify-content: center;
        }
        .system-msg span { background: #f1f5f9; padding: 3px 12px; border-radius: 20px; }

        /* ===== INPUT ===== */
        .chat-footer {
            padding: 14px 20px; border-top: 1.5px solid #f1f5f9; background: white;
        }
        .input-row {
            display: flex; align-items: center; gap: 10px;
            background: #f8fafc; border: 1.5px solid #e2e8f0;
            border-radius: 30px; padding: 6px 8px 6px 18px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .input-row:focus-within {
            border-color: #0d9488; background: white;
            box-shadow: 0 0 0 3px rgba(13,148,136,0.12);
        }
        .input-row input {
            flex: 1; border: none; background: transparent;
            font-size: 14px; color: #1e293b; outline: none; padding: 4px 0;
        }
        .btn-send {
            width: 40px; height: 40px; border-radius: 50%;
            background: linear-gradient(135deg, #0d9488, #0f766e);
            border: none; color: white; display: flex; align-items: center;
            justify-content: center; cursor: pointer; flex-shrink: 0;
            transition: all 0.25s; box-shadow: 0 2px 8px rgba(13,148,136,0.3);
        }
        .btn-send:hover:not(:disabled) { box-shadow: 0 4px 14px rgba(13,148,136,0.4); transform: scale(1.05); }
        .btn-send:disabled { background: #e2e8f0; box-shadow: none; cursor: not-allowed; }

        /* scrollbar patients */
        .patients-list::-webkit-scrollbar { width: 5px; }
        .patients-list::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
    </style>
</head>
<body>
<div class="dashboard-wrapper">
    <%@ include file="/view/jsp/doctor/doctor_menu.jsp" %>
    <main class="dashboard-main">
        <%@ include file="/view/jsp/doctor/doctor_header.jsp" %>

        <div class="dashboard-content" style="display:flex;flex-direction:column;height:calc(100vh - 60px);overflow:hidden">
            <!-- Page title -->
            <div class="d-flex align-items-center justify-content-between mb-3 flex-shrink-0">
                <div>
                    <h4 style="font-size:19px;font-weight:700;color:#1e293b;margin:0">
                        <i class="fas fa-comments me-2" style="color:#0d9488"></i>Tư vấn trực tuyến
                    </h4>
                    <p style="font-size:12.5px;color:#64748b;margin:2px 0 0">Chat riêng tư với bệnh nhân của bạn</p>
                </div>
                <span id="connBadge" class="conn-badge connecting">
                    <i class="fas fa-circle fa-xs"></i> Đang kết nối...
                </span>
            </div>

            <!-- Chat layout -->
            <div class="chat-layout">
                <!-- Patient list -->
                <div class="patients-panel">
                    <div class="panel-header">
                        <h6><i class="fas fa-users me-2"></i>Bệnh nhân online</h6>
                        <small>Nhấn vào để bắt đầu tư vấn</small>
                    </div>
                    <div class="panel-search">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchPatient" placeholder="Tìm bệnh nhân..." oninput="filterPatients(this.value)">
                    </div>
                    <div class="patients-list" id="patientList">
                        <div class="no-patients">
                            <i class="fas fa-circle-notch fa-spin" style="font-size:28px;color:#0d9488"></i>
                            <p style="font-size:13px;margin-top:12px">Đang kết nối...</p>
                        </div>
                    </div>
                </div>

                <!-- Chat window -->
                <div class="chat-window">
                    <div class="chat-header">
                        <div class="chat-partner-info" id="chatHeader">
                            <i class="fas fa-comment-medical" style="font-size:26px;color:#0d9488"></i>
                            <div>
                                <div class="cp-name" id="cpName">Chọn bệnh nhân</div>
                                <div style="font-size:12px;color:#64748b" id="cpSub">Nhấn vào bệnh nhân để bắt đầu trò chuyện</div>
                            </div>
                        </div>
                    </div>

                    <div class="chat-body" id="chatBox">
                        <div class="empty-chat" id="emptyState">
                            <i class="far fa-comment-dots"></i>
                            <h5 style="color:#64748b;font-size:16px;margin-bottom:6px">Chưa có cuộc trò chuyện nào</h5>
                            <p style="font-size:13px">Chọn bệnh nhân từ danh sách bên trái để bắt đầu</p>
                        </div>
                    </div>

                    <div class="chat-footer">
                        <div class="input-row">
                            <input type="text" id="inputMsg" placeholder="Nhập tin nhắn tư vấn..."
                                   onkeydown="if(event.key==='Enter'&&!event.shiftKey){event.preventDefault();sendMessage();}"
                                   disabled autocomplete="off">
                            <button class="btn-send" id="sendBtn" onclick="sendMessage()" disabled>
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
<script>
    // ===== CONFIG =====
    const CTX  = "${pageContext.request.contextPath}";
    const ME_ID   = <%= currentUserId %>;
    const ME_NAME = "<%= doctorDisplay %>";
    const ME_ROLE = "<%= currentRole %>";

    // ===== STATE =====
    let ws = null;
    let chatPartnerId   = null;
    let chatPartnerName = "";
    const onlinePatients = new Map(); // id → {name, role}
    const unreadCount    = new Map(); // id → count

    // ===== DOM =====
    const chatBox    = document.getElementById('chatBox');
    const inputMsg   = document.getElementById('inputMsg');
    const sendBtn    = document.getElementById('sendBtn');
    const emptyState = document.getElementById('emptyState');
    const patientListEl  = document.getElementById('patientList');
    const connBadge  = document.getElementById('connBadge');

    // ===== WEBSOCKET =====
    function connect() {
        setConnBadge('connecting');
        ws = new WebSocket("ws://" + window.location.host + CTX + "/chat");

        ws.onopen = () => {
            setConnBadge('connected');
            addSystemMsg("Đã kết nối thành công!");
        };

        ws.onmessage = (ev) => handleMessage(ev.data);

        ws.onclose = () => {
            setConnBadge('disconnected');
            addSystemMsg("Mất kết nối. Đang thử lại sau 3 giây...");
            setTimeout(connect, 3000);
        };

        ws.onerror = (e) => console.error('WS error', e);
    }

    function handleMessage(raw) {
        // patientlist update
        if (raw.startsWith('patientlist|')) {
            updatePatientList(raw.substring('patientlist|'.length));
            return;
        }
        // doctorlist → ignore for doctor role
        if (raw.startsWith('doctorlist|')) return;

        const parts = raw.split('|', 6);
        if (parts.length < 6) return;

        const [type, senderIdStr, senderName, senderRole, receiverIdStr, content] = parts;
        const senderId   = parseInt(senderIdStr);
        const receiverId = (receiverIdStr === 'null' || receiverIdStr === '') ? null : parseInt(receiverIdStr);

        if (type === 'system') { addSystemMsg(content); return; }

        if (type === 'chat' || type === 'history') {
            const isFromMe = (senderId === ME_ID);

            if (isFromMe) {
                // echo từ server (chỉ hiển thị history)
                if (type === 'history' && receiverId === chatPartnerId) {
                    appendBubble(content, 'me', ME_NAME, new Date());
                }
            } else {
                // Tin từ bệnh nhân
                if (senderId === chatPartnerId) {
                    // Đang chat với người này
                    appendBubble(content, 'other', senderName, new Date());
                } else if (receiverId === ME_ID) {
                    // Bệnh nhân khác gửi → badge
                    addUnread(senderId);
                    renderPatientList();
                }
            }
        }
    }

    // ===== PATIENT LIST =====
    function updatePatientList(data) {
        onlinePatients.clear();
        if (data && data.trim()) {
            data.split(';').forEach(part => {
                const p = part.split(':');
                if (p.length === 3) {
                    const id = parseInt(p[0]);
                    onlinePatients.set(id, { name: p[1], role: p[2] });
                }
            });
        }
        renderPatientList();
    }

    function renderPatientList() {
        const filter = (document.getElementById('searchPatient').value || '').toLowerCase();
        patientListEl.innerHTML = '';

        if (onlinePatients.size === 0) {
            patientListEl.innerHTML = `
                <div class="no-patients">
                    <i class="fas fa-user-slash"></i>
                    <p style="font-size:13px;margin-top:8px">Không có bệnh nhân online</p>
                </div>`;
            return;
        }

        onlinePatients.forEach((info, id) => {
            if (filter && !info.name.toLowerCase().includes(filter)) return;
            const div = document.createElement('div');
            div.className = 'patient-item' + (id === chatPartnerId ? ' active' : '');
            div.dataset.userId = id;
            const badgeCount = unreadCount.get(id) || 0;
            div.innerHTML =
                '<img src="' + CTX + '/view/assets/img/default-user-avatar.png" class="patient-avatar" alt="avatar">' +
                '<div class="pi-info">' +
                    '<div class="pi-name">' + escHtml(info.name) + '</div>' +
                    '<div class="pi-role"><i class="fas fa-user me-1"></i>Bệnh nhân</div>' +
                '</div>' +
                '<div class="online-dot"></div>' +
                (badgeCount > 0 ? '<span class="unread-badge">' + badgeCount + '</span>' : '');

            div.onclick = () => selectPatient(id, info.name);
            patientListEl.appendChild(div);
        });
    }

    function filterPatients(val) { renderPatientList(); }

    function addUnread(id) {
        unreadCount.set(id, (unreadCount.get(id) || 0) + 1);
    }

    function clearUnread(id) { unreadCount.delete(id); }

    // ===== SELECT PATIENT =====
    function selectPatient(id, name) {
        chatPartnerId   = id;
        chatPartnerName = name;

        clearUnread(id);
        renderPatientList();

        document.getElementById('cpName').textContent = name;
        document.getElementById('cpSub').innerHTML = '<span style="color:#22c55e">● Online</span> · Bệnh nhân';

        chatBox.innerHTML = '';
        emptyState.style.display = 'none';
        inputMsg.disabled = false;
        sendBtn.disabled = false;
        inputMsg.focus();

        addSystemMsg('Đang tải lịch sử trò chuyện với ' + name + '...');
        if (ws && ws.readyState === WebSocket.OPEN) {
            ws.send("HISTORY_REQUEST|" + id);
        }
    }

    // ===== SEND =====
    function sendMessage() {
        const msg = inputMsg.value.trim();
        if (!msg || chatPartnerId === null) return;
        if (!ws || ws.readyState !== WebSocket.OPEN) {
            addSystemMsg("Chưa kết nối! Vui lòng chờ...");
            return;
        }
        appendBubble(msg, 'me', ME_NAME, new Date()); // optimistic
        ws.send(chatPartnerId + "|" + msg);
        inputMsg.value = "";
        inputMsg.focus();
    }

    // ===== UI HELPERS =====
    function appendBubble(text, side, name, date) {
        if (emptyState) emptyState.style.display = 'none';
        const timeStr = date.toLocaleTimeString('vi-VN', {hour:'2-digit', minute:'2-digit'});
        const row = document.createElement('div');
        row.className = 'msg-row ' + side;
        if (side === 'other') {
            row.innerHTML =
                '<div class="msg-col">' +
                    '<div class="msg-bubble">' + escHtml(text) + '</div>' +
                    '<div class="msg-time">' + escHtml(name) + ' · ' + timeStr + '</div>' +
                '</div>';
        } else {
            row.innerHTML =
                '<div class="msg-col">' +
                    '<div class="msg-bubble">' + escHtml(text) + '</div>' +
                    '<div class="msg-time">' + timeStr + '</div>' +
                '</div>';
        }
        chatBox.appendChild(row);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function addSystemMsg(text) {
        const div = document.createElement('div');
        div.className = 'system-msg';
        div.innerHTML = '<span>' + escHtml(text) + '</span>';
        chatBox.appendChild(div);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function setConnBadge(state) {
        connBadge.className = 'conn-badge ' + state;
        const labels = { connected: '● Đã kết nối', connecting: '◌ Đang kết nối...', disconnected: '✕ Mất kết nối' };
        connBadge.innerHTML = labels[state] || state;
    }

    function escHtml(s) {
        return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    // ===== INIT =====
    window.addEventListener('load', connect);
</script>
</body>
</html>
