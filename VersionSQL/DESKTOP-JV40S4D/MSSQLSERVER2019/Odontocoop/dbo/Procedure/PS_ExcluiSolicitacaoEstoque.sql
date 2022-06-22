/****** Object:  Procedure [dbo].[PS_ExcluiSolicitacaoEstoque]    Committed by VersionSQL https://www.versionsql.com ******/

Create procedure [dbo].[PS_ExcluiSolicitacaoEstoque](@solicitcao int)
as
Begin

delete from ORCAMENTO_PRODUTO
where cd_solicitacao_produto in
(select cd_solicitacao_produto from SOLICITACAO_PRODUTO
where cd_solicitacao =  @solicitcao)

delete from FASE_SOLICITACAO
where cd_solicitacao =  @solicitcao

delete from SOLICITACAO_PRODUTO
where cd_solicitacao =  @solicitcao

delete from ORCAMENTO
where cd_solicitacao =  @solicitcao

delete from solicitacao_estoque
where cd_solicitacao =  @solicitcao

End
