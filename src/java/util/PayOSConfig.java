package util;

/**
 * PayOS Configuration
 * 
 * @author TranHongPhuoc
 */
public class PayOSConfig {

    // PayOS Credentials - đọc từ .env (Env.get)
    public static String getClientId() {
        String val = Env.get("PAYOS_CLIENT_ID");
        System.out.println("[PayOS DEBUG] clientId loaded: " + (val != null ? val.substring(0, Math.min(8, val.length())) + "..." : "NULL"));
        return val;
    }

    public static String getApiKey() {
        String val = Env.get("PAYOS_API_KEY");
        System.out.println("[PayOS DEBUG] apiKey loaded: " + (val != null ? val.substring(0, Math.min(8, val.length())) + "..." : "NULL"));
        return val;
    }

    public static String getChecksumKey() {
        String val = Env.get("PAYOS_CHECKSUM_KEY");
        System.out.println("[PayOS DEBUG] checksumKey loaded: " + (val != null ? val.substring(0, Math.min(8, val.length())) + "..." : "NULL"));
        return val;
    }

    // PayOS URLs
    public static final String PAYOS_BASE_URL = "https://api-merchant.payos.vn";
    public static final String CREATE_PAYMENT_URL = PAYOS_BASE_URL + "/v2/payment-requests";
    public static final String GET_PAYMENT_URL = PAYOS_BASE_URL + "/v2/payment-requests";

    // Return URLs
    public static final String SUCCESS_URL = "http://localhost:8081/TestFull/PaymentSuccessServlet";
    public static final String CANCEL_URL = "http://localhost:8081/TestFull/PaymentCancelServlet";
    public static final String WEBHOOK_URL = "http://localhost:8081/TestFull/PayOSWebhookServlet";

    // Payment configurations
    public static final String CURRENCY = "VND";
    public static final int EXPIRATION_TIME = 15; // minutes

    private PayOSConfig() {
        // Private constructor to prevent instantiation
    }
}