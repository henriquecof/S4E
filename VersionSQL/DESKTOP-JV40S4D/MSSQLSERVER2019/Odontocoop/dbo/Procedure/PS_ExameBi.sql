/****** Object:  Procedure [dbo].[PS_ExameBi]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_ExameBi]
AS
Begin 

  delete S4EBI..exames 

  insert into S4EBI..exames (cd_sequencial, cd_Associado, cd_sequencial_dep , cd_filial , cd_funcionario, dt_servico, qtde)
  select t1.cd_sequencial, t2.cd_Associado, t1.cd_sequencial_dep , t1.cd_filial , t1.cd_funcionario, t1.dt_servico, 
   (select count(0)
      from consultas as c1
     where t1.cd_sequencial = c1.cd_sequencial_Exame and 
           --c1.cd_servico not in (100,130,490,495,500) and 
           c1.cd_servico not in (81000065,80000130,80000490,80000495,80000500) 
           --and c1.cd_funcionario != 11102407 and 
           --c1.cd_filial != 657   
   )
   from consultas t1, dependentes t2
  where t1.cd_servico in (81000065,80000130) and 
        t1.dt_servico >= dateadd(day, -360, getdate()) and 
        t1.dt_cancelamento is null and 
        --cd_Associado is not null and 
        t1.cd_sequencial_dep is not null and 
        t1.cd_sequencial_dep = t2.cd_sequencial and 
        t1.cd_filial is not null and  
        t1.cd_funcionario is not null 
 group by t1.cd_sequencial, t2.cd_Associado, t1.cd_sequencial_dep , t1.cd_filial , t1.cd_funcionario, t1.dt_servico

 delete S4EBI..exames where qtde=0
 
End 
