<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Tư vấn Bệnh nhân - Staff</title>
    <style>
        .chat-container {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 20px;
            height: calc(100vh - 200px);
            min-height: 500px;
        }
        .patient-list {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            overflow-y: auto;
        }
        .patient-item {
            padding: 15px 20px;
            border-bottom: 1px solid #e5e7eb;
            cursor: pointer;
            transition: all 0.3s;
        }
        .patient-item:hover {
            background: #f8f9fa;
        }
        .patient-item.active {
            background: #e3f2fd;
            border-left: 3px solid #4361ee;
        }
        .patient-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }
        .chat-box {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            display: flex;
            flex-direction: column;
        }
        .chat-header {
            padding: 15px 20px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
        }
        .chat-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background: #f8f9fa;
        }
        .message {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }
        .message.received { align-items: flex-start; }
        .message.sent { align-items: flex-end; }
        .message-content {
            max-width: 70%;
            padding: 12px 16px;
            border-radius: 16px;
            font-size: 14px;
        }
        .message.received .message-content {
            background: white;
            color: #1e293b;
            border-bottom-left-radius: 4px;
        }
        .message.sent .message-content {
            background: #4361ee;
            color: white;
            border-bottom-right-radius: 4px;
        }
        .message-time {
            font-size: 11px;
            color: #94a3b8;
            margin-top: 4px;
        }
        .chat-input {
            padding: 15px 20px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            gap: 12px;
        }
        .chat-input input {
            flex: 1;
            padding: 12px 16px;
            border: 1px solid #e5e7eb;
            border-radius: 24px;
            font-size: 14px;
        }
        .chat-input input:focus {
            outline: none;
            border-color: #4361ee;
        }
        .chat-input button {
            background: #4361ee;
            color: white;
            border: none;
            border-radius: 24px;
            padding: 12px 24px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .chat-input button:hover {
            background: #3b50d4;
        }
        .online-badge {
            width: 10px;
            height: 10px;
            background: #10b981;
            border-radius: 50%;
            display: inline-block;
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
                        <h4 class="mb-1"><i class="fas fa-comments me-2"></i>Tư vấn Bệnh nhân</h4>
                        <p class="text-muted mb-0">Trả lời câu hỏi và tư vấn cho bệnh nhân</p>
                    </div>
                </div>
                
                <!-- Chat Container -->
                <div class="chat-container">
                    <!-- Patient List -->
                    <div class="patient-list">
                        <div class="p-3 border-bottom">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" class="form-control border-start-0" placeholder="Tìm bệnh nhân...">
                            </div>
                        </div>
                        
                        <div class="patient-item active">
                            <div class="d-flex align-items-center">
                                <img src="${pageContext.request.contextPath}/view/assets/img/default-avatar.png" class="patient-avatar me-3" alt="Avatar">
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <strong>Trần Thị B</strong>
                                        <small class="text-muted">10p</small>
                                    </div>
                                    <small class="text-muted">Tôi muốn hỏi về dịch vụ...</small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="patient-item">
                            <div class="d-flex align-items-center">
                                <img src="${pageContext.request.contextPath}/view/assets/img/default-avatar.png" class="patient-avatar me-3" alt="Avatar">
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <strong>Lê Văn C</strong>
                                        <small class="text-muted">30p</small>
                                    </div>
                                    <small class="text-muted">Cảm ơn bạn đã tư vấn</small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="patient-item">
                            <div class="d-flex align-items-center">
                                <img src="${pageContext.request.contextPath}/view/assets/img/default-avatar.png" class="patient-avatar me-3" alt="Avatar">
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <strong>Phạm Thị D</strong>
                                        <small class="text-muted">1h</small>
                                    </div>
                                    <small class="text-muted">Cho tôi hỏi về giá...</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Chat Box -->
                    <div class="chat-box">
                        <div class="chat-header">
                            <img src="${pageContext.request.contextPath}/view/assets/img/default-avatar.png" class="patient-avatar me-3" alt="Avatar">
                            <div>
                                <strong>Trần Thị B</strong><br>
                                <small class="text-muted"><span class="online-badge me-1"></span>Đang online</small>
                            </div>
                        </div>
                        
                        <div class="chat-messages">
                            <div class="message received">
                                <div class="message-content">
                                    Xin chào, tôi muốn tư vấn về dịch vụ niềng răng ạ
                                </div>
                                <div class="message-time">10:00</div>
                            </div>
                            
                            <div class="message sent">
                                <div class="message-content">
                                    Xin chào bạn! Tôi có thể giúp gì cho bạn về dịch vụ niềng răng?
                                </div>
                                <div class="message-time">10:01</div>
                            </div>
                            
                            <div class="message received">
                                <div class="message-content">
                                    Tôi muốn biết thông tin về quy trình niềng răng và chi phí cụ thể ạ
                                </div>
                                <div class="message-time">10:02</div>
                            </div>
                            
                            <div class="message sent">
                                <div class="message-content">
                                    Quy trình niềng răng gồm các bước sau:<br>
                                    1. Khám và tư vấn<br>
                                    2. Chụp X-quang, lấy mẫu răng<br>
                                    3. Lập kế hoạch điều trị<br>
                                    4. Gắn mắc cài/niềng trong<br>
                                    5. Tái khám định kỳ
                                </div>
                                <div class="message-time">10:05</div>
                            </div>
                        </div>
                        
                        <div class="chat-input">
                            <input type="text" placeholder="Nhập tin nhắn..." id="messageInput">
                            <button onclick="sendMessage()"><i class="fas fa-paper-plane me-1"></i>Gửi</button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
    <script>
        // Handle patient selection
        document.querySelectorAll('.patient-item').forEach(item => {
            item.addEventListener('click', function() {
                document.querySelectorAll('.patient-item').forEach(i => i.classList.remove('active'));
                this.classList.add('active');
            });
        });
        
        // Send message
        function sendMessage() {
            const input = document.getElementById('messageInput');
            const message = input.value.trim();
            if (message) {
                const messagesContainer = document.querySelector('.chat-messages');
                const now = new Date();
                const time = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
                
                messagesContainer.innerHTML += 
                    '<div class="message sent">' +
                        '<div class="message-content">' + message + '</div>' +
                        '<div class="message-time">' + time + '</div>' +
                    '</div>';
                
                input.value = '';
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }
        }
        
        // Send message on Enter key
        document.getElementById('messageInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
    </script>
</body>
</html>
