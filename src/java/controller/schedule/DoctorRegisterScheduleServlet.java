/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.schedule;

import dao.DoctorScheduleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.DoctorSchedule;
import model.Doctors;

/**
 *
 * @author tranhongphuoc
 * 
 */
// @WebServlet(name = "DoctorRegisterScheduleServlet", urlPatterns =
// {"/DoctorRegisterScheduleServlet"})

@WebServlet(name = "DoctorRegisterScheduleServlet", urlPatterns = { "/DoctorRegisterScheduleServlet" })
public class DoctorRegisterScheduleServlet extends HttpServlet {
    private DoctorScheduleDAO scheduleDAO;

    // Danh sách ca làm việc cố định
    private static final List<Map<String, Object>> SHIFTS = new ArrayList<>();
    static {
        Map<String, Object> caSang = new HashMap<>();
        caSang.put("slotId", 1);
        caSang.put("name", "Sáng (8h-12h)");
        SHIFTS.add(caSang);
        Map<String, Object> caChieu = new HashMap<>();
        caChieu.put("slotId", 2);
        caChieu.put("name", "Chiều (13h-17h)");
        SHIFTS.add(caChieu);
        Map<String, Object> caCaNgay = new HashMap<>();
        caCaNgay.put("slotId", 3);
        caCaNgay.put("name", "Cả ngày (8h-17h)");
        SHIFTS.add(caCaNgay);
    }

