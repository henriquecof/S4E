/****** Object:  Function [dbo].[FS_RetornaCodigoEspecialidadeAtuacaoForaUF]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaCodigoEspecialidadeAtuacaoForaUF](@ufID int, @municipio int)
Returns varchar(max)
As
Begin
   Declare @retorno varchar(1000)
   Declare @nm_especialidade as varchar(50)
 
   Set @retorno = ''
  
   Declare Cursor01 CURSOR FOR
  
  select nm_especialidade from especialidade where cd_especialidade not in (
      select distinct T1.cd_especialidade
   from especialidade T1
    	inner join atuacao_dentista T2 on T2.cd_especialidade = T1.cd_especialidade
		left join funcionario t3 on t2.cd_funcionario = t3.cd_funcionario
		left join filial t4 on t2.cd_filial = t4.cd_filial
   where fl_ativo = 1
		and T2.fl_divulgar_rede_atendimento = 1
		and (t3.ufId = @ufID or t4.ufId = @ufID)
		and (t3.cidId = @municipio or t4.cidId = @municipio)
   )
   order by 1
   
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
