# CẤU TRÚC THỦ MỤC DỰ ÁN JSP/SERVLET MVC
# DENTAL CLINIC MANAGEMENT SYSTEM

## 📁 TỔNG QUAN CẤU TRÚC

```
DentalClinicManagementSystem/
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── dentalclinic/
│       │           ├── controller/
│       │           ├── model/
│       │           ├── dao/
│       │           ├── service/
│       │           ├── filter/
│       │           ├── listener/
│       │           ├── util/
│       │           └── exception/
│       │
│       ├── webapp/
│       │   ├── WEB-INF/
│       │   │   ├── views/
│       │   │   ├── lib/
│       │   │   └── web.xml
│       │   ├── assets/
│       │   │   ├── css/
│       │   │   ├── js/
│       │   │   ├── images/
│       │   │   ├── fonts/
│       │   │   ├── uploads/
│       │   │   └── vendor/
│       │   ├── error/
│       │   └── index.jsp
│       │
│       └── resources/
│           ├── database.properties
│           ├── email.properties
│           └── log4j.properties
│
├── database/
│   ├── schema.sql
│   ├── sample-data.sql
│   └── queries.sql
│
├── docs/
│   ├── design/
│   ├── api/
│   └── user-manual/
│
└── README.md
```

---

## 📂 CHI TIẾT CẤU TRÚC TỪNG FOLDER

### ▶️ 1. BACKEND - JAVA SOURCE (`src/main/java/com/dentalclinic/`)

#### 📌 `controller/` - SERVLETS (Điều khiển luồng)
```
controller/
├── auth/
│   ├── LoginServlet.java
│   ├── LogoutServlet.java
│   ├── RegisterServlet.java
│   ├── ForgotPasswordServlet.java
│   └── ChangePasswordServlet.java
│
├── appointment/
│   ├── AppointmentListServlet.java
│   ├── AppointmentDetailServlet.java
│   ├── BookAppointmentServlet.java
│   ├── CancelAppointmentServlet.java
│   ├── UpdateAppointmentServlet.java
│   └── DoctorScheduleServlet.java
│
├── treatment/
│   ├── MedicalRecordServlet.java
│   ├── CreateMedicalRecordServlet.java
│   ├── UpdateMedicalRecordServlet.java
│   ├── ViewMedicalRecordServlet.java
│   ├── ReexaminationRequestServlet.java
│   └── PatientHistoryServlet.java
│
├── medicine/
│   ├── MedicineListServlet.java
│   ├── AddMedicineServlet.java
│   ├── UpdateMedicineServlet.java
│   └── DeleteMedicineServlet.java
│
├── service/
│   ├── MedicalServiceListServlet.java
│   ├── CreateServiceServlet.java
│   ├── UpdateServiceServlet.java
│   └── DeleteServiceServlet.java
│
├── payment/
│   ├── PaymentListServlet.java
│   ├── PaymentDetailServlet.java
│   ├── MakePaymentServlet.java
│   └── PaymentHistoryServlet.java
│
├── messaging/
│   ├── NewsListServlet.java
│   ├── CreateNewsServlet.java
│   ├── MessageServlet.java
│   ├── SendMessageServlet.java
│   └── ChatBotServlet.java
│
├── admin/
│   ├── DashboardServlet.java
│   ├── UserManagementServlet.java
│   ├── CreateStaffServlet.java
│   ├── CreateDoctorServlet.java
│   ├── RevenueStatisticsServlet.java
│   └── AppointmentStatisticsServlet.java
│
└── profile/
    ├── ViewProfileServlet.java
    └── UpdateProfileServlet.java
```

#### 📌 `model/` - ENTITY & DTO (Đối tượng dữ liệu)
```
model/
├── entity/                    # Class ánh xạ trực tiếp với Database
│   ├── User.java
│   ├── Role.java
│   ├── Patient.java
│   ├── Doctor.java
│   ├── Staff.java
│   ├── Appointment.java
│   ├── DoctorSchedule.java
│   ├── MedicalRecord.java
│   ├── MedicalService.java
│   ├── MedicalRecordService.java
│   ├── Medicine.java
│   ├── Prescription.java
│   ├── PrescriptionDetail.java
│   ├── ReexaminationRequest.java
│   ├── Payment.java
│   ├── PaymentDetail.java
│   ├── News.java
│   ├── Message.java
│   └── ChatConversation.java
│
└── dto/                       # Data Transfer Object (truyền dữ liệu giữa các layer)
    ├── UserDTO.java
    ├── AppointmentDTO.java
    ├── MedicalRecordDTO.java
    ├── PaymentDTO.java
    ├── StatisticsDTO.java
    └── DashboardDTO.java
```