    @Override
    public void init() throws ServletException {
        scheduleDAO = new DoctorScheduleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("shifts", SHIFTS);

        HttpSession session = request.getSession();
        Long doctorId = null;

        // Ưu tiên lấy từ đối tượng doctor trong session (đã set khi login)
        Doctors doc = (Doctors) session.getAttribute("doctor");
        if (doc != null) {
            doctorId = (long) doc.getDoctorId();
            session.setAttribute("doctor_id", doctorId);
        } else {
            String doctorIdParam = request.getParameter("doctor_id");
            if (doctorIdParam != null && !doctorIdParam.isEmpty()) {
                doctorId = Long.parseLong(doctorIdParam);
                session.setAttribute("doctor_id", doctorId);
            } else {
                Object doctorIdObj = session.getAttribute("doctor_id");
                if (doctorIdObj instanceof Integer) {
                    doctorId = ((Integer) doctorIdObj).longValue();
                } else if (doctorIdObj instanceof Long) {
                    doctorId = (Long) doctorIdObj;
                }
            }
        }
        System.out.println("doctor_id in session: " + doctorId);
        // ✅ LOGIC MỚI: DoctorSchedule chỉ lưu LỊCH NGHỈ, không cần tự động tạo lịch làm
        // việc
        // Mặc định bác sĩ làm việc tất cả ngày, chỉ nghỉ khi có bản ghi trong
        // DoctorSchedule
        if (doctorId != null) {
            System.out.println("💡 Bác sĩ " + doctorId + " mặc định làm việc tất cả ngày, trừ ngày có đăng ký nghỉ");
            // scheduleDAO.autoGenerateFullDaySchedules(doctorId); // ❌ DEPRECATED - đã xóa
        }
        List<DoctorSchedule> schedules = new ArrayList<>();
        List<DoctorSchedule> approvedSchedules = new ArrayList<>();
        List<DoctorSchedule> leavePending = new ArrayList<>();
        List<DoctorSchedule> leaveApproved = new ArrayList<>();
        List<DoctorSchedule> leaveRejected = new ArrayList<>();
        if (doctorId != null) {
            List<DoctorSchedule> rawSchedules = scheduleDAO.getSchedulesByDoctorId(doctorId);
            // Optimized: 1 day only 1 slot
            schedules = optimizeSchedules(rawSchedules);

            approvedSchedules = scheduleDAO.getApprovedSchedulesByDoctorId(doctorId);
            approvedSchedules.sort(
                    Comparator.comparing(DoctorSchedule::getWorkDate, Comparator.nullsLast(Comparator.naturalOrder())));

            // Lọc bỏ ca Sáng (1) và Chiều (2) nếu đã có ca Cả ngày (3) trong cùng một ngày
            // Đồng thời lọc bỏ TẤT CẢ các ca làm việc nếu đã có nghỉ phép (slotId == null)
            Map<Date, Boolean> hasFullDayMap = new HashMap<>();
            Map<Date, Boolean> hasLeaveMap = new HashMap<>();
            for (DoctorSchedule s : approvedSchedules) {
                if (s.getSlotId() != null && s.getSlotId() == 3) {
                    hasFullDayMap.put(s.getWorkDate(), true);
                }
                if (s.getSlotId() == null) {
                    hasLeaveMap.put(s.getWorkDate(), true);
                }
            }
            approvedSchedules.removeIf(s -> s.getSlotId() != null && (hasLeaveMap.containsKey(s.getWorkDate()) ||
                    ((s.getSlotId() == 1 || s.getSlotId() == 2) && hasFullDayMap.containsKey(s.getWorkDate()))));

            for (DoctorSchedule s : schedules) {
                if (s.getSlotId() == null) {
                    // Ngày nghỉ - phân loại theo trạng thái
                    String st = (s.getStatus() == null) ? "" : s.getStatus().trim().toLowerCase();
                    if (st.contains("reject") || st.equals("từ chối"))
                        leaveRejected.add(s);
                    else if (st.contains("approv") || st.equals("đã duyệt"))
                        leaveApproved.add(s);
                    else
                        leavePending.add(s);
                } else {
                    if (s.getSlotId() == 1)
                        s.setStatus("Sáng (8h-12h)");
                    else if (s.getSlotId() == 2)
                        s.setStatus("Chiều (13h-17h)");
                    else if (s.getSlotId() == 3)
                        s.setStatus("Cả ngày (8h-17h)");
                }
            }
        }
        request.setAttribute("schedules", schedules);
        request.setAttribute("approvedSchedules", approvedSchedules);
        request.setAttribute("leavePending", leavePending);
        request.setAttribute("leaveApproved", leaveApproved);
        request.setAttribute("leaveRejected", leaveRejected);

        String page = request.getParameter("page");
        if ("calendar".equals(page)) {
            request.getRequestDispatcher("/view/jsp/doctor/doctor_lichtrongthang.jsp").forward(request, response);
            return;
        }
        if ("confirmed".equals(page)) {
            request.getRequestDispatcher("/view/jsp/doctor/doctor_lichdaxacnhan.jsp").forward(request, response);
            return;
        }
        request.getRequestDispatcher("/view/jsp/doctor/doctor_dangkilich.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Long doctorId = null;
        HttpSession session = request.getSession();
        Doctors doc = (Doctors) session.getAttribute("doctor");

        if (doc != null) {
            doctorId = (long) doc.getDoctorId();
        } else {
            String doctorIdParam = request.getParameter("doctor_id");
            if (doctorIdParam != null)
                doctorId = Long.parseLong(doctorIdParam);
        }

        if (doctorId == null) {
            request.setAttribute("errorMessage", "Không nhận diện được bác sĩ. Vui lòng đăng nhập lại.");
            doGet(request, response);
            return;
        }

        Date workDate = Date.valueOf(request.getParameter("work_date"));
        String requestType = request.getParameter("request_type");

        // Lấy thêm tham số mới
        String leaveType = request.getParameter("leaveType");
        String reason = request.getParameter("reason");

        DoctorSchedule schedule = new DoctorSchedule();
        schedule.setDoctorId(doctorId);
        schedule.setWorkDate(workDate);

        // ✅ TỐI ƯU: 1 ngày chỉ 1 bản ghi (Dù là nghỉ hay làm)
        // Xóa sạch các bản ghi cũ trong ngày này của bác sĩ trước khi thêm yêu cầu mới
        DoctorScheduleDAO.deleteAllSchedulesByDate(doctorId, workDate);

        if ("leave".equals(requestType)) {
            // Đăng ký nghỉ phép cho bác sĩ fulltime
            schedule.setSlotId((Integer) null); // nghỉ phép
            schedule.setStatus("pending");
            System.out.println("[DEBUG] Đăng ký nghỉ phép cho doctorId=" + doctorId + ", workDate=" + workDate
                    + ", leaveType=" + leaveType + ", reason=" + reason);

        } else {
            // Đăng ký ca làm cho bác sĩ parttime
            String slotIdParam = request.getParameter("slot_id");
            if (slotIdParam != null && !slotIdParam.isEmpty()) {
                int slotId = Integer.parseInt(slotIdParam);
                schedule.setSlotId(slotId);
            } else {
                schedule.setSlotId((Integer) null);
            }
            schedule.setStatus("pending");

            System.out.println("[DEBUG] Đăng ký ca làm cho doctorId=" + doctorId + ", workDate=" + workDate
                    + ", slotId=" + schedule.getSlotId());
        }

        boolean success = scheduleDAO.addSchedule(schedule);
        if (success) {
            session.setAttribute("successMessage", "Đăng ký " + ("leave".equals(requestType) ? "nghỉ" : "lịch làm")
                    + " thành công cho ngày " + workDate);
        } else {
            session.setAttribute("errorMessage", "Đăng ký thất bại. Có thể do lỗi cơ sở dữ liệu hoặc lịch đã tồn tại.");
        }

        // Sau khi đăng ký xong, chuyển hướng về lại trang đăng ký và truyền doctor_id
        // để hiển thị lịch vừa đăng ký
        response.sendRedirect(request.getContextPath() + "/DoctorRegisterScheduleServlet?doctor_id=" + doctorId);
    }

    private List<DoctorSchedule> optimizeSchedules(List<DoctorSchedule> schedules) {
        if (schedules == null || schedules.isEmpty())
            return schedules;
        Map<java.sql.Date, DoctorSchedule> map = new java.util.LinkedHashMap<>();
        for (DoctorSchedule s : schedules) {
            java.sql.Date date = s.getWorkDate();
            if (date == null)
                continue;
            if (!map.containsKey(date)) {
                map.put(date, s);
            } else {
                DoctorSchedule existing = map.get(date);
                if (s.getSlotId() != null && s.getSlotId() == 3) {
                    map.put(date, s);
                } else if (existing.getSlotId() == null && s.getSlotId() != null) {
                    map.put(date, s);
                }
            }
        }
        return new ArrayList<>(map.values());
    }
}
