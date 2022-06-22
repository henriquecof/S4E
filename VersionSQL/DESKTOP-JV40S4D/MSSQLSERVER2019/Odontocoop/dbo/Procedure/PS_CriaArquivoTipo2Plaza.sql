/****** Object:  Procedure [dbo].[PS_CriaArquivoTipo2Plaza]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_CriaArquivoTipo2Plaza]              
AS
Begin        
       Declare @Mes SmallInt
       Declare @Ano Int

       Declare @Sequencial_Header Int
       Declare @DataFinal DateTime


       -- Verificar se existe arquivo gerado e nao enviado. Se existir a Data Final esta nesse arquivo
       Set @Sequencial_Header = 0
       Select @Sequencial_Header = IsNull(CD_Sequencial,0) , @DataFinal = dt_final
          From TB_ABS_PLAZA_QUINZENAL_HEADER
          Where dt_envio is null  

       If @Sequencial_Header = 0
          Begin 
            -- Mes e Ano   
            Set @Mes = Month(getdate())
            Set @Ano = Year(getdate())

            -- Calcular a Data final
            -- Quinzena
--            If day(getdate()) <= 15 
                Set @DataFinal = DateAdd(day,-1,convert(datetime,Convert(varchar,@Mes) + '/01/' + Convert(varchar,@Ano)))
--           Else     
--               Set @DataFinal = convert(datetime,Convert(varchar,@Mes) + '/15/' + Convert(varchar,@Ano))
 
            -- Gera o registro no Header
            Insert into TB_ABS_PLAZA_QUINZENAL_HEADER (cd_sequencial,dt_geracao,dt_final)
            select IsNull(Max(CD_Sequencial)+1,1) , getdate(), @DataFinal 
              from TB_ABS_PLAZA_QUINZENAL_HEADER

             Select @Sequencial_Header = Max(CD_Sequencial) 
             From TB_ABS_PLAZA_QUINZENAL_HEADER
          End                     
        Else
          Begin
               -- Se tiver gerado registros para essas datas excluir.
               Delete From TB_ABS_PLAZA_QUINZENAL 
               Where cd_sequencial_header = @Sequencial_Header

               Update TB_ABS_PLAZA_QUINZENAL_HEADER 
                  Set dt_geracao = getdate()
                 Where cd_sequencial = @Sequencial_Header
          End   

print @datafinal

       -- Pegar o sequencial do ultimo arquivo para ver se quais os ativos pagaram
        Insert Into TB_ABS_PLAZA_QUINZENAL(cd_associado,cd_sequencial_dep,dt_vencimento,dt_pagamento,cd_sequencial_header,vl_credito)
        select cd_associado, cd_sequencial , m.dt_vencimento, m.dt_pagamento,@Sequencial_Header,0.6
          from tb_abs_plaza as p, mensalidades as m 
          where p.cd_associado = m.cd_associado_empresa and m.tp_Associado_empresa=1 and 
                m.dt_pagamento <= @DataFinal and m.cd_tipo_recebimento>2 and 
                m.dt_vencimento >= p.dt_inicio and m.cd_parcela <= 32000 and 
                cd_sequencial_header = ( select max(cd_sequencial) from TB_ABS_PLAZA_HEADER) and 
                not exists (select 0 from tb_abs_plaza_quinzenal as q
                             where p.cd_Associado = q.cd_Associado and p.cd_sequencial = q.cd_Sequencial_dep and 
                                   m.dt_vencimento = q.dt_vencimento)  


        Declare @cd_Ass integer 
        Declare @cd_seq integer
        Declare @dt_venc datetime 
        Declare @q_int integer

        Set @q_int = 0 
        DECLARE cursor_ass CURSOR FOR 
        select cd_Associado, cd_sequencial_dep, dt_vencimento from tb_abs_plaza_quinzenal where cd_sequencial_header=@Sequencial_Header
        OPEN cursor_ass
        FETCH NEXT FROM cursor_ass INTO @cd_ass,@cd_seq,@dt_venc
        WHILE (@@FETCH_STATUS <> -1)
        BEGIN

           if @q_int = 10 
           Begin
              update tb_abs_plaza_quinzenal
                 set vl_credito = 0 
               where cd_Associado=@cd_ass and cd_sequencial_dep=@cd_seq and dt_vencimento=@dt_venc

              Set @q_int = 0 

           End           
           Set @q_int = @q_int + 1 
           FETCH NEXT FROM cursor_ass INTO @cd_ass,@cd_seq,@dt_venc
        End
        Close cursor_ass
        DEALLOCATE cursor_ass


        

End
