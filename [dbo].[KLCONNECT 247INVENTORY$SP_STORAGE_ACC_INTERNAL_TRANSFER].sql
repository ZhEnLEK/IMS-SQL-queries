/****** Object:  StoredProcedure [dbo].[KLCONNECT 247INVENTORY$SP_STORAGE_ACC_INTERNAL_TRANSFER]    Script Date: 20/12/2022 4:12:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[KLCONNECT 247INVENTORY$SP_STORAGE_ACC_INTERNAL_TRANSFER]

@Store_ID int,
@Item_ID int,
@Size_ID int,
@Document nvarchar(20),
@Quantity int,
@Log_ID int,
@Date_log date
	


AS
BEGIN

DECLARE @Party nvarchar(10) = (SELECT Name FROM [dbo].[KLConnect 247INVENTORY$Store] WHERE Store_ID = @Store_ID)

INSERT INTO [dbo].[KLConnect 247INVENTORY$Log] (Date_Created, Date_Modified, Date_log, Transaction_type , Party,	Quantity   , Document , Store_ID, Size_ID , Item_ID, Is_external )
								 SELECT      GETDATE(), GETDATE() , @Date_log  ,  'OUT'           ,(SELECT Code +' '+Name FROM [dbo].[KLConnect 247INVENTORY$Store] WHERE Store_ID = [dbo].[KLConnect 247INVENTORY$Storage].Store_ID) ,  @Quantity , @Document, Store_ID, Size_ID, Item_ID, 0 
								 FROM [dbo].[KLConnect 247INVENTORY$Storage]
								 WHERE Log_ID = @Log_ID;
INSERT INTO [dbo].[KLConnect 247INVENTORY$Log] (Date_Created, Date_Modified, Date_log, Transaction_type , Party,	Quantity   , Document , Store_ID, Size_ID , Item_ID, Is_external )
								 SELECT      GETDATE(), GETDATE() , @Date_log  ,  'IN'           ,@Party ,  @Quantity , @Document, @Store_ID, Size_ID, Item_ID, 0 
								 FROM [dbo].[KLConnect 247INVENTORY$Storage]
								 WHERE Log_ID = @Log_ID;

IF EXISTS (SELECT * FROM [dbo].[KLConnect 247INVENTORY$Storage] WHERE Store_ID =@Store_ID AND Item_ID =@Item_ID AND Size_ID = @Size_ID)  
BEGIN 
UPDATE [dbo].[KLConnect 247INVENTORY$Storage] SET Document = @Document, Quantity +=@Quantity, Date_modified = GETDATE() WHERE Store_ID =@Store_ID AND Item_ID =@Item_ID AND Size_ID = @Size_ID;
UPDATE [dbo].[KLConnect 247INVENTORY$Storage] SET Document = @Document, Quantity -=@Quantity, Date_modified = GETDATE() WHERE Log_ID = @Log_ID;  


END 

ELSE 
BEGIN 

INSERT INTO [dbo].[KLConnect 247INVENTORY$Storage]([Store_ID], [Date_in], [Quantity], [In_stock], [Date_modified], [Item_ID], [Size_ID], [Document])
SELECT @Store_ID, GETDATE(), @Quantity, [In_stock], GETDATE(), [Item_ID], [Size_ID], @Document
FROM [dbo].[KLConnect 247INVENTORY$Storage] WHERE Log_ID = @Log_ID;
UPDATE [dbo].[KLConnect 247INVENTORY$Storage] SET Document = @Document, Quantity -=@Quantity, Date_modified = GETDATE() WHERE Log_ID = @Log_ID;  


END
END
GO

