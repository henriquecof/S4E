/****** Object:  Function [dbo].[FF_LinhaDigitavel]    Committed by VersionSQL https://www.versionsql.com ******/

create Function [dbo].[FF_LinhaDigitavel] (@cd_parcela int) 
RETURNS varchar(100)
as 
begin

  Declare @venc varchar(10)
  Declare @valor int
  Declare @nn varchar(20)
  Declare @dv_nn varchar(1)    
  
  Declare @bco varchar(3)
  Declare @agencia varchar(10)
  Declare @digito_agencia varchar(1)
  Declare @convenio varchar(20)
  Declare @digito_convenio varchar(1)
  Declare @campolivre varchar(25)
  Declare @carteira varchar(10)
  Declare @codbarras varchar(100)
  Declare @cta varchar(10)
  
  Declare @linhaDig1 varchar(40)
  Declare @linhaDig2 varchar(40)
  Declare @linhaDig3 varchar(40)
  Declare @linhaDig4 varchar(40)
  Declare @linhaDig5 varchar(40)

  select @valor = vl_parcela ,
         @bco = t.banco , 
         @venc = convert(varchar(10),isnull(m.dt_vencimento_new, m.dt_vencimento),101), 
         @nn = m.NOSSO_NUMERO, 
         @valor = floor((m.VL_PARCELA + isnull(m.VL_Acrescimo,0) - isnull(m.vl_desconto,0) + isnull(m.vl_taxa,0) - isnull((select SUM(valor_aliquota) from parcela_aliquota as p where p.cd_parcela = m.cd_parcela and dt_exclusao is null and id_retido=1),0))*100),
         @convenio = t.convenio ,@digito_convenio = t.dv_convenio, 
         @carteira = t.carteira, 
         @agencia = t.ag, 
         @cta = t.cta 
    from mensalidades as m inner join TIPO_PAGAMENTO as t on m.CD_TIPO_PAGAMENTO = t.cd_tipo_pagamento
   where m.CD_PARCELA = @cd_parcela 
   
  if ISNULL(@bco,'') =''
  begin
     return 'Erro Busca Parcela'   
  end 

  Set @bco = RIGHT('000'+@bco,3)
  
  if len(@carteira)<>3  and @bco in ('033','341') -- Santander e Itau
     return 'Carteira deve ser 3 posições' 

  if len(@carteira)<>2  and @bco in ('1') -- Santander e Itau
     return 'Carteira deve ser 2 posições' 
  
  if convert(int,@bco) = 1 
  Begin

     Set @nn = right('000000000000'+@nn,10)          
     Set @nn = left(convert(varchar(10),@convenio),7) + @nn           
          
     ---***CAMPO LIVRE***************************************          
     Set @CampoLivre = '000000'+@nn+ left(convert(varchar(10),@carteira)+'00',2)          
     Set @CampoLivre = @CampoLivre +  dbo.FS_CalculoModulo11_CNAB240(@CampoLivre,3)          
                          
  
  End

  if convert(int,@bco) = 237 
  Begin

     Set @nn = right('000000000000'+@nn,11)          
          
     ---***CAMPO LIVRE***************************************          
     Set @CampoLivre = RIGHT('00000' + convert(VARCHAR(5), @agencia), 4) + 
                       right('00' + convert(VARCHAR(2), @carteira), 2) +
                       @nn+ 
                       RIGHT('0000000' + convert(VARCHAR(7), @cta), 7) + '0'
  End
  
  
  if @bco = '033' -- Santander
  Begin
     if LEN(@convenio)<>7
        return 'Convenio deve ser 7 posições' 
             
     Set @nn = RIGHT('00000'+@nn,12)
     Set @dv_nn = dbo.FS_CalculoModulo11_Santander(@nn)
    
     Set @CampoLivre = '9' + @convenio + @nn + @dv_nn + '0' + @carteira
     
  End    
  
  if @bco = '341' -- Itau
  Begin

     if LEN(@convenio)<>5
        return 'Convenio deve ser 7 posições' 
     
     if @digito_convenio is null or len(ISNULL(@digito_convenio,0))>1 
        return 'Digito do Convenio deve ter 1 posição' 
     
     if len(@nn)<> 8 
        return 'Nosso numero invalido' 
     
     Set @dv_nn = dbo.FS_CalculoModulo10(@agencia+@convenio+@digito_convenio+@carteira+@nn)        
     Set @CampoLivre = @carteira + @nn + @dv_nn + @agencia + @convenio + @digito_convenio + '000' 
     
  End

  if Len(@CampoLivre)<>25 
     return 'Campo livre invalido' 
          
  Set @codbarras = right('00'+convert(varchar(3),@bco),3)+ '9' + 
      convert(varchar(4),DATEDIFF(day,'10/07/1997',convert(varchar(10),@venc,103))) + -- Fator de Vencimento
	  right('00000000000'+Replace(convert(varchar(12),convert(int,@valor)),'.',''),10) + -- Valor da Parcela 
	  @CampoLivre

  if Len(@codbarras)<>43 
     return 'Linha digitavel invalido' 

	  
    Set @codbarras = left(@codbarras,4) + dbo.FS_DigitoVerificarCodigoBarras(@codbarras) + right(@codbarras,39)
	 
	Set @linhaDig1 = left(@codbarras,4) + left(@CampoLivre,5) 
	Set @linhaDig1 = left(@linhaDig1,5) + '.' + right(@linhaDig1,4) + dbo.FS_CalculoModulo10(@linhaDig1) 
    
	Set @linhaDig2 = substring(@CampoLivre,6,10) 
	Set @linhaDig2 = left(@linhaDig2,5) + '.' + right(@linhaDig2,5) + dbo.FS_CalculoModulo10(@linhaDig2) 

	Set @linhaDig3 = substring(@CampoLivre,16,10) 
	Set @linhaDig3 = left(@linhaDig3,5) + '.' + right(@linhaDig3,5) + dbo.FS_CalculoModulo10(@linhaDig3) 

	Set @linhaDig4 = substring(@codbarras,5,1)

	Set @linhaDig5 = substring(@codbarras,6,14)
	  
    return @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5

End 
