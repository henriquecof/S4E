/****** Object:  Function [dbo].[ff_data_yyyymmdd]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[ff_data_yyyymmdd] (@dt datetime)
returns varchar(8)
begin

	return right('0000' + convert(varchar(4),year(@dt)),4) + 
		right('00' + convert(varchar(2),month(@dt)),2) + 
		right('00' + convert(varchar(2),day(@dt)),2)
	

end
