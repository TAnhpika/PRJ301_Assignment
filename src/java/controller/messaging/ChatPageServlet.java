package controller.messaging;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * ChatPageServlet - Route đến giao diện chat theo role
 * URL: /ChatPageServlet
 */
@WebServlet("/ChatPageServlet")
public class ChatPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
            return;
        }

        String role = user.getRole();

        if ("DOCTOR".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/view/jsp/doctor/doctor_chat.jsp").forward(request, response);
        } else if ("PATIENT".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/view/jsp/patient/patient_chat.jsp").forward(request, response);
        } else {
            // Admin / Staff → chưa có trang riêng
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
