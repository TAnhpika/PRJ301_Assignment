<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>404 - Không Tìm Thấy Trang</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/dashboard-common.css">
        <style>
            .error-container {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                text-align: center;
                padding: 2rem;
            }

            .error-code {
                font-size: 8rem;
                font-weight: bold;
                color: #4A90E2;
                margin: 0;
            }

            .error-message {
                font-size: 1.5rem;
                color: #333;
                margin: 1rem 0;
            }

            .error-description {
                color: #666;
                margin-bottom: 2rem;
            }

            .btn-home {
                padding: 0.75rem 2rem;
                background: #4A90E2;
                color: white;
                text-decoration: none;
                border-radius: 8px;
                transition: background 0.3s;
            }

            .btn-home:hover {
                background: #357ABD;
            }
        </style>
    </head>

    <body>
        <div class="error-container">
            <h1 class="error-code">404</h1>
            <h2 class="error-message">Không Tìm Thấy Trang</h2>
            <p class="error-description">Trang bạn đang tìm kiếm không tồn tại hoặc đã bị di chuyển.</p>
            <a href="${pageContext.request.contextPath}/view/jsp/home.jsp" class="btn-home">Về Trang Chủ</a>
        </div>
    </body>

    </html>