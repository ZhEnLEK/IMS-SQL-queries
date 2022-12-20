/****** Object:  StoredProcedure [dbo].[KLCONNECT 247INVENTORY$SP_STORAGE_INSERT_FROM_RECEIVING_MODULE]    Script Date: 20/12/2022 4:12:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
CREATE PROCEDURE [dbo].[KLCONNECT 247INVENTORY$SP_STORAGE_INSERT_FROM_RECEIVING_MODULE] 
  @Date_in date,
  @Branding_code NVARCHAR(50) ,
  @Item  NVARCHAR(50),
  @Size  NVARCHAR(50) ,
  @Brand NVARCHAR(50) ,
  @Pattern NVARCHAR(50),
  @Serial_number NVARCHAR(50) ,
  @Document NVARCHAR(50) ,
  @Store_ID  int,
  @Quantity  smallint,
  @In_stock bit 


AS
BEGIN

 DECLARE @Item_ID int = (SELECT Id FROM [dbo].[KLConnect 247INVENTORY$Item] WHERE Item = @Item)
 DECLARE @Size_ID  int = (SELECT Size_ID FROM [dbo].[KLConnect 247INVENTORY$Size] where Item_ID = @Item_ID  AND (Size = @Size or Size is null))
 DECLARE @Tyre_brand_ID  int = (SELECT Brand_id FROM [dbo].[KLConnect 247INVENTORY$Tyre_brand] WHERE Brand = @Brand)
 DECLARE @Thread_pattern_ID  int = (SELECT Thread_id FROM [dbo].[KLConnect 247INVENTORY$Thread_pattern] WHERE Brand_id = @Tyre_brand_ID AND Pattern = @Pattern)
 DECLARE @Party nvarchar(20) = (SELECT Code +' '+ Name FROM [dbo].[KLConnect 247INVENTORY$Store] WHERE Store_ID = @Store_ID)


 IF (@Item_ID = 1 OR @Item_ID = 2)
 BEGIN
  IF EXISTS (SELECT * FROM [dbo].[KLConnect 247INVENTORY$Storage] WHERE (Branding_code = @Branding_code AND Serial_number = @Serial_number)  AND In_stock = 1  AND (Item_ID = 1 or Item_ID = 2)) return;
    --> Prevent duplicate entry for tyres 17/11/2022 
 
  INSERT INTO [dbo].[KLConnect 247INVENTORY$Storage](Date_in,   Date_modified,  Branding_code,  Item_ID,  Size_ID,   Tyre_brand_ID, Thread_pattern_ID,   Serial_number,  Document,  Store_ID,  Quantity, In_stock) 
                               VALUES (@Date_in,  GETDATE()    , @Branding_code, @Item_ID, @Size_ID,  @Tyre_brand_ID, @Thread_pattern_ID, @Serial_number, @Document, @Store_ID, @Quantity, @In_stock);
INSERT INTO [dbo].[KLConnect 247INVENTORY$Log] (Date_Created, Date_Modified, Date_log, Branding_code  , Tyre_serial_number,	Transaction_type , Party,	Quantity, Document , Vehicle, Store_ID, Size_ID , Item_ID , Tyre_brand_ID, 	Thread_pattern_ID, Is_external)
							   VALUES    (GETDATE(), GETDATE()       , @Date_in, @Branding_code , @Serial_number    , 'IN'               ,@Party,  1        , @Document, NULL   , @Store_ID, @Size_ID, @Item_ID, @Tyre_brand_ID  , @Thread_pattern_ID, 0 )

END

ELSE
BEGIN

IF EXISTS (SELECT * FROM [dbo].[KLConnect 247INVENTORY$Storage] WHERE Store_ID =@Store_ID AND Item_ID =@Item_ID AND Size_ID = @Size_ID)  
BEGIN
UPDATE [dbo].[KLConnect 247INVENTORY$Storage] SET Document = @Document, Quantity +=@Quantity, Date_modified = GETDATE() WHERE Store_ID =@Store_ID AND Item_ID =@Item_ID AND Size_ID = @Size_ID;

END

ELSE
BEGIN
INSERT INTO [dbo].[KLConnect 247INVENTORY$Storage]([Store_ID], [Date_in], [Quantity], [In_stock], [Date_modified], [Item_ID], [Size_ID], [Document])
                             VALUES ( @Store_ID, @Date_in , @Quantity , @In_stock , GETDATE()      , @Item_ID, @Size_ID  , @Document);
END

INSERT INTO [dbo].[KLConnect 247INVENTORY$Log] (Date_Created, Date_Modified, Date_log, Transaction_type , Party,	Quantity   , Document , Store_ID, Size_ID , Item_ID, Is_external )
							   VALUES    (GETDATE()   , GETDATE()    , @Date_in,  'IN'           ,@Party ,  @Quantity , @Document, @Store_ID, @Size_ID, @Item_ID , 0);

END
	
END
GO

