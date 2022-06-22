/****** Object:  Procedure [dbo].[SP_faturamento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_faturamento]
    @dt_inicio varchar(10),
    @dt_fim varchar(10), 
    @cd_centro_custo int,
    @cd_fp int ,
    @tp_empresa int,
    
    @grupo int = 0 ,
    @grupo_analise int = 0,
    @depid int =0,
    @cd_equipe int =0 ,
    @cd_func_vend int =0 
 
AS
begin

declare @Valor money
declare @Qtde money
declare @Tp_pagamento money
declare @vl_atrasados money

Declare @tp smallint
Declare @fp smallint

Declare @SQL varchar(max)

   
------------------------ INICIALIZANDO TABELA ------------------------------------------------------------------------

print 'limpar tabela'
Delete Atrasados

print 'insert tabela'
  Set @SQL = ''
  
  Set @SQL = @SQL + '
insert into Atrasados
select p.cd_tipo_pagamento, t.tp_associado_empresa , tp.cd_tipo_parcela  ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  from tipo_pagamento as p, tipo_associado_empresa as t, tipo_parcela as tp
 WHERE t.tp_associado_empresa <= 2 '
 
 if @cd_fp>0
   Set @SQL = @SQL + ' and CD_TIPO_PAGaMENTO = ' + convert(varchar(10),@cd_fp)
 exec(@SQL)  

------------------------ FaturadoValor e FaturadoQtde ------------------------------------------------------------------

print 'Faturado'
  Set @SQL = ''
  
  Set @SQL += '
   DECLARE cursor_atrasado CURSOR FOR 
   SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela, 
          Sum(IsNull(m.VL_PARCELA + isnull(vl_acrescimo,0) - isnull(vl_desconto,0) - isnull(vl_imposto,0) ,0)),count(0)
     FROM mensalidades as m , associados as a, empresa as e, ATRASADOS as t 
    WHERE m.cd_associado_Empresa = a.cd_associado and 
          m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
          m.tp_Associado_empresa = t.tp_Associado_empresa and 
          m.cd_tipo_parcela = t.cd_tipo_parcela and 
          a.cd_empresa = e.cd_empresa and 
          m.cd_tipo_recebimento not in (1) and 
          m.tp_associado_empresa = 1 and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)>= '''+@dt_inicio+''' and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)<= '''+@dt_fim+''' '
     
      if @cd_centro_custo > 0 
       begin 
          Set @SQL += ' and e.cd_centro_custo = '+convert(varchar(10),@cd_centro_custo )
       end
       
      if @tp_empresa > 0
       begin      
          Set @SQL += ' and e.tp_empresa ='+convert(varchar(10),@tp_empresa )
       end
      
      if @grupo > 0 
       begin  
         Set @SQL += ' and e.cd_grupo ='+convert(varchar(10),@grupo )
       end
       
      if @grupo_analise > 0 
       begin
         Set @SQL +=' and e.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
       end 
       
       if @depid>0 or @depid=-99
     begin
		if @depid=-99
		 Set @SQL +=' and a.depid is not null '
		else
		 Set @SQL +=' and a.depid ='+convert(varchar(10),@depid)
     end 
     
     if @cd_equipe>0
		begin
		    Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, dependentes t4 '
            Set @SQL +='             where t4.cd_sequencial = t2.cd_sequencial_dep '
            Set @SQL +='             and t2.cd_sequencial_lote = t3.cd_sequencial '
            Set @SQL +='             and a.cd_associado = t4.cd_associado '
			Set @SQL +='             and t3.cd_equipe = ' +convert(varchar(10),@cd_equipe) 
            Set @SQL +='           ) + '
            Set @SQL +='           (select COUNT(0) from funcionario f inner join dependentes d on d.cd_funcionario_vendedor = f.cd_funcionario where d.cd_associado = a.cd_associado and f.cd_equipe = ' +convert(varchar(10),@cd_equipe) + ')) > 0 '
		end
       
		if @cd_func_vend >0
		begin
			set @SQL +=' and (select count(0) from dependentes t4 where a.cd_associado = t4.cd_associado and t4.cd_funcionario_vendedor = ' +convert(varchar(10),@cd_func_vend) + ') >0 '
		end

       
            
    Set @SQL += ' GROUP BY  m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela '
    
    Set @SQL += ' union '
    Set @SQL += ' 
     SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela, 
          Sum(IsNull(m.VL_PARCELA + isnull(vl_acrescimo,0) - isnull(vl_desconto,0) - isnull(vl_imposto,0) ,0)),count(0)
     FROM mensalidades as m , empresa as e, ATRASADOS as t 
    WHERE m.cd_associado_Empresa = e.cd_empresa and 
          m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
          m.tp_Associado_empresa = t.tp_Associado_empresa and 
          m.cd_tipo_parcela = t.cd_tipo_parcela and 
          m.cd_tipo_recebimento not in (1) and 
          m.tp_associado_empresa = 2 and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)>= '''+@dt_inicio+''' and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)<= '''+@dt_fim+''' ' 
      
      if  @cd_centro_custo > 0       
       begin
        Set @SQL += ' and e.cd_centro_custo = '+convert(varchar(10),@cd_centro_custo )
       end
          
      if @tp_empresa > 0    
       begin 
          Set @SQL += ' and e.tp_empresa ='+convert(varchar(10),@tp_empresa )
       end
          
      if @grupo > 0 
        begin
         Set @SQL += ' and e.cd_grupo ='+convert(varchar(10),@grupo )
        end
         
      if @grupo_analise > 0 
       begin
         Set @SQL += ' and e.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
       end  
       
       if @depid>0 or @depid = -99
     begin
         Set @SQL +=' and m.cd_parcela = -1'
     end
     
     if @cd_equipe>0
         begin
			 Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, associados t4, dependentes t5 '
			 Set @SQL +='                               where t5.cd_sequencial = t2.cd_sequencial_dep '
			 Set @SQL +='                               and t2.cd_sequencial_lote = t3.cd_sequencial '
			 Set @SQL +='                               and t4.cd_associado = t5.cd_associado '
			 Set @SQL +='                               and t4.cd_empresa = e.cd_empresa '
			 Set @SQL +='                               and t3.cd_equipe = '+convert(varchar(10),@cd_equipe) 
			 Set @SQL +='                           ) +'
			 Set @SQL +='                           (select COUNT(0) from funcionario f where e.cd_func_vendedor = f.cd_funcionario and f.cd_equipe = '+convert(varchar(10),@cd_equipe)  +')) > 0 '
         end
         
         if @cd_func_vend >0
         begin
			Set @SQL +=' and e.cd_func_vendedor = ' + convert(varchar(10),@cd_func_vend)
         end

         
    Set @SQL += ' GROUP BY  m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela '

  --  print @SQL
  --  return
      
    exec (@SQL)
  OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @tp_pagamento, @tp, @fp, @Valor, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
    update atrasados 
       set FaturadoValor = FaturadoValor + Isnull(@Valor,0),
           FaturadoQtde =  FaturadoQtde  + IsNull(@Qtde,0)
     where cd_tipo_pagamento = @tp_pagamento and 
           tp_associado_empresa = @tp and     
           cd_tipo_parcela = @fp

     FETCH NEXT FROM cursor_atrasado INTO @tp_pagamento, @tp, @fp, @Valor, @Qtde
   END
   CLOSE cursor_atrasado
   DEALLOCATE cursor_atrasado

------------------------ Recebido Periodo -------------------------------------------------------------------------------

print 'Recebido Periodo'  
  Set @SQL = ''  
  
  Set @SQL += '
  DECLARE cursor_atrasado CURSOR FOR 
   SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela, 
      Sum(IsNull(m.VL_pago,0)), 
      null as diferenca,
      count(0) 
     FROM mensalidades as m , associados as a, empresa as e, ATRASADOS as t 
    WHERE m.cd_associado_Empresa = a.cd_associado and 
          m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
          m.tp_Associado_empresa = t.tp_Associado_empresa and 
          m.cd_tipo_parcela = t.cd_tipo_parcela and 
          a.cd_empresa = e.cd_empresa and 
          m.tp_associado_empresa=1 and 
          m.cd_tipo_recebimento > 2 and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)>='''+@dt_inicio+''' and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)<='''+@dt_fim+''' and 
          m.DT_pagamento>= '''+@dt_inicio+''' and 
          m.DT_pagamento <= '''+@dt_fim+''' '
     
      if  @cd_centro_custo > 0 
       begin
          Set @SQL += ' and e.cd_centro_custo = '+convert(varchar(10),@cd_centro_custo )
       end
       
      if @tp_empresa > 0 
	   begin
          Set @SQL += ' and e.tp_empresa ='+convert(varchar(10),@tp_empresa)
        end
        
      if @grupo > 0 
	   begin
         Set @SQL += ' and e.cd_grupo ='+convert(varchar(10),@grupo)
       end
       
      if @grupo_analise > 0
      begin 
         Set @SQL +=  ' and e.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
      end  
      
      if @depid>0 or @depid=-99
     begin
		if @depid=-99
		 Set @SQL +=' and a.depid is not null '
		else
		 Set @SQL +=' and a.depid ='+convert(varchar(10),@depid)
     end
     
     if @cd_equipe>0
		begin
		    Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, dependentes t4 '
            Set @SQL +='             where t4.cd_sequencial = t2.cd_sequencial_dep '
            Set @SQL +='             and t2.cd_sequencial_lote = t3.cd_sequencial '
            Set @SQL +='             and a.cd_associado = t4.cd_associado '
			Set @SQL +='             and t3.cd_equipe = ' +convert(varchar(10),@cd_equipe) 
            Set @SQL +='           ) + '
            Set @SQL +='           (select COUNT(0) from funcionario f inner join dependentes d on d.cd_funcionario_vendedor = f.cd_funcionario where d.cd_associado = a.cd_associado and f.cd_equipe = ' +convert(varchar(10),@cd_equipe) + ')) > 0 '
		end
       
		if @cd_func_vend >0
		begin
			set @SQL +=' and (select count(0) from dependentes t4 where a.cd_associado = t4.cd_associado and t4.cd_funcionario_vendedor = ' +convert(varchar(10),@cd_func_vend) + ') >0 '
		end
           
      
    Set @SQL += '  GROUP BY  m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela '
    
    Set @SQL += ' union '
    Set @SQL += ' 
      SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela, 
      Sum(IsNull(m.VL_pago,0)), 
      null as diferenca,
      count(0) 
     FROM mensalidades as m , EMPRESA as a, ATRASADOS as t 
    WHERE m.cd_associado_Empresa = a.cd_EMPRESA and 
          m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
          m.tp_Associado_empresa = t.tp_Associado_empresa and 
          m.cd_tipo_parcela = t.cd_tipo_parcela and 
          m.tp_associado_empresa=2 and 
          m.cd_tipo_recebimento > 2 and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)>= '''+@dt_inicio+''' and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)<= '''+@dt_fim+''' and 
          m.DT_pagamento>='''+@dt_inicio+''' and 
          m.DT_pagamento<='''+@dt_fim +''' '
          
      if  @cd_centro_custo > 0
       begin 
          Set @SQL += ' and a.cd_centro_custo = '+convert(varchar(10),@cd_centro_custo )
       end
       
      if @tp_empresa > 0
       begin
          Set @SQL += ' and a.tp_empresa ='+convert(varchar(10),@tp_empresa )
       end
       
      if @grupo > 0 
       begin
         Set @SQL += ' and a.cd_grupo ='+convert(varchar(10),@grupo )
       end
       
      if @grupo_analise > 0 
	   begin
         Set @SQL += ' and a.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
       end
       
       if @depid>0 or @depid = -99
     begin
         Set @SQL +=' and m.cd_parcela = -1'
     end 
     
     if @cd_equipe>0
         begin
			 Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, associados t4, dependentes t5 '
			 Set @SQL +='                               where t5.cd_sequencial = t2.cd_sequencial_dep '
			 Set @SQL +='                               and t2.cd_sequencial_lote = t3.cd_sequencial '
			 Set @SQL +='                               and t4.cd_associado = t5.cd_associado '
			 Set @SQL +='                               and t4.cd_empresa = a.cd_empresa '
			 Set @SQL +='                               and t3.cd_equipe = '+convert(varchar(10),@cd_equipe) 
			 Set @SQL +='                           ) +'
			 Set @SQL +='                           (select COUNT(0) from funcionario f where a.cd_func_vendedor = f.cd_funcionario and f.cd_equipe = '+convert(varchar(10),@cd_equipe)  +')) > 0 '
         end
         
         if @cd_func_vend >0
         begin
			Set @SQL +=' and a.cd_func_vendedor = ' + convert(varchar(10),@cd_func_vend)
         end
  

    Set @SQL += '   GROUP BY  m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela '
        
    exec (@SQL)
   OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @tp_pagamento, @tp, @fp , @Valor,@vl_atrasados, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
    select convert(varchar,@tp_pagamento), convert(varchar,@Qtde), convert(varchar,@Valor) 

    update atrasados 
       set recebidoValor = recebidoValor + IsNull(@Valor,0),
           recebidoQtde = recebidoQtde + IsNull(@Qtde,0),
           RecebidoValorDiferenca = RecebidoValorDiferenca + isnull(@vl_atrasados,0)
     where cd_tipo_pagamento = @tp_pagamento   and 
           tp_associado_empresa = @tp and     
           cd_tipo_parcela = @fp   

     FETCH NEXT FROM cursor_atrasado INTO @tp_pagamento, @tp, @fp , @Valor,@vl_atrasados, @Qtde
   END
   Close cursor_atrasado
   DEALLOCATE cursor_atrasado

------------------------   Recebimento Fora do Período  -------------------------------------------------------------------------------

print 'Recebido Fora'
 Set @SQL = ''  
  
  Set @SQL += '
   DECLARE cursor_atrasado CURSOR FOR 
    SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela, 
           Sum(IsNull(m.VL_pago,0)), 
  		   null as diferenca,
		   count(0) 
      FROM mensalidades as m , associados as a, empresa as e, ATRASADOS as t 
     WHERE m.cd_associado_Empresa = a.cd_associado and 
           m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
           m.tp_Associado_empresa = t.tp_Associado_empresa and 
           m.cd_tipo_parcela = t.cd_tipo_parcela and 
           a.cd_empresa = e.cd_empresa and 
           m.cd_tipo_recebimento > 2 and 
           m.tp_associado_empresa=1 and 
           m.DT_pagamento>= '''+ @dt_inicio +''' And m.DT_pagamento<= '''+ @dt_fim +'''          
           and (isnull(m.dt_vencimento_new,m.dt_vencimento)< '''+ @dt_inicio +''' or 
           isnull(m.dt_vencimento_new,m.dt_vencimento)> '''+ @dt_fim +''')'
                                
       if @cd_centro_custo > 0
        begin 
          Set @SQL += ' and e.cd_centro_custo = '+convert(varchar(10),@cd_centro_custo)
        end
        
       if @tp_empresa > 0
        begin
          Set @SQL += ' and e.tp_empresa ='+convert(varchar(10),@tp_empresa)
        end
        
       if @grupo > 0 
        begin
         Set @SQL += ' and e.cd_grupo ='+convert(varchar(10),@grupo) 
        end
       
       if @grupo_analise > 0 
	    begin
         Set @SQL += ' and e.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
        end    
        
        if @depid>0 or @depid=-99
     begin
		if @depid=-99
		 Set @SQL +=' and a.depid is not null '
		else
		 Set @SQL +=' and a.depid ='+convert(varchar(10),@depid)
     end  
     
     if @cd_equipe>0
		begin
		    Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, dependentes t4 '
            Set @SQL +='             where t4.cd_sequencial = t2.cd_sequencial_dep '
            Set @SQL +='             and t2.cd_sequencial_lote = t3.cd_sequencial '
            Set @SQL +='             and a.cd_associado = t4.cd_associado '
			Set @SQL +='             and t3.cd_equipe = ' +convert(varchar(10),@cd_equipe) 
            Set @SQL +='           ) + '
            Set @SQL +='           (select COUNT(0) from funcionario f inner join dependentes d on d.cd_funcionario_vendedor = f.cd_funcionario where d.cd_associado = a.cd_associado and f.cd_equipe = ' +convert(varchar(10),@cd_equipe) + ')) > 0 '
		end
       
		if @cd_func_vend >0
		begin
			set @SQL +=' and (select count(0) from dependentes t4 where a.cd_associado = t4.cd_associado and t4.cd_funcionario_vendedor = ' +convert(varchar(10),@cd_func_vend) + ')>0 '
		end
         
                   
     Set @SQL += ' GROUP BY  m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela '
     
   Set @SQL += ' Union '
   Set @SQL += '
    SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela, 
           Sum(IsNull(m.VL_pago,0)), 
           null as diferenca,
		   count(0) 
      FROM mensalidades as m , EMPRESA as a, ATRASADOS as t 
     WHERE m.cd_associado_Empresa = a.cd_empresa and 
           m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
           m.tp_Associado_empresa = t.tp_Associado_empresa and 
           m.cd_tipo_parcela = t.cd_tipo_parcela and 
           m.tp_associado_empresa=2 and 
           m.cd_tipo_recebimento > 2 and 
           m.DT_pagamento>= '''+ @dt_inicio+ ''' and 
           m.DT_pagamento <= '''+@dt_fim +''' and 
           (isnull(m.dt_vencimento_new,m.dt_vencimento)< '''+ @dt_inicio +''' or 
           isnull(m.dt_vencimento_new,m.dt_vencimento)> '''+ @dt_fim +''') '
            
            if @cd_centro_custo > 0
             begin
               Set @SQL += ' and a.cd_centro_custo ='+ convert(varchar(10),@cd_centro_custo)               
             end
             
            if @tp_empresa > 0
             begin
               Set @SQL += ' and a.tp_empresa ='+ convert(varchar(10),@tp_empresa) 
             end
             
			if @grupo > 0 
		     begin
			  Set @SQL += ' and a.cd_grupo = '+convert(varchar(10),@grupo)
			 end
	       
		    if @grupo_analise > 0 
		     begin
			  Set @SQL += ' and a.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
		     end
		     
		     if @depid>0 or @depid = -99
     begin
         Set @SQL +=' and m.cd_parcela = -1'
     end 	  
     
     if @cd_equipe>0
         begin
			 Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, associados t4, dependentes t5 '
			 Set @SQL +='                               where t5.cd_sequencial = t2.cd_sequencial_dep '
			 Set @SQL +='                               and t2.cd_sequencial_lote = t3.cd_sequencial '
			 Set @SQL +='                               and t4.cd_associado = t5.cd_associado '
			 Set @SQL +='                               and t4.cd_empresa = a.cd_empresa '
			 Set @SQL +='                               and t3.cd_equipe = '+convert(varchar(10),@cd_equipe) 
			 Set @SQL +='                           ) +'
			 Set @SQL +='                           (select COUNT(0) from funcionario f where a.cd_func_vendedor = f.cd_funcionario and f.cd_equipe = '+convert(varchar(10),@cd_equipe)  +')) > 0 '
         end
         
         if @cd_func_vend >0
         begin
			Set @SQL +=' and a.cd_func_vendedor = ' + convert(varchar(10),@cd_func_vend)
         end
     		 
                       
    Set @SQL += ' GROUP BY  m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela '
     
   -- print @SQL
  --  return
    
   exec (@SQL)
   OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @tp_pagamento, @tp, @fp, @Valor,@vl_atrasados, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
    update atrasados 
       set recebidoValorFora =  recebidoValorFora + @Valor,
           recebidoQtdeFora = recebidoQtdeFora + @Qtde,
           RecebidoValorForaDiferenca = RecebidoValorForaDiferenca + isnull(@vl_atrasados,0)
     where cd_tipo_pagamento = @tp_pagamento and 
           tp_associado_empresa = @tp and     
           cd_tipo_parcela = @fp

     FETCH NEXT FROM cursor_atrasado INTO @tp_pagamento, @tp, @fp, @Valor,@vl_atrasados, @Qtde
   END
   Close cursor_atrasado
   DEALLOCATE cursor_atrasado

------------------------   Atrasados  -------------------------------------------------------------------------------

print 'Atrasados'
 Set @SQL = ''  
  
  Set @SQL += '
  DECLARE cursor_atrasado CURSOR FOR 
   SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela, 
     Sum(IsNull(m.VL_PARCELA + isnull(vl_acrescimo,0) - isnull(vl_desconto,0) - isnull(vl_imposto,0) ,0)),     
     count(0)
     FROM mensalidades as m , associados as a, empresa as e, ATRASADOS as t 
    WHERE m.cd_associado_Empresa = a.cd_associado and 
          m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
          m.tp_Associado_empresa = t.tp_Associado_empresa and 
          m.cd_tipo_parcela = t.cd_tipo_parcela and 
          a.cd_empresa = e.cd_empresa and 
          m.cd_tipo_recebimento = 0 and 
          m.tp_associado_empresa=1 and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)>= '''+ @dt_inicio +''' and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)<= '''+ @dt_fim +''' '
          
		   if @cd_centro_custo > 0
			begin 
			  Set @SQL += ' and e.cd_centro_custo = '+convert(varchar(10),@cd_centro_custo)		   
			end
	        
		   if @tp_empresa > 0
			begin
			  Set @SQL += ' and e.tp_empresa ='+convert(varchar(10),@tp_empresa)	 
			end  
			
			if @grupo > 0 
		     begin
			  Set @SQL += ' and e.cd_grupo ='+convert(varchar(10),@grupo) 
			 end
	       
		    if @grupo_analise > 0 
		     begin
			  Set @SQL += ' and e.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
		     end
		     
		     if @depid>0 or @depid=-99
     begin
		if @depid=-99
		 Set @SQL +=' and a.depid is not null '
		else
		 Set @SQL +=' and a.depid ='+convert(varchar(10),@depid)
     end 
     
           if @cd_equipe>0
	begin
	    Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, dependentes t4 '
        Set @SQL +='             where t4.cd_sequencial = t2.cd_sequencial_dep '
        Set @SQL +='             and t2.cd_sequencial_lote = t3.cd_sequencial '
        Set @SQL +='             and a.cd_associado = t4.cd_associado '
		Set @SQL +='             and t3.cd_equipe = ' +convert(varchar(10),@cd_equipe) 
        Set @SQL +='           ) + '
        Set @SQL +='           (select COUNT(0) from funcionario f inner join dependentes d on d.cd_funcionario_vendedor = f.cd_funcionario where d.cd_associado = a.cd_associado and f.cd_equipe = ' +convert(varchar(10),@cd_equipe) + ')) > 0 '
	end
   
	if @cd_func_vend >0
	begin
		set @SQL +=' and (select count(0) from dependentes t4 where a.cd_associado = t4.cd_associado and t4.cd_funcionario_vendedor = ' +convert(varchar(10),@cd_func_vend) + ') >0 '
	end
 
	       		                            
          
   Set @SQL += ' GROUP BY  m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela '
   Set @SQL += ' Union '
   Set @SQL += ' SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela, 
          Sum(IsNull(m.VL_PARCELA + isnull(vl_acrescimo,0) - isnull(vl_desconto,0) - isnull(vl_imposto,0) ,0)),
          count(IsNull(m.cd_associado_empresa,0)) 
     FROM mensalidades as m , EMPRESA as a, ATRASADOS as t 
    WHERE m.cd_associado_Empresa = a.cd_empresa and 
          m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
          m.tp_Associado_empresa = t.tp_Associado_empresa and 
          m.cd_tipo_parcela = t.cd_tipo_parcela and 
          m.cd_tipo_recebimento = 0 and 
          m.tp_associado_empresa=2 and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)>=''' + @dt_inicio +''' and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)<='''+ @dt_fim +''' ' 
          
           if @cd_centro_custo > 0
			begin 
			  Set @SQL += ' and a.cd_centro_custo = '+convert(varchar(10),@cd_centro_custo)		   
			end
	        
		   if @tp_empresa > 0
			begin
			  Set @SQL += ' and a.tp_empresa ='+convert(varchar(10),@tp_empresa)		   
			end              
          
          if @grupo > 0 
		     begin
			  Set @SQL += ' and a.cd_grupo ='+convert(varchar(10),@grupo)
			 end
	       
		   if @grupo_analise > 0 
		     begin
			  Set @SQL += ' and a.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
		     end
		     
		    if @depid>0 or @depid = -99
     begin
         Set @SQL +=' and m.cd_parcela = -1'
     end 	
    
    if @cd_equipe>0
         begin
			 Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, associados t4, dependentes t5 '
			 Set @SQL +='                               where t5.cd_sequencial = t2.cd_sequencial_dep '
			 Set @SQL +='                               and t2.cd_sequencial_lote = t3.cd_sequencial '
			 Set @SQL +='                               and t4.cd_associado = t5.cd_associado '
			 Set @SQL +='                               and t4.cd_empresa = a.cd_empresa '
			 Set @SQL +='                               and t3.cd_equipe = '+convert(varchar(10),@cd_equipe) 
			 Set @SQL +='                           ) +'
			 Set @SQL +='                           (select COUNT(0) from funcionario f where a.cd_func_vendedor = f.cd_funcionario and f.cd_equipe = '+convert(varchar(10),@cd_equipe)  +')) > 0 '
         end
         
         if @cd_func_vend >0
         begin
			Set @SQL +=' and a.cd_func_vendedor = ' + convert(varchar(10),@cd_func_vend)
         end  
   
   Set @SQL += ' GROUP BY  m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela '

   exec(@SQL)
   OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @tp_pagamento, @tp, @fp , @Valor, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
    update atrasados 
       set atrasadoValor = atrasadoValor + IsNull(@Valor,0),
           atrasadoQtde = atrasadoQtde + IsNull(@Qtde,0)  
     where cd_tipo_pagamento = @tp_pagamento and 
           tp_associado_empresa = @tp and     
           cd_tipo_parcela = @fp

     FETCH NEXT FROM cursor_atrasado INTO @tp_pagamento, @tp, @fp , @Valor, @Qtde
   END
   Close cursor_atrasado
   DEALLOCATE cursor_atrasado

------------------------   Pagamento Fora do Período  -------------------------------------------------------------------------------

print 'Pagamento fora'
 Set @SQL = ''  
  
  Set @SQL += '
   DECLARE cursor_atrasado CURSOR FOR 
    SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela, 
           Sum(IsNull(m.VL_pago,0)), 
  		   null as diferenca,
		   count(0) 
      FROM mensalidades as m , associados as a, empresa as e, ATRASADOS as t 
     WHERE m.cd_associado_Empresa = a.cd_associado and 
           m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
           m.tp_Associado_empresa = t.tp_Associado_empresa and 
           m.cd_tipo_parcela = t.cd_tipo_parcela and 
           a.cd_empresa = e.cd_empresa and 
           m.tp_associado_empresa=1 and 
           m.cd_tipo_recebimento > 2 and 
           isnull(m.dt_vencimento_new,m.dt_vencimento)>= '''+@dt_inicio +''' and 
           isnull(m.dt_vencimento_new,m.dt_vencimento)<= '''+@dt_fim +''' and 
           (m.DT_pagamento< '''+@dt_inicio+''' or 
           m.DT_pagamento> '''+@dt_fim+''') '
           
            if @cd_centro_custo > 0
			begin 
			  Set @SQL += ' and e.cd_centro_custo = '+ convert(varchar(10),@cd_centro_custo)		   
			end
	        
		   if @tp_empresa > 0
			begin
			  Set @SQL += ' and e.tp_empresa ='+ convert(varchar(10),@tp_empresa)
			end              
           
           if @grupo > 0 
		     begin
			  Set @SQL += ' and e.cd_grupo ='+ convert(varchar(10),@grupo)
			 end
	       
		   if @grupo_analise > 0 
		     begin
			  Set @SQL += ' and e.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
		     end
	       		  
	       if @depid>0 or @depid=-99
     begin
		if @depid=-99
		 Set @SQL +=' and a.depid is not null '
		else
		 Set @SQL +=' and a.depid ='+convert(varchar(10),@depid)
     end 
     
     if @cd_equipe>0
		begin
		    Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, dependentes t4 '
            Set @SQL +='             where t4.cd_sequencial = t2.cd_sequencial_dep '
            Set @SQL +='             and t2.cd_sequencial_lote = t3.cd_sequencial '
            Set @SQL +='             and a.cd_associado = t4.cd_associado '
			Set @SQL +='             and t3.cd_equipe = ' +convert(varchar(10),@cd_equipe) 
            Set @SQL +='           ) + '
            Set @SQL +='           (select COUNT(0) from funcionario f inner join dependentes d on d.cd_funcionario_vendedor = f.cd_funcionario where d.cd_associado = a.cd_associado and f.cd_equipe = ' +convert(varchar(10),@cd_equipe) + ')) > 0 '
		end
       
		if @cd_func_vend >0
		begin
			set @SQL +=' and (select count(0) from dependentes t4 where a.cd_associado = t4.cd_associado and t4.cd_funcionario_vendedor = ' +convert(varchar(10),@cd_func_vend) + ')>0 '
		end   

           
    Set @SQL += ' GROUP BY  m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela '
    Set @SQL += ' union '
    Set @SQL += ' SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela, 
           Sum(IsNull(m.VL_pago,0)), 
  		   null as diferenca,
		   count(0) 
      FROM mensalidades as m , EMPRESA as a, ATRASADOS as t 
     WHERE m.cd_associado_Empresa = a.cd_EMPRESA and 
           m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
           m.tp_Associado_empresa = t.tp_Associado_empresa and 
           m.cd_tipo_parcela = t.cd_tipo_parcela and 
           m.tp_associado_empresa=2 and 
           m.cd_tipo_recebimento > 2 and 
           isnull(m.dt_vencimento_new,m.dt_vencimento)>='''+ @dt_inicio+''' and 
           isnull(m.dt_vencimento_new,m.dt_vencimento)<='''+ @dt_fim+''' and 
           (m.DT_pagamento< '''+@dt_inicio+''' or 
           m.DT_pagamento> '''+@dt_fim+''') '
           
           
            if @cd_centro_custo > 0
			begin 
			  Set @SQL += ' and a.cd_centro_custo = '+convert(varchar(10),@cd_centro_custo)	    
			end
	        
		   if @tp_empresa > 0
			begin
			  Set @SQL += ' and a.tp_empresa ='+convert(varchar(10),@tp_empresa)
			end   
                 
           if @grupo > 0 
		     begin
			  Set @SQL += ' and a.cd_grupo ='+convert(varchar(10),@grupo)
			 end
	       
		   if @grupo_analise > 0 
		     begin
			  Set @SQL += ' and a.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
		     end
		     
		    if @depid>0 or @depid = -99
     begin
         Set @SQL +=' and m.cd_parcela = -1'
     end  	
     
     if @cd_equipe>0
         begin
			 Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, associados t4, dependentes t5 '
			 Set @SQL +='                               where t5.cd_sequencial = t2.cd_sequencial_dep '
			 Set @SQL +='                               and t2.cd_sequencial_lote = t3.cd_sequencial '
			 Set @SQL +='                               and t4.cd_associado = t5.cd_associado '
			 Set @SQL +='                               and t4.cd_empresa = a.cd_empresa '
			 Set @SQL +='                               and t3.cd_equipe = '+convert(varchar(10),@cd_equipe) 
			 Set @SQL +='                           ) +'
			 Set @SQL +='                           (select COUNT(0) from funcionario f where a.cd_func_vendedor = f.cd_funcionario and f.cd_equipe = '+convert(varchar(10),@cd_equipe)  +')) > 0 '
         end
         
         if @cd_func_vend >0
         begin
			Set @SQL +=' and a.cd_func_vendedor = ' + convert(varchar(10),@cd_func_vend)
         end
       		   
                          
         Set @SQL += ' GROUP BY m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela '
         
     exec(@SQL)
   OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @tp_pagamento, @tp, @fp, @Valor,@vl_atrasados, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
    update atrasados 
       set PagoValorFora = PagoValorFora + IsNull(@Valor,0),
           PagoQtdeFora =  PagoQtdeFora + IsNull(@Qtde,0),
           PagoValorForaAtrasado = PagoValorForaAtrasado + isnull(@vl_atrasados,0)
     where cd_tipo_pagamento = @tp_pagamento  and 
           tp_associado_empresa = @tp and     
           cd_tipo_parcela = @fp   

     FETCH NEXT FROM cursor_atrasado INTO @tp_pagamento, @tp, @fp, @Valor,@vl_atrasados, @Qtde
   END
   Close cursor_atrasado
   DEALLOCATE cursor_atrasado

--------------------------------------- CANCELADOS ------------------------------------------------------------------

print 'Cancelado'
Set @SQL = ''  
  
  Set @SQL += '
  DECLARE cursor_cancelado CURSOR FOR 
   SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela, 
          Sum(IsNull(m.VL_PARCELA + isnull(vl_acrescimo,0) - isnull(vl_desconto,0) - isnull(vl_imposto,0) ,0)),count(0)
     FROM mensalidades as m , associados as a, empresa as e, ATRASADOS as t 
    WHERE m.cd_associado_Empresa = a.cd_associado and 
          m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
          m.tp_Associado_empresa = t.tp_Associado_empresa and 
          m.cd_tipo_parcela = t.cd_tipo_parcela and 
          a.cd_empresa = e.cd_empresa and 
          m.tp_associado_empresa=1 and 
          m.cd_tipo_recebimento in (2) and 
          isnull(m.dt_vencimento_new,m.dt_vencimento)>= '''+@dt_inicio+''' 
          and isnull(m.dt_vencimento_new,m.dt_vencimento)<= '''+@dt_fim+''' '
          
           if @cd_centro_custo > 0
			begin 
			  Set @SQL += ' and e.cd_centro_custo = '+convert(varchar(10),@cd_centro_custo)		   
			end
	        
		   if @tp_empresa > 0
			begin
			  Set @SQL += ' and e.tp_empresa ='+convert(varchar(10),@tp_empresa)
			end             
          
          if @grupo > 0 
		     begin
			  Set @SQL += ' and e.cd_grupo ='+convert(varchar(10),@grupo) 
			 end
	       
		   if @grupo_analise > 0 
		     begin
			  Set @SQL += ' and e.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
		     end
		     
		     if @depid>0 or @depid=-99
     begin
		if @depid=-99
		 Set @SQL +=' and a.depid is not null '
		else
		 Set @SQL +=' and a.depid ='+convert(varchar(10),@depid)
     end 
     
     if @cd_equipe>0
		begin
		    Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, dependentes t4 '
            Set @SQL +='             where t4.cd_sequencial = t2.cd_sequencial_dep '
            Set @SQL +='             and t2.cd_sequencial_lote = t3.cd_sequencial '
            Set @SQL +='             and a.cd_associado = t4.cd_associado '
			Set @SQL +='             and t3.cd_equipe = ' +convert(varchar(10),@cd_equipe) 
            Set @SQL +='           ) + '
            Set @SQL +='           (select COUNT(0) from funcionario f inner join dependentes d on d.cd_funcionario_vendedor = f.cd_funcionario where d.cd_associado = a.cd_associado and f.cd_equipe = ' +convert(varchar(10),@cd_equipe) + ')) > 0 '
		end
       
		if @cd_func_vend >0
		begin
			set @SQL +=' and (select count(0) from dependentes t4 where a.cd_associado = t4.cd_associado and t4.cd_funcionario_vendedor = ' +convert(varchar(10),@cd_func_vend) + ')>0 '
		end
	       		   
		     
   Set @SQL += ' GROUP BY  m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela'
   Set @SQL += ' Union '
   Set @SQL += ' SELECT m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela , 
           Sum(IsNull(m.VL_PARCELA + isnull(vl_acrescimo,0) - isnull(vl_desconto,0) - isnull(vl_imposto,0) ,0)),count(0)
      FROM mensalidades as m , EMPRESA as a, ATRASADOS as t 
     WHERE m.cd_associado_Empresa = a.cd_EMPRESA and 
		   m.CD_TIPO_PAGaMENTO = t.cd_tipo_pagamento and 
           m.tp_Associado_empresa = t.tp_Associado_empresa and 
           m.cd_tipo_parcela = t.cd_tipo_parcela and             
           m.tp_associado_empresa=2 and 
           m.cd_tipo_recebimento in (2) and 
           isnull(m.dt_vencimento_new,m.dt_vencimento)>= '''+@dt_inicio+''' and 
           isnull(m.dt_vencimento_new,m.dt_vencimento)<= '''+@dt_fim+''' '
           
           if @cd_centro_custo > 0
			begin 
			  Set @SQL += ' and a.cd_centro_custo = '+convert(varchar(10),@cd_centro_custo)		   
			end
	        
		   if @tp_empresa > 0
			begin
			  Set @SQL += ' and a.tp_empresa ='+convert(varchar(10),@tp_empresa) 		  
			end   
			
		   if @grupo > 0 
		     begin
			  Set @SQL += ' and a.cd_grupo ='+convert(varchar(10),@grupo) 
			 end
	       
		   if @grupo_analise > 0 
		     begin
			  Set @SQL += ' and a.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise='+convert(varchar(10),@grupo_analise)+')'
		     end
		     
		     if @depid>0 or @depid = -99
     begin
         Set @SQL +=' and m.cd_parcela = -1'
     end 
     
     if @cd_equipe>0
         begin
			 Set @SQL +=' and ((select COUNT(0) from lote_contratos_contratos_vendedor t2, lote_contratos t3, associados t4, dependentes t5 '
			 Set @SQL +='                               where t5.cd_sequencial = t2.cd_sequencial_dep '
			 Set @SQL +='                               and t2.cd_sequencial_lote = t3.cd_sequencial '
			 Set @SQL +='                               and t4.cd_associado = t5.cd_associado '
			 Set @SQL +='                               and t4.cd_empresa = a.cd_empresa '
			 Set @SQL +='                               and t3.cd_equipe = '+convert(varchar(10),@cd_equipe) 
			 Set @SQL +='                           ) +'
			 Set @SQL +='                           (select COUNT(0) from funcionario f where a.cd_func_vendedor = f.cd_funcionario and f.cd_equipe = '+convert(varchar(10),@cd_equipe)  +')) > 0 '
         end
         
         if @cd_func_vend >0
         begin
			Set @SQL +=' and a.cd_func_vendedor = ' + convert(varchar(10),@cd_func_vend)
         end
       		   	
                                                  
   Set @SQL += ' GROUP BY  m.CD_TIPO_PAGAMENTO, m.tp_Associado_empresa, m.cd_tipo_parcela '

  exec(@SQL)
  OPEN cursor_cancelado 
  FETCH NEXT FROM cursor_cancelado INTO @tp_pagamento, @tp, @fp, @Valor, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
    update atrasados 
       set CanceladoValor = CanceladoValor + IsNull(@Valor,0),
           CanceladoQtde  = CanceladoQtde + IsNull(@Qtde,0)
     where cd_tipo_pagamento = @tp_pagamento   and 
           tp_associado_empresa = @tp and     
           cd_tipo_parcela = @fp 

     FETCH NEXT FROM cursor_cancelado INTO @tp_pagamento, @tp, @fp, @Valor, @Qtde
   END
   CLOSE cursor_cancelado
   DEALLOCATE cursor_cancelado

  print 'Atrasados'
  delete atrasados where faturadoqtde=0 and recebidoqtde=0 and recebidoqtdefora=0 and atrasadoqtde=0 and pagoqtdefora=0 and canceladovalor=0

End
