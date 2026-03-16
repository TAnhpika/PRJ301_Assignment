    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <!-- Font local DejaVu Sans - Inject contextPath động -->
            <%@ include file="/view/layout/font-loader.jsp" %>
                <style>
                    :root {
                        --bg-color: #f0f7ff;
                        --header-bg: #fff;
                        --text-color: #333;
                        --card-bg: #fff;
                        --shadow-color: rgba(0, 0, 0, 0.2);
                        --secondary-bg: #fafcfc;
                        --news-card-bg: #fff;
                        --testimonial-bg: #f0f3f5;
                        --footer-bg: linear-gradient(135deg, #3c5bba, #183ba1, #4664bd);
                        --copyright-bg: #18376b;
                        --btn-bg: #0432b5;
                        --btn-hover-bg: #527aeb;
                        --link-color: #3b82f6;
                        --highlight-text: #3b82f6;
                    }

                    [data-theme="dark"] {
                        --bg-color: #1a1a1a;
                        --header-bg: #2c2c2c;
                        --text-color: #e0e0e0;
                        --card-bg: #333;
                        --shadow-color: rgba(255, 255, 255, 0.1);
                        --secondary-bg: #2c2c2c;
                        --news-card-bg: #333;
                        --testimonial-bg: #444;
                        --footer-bg: linear-gradient(135deg, #2a4066, #1c2526, #3a4a6b);
                        --copyright-bg: #1c2526;
                        --btn-bg: #2563eb;
                        --btn-hover-bg: #3b82f6;
                        --link-color: #60a5fa;
                        --highlight-text: #60a5fa;
                    }

                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                        font-family: 'DejaVu Sans', 'Segoe UI', Arial, sans-serif;
                    }

                    .header {
                        background: var(--header-bg);
                        padding: 15px 40px;
                        box-shadow: 0 2px 8px var(--shadow-color);
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        z-index: 1000;
                        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
                    }

                    [data-theme="dark"] .header {
                        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                    }

                    .header-top {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        max-width: 1400px;
                        margin: 0 auto;
                    }

                    .logo {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .logo img {
                        width: 45px;
                        height: 45px;
                        object-fit: contain;
                    }

                    .logo h1 {
                        font-size: 22px;
                        font-weight: 700;
                        color: var(--highlight-text);
                        text-transform: uppercase;
                        line-height: 1;
                        margin: 0;
                    }

                    .logo span {
                        font-weight: 400;
                        font-size: 22px;
                        color: var(--link-color);
                    }

                    .header-center {
                        flex: 1;
                        display: flex;
                        justify-content: center;
                        padding: 0 30px;
                    }

                    .nav ul {
                        display: flex;
                        list-style: none;
                        gap: 3px;
                        margin: 0;
                        padding: 0;
                    }

                    .nav ul li {
                        position: relative;
                    }

                    .nav ul li a {
                        text-decoration: none;
                        color: var(--text-color);
                        font-weight: 500;
                        font-size: 14px;
                        padding: 8px 16px;
                        border-radius: 6px;
                        transition: all 0.2s ease;
                        display: block;
                    }

                    .nav ul li a:hover {
                        color: var(--link-color);
                        background: rgba(59, 130, 246, 0.1);
                    }

                    [data-theme="dark"] .nav ul li a:hover {
                        background: rgba(96, 165, 250, 0.15);
                    }

                    .nav ul li a.active {
                        color: var(--link-color);
                        background: rgba(59, 130, 246, 0.15);
                        font-weight: 600;
                    }

                    [data-theme="dark"] .nav ul li a.active {
                        background: rgba(96, 165, 250, 0.2);
                    }

                    .header-right {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .auth-buttons {
                        display: flex;
                        gap: 10px;
                        align-items: center;
                    }

                    .auth-btn {
                        padding: 8px 20px;
                        text-decoration: none;
                        font-size: 14px;
                        font-weight: 500;
                        border-radius: 6px;
                        transition: all 0.2s ease;
                        white-space: nowrap;
                    }

                    .auth-btn.login {
                        background: transparent;
                        color: var(--link-color);
                        border: 1.5px solid var(--link-color);
                    }

                    .auth-btn.login:hover {
                        background: rgba(59, 130, 246, 0.1);
                    }

                    [data-theme="dark"] .auth-btn.login:hover {
                        background: rgba(96, 165, 250, 0.15);
                    }

                    .auth-btn.register {
                        background: var(--btn-bg);
                        color: #ffffff;
                        border: 1.5px solid var(--btn-bg);
                    }

                    .auth-btn.register:hover {
                        background: var(--btn-hover-bg);
                        border-color: var(--btn-hover-bg);
                    }

                    .controls {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        padding-left: 12px;
                        border-left: 1px solid rgba(0, 0, 0, 0.1);
                    }

                    [data-theme="dark"] .controls {
                        border-left: 1px solid rgba(255, 255, 255, 0.1);
                    }

                    .theme-toggle {
                        background: var(--secondary-bg);
                        border: none;
                        width: 34px;
                        height: 34px;
                        border-radius: 6px;
                        font-size: 16px;
                        cursor: pointer;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        transition: all 0.2s ease;
                    }

                    .theme-toggle:hover {
                        background: var(--testimonial-bg);
                    }

                    .language-selector select {
                        padding: 8px 10px;
                        border-radius: 6px;
                        border: 1.5px solid var(--shadow-color);
                        background: var(--header-bg);
                        color: var(--text-color);
                        font-size: 13px;
                        font-weight: 500;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        outline: none;
                    }

                    .language-selector select:hover {
                        border-color: var(--link-color);
                    }

                    .language-selector select:focus {
                        border-color: var(--link-color);
                        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
                    }

                    [data-theme="dark"] .language-selector select:focus {
                        box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.15);
                    }

                    @media screen and (max-width: 768px) {
                        .header {
                            padding: 15px 20px;
                        }

                        .header-top {
                            flex-wrap: wrap;
                            gap: 12px;
                        }

                        .logo img {
                            width: 45px;
                            height: 45px;
                        }

                        .logo h1 {
                            font-size: 22px;
                        }

                        .logo span {
                            font-size: 22px;
                        }

                        .header-center {
                            order: 3;
                            width: 100%;
                            padding: 0;
                            margin-top: 8px;
                        }

                        .nav ul {
                            justify-content: center;
                            gap: 4px;
                            flex-wrap: wrap;
                        }

                        .nav ul li a {
                            font-size: 13px;
                            padding: 8px 14px;
                        }

                        .header-right {
                            gap: 10px;
                        }

                        .auth-buttons {
                            gap: 8px;
                        }

                        .auth-btn {
                            padding: 8px 16px;
                            font-size: 13px;
                        }

                        .controls {
                            gap: 8px;
                            padding-left: 10px;
                        }

                        .theme-toggle {
                            width: 34px;
                            height: 34px;
                            font-size: 16px;
                        }

                        .language-selector select {
                            padding: 8px 10px;
                            font-size: 12px;
                        }
                    }

                    @media screen and (min-width: 769px) and (max-width: 1024px) {
                        .header {
                            padding: 18px 35px;
                        }

                        .logo img {
                            width: 50px;
                            height: 50px;
                        }

                        .logo h1 {
                            font-size: 24px;
                        }

                        .logo span {
                            font-size: 24px;
                        }

                        .header-center {
                            padding: 0 25px;
                        }

                        .nav ul {
                            gap: 4px;
                        }

                        .nav ul li a {
                            font-size: 14px;
                            padding: 9px 16px;
                        }

                        .auth-btn {
                            padding: 9px 20px;
                            font-size: 14px;
                        }
                    }
                </style>
        </head>

        <body>
            <header class="header">
                <div class="header-top">
                    <div class="logo">
                        <img src="${pageContext.request.contextPath}/view/assets/img/logo.png" alt="HAPPY Smile Logo">
                        <h1>HAPPY <span>Smile</span></h1>
                    </div>

                    <div class="header-center">
                        <nav class="nav">
                            <ul>
                                <li><a href="#hero" class="active" data-lang="overview">Tổng quan</a></li>
                                <li><a href="#services" data-lang="services">Dịch vụ</a></li>
                                <li><a href="#team" data-lang="team">Đội ngũ bác sĩ</a></li>
                                <li><a href="#news" data-lang="news">Tin tức</a></li>
                                <li><a href="#contact" data-lang="contact">Liên hệ</a></li>
                            </ul>
                        </nav>
                    </div>

                    <div class="header-right">
                        <div class="auth-buttons">
                            <!-- Điều hướng về cấu trúc JSP giống project mẫu: /jsp/auth/... -->
                            <a href="${pageContext.request.contextPath}/jsp/auth/login.jsp"
                               class="auth-btn login"
                               data-lang="login">Đăng nhập</a>
                            <a href="${pageContext.request.contextPath}/jsp/auth/register.jsp"
                               class="auth-btn register"
                               data-lang="register">Đăng ký</a>
                        </div>
                        <div class="controls">
                            <button class="theme-toggle" id="theme-toggle">🌙</button>
                            <div class="language-selector">
                                <select id="language-switcher">
                                    <option value="vi">Tiếng Việt</option>
                                    <option value="en">English</option>
                                    <option value="ja">日本語</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
        </body>

        </html>