# CẤU TRÚC DỰ ÁN PRJ301 - DENTAL CLINIC

## 📁 CẤU TRÚC CHUẨN PRJ301 (MVC)

Dự án đã được refactor theo chuẩn **PRJ301 MVC** với tổ chức theo **vai trò** (role-based organization).

---

## 🗂️ BACKEND STRUCTURE

### 1. Model Layer (`src/java/model/`)

**Cấu trúc phẳng** - tất cả entity files nằm trực tiếp trong `model/`:

```
src/java/model/
├── User.java
├── Patients.java
├── Doctors.java
├── Staff.java
├── Manager.java
├── Appointment.java
├── DoctorSchedule.java
├── StaffSchedule.java
├── TimeSlot.java
├── SlotReservation.java
├── Service.java
├── Specialty.java
├── Medicine.java
├── Prescription.java
├── PrescriptionDetail.java
├── Bill.java
├── BillService.java
├── PaymentInfo.java
├── PaymentInstallment.java
├── MedicalReport.java
├── Notification.java
├── NotificationTemplate.java
├── BlogPost.java
└── ChatMessage.java
```

**Package:** `package model;`

---

### 2. DAO Layer (`src/java/dao/`)

**Cấu trúc phẳng** - tất cả DAO files:

```
src/java/dao/
├── DBContext.java              # Database connection
├── UserDAO.java
├── PatientDAO.java
├── DoctorDAO.java
├── StaffDAO.java
├── ManagerDAO.java
├── AppointmentDAO.java
├── DoctorScheduleDAO.java
├── StaffScheduleDAO.java
├── TimeSlotDAO.java
├── ServiceDAO.java
├── ServicePriceDAO.java
├── SpecialtyDAO.java
├── MedicineDAO.java
├── BillDAO.java
├── PaymentInstallmentDAO.java
├── NotificationDAO.java
├── NotificationTemplateDAO.java
├── BlogDAO.java
├── FaceImageDAO.java
├── RelativesDAO.java
└── RelativesAppointmentDAO.java
```

---

### 3. Controller Layer (`src/java/controller/`)

**Tổ chức theo chức năng** (functional modules):

```
src/java/controller/
├── auth/                       # Authentication (10 servlets)
│   ├── LoginServlet.java
│   ├── LogoutServlet.java
│   ├── RegisterServlet.java
│   ├── SignUpServlet.java
│   ├── RegisterInformation.java
│   ├── ChangePasswordServlet.java
│   ├── ResetPasswordServlet.java
│   ├── UpdatePasswordServlet.java
│   ├── FaceIdLoginServlet.java
│   └── GoogleCallbackServlet.java
│
├── appointment/                # Appointment management (16 servlets)
│   ├── BookingPageServlet.java
│   ├── BookingServlet.java
│   ├── PatientAppointmentsServlet.java
│   ├── DoctorAppointmentsServlet.java
│   ├── CancelAppointmentServlet.java
│   ├── RescheduleAppointmentServlet.java
│   ├── ConfirmServlet.java
│   ├── ReexaminationServlet.java
│   ├── StaffBookingServlet.java
│   ├── StaffHandleQueueServlet.java
│   └── ...
│
├── payment/                    # Payment processing (5 servlets)
│   ├── PayOSServlet.java
│   ├── StaffPayOSServlet.java
│   ├── PaymentConfirmServlet.java
│   ├── CheckBillServlet.java
│   └── CreateBillServlet.java
│
├── profile/                    # User profiles (10 servlets)
│   ├── PatientProfileServlet.java
│   ├── DoctorProfileServlet.java
│   ├── StaffProfileServlet.java
│   ├── LandingPageServlet.java
│   └── ...
│
├── schedule/                   # Schedule management (8 servlets)
│   ├── DoctorScheduleServlet.java
│   ├── StaffScheduleServlet.java
│   └── ...
│
├── treatment/                  # Medical treatment (9 servlets)
│   ├── MedicalRecordServlet.java
│   ├── PrescriptionServlet.java
│   └── ...
│
├── medicine/                   # Medicine sales (2 servlets)
│   ├── StaffSellMedicineServlet.java
│   └── ConfirmSellMedicineServlet.java
│
├── messaging/                  # Chat & Blog (6 servlets)
│   ├── ChatServlet.java
│   ├── ChatAiServlet.java
│   ├── BlogServlet.java
│   └── ...
│
├── admin/                      # Admin management (11 servlets)
│   ├── AddStaffServlet.java
│   ├── DeleteStaffServlet.java
│   ├── EditDoctorServlet.java
│   ├── ManagerCustomerListServlet.java
│   └── ...
│
└── TwilioCallServlet.java     # Twilio integration
```

