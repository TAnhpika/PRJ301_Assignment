package Filter;

import model.User;
import java.io.IOException;
import java.util.*;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 🔐 AUTHENTICATION FILTER
 * Filter xác thực người dùng cho hệ thống phòng khám nha khoa
 * Chỉ kiểm tra đăng nhập, không kiểm tra quyền truy cập
 */
// @WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/*"})  // Tạm thời disable để test
public class AuthenticationFilter implements Filter {
    
    private static final boolean DEBUG = true;
    private FilterConfig filterConfig = null;
    
    // 🔓 DANH SÁCH TRANG KHÔNG CẦN ĐĂNG NHẬP
    private static final Set<String> NO_AUTH_REQUIRED = new HashSet<>(Arrays.asList(
        "/login.jsp",
        "/signup.jsp",
        "/home.jsp", 
        "/information.jsp",
        "/test-encoding.jsp",
        "/LoginServlet",
        "/SignUpServlet",
        "/RegisterServlet",
        "/GoogleCallbackServlet",
        "/LogoutServlet"
    ));
    
    // 🔓 DANH SÁCH PATTERN KHÔNG CẦN ĐĂNG NHẬP
    private static final Set<String> NO_AUTH_PATTERNS = new HashSet<>(Arrays.asList(
        "/images/",
        "/styles/",
        "/js/", 
        "/css/",
        "/META-INF/",
        "/WEB-INF/",
        "/includes/",
        "/common/",
        "/favicon.ico",
        ".css",
        ".js",
        ".png",
        ".jpg",
        ".jpeg",
        ".gif",
        ".ico"
    ));
    
    public AuthenticationFilter() {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());
        
        if (DEBUG) {
            System.out.println("🔐 AuthFilter: " + request.getMethod() + " " + path);
        }
        
        // ✅ 1. KIỂM TRA TRANG KHÔNG CẦN ĐĂNG NHẬP
        if (isNoAuthRequired(path)) {
            if (DEBUG) System.out.println("✅ No auth required: " + path);
            chain.doFilter(req, res);
            return;
        }
        
        // ✅ 2. KIỂM TRA SESSION VÀ USER
        HttpSession session = request.getSession(false);
        User user = null;
        
        if (session != null) {
            user = (User) session.getAttribute("user");
        }
        
        if (user == null) {
            if (DEBUG) System.out.println("❌ User not authenticated, redirect to login");
            
            // Lưu URL hiện tại để redirect sau khi login
            String originalUrl = request.getRequestURL().toString();
            if (request.getQueryString() != null) {
                originalUrl += "?" + request.getQueryString();
            }
            
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("originalUrl", originalUrl);
            
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        if (DEBUG) {
            System.out.println("✅ User authenticated: " + user.getUsername() + " (" + user.getRole() + ")");
        }
        
        // ✅ 3. USER ĐÃ ĐĂNG NHẬP - CHO PHÉP TIẾP TỤC
        chain.doFilter(req, res);
    }
    
    /**
     * 🔓 Kiểm tra trang có cần đăng nhập không
     */
    private boolean isNoAuthRequired(String path) {
        // Kiểm tra exact match
        if (NO_AUTH_REQUIRED.contains(path)) {
            return true;
        }
        
        // Kiểm tra pattern match
        for (String pattern : NO_AUTH_PATTERNS) {
            if (path.startsWith(pattern) || path.endsWith(pattern) || path.contains(pattern)) {
                return true;
            }
        }
        
        return false;
    }

    @Override
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
        if (DEBUG) {
            System.out.println("🔐 Authentication Filter initialized");
            System.out.println("📋 No auth required pages: " + NO_AUTH_REQUIRED.size());
        }
    }

    @Override
    public void destroy() {
        this.filterConfig = null;
        if (DEBUG) {
            System.out.println("🔐 Authentication Filter destroyed");
        }
    }
    
    /**
     * 📝 Log message
     */
    private void log(String msg) {
        if (filterConfig != null) {
            filterConfig.getServletContext().log("[AuthFilter] " + new Date() + ": " + msg);
        }
        if (DEBUG) {
            System.out.println("[AuthFilter] " + msg);
        }
    }
} 