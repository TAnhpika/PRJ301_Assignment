package controller.medicine;

import dao.MedicineDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet(name = "DeleteMedicineServlet", urlPatterns = { "/DeleteMedicineServlet" })
public class DeleteMedicineServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }

        try {
            int medicineId = Integer.parseInt(request.getParameter("medicineId"));
            boolean success = MedicineDAO.deleteMedicine(medicineId);
            if (success) {
                request.getSession().setAttribute("successMessage", "Đã xóa thuốc thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy thuốc để xóa!");
            }
        } catch (NumberFormatException | SQLException e) {
            Logger.getLogger(DeleteMedicineServlet.class.getName()).log(Level.SEVERE, null, e);
            request.getSession().setAttribute("errorMessage", "Không thể xóa thuốc: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/jsp/manager/manager_khothuoc.jsp");
    }
}
