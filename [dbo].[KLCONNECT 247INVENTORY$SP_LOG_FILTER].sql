/****** Object:  StoredProcedure [dbo].[KLCONNECT 247INVENTORY$SP_LOG_FILTER]    Script Date: 20/12/2022 4:11:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[KLCONNECT 247INVENTORY$SP_LOG_FILTER] 
	-- Add the parameters for the stored procedure here
@start_date date,
@end_date date

AS
BEGIN
	
SELECT Date_log ,B.Item, C.Size, Branding_code, D.Brand ,E.Pattern,Tyre_serial_number, Transaction_type,Party, Quantity, Document, Vehicle 
FROM [dbo].[KLConnect 247INVENTORY$Log] A
LEFT JOIN [dbo].[KLConnect 247INVENTORY$Item] B ON A.Item_ID = B.Id
LEFT JOIN [dbo].[KLConnect 247INVENTORY$Size] C ON A.Size_ID = C.Size_ID
LEFT JOIN [dbo].[KLConnect 247INVENTORY$Tyre_brand] D ON A.Tyre_brand_ID = D.Brand_id
LEFT JOIN [dbo].[KLConnect 247INVENTORY$Thread_pattern] E ON A.Thread_pattern_ID = E.Thread_id
WHERE A.Date_log BETWEEN @start_date AND @end_date
ORDER BY Date_log DESC
END
GO

