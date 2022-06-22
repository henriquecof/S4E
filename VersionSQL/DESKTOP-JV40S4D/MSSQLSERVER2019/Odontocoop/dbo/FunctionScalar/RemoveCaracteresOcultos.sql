/****** Object:  Function [dbo].[RemoveCaracteresOcultos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[RemoveCaracteresOcultos](
    @String VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE
        @Result VARCHAR(MAX), 
        @StartingIndex INT = 0
    WHILE (1 = 1)
    BEGIN 
        
        SET @StartingIndex = PATINDEX('%[^ !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ\^_`abcdefghijklmnopqrstuvwxyz|{}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™?š›œžŸ¡¢£¤¥¦§¨©?ª«¬­®?¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ[[]%', REPLACE(@String, ']', ''))
        
        IF (@StartingIndex <> 0)
            SET @String = REPLACE(@String,SUBSTRING(@String, @StartingIndex,1),'') 
        ELSE
            BREAK
 
    END    
    
    SET @Result = REPLACE(@String,'|','')
    
    RETURN @Result
 
END
