package controller.appointment;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.DoctorScheduleDAO;
import dao.PatientDAO;
import dao.ServiceDAO;
import dao.TimeSlotDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Appointment;
import model.Doctors;
import model.Patients;
import model.Service;
import model.TimeSlot;
import model.User;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "StaffBookingServlet", urlPatterns = { "/StaffBookingServlet" })
public class StaffBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        try {
            if ("search_patient".equals(action)) {
                handleSearchPatient(request, response);
            } else if ("get_timeslots".equals(action)) {
                handleGetTimeSlots(request, response);
            } else if ("get_doctors_by_service".equals(action)) {
                handleGetDoctorsByService(request, response);
            } else if ("get_detail".equals(action)) {
                handleGetAppointmentDetail(request, response);
            } else if ("confirm".equals(action)) {
                handleConfirmAppointment(request, response);
            } else if ("complete".equals(action)) {
                handleCompleteAppointment(request, response);
            } else if ("cancel".equals(action)) {
                handleCancelAppointment(request, response);
            } else {
                // Hiển thị trang chính
                loadInitialData(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/view/jsp/admin/staff_datlich.jsp").forward(request, response);
        }
    }

    private void handleConfirmAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            boolean success = AppointmentDAO.updateAppointmentStatus(appointmentId, "BOOKED");
            if (success) {
                request.setAttribute("success", "Đã xác nhận thanh toán thành công!");
            } else {
                request.setAttribute("error", "Lỗi: Không thể xác nhận lịch hẹn này.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
        }
        loadInitialData(request, response);
    }

    private void handleCompleteAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            boolean success = AppointmentDAO.updateAppointmentStatus(appointmentId, "COMPLETED");
            if (success) {
                request.setAttribute("success", "Đã đánh dấu lịch hẹn hoàn thành!");
            } else {
                request.setAttribute("error", "Lỗi: Không thể đánh dấu hoàn thành cho lịch hẹn này.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
        }
        loadInitialData(request, response);
    }