#### 📌 `dao/` - DATA ACCESS OBJECT (Truy vấn Database)
```
dao/
├── interfaces/                # Interface định nghĩa phương thức
│   ├── UserDAO.java
│   ├── RoleDAO.java
│   ├── PatientDAO.java
│   ├── DoctorDAO.java
│   ├── StaffDAO.java
│   ├── AppointmentDAO.java
│   ├── DoctorScheduleDAO.java
│   ├── MedicalRecordDAO.java
│   ├── MedicalServiceDAO.java
│   ├── MedicineDAO.java
│   ├── PrescriptionDAO.java
│   ├── ReexaminationRequestDAO.java
│   ├── PaymentDAO.java
│   ├── NewsDAO.java
│   ├── MessageDAO.java
│   └── ChatConversationDAO.java
│
└── impl/                      # Implementation (triển khai thực tế)
    ├── UserDAOImpl.java
    ├── RoleDAOImpl.java
    ├── PatientDAOImpl.java
    ├── DoctorDAOImpl.java
    ├── StaffDAOImpl.java
    ├── AppointmentDAOImpl.java
    ├── DoctorScheduleDAOImpl.java
    ├── MedicalRecordDAOImpl.java
    ├── MedicalServiceDAOImpl.java
    ├── MedicineDAOImpl.java
    ├── PrescriptionDAOImpl.java
    ├── ReexaminationRequestDAOImpl.java
    ├── PaymentDAOImpl.java
    ├── NewsDAOImpl.java
    ├── MessageDAOImpl.java
    └── ChatConversationDAOImpl.java
```

#### 📌 `service/` - BUSINESS LOGIC (Logic nghiệp vụ)
```
service/
├── interfaces/
│   ├── AuthService.java
│   ├── UserService.java
│   ├── AppointmentService.java
│   ├── TreatmentService.java
│   ├── MedicineService.java
│   ├── PaymentService.java
│   ├── MessagingService.java
│   └── StatisticsService.java
│
└── impl/
    ├── AuthServiceImpl.java
    ├── UserServiceImpl.java
    ├── AppointmentServiceImpl.java
    ├── TreatmentServiceImpl.java
    ├── MedicineServiceImpl.java
    ├── PaymentServiceImpl.java
    ├── MessagingServiceImpl.java
    └── StatisticsServiceImpl.java
```

#### 📌 `filter/` - FILTERS (Lọc request/response)
```
filter/
├── AuthenticationFilter.java     # Kiểm tra đăng nhập
├── AuthorizationFilter.java      # Kiểm tra quyền truy cập
├── CharacterEncodingFilter.java  # Xử lý encoding UTF-8
├── CORSFilter.java               # Xử lý CORS
└── LoggingFilter.java            # Ghi log request
```

#### 📌 `listener/` - LISTENERS (Lắng nghe sự kiện)
```
listener/
├── ApplicationListener.java      # Khởi tạo khi app start
└── SessionListener.java          # Quản lý session
```

#### 📌 `util/` - UTILITIES (Tiện ích)
```
util/
├── DatabaseConnection.java       # Kết nối database
├── PasswordUtil.java             # Mã hóa mật khẩu
├── DateTimeUtil.java             # Xử lý ngày tháng
├── EmailUtil.java                # Gửi email
├── ValidationUtil.java           # Validate dữ liệu
├── FileUploadUtil.java           # Upload file
├── PaginationUtil.java           # Phân trang
└── Constants.java                # Các hằng số
```

#### 📌 `exception/` - CUSTOM EXCEPTIONS (Xử lý lỗi)
```
exception/
├── DAOException.java
├── ServiceException.java
├── ValidationException.java
└── AuthenticationException.java
```

---

### ▶️ 2. FRONTEND - WEBAPP (`src/main/webapp/`)

#### 📌 `WEB-INF/` - Protected Area (Không truy cập trực tiếp)

