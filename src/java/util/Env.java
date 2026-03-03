package util;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
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
            Path path = null;

            if (pathStr != null && !pathStr.isEmpty()) {
                path = Paths.get(pathStr);
            } else {
                // Thử nhiều vị trí phổ biến
                String[] possiblePaths = {
                        System.getProperty("user.dir") + "/.env",
                        System.getProperty("user.dir") + "/../.env", // Tomcat bin -> project root
                        "d:/Documents/NetBeansProjects/NewProject/Dental-Clinic-Refactor-Source/.env", // Fallback path
                                                                                                       // if known
                        "/.env"
                };

                for (String p : possiblePaths) {
                    Path t = Paths.get(p);
                    if (Files.exists(t)) {
                        path = t;
                        System.out.println("[Env] Found .env at: " + t.toAbsolutePath());
                        break;
                    }
                }
            }

            if (path == null || !Files.exists(path)) {
                System.err.println("[Env] WARNING: .env file not found. System may use default values.");
                return envMap;
            }

            try {
                Files.readAllLines(path, StandardCharsets.UTF_8).stream()
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
                System.out.println("[Env] Loaded " + envMap.size() + " variables from " + path.toAbsolutePath());
            } catch (IOException e) {
                System.err.println("[Env] ERROR: Cannot read .env: " + e.getMessage());
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

    /**
     * Xóa cache để reload .env (hữu ích khi đổi API key khi đang chạy).
     */
    public static void clearCache() {
        synchronized (LOCK) {
            envMap = null;
        }
    }

    private Env() {
    }
}
