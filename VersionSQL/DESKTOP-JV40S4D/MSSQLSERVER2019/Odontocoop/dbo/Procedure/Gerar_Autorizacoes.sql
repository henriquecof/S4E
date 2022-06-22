/****** Object:  Procedure [dbo].[Gerar_Autorizacoes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.Gerar_Autorizacoes AS

DECLARE @max1 char(6)
DECLARE @min char(6)
DECLARE @min2 char(6)
DECLARE @cd_filial int
DECLARE @resultado char(6)



DECLARE gera_cur  cursor for

	SELECT  f.cd_filial,count(nr_autorizacao) as max1
	FROM autorizacao_Atendimento as a  --autorizacao_atendimento as a, filial as f
	left join FILIAL as f on a.cd_filial = f.cd_filial
	WHERE a.cd_filial = f.cd_filial and dt_solicitacao is null and f.cd_clinica in (1,4,5)
	GROUP BY f.cd_filial, f.nm_filial
	HAVING count(nr_autorizacao)<10000
	ORDER BY max1
OPEN gera_cur
FETCH next from gera_cur into @cd_filial,@max1
 	WHILE (@@fetch_status  <> -1)
	begin

			SELECT @resultado=max(nr_autorizacao)  from autorizacao_atendimento

			SELECT @min=MIN(nr_autorizacao) 
			FROM autorizacao_Atendimento_AUX
			WHERE nr_autorizacao > @resultado

			IF (convert(int,substring(@min,3,1)) %  2 = 0)
			begin		
				set @min2= substring(@min,1,2) + CONVERT(CHAR(1),(convert(int,substring(@min,3,1))+1)) + 'Z9Z'
			end	
			else
			begin	
				set @min2= substring(@min,1,3) +  'Z9Z'
			end

			insert into dbo.autorizacao_Atendimento(nr_autorizacao,cd_filial)
			select nr_autorizacao,@cd_filial
			from dbo.autorizacao_Atendimento_AUX
			where nr_autorizacao >= @min and nr_autorizacao <= @min2

	 fetch next from gera_cur into @cd_filial, @max1
	end

CLOSE gera_cur
DEALLOCATE gera_cur
