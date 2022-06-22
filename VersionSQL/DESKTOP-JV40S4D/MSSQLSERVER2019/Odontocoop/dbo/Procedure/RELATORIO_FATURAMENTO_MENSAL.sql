/****** Object:  Procedure [dbo].[RELATORIO_FATURAMENTO_MENSAL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[RELATORIO_FATURAMENTO_MENSAL] (@dti DATE, @dtf DATE, @centro_custo varchar(max), @empresa int, @situacaoMensalidade int) AS
BEGIN

Declare @SQL varchar(max)
Declare @SQL1 varchar(max)

Declare @dt date 
Declare @dtultdiames date 
Declare @i int


Set @SQL = ' select m.cd_Associado_empresa , a.nm_completo , a.dt_assinatura_contrato, MAX(m.vl_parcela) as Mens, d.nr_carteira, pl.nm_plano, sh.nm_situacao_historico, convert(varchar(10), h.dt_situacao, 103) as dt_situacao, convert(varchar(10), a.dt_assinatura_contrato,103) as assinatura '

Set @dt = @dti

set @i = 1
While @dt <= @dtf
Begin
   Set @dtultdiames = convert(varchar, right('00' + convert(varchar,month(@dt)),2)) + '/' + convert(varchar,dbo.FF_UltimoDiaMes(MONTH(@dt), YEAR(@dt))) + '/' +  convert(varchar, year(@dt))-- Ajustar para pegar o Ultimo Dia do Mes 
   Set @SQL = @SQL + 
     ', isnull((select sum(vl_pago) 
         from mensalidades as MM1 
        where MM1.cd_associado_empresa = m.cd_Associado_empresa
          and mm1.tp_Associado_empresa = 1 
          and mm1.dt_vencimento >=''' + convert(varchar(10),@dt) + ''' 
          and mm1.dt_vencimento<=''' + convert(varchar(50),@dtultdiames) + ' 23:58'''
     
    if @situacaoMensalidade = 1
	begin
		 set @SQL = @SQL + ' and mm1.dt_vencimento < convert(varchar(10),getdate(),101)'
	end  
	
	if @situacaoMensalidade = 2
	begin
		 set @SQL = @SQL + ' and mm1.dt_vencimento >= convert(varchar(10),getdate(),101)'
	end  
        
    Set @SQL = @SQL +   ' ),0) '
    
    Set @dt = dateadd(Day,1,@dtultdiames)
	set @i = @i + 1
End 

Set @SQL1 = '
  from mensalidades as m inner join associados as a on m.cd_associado_empresa = a.cd_associado and m.tp_associado_empresa=1
        inner join dependentes as d on a.cd_associado = d.CD_ASSOCIADO and d.CD_GRAU_PARENTESCO = 1 
        inner join empresa as e on a.cd_empresa = e.cd_empresa 
        inner join planos as pl on d.cd_plano = pl.cd_plano 
        inner join historico as h on h.cd_sequencial = d.cd_sequencial_historico 
        inner join situacao_historico as sh on sh.cd_situacao_historico = h.cd_situacao '
  
  Set @SQL1 = @SQL1 + ' where m.dt_vencimento >=''' + convert(varchar(10),@dti) + ''' and m.dt_vencimento<=''' + convert(varchar(50),@dtf) + ' 23:58'' '
  
  if @situacaoMensalidade = 1
  begin
	 set @SQL1 = @SQL1 + ' and m.dt_vencimento < convert(varchar(10),getdate(),101)'
  end  
  if @situacaoMensalidade = 2
  begin
	 set @SQL1 = @SQL1 + ' and m.dt_vencimento >= convert(varchar(10),getdate(),101)'
  end 
  
  set @SQL1 = @SQL1 + ' and m.CD_TIPO_RECEBIMENTO not in (1,2)'
  
  if @centro_custo <> ''
	set @SQL1 = @SQL1 + ' and e.cd_centro_custo in (' + CONVERT(varchar, @centro_custo) + ')'
  
  if @empresa>0
	set @SQL1 = @SQL1 + ' and e.cd_empresa = '	+ CONVERT(varchar, @empresa)
  
  Set @SQL1 = @SQL1 + ' group by m.cd_Associado_empresa , a.nm_completo, a.dt_assinatura_contrato ,d.nr_carteira, pl.nm_plano, sh.nm_situacao_historico, h.dt_situacao, a.dt_assinatura_contrato '
  Set @SQL1 = @SQL1 + ' order by 2  '


Print @SQL + @SQL1

exec (@SQL + @SQL1)

END
