package controller.appointment;

import dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.TimeSlot;

@WebServlet(name = "GetAvailableSlotsServlet", urlPatterns = { "/GetAvailableSlotsServlet" })
public class GetAvailableSlotsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String date = request.getParameter("date");
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

            List<TimeSlot> availableSlots = AppointmentDAO.getAvailableSlots(doctorId, date, appointmentId);

            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < availableSlots.size(); i++) {
                TimeSlot slot = availableSlots.get(i);
                if (i > 0)
                    json.append(",");
                json.append("{");
                json.append("\"slotId\":").append(slot.getSlotId()).append(",");
                json.append("\"startTime\":\"").append(slot.getStartTime()).append("\",");
                json.append("\"endTime\":\"").append(slot.getEndTime()).append("\",");
                json.append("\"isBooked\":").append(slot.isBooked());
                json.append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
