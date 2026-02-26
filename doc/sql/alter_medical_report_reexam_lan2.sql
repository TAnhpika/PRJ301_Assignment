-- Bước 2 tái khám: Thêm cột is_reexam_lan_2 vào MedicalReport
-- Chạy script này trên Azure SQL / SQL Server trước khi deploy code mới

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'dbo.MedicalReport') AND name = 'is_reexam_lan_2'
)
BEGIN
    ALTER TABLE dbo.MedicalReport
    ADD is_reexam_lan_2 BIT NULL DEFAULT 0;
END
GO