    private void handleCancelAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            boolean success = AppointmentDAO.updateAppointmentStatus(appointmentId, "CANCELLED");
            if (success) {
                request.setAttribute("success", "Đã hủy lịch hẹn thành công!");
            } else {
                request.setAttribute("error", "Lỗi: Không thể hủy lịch hẹn này.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
        }
        loadInitialData(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("book_appointment".equals(action)) {
                handleBookAppointment(request, response);
            } else if ("update_status".equals(action)) {
                handleUpdateAppointmentStatus(request, response);
            } else {
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi đặt lịch: " + e.getMessage());
            doGet(request, response);
        }
    }

    /**
     * Tải dữ liệu ban đầu cho trang
     */
    private void loadInitialData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy danh sách bác sĩ với error handling
            List<Doctors> doctors = new ArrayList<>();
            try {
                doctors = DoctorDAO.getAllDoctors();
            } catch (Exception e) {
                System.err.println("ERROR loading doctors: " + e.getMessage());
            }
            request.setAttribute("doctors", doctors);

            // Lấy danh sách dịch vụ với improved error handling
            List<Service> services = new ArrayList<>();
            try {
                ServiceDAO serviceDAO = new ServiceDAO();
                services = serviceDAO.getAllServices();
                if (services.isEmpty()) {
                    services = serviceDAO.getServicesByStatus("active");
                }
            } catch (Exception e) {
                System.err.println("ERROR loading services: " + e.getMessage());
            }
            request.setAttribute("services", services);

            // Lấy danh sách chuyên khoa với error handling
            List<String> specialties = new ArrayList<>();
            try {
                specialties = DoctorDAO.getAllSpecialties();
            } catch (Exception e) {
                System.err.println("ERROR loading specialties: " + e.getMessage());
            }
            request.setAttribute("specialties", specialties);

            // Lấy lịch hẹn và đếm số liệu
            int confirmedCount = 0;
            int pendingCount = 0;
            int completedCount = 0;
            try {
                Date today = new Date(System.currentTimeMillis());
                AppointmentDAO appointmentDAO = new AppointmentDAO();
                List<Appointment> todayAppsForCount = appointmentDAO.getAppointmentsByDate(today);

                for (Appointment ap : todayAppsForCount) {
                    if ("BOOKED".equals(ap.getStatus())) {
                        confirmedCount++;
                    } else if ("WAITING_PAYMENT".equals(ap.getStatus())) {
                        pendingCount++;
                    } else if ("COMPLETED".equals(ap.getStatus())) {
                        completedCount++;
                    }
                }
            } catch (Exception e) {
                System.err.println("Error loading today appointments counts: " + e.getMessage());
            }

            // Xử lý bộ lọc tìm kiếm
            String searchPatientName = request.getParameter("patientName");
            String searchAppointmentDate = request.getParameter("appointmentDate");
            String searchStatus = request.getParameter("status");
            String showAll = request.getParameter("showAll");

            // Mặc định là ngày hôm nay nếu không có tìm kiếm cụ thể và không phải yêu cầu "Hiện tất cả"
            if ((searchAppointmentDate == null || searchAppointmentDate.isEmpty()) 
                && (searchPatientName == null || searchPatientName.isEmpty()) 
                && (searchStatus == null || searchStatus.isEmpty())
                && !"true".equals(showAll)) {
                searchAppointmentDate = java.time.LocalDate.now().toString();
            }

            request.setAttribute("searchPatientName", searchPatientName);
            request.setAttribute("searchAppointmentDate", searchAppointmentDate);
            request.setAttribute("searchStatus", searchStatus);
            request.setAttribute("showAll", showAll);

            List<Appointment> displayedAppointments = new ArrayList<>();
            try {
                displayedAppointments = AppointmentDAO.searchAppointments(searchPatientName, searchAppointmentDate,
                        searchStatus);
            } catch (Exception e) {
                System.err.println("Error loading displayed appointments: " + e.getMessage());
            }
            request.setAttribute("todayAppointments", displayedAppointments); // Vẫn dùng biến này để khỏi sửa JSP nhiều
            request.setAttribute("confirmedCount", confirmedCount);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("completedCount", completedCount);

            // Forward to JSP
            request.getRequestDispatcher("/view/jsp/admin/staff_datlich.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("CRITICAL ERROR in loadInitialData: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/view/jsp/admin/staff_datlich.jsp").forward(request, response);
        }
    }

    /**
     * Xử lý tìm kiếm bệnh nhân
     */
    private void handleSearchPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String phone = request.getParameter("phone");
        String name = request.getParameter("name");
        String format = request.getParameter("format");

        PatientDAO patientDAO = new PatientDAO();
        List<Patients> patients = new ArrayList<>();