**Tổng cộng:** 77 servlets

---

## 🎨 FRONTEND STRUCTURE (PRJ301 Standard)

### Cấu trúc mới: `web/view/`

```
web/view/
├── assets/                     # Static resources
│   ├── css/
│   │   ├── dashboard-common.css
│   │   ├── dashboard.css
│   │   ├── home.css
│   │   ├── doctor.css
│   │   ├── manager.css
│   │   ├── staff.css
│   │   └── global-fonts.css
│   │
│   ├── js/
│   │   ├── home.js
│   │   ├── dashboard-common.js
│   │   ├── dashboard-simple.js
│   │   ├── booking_calendar.js
│   │   ├── calendar.js
│   │   ├── calendar_detail.js
│   │   ├── calendar_detail_1.js
│   │   └── reschedule.js
│   │
│   ├── img/
│   │   ├── logo.png
│   │   ├── banner.jpg, banner1.jpg, banner2.jpg
│   │   ├── bacsi.png, bacsi1.png, bacsi2.png, ...
│   │   ├── icon1.jpg ~ icon8.jpg
│   │   ├── dental.png
│   │   ├── default-avatar.png
│   │   └── Landing_Page_Nha_Khoa.mp4
│   │
│   └── font/
│       └── DejaVuSans.ttf
│
├── layout/                     # Layout components
│   ├── header.jsp             # Common header
│   ├── footer.jsp             # Common footer
│   └── sidebar.jsp            # Dashboard sidebar
│
├── error/                      # Error pages
│   ├── 404.jsp                # Not Found
│   ├── 500.jsp                # Server Error
│   └── 403.jsp                # Forbidden
│
└── jsp/                        # Functional JSP pages
    │
    ├── auth/                   # Authentication (7 files)
    │   ├── login.jsp
    │   ├── signup.jsp
    │   ├── forgot-password.jsp
    │   ├── reset-password.jsp
    │   ├── verify-otp.jsp
    │   ├── change-password-profile.jsp
    │   └── information.jsp
    │
    ├── patient/                # Patient pages (14 files)
    │   ├── user_homepage.jsp
    │   ├── user_header.jsp
    │   ├── user_menu.jsp
    │   ├── user_taikhoan.jsp
    │   ├── user_datlich.jsp
    │   ├── user_datlich_bacsi.jsp
    │   ├── user_lichkham.jsp
    │   ├── user_xembaocao.jsp
    │   ├── user_services.jsp
    │   ├── user_tuvan.jsp
    │   ├── user_chatAI.jsp
    │   ├── datlich-thanhcong.jsp
    │   ├── medicalreportdetail.jsp
    │   └── booking/ (components)
    │
    ├── doctor/                 # Doctor pages (25 files)
    │   ├── doctor_homepage.jsp
    │   ├── doctor_header.jsp
    │   ├── doctor_menu.jsp
    │   ├── doctor_tongquan.jsp
    │   ├── doctor_profile.jsp
    │   ├── doctor_appointments.jsp
    │   ├── doctor_trongngay.jsp
    │   ├── doctor_trongtuan.jsp
    │   ├── doctor_lichtrongthang.jsp
    │   ├── doctor_lichdaxacnhan.jsp
    │   ├── doctor_phongcho.jsp
    │   ├── doctor_bihuy.jsp
    │   ├── doctor_dangkilich.jsp
    │   ├── doctor_phieukham.jsp
    │   ├── doctor_thembaocao.jsp
    │   ├── doctor_viewMedicalReport.jsp
    │   ├── doctor_taikham.jsp
    │   ├── doctor_ketqua.jsp
    │   ├── doctor_trochuyen.jsp
    │   ├── doctor_caidat.jsp
    │   ├── doctor_changepassword.jsp
    │   ├── doctor_trangcanhan.jsp
    │   ├── datlich-thanhcong.jsp
    │   ├── success.jsp
    │   └── error_page.jsp
    │
    ├── admin/                  # Admin/Manager/Staff (37 files)
    │   │
    │   ├── Manager pages (16 files):
    │   │   ├── manager_tongquan.jsp
    │   │   ├── manager_header.jsp
    │   │   ├── manager_menu.jsp
    │   │   ├── manager_danhsach.jsp
    │   │   ├── manager_customers.jsp
    │   │   ├── manager_users.jsp
    │   │   ├── manager_doctors.jsp
    │   │   ├── manager_staff.jsp
    │   │   ├── manager_lichtrinh.jsp
    │   │   ├── manager_phancong.jsp
    │   │   ├── manager_medicine.jsp
    │   │   ├── manager_khothuoc.jsp
    │   │   ├── manager_blogs.jsp
    │   │   ├── manager_thongke.jsp
    │   │   ├── manager_doanhthu.jsp
    │   │   └── manager_baocao.jsp
    │   │
    │   └── Staff pages (21 files):
    │       ├── staff_tongquan.jsp
    │       ├── staff_header.jsp
    │       ├── staff_menu.jsp
    │       ├── staff_taikhoan.jsp
    │       ├── staff_datlich.jsp
    │       ├── staff_doilich.jsp
    │       ├── staff_quanlylichhen.jsp
    │       ├── staff_quanlyhangdoibenhnhan.jsp
    │       ├── staff_danhsachbenhnhan.jsp
    │       ├── staff_taohoadon.jsp
    │       ├── staff_thanhtoan.jsp
    │       ├── staff_tragop.jsp
    │       ├── staff_nhacno.jsp
    │       ├── staff_toathuoc.jsp
    │       ├── staff_tuvan.jsp
    │       ├── staff_dangkilich.jsp
    │       ├── staff_xinnghi.jsp
    │       ├── sell_medicine_direct.jsp
    │       ├── confirm_sell_medicine.jsp
    │       ├── sell_success.jsp
    │       └── bill_qr.jsp
    │
    └── home.jsp                # Landing page
```

