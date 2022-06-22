/****** Object:  Function [dbo].[ff_data_mm_dd_yyyy]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[ff_data_mm_dd_yyyy] (@dt varchar(10))
returns varchar(10)
begin
	return substring(@dt,4,3) + left(@dt,3) + substring(@dt,7,4)
end
