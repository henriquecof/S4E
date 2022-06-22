/****** Object:  Procedure [dbo].[PS_CriaArquivoTipo1Plaza]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_CriaArquivoTipo1Plaza]
AS
Begin   
       Declare @Sequencial Int
       Declare @cdass int
       Declare @nome varchar(100)
       Declare @quantidade int
       Declare @Mensagem varchar(1000)

       DECLARE cursor_v CURSOR FOR 
         select servicos_opcionais.cd_associado, nm_dependente, count(*)
           from servicos_opcionais , dependentes 
           where cd_sop = 14 
                 and dependentes.cd_situacao              = 1
                 and servicos_opcionais.cd_situacao       = 1
                 and servicos_opcionais.cd_associado      = dependentes .cd_associado       
                 and servicos_opcionais.cd_sequencial_dep = dependentes .cd_sequencial
           group by servicos_opcionais.cd_associado, servicos_opcionais.cd_sequencial_dep,nm_dependente
           having count(*) >= 2
           order by 3

       OPEN cursor_v
          FETCH NEXT FROM cursor_v INTO @cdass,@nome,@quantidade

       WHILE (@@FETCH_STATUS <> -1)
         BEGIN
           Close cursor_h  
           DEALLOCATE cursor_h  
           Rollback Transaction
           Set @Mensagem  = 'Nao pode ser feito arquivo, pois existe associado cadastrado mais de uma vez para o plano PLAZA. Associado : ' + @nome + ', codigo : ' + convert(varchar(20),@cdass) + ' , quantidade de vezes cadastrado :' + convert(varchar(20),@quantidade)
           RAISERROR (@Mensagem, 16, 1)
           Return             
         End
       Close cursor_h  
       DEALLOCATE cursor_h  


       Set @Sequencial = 0
       Select @Sequencial = IsNull(Max(CD_Sequencial),0) 
          From TB_ABS_PLAZA_HEADER
          Where dt_envio is null  

       If @Sequencial = 0
          Begin 
             Insert into TB_ABS_PLAZA_HEADER (cd_sequencial,dt_geracao)
             select IsNull(Max(CD_Sequencial)+1,1) , getdate() from TB_ABS_PLAZA_HEADER

             Select @Sequencial = Max(CD_Sequencial) 
             From TB_ABS_PLAZA_HEADER
          End                     
       Else
          Begin 
            Delete From TB_ABS_PLAZA  
              Where cd_sequencial_header = @Sequencial
          End               
       
        Insert into TB_ABS_PLAZA  
	    Select distinct T1.cd_associado,  T3.CD_Sequencial, T3.NM_Dependente,
		   case when t3.cd_sequencial =1 then T4.NR_Cpf else '' end As NR_Cpf, 
		   case when t3.cd_sequencial =1 then T4.NR_identidade else '' end As NR_Identidade, 
		   T4.Nm_endereco NM_Endereco, 
		   T4.Nm_bairro NM_Bairro, 
		   T6.NM_Municipio NM_Municipio, 
		   T7.CD_Uf NM_Uf, 
		   T4.NR_Cep NR_Cep, 
                   case when t1.DT_inicio< '10/01/2007' then convert(datetime,'10/'+convert(varchar(2),day(dt_inicio))+'/2007') else t1.DT_inicio end ,
		   T3.DT_Nascimento, T5.NM_RAZSOC as NM_RAZSOC, t3.fl_Sexo, T5.CD_Empresa ,
                   @Sequencial               
	     From  Servicos_Opcionais T1, Dependentes T3, Associados T4, Empresa T5 , 
                   Municipio T6, UF T7
   	    Where  T1.CD_SOP = 14 And T1.cd_situacao In (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) And
                   T3.cd_situacao In (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) And
                   T4.cd_situacao In (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) And
		           T1.CD_Associado = T3.CD_Associado And  
		           T1.CD_Sequencial_Dep = T3.CD_Sequencial And 
                   T3.CD_Associado = T4.CD_Associado And
                   T4.CD_Empresa = T5.CD_Empresa     and 
  		           T4.CD_Municipio = T6.CD_Municipio And
		           T4.CD_Uf        = T7.CD_Uf_Num    and
                   T1.cd_situacao   = 1 and
                   T3.cd_situacao   = 1
--And
--                   t4.cd_empresa in (101171,101168,101175,101172,101174,101232,101169,101170,101231,100522,
--100983,100730,100789,101347,101080,101073,101074,101075,101076,101078,101079,100926,18814,
--100937,100797,100205,26758,100760,100755,100868,3369,100190,3363,32184,100215,100417,32216,
--100648,100621,24136,100337,7209,101020, 101021, 15481, 100441, 100188, 100369, 100223, 4230,
--100490, 100647, 100515, 100071, 100069, 100587, 13546, 100092, 18914, 100563, 100813, 16488
--)

	    Order By 1      
End
