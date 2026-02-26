package util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import model.Bill;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * PayOS Direct REST API Helper - Bypass SDK signature bug.
 * Gọi trực tiếp PayOS REST API v2.
 */
public class PayOSDirectHelper {

    private static final String PAYOS_API_URL = "https://api-merchant.payos.vn/v2/payment-requests";
    private static final Gson gson = new Gson();

    /**
     * Tạo payment link trực tiếp qua PayOS REST API.
     */
    public static String createPaymentLinkDirect(Bill bill,
            String description,
            String returnUrl,
            String cancelUrl) throws Exception {

        String clientId = PayOSConfig.getClientId();
        String apiKey = PayOSConfig.getApiKey();
        String checksumKey = PayOSConfig.getChecksumKey();

        if (clientId == null || apiKey == null || checksumKey == null) {
            throw new IllegalStateException("PayOS credentials not configured");
        }

        long orderCode = System.currentTimeMillis() % 1000000000L;
        int amount = bill.getAmount().intValue();

        System.out.println("[PayOS DIRECT] orderCode=" + orderCode
                + " amount=" + amount + " desc=" + description);

        // ---- 1. Tính signature theo đúng spec PayOS ----
        // Format: amount={}&cancelUrl={}&description={}&orderCode={}&returnUrl={}
        String dataToSign = "amount=" + amount
                + "&cancelUrl=" + cancelUrl
                + "&description=" + description
                + "&orderCode=" + orderCode
                + "&returnUrl=" + returnUrl;

        String signature = hmacSHA256(checksumKey, dataToSign);
        System.out.println("[PayOS DIRECT] dataToSign=" + dataToSign);
        System.out.println("[PayOS DIRECT] signature=" + signature);

        // ---- 2. Build JSON body (phải có trường signature) ----
        JsonObject item = new JsonObject();
        item.addProperty("name", description);
        item.addProperty("quantity", 1);
        item.addProperty("price", amount);

        JsonObject payload = new JsonObject();
        payload.addProperty("orderCode", orderCode);
        payload.addProperty("amount", amount);
        payload.addProperty("description", description);
        payload.addProperty("returnUrl", returnUrl);
        payload.addProperty("cancelUrl", cancelUrl);
        payload.addProperty("signature", signature); // ← BẮT BUỘC
        payload.add("items", gson.toJsonTree(new JsonObject[] { item }));

        String body = gson.toJson(payload);
        System.out.println("[PayOS DIRECT] body=" + body);

        // ---- 3. Gửi HTTP POST ----
        URL url = URI.create(PAYOS_API_URL).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("x-client-id", clientId);
        conn.setRequestProperty("x-api-key", apiKey);
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }

        int code = conn.getResponseCode();
        BufferedReader br = new BufferedReader(new InputStreamReader(
                code >= 200 && code < 300 ? conn.getInputStream() : conn.getErrorStream(),
                StandardCharsets.UTF_8));

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null)
            sb.append(line);
        br.close();

        String resp = sb.toString();
        System.out.println("[PayOS DIRECT] HTTP " + code + " → " + resp);

        // ---- 4. Parse response ----
        JsonObject json = new JsonParser().parse(resp).getAsJsonObject();
        String respCode = json.has("code") ? json.get("code").getAsString() : "";

        if (!"00".equals(respCode)) {
            String desc = json.has("desc") ? json.get("desc").getAsString() : "Unknown error";
            throw new Exception("PayOS error code=" + respCode + ": " + desc);
        }

        // data có thể null → check trước khi cast
        if (json.get("data") == null || json.get("data").isJsonNull()) {
            throw new Exception("PayOS returned null data. Response: " + resp);
        }

        JsonObject data = json.getAsJsonObject("data");
        if (!data.has("checkoutUrl")) {
            throw new Exception("No checkoutUrl in response: " + resp);
        }

        String checkoutUrl = data.get("checkoutUrl").getAsString();
        System.out.println("[PayOS DIRECT] ✅ checkoutUrl=" + checkoutUrl);
        return checkoutUrl;
    }

    /* HMAC-SHA256 helper */
    private static String hmacSHA256(String key, String data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) {
            String h = Integer.toHexString(0xff & b);
            if (h.length() == 1)
                hex.append('0');
            hex.append(h);
        }
        return hex.toString();
    }
}
