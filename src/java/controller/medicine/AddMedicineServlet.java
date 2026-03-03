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

@WebServlet(name = "AddMedicineServlet", urlPatterns = { "/AddMedicineServlet" })
public class AddMedicineServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String unit = request.getParameter("unit");
        String description = request.getParameter("description");
        int quantity = 0;

        try {
            quantity = Integer.parseInt(request.getParameter("quantity"));
            boolean success = MedicineDAO.addMedicine(name, quantity, unit, description);
            if (success) {
                request.getSession().setAttribute("successMessage", "Đã thêm thuốc mới thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể thêm thuốc. Vui lòng thử lại!");
            }
        } catch (NumberFormatException | SQLException e) {
            Logger.getLogger(AddMedicineServlet.class.getName()).log(Level.SEVERE, null, e);
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/jsp/manager/manager_khothuoc.jsp");
    }
}
