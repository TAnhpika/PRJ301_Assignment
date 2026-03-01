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
        if (val == null || val.isEmpty()) {
            System.err.println("[PayOS ERROR] PAYOS_CLIENT_ID is EMPTY or NULL!");
            return null;
        }
        System.out.println("[PayOS DEBUG] clientId loaded: " + val.substring(0, Math.min(8, val.length())) + "...");
        return val;
    }

    public static String getApiKey() {
        String val = Env.get("PAYOS_API_KEY");
        if (val == null || val.isEmpty()) {
            System.err.println("[PayOS ERROR] PAYOS_API_KEY is EMPTY or NULL!");
            return null;
        }
        System.out.println("[PayOS DEBUG] apiKey loaded: " + val.substring(0, Math.min(8, val.length())) + "...");
        return val;
    }

    public static String getChecksumKey() {
        String val = Env.get("PAYOS_CHECKSUM_KEY");
        if (val == null || val.isEmpty()) {
            System.err.println("[PayOS ERROR] PAYOS_CHECKSUM_KEY is EMPTY or NULL!");
            return null;
        }
        System.out.println("[PayOS DEBUG] checksumKey loaded: " + val.substring(0, Math.min(8, val.length())) + "...");
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