/****** Object:  Function [dbo].[FS_DataCarenciaCarteira_ddMMyy]    Committed by VersionSQL https://www.versionsql.com ******/

Create Function [dbo].[FS_DataCarenciaCarteira_ddMMyy](@cd_sequencial_dep int, @cd_servico int, @ADD_dias int)
RETURNS varchar(10)
AS
Begin	
	Declare @Data varchar(10)
	Declare @DataRetorno varchar(10)

	Select @Data = dbo.FS_DataCarenciaCarteira(@cd_sequencial_dep, @cd_servico, @ADD_dias)		
	Set @DataRetorno = substring(@data, 1, 6) + right(@data, 2) 

	return @DataRetorno
End
