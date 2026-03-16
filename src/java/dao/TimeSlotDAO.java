/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import model.TimeSlot;
import util.DBContext;

/**
 *
 * @author tuananh
 */
public class TimeSlotDAO {

    public TimeSlotDAO() {
    }

    public static List<TimeSlot> getAllTimeSlots() {
        List<TimeSlot> allSlots = new ArrayList<>();
        String sql = "SELECT * FROM TimeSlot ORDER BY start_time";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TimeSlot slot = new TimeSlot();
                slot.setSlotId(rs.getInt("slot_id"));
                slot.setStartTime(rs.getTime("start_time").toLocalTime());
                slot.setEndTime(rs.getTime("end_time").toLocalTime());
                allSlots.add(slot);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return allSlots;
    }

    public static TimeSlot getTimeSlotById(int slotId) {
        String sql = "SELECT * FROM TimeSlot WHERE slot_id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slotId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TimeSlot slot = new TimeSlot();
                    slot.setSlotId(rs.getInt("slot_id"));
                    Time startTime = rs.getTime("start_time");
                    Time endTime = rs.getTime("end_time");
                    if (startTime != null && endTime != null) {
                        slot.setStartTime(startTime.toLocalTime());
                        slot.setEndTime(endTime.toLocalTime());
                    }
                    return slot;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean addTimeSlot(LocalTime startTime, LocalTime endTime) {
        String sql = "INSERT INTO TimeSlot (start_time, end_time) VALUES (?, ?)";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTime(1, Time.valueOf(startTime));
            ps.setTime(2, Time.valueOf(endTime));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updateTimeSlot(int slotId, LocalTime startTime, LocalTime endTime) {
        String sql = "UPDATE TimeSlot SET start_time = ?, end_time = ? WHERE slot_id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTime(1, Time.valueOf(startTime));
            ps.setTime(2, Time.valueOf(endTime));
            ps.setInt(3, slotId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteTimeSlot(int slotId) {
        String sql = "DELETE FROM TimeSlot WHERE slot_id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slotId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<TimeSlot> getAvailableSlots(int doctorId, java.sql.Date workDate) {
        List<TimeSlot> availableSlots = new ArrayList<>();
        String sql = """
                    SELECT ts.* FROM TimeSlot ts
                    WHERE ts.slot_id IN (
                        SELECT ds.slot_id FROM DoctorSchedule ds
                        WHERE ds.doctor_id = ? AND ds.work_date = ?
                        AND ds.status = 'APPROVED'
                    )
                    AND ts.slot_id NOT IN (
                        SELECT a.slot_id FROM Appointment a
                        WHERE a.doctor_id = ? AND a.work_date = ?
                        AND a.status != 'CANCELLED'
                    )
                    ORDER BY ts.start_time
                """;

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ps.setDate(2, workDate);
            ps.setInt(3, doctorId);
            ps.setDate(4, workDate);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TimeSlot slot = new TimeSlot();
                    slot.setSlotId(rs.getInt("slot_id"));
                    slot.setStartTime(rs.getTime("start_time").toLocalTime());
                    slot.setEndTime(rs.getTime("end_time").toLocalTime());
                    availableSlots.add(slot);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return availableSlots;
    }

    /**
     * Lấy khung giờ theo ca làm việc
     * Ca 1: 08:00-12:00 (sáng)
     * Ca 2: 13:00-17:00 (chiều)
     * Ca 3: 08:00-17:00 (cả ngày)
     */
    public static List<TimeSlot> getSlotsByShift(int shift) {
        // FIX: Không hardcode slot_id kiểu 3002..3019 vì DB thật có thể là 97..117 (như
        // ảnh bạn gửi).
        // Map theo time range để render khung giờ luôn đúng.
        List<Integer> ids = getTimeSlotIdsForShift(shift);
        return getTimeSlotsByIds(ids);
    }

    /**
     * Lấy list slot_id theo ca làm việc (1/2/3) dựa trên start_time/end_time.
     * - Ca 1: 08:00 - 12:00
     * - Ca 2: 13:00 - 17:00
     * - Ca 3: 08:00 - 17:00
     *
     * (Không phụ thuộc slot_id là 97.. hay 3002..)
     */
    public static List<Integer> getTimeSlotIdsForShift(int shift) {
        List<Integer> ids = new ArrayList<>();

        // NOTE: Nếu business của bạn đổi giờ làm, chỉ cần sửa 3 mốc này.
        LocalTime from;
        LocalTime to;

        switch (shift) {
            case 1:
                from = LocalTime.of(8, 0);
                to = LocalTime.of(12, 0);
                break;
            case 2:
                from = LocalTime.of(13, 0);
                to = LocalTime.of(17, 0);
                break;
            case 3:
                from = LocalTime.of(8, 0);
                to = LocalTime.of(17, 0);
                break;
            default:
                return ids;
        }

        // Chọn slot theo start_time trong khoảng [from, to)
        // Lưu ý: cột start_time trong DB đang là DATETIME nên cần CAST về TIME
        // để tránh lỗi "time and datetime are incompatible".
        String sql = "SELECT slot_id FROM TimeSlot " +
                "WHERE CAST(start_time AS time) >= CAST(? AS time) " +
                "AND   CAST(start_time AS time) <  CAST(? AS time) " +
                "ORDER BY start_time ASC";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTime(1, Time.valueOf(from));
            ps.setTime(2, Time.valueOf(to));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("slot_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ids;
    }

    /**
     * Lấy thông tin TimeSlot từ danh sách slot_id cụ thể
     * Method này được dùng khi bác sĩ đã đăng ký các slot_id cụ thể
     */
    public static List<TimeSlot> getTimeSlotsByIds(List<Integer> slotIds) {
        List<TimeSlot> slots = new ArrayList<>();
        if (slotIds == null || slotIds.isEmpty()) {
            return slots;
        }

        // Tạo câu query với IN clause
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM TimeSlot WHERE slot_id IN (");
        for (int i = 0; i < slotIds.size(); i++) {
            if (i > 0)
                sql.append(",");
            sql.append("?");
        }
        sql.append(") ORDER BY start_time ASC");

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Set parameters cho IN clause
            for (int i = 0; i < slotIds.size(); i++) {
                ps.setInt(i + 1, slotIds.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TimeSlot slot = new TimeSlot();
                    slot.setSlotId(rs.getInt("slot_id"));
                    Time startTime = rs.getTime("start_time");
                    Time endTime = rs.getTime("end_time");
                    if (startTime != null && endTime != null) {
                        slot.setStartTime(startTime.toLocalTime());
                        slot.setEndTime(endTime.toLocalTime());
                    }
                    slots.add(slot);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getTimeSlotsByIds: " + e.getMessage());
            e.printStackTrace();
        }
        return slots;
    }

    /**
     * Lấy 3 ca chính trong ngày (slotId = 1, 2, 3)
     */
    public static List<TimeSlot> getMainTimeSlots() {
        // FIX: DB TimeSlot thường không có slot_id = 1,2,3.
        // 1/2/3 là "ca" (shift) dùng cho part-time, nên tạo object ngay trong code.
        List<TimeSlot> timeSlots = new ArrayList<>();
        timeSlots.add(new TimeSlot(1, LocalTime.of(8, 0), LocalTime.of(12, 0)));
        timeSlots.add(new TimeSlot(2, LocalTime.of(13, 0), LocalTime.of(17, 0)));
        timeSlots.add(new TimeSlot(3, LocalTime.of(8, 0), LocalTime.of(17, 0)));
        return timeSlots;
    }

    // ================================================
    // 🆕 METHOD: Lấy danh sách slot trống theo bác sĩ và ngày
    public static List<TimeSlot> getAvailableSlotsByDoctorAndDate(int doctorId, String workDate) {
        List<TimeSlot> availableSlots = new ArrayList<>();

        try (Connection conn = DBContext.getConnection()) {
            String sql = """
                        SELECT ts.* FROM TimeSlot ts
                        WHERE ts.slot_id IN (
                            SELECT ds.slot_id FROM DoctorSchedule ds
                            WHERE ds.doctor_id = ? AND ds.work_date = ?
                            AND ds.status = 'Confirmed'
                        )
                        AND ts.slot_id NOT IN (
                            SELECT a.slot_id FROM Appointment a
                            WHERE a.doctor_id = ? AND a.work_date = ?
                            AND a.status = 'BOOKED'
                        )
                        ORDER BY ts.start_time
                    """;

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, doctorId);
                ps.setString(2, workDate);
                ps.setInt(3, doctorId);
                ps.setString(4, workDate);

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    TimeSlot slot = new TimeSlot();
                    slot.setSlotId(rs.getInt("slot_id"));
                    slot.setStartTime(rs.getTime("start_time").toLocalTime());
                    slot.setEndTime(rs.getTime("end_time").toLocalTime());
                    availableSlots.add(slot);
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi lấy slot trống: " + e.getMessage());
            e.printStackTrace();
        }

        return availableSlots;
    }
}