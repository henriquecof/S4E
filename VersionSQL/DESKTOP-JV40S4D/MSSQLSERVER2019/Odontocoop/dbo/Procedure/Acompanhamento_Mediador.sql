/****** Object:  Procedure [dbo].[Acompanhamento_Mediador]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.Acompanhamento_Mediador (
                 @cd_funcionario INT
)
AS
  BEGIN

-- =============================================
-- Author:      henrique.almeida
-- Create date: 09/09/2021 18:00
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO NA FORMATAÇÃO E ESTILO
-- =============================================


    /*
    NO INICIIO DA PROCEDURE É PASSADO UM VALOR DE ENTRADA PADRÃO @cd_funcionario DO TIPO INT.
    ESSA PROCEDURE SAO DECLARADAS DUAS VARIAVEIS, DO TIPO VARCHAR(MAX).:
    @SQL
    @SQL1
    
    PRIMEIRO SERÁ SETADO NA VARIAVEL @SQL O RESULTADO DO SELECT USANDO COMO REFERENCIA AS TABELAS.:
    EMPRESA AS A,
    TIPO_EMPRESA AS E ,
    HISTORICO AS H,
    SITUACAO_HISTORICO AS SH 
    
    E NA CLAUSULA WHERE SÃO USADOS COMO PARAMETROS.:
    WHERE A.TP_EMPRESA =E.TP_EMPRESA 
    AND A.CD_SEQUENCIAL_HISTORICO =H.CD_SEQUENCIAL 
    AND H.CD_SITUACAO = SH.CD_SITUACAO_HISTORICO 
    AND SH.FL_INCLUIR_ANS = 1
    AND A.CD_EMPRESA IN (SELECT CD_EMPRESA FROM CM_VENDEDOR WHERE CD_TIPO_COMISSAO IN (3,13) 
    AND CD_FUNCIONARIO = '+CONVERT(VARCHAR(20),@CD_FUNCIONARIO)+')
    
    DENTRO DA VARIAVEL @SQL É SETADO O VALOR PARA @SQL1 USANDO COMO REFERENCIA AS TABELAS.:
    ASSOCIADOS AS A1 ,
    DEPENDENTES AS D1 ,
    HISTORICO AS H1,
    SITUACAO_HISTORICO AS S1,
    DEPENDENTES AS D2 ,
    HISTORICO AS H2 ,
    SITUACAO_HISTORICO AS S2
    
    
    */

    --select distinct cd_funcionario from cm_vendedor where cd_tipo_comissao in (3,13) 

    DECLARE @sql VARCHAR(MAX)
    DECLARE @sql1 VARCHAR(MAX)

    SET @sql = '
    select a.cd_empresa cd_associado , a.NM_FANTASIA  nm_responsavel, e.ds_empresa  , 
           a.mm_aaaa_1pagamento_empresa ,a.dt_vencimento, sh.NM_SITUACAO_HISTORICO  , 
            
            (select count(0) from associados as a1 , dependentes as d1, historico as h1	, situacao_historico as s1
			 where a1.cd_empresa = a.cd_empresa and 
				   a1.cd_Associado = d1.cd_Associado and d1.cd_grau_parentesco = 1 and 
				   d1.cd_sequencial_historico = h1.cd_sequencial and 
				   h1.cd_situacao = s1.cd_situacao_historico and 
				   s1.fl_incluir_ans=1 ) as qt_tit, '

    SET @SQL1 = ' 
		   (select count(0) 
			  from associados as a1 , 
				   dependentes as d1 , historico as h1, situacao_historico as s1, 
				   dependentes as d2 , historico as h2 , situacao_historico as s2
			 where a1.cd_empresa = a.cd_empresa and 
				   a1.cd_associado = d1.cd_Associado and d1.cd_grau_parentesco >= 1 and 
				   d1.cd_sequencial_historico = h1.cd_sequencial and 
				   h1.cd_situacao = s1.cd_situacao_historico and 
				   s1.fl_incluir_ans=1 and 
				   a1.cd_associado = d2.cd_Associado and d2.cd_grau_parentesco = 1 and 
				   d2.cd_sequencial_historico = h2.cd_sequencial and 
				   h2.cd_situacao = s2.cd_situacao_historico and 
				   s2.fl_incluir_ans=1 and 
				   d1.CD_SEQUENCIAL <> d2.CD_SEQUENCIAL ) as qt_dep, 
	               
		   isnull((select SUM(d1.vl_plano) 
			 from associados as a1 , dependentes as d1, historico as h1	, situacao_historico as s1
			 where a1.cd_empresa = a.cd_empresa and 
				   a1.cd_Associado = d1.cd_Associado and d1.cd_grau_parentesco = 1 and 
				   d1.cd_sequencial_historico = h1.cd_sequencial and 
				   h1.cd_situacao = s1.cd_situacao_historico and 
				   s1.fl_incluir_ans=1  ) ,0)
			+  
		   isnull((select SUM(d1.vl_plano)
			  from associados as a1 , 
				   dependentes as d1 , historico as h1, situacao_historico as s1, 
				   dependentes as d2 , historico as h2 , situacao_historico as s2
			 where a1.cd_empresa = a.cd_empresa and 
				   a1.cd_associado = d1.cd_Associado and d1.cd_grau_parentesco >= 1 and 
				   d1.cd_sequencial_historico = h1.cd_sequencial and 
				   h1.cd_situacao = s1.cd_situacao_historico and 
				   s1.fl_incluir_ans=1 and 
				   a1.cd_associado = d2.cd_Associado and d2.cd_grau_parentesco = 1 and 
				   d2.cd_sequencial_historico = h2.cd_sequencial and 
				   h2.cd_situacao = s2.cd_situacao_historico and 
				   s2.fl_incluir_ans=1 and 
				   d1.CD_SEQUENCIAL <> d2.CD_SEQUENCIAL  ),0) as vl_fatura   

			 from empresa as a, tipo_empresa as e , HISTORICO as h, SITUACAO_HISTORICO as sh
			where a.TP_EMPRESA=e.tp_empresa and 
				  a.CD_Sequencial_historico=h.cd_sequencial and 
				  h.CD_SITUACAO= sh.CD_SITUACAO_HISTORICO and 
				  sh.fl_incluir_ans = 1 and 
				  a.cd_empresa in (select cd_empresa from cm_vendedor where cd_tipo_comissao in (3,13) and cd_funcionario = ' + CONVERT(VARCHAR(20) , @cd_funcionario) + ') 
		    order by a.mm_aaaa_1pagamento_empresa, a.NM_FANTASIA '

    PRINT (@sql + @sql1)
    EXEC (@sql + @sql1)

  END
