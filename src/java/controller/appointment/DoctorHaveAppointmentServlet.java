package controller.appointment;

import dao.DoctorDAO;
import model.Doctors;
import model.DoctorSchedule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servlet để quản lý và hiển thị lịch hẹn của bác sĩ đã đăng nhập.
 */

public class DoctorHaveAppointmentServlet extends HttpServlet {

    private DoctorDAO doctorScheduleDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        doctorScheduleDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dateParam = request.getParameter("date");

        try {
            // Có ?date= thì filter theo ngày (1 trang, văn phòng)
            if (dateParam != null && !dateParam.trim().isEmpty()) {
                showSchedulesByDate(request, response);
                return;
            }
            showPersonalSchedule(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    /**
     * Hiển thị toàn bộ lịch làm việc của bác sĩ đang đăng nhập.
     */
    private void showPersonalSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        Doctors doctor = (Doctors) request.getSession().getAttribute("doctor");
        System.out.println("DEBUG: doctor in session = " + doctor);
        if (doctor == null) {
            request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
            request.getRequestDispatcher(request.getContextPath() + "/view/jsp/auth/login.jsp").forward(request,
                    response);
            return;
        }

        int doctorId = (int) doctor.getDoctorId();
        List<DoctorSchedule> allSchedules = doctorScheduleDAO.getSchedulesByDoctorId(doctorId);

        // Optimized: 1 day only 1 slot
        List<DoctorSchedule> optimizedSchedules = optimizeSchedules(allSchedules);

        List<Doctors> doctors = doctorScheduleDAO.getAllDoctors();

        request.setAttribute("schedules", optimizedSchedules);
        request.setAttribute("doctors", doctors);
        request.setAttribute("selectedDoctorId", doctorId);
        request.setAttribute("pageTitle", "Lịch Làm Việc Của Bạn");
        request.setAttribute("selectedDate", "");
        request.setAttribute("selectedDateDisplay", "");
        request.setAttribute("isToday", false);
        request.setAttribute("filterByDate", false);

        request.getRequestDispatcher("/view/jsp/doctor/doctor_trongtuan.jsp").forward(request, response);
    }

    /**
     * Hiển thị lịch làm việc theo ngày cụ thể.
     */
    private void showSchedulesByDate(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // ✅ Đảm bảo sử dụng đúng key "doctor"
        Doctors doctor = (Doctors) request.getSession().getAttribute("doctor");
        if (doctor == null) {
            request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
            request.getRequestDispatcher(request.getContextPath() + "/view/jsp/auth/login.jsp").forward(request,
                    response);
            return;
        }

        int doctorId = (int) doctor.getDoctorId();
        String dateParam = request.getParameter("date");

        if (dateParam == null || dateParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn ngày");
            showPersonalSchedule(request, response);
            return;
        }

        try {
            LocalDate localDate = LocalDate.parse(dateParam);
            java.sql.Date sqlDate = java.sql.Date.valueOf(localDate);

            List<DoctorSchedule> allSchedules = doctorScheduleDAO.getSchedulesByDoctorId(doctorId);
            List<DoctorSchedule> daySchedules = allSchedules.stream()
                    .filter(schedule -> schedule.getWorkDate() != null && schedule.getWorkDate().equals(sqlDate))
                    .collect(Collectors.toList());

            // Optimized: 1 day only 1 slot
            List<DoctorSchedule> schedules = optimizeSchedules(daySchedules);

            List<Doctors> doctors = doctorScheduleDAO.getAllDoctors();

            request.setAttribute("schedules", schedules);
            request.setAttribute("doctors", doctors);
            request.setAttribute("selectedDoctorId", doctorId);
            request.setAttribute("selectedDate", dateParam);
            request.setAttribute("selectedDateDisplay", localDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            request.setAttribute("isToday", localDate.equals(LocalDate.now()));
            request.setAttribute("pageTitle",
                    "Lịch Làm Việc Ngày " + localDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            request.setAttribute("filterByDate", true);

            request.getRequestDispatcher("/view/jsp/doctor/doctor_trongtuan.jsp").forward(request, response);
        } catch (DateTimeParseException e) {
            request.setAttribute("errorMessage", "Ngày không hợp lệ. Vui lòng sử dụng định dạng yyyy-MM-dd");
            showPersonalSchedule(request, response);
        }
    }

    private List<DoctorSchedule> optimizeSchedules(List<DoctorSchedule> schedules) {
        if (schedules == null || schedules.isEmpty())
            return schedules;

        java.util.Map<java.sql.Date, DoctorSchedule> scheduleMap = new java.util.LinkedHashMap<>();

        for (DoctorSchedule s : schedules) {
            java.sql.Date date = s.getWorkDate();
            if (date == null)
                continue;

            if (!scheduleMap.containsKey(date)) {
                scheduleMap.put(date, s);
            } else {
                // If already has a slot, check priority: Slot 3 (Cả ngày) is highest
                DoctorSchedule existing = scheduleMap.get(date);
                if (s.getSlotId() != null && s.getSlotId() == 3) {
                    scheduleMap.put(date, s);
                } else if (existing.getSlotId() != null && existing.getSlotId() != 3) {
                    // If existing is not Slot 3, we can keep either 1 or 2,
                    // but the goal is "1 day 1 slot", so we just keep the first one unless a 3
                    // comes along.
                }
            }
        }
        return new java.util.ArrayList<>(scheduleMap.values());
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị lịch làm việc cho bác sĩ đã đăng nhập.";
    }
}
