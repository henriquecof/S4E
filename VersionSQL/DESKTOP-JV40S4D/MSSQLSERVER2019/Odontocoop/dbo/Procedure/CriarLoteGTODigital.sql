/****** Object:  Procedure [dbo].[CriarLoteGTODigital]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.CriarLoteGTODigital
-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/09/2021 10:54
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DO ESTILO T-SQL
-- =============================================

/*
ESSA PROCEDURE ABRE UM BLOCO BEGIN/END.
DENTRO DO BLOCO É DECLARADO A VARIAVEL.:
@diaCorteFaturamentoDigital INT

1º - REALIZADO SELECT NA TABELA.: configuracao, COMPARANDO A VARIAVAL @diaCorteFaturamentoDigital = ISNULL(diaCorteFaturamentoDigital, 0)
2º - É FEITO ABERTURA IF (@diaCorteFaturamentoDigital = day(getdate()))
3º - DENTRO DO IF É ABERTO BLOCO BEGIN/END, SENDO DECLARADA DUAS VARIAVEIS.:
@cd_filial int
@cd_funcionario int
3.1º - DECLARADO CURSOR vCursor USANDO SELECT NA TABELA consultas. USANDO COMO CONDIÇÃO NA CLAUSULA WHERE.:
T1.id_protocolo is null
and (select count(0) from ArquivoConsultas where nr_gto = T1.nr_gto and arcDtExclusao is null) > 0
and T1.dt_cancelamento is null
and T1.dt_servico is not null
and T1.nr_numero_lote is null
4º - CURSOR É ABERTO E LOGO APÓS REALIZADO FETCH NEXT FROM vCursor REALIZANDO INSERT NAS VARIAVEIS.:
@cd_filial, 
@cd_funcionario
5º - ABERTO WHILE USANDO @@FETCH_STATUS = 0
6º - DENTRO DO WHILE ABERTO BLOCO BEGIN/END, REALIZANDO INSERT NA TABELA Processos USANDO CONDIÇÃO NA CLAUSULA WHERE cd_processo = 6
6.1º REALIZADO UPDATE NA TABELA consultas SETANDO OS CAMPOS.:
id_protocolo = @@IDENTITY, 
ExecutarTrigger = 0

É USADO COMO CONDIÇÃO NA CLAUSULA WHERE.:
cd_funcionario = @cd_funcionario
and cd_filial = @cd_filial
and id_protocolo is null
and (select count(0) from ArquivoConsultas where nr_gto = consultas.nr_gto and arcDtExclusao is null) > 0
and dt_cancelamento is null
and dt_servico is not null
and nr_numero_lote is null

7º - REALIZADO FETCH NEXT FROM vCursor REALIZANDO INSERT NAS VARIAVEIS.:
@cd_filial, 
@cd_funcionario
8º - FECHAMENTO BEGIN ITEM 5º.
9º - CURSOR FECHADO E DEALLOCATE.
10º - FECHADO BEGIN DO ITEM 3º
11º - FECHADO BEGIN DO INICIO DA PROCEDURE


*/
AS
  BEGIN
    --***********************************************
    --LOTE GTO DIGITAL
    --***********************************************

    DECLARE @diaCorteFaturamentoDigital INT

    SELECT @diaCorteFaturamentoDigital = ISNULL(diaCorteFaturamentoDigital , 0)
    FROM Configuracao

    IF (@diaCorteFaturamentoDigital = DAY(GETDATE()))
      BEGIN
        DECLARE @cd_filial INT
        DECLARE @cd_funcionario INT

        DECLARE vCursor CURSOR
        FOR SELECT DISTINCT T1.cd_filial , T1.CD_FUNCIONARIO
          FROM Consultas T1
          WHERE T1.id_protocolo IS NULL
                AND
                (SELECT COUNT(0)
                    FROM ArquivoConsultas
                    WHERE nr_gto = T1.nr_gto
                          AND
                          arcDtExclusao IS NULL
                ) > 0
                AND
                T1.dt_cancelamento IS NULL
                AND
                T1.dt_servico IS NOT NULL
                AND
                T1.nr_numero_lote IS NULL
        OPEN vCursor

        FETCH NEXT FROM vCursor INTO @cd_filial , @cd_funcionario

        WHILE @@FETCH_STATUS = 0
          BEGIN

            --BEGIN TRANSACTION

            INSERT INTO ProtocoloConsultas (dt_gerado , dt_alterado , usuario_cadastro , cd_funcionario , cd_filial , GTODigital)
                   SELECT CONVERT(DATE , GETDATE()) , NULL , cd_funcionario , @cd_funcionario , @cd_filial , 1
                   FROM Processos
                   WHERE cd_processo = 6

            UPDATE Consultas
                   SET id_protocolo = @@IDENTITY ,
                       ExecutarTrigger = 0
            WHERE cd_funcionario = @cd_funcionario
                   AND
                   cd_filial = @cd_filial
                   AND
                   id_protocolo IS NULL
                   AND
                   (SELECT COUNT(0)
                       FROM ArquivoConsultas
                       WHERE nr_gto = Consultas.nr_gto
                             AND
                             arcDtExclusao IS NULL
                   ) > 0
                   AND
                   dt_cancelamento IS NULL
                   AND
                   dt_servico IS NOT NULL
                   AND
                   nr_numero_lote IS NULL

            --COMMIT

            FETCH NEXT FROM vCursor INTO @cd_filial , @cd_funcionario
          END
        CLOSE vCursor
        DEALLOCATE vCursor
      END

  END
