package controller.treatment;

import dao.DoctorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Doctors;
import model.User;
import util.DBContext;

/**
 * UpdateMedicalReportServlet - Cập nhật báo cáo y tế
 */
@WebServlet("/UpdateMedicalReportServlet")
public class UpdateMedicalReportServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UpdateMedicalReportServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        if (user == null || !"DOCTOR".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/view/jsp/auth/login.jsp");
            return;
        }

        String reportIdStr = request.getParameter("reportId");
        String diagnosis = request.getParameter("diagnosis");
        String treatmentPlan = request.getParameter("treatmentPlan");
        String note = request.getParameter("note");
        String sign = request.getParameter("sign");

        if (reportIdStr == null || reportIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/DoctorAppointmentsServlet");
            return;
        }

        int reportId;
        try {
            reportId = Integer.parseInt(reportIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/DoctorAppointmentsServlet");
            return;
        }

        // Lấy doctorId từ session
        Doctors doctorObj = (Doctors) session.getAttribute("doctor");
        int doctorId = 0;
        if (doctorObj != null) {
            doctorId = (int) doctorObj.getDoctorId();
        } else {
            // Fallback: tìm theo userId
            try {
                Doctors d = DoctorDAO.getDoctorByUserId((int) user.getId());
                if (d != null)
                    doctorId = (int) d.getDoctorId();
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Cannot find doctorId", ex);
            }
        }

        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                // Table name: MedicalReport (không có 's')
                // Columns: diagnosis, treatment_plan, note, sign
                String sql = "UPDATE MedicalReport SET diagnosis = ?, treatment_plan = ?, "
                        + "note = ?, sign = ? WHERE report_id = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, diagnosis != null ? diagnosis.trim() : "");
                ps.setString(2, treatmentPlan != null ? treatmentPlan.trim() : null);
                ps.setString(3, note != null ? note.trim() : null);
                ps.setString(4, sign != null ? sign.trim() : null);
                ps.setInt(5, reportId);

                int rows = ps.executeUpdate();
                success = rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi cập nhật MedicalReport id=" + reportId, e);
            success = false;
        } finally {
            DBContext.close(null, ps, conn);
        }

        // Redirect về trang xem báo cáo
        String redirectUrl = request.getContextPath() +
                "/ViewReportServlet?reportId=" + reportId +
                "&message=" + (success ? "success" : "error");
        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
