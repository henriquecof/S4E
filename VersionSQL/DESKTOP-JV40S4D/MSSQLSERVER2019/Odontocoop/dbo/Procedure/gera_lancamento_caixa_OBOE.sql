/****** Object:  Procedure [dbo].[gera_lancamento_caixa_OBOE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROC dbo.gera_lancamento_caixa_OBOE
                 @seq INT
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 09:40
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================


AS
  BEGIN
    DECLARE @seqcaixa INT , @dtrepasse DATETIME , @vlrec MONEY , @vltaxa MONEY , @aux NVARCHAR(10)

    SELECT @seqcaixa = ISNULL(Sequencial_Historico , 0)
    FROM ABS_Financeiro..TB_HistoricoMovimentacao
    WHERE Sequencial_Movimentacao = 40
          AND
          Data_Fechamento IS NULL

    SELECT @aux = CONVERT(NVARCHAR(10) , @seq)

    IF (@seqcaixa != 0)
      BEGIN

        BEGIN TRANSACTION


        DECLARE cursor_oboe CURSOR
        FOR SELECT dt_repasse , SUM(vl_cobranca) , SUM(vl_tarifa)
          FROM oboe_registro
          WHERE dt_repasse IS NOT NULL
                AND
                cd_sequencial = @seq
          GROUP BY dt_repasse
        OPEN cursor_oboe
        FETCH NEXT FROM cursor_oboe INTO @dtrepasse , @vlrec , @vltaxa
        WHILE (@@fetch_status <> -1)
          BEGIN

            /* recebimento OBOÉ */

            INSERT INTO ABS_Financeiro..TB_Lancamento (Tipo_Lancamento , Historico , Sequencial_Conta , cd_associado , cd_sequencial , cd_fornecedor , cd_funcionario , cd_dentista , cd_associadoempresa , nome_outros)
            VALUES (1 , 'Recebimento CARTÃO OBOÉ - leitura do arquivo sequencial ' + @aux , 1781 , NULL , NULL , NULL , NULL , NULL , NULL , NULL)

            INSERT INTO ABS_Financeiro..TB_FormaLancamento (Tipo_ContaLancamento , Forma_Lancamento , Data_Lancamento , Data_Documento , Valor_Lancamento , Valor_Previsto , Data_HoraLancamento , Sequencial_Historico , Sequencial_Historico_Consulta , SequencialCartao_Car , nome_usuario , Sequencial_Lancamento , Sequencial_FormaLancamento_Vale , Sequencial_HistoricoVale)
                   SELECT 2 , 1 , NULL , @dtrepasse , NULL , @vlrec , GETDATE() , @seqcaixa , NULL , NULL , 'SYS' , MAX(Sequencial_Lancamento) , NULL , NULL
                   FROM ABS_Financeiro..TB_Lancamento

            /* taxa OBOÉ 
        	
        	        Insert Into ABS_Financeiro..TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta,
        				CD_Associado, CD_Sequencial, CD_Fornecedor,
        				CD_Funcionario, CD_Dentista,CD_AssociadoEmpresa,
        				Nome_Outros)
        				Values (2, 'Taxa de serviço CARTÃO OBOÉ - leitura do arquivo sequencial ' + @aux, 1634,Null,Null,Null,null,null,null,null)
        		
        		Insert Into ABS_Financeiro..TB_FormaLancamento (Tipo_ContaLancamento, Forma_Lancamento,
        			Data_Lancamento, Data_Documento, Valor_Lancamento, Valor_Previsto,
        	                Data_HoraLancamento, Sequencial_Historico, Sequencial_Historico_Consulta,
        	                SequencialCartao_Car, nome_usuario, Sequencial_Lancamento, Sequencial_FormaLancamento_Vale, Sequencial_HistoricoVale)
        	                Select 2,1,Null, @dtrepasse, Null, @vltaxa,
        	                getdate(), @seqcaixa, null, Null,'SYS' ,Max(Sequencial_Lancamento), Null, null
        	                From ABS_Financeiro..TB_Lancamento
                        */

            FETCH NEXT FROM cursor_oboe INTO @dtrepasse , @vlrec , @vltaxa
          END
        DEALLOCATE cursor_oboe

        COMMIT
      END
    ELSE
      BEGIN
        RAISERROR ('Nenhum caixa aberto' , 16 , 1)
        ROLLBACK
        RETURN
      END



  END
