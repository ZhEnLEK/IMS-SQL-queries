/****** Object:  StoredProcedure [dbo].[KLCONNECT 247INVENTORY$SP_DASHBOARD_ACC]    Script Date: 20/12/2022 4:11:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[KLCONNECT 247INVENTORY$SP_DASHBOARD_ACC]
	@Store_ID int
AS
BEGIN
	SELECT  B.Item, C.Size, A.Quantity AS Qty
      
  FROM [dbo].[KLConnect 247INVENTORY$Storage] A
  LEFT JOIN [dbo].[KLConnect 247INVENTORY$Item] B ON A.Item_ID = B.Id
  LEFT JOIN [dbo].[KLConnect 247INVENTORY$Size] C ON A.Size_ID = C.Size_ID
  WHERE A.Store_ID = @Store_ID AND In_stock = 1 AND (A.Item_ID <> 1 AND A.Item_ID <> 2)

END
GO

