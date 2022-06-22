/****** Object:  Procedure [dbo].[PS_SolicitacaoProduto]    Committed by VersionSQL https://www.versionsql.com ******/

Create procedure [dbo].[PS_SolicitacaoProduto] (@CD_Solicitacao int)
As
Begin

delete from ORCAMENTO_PRODUTO
where cd_solicitacao_produto in (select 
cd_solicitacao_produto from SOLICITACAO_PRODUTO
where cd_solicitacao = @CD_Solicitacao) 

delete from SOLICITACAO_PRODUTO
where cd_solicitacao = @CD_Solicitacao

delete from FASE_SOLICITACAO
where cd_solicitacao = @CD_Solicitacao

delete from ORCAMENTO
where cd_solicitacao = @CD_Solicitacao

delete from solicitacao_estoque
where cd_solicitacao = @CD_Solicitacao

End
