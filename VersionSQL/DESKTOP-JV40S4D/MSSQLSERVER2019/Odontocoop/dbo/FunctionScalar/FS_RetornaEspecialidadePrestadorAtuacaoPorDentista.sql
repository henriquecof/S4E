/****** Object:  Function [dbo].[FS_RetornaEspecialidadePrestadorAtuacaoPorDentista]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaEspecialidadePrestadorAtuacaoPorDentista](@funcionario int, @filial int)
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
    where T2.cd_atuacao_dentista  in (SELECT cd_sequencial FROM atuacao_dentista WHERE cd_funcionario = @funcionario and cd_filial = @filial)
    and T2.dt_usuarioExclusao is null
	union
	select T1.nm_especialidade
	from especialidade T1 
	inner join funcionario_especialidade T2 on  T1.cd_especialidade = T2.cd_especialidade
	where T2.cd_funcionario = @funcionario
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
