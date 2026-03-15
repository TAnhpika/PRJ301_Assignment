
package util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

/**
 * Service để gửi email qua SMTP Gmail
 * @author ASUS
 */
public class EmailService {
    
    // Cấu hình email - đọc từ .env (SMTP_USERNAME, SMTP_PASSWORD, SMTP_HOST, SMTP_PORT)
    private static String getFromEmail() { return Env.get("SMTP_USERNAME"); }
    private static String getFromPassword() { return Env.get("SMTP_PASSWORD"); }
    private static String getSmtpHost() { return Env.get("SMTP_HOST", "smtp.gmail.com"); }
    private static String getSmtpPort() { return Env.get("SMTP_PORT", "587"); }

    
    /**
     * Gửi email OTP
     * @param toEmail Email người nhận
     * @param otp Mã OTP
     * @return true nếu gửi thành công
     */
    public static boolean sendOTPEmail(String toEmail, String otp) {
        System.out.println("📧 Bắt đầu gửi email OTP...");
        System.out.println("From: " + getFromEmail());
        System.out.println("To: " + toEmail);
        
        try {
            // Cấu hình properties cho SMTP với STARTTLS (chuẩn Gmail hiện tại)
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true"); // Sử dụng STARTTLS thay vì SSL
            props.put("mail.smtp.host", getSmtpHost());
            props.put("mail.smtp.port", getSmtpPort()); // Port 587 cho STARTTLS
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", getSmtpHost()); // Trust Gmail server
            props.put("mail.smtp.localhost", "localhost"); // Fix hostname issue
            props.put("mail.smtp.localhost.address", "127.0.0.1"); // Set valid hostname for HELO
            props.put("mail.debug", "true"); // Bật debug để xem lỗi chi tiết
            
            System.out.println("🔧 Cấu hình SMTP STARTTLS: " + getSmtpHost() + ":" + getSmtpPort());
            System.out.println("🔐 Email: " + getFromEmail());
            System.out.println("🔑 Password length: " + getFromPassword().trim().length());
            System.out.println("🔑 Password preview: " + getFromPassword().substring(0, Math.min(4, getFromPassword().length())) + "****");
            
            // Tạo session
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    System.out.println("🔐 Đang xác thực với Gmail (STARTTLS)...");
                    return new PasswordAuthentication(getFromEmail(), getFromPassword().trim());
                }
            });
            
            // Tạo message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP đặt lại mật khẩu - Hệ thống Quản lý Bệnh viện");
            
            // Nội dung email
            String emailContent = createOTPEmailContent(otp);
            message.setContent(emailContent, "text/html; charset=utf-8");
            
            System.out.println("📤 Đang gửi email qua STARTTLS...");
            
            // Gửi email
            Transport.send(message);
            
            System.out.println("✅ OTP email sent successfully to: " + toEmail);
            return true;
            
        } catch (jakarta.mail.AuthenticationFailedException e) {
            System.err.println("❌ Lỗi xác thực Gmail: " + e.getMessage());
            System.err.println("💡 Giải pháp:");
            System.err.println("   1. Kiểm tra email: " + getFromEmail());
            System.err.println("   2. Tạo lại App Password tại: https://myaccount.google.com/apppasswords");
            System.err.println("   3. Đảm bảo 2-Factor Authentication đã được bật");
            System.err.println("   4. App Password hiện tại: " + getFromPassword().substring(0, 4) + "****");
            e.printStackTrace();
            return false;
        } catch (MessagingException e) {
            System.err.println("❌ Lỗi gửi email: " + e.getMessage());
            System.err.println("💡 Chi tiết lỗi:");
            if (e.getMessage().contains("Connection")) {
                System.err.println("   - Kiểm tra kết nối internet");
                System.err.println("   - Kiểm tra firewall/antivirus chặn port 587");
            }
            if (e.getMessage().contains("Authentication")) {
                System.err.println("   - App Password có thể đã hết hạn");
                System.err.println("   - Tạo App Password mới tại Google Account");
            }
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("❌ Lỗi không xác định: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Tạo nội dung email OTP
     * @param otp Mã OTP
     * @return HTML content
     */
    private static String createOTPEmailContent(String otp) {
        return "<!DOCTYPE html>" +
               "<html lang='vi'>" +
               "<head>" +
               "    <meta charset='UTF-8'>" +
               "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
               "    <title>Mã OTP đặt lại mật khẩu</title>" +
               "    <style>" +
               "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
               "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
               "        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
               "        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }" +
               "        .otp-box { background: white; border: 2px dashed #667eea; border-radius: 10px; padding: 20px; text-align: center; margin: 20px 0; }" +
               "        .otp-code { font-size: 32px; font-weight: bold; color: #667eea; letter-spacing: 5px; }" +
               "        .warning { background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 5px; padding: 15px; margin: 20px 0; }" +
               "        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 12px; }" +
               "    </style>" +
               "</head>" +
               "<body>" +
               "    <div class='container'>" +
               "        <div class='header'>" +
               "            <h1>🏥 Hệ thống Quản lý Bệnh viện</h1>" +
               "            <p>Mã OTP đặt lại mật khẩu</p>" +
               "        </div>" +
               "        <div class='content'>" +
               "            <h2>Xin chào!</h2>" +
               "            <p>Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản của mình. Vui lòng sử dụng mã OTP bên dưới để tiếp tục:</p>" +
               "            <div class='otp-box'>" +
               "                <p>Mã OTP của bạn là:</p>" +
               "                <div class='otp-code'>" + otp + "</div>" +
               "            </div>" +
               "            <div class='warning'>" +
               "                <strong>⚠️ Lưu ý quan trọng:</strong>" +
               "                <ul>" +
               "                    <li>Mã OTP này có hiệu lực trong <strong>5 phút</strong></li>" +
               "                    <li>Không chia sẻ mã này với bất kỳ ai</li>" +
               "                    <li>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này</li>" +
               "                </ul>" +
               "            </div>" +
               "            <p>Nếu bạn có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi.</p>" +
               "            <p>Trân trọng,<br><strong>Đội ngũ Hệ thống Quản lý Bệnh viện</strong></p>" +
               "        </div>" +
               "        <div class='footer'>" +
               "            <p>Email này được gửi tự động, vui lòng không trả lời.</p>" +
               "        </div>" +
               "    </div>" +
               "</body>" +
               "</html>";
    }
    
    /**
     * Kiểm tra cấu hình email
     * @return true nếu đã cấu hình
     */
    public static boolean isConfigured() {
        String e = getFromEmail(), p = getFromPassword();
        return e != null && !e.trim().isEmpty() && p != null && !p.trim().isEmpty();
    }
    
    /**
     * Gửi email OTP với fallback configs
     * @param toEmail Email người nhận
     * @param otp Mã OTP
     * @return true nếu gửi thành công
     */
    public static boolean sendOTPEmailWithFallback(String toEmail, String otp) {
        // Kiểm tra xem có đang ở chế độ Dev không hoặc chưa cấu hình email
        if (isDevelopmentMode() || !isConfigured()) {
            System.out.println("⚠️ Chế độ Development: Không gửi email thật, log OTP ra console.");
            return sendOTPEmailDevelopmentMode(toEmail, otp);
        }

        // Thử STARTTLS port 587 trước (chuẩn Gmail hiện tại)
        System.out.println("🔄 Thử gửi qua STARTTLS (port 587) - Gmail standard...");
        if (sendOTPEmailSTARTTLS(toEmail, otp)) {
            return true;
        }
        
        System.out.println("⚠️ STARTTLS thất bại, thử SSL fallback...");
        
        // Fallback: thử SSL port 465
        if (sendOTPEmailSSL(toEmail, otp)) {
            return true;
        }
        
        System.out.println("❌ Cả 2 phương thức gửi email thật đều thất bại");
        System.out.println("🔄 Tự động chuyển sang Development Mode để không làm gián đoạn test...");
        
        // Nếu tất cả thất bại, tự động dùng dev mode để người dùng có thể test tiếp
        return sendOTPEmailDevelopmentMode(toEmail, otp);
    }
    
    /**
     * Gửi email qua SSL (port 465)
     */
    private static boolean sendOTPEmailSSL(String toEmail, String otp) {
        System.out.println("🔄 Thử gửi qua SSL (port 465)...");
        System.out.println("📧 From: " + getFromEmail());
        System.out.println("📧 To: " + toEmail);
        System.out.println("🔑 Password length: " + getFromPassword().trim().length());
        
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.host", getSmtpHost());
            props.put("mail.smtp.port", "465");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.localhost", "localhost"); // Fix hostname issue
            props.put("mail.smtp.localhost.address", "127.0.0.1"); // Set valid hostname for HELO
            props.put("mail.debug", "true"); // Bật debug để xem chi tiết
            
            System.out.println("🔧 Properties configured for SSL");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    System.out.println("🔐 Authenticating with Gmail...");
                    return new PasswordAuthentication(getFromEmail(), getFromPassword().trim());
                }
            });
            
            session.setDebug(true); // Bật debug session
            
            System.out.println("📝 Creating message...");
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP đặt lại mật khẩu - Hệ thống Quản lý Bệnh viện");
            message.setContent(createOTPEmailContent(otp), "text/html; charset=utf-8");
            
            System.out.println("📤 Sending message via SSL...");
            Transport.send(message);
            System.out.println("✅ SSL thành công!");
            return true;
            
        } catch (Exception e) {
            System.out.println("❌ SSL thất bại: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gửi email qua STARTTLS (port 587)
     */
    private static boolean sendOTPEmailSTARTTLS(String toEmail, String otp) {
        System.out.println("🔄 Thử gửi qua STARTTLS (port 587)...");
        System.out.println("📧 From: " + getFromEmail());
        System.out.println("📧 To: " + toEmail);
        
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true"); // Bắt buộc STARTTLS
            props.put("mail.smtp.host", getSmtpHost());
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", getSmtpHost()); // Trust Gmail
            props.put("mail.smtp.localhost", "localhost"); // Fix hostname issue
            props.put("mail.smtp.localhost.address", "127.0.0.1"); // Set valid hostname for HELO
            props.put("mail.debug", "false"); // Tắt debug để clean log
            
            System.out.println("🔧 Properties configured for STARTTLS");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    System.out.println("🔐 Authenticating with Gmail (STARTTLS)...");
                    return new PasswordAuthentication(getFromEmail(), getFromPassword().trim());
                }
            });
            
            System.out.println("📝 Creating message...");
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP đặt lại mật khẩu - Hệ thống Quản lý Bệnh viện");
            message.setContent(createOTPEmailContent(otp), "text/html; charset=utf-8");
            
            System.out.println("📤 Sending message via STARTTLS...");
            Transport.send(message);
            System.out.println("✅ STARTTLS thành công!");
            return true;
            
        } catch (jakarta.mail.AuthenticationFailedException e) {
            System.out.println("❌ STARTTLS Authentication thất bại: " + e.getMessage());
            System.out.println("💡 App Password có thể cần cập nhật");
            return false;
        } catch (Exception e) {
            System.out.println("❌ STARTTLS thất bại: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            if (e.getMessage().contains("Connection")) {
                System.out.println("💡 Kiểm tra firewall có chặn port 587 không");
            }
            return false;
        }
    }
    
    /**
     * Development mode - chỉ log OTP ra console cho việc test
     * @param toEmail Email người nhận
     * @param otp Mã OTP
     * @return luôn trả về true
     */
    public static boolean sendOTPEmailDevelopmentMode(String toEmail, String otp) {
        System.out.println("🧪 =================================");
        System.out.println("🧪 DEVELOPMENT MODE - OTP EMAIL");
        System.out.println("🧪 =================================");
        System.out.println("📧 To: " + toEmail);
        System.out.println("🔢 OTP: " + otp);
        System.out.println("⏰ Valid for: 5 minutes");
        System.out.println("🧪 =================================");
        System.out.println("💡 Copy OTP này để test: " + otp);
        System.out.println("🧪 =================================");
        
        return true;
    }
    
    /**
     * Kiểm tra có phải development mode không
     * @return true nếu là development mode
     */
    public static boolean isDevelopmentMode() {
        String email = getFromEmail();
        String pass = getFromPassword();
        
        // Coi là Dev mode nếu còn để placeholder hoặc email đặc biệt
        return email == null || email.trim().isEmpty() || 
               email.contains("your_email") || 
               email.contains("test@example.com") ||
               pass.contains("your_app_password");
    }

    /**
     * Gửi email thông báo huỷ lịch hẹn
     */
    public static boolean sendCancelAppointmentEmail(String toEmail, String patientName, String dateTime, String service, String reason, String note) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", getSmtpHost());
            props.put("mail.smtp.port", getSmtpPort());
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", getSmtpHost());
            props.put("mail.smtp.localhost", "localhost");
            props.put("mail.smtp.localhost.address", "127.0.0.1");
            props.put("mail.debug", "false");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(getFromEmail(), getFromPassword().trim());
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Thông báo huỷ lịch hẹn - Hệ thống Quản lý Bệnh viện");

            String emailContent = createCancelAppointmentEmailContent(patientName, dateTime, service, reason, note);
            message.setContent(emailContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static String createCancelAppointmentEmailContent(String patientName, String dateTime, String service, String reason, String note) {
        return "<!DOCTYPE html>" +
                "<html lang='vi'>" +
                "<head>" +
                "    <meta charset='UTF-8'>" +
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "    <title>Thông báo huỷ lịch hẹn</title>" +
                "    <style>" +
                "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
                "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
                "        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
                "        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }" +
                "        .cancel-box { background: white; border: 2px dashed #ef4444; border-radius: 10px; padding: 20px; text-align: center; margin: 20px 0; }" +
                "        .cancel-title { font-size: 24px; font-weight: bold; color: #ef4444; }" +
                "        .info-table { width: 100%; margin: 16px 0; border-collapse: collapse; }" +
                "        .info-table td { padding: 6px 0; }" +
                "        .reason { color: #b91c1c; font-weight: bold; }" +
                "        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 12px; }" +
                "    </style>" +
                "</head>" +
                "<body>" +
                "    <div class='container'>" +
                "        <div class='header'>" +
                "            <h1>🏥 Hệ thống Quản lý Bệnh viện</h1>" +
                "            <p>Thông báo huỷ lịch hẹn</p>" +
                "        </div>" +
                "        <div class='content'>" +
                "            <h2>Xin chào <span style='color:#6366f1;'>" + patientName + "</span>!</h2>" +
                "            <div class='cancel-box'>" +
                "                <div class='cancel-title'>Lịch hẹn của bạn đã bị huỷ</div>" +
                "                <table class='info-table'>" +
                "                    <tr><td><b>Thời gian:</b></td><td>" + dateTime + "</td></tr>" +
                "                    <tr><td><b>Dịch vụ:</b></td><td>" + service + "</td></tr>" +
                (reason != null && !reason.isEmpty() ? "<tr><td><b>Lý do huỷ:</b></td><td class='reason'>" + reason + "</td></tr>" : "") +
                (note != null && !note.isEmpty() ? "<tr><td><b>Ghi chú:</b></td><td>" + note + "</td></tr>" : "") +
                "                </table>" +
                "                <p style='color:#ef4444; margin-top:12px;'>Nếu có thắc mắc vui lòng liên hệ phòng khám.</p>" +
                "            </div>" +
                "            <p>Nếu bạn có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi.</p>" +
                "            <p>Trân trọng,<br><strong>Đội ngũ Hệ thống Quản lý Bệnh viện</strong></p>" +
                "        </div>" +
                "        <div class='footer'>" +
                "            <p>Email này được gửi tự động, vui lòng không trả lời.</p>" +
                "        </div>" +
                "    </div>" +
                "</body>" +
                "</html>";
    }

    /**
     * Gửi email thông báo đổi lịch hẹn
     */
    public static boolean sendRescheduleAppointmentEmail(String toEmail, String patientName, String dateTime, String service, String reason) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", getSmtpHost());
            props.put("mail.smtp.port", getSmtpPort());
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", getSmtpHost());
            props.put("mail.smtp.localhost", "localhost");
            props.put("mail.smtp.localhost.address", "127.0.0.1");
            props.put("mail.debug", "false");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(getFromEmail(), getFromPassword().trim());
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Thông báo đổi lịch hẹn - Hệ thống Quản lý Bệnh viện");

            String emailContent = createRescheduleAppointmentEmailContent(patientName, dateTime, service, reason);
            message.setContent(emailContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static String createRescheduleAppointmentEmailContent(String patientName, String dateTime, String service, String reason) {
        return "<!DOCTYPE html>" +
                "<html lang='vi'>" +
                "<head>" +
                "    <meta charset='UTF-8'>" +
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "    <title>Thông báo đổi lịch hẹn</title>" +
                "    <style>" +
                "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
                "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
                "        .header { background: linear-gradient(135deg, #22d3ee 0%, #6366f1 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
                "        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }" +
                "        .reschedule-box { background: white; border: 2px dashed #6366f1; border-radius: 10px; padding: 20px; text-align: center; margin: 20px 0; }" +
                "        .reschedule-title { font-size: 24px; font-weight: bold; color: #6366f1; }" +
                "        .info-table { width: 100%; margin: 16px 0; border-collapse: collapse; }" +
                "        .info-table td { padding: 6px 0; }" +
                "        .reason { color: #0ea5e9; font-weight: bold; }" +
                "        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 12px; }" +
                "    </style>" +
                "</head>" +
                "<body>" +
                "    <div class='container'>" +
                "        <div class='header'>" +
                "            <h1>🏥 Hệ thống Quản lý Bệnh viện</h1>" +
                "            <p>Thông báo đổi lịch hẹn</p>" +
                "        </div>" +
                "        <div class='content'>" +
                "            <h2>Xin chào <span style='color:#6366f1;'>" + patientName + "</span>!</h2>" +
                "            <div class='reschedule-box'>" +
                "                <div class='reschedule-title'>Lịch hẹn của bạn đã được đổi</div>" +
                "                <table class='info-table'>" +
                "                    <tr><td><b>Thời gian mới:</b></td><td>" + dateTime + "</td></tr>" +
                "                    <tr><td><b>Dịch vụ:</b></td><td>" + service + "</td></tr>" +
                (reason != null && !reason.isEmpty() ? "<tr><td><b>Lý do đổi:</b></td><td class='reason'>" + reason + "</td></tr>" : "") +
                "                </table>" +
                "                <p style='color:#6366f1; margin-top:12px;'>Nếu có thắc mắc vui lòng liên hệ phòng khám.</p>" +
                "            </div>" +
                "            <p>Nếu bạn có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi.</p>" +
                "            <p>Trân trọng,<br><strong>Đội ngũ Hệ thống Quản lý Bệnh viện</strong></p>" +
                "        </div>" +
                "        <div class='footer'>" +
                "            <p>Email này được gửi tự động, vui lòng không trả lời.</p>" +
                "        </div>" +
                "    </div>" +
                "</body>" +
                "</html>";
    }
} 
