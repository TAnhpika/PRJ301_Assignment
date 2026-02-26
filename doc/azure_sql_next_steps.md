# Azure SQL – Làm tiếp sau khi đã tạo xong database

Bạn đã có **benhvien-sql-server** và database **BenhVien**. Làm lần lượt 5 việc dưới đây.

---

## 1. Mở Firewall (bắt buộc – không có thì không kết nối được)

1. Azure Portal → **SQL servers** (search hoặc từ resource group) → chọn **benhvien-sql-server**.
2. Menu trái: **Security** → **Networking** (hoặc **Networking**).
3. **Add firewall rule:**
   - Rule name: `MyPC`
   - Start IP / End IP: **IP public** của bạn (google “what is my ip”).
4. (Tùy chọn) Bật **Allow Azure services and resources to access this server**.
5. **Save**.

Nếu bạn bè dùng chung: thêm rule tương tự với **IP public** của họ.

---

## 2. Kết nối Azure SQL trong Azure Data Studio (kiểm tra)

- **New Connection** (icon dây cắm hoặc Connections).
- Server: `benhvien-sql-server.database.windows.net`, SQL Login, Database: `BenhVien`, Encrypt: Mandatory.
- Connect xong bạn sẽ thấy server Azure bên cạnh `localhost` trong SERVERS (database Azure lúc này thường trống).

## 3. Migrate dữ liệu từ local lên Azure (DB Azure đang trống – bắt buộc làm bước này)

DB trên Azure **chưa có bảng** cho đến khi bạn copy schema + data từ local lên.

1. **Connection localhost:** Chuột phải **BenhVien** (database) → **Generate Script** / **Script as CREATE**.
2. Trong wizard: chọn **Tables**, bật **Script data** nếu có → lưu file (vd. `BenhVien_export.sql`).
3. **Connection Azure** (benhvien-sql-server...): **New Query** → **File** → **Open File** → mở file `.sql` → **Run** (F5).
4. Xong: chuột phải **BenhVien** (Azure) → **Refresh** → mở **Tables** sẽ thấy bảng.

---

## 4. Cấu hình app (project) dùng Azure SQL

Tạo/sửa file **`.env`** ở thư mục gốc project (copy từ `.env.example`):

```
DB_HOST=benhvien-sql-server.database.windows.net
DB_PORT=1433
DB_NAME=BenhVien
DB_USERNAME=sqladmin
DB_PASSWORD=<mật_khẩu_azure>
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=false
```

Chạy app: đảm bảo Tomcat/Java đọc được `.env` (hoặc set VM option `-Denv.file=...` nếu cần).

---

## 5. Chia sẻ cho bạn bè

- Gửi: **Server** `benhvien-sql-server.database.windows.net`, **Database** `BenhVien`, **User**, **Password** (password gửi kênh riêng).
- Nhắc bạn bè: thêm **IP public** của họ vào Firewall (bước 1) và tạo `.env` giống bước 4 trên máy họ.

---

## Kết nối bằng Azure Data Studio

**1. Trên Azure Portal (trang Networking của server):**  
- Bấm **"+ Add your client IPv4 address (xx.xx.xx.xx)"** → IP máy bạn được thêm vào firewall.  
- Bấm **Save** (bắt buộc).

**2. Trong Azure Data Studio:**  
- **New Connection** (hoặc biểu tượng dây cắm).  
- **Server:** `benhvien-sql-server.database.windows.net`  
- **Authentication:** SQL Login  
- **User name:** `sqladmin` (hoặc user bạn đặt khi tạo server)  
- **Password:** mật khẩu Azure SQL  
- **Database:** `BenhVien`  
- **Encrypt:** Mandatory (Azure bắt buộc)  
- **Trust server certificate:** Off  
- Bấm **Connect**.

Sau khi kết nối: xem Tables, chạy query, New Query như khi dùng SQL local.

Chi tiết đầy đủ: `doc/azure_sql_share_database.md`.
