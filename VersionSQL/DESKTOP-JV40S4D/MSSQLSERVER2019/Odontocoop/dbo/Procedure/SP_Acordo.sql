/****** Object:  Procedure [dbo].[SP_Acordo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Acordo]  
  @cd_Associado_empresa int,   
  @tp_empresa int ,  
  @tipo_pagamento int,   
  --@vl_entrada money, --excluir  
  @vl_parcelas varchar(200),  
  @qtde_parcelas int ,  
  @parcelas_acordo varchar(400), -- Pode vir NULL  
  @dt_vencimento varchar(200), -- Pode vir NULL  
  @cd_funcionario int ,  
  @vl_multa money,  
  @vl_juros money,  
  @vl_desconto money,  
  @chaId int = -1 ,
  @obs varchar(500)
as   
Begin  
  
 Declare @linha varchar(1000)  
 Declare @linha2 varchar(1000)  
 Declare @vl varchar(100)  
 Declare @dt varchar(100)  
  
 --if @vl_entrada=0 and @vl_parcelas=0   
 if isnull(@vl_parcelas,'')=''  
 Begin --1  
   Raiserror('Valor das Parcelas deve ser informado.',16,1)  
   RETURN  
 End --1  
  
 if isnull(@qtde_parcelas,0)=0   
 Begin --2  
   Raiserror('Quantidade de Parcelas nao pode ser zero.',16,1)  
   RETURN  
 End --2  
  
 if isnull(@dt_vencimento,'')=''  
 Begin --3  
   Raiserror('Vencimento inicial deve ser informado.',16,1)  
   RETURN  
 End --3  
  
 Declare @tp_Associado_empresa int  
 Set @tp_Associado_empresa = (case when @tp_empresa in (2,7) then 2 when @tp_empresa in (6) then 3 when @tp_empresa in (11) then 11 else 1 end)  
   
 Begin Transaction  
  
 -- Demais Parcelas  
 declare @i int, @saldo money, @parc money   
 Select @i=1  
  
 --Set @parc = (@vl_parcelas*100)/@qtde_parcelas  
 --Set @parc = convert(int,@parc)  
 --Set @parc = @parc/100  
 --set @saldo=@vl_parcelas-(@parc*@qtde_parcelas)  
  
 --print @saldo  
  
 -- @vl, @dt  
 Declare @pos int  
   
 Begin -- (Acordo)   
 Set @linha = 'insert into acordo (acoDtCadastro, cd_funcionarioCadastro)   
     values (getdate(), ' + convert(varchar(10),@cd_funcionario) + ')'  
     print @linha   
     exec (@linha)  
  
  if @@RowCount<>1  
     Begin --5.1  
      Rollback transaction  
      print @@RowCount  
   Raiserror('Erro no acordo das parcelas. Processo cancelado. Acordo',16,1)  
   RETURN         
     End --5.1  
       
 End --  
   
 Declare @ultimoAcordo int  
   
set @ultimoAcordo = @@IDENTITY  
print 'ultimo acordo'  
print @ultimoAcordo  
   
 While @i<=@qtde_parcelas  
 Begin--4  
   --if @i = @qtde_parcelas and @saldo>0 -- Se o valor for dizima ajustar na ultima parcela  
   --  Set @parc = @parc + @saldo   
  
    --print @parc  
      
    if @i = @qtde_parcelas  
    Begin -- 4.1  
      select @vl=@vl_parcelas, @dt=@dt_vencimento  
    end -- 4.1  
    else  
    begin -- 4.2  
      
      Set @pos = PATINDEX('%,%',@vl_parcelas)  
        
      Set @vl = LEFT(@vl_parcelas,@pos-1)  
      Set @vl_parcelas = SUBSTRING(@vl_parcelas,@pos+1,LEN(@vl_parcelas)-@pos)  
  
      Set @pos = PATINDEX('%,%',@dt_vencimento)  
      Set @dt = LEFT(@dt_vencimento,@pos-1)  
      Set @dt_vencimento = SUBSTRING(@dt_vencimento,@pos+1,LEN(@dt_vencimento)-@pos)  
        
    end -- 4.2   
      
 Set @linha = 'insert mensalidades (CD_ASSOCIADO_empresa,TP_ASSOCIADO_EMPRESA,cd_tipo_parcela,  
    CD_TIPO_PAGAMENTO,CD_TIPO_RECEBIMENTO,DT_VENCIMENTO,DT_GERADO, VL_PARCELA, VL_Acrescimo,VL_Desconto, chaId)  
   values (' + convert(varchar(10),@cd_Associado_empresa) + ', '+  convert(varchar(2),@tp_Associado_empresa) + ', 5 ,' +  
    + convert(varchar(10),@tipo_pagamento) + ', 0 , ''' + @dt + ''', getdate(), '+ @vl + ' , 0,0, ' + case when @chaId > 0 then convert(varchar,@chaId) else 'null' end + ') '  
      
     print @linha  
     exec (@linha)  
       
     if @@RowCount<>1  
     Begin --5.1  
      Rollback transaction  
      print @@RowCount  
   Raiserror('Erro na geração das parcelas. Processo cancelado.',16,1)  
   RETURN         
     End --5.1  
   -- set @dt_primeirovencimento = dateadd(month,1,@dt_primeirovencimento)  
     
 Set @linha2 = 'insert into mensalidadesacordonegociada (acoId, cd_parcela)   
    select ' + convert(varchar(10),@ultimoAcordo) + ' as acoId, cd_parcela  
    from mensalidades  
    where CD_parcela = ' + convert(varchar(10),@@IDENTITY) + ' '  
       
     print @linha2   
     exec (@linha2)  
       
     if @@RowCount<>1  
     Begin --  
      Rollback transaction  
      print @@RowCount  
   Raiserror('Erro na geração das parcelas. Processo cancelado.',16,1)  
   RETURN         
     End --  
  
   Set @i=@i+1     
 End --4  
     
Declare @ultimoMensalidades int  
set @ultimoMensalidades = @@IDENTITY  
print 'ultima mensalidade'   
print @ultimoMensalidades  
  
 -- Acordar Parcelas  
 if isnull(@parcelas_acordo,'')<>''  
 Begin -- 5  
    -- Contar as virgulas para saber qtos registros tem  
    Set @i=dbo.ContaPalavras(',',@parcelas_acordo)+1  
  
    Set @linha = 'update mensalidades   
        set chaId = ' + case when @chaId > 0 then convert(varchar,@chaId) else 'null' end + ', cd_tipo_recebimento=2, dt_baixa=getdate(), cd_usuario_baixa=' + convert(varchar(10),@cd_funcionario) + ', cd_usuario_alteracao=' + convert(varchar(10),@cd_funcionario) + ' ' +  
      'where cd_parcela in (' + @parcelas_acordo + ') and ' +   
          'cd_tipo_recebimento=0 and   
         tp_associado_empresa=' + convert(varchar(2),@tp_Associado_empresa) + ' and ' +   
         'cd_associado_empresa=' + convert(varchar(10),@cd_Associado_empresa)  
  
     print @linha   
     exec (@linha)  
     if @@RowCount<>@i  
     Begin --5.1  
      Rollback transaction  
      print @@RowCount  
      print @i  
   Raiserror('Erro no acordo das parcelas. Processo cancelado.',16,1)  
   RETURN         
     End --5.1  
  
 End --5  
  
if isnull(@parcelas_acordo,'')<>''  
Begin -- 7 (Acordo - Mensalidades Acordadas)   
 Set @linha = 'insert into mensalidadesacordo (acoId, cd_parcela)   
    select ' + convert(varchar(10),@ultimoAcordo) + ' as acoId, cd_parcela   
    from mensalidades  
    where cd_parcela in (' + @parcelas_acordo + ')'  
      
     print @linha   
     exec (@linha)  
  
 if @@RowCount<1  
     Begin --5.1  
      Rollback transaction  
      print @@RowCount  
   Raiserror('Erro no acordo das parcelas. Processo cancelado. Mensalidade Acordada',16,1)  
   RETURN         
     End --5.1  
End --7   
    
 print 'concluido'   
 Commit  
 --rollback   
  
End
