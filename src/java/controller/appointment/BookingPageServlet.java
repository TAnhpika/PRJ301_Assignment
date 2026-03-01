/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.appointment;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.ServiceDAO;
import dao.TimeSlotDAO;
import dao.DoctorScheduleDAO;
import dao.RelativesDAO;
import dao.PatientDAO;
import dao.ServicePriceDAO;
import dao.SpecialtyDAO;
import util.N8nWebhookService;
import model.Appointment;
import model.Doctors;
import model.Patients;
import model.Service;
import model.Specialty;
import model.TimeSlot;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.WebServlet;
import java.util.List;
import model.DoctorSchedule;
import model.User;
import java.time.LocalDate;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.sql.Date;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalTime;

/**
 *
 * @author Home & TranHongPhuoc
 */
// @WebServlet annotation removed - using web.xml mapping instead
public class BookingPageServlet extends HttpServlet {

    private List<DoctorSchedule> schedules;
    private List<String> workDates;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BookingPageServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingPageServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /*
     * Chức năng chính: Xử lý các yêu cầu liên quan đến việc đặt lịch khám bệnh, bao
     * gồm:
     * Hiển thị giao diện đặt lịch (GET).
     * Xử lý yêu cầu đặt lịch (POST).
     * Lấy danh sách khung giờ (time slots) của bác sĩ qua AJAX.
     * Quản lý thông tin người thân (nếu đặt lịch cho người thân).
     */

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User patient = (User) session.getAttribute("user");

        // Kiểm tra session và role
        if (session == null || patient == null) {
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
            return;
        }

        // Kiểm tra role PATIENT
        if (!"PATIENT".equalsIgnoreCase(patient.getRole())) {
            request.setAttribute("error", "Bạn không có quyền truy cập trang này!");
            request.getRequestDispatcher("/WEB-INF/jsp/error/404.jsp").forward(request, response);
            return;
        }

