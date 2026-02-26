# Chia sẻ database với bạn bè qua Azure SQL

Tài liệu hướng dẫn **từng bước** để đưa database **BenhVien** (đang chạy local SQL Server) lên **Azure SQL** để bạn và bạn bè cùng dùng chung một database.

---

## Tóm tắt nhanh

| Bước | Việc cần làm |
|------|----------------|
| 1 | Tạo tài khoản Azure (nếu chưa có) và tạo Azure SQL Server + Database |
| 2 | Cho phép IP của bạn và bạn bè kết nối (Firewall) |
| 3 | Đưa dữ liệu từ local lên Azure (backup/restore hoặc script) |
| 4 | Chia sẻ **connection string** (và user/password) cho bạn bè một cách an toàn |
| 5 | Cấu hình app (context.xml / DBContext) trỏ vào Azure SQL |

---

## Bước 1: Tạo Azure SQL Server và Database

### 1.1 Đăng nhập Azure

- Vào [https://portal.azure.com](https://portal.azure.com)
- Đăng nhập (hoặc tạo tài khoản miễn phí)

### 1.2 Trang "Azure SQL" – chọn đúng loại

Khi vào **Azure SQL** (Marketplace), bạn sẽ thấy nhiều lựa chọn:

| Loại | Dùng khi nào | Bạn chọn |
|------|----------------|----------|
| **Azure SQL Database** | Chia sẻ DB, học tập, app nhỏ – **đơn giản, rẻ** | **Cái này** |
| Azure SQL Database Hyperscale | DB rất lớn, scale cực mạnh | Không cần |
| Azure SQL Managed Instance | Migrate cả instance SQL Server từ on‑prem | Không cần |
| SQL Server on VM | Chạy SQL trên máy ảo, tự quản lý | Không cần |

**Làm:** Trên trang đó, tìm thẻ **"Azure SQL Database"** (mô tả: "Build applications using a fully managed SQL database...") → bấm **"Show options"** (hoặc chọn vào thẻ rồi chọn Create). Không chọn Hyperscale hay Managed Instance.

### 1.3a Tạo database **MIỄN PHÍ** (Free offer – Azure for Students)

Khi bạn thấy màn hình **Create SQL Database** với dòng **"Free offer applied! You get 100,000 vCore seconds, 32GB of data, and 32GB of backup storage free..."** và **Estimated total: Free**:

1. **Sửa lỗi "No servers found":**
   - Ở mục **Server \*** (có chữ đỏ "No servers found in the selected resource group"), bấm **"Create new"**.
   - Cửa sổ **Create SQL server** mở ra.

2. **Điền form Create SQL server:**
   - **Server name:** đặt tên (vd. `free-sql-server`) → sau này kết nối qua `free-sql-server.database.windows.net`.
   - **Location:** **Southeast Asia**.
   - **Authentication method:** **Use SQL authentication**.
   - **Server admin login:** vd. `sqladmin`.
   - **Password** và **Confirm password:** đặt mật khẩu, **ghi lại**.
   - Bấm **OK**.

3. **Quay lại form database:**
   - Ô **Server** sẽ hiển thị server vừa tạo, lỗi biến mất.
   - **Database name:** có thể đổi thành `BenhVien` (hoặc giữ `free-sql-db-6522624`).
   - **Không** bấm "Advanced configuration" nếu muốn giữ đúng gói Free (32 GB, không phát sinh phí).

4. **Tạo database:**
   - Bấm **Review + create**.
   - Kiểm tra **Cost summary** bên phải vẫn là **Estimated total: Free**.
   - Bấm **Create**.

5. Đợi vài phút. Sau khi xong: vào **Networking** của server để thêm IP (Bước 2 trong doc), rồi migrate dữ liệu và cấu hình app.

### 1.3 Các bước tạo database (từ màn hình "SQL databases")

Bạn đang ở trang **Azure SQL | SQL databases** (No SQL databases to display):

1. **Bấm nút "+ Create"** (nút xanh, giữa màn hình hoặc trên toolbar).

2. **Tab Basics:**
   - **Subscription:** chọn (vd. Azure for Students).
   - **Resource group:** chọn **Create new** → đặt tên (vd. `rg-benhnhau`) hoặc chọn sẵn.
   - **Database name:** `BenhVien`.
   - **Server:** chọn **Create new**:
     - **Server name:** tên duy nhất (vd. `benhvien-sql-server`) → sau này kết nối qua `benhvien-sql-server.database.windows.net`.
     - **Location:** **Southeast Asia** (hoặc gần bạn).
     - **Authentication method:** **Use SQL authentication**.
     - **Server admin login:** vd. `sqladmin`.
     - **Password** / **Confirm password:** đặt mật khẩu mạnh, **ghi lại** (để chia sẻ cho bạn bè và cấu hình app).
   - **Want to use SQL elastic pool?** → **No**.
   - **Compute + storage:** bấm **Configure database** → chọn **Basic** (rẻ, đủ dùng) → **Apply**.

3. **Tab Networking (tùy chọn ngay hoặc làm sau):**
   - Có thể bật **Allow Azure services and resources to access this server**.
   - Firewall: sau khi tạo xong sẽ thêm IP ở Bước 2 bên dưới.

4. **Review + create** → kiểm tra thông tin → **Create**.

5. Đợi vài phút. Khi deployment xong, bạn có **server** + **database**; tiếp theo làm **Bước 2** (Firewall) rồi migrate dữ liệu (Bước 3).

Đợi vài phút, khi xong bạn sẽ có:

- **Server**: `benhvien-sql-server.database.windows.net`
- **Database**: `BenhVien`
- **User**: `sqladmin` (hoặc tên bạn đặt)
- **Password**: (mật khẩu bạn đặt)

---

## Sau khi deployment xong ("Your deployment is complete")

1. Bấm **Go to resource group** (hoặc vào **SQL servers** → chọn `benhvien-sql-server`).
2. Làm ngay **Bước 2** (Firewall) để máy bạn kết nối được.
3. Rồi **Bước 3** (migrate dữ liệu), **Bước 4** (chia sẻ cho bạn bè), **Bước 5** (cấu hình app).

---

## Bước 2: Mở Firewall để bạn và bạn bè kết nối được

Azure SQL mặc định chặn mọi IP. Cần thêm IP của **máy bạn** và **máy bạn bè**.

1. Trong Azure Portal: vào **SQL servers** → chọn server vừa tạo (ví dụ `benhvien-sql-server`)
2. Menu trái: **Security** → **Networking** (hoặc **Firewalls and virtual networks**)
3. **Firewall rules**:
   - Thêm rule cho máy bạn:
     - Rule name: `MyPC`
     - Start IP / End IP: điền **IP public** của bạn (google “what is my ip”)
   - Thêm rule cho bạn bè:
     - Rule name: `FriendPC`
     - Start IP / End IP: **IP public** của bạn bè (bạn bè gửi cho bạn)
4. Bật **Allow Azure services and resources to access this server** nếu bạn sau này deploy app lên Azure.
5. **Save**.

**Lưu ý:** IP nhà/di động thường đổi. Nếu sau này không kết nối được, vào đây thêm lại IP mới.

---

## Bước 3: Đưa dữ liệu từ local (BenhVien) lên Azure

Bạn đang có DB **BenhVien** trên **localhost** trong Azure Data Studio. Có 2 cách phổ biến:

### Cách A: Backup từ local → Restore lên Azure (khuyên dùng)

1. **Trên máy local (Azure Data Studio nối localhost):**
   - Chuột phải database **BenhVien** → **Backup...**
   - Chọn thư mục lưu file `.bak`, đặt tên ví dụ `BenhVien_backup.bak`
   - Backup xong, bạn có 1 file backup.

2. **Restore vào Azure:**
   - Azure SQL **không restore trực tiếp file .bak từ máy local**.
   - Cách đơn giản: dùng **Azure Data Studio** nối vào **Azure SQL** (server `benhvien-sql-server.database.windows.net`), sau đó dùng tính năng **Import** hoặc chạy script (xem Cách B).

### Cách B: Script schema + data (phù hợp DB không quá lớn)

1. **Trên Azure Data Studio (nối localhost):**
   - Chuột phải **BenhVien** → **Generate Script...** (hoặc **Script as CREATE**)
   - Chọn toàn bộ bảng (Tables), có thể chọn “Script data” nếu công cụ hỗ trợ.
   - Lưu thành file `.sql`.

2. **Tạo schema trên Azure:**
   - Nối Azure Data Studio tới server Azure: `benhvien-sql-server.database.windows.net`, database `BenhVien`, user `sqladmin` + password.
   - Mở file `.sql` vừa tạo → chạy từng phần (tạo bảng trước, sau đó insert data nếu có).

3. **Data:**
   - Nếu “Generate Script” không xuất data, có thể dùng **Export** (Tables → Export to CSV/Excel) rồi **Import** vào bảng trên Azure, hoặc viết script INSERT từ bảng local sang.

Sau bước này, database **BenhVien** trên Azure đã có đủ bảng và dữ liệu.

---

## Bước 4: Chia sẻ thông tin kết nối cho bạn bè (an toàn)

**Connection string** dạng:

```text
Server=benhvien-sql-server.database.windows.net,1433;Database=BenhVien;User ID=sqladmin;Password=<MẬT_KHẨU>;Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;
```

**Cách chia sẻ an toàn:**

- **Không** gửi password qua Facebook/Zalo/email dạng plain text.
- Gửi **password** qua kênh riêng tư (tin nhắn riêng, hoặc app mã hóa).
- Chỉ gửi cho người cần dùng chung DB.
- Nếu có thể: tạo **user riêng** cho bạn bè (chỉ quyền đọc/ghi cần thiết) thay vì dùng chung `sqladmin`.

**Thông tin cần gửi cho bạn bè:**

1. Server: `benhvien-sql-server.database.windows.net`
2. Port: `1433`
3. Database: `BenhVien`
4. User: `sqladmin` (hoặc user bạn tạo cho họ)
5. Password: (gửi riêng, an toàn)
6. Lưu ý: **Encrypt=true**, **TrustServerCertificate=false** (Azure yêu cầu).

---

## Bước 5: Cấu hình app (project) dùng Azure SQL

Project của bạn đang kết nối DB ở 2 chỗ:

- **Tomcat JNDI**: `web/META-INF/context.xml`
- **Java trực tiếp**: `src/java/utils/DBContext.java`

Để **cả bạn và bạn bè** cùng chạy app mà dùng chung Azure SQL:

### 5.1 Sửa `context.xml` (khi chạy app bằng Tomcat)

Mở `web/META-INF/context.xml`, sửa phần `Resource`:

- `url`: trỏ sang Azure, ví dụ:
  - `jdbc:sqlserver://benhvien-sql-server.database.windows.net:1433;databaseName=BenhVien;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;`
- `username`: `sqladmin` (hoặc user Azure bạn tạo)
- `password`: mật khẩu Azure

**Lưu ý:** File `context.xml` có thể chứa password. **Không commit password thật lên Git.** Có thể để password trống trong file, rồi điền trong Tomcat context hoặc dùng biến môi trường (tùy cách bạn cấu hình).

### 5.2 Sửa `DBContext.java` (khi code gọi `DBContext.getConnection()`)

Trong `src/java/utils/DBContext.java`:

- `dbURL`: đổi thành URL Azure, ví dụ:
  - `jdbc:sqlserver://benhvien-sql-server.database.windows.net:1433;databaseName=BenhVien;encrypt=true;trustServerCertificate=false;loginTimeout=30;`
- `userDB`: user Azure
- `passDB`: password Azure

**Cấu hình nhanh bằng .env (đã hỗ trợ trong project):**

Project đã cấu hình `DBContext.java` đọc từ file `.env`. Bạn và bạn bè **chỉ cần** tạo/sửa file `.env` ở thư mục gốc project (copy từ `.env.example`), không cần sửa code:

- **Chạy local (SQL Server trên máy):**
  - `DB_HOST=localhost`
  - `DB_PORT=1433`
  - `DB_NAME=BenhVien`
  - `DB_USERNAME=sa`
  - `DB_PASSWORD=<mật_khẩu_local>`

- **Chạy với Azure SQL (dùng chung với bạn bè):**
  - `DB_HOST=benhvien-sql-server.database.windows.net`
  - `DB_PORT=1433`
  - `DB_NAME=BenhVien`
  - `DB_USERNAME=sqladmin`
  - `DB_PASSWORD=<mật_khẩu_azure>`
  - `DB_ENCRYPT=true`
  - `DB_TRUST_SERVER_CERTIFICATE=false`

**Lưu ý:** File `.env` không được commit lên Git (đã có trong `.gitignore`). Mỗi người tự tạo `.env` và điền thông tin Azure (hoặc local) trên máy mình.

Sau khi cấu hình `.env`, bạn và bạn bè chỉ cần:

- Cùng dùng **một bộ** `context.xml` / `DBContext` (hoặc cùng `.env`) trỏ Azure,
- Và **IP của mỗi người** đã được thêm vào Firewall Azure (Bước 2),

là cả hai có thể chạy app và dùng chung database trên Azure.

---

## Dùng Azure Data Studio kết nối trực tiếp Azure SQL

Sau khi tạo xong Azure SQL Server + database, bạn (và bạn bè) có thể **mở Azure Data Studio** và làm việc với database trên cloud giống như đang dùng local.

### Cách thêm connection trong Azure Data Studio

1. Mở **Azure Data Studio**.
2. Bấm **New Connection** (hoặc **Connections** → **New Connection**).
3. Điền:
   - **Server:** `ten-server.database.windows.net` (ví dụ `benhvien-sql-server.database.windows.net`)
   - **Authentication type:** **SQL Login**
   - **User name:** user Azure (ví dụ `sqladmin`)
   - **Password:** mật khẩu Azure
   - **Database:** `BenhVien` (hoặc để `<Default>` nếu server chỉ có 1 DB)
   - **Encrypt:** chọn **Mandatory** (Azure bắt buộc mã hóa)
   - **Trust server certificate:** thường **Off**
4. Bấm **Connect**.

Sau khi kết nối, bạn có thể:
- Xem **Tables**, chạy query, xem/sửa dữ liệu như với local.
- Chuột phải database → **New Query** để gõ SQL.
- Backup/export, import dữ liệu từ giao diện quen thuộc.

**Lưu ý:** Máy của bạn (hoặc bạn bè) phải có **IP đã được thêm vào Firewall** của Azure SQL (Bước 2 ở trên). Nếu không kết nối được, kiểm tra lại Firewall và IP public.

---

## Checklist nhanh

- [ ] Tạo Azure SQL Server + Database `BenhVien`
- [ ] Thêm Firewall rule cho IP của bạn và bạn bè
- [ ] Migrate dữ liệu từ local BenhVien lên Azure
- [ ] Chia sẻ connection info (và password an toàn) cho bạn bè
- [ ] Sửa `context.xml` và `DBContext.java` (hoặc .env) trỏ sang Azure
- [ ] Test kết nối từ Azure Data Studio và từ app (cả bạn và bạn bè)

---

## Lưu ý bảo mật

- Đổi password Azure định kỳ; khi đổi nhớ cập nhật lại trong app và gửi lại cho bạn bè (kênh an toàn).
- Không commit file chứa password thật (context.xml, .env) lên GitHub/public repo.
- Nếu chỉ bạn bè cần đọc/ghi một số bảng, nên tạo user SQL riêng với quyền tối thiểu thay vì dùng chung tài khoản admin.

Nếu bạn muốn, bước tiếp theo có thể là: viết giúp đoạn code mẫu trong `DBContext.java` đọc `DB_HOST`, `DB_NAME`, `DB_USERNAME`, `DB_PASSWORD` từ `Env.get(...)` để dùng cả local và Azure mà không sửa code.
