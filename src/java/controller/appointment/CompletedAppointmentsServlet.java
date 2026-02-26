package controller.appointment;

import model.Appointment;
import dao.AppointmentDAO;
import dao.DoctorDAO;
import model.Doctors;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "CompletedAppointmentsServlet", urlPatterns = {"/completedAppointments"})
public class CompletedAppointmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== CompletedAppointmentsServlet - doGet ===");
        // Lấy session và kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("No session found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
            return;
        }
        // Lấy thông tin user từ session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            System.out.println("User object not found in session");
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
            return;
        }
        System.out.println("Found user: " + user.getEmail());
        System.out.println("User ID: " + user.getId());
        // Lấy thông tin doctor từ user_id
        Doctors doctor =DoctorDAO.getDoctorByUserId(user.getId());
        if (doctor == null) {
            System.out.println("❌ Không tìm thấy doctor cho userId: " + user.getId());
            request.setAttribute("error", "Không tìm thấy thông tin bác sĩ");
            request.getRequestDispatcher("/view/jsp/doctor/doctor_ketqua.jsp").forward(request, response);
            return;
        }
        System.out.println("Found doctor: " + doctor.getFull_name());
        System.out.println("Doctor ID: " + doctor.getDoctor_id());
        // Lấy ngày từ tham số, mặc định hôm nay
        String dateParam = request.getParameter("date");
        LocalDate selectedDate;
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                selectedDate = LocalDate.parse(dateParam.trim(), DateTimeFormatter.ISO_LOCAL_DATE);
            } catch (Exception ex) {
                selectedDate = LocalDate.now();
            }
        } else {
            selectedDate = LocalDate.now();
        }
        String dateStr = selectedDate.format(DateTimeFormatter.ISO_LOCAL_DATE);
        String dateDisplay = selectedDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));

        try {
            System.out.println("Fetching completed appointments for doctor ID: " + doctor.getDoctor_id() + ", date: " + dateStr);
            List<Appointment> dayAppointments = AppointmentDAO.getAppointmentsByDoctorAndDate(doctor.getDoctor_id(), dateStr);
            List<Appointment> completedAppointments = dayAppointments == null ? List.of() : dayAppointments.stream()
                    .filter(a -> "completed".equalsIgnoreCase(a.getStatus())
                            || "COMPLETED".equalsIgnoreCase(a.getStatus())
                            || "FINISHED".equalsIgnoreCase(a.getStatus()))
                    .collect(Collectors.toList());
            System.out.println("Found " + completedAppointments.size() + " completed appointments for date " + dateStr);

            request.setAttribute("completedAppointments", completedAppointments);
            request.setAttribute("doctorId", doctor.getDoctor_id());
            request.setAttribute("doctorName", doctor.getFull_name());
            request.setAttribute("userId", user.getId());
            request.setAttribute("selectedDate", dateStr);
            request.setAttribute("selectedDateDisplay", dateDisplay);
            request.setAttribute("isToday", selectedDate.equals(LocalDate.now()));

            request.getRequestDispatcher("/view/jsp/doctor/doctor_ketqua.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy danh sách kết quả khám: " + e.getMessage());
            request.setAttribute("completedAppointments", null);
            request.setAttribute("doctorId", doctor.getDoctor_id());
            request.setAttribute("doctorName", doctor.getFull_name());
            request.setAttribute("userId", user.getId());
            request.setAttribute("selectedDate", dateStr);
            request.setAttribute("selectedDateDisplay", dateDisplay);
            request.setAttribute("isToday", selectedDate.equals(LocalDate.now()));
            request.getRequestDispatcher("/view/jsp/doctor/doctor_ketqua.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể xử lý các action khác ở đây
        doGet(request, response);
    }
} 