package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.DoctorSchedule;
import model.TimeSlot;
import util.DBContext;
import java.time.LocalTime;
import java.sql.Time;

public class DoctorScheduleDAO {

    // Khai báo các hằng số SQL
    private static final String GET_ALL = "SELECT * FROM DoctorSchedule";
    private static final String GET_BY_ID = "SELECT * FROM DoctorSchedule WHERE schedule_id = ?";
    private static final String GET_BY_DOCTOR_ID = "SELECT * FROM DoctorSchedule WHERE doctor_id = ?";
    private static final String INSERT = "INSERT INTO DoctorSchedule (doctor_id, work_date, slot_id, status) VALUES (?, ?, ?, ?)";
    private static final String UPDATE_STATUS = "UPDATE DoctorSchedule SET status = ? WHERE schedule_id = ?";
    private static final String DELETE = "DELETE FROM DoctorSchedule WHERE schedule_id = ?";
    private static final String GET_PENDING = "SELECT * FROM DoctorSchedule WHERE status = 'pending' ORDER BY work_date ASC";
    private static final String GET_APPROVED_BY_DOCTOR = "SELECT * FROM DoctorSchedule WHERE doctor_id = ? AND status = 'approved'";
    
    private static final String GET_AVAILABLE_BY_DOCTOR = 
        "SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id, " +
        "ts.start_time, ts.end_time, ds.status " +
        "FROM DoctorSchedule ds " +
        "JOIN TimeSlot ts ON ds.slot_id = ts.slot_id " +
        "WHERE ds.doctor_id = ? " +
        "AND ds.status = 'approved' " +
        "AND ds.work_date >= CONVERT(date, GETDATE()) " +
        "AND NOT EXISTS (" +
        "    SELECT 1 FROM Appointment ap " +
        "    WHERE ap.doctor_id = ds.doctor_id " +
        "      AND ap.work_date = ds.work_date " +
        "      AND ap.slot_id = ds.slot_id " +
        "      AND ap.status NOT IN ('cancelled', 'rejected')" +
        ") " +
        "ORDER BY ds.work_date ASC, ts.start_time ASC";
        
    private static final String GET_AVAILABLE_BY_DOCTOR_DATE = 
        "SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id, " +
        "ts.start_time, ts.end_time, ds.status " +
        "FROM DoctorSchedule ds " +
        "JOIN TimeSlot ts ON ds.slot_id = ts.slot_id " +
        "WHERE ds.doctor_id = ? " +
        "AND ds.work_date = ? " +
        "AND ds.work_date >= CONVERT(date, GETDATE()) " +
        "AND ds.status = 'approved' " +
        "AND NOT EXISTS (" +
        "    SELECT 1 FROM Appointment ap " +
        "    WHERE ap.doctor_id = ds.doctor_id " +
        "      AND ap.work_date = ds.work_date " +
        "      AND ap.slot_id = ds.slot_id " +
        "      AND ap.status IN ('BOOKED', 'Đang chờ khám')" +
        ") " +
        "ORDER BY ts.start_time ASC";
        
    private static final String GET_DOCTORS_BY_DATE = 
        "SELECT d.doctor_id, d.full_name, d.specialty, d.phone, d.status, d.avatar " +
        "FROM Doctors d JOIN DoctorSchedule ds ON d.doctor_id = ds.doctor_id " +
        "WHERE ds.work_date = ? AND ds.status = 'approved'";
        
    private static final String GET_WORK_DATES_BY_DOCTOR = 
        "SELECT DISTINCT work_date FROM DoctorSchedule " +
        "WHERE doctor_id = ? AND status = 'approved' " +
        "ORDER BY work_date ASC";
        
    private static final String GET_APPROVED_SLOTS_BY_DOCTOR_DATE = 
        "SELECT DISTINCT ds.slot_id, ds.status " +
        "FROM DoctorSchedule ds " +
        "WHERE ds.doctor_id = ? " +
        "AND ds.work_date = ? " +
        "AND ds.status = 'approved' " +
        "ORDER BY ds.slot_id ASC";

    // Khai báo biến instance


    public DoctorScheduleDAO() {}

    // CRUD Methods cơ bản
    public static List<DoctorSchedule> getAll() throws SQLException {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<DoctorSchedule> schedules = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_ALL);
                rs = ps.executeQuery();
                while (rs.next()) {
                    DoctorSchedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return schedules;
    }