        try {
            // XỬ LÝ SERVICEID - Lấy thông tin dịch vụ nếu có (SỬ DỤNG GIÁ CỐ ĐỊNH 50K)
            String serviceIdStr = request.getParameter("serviceId");
            Service selectedService = null;

            // Kiểm tra session trước (nếu đã chọn dịch vụ từ lần trước)
            Service sessionService = (Service) session.getAttribute("selectedService");
            if (sessionService != null) {
                selectedService = sessionService;
                System.out.println("✅ Lấy dịch vụ từ session: " + selectedService.getServiceName());
            }

            // Nếu có serviceId từ URL và khác với session -> cập nhật
            if (serviceIdStr != null && !serviceIdStr.isEmpty()) {
                try {
                    int serviceId = Integer.parseInt(serviceIdStr);
                    // Chỉ load lại nếu serviceId khác với session
                    if (selectedService == null || selectedService.getServiceId() != serviceId) {
                        ServicePriceDAO servicePriceDAO = new ServicePriceDAO();
                        selectedService = servicePriceDAO.getServiceWithFixedPrice(serviceId);
                        if (selectedService != null) {
                            // Lưu vào session để giữ qua các bước
                            session.setAttribute("selectedService", selectedService);
                            System.out
                                    .println("🎯 Service được chọn với giá cố định: " + selectedService.getServiceName()
                                            + " - 50,000 VNĐ");
                        } else {
                            System.err.println("❌ Không tìm thấy ServiceId trong DB: " + serviceId);
                            session.removeAttribute("selectedService");
                        }
                    }
                } catch (NumberFormatException e) {
                    System.err.println("❌ ServiceId không hợp lệ: " + serviceIdStr);
                }
            }

            // Set attribute cho JSP
            if (selectedService != null) {
                request.setAttribute("selectedService", selectedService);
            }

            // Xử lý request AJAX cho timeslots (giống StaffBookingServlet)
            // Kiểm tra xem yêu cầu có phải là AJAX (dùng để lấy danh sách khung giờ).
            // Nếu đúng, gọi phương thức handleGetTimeSlots và kết thúc xử lý.
            if (request.getParameter("ajax") != null) {
                handleGetTimeSlots(request, response);
                return;
            }

            // Xử lý request thông thường
            List<Appointment> appointments = AppointmentDAO.getAppointmentsByPatientId(patient.getId());
            request.setAttribute("appointments", appointments);
            System.out.println("Appointments: " + appointments);

            // Lấy danh sách bác sĩ - CHỈ HIỂN THỊ BÁC SĨ ĐÚNG CHUYÊN KHOA CỦA DỊCH VỤ ĐÃ
            // CHỌN
            List<Doctors> doctors;
            String specialtyNameForFilter = null;
            String keyword = request.getParameter("keyword");
            if (keyword != null)
                keyword = keyword.trim();
            boolean forceSpecialtyFromService = (selectedService != null);

            if (selectedService != null) {
                if (selectedService.getSpecialtyId() > 0) {
                    SpecialtyDAO specialtyDAO = new SpecialtyDAO();
                    Specialty spec = specialtyDAO.getById(selectedService.getSpecialtyId());
                    if (spec != null && spec.getSpecialtyName() != null)
                        specialtyNameForFilter = spec.getSpecialtyName().trim();
                }
                if (specialtyNameForFilter == null && selectedService.getCategory() != null
                        && !selectedService.getCategory().isEmpty())
                    specialtyNameForFilter = selectedService.getCategory().trim();
            }
            if (!forceSpecialtyFromService && (specialtyNameForFilter == null || specialtyNameForFilter.isEmpty())) {
                String paramSpecialty = request.getParameter("specialty");
                if (paramSpecialty != null && !paramSpecialty.trim().isEmpty())
                    specialtyNameForFilter = paramSpecialty.trim();
            }

            if (specialtyNameForFilter != null && !specialtyNameForFilter.isEmpty()) {
                doctors = DoctorDAO.filterDoctors("".equals(keyword) ? null : keyword, specialtyNameForFilter);
                if (doctors == null)
                    doctors = new ArrayList<>();
                System.out.println("🔍 Filter bác sĩ theo chuyên khoa: " + specialtyNameForFilter
                        + (keyword != null && !keyword.isEmpty() ? ", từ khóa: " + keyword : "") + " -> "
                        + doctors.size() + " bác sĩ");
                // Khi đã chọn dịch vụ: CHỈ trả về bác sĩ đúng chuyên khoa, không fallback tất
                // cả
                if (forceSpecialtyFromService && doctors.isEmpty()) {
                    System.out.println("⚠️ Chưa có bác sĩ nào phục vụ chuyên khoa: " + specialtyNameForFilter);
                    request.setAttribute("noDoctorsForSpecialty", true);
                    request.setAttribute("specialtyNameForMessage", specialtyNameForFilter);
                }
            } else {
                doctors = (keyword != null && !keyword.isEmpty())
                        ? DoctorDAO.filterDoctors(keyword, null)
                        : DoctorDAO.getAllDoctors();
                if (doctors == null)
                    doctors = new ArrayList<>();
            }
            if (doctors != null) {
                for (Doctors doctor : doctors) {
                    // ✅ LOGIC MỚI: Tự động tạo 14 ngày tiếp theo và loại bỏ ngày nghỉ
                    List<String> workDates = DoctorScheduleDAO.getWorkDatesExcludingLeaves((int) doctor.getDoctor_id(),
                            14); // 14 ngày tới
                    doctor.setWorkDates(workDates);

                    // Vẫn giữ schedules để hiển thị thông tin nghỉ phép (nếu cần)
                    DoctorScheduleDAO dsDAO = new DoctorScheduleDAO();
                    List<DoctorSchedule> schedules = dsDAO.getSchedulesByDoctorId((long) doctor.getDoctor_id());
                    doctor.setSchedules(schedules);

                    System.out.println("👨‍⚕️ Bác sĩ " + doctor.getFull_name() + " có " + workDates.size()
                            + " ngày làm việc trong 14 ngày tới");
                }
            }
            request.setAttribute("doctors", doctors);
            if (specialtyNameForFilter != null)
                request.setAttribute("selectedSpecialtyName", specialtyNameForFilter);
            System.out.println("Doctors: " + doctors);

            // Lấy danh sách chuyên khoa
            List<String> specialties = DoctorDAO.getAllSpecialties();
            request.setAttribute("specialties", specialties);
            System.out.println("Specialties: " + specialties);

            // Lấy danh sách dịch vụ để hiển thị trong popup chọn dịch vụ - CHỈ LOAD NẾU
            // CHƯA CÓ DỊCH VỤ ĐÃ CHỌN
            // Nếu đã có selectedService, không cần load lại để tránh người dùng chọn lại
            if (selectedService == null) {
                try {
                    ServicePriceDAO servicePriceDAO = new ServicePriceDAO();
                    List<Service> services = servicePriceDAO.getAllServicesWithFixedPrice(); // xử lý bên
                                                                                             // servicePriceDAO
                    request.setAttribute("services", services);
                    System.out.println("✅ Services loaded with fixed price 50k: " + services.size());
                } catch (Exception e) {
                    System.err.println("❌ Error loading services: " + e.getMessage());
                    request.setAttribute("services", new ArrayList<>());
                }
            } else {
                // Đã có dịch vụ đã chọn -> không cần load danh sách dịch vụ để chọn lại
                request.setAttribute("services", new ArrayList<>());
                System.out.println("✅ Đã có dịch vụ đã chọn, không load lại danh sách dịch vụ");
            }

            // Lấy danh sách ngày làm việc của bác sĩ (nếu có doctorId) // render ngày làm
            // việc cảu bác sĩ theo getWorkDatesByDoctorId
            String doctorIdStr = request.getParameter("doctor_id");
            List<String> workDates = new ArrayList<>();
            if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
                try {
                    int doctorId = Integer.parseInt(doctorIdStr);
                    workDates = DoctorScheduleDAO.getWorkDatesByDoctorId(doctorId);
                } catch (NumberFormatException e) {
                    // Bỏ qua nếu không hợp lệ
                }
            }
            request.setAttribute("workDates", workDates);

