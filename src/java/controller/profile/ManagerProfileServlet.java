package controller.profile;

import dao.ManagerDAO;
import dao.UserDAO;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Manager;
import model.User;

@WebServlet(name = "ManagerProfileServlet", urlPatterns = { "/ManagerProfileServlet" })
public class ManagerProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }

        Manager manager = ManagerDAO.getManagerInfo(user.getId());

        // Final fallback if DAO returns null (record missing in both Managers and Users
        // tables or DB error)
        if (manager == null) {
            manager = new Manager();
            manager.setUserId(user.getId());
            manager.setFullName(user.getUsername());
            manager.setPosition("Quản lý");
            manager.setCreatedAt(user.getCreatedAt());
            manager.setPhone("Chưa cập nhật");
            manager.setAddress("Chưa cập nhật");
            manager.setGender("Chưa có");
            manager.setManagerId(-1); // Mark as new/unsaved in Managers table
        }

        request.setAttribute("manager", manager);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/jsp/manager/manager_trangcanhan.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
