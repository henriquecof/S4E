/****** Object:  Procedure [dbo].[SP_Importar_PlanoServico]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Importar_PlanoServico] 
	-- Add the parameters for the stored procedure here 
 @cd_planoOrigem smallint, 
 @cd_planoDestino smallint 

	
AS
BEGIN
	delete PLANO_SERVICO where cd_plano = @cd_planoDestino
              
  insert into PLANO_SERVICO (cd_plano, cd_servico, id_coparticipacao, qt_diascarencia)
  select @cd_planoDestino, cd_servico, id_coparticipacao, qt_diascarencia
    From PLANO_SERVICO 
   where cd_plano = @cd_planoOrigem
END
