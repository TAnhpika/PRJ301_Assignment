# So sánh src/dental_clinic.sql với code dự án

## Kết luận nhanh

File **dental_clinic.sql** gần đúng với phần lớn nghiệp vụ (Appointment, Doctors, Patients, Services, Bills cơ bản, MedicalReport, Prescription, …) nhưng có **một số lỗi cần sửa** để chạy script từ đầu không lỗi và khớp với code Java.

---

## Các lỗi cần sửa trong file SQL

### 1. Bảng **Bills** thiếu cột `appointment_id`

- **Code dùng:** `AppointmentDAO` có `DELETE FROM Bills WHERE appointment_id = ?`; `BillDAO.createBill(int appointmentId, ...)` có `INSERT INTO Bills (appointment_id, patient_id, user_id, amount, payment_method, status)`.
- **File SQL:** Bảng `Bills` không có cột `appointment_id`.
- **Cách sửa:** Thêm cột `[appointment_id] INT NULL` vào `Bills` và có thể thêm FK tới `Appointment(appointment_id)`. Nếu đã có dữ liệu, dùng `ALTER TABLE` sau khi tạo bảng.

### 2. **Tạo bảng trùng**

- **Patients:** CREATE TABLE `Patients` xuất hiện **2 lần** (khoảng dòng 224 và 261). Lần thứ hai sẽ báo lỗi "object already exists".
- **PaymentInstallments:** CREATE TABLE `PaymentInstallments` xuất hiện **2 lần** (khoảng dòng 236 và 279). Cần xóa một định nghĩa trùng.

### 3. **Bảng Reexamination tạo 2 lần với schema khác nhau**

- Lần 1 (khoảng dòng 364): có `reexam_type`, `created_by` (doctor), `status` PENDING/COMPLETED/CANCELLED.
- Lần 2 (khoảng dòng 455): có `reexam_count`, `approved_by`, `scheduled_appointment_id`, `status` active/booked/completed/cancelled.
- **Cách xử lý:** Chỉ giữ **một** định nghĩa bảng `Reexamination` và thống nhất cột theo nghiệp vụ thật (servlet/DAO đang dùng bảng nào). Xóa bản còn lại hoặc đổi tên nếu là bảng khác.

### 4. **Bảng MedicalReport thiếu cột `is_reexam_lan_2`**

- **Code:** `DoctorDAO.insertMedicalReport(..., boolean isReexamLan2)` insert vào `MedicalReport (..., is_reexam_lan_2)`.
- **File SQL:** Bảng `MedicalReport` không có cột `is_reexam_lan_2`.
- **Cách sửa:** Thêm `[is_reexam_lan_2] BIT NULL DEFAULT 0` (hoặc NOT NULL DEFAULT 0) vào định nghĩa `MedicalReport`.

### 5. **Trigger TR_StaffSchedule_ApprovedAt dùng biến chưa định nghĩa**

- Trong trigger có `WHERE i.[status] <> d.[status]` nhưng trong `FROM` chỉ có `inserted i` và `[dbo].[StaffSchedule] s`, không có `deleted d`.
- **Cách sửa:** Thêm `INNER JOIN deleted d ON s.[schedule_id] = d.[schedule_id]` và giữ `WHERE i.[status] <> d.[status]`.

### 6. **Thứ tự tạo bảng – FK tới Relatives**

- Bảng **Appointment** có `FOREIGN KEY ([relative_id]) REFERENCES [dbo].[Relatives]([relative_id])` nhưng **Relatives** được tạo **sau** Appointment (Appointment ở đầu file, Relatives ở cuối). Chạy script từ trên xuống sẽ lỗi vì `Relatives` chưa tồn tại.
- **Cách sửa:** Tạo bảng **Relatives** (và **users** nếu cần) **trước** khi tạo **Appointment**, hoặc tạo Appointment không có FK tới Relatives rồi sau đó `ALTER TABLE Appointment ADD CONSTRAINT ... REFERENCES Relatives`.

---

## Khớp với code (đã ổn)

- **Doctors:** Tên bảng và cột `license_number` khớp với `DoctorDAO` và entity.
- **Bills:** Các cột dùng trong `BillDAO.createBill(Bill bill)` (bill_id, order_id, service_id, patient_id, user_id, amount, original_price, discount_amount, tax_amount, payment_method, payment_status, customer_name, customer_phone, customer_email, doctor_id, appointment_date, appointment_time, appointment_notes, notes) đều có trong file SQL (chỉ thiếu `appointment_id` như trên).
- **MedicalReport / Prescription:** Phần lớn code dùng bảng `MedicalReport` và `Prescription` (PascalCase) với report_id, appointment_id, doctor_id, patient_id, diagnosis, treatment_plan, note, sign – khớp với SQL (chỉ thiếu `is_reexam_lan_2`).
- **Appointment, Patients, users, TimeSlot, Services, Staff, DoctorSchedule, ChatMessages, Notifications, Blog, UserFaceImages, Relatives:** Tên bảng và cột cơ bản khớp với cách dùng trong project.

---

## Lưu ý khác (không nằm trong file SQL)

- Một số đoạn trong **DoctorDAO** tham chiếu bảng **snake_case** như `medical_reports`, `doctor_schedules`, `payment_links`, `appointment_feedbacks`, `prescriptions` (với cột kiểu medicine_name, dosage, …). Trong file SQL hiện tại chỉ có **MedicalReport**, **DoctorSchedule**, **Prescription** (PascalCase, schema khác). Nếu chạy đúng với DB hiện tại (BenhVien) thì phần đang dùng là **MedicalReport** / **Prescription** trong file SQL; các bảng snake_case có thể là code cũ hoặc module khác – cần thống nhất một bộ schema.

---

## Checklist sau khi sửa file SQL (đã áp dụng trong repo)

- [x] Thêm `appointment_id` vào `Bills` và FK `FK_Bills_Appointment`.
- [x] Xóa một trong hai khối CREATE `Patients` và một trong hai khối CREATE `PaymentInstallments`.
- [x] Chỉ giữ một bảng `Reexamination` (đã xóa bản trùng schema khác).
- [x] Thêm cột `is_reexam_lan_2` vào `MedicalReport`.
- [x] Sửa trigger `TR_StaffSchedule_ApprovedAt`: thêm `INNER JOIN deleted d`.
- [x] Điều chỉnh thứ tự: bỏ FK `Appointment` → `Relatives` trong CREATE; sau khi tạo `Relatives` thêm `ALTER TABLE Appointment ADD CONSTRAINT FK_Appointment_Relatives ...`.

Sau khi sửa xong, chạy lại toàn bộ script trên DB trống (hoặc Azure) để kiểm tra không còn lỗi.
