/****** Object:  Function [dbo].[FF_Split]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[FF_Split]
( @stringToSplit VARCHAR(MAX) ,
  @delimeter char = ','
)
RETURNS
 @returnList TABLE ([valor] [varchar] (max))
AS
BEGIN

    DECLARE @name VARCHAR(max)
    DECLARE @pos INT

    WHILE LEN(@stringToSplit) > 0
    BEGIN
        SELECT @pos  = CHARINDEX(@delimeter, @stringToSplit)


        if @pos = 0
        BEGIN
            SELECT @pos = LEN(@stringToSplit)
            SELECT @name = SUBSTRING(@stringToSplit, 1, @pos)  
        END
        else 
        BEGIN
            SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)
        END

        INSERT INTO @returnList 
        SELECT @name

        SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
    END

 RETURN
END