##### 📁 `WEB-INF/views/` - JSP PAGES
```
views/
│
├── common/                        # Component dùng chung
│   ├── header.jsp
│   ├── footer.jsp
│   ├── navbar.jsp
│   ├── sidebar.jsp
│   ├── breadcrumb.jsp
│   ├── pagination.jsp
│   └── error.jsp
│
├── auth/                          # Trang xác thực
│   ├── login.jsp
│   ├── register.jsp
│   ├── forgot-password.jsp
│   └── reset-password.jsp
│
├── patient/                       # Giao diện Bệnh nhân
│   ├── dashboard.jsp
│   ├── profile.jsp
│   ├── appointments/
│   │   ├── list.jsp
│   │   ├── detail.jsp
│   │   ├── book.jsp
│   │   └── history.jsp
│   ├── medical-records/
│   │   ├── list.jsp
│   │   ├── detail.jsp
│   │   └── history.jsp
│   ├── payments/
│   │   ├── list.jsp
│   │   ├── detail.jsp
│   │   └── make-payment.jsp
│   └── messages/
│       ├── inbox.jsp
│       ├── conversation.jsp
│       └── compose.jsp
│
├── doctor/                        # Giao diện Bác sĩ
│   ├── dashboard.jsp
│   ├── profile.jsp
│   ├── schedule/
│   │   ├── view.jsp
│   │   └── manage.jsp
│   ├── appointments/
│   │   ├── list.jsp
│   │   ├── detail.jsp
│   │   └── calendar.jsp
│   ├── medical-records/
│   │   ├── create.jsp
│   │   ├── update.jsp
│   │   ├── view.jsp
│   │   └── patient-history.jsp
│   ├── prescriptions/
│   │   ├── create.jsp
│   │   └── view.jsp
│   └── reexamination/
│       ├── request-list.jsp
│       └── create-request.jsp
│
├── staff/                         # Giao diện Nhân viên
│   ├── dashboard.jsp
│   ├── profile.jsp
│   ├── appointments/
│   │   ├── list.jsp
│   │   ├── manage.jsp
│   │   ├── book.jsp
│   │   └── calendar.jsp
│   ├── patients/
│   │   ├── list.jsp
│   │   ├── detail.jsp
│   │   └── medical-history.jsp
│   ├── schedules/
│   │   ├── list.jsp
│   │   ├── create.jsp
│   │   └── edit.jsp
│   ├── payments/
│   │   ├── list.jsp
│   │   └── detail.jsp
│   └── news/
│       ├── list.jsp
│       ├── create.jsp
│       ├── edit.jsp
│       └── preview.jsp
│
└── admin/                         # Giao diện Quản trị viên
    ├── dashboard.jsp
    ├── users/
    │   ├── list.jsp
    │   ├── create-doctor.jsp
    │   ├── create-staff.jsp
    │   ├── edit.jsp
    │   └── detail.jsp
    ├── services/
    │   ├── list.jsp
    │   ├── create.jsp
    │   ├── edit.jsp
    │   └── detail.jsp
    ├── medicines/
    │   ├── list.jsp
    │   ├── create.jsp
    │   ├── edit.jsp
    │   └── low-stock.jsp
    └── statistics/
        ├── revenue.jsp
        ├── appointments.jsp
        ├── users.jsp
        └── services.jsp
```

##### 📁 `WEB-INF/lib/` - JAR Libraries
```
lib/
├── mssql-jdbc-12.4.0.jre11.jar
├── jstl-1.2.jar
├── commons-fileupload-1.4.jar
├── commons-io-2.11.0.jar
└── json-simple-1.1.1.jar
```

##### 📄 `WEB-INF/web.xml` - Deployment Descriptor
```
web.xml                            # Cấu hình servlet, filter, listener
```

---

#### 📌 `assets/` - STATIC RESOURCES (CSS, JS, Images)

##### 📁 `assets/css/` - STYLESHEETS
```
css/
│
├── common/                        # CSS chung
│   ├── reset.css                 # CSS reset
│   ├── variables.css             # Biến CSS (màu sắc, font)
│   ├── typography.css            # Typography
│   └── utility.css               # Utility classes
│
├── components/                    # CSS cho components
│   ├── buttons.css
│   ├── forms.css
│   ├── tables.css
│   ├── cards.css
│   ├── modals.css
│   ├── navbar.css
│   ├── sidebar.css
│   ├── footer.css
│   ├── alerts.css
│   ├── badges.css
│   └── pagination.css
│
├── layouts/                       # CSS cho layouts
│   ├── auth-layout.css
│   ├── dashboard-layout.css
│   └── landing-layout.css
│
├── pages/                         # CSS riêng cho từng trang
│   ├── login.css
│   ├── dashboard.css
│   ├── appointment.css
│   ├── medical-record.css
│   ├── payment.css
│   └── statistics.css
│
└── main.css                       # File CSS chính (import tất cả)
```

