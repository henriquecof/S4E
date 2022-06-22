/****** Object:  Procedure [dbo].[PS_DadosOperadoresSac]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_DadosOperadoresSac](@dt_i varchar(10),@dt_f varchar(10))
As
Begin
-- Operadoras do SAC
select a.cd_usuario , nm_empregado, count(0) as 'Quantidade', 
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=1 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'Aldeota',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=980 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'Spazio',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=1004 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'Planeta',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=1049 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'OdontoEx',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=1048 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'OdontoWay',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=24472 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'Casa Blanca',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=5198 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'Ceneged',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=935 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'ACS',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=24255 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'Apeoc',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=24507 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'Iguatemi',

( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=264 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'Teresina',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=200 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'Natal',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=3 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'SL-S.Crist',
( select count(0) from agenda as a1  , atuacao_dentista as t1 , associados as s1
   where a1.cd_sequencial_atuacao_dent = t1.cd_sequencial and a1.dt_marcado >= @dt_i and 
         a1.cd_Associado = s1.cd_Associado and -- s1.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
         a1.dt_marcado <= @dt_f and a1.cd_filial=1010 and a.cd_usuario=a1.cd_usuario and t1.cd_especialidade in (1,2,12)) as 'SL-Cohab'
 
from agenda as a , atuacao_dentista as t, funcionario as f , associados as s --, empresa as e 
where a.cd_sequencial_atuacao_dent = t.cd_sequencial and a.dt_marcado >= @dt_i and a.dt_marcado <= @dt_f and 
      a.cd_filial in (1,980,1004,1049,1048,935,24472,24255,5198,24507,264,200,3,1010) and 
      a.cd_usuario = f.cd_funcionario and f.cd_cargo not in (30,32) and 
      a.cd_Associado = s.cd_Associado and --s.cd_empresa = e.cd_empresa and 
      -- s.cd_empresa in (100919,100683,101831,101830,101829,101592,101960,101725,101828,101831,101830,101039,102083) and 
      t.cd_especialidade in (1,2,12) 
group by a.cd_usuario, f.nm_empregado
order by 3 desc, f.nm_empregado

End
