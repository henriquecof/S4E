/****** Object:  Function [dbo].[FS_RetornaMensalidadesPlanoAtraso]    Committed by VersionSQL https://www.versionsql.com ******/

/******************************************************************************************
 Observar se a função existe, caso exista usar o Alter, se nao existir usar Create
 ******************************************************************************************/
CREATE Function [dbo].[FS_RetornaMensalidadesPlanoAtraso](@codigo int, @tp_associadoempresa int)
Returns Varchar(max)
As
Begin

Declare @retorno varchar(max)
Declare @datavencimento varchar(10)
Declare @valor varchar(20)
Declare @nf varchar(90)

Set @retorno = ''
  
Declare cursor_parcelasatraso CURSOR FOR

select convert(varchar(10),dt_vencimento,103), dbo.moeda(vl_parcela), case when TP_ASSOCIADO_EMPRESA = 1 then '' else '&nbsp;&nbsp;&nbsp;&nbsp;NF: ' + isnull(convert(varchar(90),NF),'') end 
from mensalidades 
where cd_associado_empresa =  @codigo
and TP_ASSOCIADO_EMPRESA = @tp_associadoempresa
and cd_tipo_recebimento = 0
and dt_vencimento < getdate()

open cursor_parcelasatraso
   fetch next from cursor_parcelasatraso into @datavencimento, @valor, @nf
   
  
   while (@@fetch_status<>-1)
   begin
   
    if @retorno = ''
		Set @retorno = @retorno + '<table class=''TableFaturasVencidas''><tr><td align=''center''><b>Venc</b></td><td align=''center''>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td align=''center''><b>Valor</b></td></tr>'


		Set @retorno = @retorno + '<tr>'
								+ '<td align=''center''>' + @datavencimento + '</td>'
								+ '<td align=''center''>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>'
								+ '<td align=''left''>R$ ' +  @valor + @nf + '</td>'
								+ '</tr>'


   fetch next from cursor_parcelasatraso into @datavencimento, @valor, @nf
   
   Set @retorno = @retorno + '</table>'
   End 
   Close cursor_parcelasatraso
   Deallocate cursor_parcelasatraso
   

Return @retorno  

End
/***************************************************************************************/