            // Không cần validate thông tin người thân ở doGet nữa - xử lý ở doPost

            request.getRequestDispatcher("/view/jsp/patient/user_datlich.jsp").forward(request, response); // forward ra
                                                                                                           // ở
            // đây

        } catch (ServletException | IOException | NumberFormatException e) {
            if (!response.isCommitted()) {
                request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/jsp/error/404.jsp").forward(request, response);
            } else {
                System.err.println("Không thể forward vì response đã commit: " + e.getMessage());
            }
        }
    }

    // ===================================================================================
    // doPost: Xử lý yêu cầu HTTP POST để thực hiện đặt lịch hoặc tạo thông tin
    // người thân.
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        User patient = (User) session.getAttribute("user");

        // Kiểm tra session
        if (patient == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Phiên đăng nhập đã hết hạn\"}");
            return;
        }

        String action = request.getParameter("action");

        // Xử lý tạo/lấy relative_id
        if ("createRelative".equals(action)) {
            handleCreateRelative(request, response, patient);
            return;
        }

        // Xử lý đặt lịch bình thường
        response.setContentType("text/html;charset=UTF-8");

        // Lấy dữ liệu từ form đặt lịch
        String doctorIdStr = request.getParameter("doctorId");
        String workDate = request.getParameter("workDate");
        String slotIdStr = request.getParameter("slotId");
        String reason = request.getParameter("reason");
        String serviceIdStr = request.getParameter("serviceId"); // Nhận serviceId từ form
        String bookingFor = request.getParameter("bookingFor");
        String relativeIdStr = request.getParameter("relativeId");

        // Kiểm tra dữ liệu đầu vào
        if (doctorIdStr == null || workDate == null || slotIdStr == null) {
            request.setAttribute("error", "Thiếu thông tin đặt lịch!");
            doGet(request, response);
            return;
        }

        // TẠO RELATIVE_ID TỰ ĐỘNG KHI CHỌN "RELATIVE"
        if ("relative".equals(bookingFor)) {
            System.out.println("🎯 User chọn đặt lịch cho người thân - Xử lý thông tin từ form");

            // Lấy thông tin người thân từ form
            String relativeName = request.getParameter("relativeName");
            String relativePhone = request.getParameter("relativePhone");
            String relativeDob = request.getParameter("relativeDob");
            String relativeGender = request.getParameter("relativeGender");
            String relativeRelationship = request.getParameter("relativeRelationship");

            // Nếu form có đầy đủ thông tin, dùng thông tin từ form
            if (relativeName != null && !relativeName.trim().isEmpty() &&
                    relativePhone != null && !relativePhone.trim().isEmpty() &&
                    relativeDob != null && !relativeDob.trim().isEmpty() &&
                    relativeGender != null && !relativeGender.trim().isEmpty() &&
                    relativeRelationship != null && !relativeRelationship.trim().isEmpty()) {

                try {
                    RelativesDAO relativesDAO = new RelativesDAO();

                    // Nếu đã có relativeId, update lại thông tin
                    if (relativeIdStr != null && !relativeIdStr.isEmpty()) {
                        int existingRelativeId = Integer.parseInt(relativeIdStr);
                        boolean updated = RelativesDAO.updateRelative(
                                existingRelativeId,
                                relativeName.trim(),
                                relativePhone.trim(),
                                relativeDob,
                                relativeGender.trim(),
                                relativeRelationship.trim());
                        if (updated) {
                            System.out.println(
                                    "✅ Cập nhật thông tin người thân: " + existingRelativeId + " | " + relativeName);
                        }
                    } else {
                        // Tạo mới người thân với thông tin từ form
                        int relativeId = relativesDAO.getOrCreateRelative(
                                patient.getId(),
                                relativeName.trim(),
                                relativePhone.trim(),
                                relativeDob,
                                relativeGender.trim(),
                                relativeRelationship.trim());

                        if (relativeId > 0) {
                            relativeIdStr = String.valueOf(relativeId);
                            System.out.println("✅ Tạo người thân mới từ form: " + relativeId + " | " + relativeName);
                        } else {
                            request.setAttribute("error", "Không thể tạo thông tin người thân! Vui lòng thử lại.");
                            doGet(request, response);
                            return;
                        }
                    }
                } catch (Exception e) {
                    System.err.println("❌ Lỗi xử lý thông tin người thân từ form: " + e.getMessage());
                    request.setAttribute("error", "Có lỗi khi xử lý thông tin người thân!");
                    doGet(request, response);
                    return;
                }
            } else {
                // Nếu form thiếu thông tin, tạo thông tin mặc định
                String defaultName = "Người thân của " + patient.getUsername();
                String defaultPhone = patient.getPhone() != null ? patient.getPhone() : "0000000000";
                String defaultDob = "1990-01-01";
                String defaultGender = "Khác";
                String defaultRelationship = "Khác";

                try {
                    RelativesDAO relativesDAO = new RelativesDAO();
                    int relativeId = relativesDAO.getOrCreateRelative(
                            patient.getId(),
                            defaultName,
                            defaultPhone,
                            defaultDob,
                            defaultGender,
                            defaultRelationship);

                    if (relativeId > 0) {
                        relativeIdStr = String.valueOf(relativeId);
                        System.out.println(
                                "✅ Tạo relative_id mặc định: " + relativeId + " cho user_id: " + patient.getId());
                    } else {
                        request.setAttribute("error", "Không thể tạo thông tin người thân! Vui lòng thử lại.");
                        doGet(request, response);
                        return;
                    }
                } catch (Exception e) {
                    System.err.println("❌ Lỗi tạo relative_id mặc định: " + e.getMessage());
                    request.setAttribute("error", "Có lỗi khi tạo thông tin người thân!");
                    doGet(request, response);
                    return;
                }
            }
        }

        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            int slotId = Integer.parseInt(slotIdStr);
            LocalDate appointmentDate = LocalDate.parse(workDate);

            // Kiểm tra slot có available không trước khi chuyển sang thanh toán
            if (!AppointmentDAO.isSlotAvailable(doctorId, appointmentDate, slotId)) {
                request.setAttribute("error", "Slot đã được đặt. Vui lòng chọn slot khác!");
                doGet(request, response);
                return;
            }

            // ==============================================================================
            // CHUYỂN HƯỚNG ĐẾN PAYOSSERVLET ĐỂ THANH TOÁN
            // Sử dụng serviceId từ form, nếu không có thì dùng mặc định
            String finalServiceId = (serviceIdStr != null && !serviceIdStr.isEmpty()) ? serviceIdStr : "1";

            // Tạo URL với tham số người thân (nếu có)
            StringBuilder paymentUrlBuilder = new StringBuilder(); // khởi tạo đối tượng string builder với object để
                                                                   // xây dựng URL. StringBuilder được sử dụng vì nó
                                                                   // hiệu quả hơn khi nối chuỗi so với String.
            paymentUrlBuilder.append(String.format(
                    "%s/payment?serviceId=%s&doctorId=%s&workDate=%s&slotId=%s&reason=%s",
                    request.getContextPath(),
                    finalServiceId,
                    doctorId,
                    workDate,
                    slotId,
                    reason != null ? java.net.URLEncoder.encode(reason, "UTF-8") : ""));

            // Thêm thông tin người thân vào URL nếu có
            if ("relative".equals(bookingFor) && relativeIdStr != null && !relativeIdStr.isEmpty()) {
                paymentUrlBuilder.append("&bookingFor=relative&relativeId=").append(relativeIdStr);

                // Thêm thông tin chi tiết người thân vào URL để PayOSServlet có thể lấy
                String relativeName = request.getParameter("relativeName");
                String relativePhone = request.getParameter("relativePhone");
                String relativeDob = request.getParameter("relativeDob");
                String relativeGender = request.getParameter("relativeGender");
                String relativeRelationship = request.getParameter("relativeRelationship");

                if (relativeName != null && !relativeName.trim().isEmpty()) {
                    try {
                        paymentUrlBuilder.append("&relativeName=")
                                .append(java.net.URLEncoder.encode(relativeName.trim(), "UTF-8"));
                        paymentUrlBuilder.append("&relativePhone=").append(
                                java.net.URLEncoder.encode(relativePhone != null ? relativePhone.trim() : "", "UTF-8"));
                        paymentUrlBuilder.append("&relativeDob=")
                                .append(java.net.URLEncoder.encode(relativeDob != null ? relativeDob : "", "UTF-8"));
                        paymentUrlBuilder.append("&relativeGender=").append(java.net.URLEncoder
                                .encode(relativeGender != null ? relativeGender.trim() : "", "UTF-8"));
                        paymentUrlBuilder.append("&relativeRelationship=").append(java.net.URLEncoder
                                .encode(relativeRelationship != null ? relativeRelationship.trim() : "", "UTF-8"));

                        System.out.println("✅ TRUYỀN THÔNG TIN NGƯỜI THÂN QUA URL:");
                        System.out.println("   - Tên: " + relativeName);
                        System.out.println("   - SĐT: " + relativePhone);
                        System.out.println("   - Ngày sinh: " + relativeDob);
                        System.out.println("   - Giới tính: " + relativeGender);
                        System.out.println("   - Quan hệ: " + relativeRelationship);
                    } catch (Exception e) {
                        System.err.println("❌ Lỗi encode thông tin người thân: " + e.getMessage());
                    }
                }
            }

            String paymentUrl = paymentUrlBuilder.toString();

            System.out.println("🎯 BOOKING REQUEST -> PAYMENT");
            System.out.println("🏥 Service: " + finalServiceId + " | Doctor: " + doctorId + " | Date: " + workDate
                    + " | Slot: " + slotId);
            System.out.println("🔗 Redirecting to: " + paymentUrl);

            response.sendRedirect(paymentUrl); // repond đi cái paymentUrlBuilder

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Thông tin không hợp lệ: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            System.err.println("Error in booking: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }

    // ============================================================================================================

    // Xử lý tạo/lấy thông tin người thân

    private void handleCreateRelative(HttpServletRequest request, HttpServletResponse response, User patient)
            throws ServletException, IOException {

        try {
            String relativeName = request.getParameter("relativeName");
            String relativePhone = request.getParameter("relativePhone");
            String relativeDob = request.getParameter("relativeDob");
            String relativeGender = request.getParameter("relativeGender");
            String relativeRelationship = request.getParameter("relativeRelationship");

            // Validate dữ liệu
            if (relativeName == null || relativeName.trim().isEmpty() ||
                    relativePhone == null || relativePhone.trim().isEmpty() ||
                    relativeDob == null || relativeDob.trim().isEmpty() ||
                    relativeGender == null || relativeGender.trim().isEmpty() ||
                    relativeRelationship == null || relativeRelationship.trim().isEmpty()) {

                response.getWriter()
                        .write("{\"success\": false, \"message\": \"Vui lòng nhập đầy đủ thông tin người thân!\"}");
                return;
            }

            // Tạo/lấy relative_id
            RelativesDAO relativesDAO = new RelativesDAO();
            int relativeId = relativesDAO.getOrCreateRelative(
                    patient.getId(),
                    relativeName.trim(),
                    relativePhone.trim(),
                    relativeDob,
                    relativeGender.trim(),
                    relativeRelationship.trim());

            if (relativeId > 0) {
                System.out.println("✅ [RELATIVE BOOKING] Created/found relative_id: " + relativeId
                        + " for user_id: " + patient.getId()
                        + " | Name: " + relativeName);

                response.getWriter().write("{\"success\": true, \"relativeId\": " + relativeId + "}");
            } else {
                response.getWriter()
                        .write("{\"success\": false, \"message\": \"Không thể tạo thông tin người thân!\"}");
            }

        } catch (Exception e) {
            System.err.println("❌ Error in handleCreateRelative: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }

    /**
     * Lấy danh sách khung giờ của bác sĩ với thông tin đã đặt
     */
    private void handleGetTimeSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String workDate = request.getParameter("workDate");
            LocalDate localDate = LocalDate.parse(workDate);

            System.out.println("Getting timeslots for doctorId: " + doctorId + ", workDate: " + workDate);

            // Lấy danh sách slot_id mà bác sĩ đã đăng ký và được xác nhận
            List<Integer> approvedSlotIds = DoctorScheduleDAO.getAvailableSlotIdsByDoctorAndDate(doctorId, workDate);
            System.out.println("✅ Available slot IDs (NEW LOGIC): " + approvedSlotIds);

            // Dọn reservation WAITING_PAYMENT quá hạn (slot đã qua giờ) → trả slot về xanh
            // cho người khác
            int cleaned = AppointmentDAO.cleanupExpiredReservations();
            if (cleaned > 0) {
                System.out.println("🧹 Đã giải phóng " + cleaned + " slot chờ thanh toán quá hạn");
            }

            // Lấy danh sách slot đã được đặt (BOOKED + WAITING_PAYMENT → hiển thị xám)
            List<Integer> bookedSlotIds = AppointmentDAO.getBookedSlots(doctorId, localDate);
            System.out.println("Booked slot IDs: " + bookedSlotIds);

            // Convert doctor schedule slot IDs to actual time slot IDs
            List<Integer> actualTimeSlotIds = new ArrayList<>();
            for (Integer slotId : approvedSlotIds) {
                switch (slotId) {
                    case 1: // Ca sáng (8:00-12:00)
                        actualTimeSlotIds.addAll(TimeSlotDAO.getTimeSlotIdsForShift(1));
                        break;
                    case 2: // Ca chiều (13:00-17:00)
                        actualTimeSlotIds.addAll(TimeSlotDAO.getTimeSlotIdsForShift(2));
                        break;
                    case 3: // Cả ngày (8:00-17:00)
                        actualTimeSlotIds.addAll(TimeSlotDAO.getTimeSlotIdsForShift(3));
                        break;
                    default:
                        System.out.println("Unknown slot ID: " + slotId);
                        break;
                }
            }

            System.out.println("Converted to actual time slot IDs: " + actualTimeSlotIds);

            // Lấy thông tin TimeSlot từ các slot_id thực tế
            List<TimeSlot> availableSlots = TimeSlotDAO.getTimeSlotsByIds(actualTimeSlotIds);
            System.out.println("Available time slots: " + availableSlots.size());

            LocalDate today = LocalDate.now();
            LocalTime now = LocalTime.now();

            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < availableSlots.size(); i++) {
                TimeSlot slot = availableSlots.get(i);
                boolean isBooked = bookedSlotIds.contains(slot.getSlotId());
                // đã qua giờ khám
                // Sửa logic: slot đã qua nếu giờ bắt đầu < thời điểm hiện tại
                boolean isPast = localDate.equals(today) && slot.getStartTime().plusMinutes(10).isBefore(now);
                if (i > 0)
                    json.append(",");
                json.append("{");
                json.append("\"slotId\":").append(slot.getSlotId()).append(",");
                json.append("\"startTime\":\"").append(slot.getStartTime()).append("\",");
                json.append("\"endTime\":\"").append(slot.getEndTime()).append("\",");
                json.append("\"isBooked\":").append(isBooked).append(",");
                json.append("\"isPast\":").append(isPast);
                json.append("}");
            }
            json.append("]");

            System.out.println("JSON response: " + json.toString());
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            System.err.println("Error in handleGetTimeSlots: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}