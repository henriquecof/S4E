/****** Object:  Procedure [dbo].[PS_GeraHorarioVago]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_GeraHorarioVago]
As
Begin 

  /* declarações de variaveis*/
  Declare @nm_filial        varchar(80)
  Declare @nm_especialidade varchar(100)
  Declare @nm_abreviado     varchar(100)
  Declare @dt_compromisso   datetime
  Declare @turno            varchar(20)         
  Declare @aberto           Int 
  Declare @quantidade       Int
  Declare @Contagem         Smallint
  Declare @nm_abreviado_Aux varchar(100)
 
  /*Tabela temporaria para armazenar os dados*/
  /*Tabela temporaria para armazenar os dados*/
  Delete From TB_PrimeiroHoratioVago 

  /*Cursor onde vou pegar as informações para quardar na tabela temporaria, quardar somente os dois primeiros
   registros para os funcionarios, dentistas*/
  Declare  Dados_Cursor  cursor for     
   Select fil.nm_filial, e.nm_especialidade, f.nm_abreviado, dt_compromisso,'1)Manhã' as turno, 
         count(a.cd_sequencial) as aberto , datediff(day,getdate(),dt_compromisso) as quantidade
   From  agenda as a, funcionario as f , filial as fil , atuacao_dentista_new as n, especialidade as e
   Where a.cd_funcionario = f.cd_funcionario And 
         a.cd_empresa = fil.cd_filial and 
         a.cd_sequencial_atuacao_dent = n.cd_sequencial  and 
         n.cd_especialidade = e.cd_especialidade and 
         (nm_anotacao is null or ltrim(nm_anotacao) = '') and 
         dt_compromisso >= getdate() and 
         dt_compromisso <= dateadd(day,60,getdate()) and 
         fil.cd_filial in (1,3,116,225,264,560,980,1004,935,1010,426) and 
         hr_compromisso>479 and 
         hr_compromisso<780
   Group By fil.nm_filial, e.nm_especialidade,  f.nm_abreviado, f.cd_funcionario , dt_compromisso
   Having count(a.cd_sequencial) > 2
   Union
   Select fil.nm_filial, e.nm_especialidade, f.nm_abreviado, dt_compromisso,'2)Meio-Dia' as turno, 
          count(a.cd_sequencial) as aberto , datediff(day,getdate(),dt_compromisso)
   From   agenda as a, funcionario as f , filial as fil , atuacao_dentista_new as n, especialidade as e
   Where  a.cd_funcionario = f.cd_funcionario And 
          a.cd_empresa = fil.cd_filial and 
          a.cd_sequencial_atuacao_dent = n.cd_sequencial  and 
          n.cd_especialidade = e.cd_especialidade and 
         (nm_anotacao is null or ltrim(nm_anotacao) = '') and 
          dt_compromisso >= getdate() and 
          dt_compromisso <= dateadd(day,60,getdate()) and 
          fil.cd_filial in (1,3,116,225,264,560,980,1004,935,1010,426) and 
          hr_compromisso>779 and hr_compromisso<840
   Group By fil.nm_filial, e.nm_especialidade,  f.nm_abreviado, f.cd_funcionario , dt_compromisso
   Having count(a.cd_sequencial) > 2
   Union
   Select fil.nm_filial, e.nm_especialidade, f.nm_abreviado, dt_compromisso,'3)Tarde' as turno, 
   count(a.cd_sequencial) as aberto , datediff(day,getdate(),dt_compromisso)
   From  agenda as a, funcionario as f , filial as fil , atuacao_dentista_new as n, especialidade as e
   Where a.cd_funcionario = f.cd_funcionario And
         a.cd_empresa = fil.cd_filial and 
         a.cd_sequencial_atuacao_dent = n.cd_sequencial  and 
         n.cd_especialidade = e.cd_especialidade and 
        (nm_anotacao is null or ltrim(nm_anotacao) = '') and 
         dt_compromisso >= getdate() and 
         dt_compromisso <= dateadd(day,60,getdate()) and 
         fil.cd_filial in (1,3,116,225,264,560,980,1004,935,1010,426) and 
         hr_compromisso>839 and hr_compromisso<1080
   Group By fil.nm_filial, e.nm_especialidade,  f.nm_abreviado, f.cd_funcionario , dt_compromisso
   Having count(a.cd_sequencial) > 2
   Union
   Select fil.nm_filial, e.nm_especialidade, f.nm_abreviado, dt_compromisso,'4)Noite' as turno, 
      count(a.cd_sequencial) as aberto , datediff(day,getdate(),dt_compromisso)
   From  agenda as a, funcionario as f , filial as fil , atuacao_dentista_new as n, especialidade as e
   Where a.cd_funcionario = f.cd_funcionario And
         a.cd_empresa = fil.cd_filial and 
         a.cd_sequencial_atuacao_dent = n.cd_sequencial  and 
         n.cd_especialidade = e.cd_especialidade and 
        (nm_anotacao is null or ltrim(nm_anotacao) = '') and 
         dt_compromisso >= getdate() and 
         dt_compromisso <= dateadd(day,60,getdate()) and 
         fil.cd_filial in (1,3,116,225,264,560,980,1004,935,1010,426) and 
         hr_compromisso>1079
   Group By fil.nm_filial, e.nm_especialidade,  f.nm_abreviado, f.cd_funcionario , dt_compromisso
   Having count(a.cd_sequencial) > 2
   Order By fil.nm_filial, e.nm_especialidade, turno, f.nm_abreviado, dt_compromisso

   Open Dados_Cursor
      Fetch next from Dados_Cursor
      Into  @nm_filial,@nm_especialidade,@nm_abreviado,@dt_compromisso,   
            @turno    ,@aberto          ,@quantidade       
   
   /*Iniciando loop*/
   While (@@fetch_status  <> -1)
     Begin        
       Set @Contagem         = 1 
       Set @nm_abreviado_Aux = @nm_abreviado

       While @nm_abreviado_Aux = @nm_abreviado 
          Begin
             If  @Contagem <= 1 
                 Insert into TB_PrimeiroHoratioVago Values
                 (@nm_filial,@nm_especialidade,@nm_abreviado,@dt_compromisso,@turno,@aberto,@quantidade)

             Set @Contagem = @Contagem + 1           

             Fetch Next From Dados_Cursor
             Into  @nm_filial,@nm_especialidade,@nm_abreviado,@dt_compromisso,   
                   @turno    ,@aberto          ,@quantidade       

             If (@@fetch_status  = -1)
                Break
          End    
     End 
     Close Dados_Cursor
     Deallocate Dados_Cursor

     /*-------------------------------------------------------------------------------------------------------*/
     /*Gravar para o Abs on-line mandar para os emails*/    
     /*-------------------------------------------------------------------------------------------------------*/

     /* Email para a Camila, cassio, bira, clarissa, lucimar , fernanda mara */


      /*Inserir na tabela de EMAILS para ser mandado via ABS Files*/
      Insert Into EMAILS (cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)      
      Select Max(cd_sequencial)+1,'marcio@absonline.com.br',
      '<font size=1><a href=''http://intra.absonline.com.br/modulos/ABS_Gerencial/MostraHorarioVago.asp''>Clique aqui e visualize o relatório dos horários vagos dos dentistas</a>'
      ,'Previsão para marcação de consultas',0,null
      From Emails

      Insert Into EMAILS (cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)      
      Select Max(cd_sequencial)+1,'ubiratan.chaves@absonline.com.br',
      '<font size=1><a href=''http://intra.absonline.com.br/modulos/ABS_Gerencial/MostraHorarioVago.asp''>Clique aqui e visualize o relatório dos horários vagos dos dentistas</a>'
      ,'Previsão para marcação de consultas',0,null
      From Emails

      Insert Into EMAILS (cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)      
      Select Max(cd_sequencial)+1,'cassio@absonline.com.br',
      '<font size=1><a href=''http://intra.absonline.com.br/modulos/ABS_Gerencial/MostraHorarioVago.asp''>Clique aqui e visualize o relatório dos horários vagos dos dentistas</a>'
      ,'Previsão para marcação de consultas',0,null
      From Emails

      Insert Into EMAILS (cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)      
      Select Max(cd_sequencial)+1,'camila@absonline.com.br',
      '<font size=1><a href=''http://intra.absonline.com.br/modulos/ABS_Gerencial/MostraHorarioVago.asp''>Clique aqui e visualize o relatório dos horários vagos dos dentistas</a>'
      ,'Previsão para marcação de consultas',0,null
      From Emails

      Insert Into EMAILS (cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)      
      Select Max(cd_sequencial)+1,'clarissa.passos@absonline.com.br',
      '<font size=1><a href=''http://intra.absonline.com.br/modulos/ABS_Gerencial/MostraHorarioVago.asp''>Clique aqui e visualize o relatório dos horários vagos dos dentistas</a>'
      ,'Previsão para marcação de consultas',0,null
      From Emails

      Insert Into EMAILS (cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)      
      Select Max(cd_sequencial)+1,'lucimar.lima@absonline.com.br',
      '<font size=1><a href=''http://intra.absonline.com.br/modulos/ABS_Gerencial/MostraHorarioVago.asp''>Clique aqui e visualize o relatório dos horários vagos dos dentistas</a>'
      ,'Previsão para marcação de consultas',0,null
      From Emails

      Insert Into EMAILS (cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)      
      Select Max(cd_sequencial)+1,'fernanda.mara@absonline.com.br',
      '<font size=1><a href=''http://intra.absonline.com.br/modulos/ABS_Gerencial/MostraHorarioVago.asp''>Clique aqui e visualize o relatório dos horários vagos dos dentistas</a>'
      ,'Previsão para marcação de consultas',0,null
      From Emails

     /* Email para a Assis */
      Insert Into EMAILS (cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)      
      Select Max(cd_sequencial)+1,'assis.junior@absonline.com.br',
      '<font size=1><a href=''http://intra.absonline.com.br/modulos/ABS_Gerencial/MostraHorarioVago.asp?usuario=1''>Clique aqui e visualize o relatório dos horários vagos dos dentistas</a>'
      ,'Previsão para marcação de consultas',0,null
      From Emails

     /* Email para a São Luis */
      Insert Into EMAILS (cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)      
      Select Max(cd_sequencial)+1,'adm.saoluis@absonline.com.br',
      '<font size=1><a href=''http://intra.absonline.com.br/modulos/ABS_Gerencial/MostraHorarioVago.asp?usuario=2''>Clique aqui e visualize o relatório dos horários vagos dos dentistas</a>'
      ,'Previsão para marcação de consultas',0,null
      From Emails

     /* Email para a Belem */
      Insert Into EMAILS (cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)      
      Select Max(cd_sequencial)+1,'adm.belem@absonline.com.br',
      '<font size=1><a href=''http://intra.absonline.com.br/modulos/ABS_Gerencial/MostraHorarioVago.asp?usuario=3''>Clique aqui e visualize o relatório dos horários vagos dos dentistas</a>'
      ,'Previsão para marcação de consultas',0,null
      From Emails

End
