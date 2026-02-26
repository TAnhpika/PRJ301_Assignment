package util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

/**
 * Đọc biến môi trường: ưu tiên System.getenv(), sau đó file .env. File .env đặt
 * tại thư mục gốc project (hoặc đường dẫn trong system property env.file).
 */
public final class Env {

    private static Map<String, String> envMap;
    private static final Object LOCK = new Object();

    private static Map<String, String> loadEnv() {
        if (envMap != null) {
            return envMap;
        }
        synchronized (LOCK) {
            if (envMap != null) {
                return envMap;
            }
            envMap = new HashMap<>();
            String pathStr = System.getProperty("env.file");
            if (pathStr == null || pathStr.isEmpty()) {
                pathStr = System.getProperty("user.dir") + "/.env";
            }
            Path path = Paths.get(pathStr);
            if (!Files.exists(path)) {
                return envMap;
            }
            try {
                Files.readAllLines(path).stream()
                        .map(String::trim)
                        .filter(line -> !line.isEmpty() && !line.startsWith("#"))
                        .forEach(line -> {
                            int eq = line.indexOf('=');
                            if (eq > 0) {
                                String key = line.substring(0, eq).trim();
                                String value = line.substring(eq + 1).trim();
                                if (value.startsWith("\"") && value.endsWith("\"")) {
                                    value = value.substring(1, value.length() - 1);
                                }
                                envMap.put(key, value);
                            }
                        });
            } catch (IOException e) {
                System.err.println("[Env] Cannot read .env: " + e.getMessage());
            }
            return envMap;
        }
    }

    /**
     * Lấy giá trị: ưu tiên biến môi trường hệ thống, sau đó từ file .env.
     */
    public static String get(String key) {
        String v = System.getenv(key);
        if (v != null && !v.isEmpty()) {
            return v;
        }
        return loadEnv().getOrDefault(key, "");
    }

    /**
     * Lấy giá trị với mặc định nếu không có.
     */
    public static String get(String key, String defaultValue) {
        String v = get(key);
        return (v != null && !v.isEmpty()) ? v : defaultValue;
    }

    private Env() {
    }
}
