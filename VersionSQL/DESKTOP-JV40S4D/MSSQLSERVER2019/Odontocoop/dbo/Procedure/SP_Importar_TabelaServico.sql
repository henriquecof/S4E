/****** Object:  Procedure [dbo].[SP_Importar_TabelaServico]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Importar_TabelaServico] 
 @cd_tabelaOrigem smallint, 
 @cd_tabelaDestino smallint
As

Begin

  delete tabela_servicos where cd_tabela = @cd_tabelaDestino
              
  insert into tabela_servicos (cd_tabela, cd_servico, vl_servico, tipoMoedaCalculo)
  select @cd_tabelaDestino, cd_servico, vl_servico, tipoMoedaCalculo
    From tabela_servicos 
   where cd_tabela = @cd_tabelaOrigem

End
