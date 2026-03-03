package util;

import model.Bill;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.OutputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class PayOSUtil {
    public static String createPayOSPaymentRequest(Bill bill, String description) {
        try {
            // Sử dụng config từ PayOSConfig (đọc .env)
            String PAYOS_CLIENT_ID = PayOSConfig.getClientId();
            String PAYOS_API_KEY = PayOSConfig.getApiKey();
            String CREATE_PAYMENT_URL = PayOSConfig.CREATE_PAYMENT_URL;
            String CANCEL_URL = PayOSConfig.CANCEL_URL;
            String SUCCESS_URL = PayOSConfig.SUCCESS_URL;

            Gson gson = new Gson();
            Map<String, Object> paymentData = new HashMap<>();
            String orderIdStr = bill.getOrderId().replace("ORDER_", "");
            long orderCode = Math.abs(orderIdStr.hashCode()) % 999999L;
            paymentData.put("orderCode", orderCode);
            paymentData.put("amount", bill.getAmount().intValue());
            paymentData.put("description", description);
            paymentData.put("buyerName", bill.getCustomerName());
            paymentData.put("buyerPhone", bill.getCustomerPhone());
            paymentData.put("buyerEmail",
                    bill.getCustomerEmail() != null ? bill.getCustomerEmail() : "customer@example.com");
            paymentData.put("cancelUrl", CANCEL_URL);
            paymentData.put("returnUrl", SUCCESS_URL);
            paymentData.put("expiredAt", System.currentTimeMillis() / 1000 + 900); // 15 phút
            Map<String, Object> item = new HashMap<>();
            item.put("name", description);
            item.put("quantity", 1);
            item.put("price", bill.getAmount().intValue());
            paymentData.put("items", new Object[] { item });
            String jsonPayload = gson.toJson(paymentData);
            URL url = new URL(CREATE_PAYMENT_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("x-client-id", PAYOS_CLIENT_ID);
            conn.setRequestProperty("x-api-key", PAYOS_API_KEY);
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes("utf-8");
                os.write(input, 0, input.length);
            }
            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }
                    Map responseMap = gson.fromJson(response.toString(), Map.class);
                    Map data = (Map) responseMap.get("data");
                    if (data != null && data.containsKey("qrCode")) {
                        return (String) data.get("qrCode");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Fallback: trả về QR code test nếu API call fail
        return "";
    }

    // ==========================================
    // lớp servlet sinh ra mã qr cho staff

    public static String createPayOSPaymentRequestForStaff(Bill bill, String description) {
        try {
            System.out.println("[STAFF][PayOS] Tạo QR cho staff với billId=" + bill.getBillId());
            String PAYOS_CLIENT_ID = PayOSConfig.getClientId();
            String PAYOS_API_KEY = PayOSConfig.getApiKey();
            String CREATE_PAYMENT_URL = PayOSConfig.CREATE_PAYMENT_URL;
            String CANCEL_URL = PayOSConfig.CANCEL_URL;
            String SUCCESS_URL = PayOSConfig.SUCCESS_URL;

            Gson gson = new Gson();
            Map<String, Object> paymentData = new HashMap<>();
            // Sử dụng orderCode là số nguyên duy nhất (timestamp)
            long orderCode = System.currentTimeMillis() % 1000000000L;
            paymentData.put("orderCode", orderCode);
            int amount = bill.getAmount().intValue();
            if (amount <= 0)
                amount = 10000; // fallback tránh lỗi amount = 0
            paymentData.put("amount", amount);
            paymentData.put("description", description != null ? description : "Thanh toán dịch vụ nha khoa");
            paymentData.put("buyerName", bill.getCustomerName() != null ? bill.getCustomerName() : "Khach hang");
            paymentData.put("buyerPhone", bill.getCustomerPhone() != null ? bill.getCustomerPhone() : "0123456789");
            paymentData.put("buyerEmail",
                    bill.getCustomerEmail() != null ? bill.getCustomerEmail() : "customer@example.com");
            paymentData.put("cancelUrl", CANCEL_URL != null ? CANCEL_URL : "https://google.com");
            paymentData.put("returnUrl", SUCCESS_URL != null ? SUCCESS_URL : "https://google.com");
            paymentData.put("expiredAt", System.currentTimeMillis() / 1000 + 900); // 15 phút
            Map<String, Object> item = new HashMap<>();
            item.put("name", description != null ? description : "Dịch vụ nha khoa");
            item.put("quantity", 1);
            item.put("price", amount);
            paymentData.put("items", new Object[] { item });
            String jsonPayload = gson.toJson(paymentData);
            System.out.println("[STAFF][PayOS] Payload: " + jsonPayload);
            URL url = new URL(CREATE_PAYMENT_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("x-client-id", PAYOS_CLIENT_ID);
            conn.setRequestProperty("x-api-key", PAYOS_API_KEY);
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes("utf-8");
                os.write(input, 0, input.length);
            }
            int responseCode = conn.getResponseCode();
            System.out.println("[STAFF][PayOS] Response code: " + responseCode);
            if (responseCode == 200) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }
                    System.out.println("[STAFF][PayOS] Response: " + response);
                    Map responseMap = gson.fromJson(response.toString(), Map.class);
                    Map data = (Map) responseMap.get("data");
                    if (data != null && data.containsKey("qrCode")) {
                        System.out.println("[STAFF][PayOS] QR URL: " + data.get("qrCode"));
                        return (String) data.get("qrCode");
                    } else {
                        System.out.println("[STAFF][PayOS] Không có trường qrCode trong response!");
                    }
                }
            } else {
                System.out.println("[STAFF][PayOS] API trả về mã lỗi: " + responseCode);
                // Đọc error response để debug
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                    StringBuilder errorResponse = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        errorResponse.append(responseLine.trim());
                    }
                    System.out.println("[STAFF][PayOS] Error response: " + errorResponse.toString());
                }
            }
        } catch (Exception e) {
            System.out.println("[STAFF][PayOS] Exception: " + e.getMessage());
            e.printStackTrace();
        }

        // FALLBACK: Tạo QR VietQR/MB Bank khi PayOS API lỗi
        System.out.println("[STAFF][PayOS] PayOS API lỗi - Sử dụng QR fallback VietQR/MB Bank");
        return generateMBBankDirectQR(bill);
    }

    /**
     * Tạo QR code cho TẤT CẢ ngân hàng Việt Nam (VietQR format) - FALLBACK
     */
    private static String generateMBBankDirectQR(Bill bill) {
        // Default account cho demo (có thể config nhiều account khác nhau)
        String defaultBankCode = "970422"; // MB Bank
        String defaultAccountNumber = "70410082004";

        String amount = String.valueOf(bill.getAmount().intValue());
        String description = bill.getBillId(); // Đơn giản hóa

        // Tạo VietQR universal format (hỗ trợ tất cả ngân hàng)
        String qrUrl = String.format(
                "https://img.vietqr.io/image/%s-%s-compact.jpg?amount=%s&addInfo=%s",
                defaultBankCode,
                defaultAccountNumber,
                amount,
                java.net.URLEncoder.encode(description, java.nio.charset.StandardCharsets.UTF_8));

        System.out.println("[STAFF][FALLBACK] === MÃ QR NGÂN HÀNG VIỆT NAM TOÀN DIỆN (VIETQR) ===");
        System.out.println("[STAFF][FALLBACK] 🏦 Ngân hàng: " + getBankName(defaultBankCode));
        System.out.println("[STAFF][FALLBACK] 📱 Mã BIN: " + defaultBankCode);
        System.out.println("[STAFF][FALLBACK] 💳 Tài khoản: " + defaultAccountNumber);
        System.out.println("[STAFF][FALLBACK] 💰 Số tiền: " + amount + " VNĐ");
        System.out.println("[STAFF][FALLBACK] 📝 Mô tả: " + description);
        System.out.println("[STAFF][FALLBACK] 🔗 URL QR: " + qrUrl);
        System.out.println("[STAFF][FALLBACK] ✅ Có thể thanh toán bằng BẤT KỲ ngân hàng nào tại Việt Nam!");

        return qrUrl;
    }

    /**
     * Get bank name từ BIN code
     */
    private static String getBankName(String binCode) {
        Map<String, String> bankNames = new HashMap<>();
        bankNames.put("970422", "MB Bank");
        bankNames.put("970436", "Vietcombank");
        bankNames.put("970418", "BIDV");
        bankNames.put("970405", "Agribank");
        bankNames.put("970415", "VietinBank");
        bankNames.put("970407", "Techcombank");
        bankNames.put("970416", "ACB");
        bankNames.put("970443", "SHB");
        bankNames.put("970432", "VPBank");
        bankNames.put("970423", "TPBank");
        bankNames.put("970403", "Sacombank");
        bankNames.put("970437", "HDBank");

        return bankNames.getOrDefault(binCode, "Unknown Bank");
    }
}