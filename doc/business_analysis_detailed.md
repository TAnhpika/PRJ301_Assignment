# PHÂN TÍCH NGHIỆP VỤ CHI TIẾT
## HỆ THỐNG QUẢN LÝ PHÒNG KHÁM NHA KHOA

---

## 📋 MỤC LỤC
1. [Tổng Quan Hệ Thống](#1-tổng-quan-hệ-thống)
2. [Phân Tích 8 Module Nghiệp Vụ](#2-phân-tích-8-module-nghiệp-vụ)
3. [Workflow Chi Tiết](#3-workflow-chi-tiết)
4. [Mapping Nghiệp Vụ → Database](#4-mapping-nghiệp-vụ--database)
5. [Use Case Diagram](#5-use-case-diagram)

---

## 1. TỔNG QUAN HỆ THỐNG

### 1.1. Mục Đích
Hệ thống quản lý toàn diện hoạt động của phòng khám nha khoa, bao gồm:
- Quản lý lịch hẹn khám
- Quản lý hồ sơ bệnh án
- Quản lý dịch vụ và thanh toán
- Tư vấn trực tuyến
- Quản lý nội dung (tin tức y tế)

### 1.2. Phân Loại Người Dùng (4 Roles)

| Role | Mô Tả | Quyền Hạn Chính |
|------|-------|-----------------|
| **PATIENT** (Bệnh nhân) | Người đến khám chữa bệnh | Đặt lịch, xem hồ sơ bệnh án, thanh toán, tư vấn |
| **DOCTOR** (Bác sĩ) | Chuyên gia nha khoa | Khám bệnh, tạo hồ sơ bệnh án, kê đơn thuốc, tư vấn |
| **STAFF** (Nhân viên) | Nhân viên lễ tân/hành chính | Quản lý lịch hẹn, hỗ trợ bệnh nhân, quản lý tin tức |
| **MANAGER** (Quản lý) | Quản lý phòng khám | Quản lý nhân sự, dịch vụ, xem báo cáo thống kê |

### 1.3. Thống Kê Chức Năng

| Module | Số Chức Năng | Độ Ưu Tiên |
|--------|--------------|------------|
| Appointment | 11 | ⭐⭐⭐ (Critical) |
| Treatment | 9 | ⭐⭐⭐ (Critical) |
| System Management | 9 | ⭐⭐ (High) |
| Discussing | 9 | ⭐⭐ (High) |
| Authentication | 7 | ⭐⭐⭐ (Critical) |
| Medical Service | 6 | ⭐⭐ (High) |
| Order (Medicine) | 4 | ⭐ (Medium) |
| Payment | 3 | ⭐⭐⭐ (Critical) |
| **TỔNG** | **58 chức năng** | |

---

## 2. PHÂN TÍCH 8 MODULE NGHIỆP VỤ

### 📌 MODULE 1: AUTHENTICATION (Xác Thực - 7 chức năng)

#### **Mục đích**: Quản lý tài khoản và bảo mật hệ thống

#### **Chức năng chi tiết:**

##### **1.1. Sign In (Đăng nhập)**
- **Actor**: Doctor, Patient, Staff, Manager (TẤT CẢ)
- **Mô tả**: Người dùng đăng nhập vào hệ thống
- **Input**: Email, Password
- **Output**: Chuyển đến dashboard tương ứng với role
- **Nghiệp vụ**:
  - Kiểm tra email tồn tại
  - Xác thực password (hash)
  - Kiểm tra tài khoản active
  - Lưu last_login
  - Tạo session (nếu cần)
- **Bảng liên quan**: `Users`, `Roles`, `UserSessions` (optional)

##### **1.2. Sign Out (Đăng xuất)**
- **Actor**: TẤT CẢ
- **Mô tả**: Đăng xuất khỏi hệ thống
- **Nghiệp vụ**: Xóa session, redirect về trang login

##### **1.3. Register (Đăng ký)**
- **Actor**: Guest (Khách)
- **Mô tả**: Khách đăng ký tài khoản PATIENT mới
- **Input**: Email, Password, Full Name, Phone, Date of Birth, Gender
- **Nghiệp vụ**:
  - Kiểm tra email chưa tồn tại
  - Hash password
  - Tạo record trong `Users` (role_id = PATIENT)
  - Tạo record trong `PatientProfiles`
  - Gửi email xác nhận (optional)
- **Bảng liên quan**: `Users`, `PatientProfiles`

##### **1.4. Forgot Password (Quên mật khẩu)**
- **Actor**: TẤT CẢ (đã có tài khoản)
- **Mô tả**: Khôi phục mật khẩu qua email
- **Nghiệp vụ**:
  - Nhập email → Gửi link reset password
  - Click link → Nhập password mới → Cập nhật

##### **1.5. View Profile (Xem hồ sơ cá nhân)**
- **Actor**: TẤT CẢ
- **Mô tả**: Xem thông tin cá nhân
- **Output**:
  - **Patient**: Thông tin cơ bản + PatientProfile (blood_type, allergies)
  - **Doctor**: Thông tin cơ bản + DoctorProfile (specialization, rating)
  - **Staff**: Thông tin cơ bản + StaffProfile (position, department)
  - **Manager**: Thông tin cơ bản

##### **1.6. Change Password (Đổi mật khẩu)**
- **Actor**: TẤT CẢ
- **Mô tả**: Thay đổi mật khẩu khi đã đăng nhập
- **Input**: Old Password, New Password, Confirm Password
- **Nghiệp vụ**: Kiểm tra old password → Hash new password → Cập nhật

##### **1.7. Update Profile (Cập nhật hồ sơ)**
- **Actor**: TẤT CẢ
- **Mô tả**: Cập nhật thông tin cá nhân
- **Input**: Full Name, Phone, Address, Avatar, Date of Birth
- **Bảng liên quan**: `Users`, và Profile tương ứng

---

### 📌 MODULE 2: APPOINTMENT (Lịch Hẹn - 11 chức năng)

#### **Mục đích**: Quản lý toàn bộ quy trình đặt lịch và khám bệnh

#### **Chức năng chi tiết:**

##### **2.1. Book An Appointment (Đặt lịch hẹn)**
- **Actor**: Patient, Staff
- **Mô tả**: Tạo lịch hẹn khám mới
- **Input**:
  - Patient (nếu staff đặt cho bệnh nhân)
  - Doctor (chọn từ danh sách)
  - Date, Time
  - Reason (lý do khám)
- **Workflow**:
  1. Patient/Staff chọn bác sĩ
  2. Hệ thống hiển thị lịch trống của bác sĩ (từ `Schedules`)
  3. Chọn ngày giờ phù hợp
  4. Nhập lý do khám
  5. Submit → Tạo record `Appointments` (status = PENDING)
  6. (Optional) Gửi email/SMS xác nhận
- **Business Rule**:
  - Không được đặt trùng giờ với appointment khác của cùng doctor
  - Chỉ đặt trong khung giờ làm việc (từ `Schedules`)
  - Duration mặc định: 30 phút
- **Bảng liên quan**: `Appointments`, `Users`, `Schedules`, `AppointmentStatuses`

##### **2.2. View Appointments List (Xem danh sách lịch hẹn)**
- **Actor**: Staff, Admin, Patient, Doctor
- **Mô tả**: Xem danh sách lịch hẹn theo role
- **Phân quyền**:
  - **Patient**: Chỉ xem lịch của mình
  - **Doctor**: Xem lịch bệnh nhân đặt với mình
  - **Staff/Admin**: Xem tất cả lịch hẹn
- **Hiển thị**: appointment_date, appointment_time, patient_name, doctor_name, status

##### **2.3. View Appointment Detail (Xem chi tiết lịch hẹn)**
- **Actor**: TẤT CẢ (Staff, Admin, Patient, Doctor)
- **Mô tả**: Xem thông tin chi tiết 1 lịch hẹn
- **Output**:
  - Thông tin cơ bản: date, time, reason, notes
  - Patient info: full_name, phone, age, blood_type, allergies
  - Doctor info: full_name, specialization
  - Services sử dụng (từ `AppointmentServices`)
  - Status hiện tại
- **Bảng liên quan**: `Appointments`, `Users`, `PatientProfiles`, `DoctorProfiles`, `AppointmentServices`, `Services`

##### **2.4. Cancel Appointment (Hủy lịch hẹn)**
- **Actor**: Staff
- **Mô tả**: Hủy lịch hẹn (khi bệnh nhân yêu cầu hoặc có lý do khác)
- **Nghiệp vụ**:
  - Update `status_id = CANCELLED`
  - Ghi lý do vào `notes`
  - (Optional) Gửi thông báo cho patient
- **Business Rule**: Chỉ hủy được lịch hẹn có status = PENDING hoặc CONFIRMED

##### **2.5. Update Appointment Time and Date (Cập nhật ngày giờ)**
- **Actor**: Staff
- **Mô tả**: Thay đổi ngày giờ lịch hẹn (reschedule)
- **Nghiệp vụ**:
  - Kiểm tra lịch trống của doctor vào thời gian mới
  - Update `appointment_date`, `appointment_time`
  - Gửi thông báo cho patient
- **Business Rule**: Không được trùng với appointment khác

##### **2.6. Update Appointment Status (Cập nhật trạng thái)**
- **Actor**: Staff
- **Mô tả**: Thay đổi trạng thái lịch hẹn
- **Status Flow**:
  - PENDING → CONFIRMED (Staff xác nhận)
  - CONFIRMED → COMPLETED (Sau khi khám xong)
  - CONFIRMED → CANCELLED (Hủy bỏ)
  - CONFIRMED → NO_SHOW (Bệnh nhân không đến)
- **Bảng liên quan**: `Appointments`, `AppointmentStatuses`

##### **2.7. Arrange Doctor's Appointments (Sắp xếp lịch bác sĩ)**
- **Actor**: Staff
- **Mô tả**: Sắp xếp lại thứ tự/thời gian các appointment của doctor trong 1 ngày
- **Nghiệp vụ**: Drag & drop hoặc edit hàng loạt để tối ưu lịch

##### **2.8. Edit Doctor Work Schedule (Sửa lịch làm việc)**
- **Actor**: Staff
- **Mô tả**: Chỉnh sửa ca làm việc của bác sĩ
- **Nghiệp vụ**: Update record trong `Schedules`
- **Business Rule**: Nếu đã có appointment trong khung giờ → cảnh báo hoặc không cho sửa

##### **2.9. Create Doctor's Schedule (Tạo lịch làm việc)**
- **Actor**: Staff
- **Mô tả**: Tạo lịch làm việc cho bác sĩ (theo tuần, tháng)
- **Input**: Doctor, Work Date, Start Time, End Time, Schedule Type (WORKING/LEAVE/HOLIDAY)
- **Ví dụ**:
  - Dr. Nguyen: Thứ 2-6, 8h-12h (sáng), 13h-17h (chiều)
  - Dr. Tran: Thứ 3,5,7, 8h-12h
- **Bảng liên quan**: `Schedules`

##### **2.10. Filter Appointment List (Lọc danh sách)**
- **Actor**: Staff, Admin, Patient
- **Mô tả**: Lọc appointment theo điều kiện
- **Filter by**: Doctor, Patient, Status, Date Range

##### **2.11. Search Appointment (Tìm kiếm)**
- **Actor**: Staff, Admin, Patient
- **Mô tả**: Tìm kiếm appointment theo keyword
- **Search by**: Patient Name, Patient Phone, Appointment ID

---

### 📌 MODULE 3: TREATMENT (Điều Trị - 9 chức năng)

#### **Mục đích**: Quản lý quy trình khám bệnh, chẩn đoán, kê đơn

#### **Chức năng chi tiết:**

##### **3.1. Create Medical Record (Tạo hồ sơ bệnh án)**
- **Actor**: Doctor
- **Mô tả**: Bác sĩ tạo báo cáo khám bệnh sau khi khám
- **Workflow**:
  1. Doctor chọn appointment (status = COMPLETED)
  2. Nhập thông tin:
     - **Symptoms** (triệu chứng): Đau nhức, sưng tấy...
     - **Diagnosis** (chẩn đoán): Sâu răng số 6, viêm nha chu...
     - **Treatment Plan** (kế hoạch điều trị): Hàn răng, nhổ răng...
     - **Notes** (ghi chú): Lưu ý đặc biệt
     - **Follow-up Required**: Có cần tái khám không?
     - **Follow-up Date**: Ngày tái khám
  3. Chọn dịch vụ đã sử dụng → Insert vào `AppointmentServices`
  4. (Optional) Kê đơn thuốc → `Prescriptions` + `PrescriptionDetails`
  5. Submit → Insert `MedicalReports`
- **Business Rule**:
  - 1 appointment chỉ có 1 medical report
  - Appointment phải có status = COMPLETED mới tạo được report
- **Bảng liên quan**: `MedicalReports`, `Appointments`, `AppointmentServices`, `Prescriptions`, `PrescriptionDetails`

##### **3.2. Update Medical Record (Cập nhật hồ sơ)**
- **Actor**: Doctor
- **Mô tả**: Sửa thông tin trong báo cáo khám bệnh
- **Nghiệp vụ**: Update các field trong `MedicalReports`

##### **3.3. View Medical Record (Xem hồ sơ bệnh án)**
- **Actor**: Patient, Doctor
- **Mô tả**: Xem chi tiết báo cáo khám bệnh
- **Phân quyền**:
  - **Patient**: Chỉ xem hồ sơ của mình
  - **Doctor**: Xem hồ sơ bệnh nhân mình khám
- **Hiển thị**:
  - Thông tin khám: diagnosis, symptoms, treatment_plan
  - Đơn thuốc: danh sách thuốc, liều lượng, cách dùng
  - Dịch vụ đã sử dụng
  - Ngày khám, bác sĩ khám

##### **3.4. Create Request Reexamination (Tạo yêu cầu tái khám)**
- **Actor**: Doctor
- **Mô tả**: Bác sĩ tạo lịch tái khám cho bệnh nhân (khi cần theo dõi)
- **Input**: Appointment ID (gốc), Reexam Date, Reexam Time, Reason
- **Nghiệp vụ**: Insert `Reexaminations` (is_completed = 0)
- **Bảng liên quan**: `Reexaminations`, `Appointments`

##### **3.5. View Request Reexamination (Xem yêu cầu tái khám)**
- **Actor**: Doctor, Staff, Patient
- **Mô tả**: Xem danh sách lịch tái khám
- **Phân quyền**:
  - **Patient**: Chỉ xem lịch tái khám của mình
  - **Doctor**: Xem lịch tái khám bệnh nhân của mình
  - **Staff**: Xem tất cả

##### **3.6. Create Schedule Reexamination (Xác nhận lịch tái khám)**
- **Actor**: Doctor, Staff, Patient
- **Mô tả**: Xác nhận/tạo appointment cho lịch tái khám
- **Workflow**:
  1. Xem request reexamination
  2. Chọn ngày giờ cụ thể (nếu chưa có)
  3. Tạo appointment mới với reason = "Tái khám"
  4. Link với reexamination (appointment_id)

##### **3.7. Cancel Schedule Reexamination (Hủy lịch tái khám)**
- **Actor**: Staff
- **Mô tả**: Hủy lịch tái khám
- **Nghiệp vụ**: Update `is_completed = 0`, hoặc xóa appointment liên kết

##### **3.8. View Schedule Reexamination (Xem lịch tái khám)**
- **Actor**: Doctor, Staff, Patient
- **Mô tả**: Xem danh sách lịch tái khám đã xác nhận

##### **3.9. View Patient Medical Record History (Xem lịch sử bệnh án)**
- **Actor**: Doctor, Staff
- **Mô tả**: Xem toàn bộ lịch sử khám bệnh của 1 bệnh nhân
- **Output**: Danh sách tất cả `MedicalReports` của patient, sắp xếp theo ngày khám
- **Nghiệp vụ**: 
  ```sql
  SELECT * FROM MedicalReports 
  WHERE patient_id = ? 
  ORDER BY created_at DESC
  ```

---

### 📌 MODULE 4: MEDICAL SERVICE (Dịch Vụ Y Tế - 6 chức năng)

#### **Mục đích**: Quản lý danh mục các dịch vụ nha khoa

#### **Chức năng chi tiết:**

##### **4.1. Create Medical Service (Tạo dịch vụ mới)**
- **Actor**: Manager
- **Mô tả**: Thêm dịch vụ mới vào hệ thống
- **Input**:
  - Service Name: "Tẩy trắng răng", "Niềng răng invisalign"...
  - Category: Chọn từ `ServiceCategories`
  - Price: Giá dịch vụ
  - Duration: Thời gian thực hiện (phút)
  - Description: Mô tả chi tiết
  - Image URL: Hình ảnh minh họa
- **Bảng liên quan**: `Services`, `ServiceCategories`

##### **4.2. Update Medical Service (Cập nhật dịch vụ)**
- **Actor**: Manager
- **Mô tả**: Sửa thông tin dịch vụ (giá, mô tả...)

##### **4.3. Delete Medical Service (Xóa dịch vụ)**
- **Actor**: Manager
- **Mô tả**: Xóa hoặc ẩn dịch vụ (soft delete: is_available = 0)

##### **4.4. View Medical Service List (Xem danh sách dịch vụ)**
- **Actor**: Admin, Staff, Patient
- **Mô tả**: Xem danh sách tất cả dịch vụ
- **Hiển thị**: Theo category, có filter và search

##### **4.5. View Medical Service Details (Xem chi tiết dịch vụ)**
- **Actor**: Admin, Staff, Patient
- **Mô tả**: Xem thông tin chi tiết 1 dịch vụ (giá, mô tả, hình ảnh)

##### **4.6. Search Medical Service (Tìm kiếm dịch vụ)**
- **Actor**: Admin, Staff, Patient
- **Mô tả**: Tìm kiếm dịch vụ theo tên, category

---

### 📌 MODULE 5: ORDER / MEDICINE (Quản Lý Thuốc - 4 chức năng)

#### **Mục đích**: Quản lý kho thuốc

#### **Chức năng chi tiết:**

##### **5.1. Add Medicine to Storage (Nhập thuốc vào kho)**
- **Actor**: Manager
- **Mô tả**: Thêm thuốc mới hoặc nhập thêm số lượng
- **Input**:
  - Medicine Name: Tên thuốc
  - Generic Name: Tên hoạt chất
  - Category: Kháng sinh, giảm đau...
  - Manufacturer: Nhà sản xuất
  - Unit: Viên, hộp, chai...
  - Unit Price: Giá đơn vị
  - Stock Quantity: Số lượng tồn kho
  - Description, Side Effects, Contraindications
- **Bảng liên quan**: `Medicines`, `MedicineCategories`

##### **5.2. View Medicine List (Xem danh sách thuốc)**
- **Actor**: Manager
- **Mô tả**: Xem danh sách thuốc trong kho (có stock quantity)

##### **5.3. Update Medicine (Cập nhật thông tin thuốc)**
- **Actor**: Manager
- **Mô tả**: Sửa thông tin thuốc (giá, số lượng, mô tả)

##### **5.4. Delete Medicine (Xóa thuốc)**
- **Actor**: Manager
- **Mô tả**: Xóa thuốc khỏi danh mục (soft delete: is_available = 0)

---

### 📌 MODULE 6: PAYMENT (Thanh Toán - 3 chức năng)

#### **Mục đích**: Quản lý thanh toán và hóa đơn

#### **Chức năng chi tiết:**

##### **6.1. Make Payment (Thanh toán)**
- **Actor**: Patient
- **Mô tả**: Bệnh nhân thanh toán cho appointment hoặc consultation
- **Workflow**:
  1. Hệ thống tính tổng tiền từ:
     - Dịch vụ đã sử dụng (`AppointmentServices`)
     - Thuốc đã kê (`PrescriptionDetails`)
     - Phí tư vấn (nếu có)
  2. Tạo `Invoice` (status = UNPAID)
  3. Tạo `InvoiceItems` (chi tiết từng khoản)
  4. Patient chọn phương thức thanh toán (CASH, CARD, BANK_TRANSFER)
  5. Xác nhận thanh toán → Update `payment_status = PAID`, `payment_date = now()`
- **Bảng liên quan**: `Invoices`, `InvoiceItems`, `Appointments`, `AppointmentServices`

##### **6.2. View Payment List (Xem danh sách hóa đơn)**
- **Actor**: Patient, Staff
- **Mô tả**: Xem danh sách hóa đơn
- **Phân quyền**:
  - **Patient**: Chỉ xem hóa đơn của mình
  - **Staff**: Xem tất cả hóa đơn

##### **6.3. View Payment Detail (Xem chi tiết hóa đơn)**
- **Actor**: Patient, Staff
- **Mô tả**: Xem chi tiết 1 hóa đơn
- **Hiển thị**:
  - Invoice number, date
  - Patient info
  - Danh sách items (service, medicine)
  - Total amount, discount, tax, final amount
  - Payment status, method, date

---

### 📌 MODULE 7: DISCUSSING (Trao Đổi/Tư Vấn - 9 chức năng)

#### **Mục đích**: Tư vấn trực tuyến và quản lý tin tức

#### **Chức năng chi tiết:**

##### **7.1. Chat with ChatBox (Tư vấn qua chatbox)**
- **Actor**: Patient
- **Mô tả**: Bệnh nhân chat với bác sĩ/nhân viên để tư vấn
- **Workflow**:
  1. Patient tạo consultation mới (type = CHAT)
  2. Gửi tin nhắn → Insert `Messages`
  3. Doctor/Staff nhận thông báo → Reply
  4. Conversation 2 chiều real-time
- **Bảng liên quan**: `Consultations`, `Messages`

##### **7.2-7.5. News Management (CRUD tin tức)**
- **7.2. Create News**: Staff tạo bài viết tin tức
- **7.3. View News**: Tất cả xem tin tức (công khai)
- **7.4. Update News**: Staff sửa bài viết
- **7.5. Delete News**: Staff xóa bài viết
- **Bảng liên quan**: `MedicalNews`, `NewsCategories`

##### **7.6-7.9. Messaging (Tin nhắn)**
- **7.6. View Message**: Xem tin nhắn trong consultation
- **7.7. Send Message**: Gửi tin nhắn
- **7.8. View Contact List**: Xem danh sách người liên hệ (doctor, staff)
- **7.9. Search Contact**: Tìm kiếm contact theo tên
- **Bảng liên quan**: `Consultations`, `Messages`, `Users`

---

### 📌 MODULE 8: SYSTEM MANAGEMENT (Quản Trị Hệ Thống - 9 chức năng)

#### **Mục đích**: Quản lý nhân sự và xem báo cáo thống kê

#### **Chức năng chi tiết:**

##### **8.1. View User Statistics (Thống kê user)**
- **Actor**: Manager
- **Mô tả**: Xem thống kê số lượng user theo role
- **Output**:
  - Tổng số Patient, Doctor, Staff
  - Số user active/inactive
  - Biểu đồ user mới theo tháng

##### **8.2. View Account Detail (Xem chi tiết tài khoản)**
- **Actor**: Manager
- **Mô tả**: Xem thông tin chi tiết 1 tài khoản user

##### **8.3. View Revenue Statistics (Thống kê doanh thu)**
- **Actor**: Manager
- **Mô tả**: Xem báo cáo doanh thu
- **Output**:
  - Doanh thu theo ngày/tuần/tháng/năm
  - Doanh thu theo dịch vụ
  - Biểu đồ xu hướng
- **Query**: 
  ```sql
  SELECT SUM(final_amount) FROM Invoices 
  WHERE payment_status = 'PAID' 
  AND payment_date BETWEEN ? AND ?
  ```

##### **8.4. Update Account Password (Đổi mật khẩu cho user khác)**
- **Actor**: Manager
- **Mô tả**: Manager reset password cho user (khi user quên)

##### **8.5. Create Staff (Tạo tài khoản nhân viên)**
- **Actor**: Manager
- **Mô tả**: Tạo tài khoản mới cho nhân viên
- **Input**: Email, Password, Full Name, Position, Department
- **Nghiệp vụ**: 
  - Insert `Users` (role_id = STAFF)
  - Insert `StaffProfiles`

##### **8.6. View Appointment Statistics Reports (Thống kê lịch hẹn)**
- **Actor**: Manager
- **Mô tả**: Xem báo cáo thống kê lịch hẹn
- **Output**:
  - Số lịch hẹn theo trạng thái
  - Tỷ lệ hoàn thành/hủy/no-show
  - Bác sĩ có nhiều lịch hẹn nhất

##### **8.7. Delete Staff (Xóa tài khoản nhân viên)**
- **Actor**: Manager
- **Mô tả**: Xóa tài khoản staff (soft delete: is_active = 0)

##### **8.8. Delete Doctor (Xóa tài khoản bác sĩ)**
- **Actor**: Manager
- **Mô tả**: Xóa tài khoản doctor (soft delete: is_active = 0)

##### **8.9. Create Doctor (Tạo tài khoản bác sĩ)**
- **Actor**: Manager
- **Mô tả**: Tạo tài khoản mới cho bác sĩ
- **Input**: Email, Password, Full Name, Specialization, License Number
- **Nghiệp vụ**:
  - Insert `Users` (role_id = DOCTOR)
  - Insert `DoctorProfiles`

---

## 3. WORKFLOW CHI TIẾT

### 🔄 WORKFLOW 1: QUY TRÌNH ĐẶT LỊCH VÀ KHÁM BỆNH (End-to-End)

```
1. [PATIENT] Đăng nhập hệ thống
   ↓
2. [PATIENT] Xem danh sách bác sĩ → Chọn bác sĩ
   ↓
3. [PATIENT] Xem lịch trống của bác sĩ (từ Schedules)
   ↓
4. [PATIENT] Chọn ngày giờ → Nhập lý do khám → Book Appointment
   ↓ (Insert Appointments, status = PENDING)
   ↓
5. [STAFF] Xem danh sách appointment mới → Xác nhận
   ↓ (Update status = CONFIRMED)
   ↓
6. [PATIENT] Nhận thông báo xác nhận (email/SMS)
   ↓
7. [PATIENT] Đến phòng khám đúng giờ
   ↓
8. [STAFF] Check-in patient → Update status = IN_PROGRESS (optional)
   ↓
9. [DOCTOR] Xem thông tin patient (profile, medical history)
   ↓
10. [DOCTOR] Khám bệnh
    ↓
11. [DOCTOR] Tạo Medical Report:
    - Nhập diagnosis, symptoms, treatment_plan
    - Chọn dịch vụ đã sử dụng → Insert AppointmentServices
    - Kê đơn thuốc → Insert Prescriptions + PrescriptionDetails
    - Nếu cần tái khám → Insert Reexaminations
    ↓ (Insert MedicalReports)
    ↓
12. [STAFF] Update Appointment status = COMPLETED
    ↓
13. [STAFF] Tạo Invoice:
    - Tính tổng tiền từ services + medicines
    - Tạo Invoice + InvoiceItems
    ↓
14. [PATIENT] Thanh toán
    ↓ (Update Invoice: payment_status = PAID, payment_date = now())
    ↓
15. [PATIENT] Nhận hóa đơn → Kết thúc
```

---

### 🔄 WORKFLOW 2: QUY TRÌNH TƯ VẤN TRỰC TUYẾN

```
1. [PATIENT] Đăng nhập → Chọn "Tư vấn trực tuyến"
   ↓
2. [PATIENT] Chọn bác sĩ hoặc staff để chat
   ↓
3. [PATIENT] Nhập chủ đề tư vấn → Bắt đầu consultation
   ↓ (Insert Consultations, status = ACTIVE)
   ↓
4. [PATIENT] Gửi tin nhắn
   ↓ (Insert Messages, sender_id = patient_id)
   ↓
5. [DOCTOR/STAFF] Nhận thông báo → Xem tin nhắn → Reply
   ↓ (Insert Messages, sender_id = doctor/staff_id)
   ↓
6. [PATIENT ↔ DOCTOR] Trao đổi 2 chiều (real-time)
   ↓
7. [DOCTOR] Kết thúc tư vấn
   ↓ (Update Consultations: status = CLOSED, end_time = now())
   ↓
8. [PATIENT] Đánh giá (rating, feedback)
   ↓ (Update Consultations: rating, feedback)
   ↓
9. (Optional) Nếu cần thanh toán → Tạo Invoice
```

---

### 🔄 WORKFLOW 3: QUY TRÌNH QUẢN LÝ KHO THUỐC

```
1. [MANAGER] Nhập thuốc mới vào kho
   ↓ (Insert Medicines, stock_quantity = X)
   ↓
2. [DOCTOR] Khám bệnh → Kê đơn thuốc
   ↓ (Insert PrescriptionDetails: medicine_id, quantity)
   ↓
3. [SYSTEM] Tự động trừ stock:
   ↓ (Update Medicines: stock_quantity = stock_quantity - quantity)
   ↓
4. [SYSTEM] Nếu stock < threshold → Gửi cảnh báo cho Manager
   ↓
5. [MANAGER] Nhập thêm thuốc
```

---

## 4. MAPPING NGHIỆP VỤ → DATABASE

### 📊 Bảng Mapping Chi Tiết

| Nghiệp Vụ | Chức Năng | Bảng Chính | Bảng Liên Quan | CRUD |
|-----------|-----------|-----------|----------------|------|
| **AUTHENTICATION** |||||
| Đăng ký | Register | Users | PatientProfiles | C |
| Đăng nhập | Sign In | Users | Roles, UserSessions | R |
| Xem profile | View Profile | Users | DoctorProfiles / PatientProfiles / StaffProfiles | R |
| Cập nhật profile | Update Profile | Users | Profiles tương ứng | U |
| Đổi mật khẩu | Change Password | Users | - | U |
| **APPOINTMENT** |||||
| Đặt lịch | Book Appointment | Appointments | Users, Schedules, AppointmentStatuses | C |
| Xem lịch hẹn | View Appointments | Appointments | Users, AppointmentStatuses | R |
| Hủy lịch | Cancel Appointment | Appointments | - | U |
| Cập nhật trạng thái | Update Status | Appointments | AppointmentStatuses | U |
| Tạo lịch làm việc | Create Schedule | Schedules | Users | C |
| **TREATMENT** |||||
| Tạo hồ sơ bệnh án | Create Medical Record | MedicalReports | Appointments, AppointmentServices | C |
| Kê đơn thuốc | Create Prescription | Prescriptions, PrescriptionDetails | Medicines | C |
| Xem lịch sử khám | View History | MedicalReports | Appointments, Users | R |
| Tạo lịch tái khám | Create Reexamination | Reexaminations | Appointments | C |
| **SERVICE** |||||
| Quản lý dịch vụ | CRUD Service | Services | ServiceCategories | CRUD |
| Thêm dịch vụ vào appointment | Add Service | AppointmentServices | Services, Appointments | C |
| **MEDICINE** |||||
| Quản lý thuốc | CRUD Medicine | Medicines | MedicineCategories | CRUD |
| Nhập kho | Add Medicine | Medicines | - | C/U |
| **PAYMENT** |||||
| Tạo hóa đơn | Create Invoice | Invoices, InvoiceItems | Appointments, AppointmentServices | C |
| Thanh toán | Make Payment | Invoices | - | U |
| Xem hóa đơn | View Invoice | Invoices, InvoiceItems | - | R |
| **CONSULTATION** |||||
| Tư vấn trực tuyến | Chat | Consultations, Messages | Users | C |
| Gửi tin nhắn | Send Message | Messages | Consultations | C |
| **NEWS** |||||
| Quản lý tin tức | CRUD News | MedicalNews | NewsCategories, Users | CRUD |
| **SYSTEM** |||||
| Thống kê user | View User Stats | Users | Roles | R |
| Thống kê doanh thu | View Revenue | Invoices | InvoiceItems | R |
| Quản lý nhân sự | CRUD Staff/Doctor | Users | DoctorProfiles, StaffProfiles | CRUD |

---

## 5. USE CASE DIAGRAM

### 🎭 Use Case - PATIENT

```
PATIENT
  │
  ├─── Đăng ký tài khoản (Register)
  ├─── Đăng nhập (Sign In)
  ├─── Xem/Cập nhật Profile
  ├─── Đổi mật khẩu
  │
  ├─── Xem danh sách bác sĩ
  ├─── Đặt lịch hẹn (Book Appointment)
  ├─── Xem lịch hẹn của mình
  ├─── Xem chi tiết lịch hẹn
  │
  ├─── Xem hồ sơ bệnh án của mình
  ├─── Xem lịch sử khám bệnh
  ├─── Xem lịch tái khám
  │
  ├─── Xem danh sách dịch vụ
  ├─── Xem chi tiết dịch vụ
  │
  ├─── Thanh toán (Make Payment)
  ├─── Xem hóa đơn của mình
  │
  ├─── Tư vấn trực tuyến (Chat)
  ├─── Gửi/Nhận tin nhắn
  │
  └─── Xem tin tức y tế
```

### 🩺 Use Case - DOCTOR

```
DOCTOR
  │
  ├─── Đăng nhập
  ├─── Xem/Cập nhật Profile
  │
  ├─── Xem lịch hẹn của mình
  ├─── Xem chi tiết bệnh nhân
  │
  ├─── Tạo hồ sơ bệnh án (Create Medical Record)
  ├─── Cập nhật hồ sơ bệnh án
  ├─── Xem lịch sử khám của bệnh nhân
  │
  ├─── Kê đơn thuốc (Create Prescription)
  ├─── Thêm dịch vụ vào appointment
  │
  ├─── Tạo yêu cầu tái khám (Create Reexamination)
  ├─── Xem lịch tái khám
  │
  ├─── Tư vấn trực tuyến (Reply chat)
  │
  └─── Xem tin tức
```

### 👨‍💼 Use Case - STAFF

```
STAFF
  │
  ├─── Đăng nhập
  ├─── Xem/Cập nhật Profile
  │
  ├─── Quản lý lịch hẹn:
  │     ├─── Đặt lịch cho bệnh nhân
  │     ├─── Xem tất cả lịch hẹn
  │     ├─── Xác nhận lịch hẹn
  │     ├─── Hủy lịch hẹn
  │     ├─── Cập nhật ngày giờ
  │     ├─── Cập nhật trạng thái
  │     └─── Tìm kiếm/Lọc
  │
  ├─── Quản lý lịch làm việc bác sĩ:
  │     ├─── Tạo lịch làm việc
  │     ├─── Sửa lịch làm việc
  │     └─── Sắp xếp lịch hẹn
  │
  ├─── Xem hồ sơ bệnh án (của tất cả bệnh nhân)
  ├─── Xem lịch tái khám
  │
  ├─── Xem hóa đơn (của tất cả)
  │
  ├─── Tư vấn trực tuyến (Reply chat)
  │
  └─── Quản lý tin tức (CRUD News)
```

### 🏢 Use Case - MANAGER

```
MANAGER
  │
  ├─── Đăng nhập
  ├─── Xem/Cập nhật Profile
  │
  ├─── Quản lý dịch vụ (CRUD Medical Service)
  ├─── Quản lý thuốc (CRUD Medicine)
  │
  ├─── Quản lý nhân sự:
  │     ├─── Tạo tài khoản Doctor
  │     ├─── Tạo tài khoản Staff
  │     ├─── Xóa Doctor
  │     ├─── Xóa Staff
  │     ├─── Xem chi tiết tài khoản
  │     └─── Reset password
  │
  ├─── Xem thống kê:
  │     ├─── Thống kê user
  │     ├─── Thống kê doanh thu
  │     └─── Thống kê lịch hẹn
  │
  └─── Xem tin tức
```

---

## 6. BUSINESS RULES QUAN TRỌNG

### ⚠️ Các Ràng Buộc Nghiệp Vụ Cần Lưu Ý

#### **1. Appointment Rules**
- ✅ Không được đặt trùng giờ (cùng doctor, cùng time slot)
- ✅ Chỉ đặt trong khung giờ làm việc (từ `Schedules`)
- ✅ Duration mặc định: 30 phút (có thể custom)
- ✅ Chỉ hủy được appointment có status = PENDING hoặc CONFIRMED
- ✅ Status flow: PENDING → CONFIRMED → COMPLETED/CANCELLED/NO_SHOW

#### **2. Medical Report Rules**
- ✅ 1 appointment chỉ có 1 medical report
- ✅ Chỉ tạo report cho appointment có status = COMPLETED
- ✅ Doctor chỉ tạo report cho appointment của mình

#### **3. Payment Rules**
- ✅ Tổng tiền = Services + Medicines + Consultation Fee
- ✅ Final Amount = Total - Discount + Tax
- ✅ Chỉ thanh toán khi appointment đã COMPLETED
- ✅ 1 appointment có thể có nhiều invoice (nếu thanh toán nhiều lần)

#### **4. Medicine Stock Rules**
- ✅ Khi kê đơn thuốc → Tự động trừ stock
- ✅ Không cho phép kê đơn nếu stock < quantity
- ✅ Cảnh báo khi stock < threshold (ví dụ: 10 viên)

#### **5. Schedule Rules**
- ✅ Không cho phép tạo appointment ngoài work schedule
- ✅ Nếu bác sĩ nghỉ phép (LEAVE) → Không hiển thị trong danh sách chọn
- ✅ Không cho phép sửa schedule nếu đã có appointment trong khung giờ đó

#### **6. Authorization Rules**
- ✅ Patient chỉ xem được dữ liệu của mình
- ✅ Doctor chỉ xem/sửa được appointment của mình
- ✅ Staff xem được tất cả nhưng chỉ CRUD một số entity
- ✅ Manager có quyền cao nhất (xem thống kê, CRUD user, service, medicine)

---

## 7. DATA FLOW DIAGRAM (DFD) - Level 0

```
                    ┌─────────────────────────┐
                    │  DENTAL CLINIC SYSTEM   │
                    └─────────────────────────┘
                               │
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
        ▼                      ▼                      ▼
  ┌─────────┐           ┌─────────┐           ┌─────────┐
  │ PATIENT │           │ DOCTOR  │           │  STAFF  │
  └─────────┘           └─────────┘           └─────────┘
        │                      │                      │
        │ - Đặt lịch hẹn       │ - Khám bệnh         │ - Quản lý lịch
        │ - Xem hồ sơ          │ - Tạo báo cáo       │ - Xác nhận lịch
        │ - Thanh toán         │ - Kê đơn thuốc      │ - Tạo hóa đơn
        │ - Tư vấn online      │ - Tư vấn            │ - Tư vấn
        │                      │                      │
        └──────────────────────┼──────────────────────┘
                               │
                               ▼
                         ┌──────────┐
                         │ MANAGER  │
                         └──────────┘
                               │
                    - Quản lý user
                    - Quản lý service/medicine
                    - Xem thống kê
```

---

## 8. KẾT LUẬN VÀ KHUYẾN NGHỊ

### ✅ Điểm Mạnh Của Thiết Kế

1. **Phân quyền rõ ràng**: 4 roles với quyền hạn cụ thể
2. **Workflow đầy đủ**: Từ đặt lịch → khám → kê đơn → thanh toán
3. **Tích hợp tư vấn trực tuyến**: Chat real-time giữa patient-doctor
4. **Quản lý kho thuốc**: Tự động trừ stock khi kê đơn
5. **Báo cáo thống kê**: Dashboard cho manager

### 🚀 Đề Xuất Mở Rộng Trong Tương Lai

1. **Notification System**: Gửi email/SMS tự động khi:
   - Appointment được xác nhận
   - Sắp đến lịch hẹn (1 ngày trước)
   - Có tin nhắn mới
   - Sắp đến lịch tái khám

2. **File Upload**: Cho phép upload hình ảnh X-quang, kết quả xét nghiệm

3. **Rating System**: Bệnh nhân đánh giá bác sĩ sau mỗi lần khám

4. **Queue Management**: Quản lý hàng đợi trong phòng khám

5. **Integration với bên thứ 3**:
   - Payment gateway (VNPay, Momo)
   - Email service (SendGrid)
   - SMS service (Twilio)

---

**LƯU Ý**: Tài liệu này phân tích nghiệp vụ dựa trên file project tracking. Khi triển khai, cần trao đổi thêm với khách hàng để xác nhận chi tiết và có thể điều chỉnh cho phù hợp.

**HẾT PHẦN PHÂN TÍCH NGHIỆP VỤ**