    public static DoctorSchedule getScheduleById(int id) throws SQLException {
        DoctorSchedule schedule = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_BY_ID);
                ps.setInt(1, id);
                rs = ps.executeQuery();
                if (rs.next()) {
                    schedule = mapResultSetToSchedule(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        return schedule;
    }

    // Khi insert lịch nghỉ phép, LUÔN set status = 'pending'
    public static boolean addSchedule(DoctorSchedule schedule) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(INSERT);
                ps.setLong(1, schedule.getDoctorId());
                ps.setDate(2, schedule.getWorkDate());
                if (schedule.getSlotId() == null) {
                    ps.setNull(3, java.sql.Types.INTEGER);
                } else {
                    ps.setInt(3, schedule.getSlotId());
                }
                ps.setString(4, "pending"); // CHUẨN HÓA: luôn là 'pending'
                int result = ps.executeUpdate();
                System.out.println("Insert result: " + result);
                return result > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return false;
    }

    public static boolean updateScheduleStatus(int scheduleId, String status) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(UPDATE_STATUS);
                ps.setString(1, status);
                ps.setInt(2, scheduleId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return false;
    }

    public static boolean deleteSchedule(int scheduleId) throws SQLException {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(DELETE);
                ps.setInt(1, scheduleId);
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return false;
    }

