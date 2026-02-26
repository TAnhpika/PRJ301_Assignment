package controller.profile;

import dao.AppointmentDAO;
import dao.BlogDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.Patients;
import java.util.List;
import model.Appointment;
import model.BlogPost;
import model.Doctors;

// @WebServlet annotation removed - using web.xml mapping instead
public class UserHompageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đảm bảo toàn bộ trang dashboard bệnh nhân hiển thị đúng Unicode (UTF-8)
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);

        // ❌ Nếu chưa có session → về trang login
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
            return;
        }

        // ✅ Có session nhưng patient null: vẫn cho vào trang chủ (show dữ liệu trống)
        Patients patient = (Patients) session.getAttribute("patient");
        if (patient == null) {
            request.setAttribute("upcomingAppointments", new ArrayList<Appointment>());
            request.setAttribute("totalVisits", 0);

            // Các section khác trên homepage vẫn nên có data tối thiểu
            List<Doctors> doctors = DoctorDAO.getAllDoctorsOnline();
            request.setAttribute("doctors", doctors);

            List<BlogPost> latestBlogs = BlogDAO.getLatest(2);
            request.setAttribute("latestBlogs", latestBlogs);

            request.getRequestDispatcher("/view/jsp/patient/user_homepage.jsp").forward(request, response);
            return;
        }

        // ✅ Nếu có patient, xử lý bình thường
        List<Appointment> upcomingAppointments = AppointmentDAO.getUpcomingAppointmentsByPatientId(patient.getPatientId());
        request.setAttribute("upcomingAppointments", upcomingAppointments);

        int totalVisits = PatientDAO.getTotalVisitsByPatientId(patient.getPatientId());
        request.setAttribute("totalVisits", totalVisits);

        System.out.println("Patient ID: " + patient.getPatientId());
        System.out.println("Total visits: " + totalVisits);
        List<BlogPost> latestBlogs = BlogDAO.getLatest(2); // hoặc tất cả nếu cần
        request.setAttribute("latestBlogs", latestBlogs);

        // Chuyển đến user_homepage.jsp
        request.getRequestDispatcher("/view/jsp/patient/user_homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
