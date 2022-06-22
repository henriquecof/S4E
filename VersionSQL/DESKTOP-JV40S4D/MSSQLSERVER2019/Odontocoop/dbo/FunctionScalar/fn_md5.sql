/****** Object:  Function [dbo].[fn_md5]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  FUNCTION [dbo].[fn_md5] (@data varchar(255)) 
RETURNS CHAR(32)  AS  
BEGIN
    return SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', @data)), 3, 32)
END
