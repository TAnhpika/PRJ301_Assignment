import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.regex.*;

public class FixPaths {
    public static void main(String[] args) throws IOException {
        Files.walk(Paths.get("web"))
                .filter(Files::isRegularFile)
                .filter(p -> p.toString().endsWith(".jsp") || p.toString().endsWith(".css")
                        || p.toString().endsWith(".js"))
                .forEach(FixPaths::processFile);
        System.out.println("Done.");
    }

    private static void processFile(Path filePath) {
        try {
            String content = new String(Files.readAllBytes(filePath), "UTF-8");
            String original = content;

            // Fix for patient.css 404
            // <link rel="stylesheet"
            // href="${pageContext.request.contextPath}/view/assets/css/patient.css">
            // Actually it was loading dashboard.css probably, I will change missing
            // /view/assets/css/patient.css to use dashboard.css instead or just remove if
            // it doesn't exist

            // Fix //images -> /view/assets/img/
            content = content.replaceAll("\\$\\{pageContext\\.request\\.contextPath\\}//images/",
                    "\\$\\{pageContext.request.contextPath\\}/view/assets/img/");
            content = content.replaceAll("\\$\\{pageContext\\.request\\.contextPath\\}/images/",
                    "\\$\\{pageContext.request.contextPath\\}/view/assets/img/");

            // Fix /img/ -> /view/assets/img/
            content = content.replaceAll("\\$\\{pageContext\\.request\\.contextPath\\}/img/",
                    "\\$\\{pageContext.request.contextPath\\}/view/assets/img/");
            content = content.replaceAll("<%= request\\.getContextPath\\(\\)\\s*%>\\s*/img/",
                    "<%= request.getContextPath() %>/view/assets/img/");

            // Fix context URL in front of https
            // Example: ${pageContext.request.contextPath}/https://www.vinmec.com...
            // the variable might be like ${blogPost.imageUrl}
            // So we need to evaluate in JSTL or java. We can just use string operations:
            // src="${pageContext.request.contextPath}/${item.image}"
            // Let's replace with a JSTL core choose?
            // Better: use EL 3.0:
            // src="${item.image.startsWith('http') ? item.image :
            // pageContext.request.contextPath.concat(item.image.startsWith('/') ? '' :
            // '/').concat(item.image)}"
            Matcher m = Pattern
                    .compile("src\\s*=\\s*\"\\$\\{pageContext\\.request\\.contextPath\\}/\\$\\{([a-zA-Z0-9_\\.]+)\\}\"")
                    .matcher(content);
            StringBuffer sb = new StringBuffer();
            while (m.find()) {
                String var = m.group(1);
                String replacement = "src=\"${" + var + ".startsWith('http') ? " + var
                        + " : pageContext.request.contextPath.concat(" + var + ".startsWith('/') ? '' : '/').concat("
                        + var + ")}\"";
                m.appendReplacement(sb, Matcher.quoteReplacement(replacement));
            }
            m.appendTail(sb);
            content = sb.toString();

            Matcher m2 = Pattern
                    .compile(
                            "href\\s*=\\s*\"\\$\\{pageContext\\.request\\.contextPath\\}/\\$\\{([a-zA-Z0-9_\\.]+)\\}\"")
                    .matcher(content);
            StringBuffer sb2 = new StringBuffer();
            while (m2.find()) {
                String var = m2.group(1);
                String replacement = "href=\"${" + var + ".startsWith('http') ? " + var
                        + " : pageContext.request.contextPath.concat(" + var + ".startsWith('/') ? '' : '/').concat("
                        + var + ")}\"";
                m2.appendReplacement(sb2, Matcher.quoteReplacement(replacement));
            }
            m2.appendTail(sb2);
            content = sb2.toString();

            // Same with <%= %> tags?
            // <img src="<%= request.getContextPath() %>/<%= blogpost.getImage() %>">
            Matcher m3 = Pattern
                    .compile("src\\s*=\\s*\"<%= request\\.getContextPath\\(\\)\\s*%>\\s*/\\s*<%=\\s*(.*?)\\s*%>\"")
                    .matcher(content);
            StringBuffer sb3 = new StringBuffer();
            while (m3.find()) {
                String var = m3.group(1);
                String replacement = "src=\"<%= (" + var + ").startsWith(\\\"http\\\") ? (" + var
                        + ") : request.getContextPath() + ((" + var
                        + ").startsWith(\\\"/\\\") ? \\\"\\\" : \\\"/\\\") + (" + var + ") %>\"";
                m3.appendReplacement(sb3, Matcher.quoteReplacement(replacement));
            }
            m3.appendTail(sb3);
            content = sb3.toString();

            if (!content.equals(original)) {
                Files.write(filePath, content.getBytes("UTF-8"));
                System.out.println("Cleaned URL paths: " + filePath);
            }
        } catch (Exception e) {
        }
    }
}
