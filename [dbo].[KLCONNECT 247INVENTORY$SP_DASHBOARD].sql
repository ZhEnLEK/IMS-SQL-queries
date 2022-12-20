/****** Object:  StoredProcedure [dbo].[KLCONNECT 247INVENTORY$SP_DASHBOARD]    Script Date: 20/12/2022 4:10:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[KLCONNECT 247INVENTORY$SP_DASHBOARD]
	@Store_ID int
AS
BEGIN
	SELECT  A.Item, C.Size, D.Pattern, B.Qty
      
  FROM [dbo].[KLConnect 247INVENTORY$Item] A
  INNER JOIN
  (
   SELECT  [Item_ID],[Size_ID],[Thread_pattern_ID], COUNT (Log_ID) AS Qty
FROM [dbo].[KLConnect 247INVENTORY$Storage]
WHERE Store_ID = @Store_ID AND In_stock = 1 AND (Item_ID = 1 OR Item_ID = 2)
GROUP BY  Item_ID, Size_ID, Thread_pattern_ID

  )  B ON A.Id = B.Item_ID 
  LEFT JOIN [dbo].[KLConnect 247INVENTORY$Size] C ON B.Size_ID = C.Size_ID
  LEFT JOIN  [dbo].[KLConnect 247INVENTORY$Thread_pattern] D ON B.Thread_pattern_ID = D.Thread_id
  ORDER BY A.Id, C.Size, D.Pattern
END
GO

