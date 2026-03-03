package controller.admin;

import dao.BlogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/DeleteBlogServlet")
public class DeleteBlogServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String blogIdStr = request.getParameter("blogId");

        if (blogIdStr != null && !blogIdStr.isEmpty()) {
            try {
                int blogId = Integer.parseInt(blogIdStr);

                // Get the image URL before deleting so we can remove the file
                String imageUrl = BlogDAO.deletePost(blogId);

                // If there's an image file, try to delete it from the server
                if (imageUrl != null && !imageUrl.isEmpty()) {
                    String realPath = getServletContext().getRealPath("/");
                    File imageFile = new File(realPath + imageUrl);
                    if (imageFile.exists()) {
                        imageFile.delete();
                    }
                }

                // Redirect back to the blog management page
                response.sendRedirect(request.getContextPath() + "/jsp/manager/manager_blogs.jsp");

            } catch (NumberFormatException | SQLException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/jsp/manager/manager_blogs.jsp?error=DeleteFailed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/jsp/manager/manager_blogs.jsp?error=InvalidId");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