##### 📁 `assets/js/` - JAVASCRIPT
```
js/
│
├── common/                        # JS chung
│   ├── constants.js              # Hằng số JS
│   ├── utils.js                  # Hàm tiện ích
│   ├── validation.js             # Validate form
│   ├── ajax.js                   # AJAX requests
│   └── datetime.js               # Xử lý ngày tháng
│
├── components/                    # JS cho components
│   ├── modal.js
│   ├── datepicker.js
│   ├── timepicker.js
│   ├── notification.js
│   ├── table.js
│   ├── pagination.js
│   ├── search.js
│   └── chart.js
│
├── pages/                         # JS riêng cho từng trang
│   ├── auth.js
│   ├── dashboard.js
│   ├── appointment.js
│   ├── medical-record.js
│   ├── payment.js
│   ├── schedule.js
│   ├── messaging.js
│   └── statistics.js
│
└── main.js                        # File JS chính (initialization)
```

##### 📁 `assets/images/` - IMAGES
```
images/
│
├── logo/
│   ├── logo.png
│   ├── logo-white.png
│   └── favicon.ico
│
├── avatars/
│   ├── default-user.png
│   ├── default-doctor.png
│   └── default-patient.png
│
├── banners/
│   ├── home-banner.jpg
│   └── services-banner.jpg
│
├── services/
│   ├── service-1.jpg
│   ├── service-2.jpg
│   └── service-3.jpg
│
└── icons/
    ├── appointment.png
    ├── medical-record.png
    └── payment.png
```

##### 📁 `assets/fonts/` - CUSTOM FONTS
```
fonts/
├── Roboto/
│   ├── Roboto-Regular.woff2
│   ├── Roboto-Bold.woff2
│   └── Roboto-Italic.woff2
│
└── OpenSans/
    ├── OpenSans-Regular.woff2
    └── OpenSans-Bold.woff2
```

##### 📁 `assets/uploads/` - USER UPLOADS
```
uploads/
├── avatars/                       # Avatar người dùng
├── news/                          # Ảnh tin tức
├── medical-images/                # Ảnh y khoa
└── attachments/                   # File đính kèm
```

##### 📁 `assets/vendor/` - THIRD-PARTY LIBRARIES
```
vendor/
│
├── bootstrap/
│   ├── css/
│   │   └── bootstrap.min.css
│   └── js/
│       └── bootstrap.bundle.min.js
│
├── jquery/
│   └── jquery-3.6.0.min.js
│
├── fontawesome/
│   ├── css/
│   │   └── all.min.css
│   └── webfonts/
│       ├── fa-solid-900.woff2
│       └── fa-regular-400.woff2
│
├── datatables/
│   ├── datatables.min.css
│   └── datatables.min.js
│
├── chart.js/
│   └── chart.min.js
│
├── fullcalendar/
│   ├── fullcalendar.min.css
│   └── fullcalendar.min.js
│
└── sweetalert2/
    ├── sweetalert2.min.css
    └── sweetalert2.min.js
```

---

#### 📌 `error/` - ERROR PAGES (Trang lỗi)
```
error/
├── 404.jsp                        # Not Found
├── 500.jsp                        # Server Error
└── 403.jsp                        # Forbidden
```

#### 📄 `index.jsp` - LANDING PAGE
```
index.jsp                          # Trang chủ công khai
```

---

### ▶️ 3. RESOURCES - CONFIGURATION (`src/main/resources/`)

```
resources/
├── database.properties            # Cấu hình database
├── email.properties               # Cấu hình email
├── log4j.properties              # Cấu hình logging
└── messages.properties            # i18n Messages (đa ngôn ngữ)
```

---

### ▶️ 4. DATABASE SCRIPTS (`database/`)

```
database/
├── schema.sql                     # Script tạo bảng
├── sample-data.sql                # Dữ liệu mẫu
├── queries.sql                    # Các query thường dùng
└── stored-procedures.sql          # Stored procedures
```

---

### ▶️ 5. DOCUMENTATION (`docs/`)

```
docs/
│
├── design/
│   ├── database-design.md
│   ├── erd.png
│   ├── architecture.md
│   └── ui-mockups/
│
├── api/
│   └── servlet-api.md
│
├── user-manual/
│   ├── patient-guide.pdf
│   ├── doctor-guide.pdf
│   ├── staff-guide.pdf
│   └── admin-guide.pdf
│
└── setup/
    ├── installation.md
    └── deployment.md
```

