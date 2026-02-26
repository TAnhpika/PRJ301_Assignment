# CẤU TRÚC SOURCE CODE - PHIÊN BẢN ĐƠN GIẢN

## 📁 CẤU TRÚC HIỆN TẠI

```
src/java/
├── controller/          # 75+ servlets (TẤT CẢ Ở ĐÂY)
├── model/              # 24 entity classes
├── dao/                # 21 DAO classes  
├── util/               # 16 utility classes
└── logging.properties
```

## 🎯 CẤU TRÚC ĐỀ XUẤT (Giữ package đơn giản)

```
src/java/
│
├── controller/
│   ├── auth/                    # Authentication & Authorization
│   │   ├── LoginServlet.java
│   │   ├── LogoutServlet.java
│   │   ├── RegisterServlet.java
│   │   ├── SignUpServlet.java
│   │   ├── RegisterInformation.java
│   │   ├── ChangePasswordServlet.java
│   │   ├── ResetPasswordServlet.java
│   │   ├── UpdatePasswordServlet.java
│   │   ├── FaceIdLoginServlet.java
│   │   └── GoogleCallbackServlet.java
│   │
│   ├── appointment/             # Quản lý lịch hẹn
│   │   ├── BookingServlet.java
│   │   ├── BookingPageServlet.java
│   │   ├── CancelAppointmentServlet.java
│   │   ├── RescheduleAppointmentServlet.java
│   │   ├── ConfirmServlet.java
│   │   ├── DoctorAppointmentsServlet.java
│   │   ├── PatientAppointmentsServlet.java
│   │   ├── StaffBookingServlet.java
│   │   ├── CancelledAppointmentsServlet.java
│   │   ├── CompletedAppointmentsServlet.java
│   │   ├── DoctorHaveAppointmentServlet.java
│   │   ├── GetAvailableSlotsServlet.java
│   │   ├── RelativesAppointmentServlet.java
│   │   ├── StaffHandleQueueServlet.java
│   │   ├── ViewAppointmentServlet.java
│   │   ├── ViewAllAppointmentsServlet.java
│   │   └── SlotReservationServlet.java
│   │
│   ├── schedule/                # Quản lý lịch làm việc
│   │   ├── DoctorRegisterScheduleServlet.java
│   │   ├── DoctorScheduleConfirmServlet.java
│   │   ├── DoctorWorkDaysServlet.java
│   │   ├── StaffRegisterSecheduleServlet.java
│   │   ├── ManagerApprovalDoctorSchedulerServlet.java
│   │   ├── ManagerApprovalStaffScheduleServlet.java
│   │   ├── StaffScheduleApprovalServlet.java
│   │   └── StaffScheduleServlet.java
│   │
│   ├── treatment/               # Điều trị & Hồ sơ bệnh án
│   │   ├── MedicalReportServlet.java
│   │   ├── CreateMedicalReportServlet.java
│   │   ├── InputMedicalReportServlet.java
│   │   ├── MedicalReportDetailServlet.java
│   │   ├── UpdateMedicalReportServlet.java
│   │   ├── DeleteMedicalReportServlet.java
│   │   ├── ExportMedicalReportServlet.java
│   │   ├── AddReportServlet.java
│   │   ├── SubmitMedicalReportServlet.java
│   │   └── ViewReportServlet.java
│   │
│   ├── medicine/                # Quản lý thuốc & Đơn thuốc
│   │   ├── SellMedicineServlet.java
│   │   ├── ConfirmSellMedicineServlet.java
│   │   ├── StaffMedicineServlet.java
│   │   ├── StaffPrescriptionServlet.java
│   │   ├── StaffSellMedicineServlet.java
│   │   ├── ViewPrescriptionServlet.java
│   │   └── UpdateStockServlet.java
│   │
│   ├── payment/                 # Thanh toán
│   │   ├── PayOSServlet.java
│   │   ├── PaymentConfirmServlet.java
│   │   ├── StaffPaymentServlet.java
│   │   ├── StaffPayOSServlet.java
│   │   ├── CheckBillServlet.java
│   │   ├── ViewBillServlet.java
│   │   ├── ViewPaymentServlet.java
│   │   └── UserPaymentServlet.java
│   │
│   ├── messaging/               # Tin nhắn & Chat
│   │   ├── ChatServlet.java
│   │   ├── ChatHistoryServlet.java
│   │   ├── ChatAiServlet.java
│   │   ├── MedicalNoteAiServlet.java
│   │   ├── BlogServlet.java
│   │   └── ServiceServlet.java
│   │
│   ├── admin/                   # Quản trị hệ thống
│   │   ├── AddStaffServlet.java
│   │   ├── DeleteStaffServlet.java
│   │   ├── EditDoctorServlet.java
│   │   ├── ManagerCustomerListServlet.java
│   │   ├── ManagerResetStaffPasswordServlet.java
│   │   ├── StaffInfoServlet.java
│   │   ├── UpdateStaffInfoServlet.java
│   │   ├── UpdateDoctorStatusServlet.java
│   │   ├── UpdateUserServlet.java
│   │   ├── UserRegisterWhenTheyNotRegisterInformation.java
│   │   ├── CloudflareManagementServlet.java
│   │   ├── NotificationServlet.java
│   │   ├── TwilioCallServlet.java
│   │   └── TwilioSMSServlet.java
│   │
│   └── profile/                 # Hồ sơ cá nhân
│       ├── AvatarServlet.java
│       ├── UpdateStaffAvatarServlet.java
│       ├── UpdateDoctorAvatarServlet.java
│       ├── DoctorHomePageServlet.java
│       ├── LandingPageServlet.java
│       ├── StaffProfileServlet.java
│       ├── StaffViewPatientServlet.java
│       ├── UserHompageServlet.java
│       ├── UserAccountServlet.java
│       └── ViewProfileServlet.java
│
├── model/
│   ├── entity/                  # Domain Objects
│   │   ├── User.java
│   │   ├── Patients.java
│   │   ├── Doctors.java
│   │   ├── Staff.java
│   │   ├── Manager.java
│   │   ├── Appointment.java
│   │   ├── DoctorSchedule.java
│   │   ├── StaffSchedule.java
│   │   ├── TimeSlot.java
│   │   ├── SlotReservation.java
│   │   ├── MedicalReport.java
│   │   ├── Prescription.java
│   │   ├── PrescriptionDetail.java
│   │   ├── Medicine.java
│   │   ├── Service.java
│   │   ├── BillService.java
│   │   ├── Bill.java
│   │   ├── PaymentInfo.java
│   │   ├── PaymentInstallment.java
│   │   ├── BlogPost.java
│   │   ├── ChatMessage.java
│   │   ├── Notification.java
│   │   ├── NotificationTemplate.java
│   │   └── Specialty.java
│   │
│   └── dto/                     # Data Transfer Objects (Tạo sau)
│       ├── UserDTO.java
│       ├── AppointmentDTO.java
│       ├── MedicalRecordDTO.java
│       ├── PaymentDTO.java
│       └── StatisticsDTO.java
│
├── dao/
│   ├── impl/                    # DAO Implementations
│   │   ├── UserDAOImpl.java
│   │   ├── PatientDAOImpl.java
│   │   ├── DoctorDAOImpl.java
│   │   ├── StaffDAOImpl.java
│   │   ├── ManagerDAOImpl.java
│   │   ├── AppointmentDAOImpl.java
│   │   ├── DoctorScheduleDAOImpl.java
│   │   ├── StaffScheduleDAOImpl.java
│   │   ├── TimeSlotDAOImpl.java
│   │   ├── MedicineDAOImpl.java
│   │   ├── ServiceDAOImpl.java
│   │   ├── ServicePriceDAOImpl.java
│   │   ├── BillDAOImpl.java
│   │   ├── PaymentInstallmentDAOImpl.java
│   │   ├── BlogDAOImpl.java
│   │   ├── NotificationDAOImpl.java
│   │   ├── NotificationTemplateDAOImpl.java
│   │   ├── SpecialtyDAOImpl.java
│   │   ├── RelativesDAOImpl.java
│   │   ├── RelativesAppointmentDAOImpl.java
│   │   └── FaceImageDAOImpl.java
│   │
│   └── interfaces/              # DAO Interfaces (Tạo sau)
│       ├── IUserDAO.java
│       ├── IPatientDAO.java
│       ├── IDoctorDAO.java
│       └── ...
│
├── service/                     # Business Logic Layer (Tạo sau)
│   ├── impl/
│   │   ├── AuthServiceImpl.java
│   │   ├── AppointmentServiceImpl.java
│   │   ├── TreatmentServiceImpl.java
│   │   └── ...
│   │
│   └── interfaces/
│       ├── IAuthService.java
│       ├── IAppointmentService.java
│       └── ...
│
├── filter/                      # Request/Response Filters
│   ├── AuthenticationFilter.java
│   ├── AuthorizationFilter.java (renamed from RoleFilter)
│   ├── CharacterEncodingFilter.java (renamed from EncodingFilter)
│   └── SecurityFilter.java
│
├── util/                        # Utility Classes
│   ├── DatabaseConnection.java
│   ├── PasswordUtil.java
│   ├── DateTimeUtil.java
│   ├── EmailUtil.java
│   ├── ValidationUtil.java
│   ├── FileUploadUtil.java
│   ├── Constants.java
│   ├── Env.java
│   └── ... (16 files total)
│
└── exception/                   # Custom Exceptions (Tạo sau)
    ├── DAOException.java
    ├── ServiceException.java
    ├── ValidationException.java
    └── AuthenticationException.java
```

