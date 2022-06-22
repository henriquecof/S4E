/****** Object:  Procedure [dbo].[gera_tabela_aux_VISA]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.gera_tabela_aux_VISA
                 @seq INTEGER
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 10:40
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  BEGIN

    DECLARE @nm_arquivo VARCHAR(7)
    DECLARE @qtt INT

    SET @nm_arquivo = 'VI' + RIGHT('00000' + CONVERT(VARCHAR(5) , @seq) , 5)
    PRINT @nm_arquivo
    SET @qtt = (SELECT COUNT(0)
        FROM sysobjects
        WHERE name = ' + @nm_arquivo + '
    )

    IF @qtt = 1
      PRINT @qtt

    BEGIN
        PRINT 'drop'
        EXECUTE ('drop table dbo.' + @nm_arquivo)
    END

    PRINT 'inicio'

    BEGIN TRANSACTION
    EXECUTE ('create TABLE [' + @nm_arquivo + '] (
                [cd_associado] [int] NULL ,
                [vl_parcela] [varchar] (15)  NULL ,
                [cd_parcela] [int] NULL ,
                [dt_vencimento] [varchar] (8)  NULL ,
                [venc_cartao] [int] NULL ,
                [nr_autorizacao] [varchar] (19)  NULL ,
                [val_cartao] [varchar] (4)  NULL,
		[nr_autorizacao_cartao] [varchar] (6)  NULL,		
		[cd_rejeicao] [int] NULL
            ) ON [PRIMARY]')

    EXECUTE ('insert into [' + @nm_arquivo + ']
            SELECT CD_ASSOCIADO, right(''000000000000000'' + convert(varchar(6),convert(int,VL_PARCELA*100)),15),
            CD_PARCELA, right(''00'' + CONVERT(VARCHAR(2),day(M.DT_VENCIMENTO)),2) + right(''00'' + CONVERT(VARCHAR(2),month(M.DT_VENCIMENTO)),2) + CONVERT(VARCHAR(4),year(M.DT_VENCIMENTO)),
            A.dt_Vencimento VENC_CARTAO
            ,right(''0000000000000000000'' + A.nr_autorizacao,19),
            right(a.val_cartao,4),null,null
            FROM ASSOCIADOS A, MENSALIDADES M, situacao_historico S
            where cd_associado = CD_ASSOCIADO_EMPRESA And TP_ASSOCIADO_EMPRESA = 1
	    and a.cd_situacao = s.cd_situacao_historico
            AND M.CD_TIPO_PAGAMENTO = 21 and M.cd_tipo_recebimento = 0 and m.dt_vencimento <= getdate()
            and nosso_numero is null and fl_envia_cobranca=1
            order by CD_ASSOCIADO, cd_parcela desc')

    /*execute('insert into gerado_arquivo(dt_vencimento,dt_gerado,cd_tipo_pagamento,dt_envio,dt_gerado_arquivo) values (getdate(),getdate(),21,null,null)')*/

    EXECUTE ('
declare @valor int
declare @cdass int
declare @cdparcela int

declare cursor_ss cursor for
	select cd_associado, sum(convert(int,vl_parcela)) from [' + @nm_arquivo + '] group by cd_associado
open cursor_ss
fetch next from cursor_ss into @cdass, @valor
while (@@fetch_status<>-1)
begin
	set @cdparcela = (select min(cd_parcela) from [' + @nm_arquivo + '] where cd_associado = @cdass)

	delete from [' + @nm_arquivo + '] where cd_associado=@cdass and cd_parcela!=@cdparcela
	
	update [' + @nm_arquivo + '] set vl_parcela = right(''000000000000000''+convert(varchar(8),@valor),15) where cd_associado=@cdass and cd_parcela=@cdparcela
	fetch next from cursor_ss into @cdass, @valor
end
deallocate cursor_ss')


    INSERT INTO gerado_arquivo (DT_GERADO , CD_TIPO_PAGAMENTO , nm_ref)
    VALUES (GETDATE() , 21 , @nm_arquivo)

    COMMIT TRANSACTION

  END
