USE PRJ301_ASSIGNMENT_DENTAL_CLINIC;
GO

/* ==============================================================
   1. BẢNG SPECIALTIES & BỔ SUNG CỘT CHO DOCTORS
============================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Specialties]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Specialties] (
        [specialty_id]   INT            IDENTITY (1, 1) NOT NULL,
        [specialty_name] NVARCHAR (255) NOT NULL,
        [description]    NVARCHAR (MAX) NULL,
        [created_at]     DATETIME2 (7)  DEFAULT (getdate()) NULL,
        PRIMARY KEY CLUSTERED ([specialty_id] ASC)
    );
    
    INSERT INTO [dbo].[Specialties] ([specialty_name], [description]) VALUES
    (N'Nha khoa tổng quát', N'Khám và điều trị các bệnh lý răng miệng cơ bản'),
    (N'Chỉnh nha - Niềng răng', N'Điều chỉnh răng lệch lạc, khớp cắn'),
    (N'Phẫu thuật hàm mặt', N'Nhổ răng khôn, phẫu thuật chỉnh hình xương hàm'),
    (N'Nha khoa thẩm mỹ', N'Tẩy trắng răng, bọc răng sứ, thẩm mỹ nụ cười'),
    (N'Chuyên khoa răng miệng', N'Chẩn đoán và điều trị toàn diện');
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Doctors]') AND name = 'specialty_id')
BEGIN
    ALTER TABLE [dbo].[Doctors] ADD [specialty_id] INT NULL;
    ALTER TABLE [dbo].[Doctors] ADD CONSTRAINT [FK_Doctors_Specialties] FOREIGN KEY ([specialty_id]) REFERENCES [dbo].[Specialties] ([specialty_id]);
END
GO

UPDATE d SET d.specialty_id = s.specialty_id 
FROM [dbo].[Doctors] d 
INNER JOIN [dbo].[Specialties] s ON d.specialty LIKE '%' + s.specialty_name + '%';
GO

/* ==============================================================
   2. BẢNG APPOINTMENT
============================================================== */
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Appointment]') AND name = 'doctor_name')
BEGIN
    ALTER TABLE [dbo].[Appointment] ADD [doctor_name] NVARCHAR (50) NULL;
END
GO

ALTER TABLE [dbo].[Appointment] ALTER COLUMN [patient_id] INT NULL;
ALTER TABLE [dbo].[Appointment] ALTER COLUMN [work_date] DATE NULL;
ALTER TABLE [dbo].[Appointment] ALTER COLUMN [slot_id] INT NULL;
GO

/* ==============================================================
   3. CHUYỂN ĐỔI KIỂU TIỀN TỆ SANG MONEY
============================================================== */
DROP INDEX IF EXISTS [IX_Services_Price] ON [dbo].[Services];
DROP INDEX IF EXISTS [IX_Bills_Amount] ON [dbo].[Bills];
GO

-- Xóa tất cả CHECK Constraints
DECLARE @sql_check NVARCHAR(MAX) = N'';
SELECT @sql_check += N'ALTER TABLE [dbo].[' + OBJECT_NAME(parent_object_id) + '] DROP CONSTRAINT ' + QUOTENAME(name) + N';' + CHAR(13)
FROM sys.check_constraints 
WHERE parent_object_id IN (OBJECT_ID(N'[dbo].[Services]'), OBJECT_ID(N'[dbo].[Bills]'));
EXEC sp_executesql @sql_check;
GO

-- Xóa DEFAULT Constraints
DECLARE @sql_default NVARCHAR(MAX) = N'';
SELECT @sql_default += N'ALTER TABLE [dbo].[Bills] DROP CONSTRAINT ' + QUOTENAME(name) + N';' + CHAR(13)
FROM sys.default_constraints 
WHERE parent_object_id = OBJECT_ID(N'[dbo].[Bills]') 
AND parent_column_id IN (
    SELECT column_id FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Bills]') AND name IN ('discount_amount', 'tax_amount')
);
EXEC sp_executesql @sql_default;
GO

ALTER TABLE [dbo].[Services] ALTER COLUMN [price] MONEY NOT NULL;
ALTER TABLE [dbo].[Bills] ALTER COLUMN [amount] MONEY NOT NULL;
ALTER TABLE [dbo].[Bills] ALTER COLUMN [original_price] MONEY NOT NULL;
ALTER TABLE [dbo].[Bills] ALTER COLUMN [discount_amount] MONEY NULL;
ALTER TABLE [dbo].[Bills] ALTER COLUMN [tax_amount] MONEY NULL;
GO

ALTER TABLE [dbo].[Bills] ADD DEFAULT ((0)) FOR [discount_amount];
ALTER TABLE [dbo].[Bills] ADD DEFAULT ((0)) FOR [tax_amount];
GO

ALTER TABLE [dbo].[Services] ADD CHECK ([price] >= 0);
ALTER TABLE [dbo].[Bills] ADD CHECK ([amount] > 0);
ALTER TABLE [dbo].[Bills] ADD CHECK (ISNULL([discount_amount],0) >= 0);
ALTER TABLE [dbo].[Bills] ADD CHECK ([original_price] > 0);
ALTER TABLE [dbo].[Bills] ADD CHECK (ISNULL([tax_amount],0) >= 0);
GO

CREATE NONCLUSTERED INDEX [IX_Services_Price] ON [dbo].[Services]([price] ASC);
CREATE NONCLUSTERED INDEX [IX_Bills_Amount] ON [dbo].[Bills]([amount] ASC);
GO

/* ==============================================================
   4. TẠO BẢNG USERFACEIMAGES
============================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserFaceImages]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[UserFaceImages] (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        face_image NVARCHAR(MAX) NOT NULL,
        face_encoding NVARCHAR(MAX) NOT NULL,
        confidence_score FLOAT DEFAULT(0),
        registered_at DATETIME DEFAULT (getdate()),
        is_active BIT DEFAULT(1),
        FOREIGN KEY (user_id) REFERENCES [dbo].[users](user_id)
    );
    
    CREATE NONCLUSTERED INDEX [IX_UserFaceImages_UserId] ON [dbo].[UserFaceImages]([user_id] ASC);
    CREATE NONCLUSTERED INDEX [IX_UserFaceImages_Active] ON [dbo].[UserFaceImages]([is_active] ASC);
END
GO
