/****** Object:  Procedure [dbo].[SP_NF]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_NF] 
   @dt_ini varchar(10) , @dt_fim varchar(10), @cd_aliquota varchar(1000) = '' , @datas smallint -- 1-Dt_Vencimento,2-Dt_Gerado
as 
Begin

  Set @cd_aliquota = ltrim(rtrim(@cd_aliquota))
  
  if LEN(@cd_aliquota)>0 and RIGHT(@cd_aliquota,1)<>','
  begin
	  Raiserror('Codigos das aliquotas devem terminar com (,).',16,1)
	  RETURN
  End 
  
  Declare @lin varchar(max) 
  --Declare @qtde int = 3 
  Declare @cod varchar(10) 
  Declare @pos int 

  Set @lin = 'select e.CD_EMPRESA , e.NM_FANTASIA, m.cd_parcela , convert(varchar(10),m.dt_vencimento,103) as dt, convert(varchar(10),m.DT_PAGAMENTO,103) as dt_pagamento, m.NF, t.nm_tipo_pagamento , SUM(p.valor_aliquota) total, m.VL_PARCELA, (m.VL_PARCELA- SUM(p.valor_aliquota)) vl_liquido, m.VL_PAGO, (select count(cd_sequencial) from mensalidades_planos where cd_parcela_mensalidade = m.cd_parcela and dt_exclusao is null ) nr_vidas, cc.ds_centro_custo'

  While @cd_aliquota <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_aliquota)
     Set @cod = LEFT(@cd_aliquota,@pos-1)
     Set @cd_aliquota = substring(@cd_aliquota , @pos+1, LEN(@cd_aliquota)-@pos)
     
     --print @pos
     --print @cod 
     --print @cd_aliquota
     --return 
     
     --Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' ,
				(select isnull(sum(valor_aliquota),0)
				   from parcela_aliquota as c1 
				  where c1.cd_parcela = m.cd_parcela and 
						c1.dt_exclusao is null and 
						c1.cd_aliquota ='+ CONVERT(varchar(10),@cod) +  
				  ') col'   + convert(varchar(4), @cod )

  End 

  Set @lin = @lin + '
               from MENSALIDADES as m, parcela_aliquota as p , EMPRESA as e, TIPO_PAGAMENTO as t , Centro_Custo as cc
              where m.CD_PARCELA = p.cd_parcela and 
					e.cd_centro_custo = cc.cd_centro_custo   and
                    m.CD_ASSOCIADO_empresa = e.CD_EMPRESA and    
                    m.CD_TIPO_RECEBIMENTO = t.cd_tipo_pagamento and ' +
                    case when @datas=1 then 'm.DT_VENCIMENTO' else 'm.dt_gerado' end + ' >= '''+ @dt_ini + ''' and ' +
                    case when @datas=1 then 'm.DT_VENCIMENTO' else 'm.dt_gerado' end + '  < ''' + @dt_fim + ' 23:59'' and 
                    p.dt_exclusao is null and 
                   (
                      m.CD_TIPO_RECEBIMENTO not In (1,2) or 
                     (m.CD_TIPO_RECEBIMENTO in (1,2) and nf is not null)
                   ) 
             group by e.CD_EMPRESA , e.NM_FANTASIA, m.cd_parcela , m.dt_vencimento, m.DT_PAGAMENTO, m.NF, t.nm_tipo_pagamento, m.VL_PARCELA , m.VL_PAGO, cc.ds_centro_custo
             order by m.dt_vencimento '

  print @lin

  exec (@lin)
                 

End
