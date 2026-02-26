package util;

import model.Bill;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;

/**
 * Helper sử dụng PayOS Java SDK (payos-java-1.0.3) để tạo payment link.
 * Đọc clientId/apiKey/checksumKey từ PayOSConfig (đã map với .env).
 */
public class PayOSSdkHelper {

    private static PayOS newClient() {
        return new PayOS(
                PayOSConfig.getClientId(),
                PayOSConfig.getApiKey(),
                PayOSConfig.getChecksumKey());
    }

    /**
     * Tạo checkoutUrl cho bill (luồng bệnh nhân đặt lịch).
     *
     * @param bill        hóa đơn trong hệ thống
     * @param description mô tả đơn hàng hiển thị trên PayOS
     * @param returnUrl   URL PayOS redirect khi thanh toán thành công
     * @param cancelUrl   URL PayOS redirect khi hủy/thất bại
     */
    public static String createCheckoutUrlForBill(Bill bill,
            String description,
            String returnUrl,
            String cancelUrl) throws Exception {
        PayOS payOS = newClient();

        // PayOS yêu cầu orderCode là số nguyên dương, thường 6-12 chữ số
        // Sử dụng timestamp nhưng lấy 9 chữ số cuối để tránh vượt quá giới hạn
        long timestamp = System.currentTimeMillis();
        long orderCode = timestamp % 1000000000L; // Lấy 9 chữ số cuối (< 1 tỷ)

        System.out.println("[PayOS DEBUG] Creating payment link:");
        System.out.println("  - Bill ID: " + bill.getBillId());
        System.out.println("  - Order Code: " + orderCode);
        System.out.println("  - Timestamp: " + timestamp);

        long amountLong = bill.getAmount().longValue();
        if (amountLong <= 0) {
            throw new IllegalArgumentException("Amount must be > 0 for PayOS payment");
        }
        if (amountLong > Integer.MAX_VALUE) {
            throw new IllegalArgumentException("Amount is too large for PayOS SDK v1 (must fit Integer)");
        }
        int amount = (int) amountLong;

        System.out.println("  - Amount: " + amount + " VND");
        System.out.println("  - Description: " + description);

        PaymentData req = PaymentData.builder()
                .orderCode(orderCode)
                .amount(amount)
                .description(description)
                .returnUrl(returnUrl)
                .cancelUrl(cancelUrl)
                .item(ItemData.builder()
                        .name(description)
                        .price(amount)
                        .quantity(1)
                        .build())
                .build();

        System.out.println("[PayOS DEBUG] Calling PayOS API...");
        CheckoutResponseData res = payOS.createPaymentLink(req);
        System.out.println("[PayOS DEBUG] Payment link created successfully!");
        System.out.println("  - Checkout URL: " + res.getCheckoutUrl());

        return res.getCheckoutUrl();
    }

    /**
     * Tạo QR cho quầy thuốc (staff). PayOS trả cả checkoutUrl & qrCode,
     * ở đây ta trả lại qrCode để JSP hiển thị ảnh.
     */
    public static String createQrForPharmacy(Bill bill,
            String description,
            String returnUrl,
            String cancelUrl) throws Exception {
        PayOS payOS = newClient();

        // PayOS yêu cầu orderCode là số nguyên dương, thường 6-12 chữ số
        long timestamp = System.currentTimeMillis();
        long orderCode = timestamp % 1000000000L; // Lấy 9 chữ số cuối (< 1 tỷ)

        long amountLong = bill.getAmount().longValue();
        if (amountLong <= 0) {
            throw new IllegalArgumentException("Amount must be > 0 for PayOS payment");
        }
        if (amountLong > Integer.MAX_VALUE) {
            throw new IllegalArgumentException("Amount is too large for PayOS SDK v1 (must fit Integer)");
        }
        int amount = (int) amountLong;

        PaymentData req = PaymentData.builder()
                .orderCode(orderCode)
                .amount(amount)
                .description(description)
                .returnUrl(returnUrl)
                .cancelUrl(cancelUrl)
                .item(ItemData.builder()
                        .name(description)
                        .price(amount)
                        .quantity(1)
                        .build())
                .build();

        CheckoutResponseData res = payOS.createPaymentLink(req);
        // Nếu muốn redirect thì dùng res.getCheckoutUrl()
        return res.getQrCode();
    }
}
