/****** Object:  Procedure [dbo].[PS_MostraProcedimentosGlosados]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_MostraProcedimentosGlosados](@datainicial varchar(10),@datafinal varchar(10),@tipo int)
As
Begin

  Declare @codigo int
  Declare @nome varchar(100)
  Declare @quantidade int
  Declare @codigo_aux int

  Create Table [dbo].[#TB_Resultado]
	([codigo] [int] not Null,  
	 [nome] [varchar](100) NOT Null,
	 [quantidade_glosa_total]  [Int] not Null,        
	 [quantidade_glosa_parcial] [Int] not Null     
 )
  
  if @tipo = 0 
   Begin
		   --- glosa parcial - troca de procedimentos.
		   insert into #TB_Resultado
                  (codigo,nome,quantidade_glosa_total,quantidade_glosa_parcial)     
 			Select t1.codigo_antigo_servico, t2.nm_servico,0, count(t1.sequencial_consultasglosados)
			 From  TB_consultasglosados t1, servico t2, consultas t3
			 Where t2.cd_servico    = t1.codigo_antigo_servico and
				   t1.cd_sequencial = t3.cd_sequencial and 
				   t3.dt_servico between @datainicial and @datafinal  and
                   t3.dt_cancelamento is null     
			 Group by t1.codigo_antigo_servico, t2.nm_servico
		            		   
			--glosa total
		   insert into #TB_Resultado
                  (codigo,nome,quantidade_glosa_total,quantidade_glosa_parcial)     
 					Select t3.cd_servico, t2.nm_servico, count(t1.cd_sequencial),0
			 From  TB_consultasglosados t1, servico t2, consultas t3
			 Where t1.codigo_antigo_servico is null And
				   t1.cd_sequencial = t3.cd_sequencial and
				   t3.cd_servico = t2.cd_servico AND
                   t3.dt_servico between @datainicial and @datafinal  and
                   t3.dt_cancelamento is null     
			 Group by t3.cd_servico, t2.nm_servico                
			 Order by 3 desc

    End

  Else

    Begin
		 
		   --- glosa parcial - troca de procedimentos.
		   insert into #TB_Resultado
                  (codigo,nome,quantidade_glosa_total,quantidade_glosa_parcial)     
			Select t3.cd_funcionario, t4.nm_empregado, 0, count(t1.sequencial_consultasglosados)
			 From  TB_consultasglosados t1, consultas t3, funcionario t4
			 Where t1.codigo_antigo_servico is not null and
				   t1.cd_sequencial = t3.cd_sequencial and
                   t3.cd_funcionario = t4.cd_funcionario and 
				   t3.dt_servico between @datainicial and @datafinal and
                   t3.dt_cancelamento is null            
			 Group by t3.cd_funcionario, t4.nm_empregado
           --  union all
            
			--glosa total
		    insert into #TB_Resultado
                  (codigo,nome,quantidade_glosa_total,quantidade_glosa_parcial)     
		    Select t3.cd_funcionario, t4.nm_empregado, count(t1.sequencial_consultasglosados), 0
			 From  TB_consultasglosados t1, consultas t3, funcionario t4
			 Where t1.codigo_antigo_servico is null and
				   t1.cd_sequencial = t3.cd_sequencial and
                   t3.cd_funcionario = t4.cd_funcionario and 
				   t3.dt_servico between @datainicial and @datafinal and
                   t3.dt_cancelamento is null            
			 Group by t3.cd_funcionario, t4.nm_empregado
  End

  Select codigo, nome , sum(quantidade_glosa_total)  as quantidade_glosa_total, sum(quantidade_glosa_parcial) as quantidade_glosa_parcial, sum(quantidade_glosa_total) + sum(quantidade_glosa_parcial) as total
   from #TB_Resultado
   group by codigo, nome
   order by 5 desc

  Drop table #TB_Resultado

End 
