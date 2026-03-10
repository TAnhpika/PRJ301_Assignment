<%@page import="java.sql.*, util.DBContext, java.util.*, dao.AppointmentDAO, model.Appointment"%>
<%@page contentType="text/plain; charset=UTF-8"%>
<%
    try {
        List<Appointment> list = AppointmentDAO.getUnbilledCompletedAppointments();
        out.println("Result size: " + list.size());
        for(Appointment a : list) {
            out.println("App ID: " + a.getAppointmentId() + " - " + a.getPatientName());
        }
    } catch(Exception e) {
        out.println("Exception: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
