/****** Object:  Procedure [dbo].[SP_PlanoContinuidade]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_PlanoContinuidade] (@mes varchar(2), @ano varchar(4), @cd_emp int = null, @cd_Ass int = null )    
As     
Begin    
    
Declare @dia int     
Declare @wl_venc date    
Declare @tp int     
    
DECLARE GERA_PlanoContinuidade CURSOR FOR   
select distinct   
  d.cd_associado,   
  isnull(case when a.dia_vencimento=0 then null else a.dia_vencimento end,e.dt_vencimento)    
from dependentes as d inner join historico as h on d.cd_sequencial_historico = h.cd_sequencial     
  inner join associados as a on d.CD_ASSOCIADO = a.cd_associado    
  inner join empresa as e on a.cd_empresa=e.cd_empresa    
where h.cd_situacao=19   
  and convert(varchar(6),isnull(h.dt_fim_atendimento,'12/31/2050'),112) >= @ano+@mes    
  and d.CD_ASSOCIADO not in ( select CD_ASSOCIADO_empresa     
         from mensalidades     
         where TP_ASSOCIADO_EMPRESA = 1   
           and CD_TIPO_RECEBIMENTO not in (1)   
           and cd_tipo_parcela=1    
           and CONVERT(varchar(6),dt_vencimento,112)=@ano+@mes     
         )    
  and d.cd_Associado = isnull(@cd_Ass, d.cd_Associado)    
  and a.cd_empresa = isnull(@cd_emp, a.cd_empresa)    
        
 OPEN GERA_PlanoContinuidade      
 FETCH NEXT FROM GERA_PlanoContinuidade INTO @cd_ass,@dia    
 WHILE (@@FETCH_STATUS <> -1)      
 begin      
    
  print @cd_Ass     
         
 if @mes='02' and @dia>28     
  Set @dia=28    
  print @dia       
  Set @wl_venc = @mes+'/'+convert(varchar(2),@dia)+'/'+@ano    
  print @wl_venc    
    
  Select @tp = isnull(cd_tipo_pagamento,0)   
  from ASSOCIADOS   
  where cd_associado=@cd_ass  
  
  update SITUACAO_HISTORICO set fl_gera_cobranca=1 where CD_SITUACAO_HISTORICO=19    
    
  exec sp_gera_mensalidade @wl_venc, @cd_ass, 3, 0 , 0 , 1     
    
  update mensalidades set TP_ASSOCIADO_EMPRESA=1, CD_TIPO_PAGAMENTO=case when ISNULL(@tp,0)>0 then @tp else CD_TIPO_PAGAMENTO end ,executarTrigger=0 where  CD_ASSOCIADO_empresa=@cd_ass and dt_vencimento=@wl_venc and TP_ASSOCIADO_EMPRESA=2 and CD_TIPO_RECEBIMENTO=0 and cd_tipo_parcela=1     
    
  update SITUACAO_HISTORICO set fl_gera_cobranca=0 where CD_SITUACAO_HISTORICO=19    
    
   --  break     
         
   FETCH NEXT FROM GERA_PlanoContinuidade INTO @cd_ass,@dia    
 End     
 Close GERA_PlanoContinuidade    
 Deallocate GERA_PlanoContinuidade    
    
    
End 
