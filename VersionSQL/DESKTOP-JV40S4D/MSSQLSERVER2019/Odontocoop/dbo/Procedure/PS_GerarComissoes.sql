/****** Object:  Procedure [dbo].[PS_GerarComissoes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_GerarComissoes]
As
Begin

Declare @cdassociado int
Declare @cdsequencialdep int
Declare @adesao smallint
Declare @cdsequencialsop int
Declare @operacao smallint
Declare @cdsequencial int
Declare @valor money
declare @retorno varchar(1000) = ''
--return 

--------------------------------------------------
-- Gerar comissao 
-------------------------------------------------

   Declare cursor_aux Cursor For
     Select cd_sequencial, cd_sequencial_dep,adesao, operacao, valor
       From tb_comissaovendedoroperacao
       Where Data_Operacao is null -- and cd_sequencial_dep=310539816    

-- Operação : 1 - Incluir , 2 - Alterar, 3- Excluir

   OPEN cursor_aux
   FETCH NEXT FROM cursor_aux INTO @cdsequencial, @cdsequencialdep,@adesao,@operacao,@valor

   -- Inicio do Loop.
   WHILE (@@FETCH_STATUS <> -1)
   BEGIN
       exec SP_Inclui_Comissao2 @cdsequencialdep,@valor,@adesao,@operacao , @retorno OUTPUT
       if @retorno = ''           
          Update tb_comissaovendedoroperacao set data_operacao = getdate() where cd_sequencial = @cdsequencial        
       else
       begin
          print 'sair do laco'
          break   
       end
       FETCH NEXT FROM cursor_aux INTO @cdsequencial, @cdsequencialdep,@adesao,@operacao,@valor
   END
   Close cursor_aux
   DEALLOCATE cursor_aux
   

--------------------------------------------------
-- Gerar Adesao 
-------------------------------------------------

   Declare cursor_aux Cursor For
     Select a.cd_associado, p.cd_sequencial_dep
       From tb_operacao_pre as p, dependentes as d, associados as a
       Where p.dt_operacao is null and 
             p.cd_sequencial_dep = d.cd_sequencial and  
             d.cd_associado = a.cd_Associado 

-- Operação : 1 - Incluir , 2 - Alterar, 3- Excluir

   OPEN cursor_aux
   FETCH NEXT FROM cursor_aux INTO @cdassociado,@cdsequencialdep

   -- Inicio do Loop.
   WHILE (@@FETCH_STATUS <> -1)
   BEGIN
       exec SP_GeraAdesao_XX @cdassociado, @cdsequencialdep , -1, -1, @retorno OUTPUT 
       if @retorno = ''           
          Update tb_operacao_pre set dt_operacao = getdate() where cd_sequencial_dep = @cdsequencialdep        
       else
       begin
          print 'sair do laco'
          break   
       end
       FETCH NEXT FROM cursor_aux INTO @cdassociado,@cdsequencialdep
   END
   Close cursor_aux
   DEALLOCATE cursor_aux
      

End
