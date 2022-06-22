/****** Object:  Procedure [dbo].[SP_GeraANS_RPS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_GeraANS_RPS] (@cd_sequencial int = 0, @nosso_numero varchar(17) = null, @isencaoOnus varchar(1) = null)

As

Begin 
	/**
		Ticket 6833: Copiado a procedure da Mogidonto para atualizar os dados quando gerar o lote.
	**/
  Declare @competencia varchar(6)
  Declare @dt_preparacao datetime
  Declare @dt_fechado datetime
  Declare @ind smallint = 0
  Declare @dt_limite date 

  if @cd_sequencial = 0 

  begin
        Select top 1 @cd_sequencial=cd_sequencial from ANS_RPS where dt_fechado is null order by cd_sequencial desc -- Verificar se tem algum arquivo de envio da ANS aberto
        
        if @cd_sequencial = 0
        
        Begin  -- 1

          insert into ANS_RPS(cd_sequencial, dt_preparacao, nossoNumero, isencaoOnus)
          
            select isnull(max(cd_sequencial),0)+1, GETDATE(), @nosso_numero, @isencaoOnus
              from ANS_RPS          

            if @@ROWCOUNT = 0
            begin -- 1.1
              Raiserror('Erro na criação do arquivo da ANS RPS.',16,1)
              RETURN
            end -- 1.1         

            Select top 1 @cd_sequencial=cd_sequencial from ANS_RPS where dt_fechado is null order by cd_sequencial desc  
        End -- 1 

        else

         begin
          Raiserror('Existe arquivo aberto. Verifique se o arquivo foi enviado e feche.',16,1)
          RETURN
        End
  End

  Else -- Veio Sequencial

  Begin 

        Select top 1 @dt_fechado=dt_fechado from ANS_RPS where cd_sequencial = @cd_sequencial -- Verificar se tem algum arquivo de envio da ANS aberto

        if @@ROWCOUNT=0

        Begin  -- 1

              Raiserror('Sequencia l não localizado.',16,1)

              RETURN

        End -- 1 

        

        if @dt_fechado is not null

        Begin  -- 1

              Raiserror('Sequencial fechado não pode ser reprocessado.',16,1)

              RETURN

        End -- 1 


      delete ANS_RPS_Itens where cd_sequencial=@cd_sequencial      

  End
  
  insert ANS_RPS_Itens (cd_sequencial, cd_filial,acao,Prestador,NR_CGC,Cnes,ufid,Cidid,tp_contratacao,nr_ANSinter,cd_dispon_serv,
         data_contrato,Data_Inicio_Vinculo,cd_ind_urgencia)
   Select @cd_sequencial , f.cd_filial, 'I', f.nm_filial, 
          isnull(f.nr_cgc, fu.nr_cpf), 
          f.Cnes,f.ufid, f.cidid, f.tp_contratacao, f.nr_ANSinter, 
          f.cd_dispon_serv, f.dt_contrato, f.dt_iniVinculo, f.cd_ind_urgencia
     from filial as f inner join funcionario as fu on f.cd_funcionario_responsavel = fu.cd_funcionario
    where f.cd_filial not in (select cd_filial from VW_ANS_RPS where acao in ('I','A'))
      and f.fl_ativa=1 and ISNULL(f.fl_cadastroANS, 1) = 1
      
  insert ANS_RPS_Itens (cd_sequencial, cd_filial,acao,Prestador,NR_CGC,Cnes,ufid,Cidid,tp_contratacao,nr_ANSinter,cd_dispon_serv,
         data_contrato,Data_Inicio_Vinculo,cd_ind_urgencia)
   Select @cd_sequencial , f.cd_filial, 'A', f.nm_filial, 
          isnull(f.nr_cgc, fu.nr_cpf), 
          f.Cnes,f.ufid, f.cidid, f.tp_contratacao, f.nr_ANSinter, 
          f.cd_dispon_serv, f.dt_contrato, f.dt_iniVinculo, f.cd_ind_urgencia
     from filial as f inner join funcionario as fu on f.cd_funcionario_responsavel = fu.cd_funcionario
              inner join VW_ANS_RPS as V on f.cd_filial = v.cd_filial 
    where v.acao in ('I','A')
      and f.fl_ativa=1 
      and ISNULL(f.fl_cadastroANS, 1) = 1     
      and (
          isnull(v.ufid,0) <> isnull(f.ufId,0) 
       or isnull(v.Prestador,'') <> isnull(f.nm_filial,'')
       or isnull(v.NR_CGC,'') <> isnull(ISNULL(f.nr_cgc, fu.nr_cpf),'')
       or isnull(v.Cnes,0) <> isnull(f.CNES,0)
       or isnull(v.Cidid,0) <> isnull(f.CidID,0)
       or isnull(v.tp_contratacao,'') <> isnull(f.tp_contratacao,'')
       or isnull(v.nr_ANSinter,0) <> isnull(f.nr_ANSinter,0)
       or isnull(v.cd_dispon_serv,'') <> isnull(f.cd_dispon_serv,'')
       or isnull(v.data_contrato,'01/01/2000') <> isnull(f.dt_contrato,'01/01/2000')
       or isnull(v.Data_Inicio_Vinculo,'01/01/2000') <> isnull(f.dt_iniVinculo,'01/01/2000')
       or isnull(v.cd_ind_urgencia,'') <> isnull(f.cd_ind_urgencia ,'')
          ) 
      
      
   insert ANS_RPS_Itens (cd_sequencial, cd_filial,acao)
   Select @cd_sequencial , f.cd_filial, 'E'
     from filial as f
    where f.cd_filial in (select cd_filial from VW_ANS_RPS where acao in ('I','A'))
      and f.fl_ativa=0 and ISNULL(f.fl_cadastroANS, 1) = 1

   update ANS_RPS
      set qt_reg_inclusao=(select COUNT(0) from ans_rps_itens where cd_sequencial = @cd_sequencial and dt_excluido is null  and acao='I' ),
          qt_reg_alteracao=(select COUNT(0) from ans_rps_itens where cd_sequencial = @cd_sequencial and dt_excluido is null and acao='A'),
          qt_reg_exclusao = (select COUNT(0) from ans_rps_itens where cd_sequencial = @cd_sequencial and dt_excluido is null and acao='E')
    where cd_sequencial=@cd_sequencial 

End
