/****** Object:  Function [dbo].[FS_RetornaDepLoteCartSemTitular]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[FS_RetornaDepLoteCartSemTitular] (@Associado int, @SQ_Lote int)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	Declare @Result varchar(1000)
	Declare @NM_dep varchar(60)
	Set @Result = ''

	declare cursor_Dependentes cursor for     
	   select t1.NM_DEPENDENTE 
	   from DEPENDENTES T1, Carteiras T2
	   where T1.CD_GRAU_PARENTESCO <> 1
	   and T1.cd_sequencial = T2.cd_sequencial_dep
	   and T2.dt_exclusao is null
	   and T1.cd_associado = @Associado
	   and T2.sq_lote = @SQ_Lote
	   order by 1 
	
	open cursor_Dependentes     
	fetch next from cursor_Dependentes into @NM_dep
	while (@@fetch_status<>-1)
	begin
		Set @Result = @Result + '<br />' + @NM_dep

	fetch next from cursor_Dependentes into @NM_dep
	end
	Close cursor_Dependentes
	deallocate cursor_Dependentes


	-- Return the result of the function
	RETURN @Result

END
