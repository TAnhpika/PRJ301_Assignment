package controller.schedule;

import dao.StaffDAO;
import dao.StaffScheduleDAO;
import dao.TimeSlotDAO;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.ColoredLogger;
import model.Staff;
import model.StaffSchedule;
import model.TimeSlot;
import model.User;

/**
 * Servlet xử lý lịch làm việc của nhân viên
 * - Fulltime: Đăng ký nghỉ phép (tối đa 6 ngày/tháng)
 * - Parttime: Đăng ký ca làm việc (như bác sĩ)
 */
@WebServlet(name = "StaffScheduleServlet", urlPatterns = {"/StaffScheduleServlet"})
public class StaffScheduleServlet extends HttpServlet {
    
    private StaffDAO staffDAO;
    private StaffScheduleDAO scheduleDAO;
    private TimeSlotDAO timeSlotDAO;
    
    @Override
    public void init() {
        staffDAO = new StaffDAO();
        scheduleDAO = new StaffScheduleDAO();
        timeSlotDAO = new TimeSlotDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
            return;
        }
        Staff staff = null;
        try {
            staff = staffDAO.getStaffByUserId(user.getId());
        } catch (SQLException ex) {
            Logger.getLogger(StaffScheduleServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (staff == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        // Lấy tham số tháng/năm từ request hoặc mặc định là tháng/năm hiện tại
        String monthStr = request.getParameter("month");
        String yearStr = request.getParameter("year");
        java.time.LocalDate now = java.time.LocalDate.now();
        int month = (monthStr != null && !monthStr.isEmpty()) ? Integer.parseInt(monthStr) : now.getMonthValue();
        int year = (yearStr != null && !yearStr.isEmpty()) ? Integer.parseInt(yearStr) : now.getYear();
        // Lấy lịch sử nghỉ phép (chỉ lấy request_type='leave')
        List<StaffSchedule> leaveRequests = scheduleDAO.getStaffSchedulesByMonth((int) staff.getStaffId(), month, year);
        // Lọc ra các yêu cầu nghỉ phép
        List<StaffSchedule> leaveHistory = new java.util.ArrayList<>();
        for (StaffSchedule s : leaveRequests) {
            if (s.getSlotId() == null) {
                leaveHistory.add(s);
            }
        }
        request.setAttribute("scheduleRequests", leaveHistory);
        request.setAttribute("employmentType", staff.getEmploymentType());
        request.setAttribute("currentMonth", month);
        request.setAttribute("currentYear", year);
        if ("fulltime".equals(staff.getEmploymentType())) {
            int usedLeaveDays = scheduleDAO.getApprovedLeaveDaysInMonth((int) staff.getStaffId(), month, year);
            request.setAttribute("usedDays", usedLeaveDays);
            request.setAttribute("maxDays", 6);
            request.setAttribute("remainingDays", 6 - usedLeaveDays);
            request.getRequestDispatcher("jsp/staff/staff_xinnghi.jsp").forward(request, response);
        } else {
            // Nếu là parttime thì chỉ lấy 3 ca chính (slotId 1,2,3)
            List<TimeSlot> timeSlots = timeSlotDAO.getMainTimeSlots();
            request.setAttribute("timeSlots", timeSlots);
            request.getRequestDispatcher("jsp/staff/staff_dangkilich.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        ColoredLogger.logInfo("StaffScheduleServlet", "🚀 doPost() method called!");
        ColoredLogger.logInfo("StaffScheduleServlet", "📝 Request method: " + request.getMethod());
        ColoredLogger.logInfo("StaffScheduleServlet", "🌐 Request URI: " + request.getRequestURI());
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
            return;
        }
        
        Staff staff = null;
        try {
            staff = staffDAO.getStaffByUserId(user.getId());
        } catch (SQLException ex) {
            Logger.getLogger(StaffScheduleServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (staff == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String workDateStr = request.getParameter("workDate");
        ColoredLogger.logInfo("StaffScheduleServlet", "Received workDate parameter: '" + workDateStr + "'");
        
        // Validate date parameter
        if (workDateStr == null || workDateStr.trim().isEmpty()) {
            ColoredLogger.logError("StaffScheduleServlet", "workDate parameter is null or empty");
            response.sendRedirect("StaffRegisterSecheduleServlet?error=invalid_date");
            return;
        }
        
        Date workDate;
        try {
            workDate = Date.valueOf(workDateStr.trim());
            ColoredLogger.logSuccess("StaffScheduleServlet", "Successfully parsed date: " + workDate);
        } catch (IllegalArgumentException e) {
            ColoredLogger.logError("StaffScheduleServlet", "Invalid date format: " + workDateStr + " - " + e.getMessage());
            response.sendRedirect("StaffRegisterSecheduleServlet?error=invalid_date_format");
            return;
        }
        
        if ("fulltime".equals(staff.getEmploymentType())) {
            handleFulltimeStaff(request, response, staff, workDate);
        } else {
            handleParttimeStaff(request, response, staff, workDate);
        }
    }
    
    private void handleFulltimeStaff(HttpServletRequest request, HttpServletResponse response, 
            Staff staff, Date workDate) throws IOException {
        String reason = request.getParameter("reason");
        int month = workDate.toLocalDate().getMonthValue();
        int year = workDate.toLocalDate().getYear();
        // Kiểm tra số ngày nghỉ còn lại
        if (!scheduleDAO.canTakeMoreLeave((int) staff.getStaffId(), 
                month, 
                year)) {
            response.sendRedirect("StaffScheduleServlet?month=" + month + "&year=" + year + "&error=exceeded_leave_days");
            return;
        }
        // Tạo yêu cầu nghỉ phép
        StaffSchedule schedule = new StaffSchedule();
        schedule.setStaffId((int) staff.getStaffId());
        schedule.setWorkDate(workDate);
        schedule.setSlotId(null); // Nghỉ cả ngày
        schedule.setStatus("pending");
        schedule.setReason(reason);
        if (scheduleDAO.addScheduleRequest(schedule)) {
            response.sendRedirect("StaffScheduleServlet?month=" + month + "&year=" + year + "&success=leave_requested");
        } else {
            response.sendRedirect("StaffScheduleServlet?month=" + month + "&year=" + year + "&error=request_failed");
        }
    }
    
    private void handleParttimeStaff(HttpServletRequest request, HttpServletResponse response, 
            Staff staff, Date workDate) throws IOException {
        String slotIdStr = request.getParameter("slotId");
        if (slotIdStr == null || slotIdStr.isEmpty()) {
            int month = workDate.toLocalDate().getMonthValue();
            int year = workDate.toLocalDate().getYear();
            response.sendRedirect("StaffScheduleServlet?month=" + month + "&year=" + year + "&error=invalid_slot");
            return;
        }
        int slotId = Integer.parseInt(slotIdStr);
        int month = workDate.toLocalDate().getMonthValue();
        int year = workDate.toLocalDate().getYear();
        // Kiểm tra trùng lịch
        if (scheduleDAO.isSlotBooked((int) staff.getStaffId(), workDate, slotId)) {
            response.sendRedirect("StaffScheduleServlet?month=" + month + "&year=" + year + "&error=slot_already_booked");
            return;
        }
        // Tạo yêu cầu đăng ký ca làm việc
        StaffSchedule schedule = new StaffSchedule();
        schedule.setStaffId((int) staff.getStaffId());
        schedule.setWorkDate(workDate);
        schedule.setSlotId(slotId);
        schedule.setStatus("pending");
        if (scheduleDAO.addScheduleRequest(schedule)) {
            response.sendRedirect("StaffScheduleServlet?month=" + month + "&year=" + year + "&success=shift_requested");
        } else {
            response.sendRedirect("StaffScheduleServlet?month=" + month + "&year=" + year + "&error=request_failed");
        }
    }
    
    @Override
    public void destroy() {
        if (staffDAO != null) {
            staffDAO = null;
        }
        if (scheduleDAO != null) {
            scheduleDAO.close();
        }
        if (timeSlotDAO != null) {
            timeSlotDAO = null;
        }
    }
} 