        try {
            if (phone != null && !phone.trim().isEmpty()) {
                patients = patientDAO.searchByPhone(phone.trim());
            } else if (name != null && !name.trim().isEmpty()) {
                patients = patientDAO.searchByName(name.trim());
            }

            // Nếu yêu cầu JSON format
            if ("json".equals(format)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                StringBuilder json = new StringBuilder();
                json.append("[");
                for (int i = 0; i < patients.size(); i++) {
                    Patients patient = patients.get(i);
                    if (i > 0)
                        json.append(",");
                    json.append("{");
                    json.append("\"patientId\":").append(patient.getPatientId()).append(",");
                    json.append("\"fullName\":\"").append(patient.getFullName() != null ? patient.getFullName() : "")
                            .append("\",");
                    json.append("\"phone\":\"").append(patient.getPhone() != null ? patient.getPhone() : "")
                            .append("\",");
                    json.append("\"dateOfBirth\":\"")
                            .append(patient.getDateOfBirth() != null ? patient.getDateOfBirth().toString() : "")
                            .append("\",");
                    json.append("\"gender\":\"").append(patient.getGender() != null ? patient.getGender() : "")
                            .append("\"");
                    json.append("}");
                }
                json.append("]");

                response.getWriter().write(json.toString());
                return;
            } else {
                // Trả về HTML với dữ liệu JSON embedded
                request.setAttribute("patients", patients);

                // Tạo JSON data để embed vào HTML
                StringBuilder jsonData = new StringBuilder();
                jsonData.append("[");
                for (int i = 0; i < patients.size(); i++) {
                    Patients patient = patients.get(i);
                    if (i > 0)
                        jsonData.append(",");
                    jsonData.append("{");
                    jsonData.append("\"patientId\":").append(patient.getPatientId()).append(",");
                    jsonData.append("\"fullName\":\"")
                            .append(patient.getFullName() != null ? patient.getFullName().replace("\"", "\\\"") : "")
                            .append("\",");
                    jsonData.append("\"phone\":\"").append(patient.getPhone() != null ? patient.getPhone() : "")
                            .append("\",");
                    jsonData.append("\"dateOfBirth\":\"")
                            .append(patient.getDateOfBirth() != null ? patient.getDateOfBirth().toString() : "")
                            .append("\",");
                    jsonData.append("\"gender\":\"").append(patient.getGender() != null ? patient.getGender() : "")
                            .append("\"");
                    jsonData.append("}");
                }
                jsonData.append("]");

                request.setAttribute("patientsJson", jsonData.toString());
                loadInitialData(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            if ("json".equals(format)) {
                response.setContentType("application/json");
                response.getWriter().write("[]");
            } else {
                request.setAttribute("error", "Lỗi tìm kiếm: " + e.getMessage());
                loadInitialData(request, response);
            }
        }
    }

    /**
     * Lấy danh sách khung giờ trống của bác sĩ
     */
    private void handleGetTimeSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String workDate = request.getParameter("workDate");

            System.out.println("Getting timeslots for doctorId: " + doctorId + ", workDate: " + workDate);

            // Lấy danh sách slot có thể đặt lịch
            List<Integer> approvedSlotIds = DoctorScheduleDAO.getAvailableSlotIdsByDoctorAndDate(doctorId,
                    workDate);
            System.out.println("✅ Available slot IDs (NEW LOGIC): " + approvedSlotIds);

            // Convert doctor schedule slot IDs to actual time slot IDs
            // slotId 1/2/3 là "ca" (shift) -> map ra slot_id thật theo start_time/end_time
            // trong TimeSlot table
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

            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < availableSlots.size(); i++) {
                TimeSlot slot = availableSlots.get(i);
                if (i > 0)
                    json.append(",");
                json.append("{");
                json.append("\"slotId\":").append(slot.getSlotId()).append(",");
                json.append("\"startTime\":\"").append(slot.getStartTime()).append("\",");
                json.append("\"endTime\":\"").append(slot.getEndTime()).append("\"");
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
     * Xử lý đặt lịch hẹn mới
     */
    private void handleBookAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            request.setAttribute("error", "Phiên đăng nhập đã hết hạn");
            doGet(request, response);
            return;
        }
        try {
            // Lấy thông tin từ form
            String bookingFor = request.getParameter("bookingFor");
            if ("relative".equals(bookingFor)) {
                // Gọi DAO riêng cho người thân (RelativesAppointmentDAO)
                // ... logic đặt lịch cho người thân ...
            } else {
                int patientId = Integer.parseInt(request.getParameter("patientId"));
                int doctorId = Integer.parseInt(request.getParameter("doctorId"));
                int slotId = Integer.parseInt(request.getParameter("slotId"));
                Date workDate = Date.valueOf(request.getParameter("workDate"));
                String reason = request.getParameter("reason");
                String serviceIdStr = request.getParameter("serviceId");
                int serviceId = (serviceIdStr != null && !serviceIdStr.isEmpty()) ? Integer.parseInt(serviceIdStr) : 0;

                Appointment appointment = new Appointment();
                appointment.setPatientId(patientId);
                appointment.setDoctorId(doctorId);
                appointment.setSlotId(slotId);
                appointment.setWorkDate(workDate.toLocalDate());
                appointment.setReason(reason);
                appointment.setStatus("BOOKED");
                if (serviceId > 0) {
                    appointment.setServiceId(serviceId);
                }

                AppointmentDAO appointmentDAO = new AppointmentDAO();
                int appointmentId = appointmentDAO.createAppointment(appointment);

                if (appointmentId > 0) {
                    request.setAttribute("successMessage", "Đặt lịch hẹn thành công!");
                } else {
                    request.setAttribute("error", "Lỗi: Không thể đặt lịch hẹn mới.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
        doGet(request, response);
    }

    /**
     * Lấy chi tiết appointment
     */
    private void handleGetAppointmentDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String appointmentIdStr = request.getParameter("appointmentId");
            if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing appointmentId\"}");
                return;
            }

            int appointmentId = Integer.parseInt(appointmentIdStr);

            // Lấy chi tiết appointment từ database
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

            if (appointment == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Appointment not found\"}");
                return;
            }