**Tổng cộng:** 88 JSP files

---

## 🔗 URL MAPPING

### Authentication
| Chức năng | URL |
|-----------|-----|
| Đăng nhập | `/view/jsp/auth/login.jsp` |
| Đăng ký | `/view/jsp/auth/signup.jsp` |
| Quên mật khẩu | `/view/jsp/auth/forgot-password.jsp` |
| Đổi mật khẩu | `/view/jsp/auth/change-password-profile.jsp` |

### Patient
| Chức năng | URL |
|-----------|-----|
| Trang chủ bệnh nhân | `/view/jsp/patient/user_homepage.jsp` |
| Đặt lịch | `/view/jsp/patient/user_datlich.jsp` |
| Lịch khám | `/view/jsp/patient/user_lichkham.jsp` |
| Xem báo cáo | `/view/jsp/patient/user_xembaocao.jsp` |
| Dịch vụ | `/view/jsp/patient/user_services.jsp` |

### Doctor
| Chức năng | URL |
|-----------|-----|
| Trang chủ bác sĩ | `/view/jsp/doctor/doctor_homepage.jsp` |
| Lịch hẹn | `/view/jsp/doctor/doctor_appointments.jsp` |
| Phiếu khám | `/view/jsp/doctor/doctor_phieukham.jsp` |
| Thêm báo cáo | `/view/jsp/doctor/doctor_thembaocao.jsp` |

