import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.net.URL;

public class DownloadJar {
    public static void main(String[] args) throws Exception {
        URL url = new URL("https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/1.7.36/slf4j-simple-1.7.36.jar");
        try (InputStream in = url.openStream()) {
            Files.copy(in, Paths.get("web/WEB-INF/lib/slf4j-simple-1.7.36.jar"), StandardCopyOption.REPLACE_EXISTING);
        }
        System.out.println("Downloaded.");
    }
}
