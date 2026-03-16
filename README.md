# Dental Clinic Management System - PRJ301 (Full System Flows)

Hệ thống quản lý phòng khám nha khoa toàn diện, tích hợp các công nghệ hiện đại phục vụ quản trị và trải nghiệm khách hàng.

---

## 🛠 Công nghệ & Kiến trúc (Tech Stack)
- **Kiến trúc:** Model-View-Controller (MVC).
- **Backend:** Java Servlet, Jakarta EE, JDBC.
- **Frontend:** JSP, Bootstrap 5, Vanilla JS, AJAX (Gson).
- **Database:** SQL Server (Normalized DB).
- **Tích hợp:** 
    - **PayOS:** Cổng thanh toán QR Code tự động.
    - **Google OAuth 2.0:** Đăng nhập một chạm.
    - **n8n Automation:** Tự động gửi Email & đồng bộ Google Calendar.

---

## 🔄 Chi tiết Luồng Nghiệp vụ theo Vai trò (User Roles & Flows)

### 1. BỆNH NHÂN (PATIENT) - Người sử dụng dịch vụ

#### A. Đăng ký & Đăng nhập (Google OAuth 2.0)
*   **Front-end:** Tại `login.jsp`, người dùng chọn "Login with Google". Link chuyển hướng đến Google Auth Server.
*   **Back-end:** 
    *   `GoogleCallbackServlet` tiếp nhận thẻ `code`, trao đổi lấy `AccessToken` và gửi yêu cầu lấy Email/Họ tên từ Google Profiler.
    *   `LoginServlet` kiểm tra Email trong DB. Nếu chưa có tài khoản, tự cập nhật bảng `Users` và `Patients`.
    *   Tạo Session và redirect về `user_homepage.jsp`.

#### B. Đặt lịch & Thanh toán Tự động (Core Flow)
*   **Front-end:** Tại `booking.jsp`, bệnh nhân chọn Bác sĩ/Dịch vụ. 
    *   **AJAX:** Khi chọn ngày, gửi yêu cầu tới `BookingServlet?action=check-slots` để hiển thị các Slot giờ còn trống (màu xanh).
*   **Back-end (Giữ chỗ):** Khi chọn Slot, `BookingServlet` gọi `AppointmentDAO.createReservation` để "tạm khóa" slot trong 5 phút.
*   **Thanh toán:** 
    *   `PayOSServlet` được gọi để tạo Payment Link. Người dùng quét mã QR để trả phí giữ chỗ (50k hoặc tùy cấu hình).
    *   Khi thanh toán thành công, PayOS gọi về Webhook `/payment?action=success`.
    *   Hệ thống chuyển trạng thái Bill thành `PAID` và Appointment thành `BOOKED`.
*   **Automation:** `N8nWebhookService` đẩy dữ liệu sang n8n để gửi Email xác nhận và tự động chèn lịch vào Google Calendar cho cả Bác sĩ & Bệnh nhân.

---

### 2. BÁC SĨ (DOCTOR) - Người chuyên môn

#### A. Quản lý Lịch làm việc
*   **Front-end:** Bác sĩ đăng ký các ca trực (Morning/Afternoon) trong tuần tại giao diện đăng ký lịch.
*   **Back-end:** `DoctorRegisterScheduleServlet` lưu yêu cầu vào bảng `DoctorSchedules` với trạng thái `PENDING` chờ Manager duyệt.

#### B. Quy trình Khám bệnh & Hồ sơ bệnh án
*   **Front-end:** Bác sĩ xem danh sách bệnh nhân đã Check-in trong hàng đợi. Nhấn "Khám bệnh".
*   **Back-end (Load):** `CreateMedicalReportServlet` lấy thông tin chi tiết bệnh nhân, tiền sử bệnh và forward sang `doctor_phieukham.jsp`.
*   **Front-end (Submit):** Bác sĩ nhập Chẩn đoán, Triệu chứng, Kê đơn thuốc và chỉ định Dịch vụ điều trị.
*   **Back-end (Save):** `SubmitMedicalReportServlet` thực hiện luồng:
    1.  Lưu thông tin chẩn đoán vào `MedicalReports`.
    2.  Lưu danh mục thuốc/dịch vụ vào `TreatmentDetails`.
    3.  Cập nhật trạng thái Appointment sang `COMPLETED`.

