<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User authUser = (User) session.getAttribute("user");
    if (authUser == null || !"PATIENT".equalsIgnoreCase(authUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
        return;
    }
    int currentUserId = authUser.getId();
    String currentUsername = authUser.getUsername() != null ? authUser.getUsername() : authUser.getEmail();
    String currentRole = authUser.getRole();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/view/layout/dashboard_head.jsp" %>
    <title>Tư vấn trực tuyến - Happy Smile</title>
    <style>
        .chat-layout {
            display: flex; gap: 20px; height: calc(100vh - 170px); min-height: 500px;
        }
        /* DOCTORS PANEL */
        .doctors-panel {
            width: 290px; flex-shrink: 0;
            background: white; border-radius: 16px;
            border: 1.5px solid #e8eef5;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            display: flex; flex-direction: column; overflow: hidden;
        }
        .panel-hdr {
            padding: 16px 20px; border-bottom: 1.5px solid #f1f5f9;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        }
        .panel-hdr h6 { color: white; font-size: 14px; font-weight: 700; margin: 0; }
        .panel-hdr small { color: rgba(255,255,255,0.8); font-size: 12px; }
        .doctors-list { flex: 1; overflow-y: auto; padding: 8px; }
        .doctors-list::-webkit-scrollbar { width: 5px; }
        .doctors-list::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius:10px; }

        .doc-item {
            display: flex; align-items: center; gap: 12px;
            padding: 12px 14px; border-radius: 12px; cursor: pointer;
            transition: all 0.2s; border: 1.5px solid transparent; margin-bottom: 4px;
        }
        .doc-item:hover { background: #f8fafc; border-color: #e8eef5; }
        .doc-item.active { background: #eff6ff; border-color: #bfdbfe; }
        .doc-avatar { width: 46px; height: 46px; border-radius: 50%; object-fit: cover; border: 2px solid #e2e8f0; flex-shrink: 0; }
        .doc-item.active .doc-avatar { border-color: #3b82f6; }
        .doc-info { flex: 1; min-width: 0; }
        .doc-name { font-size: 13.5px; font-weight: 700; color: #1e293b; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .doc-item.active .doc-name { color: #1d4ed8; }
        .doc-spec { font-size: 11.5px; color: #64748b; }
        .online-dot { width: 9px; height: 9px; background: #22c55e; border-radius: 50%; flex-shrink: 0; box-shadow: 0 0 0 2px white, 0 0 0 3px #22c55e40; }
        .no-doc { padding: 40px 16px; text-align: center; color: #94a3b8; }
        .no-doc i { font-size: 40px; color: #e2e8f0; display: block; margin-bottom: 12px; }

        /* CHAT WINDOW */
        .chat-window {
            flex: 1; min-width: 0;
            background: white; border-radius: 16px;
            border: 1.5px solid #e8eef5;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            display: flex; flex-direction: column; overflow: hidden;
        }
        .chat-hdr {
            padding: 14px 20px; border-bottom: 1.5px solid #f1f5f9;
            display: flex; align-items: center; justify-content: space-between;
        }
        .chat-hdr-info { display: flex; align-items: center; gap: 12px; }
        .chat-hdr-info img { width: 42px; height: 42px; border-radius: 50%; border: 2px solid #dbeafe; }
        .chat-hdr-name { font-size: 15px; font-weight: 700; color: #1e293b; }
        .chat-hdr-sub { font-size: 12px; color: #64748b; }

        .conn-pill {
            padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
            display: flex; align-items: center; gap: 5px;
        }
        .conn-pill.ok   { background: #ecfdf5; color: #0f766e; }
        .conn-pill.wait { background: #fef9c3; color: #854d0e; }
        .conn-pill.off  { background: #fef2f2; color: #991b1b; }

        .chat-body {
            flex: 1; overflow-y: auto; padding: 20px;
            background: #f8fbfd; display: flex; flex-direction: column; gap: 12px;
        }
        .chat-body::-webkit-scrollbar { width: 5px; }
        .chat-body::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }

        .empty-c { display:flex; flex-direction:column; align-items:center; justify-content:center; flex:1; color:#94a3b8; text-align:center; padding:40px; }
        .empty-c i { font-size:54px; color:#e2e8f0; margin-bottom:14px; }

        .msg-row { display:flex; align-items:flex-end; gap:8px; }
        .msg-row.me { flex-direction:row-reverse; }
        .msg-avatar-s { width:32px; height:32px; border-radius:50%; object-fit:cover; flex-shrink:0; }
        .bubble {
            width: fit-content; max-width: 100%;
            padding: 10px 16px; border-radius: 18px;
            font-size: 14px; line-height: 1.55; white-space: pre-wrap; word-break: break-word;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06);
        }
        .msg-row.me    .bubble { background:linear-gradient(135deg,#3b82f6,#1d4ed8); color:white; border-bottom-right-radius:4px; }
        .msg-row.other .bubble { background:white; color:#1e293b; border:1px solid #e8eef5; border-bottom-left-radius:4px; }
        .msg-col { display:flex; flex-direction:column; max-width: 75%; }
        .msg-row.me   .msg-col { align-items:flex-end; }
        .msg-row.other .msg-col { align-items:flex-start; }
        .msg-time { font-size:10.5px; color:#94a3b8; margin-top:3px; }

        .sys-msg { text-align:center; font-size:12px; color:#94a3b8; font-style:italic; display:flex; justify-content:center; }
        .sys-msg span { background:#f1f5f9; padding:3px 12px; border-radius:20px; }

        .chat-footer { padding:14px 20px; border-top:1.5px solid #f1f5f9; background:white; }
        .input-row {
            display:flex; align-items:center; gap:10px;
            background:#f8fafc; border:1.5px solid #e2e8f0;
            border-radius:30px; padding:6px 8px 6px 18px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .input-row:focus-within { border-color:#3b82f6; background:white; box-shadow:0 0 0 3px rgba(59,130,246,0.12); }
        .input-row input { flex:1; border:none; background:transparent; font-size:14px; color:#1e293b; outline:none; padding:4px 0; }
        .btn-send-p {
            width:40px; height:40px; border-radius:50%;
            background:linear-gradient(135deg,#3b82f6,#1d4ed8);
            border:none; color:white; display:flex; align-items:center; justify-content:center;
            cursor:pointer; flex-shrink:0; transition:all 0.25s; box-shadow:0 2px 8px rgba(59,130,246,0.3);
        }
        .btn-send-p:hover:not(:disabled) { box-shadow:0 4px 14px rgba(59,130,246,0.4); transform:scale(1.05); }
        .btn-send-p:disabled { background:#e2e8f0; box-shadow:none; cursor:not-allowed; }

        @media(max-width:768px) {
            .chat-layout { flex-direction:column; height:auto; }
            .doctors-panel { width:100%; height:200px; }
            .chat-window { height:500px; }
        }
    </style>
</head>
<body>
<div class="dashboard-wrapper">
    <%@ include file="/view/layout/components/sidebar_patient.jsp" %>
    <main class="dashboard-main">
        <%@ include file="/view/layout/components/header_patient.jsp" %>

        <div class="dashboard-content">
            <!-- Header -->
            <div class="d-flex align-items-center justify-content-between mb-3">
                <div>
                    <h4 style="font-size:20px;font-weight:700;color:#1e293b;margin:0">
                        <i class="fas fa-stethoscope me-2" style="color:#3b82f6"></i>Tư vấn trực tuyến
                    </h4>
                    <nav aria-label="breadcrumb" class="mt-1">
                        <ol class="breadcrumb mb-0" style="font-size:12.5px">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/UserHompageServlet" class="text-decoration-none">Trang chủ</a></li>
                            <li class="breadcrumb-item active">Tư vấn bác sĩ</li>
                        </ol>
                    </nav>
                </div>
                <span id="connPill" class="conn-pill wait"><i class="fas fa-circle fa-xs"></i> Đang kết nối...</span>
            </div>

            <div class="chat-layout">
                <!-- Doctors online list -->
                <div class="doctors-panel">
                    <div class="panel-hdr">
                        <h6><i class="fas fa-user-md me-2"></i>Bác sĩ Online</h6>
                        <small>Nhấn để bắt đầu tư vấn</small>
                    </div>
                    <div class="doctors-list" id="doctorList">
                        <div class="no-doc">
                            <i class="fas fa-circle-notch fa-spin" style="font-size:28px;color:#3b82f6"></i>
                            <p style="font-size:13px;margin-top:12px">Đang kết nối...</p>
                        </div>
                    </div>
                </div>

                <!-- Chat window -->
                <div class="chat-window">
                    <div class="chat-hdr">
                        <div class="chat-hdr-info" id="chatHdrInfo">
                            <i class="fas fa-comments" style="font-size:28px;color:#3b82f6"></i>
                            <div>
                                <div class="chat-hdr-name" id="cpName">Hộp thư tư vấn</div>
                                <div class="chat-hdr-sub" id="cpSub">Chọn bác sĩ từ danh sách bên trái</div>
                            </div>
                        </div>
                    </div>

                    <div class="chat-body" id="chatBox">
                        <div class="empty-c" id="emptyState">
                            <i class="far fa-comments"></i>
                            <h5 style="color:#64748b;font-size:16px;margin-bottom:6px">Bắt đầu trò chuyện</h5>
                            <p style="font-size:13px">Chọn bác sĩ và gửi câu hỏi của bạn</p>
                        </div>
                    </div>

                    <div class="chat-footer">
                        <div class="input-row">
                            <input type="text" id="inputMsg" placeholder="Nhập câu hỏi của bạn..."
                                   onkeydown="if(event.key==='Enter'&&!event.shiftKey){event.preventDefault();sendMessage();}"
                                   disabled autocomplete="off">
                            <button class="btn-send-p" id="sendBtn" onclick="sendMessage()" disabled>
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
    const CTX     = "${pageContext.request.contextPath}";
    const ME_ID   = <%= currentUserId %>;
    const ME_NAME = "<%= currentUsername.replace("\"","\\\"") %>";
    const ME_ROLE = "<%= currentRole %>";

    let ws = null;
    let chatPartnerId   = null;
    let chatPartnerName = "";
    const onlineDoctors = new Map();
    const unreadMap     = new Map();

    const chatBox    = document.getElementById('chatBox');
    const inputMsg   = document.getElementById('inputMsg');
    const sendBtn    = document.getElementById('sendBtn');
    const emptyState = document.getElementById('emptyState');
    const doctorListEl   = document.getElementById('doctorList');
    const connPill   = document.getElementById('connPill');

    function connect() {
        setPill('wait');
        ws = new WebSocket("ws://" + window.location.host + CTX + "/chat");
        ws.onopen  = () => { setPill('ok'); addSys("Đã kết nối thành công!"); };
        ws.onmessage = ev => handleMsg(ev.data);
        ws.onclose = () => {
            setPill('off');
            addSys("Mất kết nối. Đang thử kết nối lại...");
            setTimeout(connect, 3000);
        };
        ws.onerror = e => console.error(e);
    }

    function handleMsg(raw) {
        if (raw.startsWith('doctorlist|')) {
            updateDoctorList(raw.substring('doctorlist|'.length));
            return;
        }
        if (raw.startsWith('patientlist|')) return; // ignore for patient

        const p = raw.split('|', 6);
        if (p.length < 6) return;
        const [type, sidStr, sName, sRole, ridStr, content] = p;
        const sid = parseInt(sidStr);
        const rid = (ridStr === 'null' || ridStr === '') ? null : parseInt(ridStr);

        if (type === 'system') { addSys(content); return; }

        if (type === 'chat' || type === 'history') {
            const isMe = sid === ME_ID;
            if (isMe) {
                if (type === 'history' && rid === chatPartnerId) addBubble(content,'me', ME_NAME);
            } else {
                if (sid === chatPartnerId) {
                    addBubble(content, 'other', sName);
                } else if (rid === ME_ID || rid === null) {
                    // Bác sĩ khác gửi → badge + auto select nếu chưa chọn ai
                    if (chatPartnerId === null && onlineDoctors.has(sid)) {
                        const d = onlineDoctors.get(sid);
                        selectDoctor(sid, d.name);
                        addBubble(content, 'other', sName);
                    } else {
                        unreadMap.set(sid, (unreadMap.get(sid) || 0) + 1);
                        renderDoctorList();
                    }
                }
            }
        }
    }

    function updateDoctorList(data) {
        onlineDoctors.clear();
        if (data && data.trim()) {
            data.split(';').forEach(s => {
                const p = s.split(':');
                if (p.length === 3) onlineDoctors.set(parseInt(p[0]), {name: p[1], role: p[2]});
            });
        }
        renderDoctorList();
        // Auto-select nếu list mới có bác sĩ cũ đang chat
        if (chatPartnerId !== null && !onlineDoctors.has(chatPartnerId)) {
            chatPartnerId = null;
            document.getElementById('cpName').textContent = 'Hộp thư tư vấn';
            document.getElementById('cpSub').textContent  = 'Bác sĩ đã offline';
            inputMsg.disabled = true;
            sendBtn.disabled  = true;
        }
    }

    function renderDoctorList() {
        doctorListEl.innerHTML = '';
        if (onlineDoctors.size === 0) {
            doctorListEl.innerHTML = `<div class="no-doc"><i class="fas fa-user-md"></i><p style="font-size:13px;margin-top:8px">Hiện chưa có bác sĩ online</p></div>`;
            return;
        }
        onlineDoctors.forEach((info, id) => {
            const d = document.createElement('div');
            d.className = 'doc-item' + (id === chatPartnerId ? ' active' : '');
            d.dataset.userId = id;
            const badge = unreadMap.get(id) || 0;
            d.innerHTML =
                '<img src="' + CTX + '/view/assets/img/default-avatar.png" class="doc-avatar" alt="avatar">' +
                '<div class="doc-info">' +
                    '<div class="doc-name">BS. ' + esc(info.name) + '</div>' +
                    '<div class="doc-spec"><i class="fas fa-stethoscope me-1"></i>Bác sĩ</div>' +
                '</div>' +
                '<div class="online-dot"></div>' +
                (badge > 0 ? '<span style="background:#ef4444;color:white;font-size:10px;font-weight:700;padding:1px 6px;border-radius:20px">' + badge + '</span>' : '');
            d.onclick = () => selectDoctor(id, info.name);
            doctorListEl.appendChild(d);
        });
    }

    function selectDoctor(id, name) {
        chatPartnerId   = id;
        chatPartnerName = name;
        unreadMap.delete(id);
        renderDoctorList();

        document.getElementById('cpName').textContent = 'BS. ' + name;
        document.getElementById('cpSub').innerHTML = '<span style="color:#22c55e">● Online</span>';

        chatBox.innerHTML = '';
        if (emptyState) emptyState.style.display = 'none';
        inputMsg.disabled = false;
        sendBtn.disabled  = false;
        inputMsg.focus();

        addSys('Đang tải lịch sử trò chuyện với BS. ' + name + '...');
        if (ws && ws.readyState === WebSocket.OPEN) ws.send("HISTORY_REQUEST|" + id);
    }

    function sendMessage() {
        const msg = inputMsg.value.trim();
        if (!msg || chatPartnerId === null) return;
        if (!ws || ws.readyState !== WebSocket.OPEN) { addSys("Chưa kết nối!"); return; }
        addBubble(msg, 'me', ME_NAME);
        ws.send(chatPartnerId + "|" + msg);
        inputMsg.value = "";
        inputMsg.focus();
    }

    function addBubble(text, side, name) {
        if (emptyState) emptyState.style.display = 'none';
        const now = new Date().toLocaleTimeString('vi-VN',{hour:'2-digit',minute:'2-digit'});
        const row = document.createElement('div');
        row.className = 'msg-row ' + side;
        if (side === 'other') {
            row.innerHTML = '<div class="msg-col"><div class="bubble">' + esc(text) + '</div><div class="msg-time">' + esc(name) + ' · ' + now + '</div></div>';
        } else {
            row.innerHTML = '<div class="msg-col"><div class="bubble">' + esc(text) + '</div><div class="msg-time">' + now + '</div></div>';
        }
        chatBox.appendChild(row);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function addSys(text) {
        const d = document.createElement('div');
        d.className = 'sys-msg';
        d.innerHTML = '<span>' + esc(text) + '</span>';
        chatBox.appendChild(d);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function setPill(state) {
        connPill.className = 'conn-pill ' + state;
        connPill.innerHTML = {ok:'● Đã kết nối', wait:'◌ Đang kết nối...', off:'✕ Mất kết nối'}[state] || state;
    }

    function esc(s) {
        return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    window.addEventListener('load', connect);
</script>
</body>
</html>
