/****** Object:  Procedure [dbo].[PS_CriaProcedimentosGlosadosDentistas]    Committed by VersionSQL https://www.versionsql.com ******/

Create procedure [dbo].[PS_CriaProcedimentosGlosadosDentistas]
As
Begin

           Delete From abs_bi..Procedimentos_Glosados
  
		   --- glosa parcial - troca de procedimentos.
		   insert into abs_bi..Procedimentos_Glosados
                  (cd_funcionario,quantidade_glosa_total,quantidade_glosa_parcial)     
			Select t3.cd_funcionario,  0, count(t1.sequencial_consultasglosados)
			 From  TB_consultasglosados t1, consultas t3
			 Where t1.codigo_antigo_servico is not null and
				   t1.cd_sequencial = t3.cd_sequencial and
                   t3.dt_cancelamento is null            
			 Group by t3.cd_funcionario
                      
			--glosa total
		    insert into abs_bi..Procedimentos_Glosados
                  (cd_funcionario,quantidade_glosa_total,quantidade_glosa_parcial)     
		    Select t3.cd_funcionario, count(t1.sequencial_consultasglosados), 0
			 From  TB_consultasglosados t1, consultas t3
			 Where t1.codigo_antigo_servico is null and
				   t1.cd_sequencial = t3.cd_sequencial and
             	   t3.dt_cancelamento is null            
			 Group by t3.cd_funcionario
End
