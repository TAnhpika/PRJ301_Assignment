/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author lebao
 */
@WebServlet(name = "ManagerResetStaffPasswordServlet", urlPatterns = { "/ManagerResetStaffPasswordServlet" })
public class ManagerResetStaffPasswordServlet extends HttpServlet {

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
            out.println("<title>Servlet ManagerResetStaffPasswordServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManagerResetStaffPasswordServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        String idStr = request.getParameter("id");

        jakarta.servlet.http.HttpSession session = request.getSession();

        if (type == null || idStr == null) {
            session.setAttribute("error", "Tham số không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/jsp/manager/manager_danhsach.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            int userId = -1;

            if ("doctor".equals(type)) {
                userId = dao.DoctorDAO.getUserId(id);
            } else if ("staff".equals(type)) {
                model.Staff staff = dao.StaffDAO.getStaffById(id);
                if (staff != null) {
                    userId = (int) staff.getUserId();
                }
            }

            if (userId != -1) {
                boolean success = dao.UserDAO.updatePassword(userId, "123456");
                if (success) {
                    session.setAttribute("success", "Mật khẩu đã được reset về '123456'.");
                } else {
                    session.setAttribute("error", "Không thể reset mật khẩu.");
                }
            } else {
                session.setAttribute("error", "Không tìm thấy tài khoản người dùng.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/jsp/manager/manager_danhsach.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
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