## 📋 PACKAGE STRUCTURE

### Cách 1: Giữ package đơn giản (KHUYẾN NGHỊ)
```java
// Controller
package controller.auth;
package controller.appointment;
package controller.schedule;
// etc...

// Model
package model.entity;
package model.dto;

// DAO
package dao.impl;
package dao.interfaces;

// Service
package service.impl;
package service.interfaces;

// Filter
package filter;

// Util
package util;

// Exception
package exception;
```

### Cách 2: Không dùng sub-package (Hiện tại của bạn)
```java
package controller;  // TẤT CẢ controller ở đây
package model;       // TẤT CẢ model ở đây
package dao;         // TẤT CẢ dao ở đây
package util;        // TẤT CẢ util ở đây
package filter;      // TẤT CẢ filter ở đây
```

## 🎯 QUYẾT ĐỊNH

Bạn muốn:

### Lựa chọn A: Tổ chức theo folder + sub-package (Chuẩn)
- ✅ Dễ quản lý khi project lớn
- ✅ Tách biệt rõ ràng từng module
- ✅ Dễ tìm kiếm file
- ⚠️ Phải update package declarations

### Lựa chọn B: Giữ nguyên (Tất cả ở root)
- ✅ Không cần update code
- ✅ Package đơn giản
- ⚠️ Khó quản lý khi có nhiều file
- ⚠️ Khó tìm kiếm

## 💡 ĐỀ XUẤT CỦA TÔI

Tôi khuyên nên dùng **Lựa chọn A** với cấu trúc:

```
controller/
├── auth/           (package controller.auth)
├── appointment/    (package controller.appointment)
├── schedule/       (package controller.schedule)
├── treatment/      (package controller.treatment)
├── medicine/       (package controller.medicine)
├── payment/        (package controller.payment)
├── messaging/      (package controller.messaging)
├── admin/          (package controller.admin)
└── profile/        (package controller.profile)
```

Lý do:
1. Dễ tìm servlet theo chức năng
2. Dễ maintain và scale
3. Chuẩn theo best practices
4. Dễ onboard developer mới

Bạn chọn cách nào?
