package controller.appointment;

import dao.AppointmentDAO;
import dao.ServiceDAO;
import dao.PatientDAO;
import model.SlotReservation;
import model.Service;
import model.Patients;
import model.User;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet xử lý đặt lịch appointment với bác sĩ
 * Tích hợp với PayOSServlet để thanh toán
 */
@WebServlet(name = "BookingServlet", urlPatterns = { "/booking" })
public class BookingServlet extends HttpServlet {

    private ServiceDAO serviceDAO = new ServiceDAO();
    private PatientDAO patientDAO = new PatientDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null)
            action = "form";

        try {
            switch (action) {
                case "form":
                    showBookingForm(request, response);
                    break;
                case "check-slots":
                    checkAvailableSlots(request, response);
                    break;
                case "get-booked-slots":
                    getBookedSlots(request, response);
                    break;
                default:
                    showBookingForm(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Lỗi BookingServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi xử lý đặt lịch: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null)
            action = "book";

        try {
            switch (action) {
                case "book":
                    handleBookAppointment(request, response);
                    break;
                case "reserve-slot":
                    reserveSlot(request, response);
                    break;
                default:
                    handleBookAppointment(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Lỗi BookingServlet POST: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi xử lý đặt lịch: " + e.getMessage());
        }
    }

    /**
     * Hiển thị form đặt lịch
     */
    private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy danh sách services cho dropdown
        List<Service> services = serviceDAO.getAllServices();
        request.setAttribute("services", services);

        // Forward tới JSP
        request.getRequestDispatcher("/booking.jsp").forward(request, response);
    }

    /**
     * Xử lý đặt lịch appointment → chuyển sang thanh toán
     */
    private void handleBookAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        // Lấy thông tin từ form
        String serviceIdStr = request.getParameter("serviceId");
        String doctorIdStr = request.getParameter("doctorId");
        String workDate = request.getParameter("workDate");
        String slotIdStr = request.getParameter("slotId");
        String reason = request.getParameter("reason");

        if (serviceIdStr == null || doctorIdStr == null || workDate == null || slotIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Thiếu thông tin: serviceId, doctorId, workDate, slotId");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            int slotId = Integer.parseInt(slotIdStr);
            LocalDate appointmentDate = LocalDate.parse(workDate);

            // Validate user
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
                return;
            }

            // Lấy thông tin patient
            Patients patient = patientDAO.getPatientByUserId(user.getId());
            if (patient == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy thông tin bệnh nhân");
                return;
            }

            // Kiểm tra slot có available không
            if (!AppointmentDAO.isSlotAvailable(doctorId, appointmentDate, slotId)) {
                response.sendError(HttpServletResponse.SC_CONFLICT,
                        "Slot đã được đặt. Vui lòng chọn slot khác.");
                return;
            }

            // CHUYỂN HƯỚNG ĐẾN PAYOSSERVLET ĐỂ THANH TOÁN
            String paymentUrl = String.format(
                    "/TestFull/payment?serviceId=%s&doctorId=%s&workDate=%s&slotId=%s&reason=%s",
                    serviceId, doctorId, workDate, slotId,
                    reason != null ? java.net.URLEncoder.encode(reason, "UTF-8") : "");

            System.out.println("🎯 BOOKING REQUEST -> PAYMENT");
            System.out.println("📅 Doctor: " + doctorId + " | Date: " + workDate + " | Slot: " + slotId);
            System.out.println("🔗 Redirecting to: " + paymentUrl);

            response.sendRedirect(paymentUrl);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tham số không hợp lệ: " + e.getMessage());
        }
    }

    /**
     * Tạm khóa slot trong 5 phút (AJAX call)
     */
    private void reserveSlot(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        try {
            String doctorIdStr = request.getParameter("doctorId");
            String workDate = request.getParameter("workDate");
            String slotIdStr = request.getParameter("slotId");
            String reason = request.getParameter("reason");

            int doctorId = Integer.parseInt(doctorIdStr);
            int slotId = Integer.parseInt(slotIdStr);
            LocalDate appointmentDate = LocalDate.parse(workDate);

            // Lấy patient
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            Patients patient = patientDAO.getPatientByUserId(user.getId());

            // Tạm khóa slot
            SlotReservation reservation = AppointmentDAO.createReservation(
                    doctorId, appointmentDate, slotId, patient.getPatientId(), reason);

            Map<String, Object> result = new HashMap<>();
            if (reservation != null) {
                result.put("success", true);
                result.put("reservationId", reservation.getAppointmentId());
                result.put("expiresAt", reservation.getExpiresAt().toString());
                result.put("remainingTime", reservation.getRemainingTime());
                result.put("message", "Đã tạm khóa slot thành công! Bạn có " +
                        reservation.getRemainingTime() + " để hoàn tất thanh toán.");
            } else {
                result.put("success", false);
                result.put("message", "Không thể tạm khóa slot. Slot có thể đã được đặt.");
            }

            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Lỗi: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }

    /**
     * Kiểm tra slots có sẵn (AJAX)
     */
    private void checkAvailableSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        try {
            String doctorIdStr = request.getParameter("doctorId");
            String workDate = request.getParameter("workDate");

            int doctorId = Integer.parseInt(doctorIdStr);
            LocalDate appointmentDate = LocalDate.parse(workDate);

            // Lấy danh sách slots đã đặt
            List<Integer> bookedSlots = AppointmentDAO.getBookedSlots(doctorId, appointmentDate);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("doctorId", doctorId);
            result.put("workDate", workDate);
            result.put("bookedSlots", bookedSlots);
            result.put("availableSlots", calculateAvailableSlots(bookedSlots));

            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Lỗi: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }

    /**
     * Lấy danh sách slots đã đặt để disable UI (AJAX)
     */
    private void getBookedSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        try {
            String doctorIdStr = request.getParameter("doctorId");
            String workDate = request.getParameter("workDate");

            int doctorId = Integer.parseInt(doctorIdStr);
            LocalDate appointmentDate = LocalDate.parse(workDate);

            List<Integer> bookedSlots = AppointmentDAO.getBookedSlots(doctorId, appointmentDate);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("doctorId", doctorId);
            result.put("workDate", workDate);
            result.put("bookedSlots", bookedSlots);
            result.put("count", bookedSlots.size());
            result.put("message", "Tìm thấy " + bookedSlots.size() + " slots đã được đặt");

            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Lỗi: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }

    /**
     * Tính toán slots available (giả sử có 8 slots: 1-8)
     */
    private List<Integer> calculateAvailableSlots(List<Integer> bookedSlots) {
        List<Integer> availableSlots = new java.util.ArrayList<>();
        for (int i = 1; i <= 8; i++) {
            if (!bookedSlots.contains(i)) {
                availableSlots.add(i);
            }
        }
        return availableSlots;
    }
}