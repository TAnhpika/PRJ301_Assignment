package controller.payment;

import dao.BillDAO;
import model.Bill;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * Servlet để user confirm đã thanh toán và trigger success
 * URL: /confirmPayment
 */
@WebServlet("/confirmPayment")
public class PaymentConfirmServlet extends HttpServlet {

    private BillDAO billDAO = new BillDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String orderId = request.getParameter("orderId");
        String billId = request.getParameter("billId");

        if ("confirm".equals(action)) {
            handlePaymentConfirm(request, response, orderId, billId);
        } else {
            showConfirmPage(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Hiển thị trang confirm payment
     */
    private void showConfirmPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html><head>");
        out.println("<title>✅ Xác nhận thanh toán</title>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println(
                "<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css' rel='stylesheet'>");
        out.println(
                "<link href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css' rel='stylesheet'>");
        out.println("<style>");
        out.println(
                "body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 20px; }");
        out.println(
                ".confirm-container { background: white; border-radius: 15px; padding: 30px; max-width: 600px; margin: 0 auto; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }");
        out.println(
                ".btn-confirm { background: #28a745; border: none; padding: 15px 30px; font-size: 1.2rem; border-radius: 25px; }");
        out.println(".btn-confirm:hover { background: #218838; transform: translateY(-2px); }");
        out.println("</style>");
        out.println("</head><body>");

        out.println("<div class='confirm-container'>");
        out.println("<div class='text-center mb-4'>");
        out.println("<i class='fas fa-check-circle fa-4x text-success mb-3'></i>");
        out.println("<h2>🏦 Xác nhận thanh toán MB Bank</h2>");
        out.println("<p class='lead'>Bạn đã hoàn tất chuyển khoản?</p>");
        out.println("</div>");

        out.println("<div class='alert alert-info'>");
        out.println("<h6><i class='fas fa-info-circle me-2'></i>Thông tin chuyển khoản:</h6>");
        out.println("<ul class='mb-0'>");
        out.println("<li><strong>Ngân hàng:</strong> MB Bank</li>");
        out.println("<li><strong>Số tài khoản:</strong> 70410082004</li>");
        out.println("<li><strong>Chủ tài khoản:</strong> NGUYEN VAN TUAN ANH</li>");
        out.println("<li><strong>Số tiền:</strong> 2,000 VND</li>");
        out.println("<li><strong>Nội dung:</strong> BILL_XXXXXXXX</li>");
        out.println("</ul>");
        out.println("</div>");

        // Form confirm với current order/bill
        String currentOrderId = request.getParameter("orderId");
        String currentBillId = request.getParameter("billId");

        if (currentOrderId != null || currentBillId != null) {
            out.println("<form method='post' class='text-center'>");
            out.println("<input type='hidden' name='action' value='confirm'>");
            if (currentOrderId != null) {
                out.println("<input type='hidden' name='orderId' value='" + currentOrderId + "'>");
                out.println("<p><strong>Order ID:</strong> <code>" + currentOrderId + "</code></p>");
            }
            if (currentBillId != null) {
                out.println("<input type='hidden' name='billId' value='" + currentBillId + "'>");
                out.println("<p><strong>Bill ID:</strong> <code>" + currentBillId + "</code></p>");
            }

            out.println("<button type='submit' class='btn btn-confirm btn-success'>");
            out.println("<i class='fas fa-check me-2'></i>Xác nhận đã thanh toán");
            out.println("</button>");
            out.println("</form>");
        } else {
            // Manual input form
            out.println("<form method='post'>");
            out.println("<input type='hidden' name='action' value='confirm'>");

            out.println("<div class='mb-3'>");
            out.println("<label class='form-label'><strong>Order ID hoặc Bill ID:</strong></label>");
            out.println(
                    "<input type='text' name='orderId' class='form-control' placeholder='ORDER_1749726206435 hoặc BILL_C5C23B92' required>");
            out.println("</div>");

            out.println("<div class='text-center'>");
            out.println("<button type='submit' class='btn btn-confirm btn-success'>");
            out.println("<i class='fas fa-check me-2'></i>Xác nhận đã thanh toán");
            out.println("</button>");
            out.println("</div>");
            out.println("</form>");
        }

        out.println("<hr>");
        out.println("<div class='text-center'>");
        out.println("<small class='text-muted'>Chỉ xác nhận khi bạn đã thực sự chuyển khoản thành công</small><br>");
        out.println("<a href='payment?serviceId=10' class='btn btn-outline-secondary mt-2'>");
        out.println("<i class='fas fa-arrow-left me-2'></i>Quay lại thanh toán");
        out.println("</a>");
        out.println("</div>");

        out.println("</div>");
        out.println("</body></html>");
    }

    /**
     * Xử lý confirm payment
     */
    private void handlePaymentConfirm(HttpServletRequest request, HttpServletResponse response,
            String orderId, String billId)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Bill bill = null;

            // Tìm bill theo Order ID hoặc Bill ID
            if (orderId != null && orderId.startsWith("ORDER_")) {
                bill = billDAO.getBillByOrderId(orderId);
            } else if (orderId != null && orderId.startsWith("BILL_")) {
                bill = billDAO.getBillById(orderId);
            } else if (billId != null) {
                bill = billDAO.getBillById(billId);
            }

            if (bill == null) {
                out.println("{\"success\": false, \"message\": \"Không tìm thấy hóa đơn\"}");
                return;
            }

            // Kiểm tra trạng thái
            if ("success".equals(bill.getPaymentStatus())) {
                out.println(
                        "{\"success\": true, \"message\": \"Hóa đơn đã được thanh toán trước đó\", \"status\": \"already_paid\"}");
                return;
            }

            // Cập nhật trạng thái thành công
            String transactionId = "USER_CONFIRM_" + System.currentTimeMillis();
            boolean updated = billDAO.updatePaymentStatus(
                    bill.getBillId(),
                    "success",
                    transactionId,
                    "Payment confirmed by user after bank transfer");

            if (updated) {
                System.out.println("✅ USER CONFIRMED: Payment updated for " + bill.getBillId());
                out.println("{\"success\": true, \"message\": \"Thanh toán đã được xác nhận!\", \"orderId\": \""
                        + bill.getOrderId() + "\"}");

                // JavaScript redirect to success page
                response.sendRedirect("payment?action=success");

            } else {
                out.println("{\"success\": false, \"message\": \"Không thể cập nhật trạng thái thanh toán\"}");
            }

        } catch (SQLException e) {
            System.err.println("Error confirming payment: " + e.getMessage());
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"Lỗi database: " + e.getMessage() + "\"}");
        }
    }
}