            // Tạo JSON response
            StringBuilder json = new StringBuilder();
            json.append("{\"success\": true, \"appointment\": {");
            json.append("\"appointmentId\": ").append(appointment.getAppointmentId()).append(",");
            json.append("\"patientName\": \"")
                    .append(appointment.getPatientName() != null ? appointment.getPatientName() : "").append("\",");
            json.append("\"patientPhone\": \"")
                    .append(appointment.getPatientPhone() != null ? appointment.getPatientPhone() : "").append("\",");
            json.append("\"doctorName\": \"")
                    .append(appointment.getDoctorName() != null ? appointment.getDoctorName() : "").append("\",");
            json.append("\"serviceName\": \"")
                    .append(appointment.getServiceName() != null ? appointment.getServiceName() : "Chưa có")
                    .append("\",");
            json.append("\"workDate\": \"")
                    .append(appointment.getWorkDate() != null ? appointment.getWorkDate().toString() : "")
                    .append("\",");
            json.append("\"startTime\": \"").append(appointment.getFormattedStartTime()).append("\",");
            json.append("\"endTime\": \"").append(appointment.getFormattedEndTime()).append("\",");
            json.append("\"status\": \"").append(appointment.getStatus() != null ? appointment.getStatus() : "")
                    .append("\",");
            json.append("\"reason\": \"")
                    .append(appointment.getReason() != null ? appointment.getReason().replace("\"", "\\\"") : "")
                    .append("\"");
            json.append("}}");

            response.getWriter().write(json.toString());

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid appointmentId format\"}");
        } catch (Exception e) {
            System.err.println("Error getting appointment detail: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Internal server error\"}");
        }
    }

    /**
     * Cập nhật trạng thái appointment
     */
    private void handleUpdateAppointmentStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String appointmentIdStr = request.getParameter("appointmentId");
            String newStatus = request.getParameter("status");

            if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing appointmentId\"}");
                return;
            }

            if (newStatus == null || newStatus.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing status\"}");
                return;
            }

            int appointmentId = Integer.parseInt(appointmentIdStr);

            // Cập nhật trạng thái trong database
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, newStatus);

            if (success) {
                System.out
                        .println("✅ CẬP NHẬT TRẠNG THÁI THÀNH CÔNG: Appointment " + appointmentId + " → " + newStatus);
                response.getWriter().write("{\"success\": true, \"message\": \"Status updated successfully\"}");
            } else {
                System.err.println("❌ THẤT BẠI: Không thể cập nhật trạng thái cho appointment " + appointmentId);
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to update status\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid appointmentId format\"}");
        } catch (Exception e) {
            System.err.println("Error updating appointment status: " + e.getMessage());
            e.printStackTrace();
            response.getWriter()
                    .write("{\"success\": false, \"message\": \"Internal server error: " + e.getMessage() + "\"}");
        }
    }

    /**
     * Lấy danh sách bác sĩ theo dịch vụ
     */
    private void handleGetDoctorsByService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            List<Doctors> doctors = DoctorDAO.getDoctorsByServiceId(serviceId);
            
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < doctors.size(); i++) {
                Doctors d = doctors.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"doctorId\":").append(d.getDoctor_id()).append(",");
                json.append("\"fullName\":\"").append(d.getFull_name().replace("\"", "\\\"")).append("\",");
                json.append("\"specialty\":\"").append(d.getSpecialty() != null ? d.getSpecialty().replace("\"", "\\\"") : "").append("\"");
                json.append("}");
            }
            json.append("]");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }
}