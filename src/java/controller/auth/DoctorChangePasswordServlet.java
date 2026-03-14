package controller.auth;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

/**
 * Servlet xử lý đổi mật khẩu cho Bác sĩ
 */
@WebServlet(name = "DoctorChangePasswordServlet", urlPatterns = {"/DoctorChangePasswordServlet", "/doctor_changepassword.jsp"})
public class DoctorChangePasswordServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DoctorChangePasswordServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        if (user == null || !"DOCTOR".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (currentPassword == null || currentPassword.isBlank() ||
                newPassword == null || newPassword.isBlank() ||
                confirmPassword == null || confirmPassword.isBlank()) {
            redirect(response, request, "error", "Vui lòng điền đầy đủ tất cả các trường.");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            redirect(response, request, "error", "Mật khẩu mới và xác nhận không khớp.");
            return;
        }

        if (newPassword.length() < 6) {
            redirect(response, request, "error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            return;
        }

        // Kiểm tra mật khẩu hiện tại bằng cách login lại
        try {
            User verified = UserDAO.loginUserInstance(user.getEmail(), currentPassword);
            if (verified == null) {
                redirect(response, request, "error", "Mật khẩu hiện tại không đúng.");
                return;
            }

            boolean updated = UserDAO.updatePasswordInstance(user.getId(), newPassword);
            if (updated) {
                redirect(response, request, "success", "Đổi mật khẩu thành công!");
            } else {
                redirect(response, request, "error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi DB khi đổi mật khẩu", e);
            redirect(response, request, "error", "Lỗi hệ thống. Vui lòng thử lại sau.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET → forward đến trang JSP
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null || !"DOCTOR".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
            return;
        }
        request.getRequestDispatcher("/view/jsp/doctor/doctor_changepassword.jsp").forward(request, response);
    }

    private void redirect(HttpServletResponse response, HttpServletRequest request,
            String type, String msg) throws IOException {
        String encoded = java.net.URLEncoder.encode(msg, "UTF-8");
        response.sendRedirect(request.getContextPath() +
                "/DoctorChangePasswordServlet?" + type + "=" + encoded);
    }
}
