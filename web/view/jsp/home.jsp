<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HAPPY Smile - Phòng khám nha khoa tư nhân chuyên nghiệp</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/home.css">
    </head>

    <body>
        <%@ include file="/view/layout/header.jsp" %>

        <section class="hero" id="hero">
            <div class="hero-content">
                <h2 data-lang="hero-subtitle">Phòng khám nha khoa</h2>
                <h3 data-lang="hero-title">HAPPY SMILE</h3>
            </div>
        </section>

        <section class="about" id="about">
            <h3 data-lang="about-title">CHÚNG TÔI LÀ AI?</h3>
            <div class="about-content">
                <div class="about-text">
                    <p data-lang="about-text-1">HAPPY Smile là phòng khám nha khoa tư nhân chuyên nghiệp tại Việt
                        Nam, với sứ mệnh mang đến dịch vụ chăm sóc răng miệng chất lượng cao và nụ cười khỏe mạnh
                        cho mọi khách hàng.</p>
                    <p data-lang="about-text-2">Với đội ngũ bác sĩ giàu kinh nghiệm, được đào tạo bài bản trong và
                        ngoài nước, cùng trang thiết bị hiện đại, chúng tôi cam kết mang đến những phương pháp điều
                        trị tiên tiến và hiệu quả nhất.</p>
                    <p data-lang="about-text-3">Tại HAPPY Smile, chúng tôi không chỉ chữa trị các vấn đề răng miệng
                        mà còn hướng đến việc phòng ngừa, tư vấn và chăm sóc sức khỏe răng miệng lâu dài cho khách
                        hàng.</p>
                    <p data-lang="about-text-4">Hãy đến với chúng tôi để trải nghiệm dịch vụ nha khoa chất lượng
                        trong một không gian thoải mái, thân thiện và chuyên nghiệp.</p>
                </div>
                <div class="about-image">
                    <img src="${pageContext.request.contextPath}/view/assets/img/bacsii.png"
                         alt="Phòng khám HAPPY Smile">
                </div>
            </div>
        </section>

        <section class="services" id="services">
            <h3 data-lang="services-title">DỊCH VỤ NHA KHOA</h3>
            <div class="service-container">
                <div class="service-row">
                    <div class="service-item">
                        <img src="${pageContext.request.contextPath}/view/assets/img/icon1.jpg" alt="Khám tổng quát"
                             class="service-icon">
                        <p data-lang="service-general-checkup">Khám tổng quát</p>
                    </div>
                    <div class="service-item">
                        <img src="${pageContext.request.contextPath}/view/assets/img/icon2.jpg" alt="Trám răng"
                             class="service-icon">
                        <p data-lang="service-filling">Trám răng</p>
                    </div>
                    <div class="service-item">
                        <img src="${pageContext.request.contextPath}/view/assets/img/icon3.jpg" alt="Tẩy trắng răng"
                             class="service-icon">
                        <p data-lang="service-whitening">Tẩy trắng răng</p>
                    </div>
                    <div class="service-item">
                        <img src="${pageContext.request.contextPath}/view/assets/img/icon4.jpg" alt="Bọc răng sứ"
                             class="service-icon">
                        <p data-lang="service-veneers">Bọc răng sứ</p>
                    </div>
                </div>
                <div class="service-row">
                    <div class="service-item">
                        <img src="${pageContext.request.contextPath}/view/assets/img/icon5.jpg" alt="Niềng răng"
                             class="service-icon">
                        <p data-lang="service-braces">Niềng răng</p>
                    </div>
                    <div class="service-item">
                        <img src="${pageContext.request.contextPath}/view/assets/img/icon6.jpg" alt="Nhổ răng"
                             class="service-icon">
                        <p data-lang="service-extraction">Nhổ răng</p>
                    </div>
                    <div class="service-item">
                        <img src="${pageContext.request.contextPath}/view/assets/img/icon7.jpg"
                             alt="Cấy ghép implant" class="service-icon">
                        <p data-lang="service-implant">Cấy ghép implant</p>
                    </div>
                    <div class="service-item">
                        <img src="${pageContext.request.contextPath}/view/assets/img/icon8.jpg"
                             alt="Điều trị nha chu" class="service-icon">
                        <p data-lang="service-periodontal">Điều trị nha chu</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="team" id="team">
            <h3 data-lang="team-title">ĐỘI NGŨ BÁC SĨ</h3>
            <div class="team-slider">
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="${pageContext.request.contextPath}/view/assets/img/bacsi1.png"
                             alt="Bác sĩ Nguyễn Văn A">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Nguyễn Văn A</h4>
                        <p data-lang="doctor-implant">Chuyên gia Implant</p>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="${pageContext.request.contextPath}/view/assets/img/bacsi2.png"
                             alt="Bác sĩ Trần Thị B">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Trần Thị B</h4>
                        <p data-lang="doctor-orthodontics">Chuyên gia Chỉnh nha</p>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="${pageContext.request.contextPath}/view/assets/img/bacsi3.png"
                             alt="Bác sĩ Lê Văn C">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Lê Văn C</h4>
                        <p data-lang="doctor-restoration">Chuyên gia Phục hình</p>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="${pageContext.request.contextPath}/view/assets/img/bacsi4.png"
                             alt="Bác sĩ Phạm Thị D">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Phạm Thị D</h4>
                        <p data-lang="doctor-periodontal">Chuyên gia Nha chu</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="testimonials">
            <h3 data-lang="testimonials-title">CẢM NHẬN TỪ KHÁCH HÀNG</h3>
            <div class="testimonial-slider">
                <div class="testimonial-card">
                    <p class="testimonial-text" data-lang="testimonial-1">Tôi đã điều trị niềng răng tại HAPPY Smile
                        và rất hài lòng với kết quả. Các bác sĩ rất tận tâm, tư vấn chi tiết và quá trình điều trị
                        rất chuyên nghiệp. Giờ đây tôi có thể tự tin cười mà không cần phải che miệng nữa.</p>
                    <div class="testimonial-author">
                        <div class="author-info">
                            <h4>Nguyễn Thị Minh</h4>
                            <p data-lang="testimonial-author-1">Khách hàng niềng răng</p>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card">
                    <p class="testimonial-text" data-lang="testimonial-2">Dịch vụ bọc răng sứ tại HAPPY Smile thực
                        sự xuất sắc. Bác sĩ tư vấn rất tỉ mỉ, lựa chọn loại răng sứ phù hợp với gương mặt tôi. Kết
                        quả vượt ngoài mong đợi, trông rất tự nhiên và đẹp. Tôi sẽ giới thiệu bạn bè đến đây.</p>
                    <div class="testimonial-author">
                        <div class="author-info">
                            <h4>Trần Văn Hoàng</h4>
                            <p data-lang="testimonial-author-2">Khách hàng bọc răng sứ</p>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card">
                    <p class="testimonial-text" data-lang="testimonial-3">Mình thường xuyên đến HAPPY Smile để khám
                        và vệ sinh răng định kỳ. Môi trường phòng khám sạch sẽ, hiện đại và thân thiện. Các bác sĩ
                        và nhân viên rất chuyên nghiệp và chu đáo. Chất lượng dịch vụ xứng đáng với giá tiền.</p>
                    <div class="testimonial-author">
                        <div class="author-info">
                            <h4>Võ Hoàng Gia Linh</h4>
                            <p data-lang="testimonial-author-3">Khách hàng thường xuyên</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="news" id="news">
            <h3 data-lang="news-title">TIN TỨC NHA KHOA</h3>
            <div class="news-grid">
                <div class="news-card">
                    <div class="news-image">
                        <img src="${pageContext.request.contextPath}/view/assets/img/tintuc1.png"
                             alt="Cách chăm sóc răng miệng">
                    </div>
                    <div class="news-content">
                        <div class="news-date">17/05/2025</div>
                        <h4 class="news-title" data-lang="news-title-1">TOP 11 cách chăm sóc răng miệng hiệu quả,
                            cho răng khỏe đẹp</h4>
                        <p class="news-excerpt" data-lang="news-excerpt-1">Chăm sóc răng miệng đúng cách không chỉ
                            giúp bạn có hàm răng trắng sáng mà còn phòng ngừa nhiều bệnh lý...</p>
                        <a href="https://elitedental.com.vn/top-cac-cach-cham-soc-rang-mieng-hieu-qua-cho-rang-khoe-dep.html"
                           class="news-link" data-lang="read-more">Xem thêm</a>
                    </div>
                </div>
                <div class="news-card">
                    <div class="news-image">
                        <img src="${pageContext.request.contextPath}/view/assets/img/tintuc2.jpg"
                             alt="Niềng răng trong suốt">
                    </div>
                    <div class="news-content">
                        <div class="news-date">10/05/2025</div>
                        <h4 class="news-title" data-lang="news-title-2">Những điều cần biết về niềng răng trong suốt
                        </h4>
                        <p class="news-excerpt" data-lang="news-excerpt-2">Niềng răng trong suốt đang là xu hướng
                            được nhiều người lựa chọn nhờ tính thẩm mỹ cao và thuận tiện...</p>
                        <a href="https://medlatec.vn/tin-tuc/nieng-rang-trong-suot--uu-nhuoc-diem-va-nhung-dieu-can-luu-y-s99-n31947"
                           class="news-link" data-lang="read-more">Xem thêm</a>
                    </div>
                </div>
                <div class="news-card">
                    <div class="news-image">
                        <img src="${pageContext.request.contextPath}/view/assets/img/tintuc3.png"
                             alt="Phòng ngừa sâu răng">
                    </div>
                    <div class="news-content">
                        <div class="news-date">05/05/2025</div>
                        <h4 class="news-title" data-lang="news-title-3">Phòng ngừa sâu răng cho trẻ em hiệu quả</h4>
                        <p class="news-excerpt" data-lang="news-excerpt-3">Trẻ em là đối tượng dễ bị sâu răng. Hãy
                            cùng tìm hiểu các biện pháp phòng ngừa sâu răng hiệu quả...</p>
                        <a href="https://elitedental.com.vn/doctors/nguyen-thi-xuan-ngoc" class="news-link"
                           data-lang="read-more">Xem thêm</a>
                    </div>
                </div>
            </div>
        </section>

        <section class="contact" id="contact">
            <h2 data-lang="contact-title">ĐỊA CHỈ - THÔNG TIN - LIÊN HỆ</h2>
            <p data-lang="contact-address">Khu đô thị FPT City, Ngũ Hành Sơn, Đà Nẵng, Việt Nam</p>
            <div class="contact-container">
                <div class="map">
                    <iframe
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3835.738711613779!2d108.25104871463337!3d15.978921588939292!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3142108997dc971f%3A0x1295cb3d313469c9!2zVHLGsOG7nW5gIMSQ4bqhaSBo4buNYyBGUFQgxJDJoCBO4bq1bmc!5e0!3m2!1svi!2s!4v1650010000000!5m2!1svi!2s"
                        allowfullscreen="" loading="lazy"></iframe>
                </div>
                <div class="contact-info">
                    <h3 data-lang="contact-info-title">NHA KHOA HAPPY SMILE</h3>
                    <hr>
                    <p class="highlight-hours" data-lang="contact-hours-open">Thời gian <span class="open-text">Mở
                            cửa</span>: Từ thứ 2 đến thứ 7, 7:00 AM - 6:00 PM</p>
                    <p class="highlight-hours" data-lang="contact-hours-closed">Thời gian nghỉ trong tuần: Chủ nhật
                        <span class="closed-text">Đóng cửa</span>
                    </p>
                    <hr>
                    <a href="#" class="contact-btn" data-lang="contact-btn">Chốt lịch Đồng giá</a>
                </div>
            </div>
            <div class="contact-form">
                <div class="form-group">
                    <label for="name" data-lang="form-name">Họ và tên</label>
                    <input type="text" id="name" class="form-control" placeholder="Họ và tên" required>
                </div>
                <div class="form-group">
                    <label for="email" data-lang="form-email">Email hoặc số điện thoại</label>
                    <input type="text" id="email" class="form-control" placeholder="Email hoặc số điện thoại"
                           required>
                </div>
                <div class="form-group">
                    <label for="gender" data-lang="form-gender">Giới tính</label>
                    <select id="gender" class="form-control" required>
                        <option value="" data-lang="form-gender-select">Chọn giới tính</option>
                        <option value="male" data-lang="form-gender-male">Nam</option>
                        <option value="female" data-lang="form-gender-female">Nữ</option>
                        <option value="other" data-lang="form-gender-other">Khác</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="age" data-lang="form-age">Tuổi</label>
                    <input type="number" id="age" class="form-control" placeholder="Tuổi" required>
                </div>
                <div class="form-group">
                    <label for="message" data-lang="form-message">Nội dung</label>
                    <textarea id="message" class="form-control" placeholder="Nhập nội dung" required></textarea>
                </div>
                <button type="submit" class="submit-btn" data-lang="form-submit">Gửi thông tin</button>
            </div>
        </section>

        <%@ include file="/view/layout/footer.jsp" %>
        <% String _lang = (String) session.getAttribute("language");
                    if (_lang == null)
                        _lang = "vi";%>
        <script>window.__INIT_LANG__ = '<%= _lang%>';</script>
        <script src="${pageContext.request.contextPath}/view/assets/js/home.js"></script>
    </body>

</html>