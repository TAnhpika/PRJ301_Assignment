package controller.auth;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;

/*
Tóm lại: Nếu email Google chưa có trong database, hãy tự động tạo tài khoản mới rồi đăng nhập luôn. Nếu đã có thì đăng nhập như bình thường.
Đây là servlet dùng để xử lý phản hồi từ Google sau khi người dùng đăng nhập bằng Google OAuth. Nó sẽ:

Nhận code do Google trả về.

Đổi code này thành access_token.

Dùng access_token để gọi API lấy thông tin người dùng (email, name,...).

Tạo session đăng nhập và điều hướng về servlet xử lý tiếp (LoginServlet).
*/
public class GoogleCallbackServlet extends HttpServlet {
    private static String getClientId() {
        return util.Env.get("GOOGLE_CLIENT_ID");
    }

    private static String getClientSecret() {
        return util.Env.get("GOOGLE_CLIENT_SECRET");
    }

    private String REDIRECT_URI;

    @Override
    public void init() throws ServletException {
        super.init();
        String contextPath = "/TestFull";
        REDIRECT_URI = "http://localhost:8080" + contextPath + "/LoginGG/LoginGoogleHandler"; // REDIRECT_URI – tức là
                                                                                              // URL mà Google sẽ
                                                                                              // redirect người dùng về
                                                                                              // sau khi đăng nhập thành
                                                                                              // công.
        System.out.println("[DEBUG] GoogleCallbackServlet REDIRECT_URI initialized: " + REDIRECT_URI);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code"); // Lấy mã code mà Google trả về sau khi người dùng đồng ý đăng nhập
        System.out.println("[DEBUG] GoogleCallbackServlet received code: " + code);

        if (code != null) { // Nếu có code -> tức là đăng nhập thành công bên Google
            try {
                System.out.println("[DEBUG] GoogleCallbackServlet starting token request...");
                GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                        new NetHttpTransport(), // Cấu hình giao tiếp HTTP
                        new JacksonFactory(), // Dùng để xử lý JSON
                        getClientId(),
                        getClientSecret(),
                        code,
                        REDIRECT_URI)
                        .execute();

                String accessToken = tokenResponse.getAccessToken();

                // Tạo URL gọi đến API Google để lấy thông tin người dùng
                URL url = new URL("https://www.googleapis.com/oauth2/v2/userinfo");
                HttpURLConnection conn = (HttpURLConnection) url.openConnection(); // Tạo kết nối HTTP
                conn.setRequestProperty("Authorization", "Bearer " + accessToken); // Gửi access token để xác thực
                conn.setRequestMethod("GET"); // Phương thức GET

                if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    // đọc dữ liệu token gg trả về
                    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    StringBuilder result = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        result.append(line);
                    }

                    // chuyển cái token -> object
                    JSONObject userInfo = new JSONObject(result.toString());
                    String email = userInfo.getString("email");
                    String name = userInfo.getString("name");

                    HttpSession session = request.getSession();
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userName", name);

                    response.sendRedirect(request.getContextPath() + "/LoginServlet");
                } else {
                    throw new IOException("Failed to get user info");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp?error=google_auth_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp?error=no_auth_code");
        }
    }
}