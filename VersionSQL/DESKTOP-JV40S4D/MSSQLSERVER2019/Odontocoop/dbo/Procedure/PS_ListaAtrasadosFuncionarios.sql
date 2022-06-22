/****** Object:  Procedure [dbo].[PS_ListaAtrasadosFuncionarios]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[PS_ListaAtrasadosFuncionarios](@Nome varchar(20),@tipo smallint,@Faixa Smallint, @Filial Int)
as
begin  
  ---Declaracao variaveis
  --Declare @Numero_Maximo_Permitido int  
  Declare @sequencial_atrasados int   
  Declare @codigo int  
  Declare @quantidade_dias_atraso int   
  Declare @situacao_associado Smallint
  Declare @cd_parcela  int  
  Declare @WL_Data varchar(10)
  Declare @WL_Sequencial int
  Declare @valor money
  
   /*Data atual*/
  Set @WL_Data = convert(varchar(10),getdate(),101)

  --transformando a lista atual em lista antiga. Devem ter sobrado os que nao tem status = 0.
  update TB_ListaAtrasadosUsuario set
         lista_atual = 0
   where nome_usuario   = @Nome And
         lista_atual    = 1
          
  --Seleciona os registros de acordo com os dados passados.
  If (@Filial = 1)
     Begin
		 Declare pessoas_Cursor  Cursor For
			Select top 30
				  t1.sequencial_atrasados, t1.codigo, t1.quantidade_dias_atraso, 
				  t1.situacao_associado, t1.cd_parcela, 
                  (Select max(t2.valor) from TB_ParcelasAtrasadas t2
                          where  t1.sequencial_atrasados = t2.sequencial_atrasados)
			From  TB_Atrasados t1 
		   Where   t1.tipo_pessoa = @tipo And
				   t1.faixa_atraso = @Faixa And
				   t1.usado is null 				   
			 order by 6 desc     
     End
   Else
     Begin
       if (@tipo = 1)
          Begin
            Declare pessoas_Cursor  Cursor For

            Select top 30
				  t1.sequencial_atrasados, t1.codigo, t1.quantidade_dias_atraso, 
				  t1.situacao_associado, t1.cd_parcela, 
                  (Select max(t2.valor) from TB_ParcelasAtrasadas t2
                          where  t1.sequencial_atrasados = t2.sequencial_atrasados)
			 From  TB_Atrasados t1 , Associados t3
   		     Where   t1.tipo_pessoa = @tipo And
			   	     t1.faixa_atraso = @Faixa And
				     t1.usado is null And
                     t1.codigo = t3.cd_associado And
                     t3.cd_filial = @Filial 
		     order by 6 desc

          End
       Else
          Begin
           Declare pessoas_Cursor  Cursor For
           Select top 30
				  t1.sequencial_atrasados, t1.codigo, t1.quantidade_dias_atraso, 
				  t1.situacao_associado, t1.cd_parcela, 
                  (Select max(t2.valor) from TB_ParcelasAtrasadas t2
                          where  t1.sequencial_atrasados = t2.sequencial_atrasados)
			 From  TB_Atrasados t1 , Empresa t3
   		     Where   t1.tipo_pessoa = @tipo And
			   	     t1.faixa_atraso = @Faixa And
				     t1.usado is null And
                     t1.codigo = t3.cd_empresa And
                     t3.cd_filial = @Filial 
		     order by 6 desc
			
          End  
     End 
  
  Open pessoas_Cursor
     Fetch next from pessoas_Cursor
     Into @sequencial_atrasados, @codigo, @quantidade_dias_atraso,@situacao_associado, @cd_parcela, @valor

  While (@@fetch_status<>-1)
     Begin
           Begin Transaction
           
          --mensalidade com mensalidade em mais atraso do cliente.
          insert into TB_ListaAtrasadosUsuario 
           (codigo,tipo_pessoa,Faixa_dias_atrasado,dias_atrasado,Situacao_Associado,   
            status,Gerar_Novamente,cd_parcela,nome_usuario,data_gerado,lista_atual,  
            data_vencimento,cd_filial,data_status)
          Values 
            (@codigo,@tipo,@Faixa,@quantidade_dias_atraso,@situacao_associado,
             0,0,@cd_parcela,@Nome,@WL_Data,1,
             null,null,null)

          Select @WL_Sequencial = max(sequencial) from TB_ListaAtrasadosUsuario 

          --Atraso nao cair na lista de outro usuario. 
          Update TB_Atrasados Set Usado = 1 Where  sequencial_atrasados = @sequencial_atrasados

          Insert into TB_ParcelasAtrasadasUsuario
            (CD_Parcela, Data_Vencimento, Dias_Atraso, Sequencial)
          Select CD_Parcela, Data_Vencimento, Dias_Atraso, @WL_Sequencial
 From TB_ParcelasAtrasadas
            Where sequencial_atrasados = @sequencial_atrasados

          Commit Transaction

          Fetch next from pessoas_Cursor
          Into @sequencial_atrasados, @codigo, @quantidade_dias_atraso,@situacao_associado, @cd_parcela,@valor
      End

   CLOSE      pessoas_Cursor
   DEALLOCATE pessoas_Cursor

End        
