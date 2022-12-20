/****** Object:  StoredProcedure [dbo].[KLCONNECT 247INVENTORY$SP_STORAGE_ACC_EXTERNAL_TRANSFER]    Script Date: 20/12/2022 4:12:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[KLCONNECT 247INVENTORY$SP_STORAGE_ACC_EXTERNAL_TRANSFER]

@Quantity int,
@Client nvarchar(20),
@Vehicle nvarchar(10),
@Document nvarchar(10),
@Log_ID int,
@Date_log date
	

AS
BEGIN

UPDATE [dbo].[KLConnect 247INVENTORY$Storage] SET Date_modified = GETDATE(), Quantity -= @Quantity, Client = @Client, Vehicle = @Vehicle, Document = @Document WHERE Log_ID = @Log_ID;

INSERT INTO [dbo].[KLConnect 247INVENTORY$Log] (Date_Created, Date_Modified, Date_log, Transaction_type , Party,	Quantity   , Document , Store_ID, Size_ID , Item_ID , Is_external)
								 SELECT      GETDATE(), GETDATE() , @Date_log  ,  'OUT'           ,(SELECT Code +' '+ Name FROM [dbo].[KLConnect 247INVENTORY$Store] WHERE Store_ID = [dbo].[KLConnect 247INVENTORY$Storage].Store_ID) ,  @Quantity , @Document, Store_ID, Size_ID, Item_ID , 1
								 FROM [dbo].[KLConnect 247INVENTORY$Storage]
								 WHERE Log_ID = @Log_ID;
INSERT INTO [dbo].[KLConnect 247INVENTORY$Log] (Date_Created, Date_Modified, Date_log, Transaction_type , Party,	Quantity   , Document , Store_ID, Size_ID , Item_ID, Is_external , Vehicle)
								 SELECT      GETDATE(), GETDATE() , @Date_log  ,  'IN'           ,@Client ,  @Quantity , @Document, Store_ID, Size_ID, Item_ID , 1 , @Vehicle
								 FROM [dbo].[KLConnect 247INVENTORY$Storage]
								 WHERE Log_ID = @Log_ID	


END
GO

