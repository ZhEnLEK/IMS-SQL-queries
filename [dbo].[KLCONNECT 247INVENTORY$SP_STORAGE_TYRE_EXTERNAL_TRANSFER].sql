/****** Object:  StoredProcedure [dbo].[KLCONNECT 247INVENTORY$SP_STORAGE_TYRE_EXTERNAL_TRANSFER]    Script Date: 20/12/2022 4:13:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[KLCONNECT 247INVENTORY$SP_STORAGE_TYRE_EXTERNAL_TRANSFER] 
@Log_ID int,
@Document nvarchar(10),
@Client nvarchar(20),
@Vehicle nvarchar(10),
@Date_log date

AS
BEGIN

INSERT INTO [dbo].[KLConnect 247INVENTORY$Log] (Date_Created, Date_Modified, Date_log, Branding_code, Tyre_serial_number,	Transaction_type , Party,	Quantity, Document , 	Vehicle, Store_ID, Size_ID , Item_ID , Tyre_brand_ID, 	Thread_pattern_ID, Is_external)
							SELECT       GETDATE()   , GETDATE() , @Date_log  , Branding_code , Serial_number     , 'OUT'           , (SELECT Code +' '+Name FROM [dbo].[KLConnect 247INVENTORY$Store] WHERE Store_ID =  [dbo].[KLConnect 247INVENTORY$Storage].Store_ID),  1        , @Document   , NULL,   Store_ID  , Size_ID, Item_ID, Tyre_brand_ID  , Thread_pattern_ID, 1 
								 FROM [dbo].[KLConnect 247INVENTORY$Storage]
								 WHERE Log_ID = @Log_ID;
UPDATE [dbo].[KLConnect 247INVENTORY$Storage] SET Date_modified = GETDATE(), Quantity = 0, In_stock = 0, Client = @Client, Vehicle = @Vehicle, Document = @Document WHERE Log_ID = @Log_ID ;
INSERT INTO [dbo].[KLConnect 247INVENTORY$Log] (Date_Created, Date_Modified, Date_log, Branding_code, Tyre_serial_number,	Transaction_type , Party,	Quantity, Document , Vehicle  , Store_ID, Size_ID , Item_ID , Tyre_brand_ID, 	Thread_pattern_ID, Is_external)
								 SELECT      GETDATE(), GETDATE() , @Date_log  , Branding_code , Serial_number     , 'IN'           , @Client,  1       , @Document, @Vehicle , Store_ID, Size_ID, Item_ID, Tyre_brand_ID  , Thread_pattern_ID , 1
								 FROM [dbo].[KLConnect 247INVENTORY$Storage]
								 WHERE Log_ID = @Log_ID;
	


END
GO

