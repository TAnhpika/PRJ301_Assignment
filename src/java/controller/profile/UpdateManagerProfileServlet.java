package controller.profile;

import dao.ManagerDAO;
import java.io.IOException;
import java.text.SimpleDateFormat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Manager;
import model.User;

@WebServlet(name = "UpdateManagerProfileServlet", urlPatterns = { "/UpdateManagerProfileServlet" })
public class UpdateManagerProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        try {
            request.setCharacterEncoding("UTF-8");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String dobStr = request.getParameter("dob");
            String position = request.getParameter("position");

            Manager manager = new Manager();
            manager.setUserId(user.getId());
            manager.setFullName(fullName);
            manager.setPhone(phone);
            manager.setAddress(address);
            manager.setGender(gender);
            manager.setPosition(position);

            if (dobStr != null && !dobStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                manager.setDateOfBirth(sdf.parse(dobStr));
            }

            boolean success = ManagerDAO.updateManagerProfile(manager);
            if (success) {
                session.setAttribute("successMessage", "Cập nhật hồ sơ thành công!");
            } else {
                session.setAttribute("errorMessage", "Cập nhật hồ sơ thất bại.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/ManagerProfileServlet");
    }
}
