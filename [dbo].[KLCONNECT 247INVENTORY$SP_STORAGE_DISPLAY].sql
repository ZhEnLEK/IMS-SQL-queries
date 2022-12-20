/****** Object:  StoredProcedure [dbo].[KLCONNECT 247INVENTORY$SP_STORAGE_DISPLAY]    Script Date: 20/12/2022 4:12:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[KLCONNECT 247INVENTORY$SP_STORAGE_DISPLAY] 
	@Store_ID int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from

	SELECT A.Store_ID, Item, Size, Pattern,  Branding_code, Serial_number, Quantity, In_stock, Log_ID, A.Item_ID, A.Size_ID  FROM [dbo].[KLConnect 247INVENTORY$Storage] A  
                    LEFT JOIN [dbo].[KLConnect 247INVENTORY$Item] B  ON A.Item_ID = B.Id  
                    LEFT JOIN [dbo].[KLConnect 247INVENTORY$Size] C  ON A.Size_ID = C.Size_ID  
                    LEFT JOIN [dbo].[KLConnect 247INVENTORY$Thread_pattern] D  ON A.Thread_pattern_ID = D.Thread_id  
                    LEFT JOIN [dbo].[KLConnect 247INVENTORY$Tyre_brand] E  ON A.Tyre_brand_ID = E.Brand_id WHERE In_stock = 1 AND Store_ID = @Store_ID
	
END
GO

