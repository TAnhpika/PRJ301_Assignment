package controller.profile;

import dao.DoctorDAO;
import model.Doctors;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet trang Trang cá nhân bác sĩ (doctor_trangcanhan).
 * Load thông tin bác sĩ và forward tới doctor_trangcanhan.jsp.
 */
public class DoctorProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
            return;
        }
        Doctors doctor = DoctorDAO.getDoctorByUserId(user.getId());
        if (doctor != null) {
            request.setAttribute("doctor_trangcanhan", doctor);
        }
        request.getRequestDispatcher("/view/jsp/doctor/doctor_trangcanhan.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
