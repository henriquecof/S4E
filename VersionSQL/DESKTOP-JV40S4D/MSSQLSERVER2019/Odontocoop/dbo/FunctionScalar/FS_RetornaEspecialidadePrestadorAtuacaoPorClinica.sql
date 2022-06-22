/****** Object:  Function [dbo].[FS_RetornaEspecialidadePrestadorAtuacaoPorClinica]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaEspecialidadePrestadorAtuacaoPorClinica](@filial int)
Returns varchar(1000)
As
Begin
   Declare @retorno varchar(1000)
   Declare @nm_especialidade as varchar(50)

   Set @retorno = ''
   
   Declare Cursor01 CURSOR FOR
   
  select distinct T1.nm_especialidade
    from especialidade T1
    inner join Especialidade_Prestador T2 on T2.cd_especialidade = T1.cd_especialidade
    where T2.cd_filial = @filial
    and T2.dt_usuarioExclusao is null
    and t2.cd_funcionario in (select cd_funcionario from funcionario_especialidade)
	union
	select T1.nm_especialidade
	from especialidade T1 
	inner join funcionario_especialidade T2 on  T1.cd_especialidade = T2.cd_especialidade
	where T2.cd_funcionario in (SELECT cd_funcionario FROM atuacao_dentista WHERE cd_filial = @filial)
	order by T1.nm_especialidade
   
   open Cursor01
   fetch next from Cursor01 into @nm_especialidade
   while (@@fetch_status<>-1)
   begin
     if (@retorno <> '')
        set @retorno = @retorno + ', '
     Set @retorno = @retorno + @nm_especialidade
     fetch next from Cursor01 into @nm_especialidade
   End 
   Close Cursor01
   Deallocate Cursor01
   
   Return @retorno  
End
