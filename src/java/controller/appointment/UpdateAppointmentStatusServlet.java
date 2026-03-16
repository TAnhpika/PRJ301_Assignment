package controller.appointment;

import dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "UpdateAppointmentStatusServlet", urlPatterns = {"/updateAppointmentStatus"})
public class UpdateAppointmentStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String appointmentIdStr = request.getParameter("appointmentId");
        String status = request.getParameter("status");

        System.out.println("=== UpdateAppointmentStatusServlet ===");
        System.out.println(" - Appointment ID: " + appointmentIdStr);
        System.out.println(" - New Status: " + status);

        if (appointmentIdStr != null && status != null) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                
                // Chuẩn hóa status theo constants trong AppointmentDAO
                String normalizedStatus = status.toUpperCase();
                
                boolean success = AppointmentDAO.updateAppointmentStatus(appointmentId, normalizedStatus);
                
                if (success) {
                    System.out.println(" ✅ Status updated successfully!");
                } else {
                    System.err.println(" ❌ Failed to update status.");
                }

            } catch (NumberFormatException e) {
                System.err.println(" ❌ Invalid Appointment ID format: " + appointmentIdStr);
            } catch (SQLException e) {
                System.err.println(" ❌ SQL Error: " + e.getMessage());
                e.printStackTrace();
            }
        }

        // Redirect back to referrer or default dashboard
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/DoctorAppointmentsServlet");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