    // Search và Filter Methods
    public static List<DoctorSchedule> getSchedulesByDoctorId(long doctorId) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<DoctorSchedule> schedules = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_BY_DOCTOR_ID);
                ps.setLong(1, doctorId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    DoctorSchedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return schedules;
    }

    public static List<DoctorSchedule> getAllPendingSchedules() {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<DoctorSchedule> schedules = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_PENDING);
                rs = ps.executeQuery();
                while (rs.next()) {
                    DoctorSchedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return schedules;
    }
    
    /**
     * ✅ HÀM MỚI: Lấy tất cả lịch chờ phê duyệt (bao gồm cả nghỉ phép)
     * (CHỈ LẤY status = 'pending')
     */
    public static List<DoctorSchedule> getAllPendingSchedulesIncludingLeaves() {
        List<DoctorSchedule> schedules = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                // SQL lấy tất cả lịch chờ phê duyệt, chỉ lấy status = 'pending'
                String sql = "SELECT * FROM DoctorSchedule WHERE status = 'pending' ORDER BY work_date ASC, doctor_id ASC";
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                while (rs.next()) {
                    DoctorSchedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
                System.out.println("📋 [MANAGER] Found " + schedules.size() + " pending schedules");
                for (DoctorSchedule s : schedules) {
                    System.out.println("   - Doctor " + s.getDoctorId() + " | Date: " + s.getWorkDate() + 
                                     " | Status: " + s.getStatus() + " | Slot: " + s.getSlotId());
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllPendingSchedulesIncludingLeaves: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        return schedules;
    }

    public static List<DoctorSchedule> getApprovedSchedulesByDoctorId(long doctorId) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<DoctorSchedule> schedules = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_APPROVED_BY_DOCTOR);
                ps.setLong(1, doctorId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    DoctorSchedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return schedules;
    }

    // Static Methods cho các truy vấn phức tạp
    public static List<DoctorSchedule> getAvailableSchedulesByDoctor(int doctorId) {
        List<DoctorSchedule> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(GET_AVAILABLE_BY_DOCTOR);
            ps.setInt(1, doctorId);
            rs = ps.executeQuery();

            while (rs.next()) {
                try {
                    DoctorSchedule ds = mapResultSetToScheduleWithTimeSlot(rs);
                    list.add(ds);
                } catch (SQLException e) {
                    System.err.println("Lỗi khi đọc dữ liệu từ ResultSet: " + e.getMessage());
                    continue;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi truy vấn lịch khám: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        return list;
    }

    public static List<DoctorSchedule> getAvailableSchedules(int doctorId, String workDate) {
        List<DoctorSchedule> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(GET_AVAILABLE_BY_DOCTOR_DATE);
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            rs = ps.executeQuery();

            while (rs.next()) {
                try {
                    DoctorSchedule ds = new DoctorSchedule();
                    ds.setScheduleId(rs.getInt("schedule_id"));
                    ds.setDoctorId(rs.getLong("doctor_id"));
                    ds.setWorkDate(rs.getDate("work_date"));
                    ds.setSlotId(rs.getInt("slot_id"));
                    
                    Time startTime = rs.getTime("start_time");
                    LocalTime localStartTime = startTime.toLocalTime();
                    LocalTime localEndTime = localStartTime.plusMinutes(30);
                    
                    ds.setStartTime(Time.valueOf(localStartTime));
                    ds.setEndTime(Time.valueOf(localEndTime));
                    ds.setStatus(rs.getString("status"));

                    TimeSlot ts = new TimeSlot();
                    ts.setStartTime(localStartTime);
                    ts.setEndTime(localEndTime);
                    ds.setTimeSlot(ts);

                    list.add(ds);
                } catch (SQLException e) {
                    System.err.println("Lỗi khi đọc dữ liệu từ ResultSet: " + e.getMessage());
                    continue;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi truy vấn lịch khám: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        return list;
    }

    public static List<model.Doctors> getDoctorsByWorkDate(String workDate) {
        List<model.Doctors> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(GET_DOCTORS_BY_DATE);
            ps.setDate(1, java.sql.Date.valueOf(workDate));
            rs = ps.executeQuery();
            while (rs.next()) {
                model.Doctors doctor = new model.Doctors();
                doctor.setDoctor_id(rs.getLong("doctor_id"));
                doctor.setFull_name(rs.getString("full_name"));
                doctor.setSpecialty(rs.getString("specialty"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setStatus(rs.getString("status"));
                doctor.setAvatar(rs.getString("avatar"));
                list.add(doctor);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return list;
    }

    public static List<String> getWorkDatesByDoctorId(int doctorId) {
        List<String> workDates = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(GET_WORK_DATES_BY_DOCTOR);
            ps.setInt(1, doctorId);
            rs = ps.executeQuery();
            while (rs.next()) {
                workDates.add(rs.getDate("work_date").toString());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return workDates;
    }

    /**
     * ✅ HÀM MỚI: Lấy danh sách slot khả dụng theo logic mới
     * Logic: Nếu bác sĩ KHÔNG nghỉ phép thì trả về tất cả 3 ca (1,2,3), nếu nghỉ thì trả về rỗng
     */
    public static List<Integer> getAvailableSlotIdsByDoctorAndDate(int doctorId, String workDate) {
        List<Integer> availableSlots = new ArrayList<>();
        
        System.out.println("🔍 [NEW LOGIC] getAvailableSlotIdsByDoctorAndDate");
        System.out.println("   - Doctor ID: " + doctorId);
        System.out.println("   - Work Date: " + workDate);
        
        // Kiểm tra bác sĩ có đang làm việc không (không nghỉ phép)
        boolean isWorking = isDoctorWorkingOnDate(doctorId, workDate);
        
        if (isWorking) {
            // Bác sĩ làm việc -> trả về tất cả 3 ca
            availableSlots.add(1); // Ca sáng
            availableSlots.add(2); // Ca chiều  
            availableSlots.add(3); // Ca cả ngày
            System.out.println("   ✅ Bác sĩ đang làm việc -> trả về tất cả 3 ca: " + availableSlots);
        } else {
            // Bác sĩ nghỉ phép -> không có ca nào
            System.out.println("   ❌ Bác sĩ đang nghỉ phép -> không có ca nào");
        }
        
        return availableSlots;
    }

    /**
     * ✅ HÀM MỚI: Lấy ngày làm việc của bác sĩ bằng cách loại bỏ ngày nghỉ
     * Logic đúng: Bác sĩ làm việc tất cả ngày TRỪ ngày có trong DoctorSchedule (ngày nghỉ)
     */
    public static List<String> getWorkDatesExcludingLeaves(int doctorId, int daysAhead) {
        List<String> workDates = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                // Lấy danh sách ngày nghỉ của bác sĩ
                String leaveSql = "SELECT DISTINCT work_date FROM DoctorSchedule " +
                                "WHERE doctor_id = ? " +
                                "AND work_date >= CONVERT(date, GETDATE()) " +
                                "AND work_date <= DATEADD(day, ?, CONVERT(date, GETDATE())) " +
                                "AND (slot_id IS NULL OR status LIKE N'%nghỉ%' OR status LIKE N'%leave%') " +
                                "ORDER BY work_date ASC";
                
                ps = conn.prepareStatement(leaveSql);
                ps.setInt(1, doctorId);
                ps.setInt(2, daysAhead);
                rs = ps.executeQuery();
                
                // Tạo set để lưu ngày nghỉ
                java.util.Set<String> leaveDates = new java.util.HashSet<>();
                while (rs.next()) {
                    java.sql.Date date = rs.getDate("work_date");
                    if (date != null) {
                        leaveDates.add(date.toString());
                    }
                }
                
                // Tạo 14 ngày tiếp theo từ ngày hiện tại
                java.time.LocalDate currentDate = java.time.LocalDate.now();
                for (int i = 0; i < daysAhead; i++) {
                    java.time.LocalDate checkDate = currentDate.plusDays(i);
                    String dateStr = checkDate.toString();
                    
                    // Chỉ thêm vào danh sách nếu không phải ngày nghỉ
                    if (!leaveDates.contains(dateStr)) {
                        workDates.add(dateStr);
                    }
                }
                
                System.out.println("📅 [AUTOMATION] Generated work dates for doctor " + doctorId + ":");
                System.out.println("   - Total days generated: " + daysAhead);
                System.out.println("   - Leave dates found: " + leaveDates.size());
                System.out.println("   - Available work dates: " + workDates.size());
                System.out.println("   - Work dates: " + workDates);
            }
        } catch (SQLException e) {
            System.err.println("Error in getWorkDatesExcludingLeaves: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        
        return workDates;
    }

    /**
     * ✅ HÀM MỚI: Lấy danh sách ngày NGHỈ của bác sĩ
     */
    public static List<String> getLeaveDatasByDoctorId(int doctorId) {
        List<String> leaveDates = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        // SQL lấy ngày nghỉ (slot_id = null hoặc status chứa "nghỉ")
        String sql = "SELECT DISTINCT work_date FROM DoctorSchedule " +
                    "WHERE doctor_id = ? " +
                    "AND (slot_id IS NULL OR status LIKE N'%nghỉ%' OR status LIKE N'%leave%') " +
                    "ORDER BY work_date ASC";
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            rs = ps.executeQuery();
            while (rs.next()) {
                leaveDates.add(rs.getDate("work_date").toString());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return leaveDates;
    }

    /**
     * ✅ HÀM MỚI: Kiểm tra bác sĩ có làm việc vào ngày cụ thể không
     * @param doctorId ID bác sĩ
     * @param workDate Ngày cần kiểm tra (format: yyyy-MM-dd)
     * @return true nếu bác sĩ làm việc (không nghỉ), false nếu nghỉ
     */
    public static boolean isDoctorWorkingOnDate(int doctorId, String workDate) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        // Kiểm tra có bản ghi nghỉ phép trong ngày đó không
        String sql = "SELECT COUNT(*) FROM DoctorSchedule " +
                    "WHERE doctor_id = ? AND work_date = ? " +
                    "AND (slot_id IS NULL OR status LIKE N'%nghỉ%' OR status LIKE N'%leave%')";
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            rs = ps.executeQuery();
            
            if (rs.next()) {
                int leaveCount = rs.getInt(1);
                return leaveCount == 0; // Không có bản ghi nghỉ = đang làm việc
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        
        return true; // Mặc định là đang làm việc nếu không có dữ liệu
    }

    /**
     * ✅ FIXED: Kiểm tra đã có lịch nghỉ cho bác sĩ, ngày chưa 
     * (Hàm này chỉ để kiểm tra tránh trùng lặp khi thêm nghỉ phép)
     */
    public static boolean existsSchedule(long doctorId, java.sql.Date workDate, int slotId) {
        Connection conn = null; PreparedStatement ps = null;
        String sql = "SELECT COUNT(*) FROM DoctorSchedule WHERE doctor_id = ? AND work_date = ? AND slot_id = ?";
        try {
            ps = conn.prepareStatement(sql);
            ps.setLong(1, doctorId);
            ps.setDate(2, workDate);
            ps.setInt(3, slotId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Utility Methods
    private static DoctorSchedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        DoctorSchedule schedule = new DoctorSchedule();
        schedule.setScheduleId(rs.getInt("schedule_id"));
        schedule.setDoctorId(rs.getLong("doctor_id"));
        schedule.setWorkDate(rs.getDate("work_date"));
        schedule.setSlotId(rs.getInt("slot_id"));
        schedule.setStatus(rs.getString("status"));
        return schedule;
    }

    private static DoctorSchedule mapResultSetToScheduleWithTimeSlot(ResultSet rs) throws SQLException {
        DoctorSchedule ds = new DoctorSchedule();
        ds.setScheduleId(rs.getInt("schedule_id"));
        ds.setDoctorId(rs.getLong("doctor_id"));
        ds.setWorkDate(rs.getDate("work_date"));
        ds.setSlotId(rs.getInt("slot_id"));
        ds.setStartTime(rs.getTime("start_time"));
        ds.setEndTime(rs.getTime("end_time"));
        ds.setStatus(rs.getString("status"));

        TimeSlot ts = new TimeSlot();
        ts.setStartTime(rs.getTime("start_time").toLocalTime());
        ts.setEndTime(rs.getTime("end_time").toLocalTime());
        ds.setTimeSlot(ts);

        return ds;
    }

    // Deprecated method - để tương thích ngược
    @Deprecated
    public static Object getAvailableDates(int parseInt) {
        throw new UnsupportedOperationException("Method deprecated. Use getWorkDatesByDoctorId instead.");
    }

    /**
     * ⚠️ DEPRECATED: Hàm cũ dùng logic sai - sẽ được thay thế dần
     */
    @Deprecated
    public static List<Integer> getApprovedSlotIdsByDoctorAndDate(int doctorId, String workDate) {
        System.out.println("⚠️ [DEPRECATED] getApprovedSlotIdsByDoctorAndDate() - Nên dùng getAvailableSlotIdsByDoctorAndDate()");
        
        // Gọi hàm mới để tương thích ngược
        return getAvailableSlotIdsByDoctorAndDate(doctorId, workDate);
    }

    /**
     * DEPRECATED: Hàm này đã bị xóa vì sai logic.
     * DoctorSchedule chỉ dùng để lưu LỊCH NGHỈ, không phải lịch làm việc.
     * Mặc định bác sĩ làm việc tất cả các ngày, chỉ nghỉ khi có bản ghi trong DoctorSchedule.
     */
    @Deprecated
    public static void autoGenerateSchedulesForAllDoctors2Weeks() {
        ResultSet rs = null;
        System.out.println("⚠️ [DEPRECATED] autoGenerateSchedulesForAllDoctors2Weeks() - Hàm này không còn được sử dụng");
        System.out.println("💡 Logic mới: DoctorSchedule chỉ lưu NGÀY NGHỈ, không phải ngày làm việc");
        // Không thực hiện gì cả
    }

    /**
     * DEPRECATED: Hàm này đã bị xóa vì sai logic.
     */
    @Deprecated 
    public static void autoGenerateFullDaySchedules(long doctorId) {
        System.out.println("⚠️ [DEPRECATED] autoGenerateFullDaySchedules() - Hàm này không còn được sử dụng");
        // Không thực hiện gì cả
    }

    /**
     * Lấy danh sách lịch nghỉ phép theo status (pending, approved, rejected)
     */
    public static List<DoctorSchedule> getDoctorSchedulesByStatus(String status) {
        List<DoctorSchedule> schedules = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                String sql = "SELECT * FROM DoctorSchedule WHERE status = ? ORDER BY work_date ASC, doctor_id ASC";
                ps = conn.prepareStatement(sql);
                ps.setString(1, status);
                rs = ps.executeQuery();
                while (rs.next()) {
                    DoctorSchedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getDoctorSchedulesByStatus: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        return schedules;
    }

    /**
     * 🆕 Xóa lịch nghỉ theo bác sĩ và ngày
     */
    public static boolean deleteScheduleByDoctorAndDate(long doctorId, java.sql.Date workDate) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                String sql = "DELETE FROM DoctorSchedule WHERE doctor_id = ? AND work_date = ?";
                ps = conn.prepareStatement(sql);
                ps.setLong(1, doctorId);
                ps.setDate(2, workDate);
                int rowsAffected = ps.executeUpdate();
                System.out.println("[DEBUG] Xóa lịch nghỉ: doctorId=" + doctorId + ", workDate=" + workDate + ", rowsAffected=" + rowsAffected);
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error in deleteScheduleByDoctorAndDate: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        return false;
    }

    // Test main method
    public static void main(String[] args) {
        try {
            DoctorScheduleDAO dao = new DoctorScheduleDAO();
            
            // Test getAll
            List<DoctorSchedule> schedules = dao.getAll();
            System.out.println("All schedules count: " + schedules.size());
            
            // Test getSchedulesByDoctorId
            if (!schedules.isEmpty()) {
                long doctorId = schedules.get(0).getDoctorId();
                List<DoctorSchedule> doctorSchedules = dao.getSchedulesByDoctorId(doctorId);
                System.out.println("Schedules for doctor " + doctorId + ": " + doctorSchedules.size());
            }
            
            // Test getAllPendingSchedules
            List<DoctorSchedule> pendingSchedules = dao.getAllPendingSchedules();
            System.out.println("Pending schedules count: " + pendingSchedules.size());
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 