### Admin/Manager/Staff
| Chức năng | URL |
|-----------|-----|
| Manager tổng quan | `/view/jsp/admin/manager_tongquan.jsp` |
| Staff tổng quan | `/view/jsp/admin/staff_tongquan.jsp` |
| Quản lý khách hàng | `/view/jsp/admin/manager_customers.jsp` |
| Quản lý lịch hẹn | `/view/jsp/admin/staff_quanlylichhen.jsp` |

### Landing Page
| Chức năng | URL |
|-----------|-----|
| Trang chủ công khai | `/view/jsp/home.jsp` |

---

## 📝 QUY ƯỚC SỬ DỤNG

### 1. Trong JSP Files

#### Tài nguyên tĩnh (CSS, JS, Images):
```jsp
<!-- CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/dashboard-common.css">

<!-- JavaScript -->
<script src="${pageContext.request.contextPath}/view/assets/js/dashboard-common.js"></script>

<!-- Images -->
<img src="${pageContext.request.contextPath}/view/assets/img/logo.png" alt="Logo">
```

#### Include layout components:
```jsp
<!-- Header -->
<%@ include file="/view/layout/header.jsp" %>

<!-- Footer -->
<%@ include file="/view/layout/footer.jsp" %>

<!-- Sidebar -->
<%@ include file="/view/layout/sidebar.jsp" %>
```

### 2. Trong Servlet Files

#### Forward to JSP:
```java
// Patient
request.getRequestDispatcher("/view/jsp/patient/user_homepage.jsp").forward(request, response);

// Doctor
request.getRequestDispatcher("/view/jsp/doctor/doctor_homepage.jsp").forward(request, response);

// Admin
request.getRequestDispatcher("/view/jsp/admin/manager_tongquan.jsp").forward(request, response);

// Auth
request.getRequestDispatcher("/view/jsp/auth/login.jsp").forward(request, response);
```

#### Redirect:
```java
response.sendRedirect(request.getContextPath() + "/view/jsp/patient/user_homepage.jsp");
```

### 3. Import Model Classes

```java
// OLD (không dùng nữa)
import model.entity.User;
import model.entity.Patient;

// NEW (chuẩn PRJ301)
import model.User;
import model.Patients;
import model.Doctors;
import model.Appointment;
```

---

## 🔧 SCRIPTS TỰ ĐỘNG

### 1. `update_paths.sh`
Cập nhật tất cả đường dẫn tài nguyên trong JSP files:
```bash
./update_paths.sh
```

### 2. `update_servlet_paths.sh`
Cập nhật tất cả đường dẫn forward/redirect trong Servlets:
```bash
./update_servlet_paths.sh
```

---

## ✅ VERIFICATION

### Compilation Test
```bash
ant clean
ant compile
```

**Kết quả:** ✅ BUILD SUCCESSFUL (142 source files compiled)

---

## 📚 TÀI LIỆU THAM KHẢO

- **Implementation Plan:** [implementation_plan.md](file:///Users/tranhongphuoc/.gemini/antigravity/brain/c5ae07cf-0bd0-4341-a237-e5f4ad5ca6c7/implementation_plan.md)
- **Walkthrough:** [walkthrough.md](file:///Users/tranhongphuoc/.gemini/antigravity/brain/c5ae07cf-0bd0-4341-a237-e5f4ad5ca6c7/walkthrough.md)
- **Task Checklist:** [task.md](file:///Users/tranhongphuoc/.gemini/antigravity/brain/c5ae07cf-0bd0-4341-a237-e5f4ad5ca6c7/task.md)

---

## 🎯 LƯU Ý QUAN TRỌNG

1. **Cấu trúc cũ vẫn tồn tại** - Các thư mục `web/css/`, `web/js/`, `web/jsp/` cũ vẫn còn để tương thích ngược. Có thể xóa sau khi verify hoàn toàn.

2. **Git History** - Tất cả file moves được thực hiện bằng `git mv` để preserve history.

3. **Backup** - Đã tạo commit backup trước khi refactor: "Backup before PRJ301 structure refactoring"

4. **Testing Required** - Cần test deployment và verify tất cả pages load correctly.

---

**Last Updated:** 2026-02-10  
**Refactored by:** Antigravity AI  
**Structure Standard:** PRJ301 MVC
