package Filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 🔤 ENCODING FILTER
 * Filter đảm bảo encoding UTF-8 cho toàn bộ ứng dụng
 * Hỗ trợ tiếng Việt hiển thị đúng
 */
@WebFilter(filterName = "EncodingFilter", urlPatterns = {"/*"})
public class EncodingFilter implements Filter {
    
    private static final String ENCODING = "UTF-8";
    
    public EncodingFilter() {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        
        request.setCharacterEncoding(ENCODING);
        response.setCharacterEncoding(ENCODING);

        // Chỉ set Content-Type text/html cho trang HTML/JSP/Servlet.
        // Không set cho file tĩnh (.css, .js, .png...) để container trả đúng MIME type (fix layout bung).
        String uri = request.getRequestURI();
        if (!isStaticResource(uri)) {
            response.setContentType("text/html; charset=" + ENCODING);
        }

        chain.doFilter(req, res);
    }

    /** Bỏ qua setContentType cho file tĩnh (css, js, font, ảnh...) */
    private boolean isStaticResource(String uri) {
        if (uri == null) return false;
        String lower = uri.toLowerCase();
        return lower.endsWith(".css") || lower.endsWith(".js") || lower.endsWith(".png")
                || lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".gif")
                || lower.endsWith(".ico") || lower.endsWith(".svg") || lower.endsWith(".woff")
                || lower.endsWith(".woff2") || lower.endsWith(".ttf") || lower.endsWith(".eot");
    }

    @Override
    public void init(FilterConfig filterConfig) {
        System.out.println("🔤 Encoding Filter initialized with UTF-8");
    }

    @Override
    public void destroy() {
        System.out.println("🔤 Encoding Filter destroyed");
    }
} 