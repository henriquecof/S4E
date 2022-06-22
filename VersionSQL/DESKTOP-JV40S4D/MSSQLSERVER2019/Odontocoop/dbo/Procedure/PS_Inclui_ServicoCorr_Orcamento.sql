/****** Object:  Procedure [dbo].[PS_Inclui_ServicoCorr_Orcamento]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PS_Inclui_ServicoCorr_Orcamento] 
	-- Add the parameters for the stored procedure here
	(@CD_Dependente int,
	 @Cd_filial int)
AS
BEGIN
	
	
  Declare @cd_sequencial_pp int 
  Declare @cd_orcamento int 
  Declare @vl_servico float
  
  Declare @cd_sequencial_corr int	    
  Declare @vl_servico_corr float
  Declare @vl_Final float
 
 --Dados do ultimo orçamento
 Select	 @cd_sequencial_pp = T1.cd_sequencial_pp 
	, @cd_orcamento = T1.cd_orcamento
	, @vl_Final = T1.vl_servico
   from	   orcamento_servico T1
    where	T1.cd_orcamento = (Select  max(cd_orcamento) from orcamento_clinico where cd_sequencial_dep = @CD_Dependente and cd_filial = @Cd_filial )
 
DECLARE cursor_consultas_orcamento CURSOR FOR 
 
  SELECT os.cd_sequencial_pp, os.vl_servico    
  FROM orcamento_servico os where os.cd_orcamento = @cd_orcamento
       
       OPEN cursor_consultas_orcamento
       FETCH NEXT FROM cursor_consultas_orcamento INTO 
             @cd_sequencial_pp, @vl_Final

	   WHILE (@@FETCH_STATUS <> -1)
	   BEGIN  -- 1.0  
	   
------2 Nivel    
		 DECLARE cursor_consultas_corr CURSOR FOR
			  select  corr.cd_sequencial , s.vl_servico_orcamento
			  from Consultas corr, Servico_Correlacionado s
			  where corr.cd_sequencial_pai = @cd_sequencial_pp
			  and	s.cd_servico_aux = corr.CD_SERVICO
			  
	   
			OPEN cursor_consultas_corr
            FETCH NEXT FROM cursor_consultas_corr INTO 
             @cd_sequencial_corr, @vl_servico_corr 

	        WHILE (@@FETCH_STATUS <> -1)
	        BEGIN  -- 1.1  
			  
				INSERT INTO orcamento_servico
				(cd_sequencial_pp ,fl_pp	,cd_orcamento ,vl_servico)
				VALUES
				(@cd_sequencial_corr,1 ,@cd_orcamento,@vl_servico_corr)

			
				set @vl_Final = @vl_Final -   @vl_servico_corr
	   
				UPDATE orcamento_servico
				SET vl_servico = @vl_Final
				WHERE cd_sequencial_pp = @cd_sequencial_pp



	   
	   
			FETCH NEXT FROM cursor_consultas_corr INTO 
                 @cd_sequencial_corr, @vl_servico_corr	
			End -- 1.1 
	    
		Close cursor_consultas_corr
		Deallocate cursor_consultas_corr			 
 ------Fim 2 nivel
	   
        FETCH NEXT FROM cursor_consultas_orcamento INTO 
                 @cd_sequencial_pp, @vl_Final
	    End -- 1.0 
	    
 Close cursor_consultas_orcamento
 Deallocate cursor_consultas_orcamento	
	
	
	
END