---

## 🔧 CÁCH TẠO CẤU TRÚC THƯ MỤC

### ✅ Cách 1: Tạo thủ công trong IDE (Eclipse/IntelliJ)

#### **Trong Eclipse:**
1. **Tạo Dynamic Web Project**: File → New → Dynamic Web Project
2. **Tạo package trong src**: Click phải src → New → Package
   - `com.dentalclinic.controller`
   - `com.dentalclinic.model`
   - `com.dentalclinic.dao`
   - v.v.
3. **Tạo folder trong webapp**: Click phải webapp → New → Folder
   - `assets/css`
   - `assets/js`
   - `WEB-INF/views`
   - v.v.

#### **Trong IntelliJ IDEA:**
1. **Tạo Web Application Project**: File → New → Project → Java Enterprise
2. **Tạo package**: Click phải java → New → Package
3. **Tạo directory**: Click phải webapp → New → Directory

---

### ✅ Cách 2: Tạo bằng Maven (Khuyến nghị)

#### **Bước 1: Tạo Maven Project**
```bash
mvn archetype:generate -DgroupId=com.dentalclinic -DartifactId=DentalClinicManagementSystem -DarchetypeArtifactId=maven-archetype-webapp
```

#### **Bước 2: Cấu trúc tự động tạo**
```
DentalClinicManagementSystem/
├── src/
│   └── main/
│       ├── java/
│       ├── resources/
│       └── webapp/
└── pom.xml
```

#### **Bước 3: Tạo thêm các package cần thiết**
Trong `src/main/java/`, tạo package:
- `com.dentalclinic.controller`
- `com.dentalclinic.model.entity`
- `com.dentalclinic.model.dto`
- `com.dentalclinic.dao.interfaces`
- `com.dentalclinic.dao.impl`
- `com.dentalclinic.service.interfaces`
- `com.dentalclinic.service.impl`
- `com.dentalclinic.filter`
- `com.dentalclinic.listener`
- `com.dentalclinic.util`
- `com.dentalclinic.exception`

#### **Bước 4: Tạo cấu trúc frontend**
Trong `src/main/webapp/`:
```
webapp/
├── WEB-INF/
│   ├── views/
│   │   ├── common/
│   │   ├── auth/
│   │   ├── patient/
│   │   ├── doctor/
│   │   ├── staff/
│   │   └── admin/
│   ├── lib/
│   └── web.xml
├── assets/
│   ├── css/
│   ├── js/
│   ├── images/
│   ├── fonts/
│   ├── uploads/
│   └── vendor/
├── error/
└── index.jsp
```

---

### ✅ Cách 3: Script tự động (Windows/Linux)

#### **Windows - Batch Script**
Tạo file `create-structure.bat`:
```batch
@echo off
mkdir src\main\java\com\dentalclinic\controller\auth
mkdir src\main\java\com\dentalclinic\controller\appointment
mkdir src\main\java\com\dentalclinic\model\entity
mkdir src\main\java\com\dentalclinic\model\dto
mkdir src\main\java\com\dentalclinic\dao\interfaces
mkdir src\main\java\com\dentalclinic\dao\impl
mkdir src\main\java\com\dentalclinic\service\interfaces
mkdir src\main\java\com\dentalclinic\service\impl
mkdir src\main\java\com\dentalclinic\filter
mkdir src\main\java\com\dentalclinic\listener
mkdir src\main\java\com\dentalclinic\util
mkdir src\main\java\com\dentalclinic\exception
mkdir src\main\webapp\WEB-INF\views\common
mkdir src\main\webapp\WEB-INF\views\auth
mkdir src\main\webapp\WEB-INF\views\patient
mkdir src\main\webapp\WEB-INF\views\doctor
mkdir src\main\webapp\WEB-INF\lib
mkdir src\main\webapp\assets\css
mkdir src\main\webapp\assets\js
mkdir src\main\webapp\assets\images
mkdir src\main\webapp\assets\vendor
mkdir src\main\resources
mkdir database
mkdir docs
echo Done!
```