---

### 3. NHÂN VIÊN (STAFF) - Người vận hành

#### A. Tiếp đón & Điều phối Hàng đợi
*   **Front-end:** Nhân viên xem danh sách bệnh nhân đã đặt lịch trong ngày tại Dashboard Staff.
*   **Back-end:** `StaffHandleQueueServlet` xử lý việc "Check-in" khi bệnh nhân có mặt tại phòng khám, chuyển trạng thái từ `BOOKED` sang `WAITING`.

#### B. Quản lý Hóa đơn & Trả góp (Installment)
*   **Front-end:** Tại `staff_thanhtoan.jsp`, nhân viên tạo hóa đơn cho bệnh nhân khám trực tiếp hoặc dịch vụ phát sinh.
*   **Xử lý Trả góp:**
    *   Nếu bệnh nhân muốn trả góp cho dịch vụ lớn, nhân viên chọn "Installment".
    *   **Back-end:** `StaffPaymentServlet` gọi `PaymentInstallmentDAO` để chia nhỏ số tiền thành các kỳ hạn thanh toán.
    *   Tự động theo dõi dư nợ và ngày thanh toán định kỳ.

---

### 4. QUẢN LÝ (MANAGER) - Người giám sát

#### A. Phê duyệt Lịch trực
*   **Front-end:** Manager xem danh sách đăng ký trực tuần của Bác sĩ/Nhân viên tại `manager_phancong.jsp`.
*   **Back-end:** `ManagerApprovalDoctorSchedulerServlet` xử lý Duyệt/Từ chối. Chỉ lịch đã duyệt mới hiện lên trang Đặt lịch của bệnh nhân.

#### B. Quản lý Nhân sự & Kho thuốc
*   **Cửa sổ:** Quản lý tài khoản (Add/Delete Staff/Doctor) qua `AddStaffServlet` và `DeleteStaffServlet`.
*   **Kho thuốc:** Cập nhật danh mục thuốc, giá dịch vụ điều trị qua các Servlet chuyên biệt như `AddMedicineServlet`.

---

## 📊 Bảng ánh xạ Kỹ thuật (Technical Mapping)

| Vai trò | Chức năng chính | Servlet Xử lý | DAO Liên quan |
| :--- | :--- | :--- | :--- |
| **Patient** | Đăng nhập Google | `GoogleCallbackServlet` | `UserDAO` |
| **Patient** | Đặt lịch & Thanh toán | `BookingServlet`, `PayOSServlet` | `AppointmentDAO`, `BillDAO` |
| **Doctor** | Khám bệnh & Kê đơn | `CreateMedicalReportServlet` | `MedicalReportDAO` |
| **Staff** | Quản lý Hàng đợi | `StaffHandleQueueServlet` | `AppointmentDAO` |
| **Staff** | Thanh toán Trả góp | `StaffPaymentServlet` | `PaymentInstallmentDAO` |
| **Manager** | Phê duyệt Lịch | `ManagerApprovalDoctorSchedulerServlet` | `ScheduleDAO` |
| **System** | Tự động hóa n8n | `N8nWebhookService` | (Utility Class) |

---

## 📂 Toàn cảnh Cấu trúc mã nguồn
- `controller/auth`: Bảo mật, OTP, Google OAuth.
- `controller/appointment`: Quy trình đặt lịch, giữ chỗ.
- `controller/payment`: Hóa đơn, PayOS, Trả góp.
- `controller/treatment`: Phiếu khám, Bệnh án điện tử.
- `controller/admin`: Quản lý nhân sự của Manager.
- `controller/schedule`: Đăng ký và duyệt lịch trực.

---
*Tài liệu hướng dẫn hệ thống được cập nhật tự động bởi Antigravity.*
