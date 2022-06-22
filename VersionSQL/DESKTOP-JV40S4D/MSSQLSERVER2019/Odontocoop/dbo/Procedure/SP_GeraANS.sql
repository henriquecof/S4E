/****** Object:  Procedure [dbo].[SP_GeraANS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_GeraANS]
    @competencia VARCHAR(6), --YYYYMM
    @inclusao BIT,
    @exclusao BIT,
    @retificacao BIT,
    @mContratual BIT,
    @filtroCamposDivergentes VARCHAR(300) = ''
AS
BEGIN

    /*
	ticket #8870 - Corrigir Mudança Contratual com alteração de Titular
	ticket #8896 - Corrigir Retificação - codigoBeneficiarioTitular
*/
    DECLARE @cd_sequencial INT = NULL;
    DECLARE @dt_preparacao DATETIME;
    DECLARE @dt_envio DATETIME;
    DECLARE @dt_limite DATE;
    DECLARE @utilizaDatacompetenciaSIB TINYINT;

    SELECT @utilizaDatacompetenciaSIB = ISNULL(utilizaDatacompetenciaSIB, 0)
    FROM Configuracao;

    /********* Checar Filtros Retificação *********/
    IF @retificacao = 1
       AND @filtroCamposDivergentes = ''
    BEGIN
        RAISERROR('Nenhum filtro utilizado para o Sib de retificação.', 16, 1);
        RETURN;
    END;
    /**********************************************/

    /*** REMOVED ON UC_426 

 Declare @ind smallint = 0 

 if DAY(getdate())<15
    -- Set @ind=-1

  -- ** REMOVED ON UC_426
  -- Set @competencia = CONVERT(varchar(6),dateadd(month,@ind,getdate()),112)
  -- Set @competencia = CONVERT(varchar(6),dateadd(month,-1,getdate()),112)
  */

    UPDATE Ans_Beneficiarios
    SET mensagemErro = NULL
    WHERE mensagemErro IS NOT NULL;

    SET @dt_limite = DATEADD(MONTH, 1, RIGHT(@competencia, 2) + '/01/' + LEFT(@competencia, 4));

    SELECT TOP 1
           @cd_sequencial = cd_sequencial,
           @dt_preparacao = dt_preparacao,
           @dt_envio = dt_envio,
           @competencia = competencia
    FROM ANS
    WHERE dt_fechado IS NULL
    ORDER BY cd_sequencial DESC; -- Verificar se tem algum arquivo de envio da ANS aberto

    /** REMOVED ON UC_426 
  if @cd_sequencial is null -- Esse if esta repetido apenas p definir a data limite
    Set @competencia = CONVERT(varchar(6),dateadd(month,@ind,getdate()),112)
  */
    SET @dt_limite = DATEADD(MONTH, 1, RIGHT(@competencia, 2) + '/01/' + LEFT(@competencia, 4));

    IF @cd_sequencial IS NULL
    BEGIN -- 1 

        INSERT INTO ANS
        (
            cd_sequencial,
            dt_preparacao,
            competencia
        )
        SELECT MAX(cd_sequencial) + 1,
               @dt_limite,
               @competencia
        FROM ANS;

        IF @@ROWCOUNT = 0
        BEGIN -- 1.1
            RAISERROR('Erro na criação do arquivo da ANS.', 16, 1);
            RETURN;
        END; -- 1.1

        SELECT TOP 1
               @cd_sequencial = cd_sequencial
        FROM ANS
        WHERE dt_fechado IS NULL
        ORDER BY cd_sequencial DESC;

    END; -- 1 

    UPDATE ANS
    SET nm_arquivo_envio = NULL
    WHERE cd_sequencial = @cd_sequencial;

    --else
    --if DATEDIFF(day,@dt_preparacao, getdate())>10 and @dt_envio is not null 
    -- begin
    --   Raiserror('Arquivo aberto superior a 10 dias. Verifique se o arquivo enviado foi fechado',16,1)
    --RETURN
    --End 

    ----------------------------------------------------------------------------------
    -- estes dois comandos sempre tem  q rodar na procedure e ao clicar no botao "excluir erros" dentro da modal, add o "and" comentando
    UPDATE ANS
    SET erro = NULL
    WHERE cd_sequencial = @cd_sequencial;

    DELETE Ans_Beneficiarios
    WHERE cd_arquivo_envio_inc = @cd_sequencial; -- Exluir os incluido

    UPDATE Ans_Beneficiarios
    SET cd_arquivo_envio_exc = NULL,
        dt_exclusao = NULL,
        cd_motivo_exclusao_Ans = NULL,
        oculto = NULL,
        dataRetifMudanca = NULL,
        retificacao = NULL,
        mudanca_contratual = NULL
    WHERE cd_arquivo_envio_exc = @cd_sequencial --Atualizar as exclusoes
          AND Ans_Beneficiarios.cco IS NOT NULL;
    --and Ans_Beneficiarios.mensagemErro is not null    
    ----------------------------------------------------------------------------------

    IF @exclusao = 1
    BEGIN
        --------------------------------------------------------------------------------------------
        --os updates abaixo entram ao escolher a opção "exclusao" no comando de "novo lote"
        PRINT 'Cancelar os usuarios';
        UPDATE Ans_Beneficiarios
        SET -- Ans_Beneficiarios.dt_exclusao = right(@competencia,2) + '/01/' + LEFT(@competencia,4),
            --Ans_Beneficiarios.dt_exclusao = dateadd(day,1,Ans_Beneficiarios.dt_inclusao) ,
            Ans_Beneficiarios.dt_exclusao = CASE
                                                WHEN @utilizaDatacompetenciaSIB = 1 THEN
                                                    RIGHT(@competencia, 2) + '/01/' + LEFT(@competencia, 4)
                                                ELSE
                                                    DATEADD(DAY, 1, Ans_Beneficiarios.dt_inclusao)
                                            END,
            Ans_Beneficiarios.cd_motivo_exclusao_Ans =
            (
                SELECT cd_motivo_exclusao_ans
                FROM SITUACAO_HISTORICO
                WHERE CD_SITUACAO_HISTORICO = 2
            ),
            cd_arquivo_envio_exc = @cd_sequencial
        WHERE cd_sequencial_dep IS NULL
              AND cd_arquivo_envio_exc IS NULL
              AND Ans_Beneficiarios.cco IS NOT NULL;

        UPDATE Ans_Beneficiarios
        SET --Ans_Beneficiarios.dt_exclusao = right(@competencia,2) + '/' + CONVERT(varchar(2),case when DAY(historico.dt_situacao)>28 and right(@competencia,2)='02' then 28 when DAY(historico.dt_situacao) > 30 then 30  else DAY(historico.dt_situacao) end ) + '/' + LEFT(@competencia,4),
            --Ans_Beneficiarios.dt_exclusao = case when historico.dt_situacao>Ans_Beneficiarios.dt_inclusao then historico.dt_situacao else DATEADD(day,1,ans_beneficiarios.dt_inclusao) end ,
            Ans_Beneficiarios.dt_exclusao = CASE
                                                WHEN @utilizaDatacompetenciaSIB = 1 THEN
                                                    RIGHT(@competencia, 2) + '/'
                                                    + CONVERT(
                                                                 VARCHAR(2),
                                                                 CASE
                                                                     WHEN DAY(HISTORICO.DT_SITUACAO) > 28
                                                                          AND RIGHT(@competencia, 2) = '02' THEN
                                                                         28
                                                                     WHEN DAY(HISTORICO.DT_SITUACAO) > 30 THEN
                                                                         30
                                                                     ELSE
                                                                         DAY(HISTORICO.DT_SITUACAO)
                                                                 END
                                                             ) + '/' + LEFT(@competencia, 4)
                                                ELSE
                                                    CASE
                                                        WHEN HISTORICO.DT_SITUACAO > Ans_Beneficiarios.dt_inclusao THEN
                                                            HISTORICO.DT_SITUACAO
                                                        ELSE
                                                            DATEADD(DAY, 1, Ans_Beneficiarios.dt_inclusao)
                                                    END
                                            END,
            Ans_Beneficiarios.cd_motivo_exclusao_Ans = (CASE
                                                            WHEN MOTIVO_CANCELAMENTO.cd_motivo_exclusao_ans IS NOT NULL THEN
                                                                MOTIVO_CANCELAMENTO.cd_motivo_exclusao_ans
                                                            ELSE
                                                                SITUACAO_HISTORICO.cd_motivo_exclusao_ans
                                                        END
                                                       ),
            cd_arquivo_envio_exc = @cd_sequencial
        FROM --dependentes , HISTORICO , SITUACAO_HISTORICO , MOTIVO_CANCELAMENTO 
            dbo.DEPENDENTES
            INNER JOIN dbo.HISTORICO
                ON HISTORICO.CD_SEQUENCIAL_dep = DEPENDENTES.CD_SEQUENCIAL
            INNER JOIN dbo.SITUACAO_HISTORICO
                ON dbo.HISTORICO.CD_SITUACAO = dbo.SITUACAO_HISTORICO.CD_SITUACAO_HISTORICO
                   AND dbo.SITUACAO_HISTORICO.fl_incluir_ans = 0
            LEFT JOIN dbo.MOTIVO_CANCELAMENTO
                ON HISTORICO.cd_MOTIVO_CANCELAMENTO = MOTIVO_CANCELAMENTO.cd_motivo_cancelamento
        WHERE Ans_Beneficiarios.cd_sequencial_dep = DEPENDENTES.CD_SEQUENCIAL
              AND Ans_Beneficiarios.dt_exclusao IS NULL
              AND Ans_Beneficiarios.cd_arquivo_envio_exc IS NULL
              AND
            -- dependentes.CD_Sequencial_historico= HISTORICO.cd_Sequencial and 
            -- HISTORICO.CD_SITUACAO=SITUACAO_HISTORICO.CD_SITUACAO_HISTORICO and SITUACAO_HISTORICO.fl_incluir_ans=0 and 
            -- historico.cd_MOTIVO_CANCELAMENTO *= MOTIVO_CANCELAMENTO.cd_motivo_cancelamento  and 
            HISTORICO.DT_SITUACAO < @dt_limite
              AND HISTORICO.DT_SITUACAO >= '02/01/2016'
              AND Ans_Beneficiarios.cco IS NOT NULL;

        PRINT 'Cancelar os usuarios onde titular esteja cancelado';
        UPDATE Ans_Beneficiarios
        SET --Ans_Beneficiarios.dt_exclusao = right(@competencia,2) + '/' + CONVERT(varchar(2),case when DAY(historico.dt_situacao)>28 and right(@competencia,2)='02' then 28 when DAY(historico.dt_situacao) > 30 then 30  else DAY(historico.dt_situacao) end ) + '/' + LEFT(@competencia,4),
            --Ans_Beneficiarios.dt_exclusao = case when historico.dt_situacao>Ans_Beneficiarios.dt_inclusao then historico.dt_situacao else DATEADD(day,1,ans_beneficiarios.dt_inclusao) end ,
            Ans_Beneficiarios.dt_exclusao = CASE
                                                WHEN @utilizaDatacompetenciaSIB = 1 THEN
                                                    RIGHT(@competencia, 2) + '/'
                                                    + CONVERT(
                                                                 VARCHAR(2),
                                                                 CASE
                                                                     WHEN DAY(HISTORICO.DT_SITUACAO) > 28
                                                                          AND RIGHT(@competencia, 2) = '02' THEN
                                                                         28
                                                                     WHEN DAY(HISTORICO.DT_SITUACAO) > 30 THEN
                                                                         30
                                                                     ELSE
                                                                         DAY(HISTORICO.DT_SITUACAO)
                                                                 END
                                                             ) + '/' + LEFT(@competencia, 4)
                                                ELSE
                                                    CASE
                                                        WHEN HISTORICO.DT_SITUACAO > Ans_Beneficiarios.dt_inclusao THEN
                                                            HISTORICO.DT_SITUACAO
                                                        ELSE
                                                            DATEADD(DAY, 1, Ans_Beneficiarios.dt_inclusao)
                                                    END
                                            END,
            Ans_Beneficiarios.cd_motivo_exclusao_Ans = (CASE
                                                            WHEN MOTIVO_CANCELAMENTO.cd_motivo_exclusao_ans IS NOT NULL THEN
                                                                MOTIVO_CANCELAMENTO.cd_motivo_exclusao_ans
                                                            ELSE
                                                                SITUACAO_HISTORICO.cd_motivo_exclusao_ans
                                                        END
                                                       ),
            cd_arquivo_envio_exc = @cd_sequencial
        FROM -- dependentes, DEPENDENTES as d_tit , HISTORICO , SITUACAO_HISTORICO , MOTIVO_CANCELAMENTO 
            dbo.DEPENDENTES
            INNER JOIN dbo.DEPENDENTES D_TIT
                ON dbo.DEPENDENTES.CD_ASSOCIADO = D_TIT.CD_ASSOCIADO
                   AND D_TIT.CD_GRAU_PARENTESCO = 1
            INNER JOIN dbo.HISTORICO
                ON D_TIT.CD_Sequencial_historico = dbo.HISTORICO.cd_sequencial
            INNER JOIN dbo.SITUACAO_HISTORICO
                ON HISTORICO.CD_SITUACAO = SITUACAO_HISTORICO.CD_SITUACAO_HISTORICO
                   AND dbo.SITUACAO_HISTORICO.fl_incluir_ans = 0
            LEFT JOIN dbo.MOTIVO_CANCELAMENTO
                ON MOTIVO_CANCELAMENTO.cd_motivo_cancelamento = HISTORICO.cd_MOTIVO_CANCELAMENTO
        WHERE Ans_Beneficiarios.cd_sequencial_dep = DEPENDENTES.CD_SEQUENCIAL
              AND Ans_Beneficiarios.dt_exclusao IS NULL
              AND Ans_Beneficiarios.cd_arquivo_envio_exc IS NULL
              AND
            -- DEPENDENTES.CD_ASSOCIADO = d_tit.CD_ASSOCIADO and d_tit.CD_GRAU_PARENTESCO=1 and 
            -- d_tit.CD_Sequencial_historico= HISTORICO.cd_Sequencial and 
            -- HISTORICO.CD_SITUACAO=SITUACAO_HISTORICO.CD_SITUACAO_HISTORICO and SITUACAO_HISTORICO.fl_incluir_ans=0 and 
            -- historico.cd_MOTIVO_CANCELAMENTO *= MOTIVO_CANCELAMENTO.cd_motivo_cancelamento  and 
            HISTORICO.DT_SITUACAO < @dt_limite
              AND HISTORICO.DT_SITUACAO >= '02/01/2016'
              AND Ans_Beneficiarios.cco IS NOT NULL;

        PRINT 'Cancelar os usuarios onde empresa esteja cancelado';
        UPDATE Ans_Beneficiarios
        SET --Ans_Beneficiarios.dt_exclusao = right(@competencia,2) + '/' + CONVERT(varchar(2),case when DAY(historico.dt_situacao)>28 and right(@competencia,2)='02' then 28 when DAY(historico.dt_situacao) > 30 then 30  else DAY(historico.dt_situacao) end ) + '/' + LEFT(@competencia,4),
            --Ans_Beneficiarios.dt_exclusao = case when historico.dt_situacao>Ans_Beneficiarios.dt_inclusao then historico.dt_situacao else DATEADD(day,1,ans_beneficiarios.dt_inclusao) end ,
            Ans_Beneficiarios.dt_exclusao = CASE
                                                WHEN @utilizaDatacompetenciaSIB = 1 THEN
                                                    RIGHT(@competencia, 2) + '/'
                                                    + CONVERT(
                                                                 VARCHAR(2),
                                                                 CASE
                                                                     WHEN DAY(HISTORICO.DT_SITUACAO) > 28
                                                                          AND RIGHT(@competencia, 2) = '02' THEN
                                                                         28
                                                                     WHEN DAY(HISTORICO.DT_SITUACAO) > 30 THEN
                                                                         30
                                                                     ELSE
                                                                         DAY(HISTORICO.DT_SITUACAO)
                                                                 END
                                                             ) + '/' + LEFT(@competencia, 4)
                                                ELSE
                                                    CASE
                                                        WHEN HISTORICO.DT_SITUACAO > Ans_Beneficiarios.dt_inclusao THEN
                                                            HISTORICO.DT_SITUACAO
                                                        ELSE
                                                            DATEADD(DAY, 1, Ans_Beneficiarios.dt_inclusao)
                                                    END
                                            END,
            Ans_Beneficiarios.cd_motivo_exclusao_Ans = (CASE
                                                            WHEN MOTIVO_CANCELAMENTO.cd_motivo_exclusao_ans IS NOT NULL THEN
                                                                MOTIVO_CANCELAMENTO.cd_motivo_exclusao_ans
                                                            ELSE
                                                                SITUACAO_HISTORICO.cd_motivo_exclusao_ans
                                                        END
                                                       ),
            cd_arquivo_envio_exc = @cd_sequencial
        FROM -- dependentes, ASSOCIADOS , empresa as e, HISTORICO , SITUACAO_HISTORICO , MOTIVO_CANCELAMENTO 
            dbo.DEPENDENTES
            INNER JOIN dbo.ASSOCIADOS
                ON ASSOCIADOS.cd_associado = DEPENDENTES.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA E
                ON ASSOCIADOS.cd_empresa = E.CD_EMPRESA
            INNER JOIN dbo.HISTORICO
                ON E.CD_Sequencial_historico = HISTORICO.cd_sequencial
            INNER JOIN dbo.SITUACAO_HISTORICO
                ON HISTORICO.CD_SITUACAO = dbo.SITUACAO_HISTORICO.CD_SITUACAO_HISTORICO
                   AND SITUACAO_HISTORICO.fl_incluir_ans = 0
            LEFT JOIN dbo.MOTIVO_CANCELAMENTO
                ON HISTORICO.cd_MOTIVO_CANCELAMENTO = dbo.MOTIVO_CANCELAMENTO.cd_motivo_cancelamento
        WHERE Ans_Beneficiarios.cd_sequencial_dep = DEPENDENTES.CD_SEQUENCIAL
              AND Ans_Beneficiarios.dt_exclusao IS NULL
              AND Ans_Beneficiarios.cd_arquivo_envio_exc IS NULL
              AND
            --DEPENDENTES.CD_ASSOCIADO = ASSOCIADOS.CD_ASSOCIADO and 
            --ASSOCIADOS.cd_empresa=e.CD_EMPRESA and 
            --e.CD_Sequencial_historico= HISTORICO.cd_Sequencial and 
            --HISTORICO.CD_SITUACAO=SITUACAO_HISTORICO.CD_SITUACAO_HISTORICO and
            --SITUACAO_HISTORICO.fl_incluir_ans=0 and 
            --historico.cd_MOTIVO_CANCELAMENTO *= MOTIVO_CANCELAMENTO.cd_motivo_cancelamento  and 
            HISTORICO.DT_SITUACAO < @dt_limite
              AND HISTORICO.DT_SITUACAO >= '02/01/2016'
              AND Ans_Beneficiarios.cco IS NOT NULL;
        PRINT 'processo exclusao excutado';

    --------------------------------------------------------------------------------------------
    END; -- END IF @Exclusão

    IF @inclusao = 1
    BEGIN
        --------------------------------------------------------------------------------------------
        --os insert abaixo entram ao escolher a opção "inclusao" no comando de "novo lote"

        PRINT 'Incluir os Titulares Mes Atual. Caso já existe a Trigger altera o Tipo Movimento p/ 3 (Competencia)';
        INSERT INTO dbo.Ans_Beneficiarios
        (
            cd_sequencial_dep,
            tipo_Movimentacao,
            dt_inclusao,
            cd_arquivo_envio_inc,
            nr_cpf,
            cd_plano_ans,
            nm_beneficiario,
            dt_nascimento,
            cd_grau_parentesco,
            cd_empresa,
            cd_beneficiario,
            cd_variacao
        )
        SELECT d.CD_SEQUENCIAL,
               1,
               --right(@competencia,2) + '/' + CONVERT(varchar(2),case when DAY(e.dt_vencimento)>28 and right(@competencia,2)='02' then 28 when DAY(e.dt_vencimento) > 30 then 30 else DAY(e.dt_vencimento) end) + '/' + LEFT(@competencia,4), -- Data Inclusao ANS
               --d.dt_assinaturaContrato , 
               CASE
                   WHEN @utilizaDatacompetenciaSIB = 1 THEN
                       RIGHT(@competencia, 2) + '/'
                       + CONVERT(   VARCHAR(2),
                                    CASE
                                        WHEN DAY(e.dt_vencimento) > 28
                                             AND RIGHT(@competencia, 2) = '02' THEN
                                            28
                                        WHEN DAY(e.dt_vencimento) > 30 THEN
                                            30
                                        ELSE
                                            DAY(e.dt_vencimento)
                                    END
                                ) + '/' + LEFT(@competencia, 4) -- Data Inclusao ANS
                   ELSE
                       d.dt_assinaturaContrato
               END,
               @cd_sequencial,
               d.nr_cpf_dep,
               ans.cd_ans,
               d.NM_DEPENDENTE,
               d.DT_NASCIMENTO,
               CASE
                   WHEN d.CD_GRAU_PARENTESCO NOT IN ( 1, 3, 4, 6, 8, 10 ) THEN
                       10
                   ELSE
                       d.CD_GRAU_PARENTESCO
               END,
               CASE
                   WHEN ans.tp_empresa IN ( 2, 8 ) THEN
                       e.CD_EMPRESA
                   ELSE
                       NULL
               END,
               d.CD_SEQUENCIAL,
               1
        FROM dbo.DEPENDENTES AS d,
             dbo.ASSOCIADOS AS a,
             dbo.PLANOS AS p,
             dbo.CLASSIFICACAO_ANS AS ans,
             dbo.EMPRESA AS e,
             dbo.HISTORICO AS h,
             dbo.SITUACAO_HISTORICO AS sh,
             dbo.HISTORICO AS h_e,
             dbo.SITUACAO_HISTORICO AS sh_e
        WHERE d.CD_ASSOCIADO = a.cd_associado
              AND d.CD_GRAU_PARENTESCO = 1
              AND d.cd_plano = p.cd_plano
              AND d.CD_Sequencial_historico = h.cd_sequencial
              AND h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO
              AND sh.fl_incluir_ans = 1
              AND p.cd_classificacao = ans.cd_classificacao
              AND a.cd_empresa = e.CD_EMPRESA
              AND e.CD_Sequencial_historico = h_e.cd_sequencial
              AND h_e.CD_SITUACAO = sh_e.CD_SITUACAO_HISTORICO
              AND sh_e.fl_incluir_ans = 1
              AND e.TP_EMPRESA < 10
              --and d.mm_aaaa_1pagamento =  @competencia   -- Inclusao do Mes Anterior
              --and CONVERT(varchar(6),d.dt_assinaturaContrato  ,112)=  @competencia
              AND (CASE
                       WHEN @utilizaDatacompetenciaSIB = 1 THEN
                           d.mm_aaaa_1pagamento
                       ELSE
                           CONVERT(VARCHAR(6), d.dt_assinaturaContrato, 112)
                   END
                  ) = @competencia
              AND d.CD_SEQUENCIAL NOT IN
                  (
                      SELECT cd_sequencial_dep
                      FROM dbo.Ans_Beneficiarios
                      WHERE dt_exclusao IS NULL
                            AND CD_SEQUENCIAL_dep IS NOT NULL
                  )
              AND a.cd_associado NOT IN
                  (
                      SELECT cd_associado FROM dbo.Exclusao_Ans WHERE cd_associado IS NOT NULL
                  )
              AND a.cd_empresa NOT IN
                  (
                      SELECT cd_empresa FROM dbo.Exclusao_Ans WHERE CD_empresa IS NOT NULL
                  )
              AND d.nr_cpf_dep NOT IN
                  (
                      SELECT nr_cpf
                      FROM dbo.Ans_Beneficiarios
                      WHERE dt_exclusao IS NULL
                            AND nr_cpf IS NOT NULL
                  )
              AND d.nr_cpf_dep IS NOT NULL -- So entra quem possui CPF
              AND d.nm_mae_dep IS NOT NULL
              AND ans.IdConvenio IS NULL;


        --print 'Incluir os Titulares Competencia Passada. Caso já existe a Trigger altera o Tipo Movimento p/ 3 (Competencia)'
        INSERT INTO dbo.Ans_Beneficiarios
        (
            cd_sequencial_dep,
            tipo_Movimentacao,
            dt_inclusao,
            cd_arquivo_envio_inc,
            nr_cpf,
            cd_plano_ans,
            nm_beneficiario,
            dt_nascimento,
            cd_grau_parentesco,
            cd_empresa,
            cd_beneficiario,
            cd_variacao
        )
        SELECT d.CD_SEQUENCIAL,
               1,
               --right(@competencia,2) + '/' + CONVERT(varchar(2),case when DAY(e.dt_vencimento)>28 and right(@competencia,2)='02' then 28 when DAY(e.dt_vencimento) > 30 then 30 else DAY(e.dt_vencimento) end) + '/' + LEFT(@competencia,4), -- Data Inclusao ANS
               --d.dt_assinaturaContrato ,
               CASE
                   WHEN @utilizaDatacompetenciaSIB = 1 THEN
                       RIGHT(@competencia, 2) + '/'
                       + CONVERT(   VARCHAR(2),
                                    CASE
                                        WHEN DAY(e.dt_vencimento) > 28
                                             AND RIGHT(@competencia, 2) = '02' THEN
                                            28
                                        WHEN DAY(e.dt_vencimento) > 30 THEN
                                            30
                                        ELSE
                                            DAY(e.dt_vencimento)
                                    END
                                ) + '/' + LEFT(@competencia, 4) -- Data Inclusao ANS
                   ELSE
                       d.dt_assinaturaContrato
               END,
               @cd_sequencial,
               d.nr_cpf_dep,
               ans.cd_ans,
               d.NM_DEPENDENTE,
               d.DT_NASCIMENTO,
               CASE
                   WHEN d.CD_GRAU_PARENTESCO NOT IN ( 1, 3, 4, 6, 8, 10 ) THEN
                       10
                   ELSE
                       d.CD_GRAU_PARENTESCO
               END,
               CASE
                   WHEN ans.tp_empresa IN ( 2, 8 ) THEN
                       e.CD_EMPRESA
                   ELSE
                       NULL
               END,
               d.CD_SEQUENCIAL,
               1
        FROM dbo.DEPENDENTES AS d,
             dbo.ASSOCIADOS AS a,
             dbo.PLANOS AS p,
             dbo.CLASSIFICACAO_ANS AS ans,
             dbo.EMPRESA AS e,
             dbo.HISTORICO AS h,
             dbo.SITUACAO_HISTORICO AS sh,
             dbo.HISTORICO AS h_e,
             dbo.SITUACAO_HISTORICO AS sh_e
        WHERE d.CD_ASSOCIADO = a.cd_associado
              AND d.CD_GRAU_PARENTESCO = 1
              AND d.cd_plano = p.cd_plano
              AND d.CD_Sequencial_historico = h.cd_sequencial
              AND h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO
              AND sh.fl_incluir_ans = 1
              AND p.cd_classificacao = ans.cd_classificacao
              AND a.cd_empresa = e.CD_EMPRESA
              AND e.CD_Sequencial_historico = h_e.cd_sequencial
              AND h_e.CD_SITUACAO = sh_e.CD_SITUACAO_HISTORICO
              AND sh_e.fl_incluir_ans = 1
              AND e.TP_EMPRESA < 10
              --and d.mm_aaaa_1pagamento <  @competencia   -- Inclusao do Mes Anterior
              --and CONVERT(varchar(6),d.dt_assinaturaContrato  ,112)<  @competencia
              AND (CASE
                       WHEN @utilizaDatacompetenciaSIB = 1 THEN
                           d.mm_aaaa_1pagamento
                       ELSE
                           CONVERT(VARCHAR(6), d.dt_assinaturaContrato, 112)
                   END
                  ) < @competencia
              AND d.CD_SEQUENCIAL NOT IN
                  (
                      SELECT cd_sequencial_dep
                      FROM dbo.Ans_Beneficiarios
                      WHERE dt_exclusao IS NULL
                            AND CD_SEQUENCIAL_dep IS NOT NULL
                  )
              AND a.cd_associado NOT IN
                  (
                      SELECT cd_associado FROM dbo.Exclusao_Ans WHERE cd_associado IS NOT NULL
                  )
              AND a.cd_empresa NOT IN
                  (
                      SELECT cd_empresa FROM dbo.Exclusao_Ans WHERE CD_empresa IS NOT NULL
                  )
              AND d.nr_cpf_dep NOT IN
                  (
                      SELECT nr_cpf
                      FROM dbo.Ans_Beneficiarios
                      WHERE dt_exclusao IS NULL
                            AND nr_cpf IS NOT NULL
                  )
              AND d.nr_cpf_dep IS NOT NULL -- So entra quem possui CPF
              AND d.nm_mae_dep IS NOT NULL
              AND ans.IdConvenio IS NULL
        ORDER BY d.mm_aaaa_1pagamento DESC;

        --print 'Dependente. Caso já existe a Trigger altera o Tipo Movimento p/ 3'
        INSERT INTO Ans_Beneficiarios
        (
            cd_sequencial_dep,
            tipo_Movimentacao,
            dt_inclusao,
            cd_arquivo_envio_inc,
            nr_cpf,
            cd_plano_ans,
            nm_beneficiario,
            dt_nascimento,
            cd_grau_parentesco,
            cd_empresa,
            cd_beneficiario_titular,
            cd_beneficiario,
            cd_variacao
        )
        SELECT d.CD_SEQUENCIAL,
               1,
                  -- right(@competencia,2) + '/' + CONVERT(varchar(2),case when DAY(e.dt_vencimento)>28 and right(@competencia,2)='02' then 28 when DAY(e.dt_vencimento) > 30 then 30 else DAY(e.dt_vencimento) end) + '/' + LEFT(@competencia,4), -- Data Inclusao ANS
                  --d.dt_assinaturaContrato , 
               CASE
                   WHEN @utilizaDatacompetenciaSIB = 1 THEN
                       RIGHT(@competencia, 2) + '/'
                       + CONVERT(   VARCHAR(2),
                                    CASE
                                        WHEN DAY(e.dt_vencimento) > 28
                                             AND RIGHT(@competencia, 2) = '02' THEN
                                            28
                                        WHEN DAY(e.dt_vencimento) > 30 THEN
                                            30
                                        ELSE
                                            DAY(e.dt_vencimento)
                                    END
                                ) + '/' + LEFT(@competencia, 4) -- Data Inclusao ANS
                   ELSE
                       d.dt_assinaturaContrato
               END,
               @cd_sequencial,
               d.nr_cpf_dep,
               ans.cd_ans,
               d.NM_DEPENDENTE,
               d.DT_NASCIMENTO,
               CASE
                   WHEN d.CD_GRAU_PARENTESCO NOT IN ( 1, 3, 4, 6, 8, 10 ) THEN
                       10
                   ELSE
                       d.CD_GRAU_PARENTESCO
               END,
               CASE
                   WHEN ans.tp_empresa IN ( 2, 8 ) THEN
                       e.CD_EMPRESA
                   ELSE
                       NULL
               END,
                  -- case when dd.cd_beneficiario_ans IS null then convert(varchar(30),dd.CD_SEQUENCIAL) else convert(varchar(30),dd.cd_beneficiario_ans) end
               (
                   SELECT TOP 1
                          ansb.cd_beneficiario
                   FROM Ans_Beneficiarios ansb
                   WHERE ansb.cd_sequencial_dep = dd.cd_sequencial
                         AND ansb.dt_exclusao IS NULL
               ), -- cd_beneficiario_titular
               d.CD_SEQUENCIAL,
               1
        FROM DEPENDENTES AS d,
             ASSOCIADOS AS a,
             PLANOS AS p,
             CLASSIFICACAO_ANS AS ans,
             EMPRESA AS e,
             HISTORICO AS h,
             SITUACAO_HISTORICO AS sh,
             HISTORICO AS h_e,
             SITUACAO_HISTORICO AS sh_e,
             DEPENDENTES AS dd -- Dependente Titular
        WHERE d.CD_ASSOCIADO = a.cd_associado
              AND d.CD_GRAU_PARENTESCO > 1
              AND d.cd_plano = p.cd_plano
              AND d.CD_Sequencial_historico = h.cd_sequencial
              AND h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO
              AND sh.fl_incluir_ans = 1
              AND p.cd_classificacao = ans.cd_classificacao
              AND a.cd_empresa = e.CD_EMPRESA
              AND e.CD_Sequencial_historico = h_e.cd_sequencial
              AND h_e.CD_SITUACAO = sh_e.CD_SITUACAO_HISTORICO
              AND sh_e.fl_incluir_ans = 1
              AND e.TP_EMPRESA < 10
              AND CONVERT(VARCHAR(6), d.dt_assinaturaContrato, 112) <= @competencia -- Removido o < para so entrar a competencia atual 
              AND d.nm_mae_dep IS NOT NULL
              AND
              (
                  d.DT_NASCIMENTO > DATEADD(YEAR, -18, GETDATE())
                  OR
                  (
                      d.DT_NASCIMENTO <= DATEADD(YEAR, -18, GETDATE())
                      AND d.nr_cpf_dep IS NOT NULL
                      AND d.nr_cpf_dep NOT IN
                          (
                              SELECT nr_cpf
                              FROM Ans_Beneficiarios
                              WHERE dt_exclusao IS NULL
                                    AND nr_cpf IS NOT NULL
                          )
                  ) -- So entra quem possui CPF
              )
              AND d.CD_SEQUENCIAL NOT IN
                  (
                      SELECT cd_sequencial_dep
                      FROM Ans_Beneficiarios
                      WHERE dt_exclusao IS NULL
                            AND CD_SEQUENCIAL_dep IS NOT NULL
                  )
              AND a.cd_associado = dd.CD_ASSOCIADO -- Titular
              AND dd.CD_GRAU_PARENTESCO = 1 -- Titular
              AND dd.CD_SEQUENCIAL IN
                  (
                      SELECT cd_sequencial_dep
                      FROM Ans_Beneficiarios
                      WHERE dt_exclusao IS NULL
                            AND cd_grau_parentesco = 1
                            AND CD_SEQUENCIAL_dep IS NOT NULL
                  ) -- titular ativo na ANS
              AND a.cd_associado NOT IN
                  (
                      SELECT cd_associado FROM Exclusao_Ans WHERE CD_ASSOCIADO IS NOT NULL
                  )
              AND a.cd_empresa NOT IN
                  (
                      SELECT cd_empresa FROM Exclusao_Ans WHERE CD_empresa IS NOT NULL
                  )
              AND ans.IdConvenio IS NULL;
        -- and dd.CD_SEQUENCIAL<0 -- Retirar para incluir os dependentes 
        --------------------------------------------------------------------------------------------
        PRINT 'processo inclusao excutado';

    END; -- end if @inclusao

    IF @retificacao = 1
    BEGIN
        --------------------------------------------------------------------------------------------
        --os update e insert abaixo entram ao escolher a opção "retificação" no comando de "novo lote"

        --	--------Update Retificação----------

        UPDATE cv
        SET cv.cd_arquivo_envio_inc = @cd_sequencial,
            cv.mensagemErro = NULL,
            cv.tipo_Movimentacao = 2
        FROM ConferenciaANS_Verificacao cv,
             Conferencia_ANS c
        WHERE cv.ocorrencia IN ( 2 )
              AND cv.cco = c.cco
              AND c.situacao = 'ATIVO'
              AND DATEDIFF(DAY, cv.data_verificacao, GETDATE()) <= 30
              AND (0 + +CASE
                            WHEN @filtroCamposDivergentes LIKE '%,' + CAST(1 AS VARCHAR(5)) + ',%'
                                 AND ISNULL(CONVERT(INT, cv.nome), 0) > 0 THEN
                                1
                            ELSE
                                0
                        END + CASE
                                  WHEN @filtroCamposDivergentes LIKE '%,' + CAST(2 AS VARCHAR(5)) + ',%'
                                       AND ISNULL(CONVERT(INT, cv.cpf), 0) > 0 THEN
                                      1
                                  ELSE
                                      0
                              END + CASE
                                        WHEN @filtroCamposDivergentes LIKE '%,' + CAST(3 AS VARCHAR(5)) + ',%'
                                             AND ISNULL(CONVERT(INT, cv.sexo), 0) > 0 THEN
                                            1
                                        ELSE
                                            0
                                    END + CASE
                                              WHEN @filtroCamposDivergentes LIKE '%,' + CAST(4 AS VARCHAR(5)) + ',%'
                                                   AND ISNULL(CONVERT(INT, cv.situacao), 0) > 0 THEN
                                                  1
                                              ELSE
                                                  0
                                          END
                   + CASE
                         WHEN @filtroCamposDivergentes LIKE '%,' + CAST(5 AS VARCHAR(5)) + ',%'
                              AND ISNULL(CONVERT(INT, cv.cns), 0) > 0 THEN
                             1
                         ELSE
                             0
                     END + CASE
                               WHEN @filtroCamposDivergentes LIKE '%,' + CAST(6 AS VARCHAR(5)) + ',%'
                                    AND ISNULL(CONVERT(INT, cv.dataNascimento), 0) > 0 THEN
                                   1
                               ELSE
                                   0
                           END + CASE
                                     WHEN @filtroCamposDivergentes LIKE '%,' + CAST(7 AS VARCHAR(5)) + ',%'
                                          AND ISNULL(CONVERT(INT, cv.nomeMae), 0) > 0 THEN
                                         1
                                     ELSE
                                         0
                                 END + CASE
                                           WHEN @filtroCamposDivergentes LIKE '%,' + CAST(8 AS VARCHAR(5)) + ',%'
                                                AND ISNULL(CONVERT(INT, cv.relacaoDependencia), 0) > 0 THEN
                                               1
                                           ELSE
                                               0
                                       END
                   + CASE
                         WHEN @filtroCamposDivergentes LIKE '%,' + CAST(10 AS VARCHAR(5)) + ',%'
                              AND ISNULL(CONVERT(INT, cv.cnpjEmpresaContratante), 0) > 0 THEN
                             1
                         ELSE
                             0
                     END + CASE
                               WHEN @filtroCamposDivergentes LIKE '%,' + CAST(11 AS VARCHAR(5)) + ',%'
                                    AND ISNULL(CONVERT(INT, cv.caepfEmpresaContratante), 0) > 0 THEN
                                   1
                               ELSE
                                   0
                           END + CASE
                                     WHEN @filtroCamposDivergentes LIKE '%,' + CAST(12 AS VARCHAR(5)) + ',%'
                                          AND ISNULL(CONVERT(INT, cv.ceiEmpresaContratante), 0) > 0 THEN
                                         1
                                     ELSE
                                         0
                                 END
                  ) > 0;


        PRINT 'processo retificacao excutado';
    --------------------------------------------------------------------------------------------
    END; -- if @retificacao

    IF @mContratual = 1
    BEGIN
        --------------------------------------------------------------------------------------------
        --os update e insert abaixo entram ao escolher a opção "Mudança Contratual" no comando de "novo lote"

        ----------Update Mudança Contratual----------

        UPDATE cv
        SET cv.cd_arquivo_envio_inc = @cd_sequencial,
            cv.mensagemErro = NULL,
            cv.tipo_Movimentacao = 4
        FROM ConferenciaANS_Verificacao cv,
             Conferencia_ANS c
        WHERE cv.ocorrencia IN ( 2 )
              AND cv.cco = c.cco
              AND c.situacao = 'ATIVO'
              AND DATEDIFF(DAY, cv.data_verificacao, GETDATE()) <= 30
              AND ISNULL(CONVERT(INT, cv.numeroPlanoANS), 0) > 0;


        PRINT 'processo mContratual executado';
    --------------------------------------------------------------------------------------------
    END; -- end mContratual
    -------------------------------------------------------------------------------------------------------------------------

    PRINT 'Totalizadores';
    UPDATE ANS
    SET qt_reg_inclusao =
        (
            SELECT COUNT(0)
            FROM Ans_Beneficiarios
            WHERE cd_arquivo_envio_inc = @cd_sequencial
                  AND tipo_Movimentacao = 1
        ),
        qt_reg_reativacao =
        (
            SELECT COUNT(0)
            FROM Ans_Beneficiarios
            WHERE cd_arquivo_envio_inc = @cd_sequencial
                  AND tipo_Movimentacao = 3
        ),
        qt_reg_exclusao =
        (
            SELECT COUNT(0)
            FROM Ans_Beneficiarios
            WHERE cd_arquivo_envio_exc = @cd_sequencial
                  AND oculto IS NULL
        ),
        qt_reg_retificacao =
        (
            SELECT COUNT(0)
            FROM ConferenciaANS_Verificacao cv,
                 Conferencia_ANS c
            WHERE cv.cd_arquivo_envio_inc = @cd_sequencial
                  AND cv.cco = c.cco
                  AND c.situacao = 'ATIVO'
                  AND cv.tipo_Movimentacao = 2
        ),
        qt_reg_mudanca =
        (
            SELECT COUNT(0)
            FROM ConferenciaANS_Verificacao cv,
                 Conferencia_ANS c
            WHERE cv.cd_arquivo_envio_inc = @cd_sequencial
                  AND cv.cco = c.cco
                  AND c.situacao = 'ATIVO'
                  AND cv.tipo_Movimentacao = 4
        )
    WHERE cd_sequencial = @cd_sequencial;


END;
