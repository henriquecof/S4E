/****** Object:  Function [dbo].[FS_RetornaMensalidadesNFAtrasoPJ]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaMensalidadesNFAtrasoPJ](@codigo int)
Returns Varchar(max)
As
Begin

Declare @retorno varchar(max)
Declare @datavencimento varchar(10)
Declare @valor varchar(20)
Declare @nf varchar(90)

Set @retorno = ''
  
Declare cursor_parcelasatraso CURSOR FOR

select convert(varchar(10),dt_vencimento,103), dbo.moeda(vl_parcela), case when TP_ASSOCIADO_EMPRESA = 1 then '' else 'NF: ' + isnull(convert(varchar(90),NF),'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;') end 
from mensalidades 
where cd_associado_empresa =  @codigo
and TP_ASSOCIADO_EMPRESA = 2
and cd_tipo_recebimento = 0
and dt_vencimento < getdate()

open cursor_parcelasatraso
   fetch next from cursor_parcelasatraso into @datavencimento, @valor, @nf
   
  
   while (@@fetch_status<>-1)
   begin
   
    if @retorno = ''
		--Set @retorno = @retorno + '<table class=''TableFaturasVencidas''><tr><td align=''center''><b>Venc</b></td><td align=''center''>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td align=''center''><b>Valor</b></td><td>&nbsp;</td></tr>'
		Set @retorno = @retorno + '<table class=''TableFaturasVencidas''><tr><td align=''center''><b>Nota Fiscal</b></td><td align=''center''>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td align=''center''><b>Vencimento</b></td><td align=''center''>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td align=''center''><b>Total a Pagar</b></td></tr>'


		Set @retorno = @retorno + '<tr>'
								+ '<td align=''center''>' + @nf + '</td>'
								+ '<td align=''center''>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>'
								+ '<td align=''center''>' + @datavencimento + '</td>'
								+ '<td align=''center''>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>'
								+ '<td align=''left''>R$ ' +  @valor + '</td>'
								+ '</tr>'


   fetch next from cursor_parcelasatraso into @datavencimento, @valor, @nf
   
   Set @retorno = @retorno + '</table>'
   End 
   Close cursor_parcelasatraso
   Deallocate cursor_parcelasatraso
   

Return @retorno  

End