#### **Linux/Mac - Shell Script**
Tạo file `create-structure.sh`:
```bash
#!/bin/bash
mkdir -p src/main/java/com/dentalclinic/controller/{auth,appointment,treatment,medicine,payment,admin}
mkdir -p src/main/java/com/dentalclinic/model/{entity,dto}
mkdir -p src/main/java/com/dentalclinic/dao/{interfaces,impl}
mkdir -p src/main/java/com/dentalclinic/service/{interfaces,impl}
mkdir -p src/main/java/com/dentalclinic/{filter,listener,util,exception}
mkdir -p src/main/webapp/WEB-INF/views/{common,auth,patient,doctor,staff,admin}
mkdir -p src/main/webapp/WEB-INF/lib
mkdir -p src/main/webapp/assets/{css,js,images,fonts,uploads,vendor}
mkdir -p src/main/webapp/error
mkdir -p src/main/resources
mkdir -p database
mkdir -p docs
echo "Structure created successfully!"
```

Chạy script:
```bash
chmod +x create-structure.sh
./create-structure.sh
```

---

## 📋 CHECKLIST TẠO DỰ ÁN

### ✅ Backend (Java)
- [ ] Tạo package `controller` với các module con
- [ ] Tạo package `model.entity` cho các class Entity
- [ ] Tạo package `model.dto` cho Data Transfer Objects
- [ ] Tạo package `dao.interfaces` và `dao.impl`
- [ ] Tạo package `service.interfaces` và `service.impl`
- [ ] Tạo package `filter` cho Authentication/Authorization
- [ ] Tạo package `listener`
- [ ] Tạo package `util` cho các utility classes
- [ ] Tạo package `exception` cho custom exceptions

### ✅ Frontend (JSP/CSS/JS)
- [ ] Tạo folder `WEB-INF/views/` với các module (patient, doctor, staff, admin)
- [ ] Tạo folder `WEB-INF/views/common/` cho components dùng chung
- [ ] Tạo folder `assets/css/` với cấu trúc phân chia rõ ràng
- [ ] Tạo folder `assets/js/` với cấu trúc phân chia rõ ràng
- [ ] Tạo folder `assets/images/` cho hình ảnh
- [ ] Tạo folder `assets/vendor/` cho thư viện third-party
- [ ] Tạo folder `error/` cho các trang lỗi
- [ ] Tạo file `index.jsp` làm landing page

### ✅ Configuration & Resources
- [ ] Tạo folder `src/main/resources/` cho config files
- [ ] Tạo file `WEB-INF/web.xml`
- [ ] Tạo folder `WEB-INF/lib/` cho JAR files

### ✅ Database & Documentation
- [ ] Tạo folder `database/` chứa SQL scripts
- [ ] Tạo folder `docs/` cho tài liệu
- [ ] Tạo file `README.md`

---

## 💡 GỢI Ý TRIỂN KHAI

### 🎯 Thứ tự phát triển đề xuất:

1. **Setup cơ bản**
   - Tạo cấu trúc thư mục
   - Cấu hình web.xml
   - Setup database connection

2. **Authentication Module**
   - LoginServlet
   - AuthenticationFilter
   - User Entity & DAO

3. **Core Modules** (theo thứ tự ưu tiên)
   - Appointment Management
   - Medical Record Management
   - Payment Management
   - User Management

4. **Additional Features**
   - Messaging
   - Statistics
   - News Management

---

## 📌 LƯU Ý QUAN TRỌNG

### ⚠️ Quy tắc đặt tên:
- **Package**: lowercase, không dấu (vd: `com.dentalclinic.controller`)
- **Class**: PascalCase (vd: `LoginServlet.java`, `UserDAO.java`)
- **JSP**: lowercase, dấu gạch ngang (vd: `login.jsp`, `appointment-list.jsp`)
- **CSS/JS**: lowercase, dấu gạch ngang (vd: `main.css`, `appointment.js`)
- **Folder**: lowercase, dấu gạch ngang (vd: `medical-records/`)

### ⚠️ Bảo mật:
- Đặt tất cả JSP trong `WEB-INF/views/` (không truy cập trực tiếp)
- File upload vào `assets/uploads/`, không vào `WEB-INF/`
- Cấu hình AuthenticationFilter cho tất cả protected pages

### ⚠️ Tổ chức code:
- Mỗi Servlet chỉ xử lý 1 chức năng cụ thể
- Mỗi DAO chỉ truy vấn 1 bảng
- Service layer xử lý business logic, không trực tiếp gọi database
- Tách riêng CSS/JS theo module, không viết inline

---

**✅ Hoàn thành!** Cấu trúc thư mục đã sẵn sàng cho dự án JSP/Servlet MVC của bạn!
