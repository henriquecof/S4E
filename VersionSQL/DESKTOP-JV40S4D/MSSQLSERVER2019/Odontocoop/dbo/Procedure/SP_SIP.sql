/****** Object:  Procedure [dbo].[SP_SIP]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_SIP]
	@trimestre smallint, -- Valores de 1 a 4 
	@ano smallint, 
	@tp_empresa smallint, -- 1-Ind, 2-Col Emp, 3-Col Ades
	@cd_uf int 
as 
Begin

	Declare @ufp int = 18 
	
	insert into categoriaANS_Servico (cd_categoria_ans,cd_servico)
	select distinct 1,cd_servico from categoriaANS_Servico where cd_categoria_ans>1 
	and cd_servico not in (select cd_servico from categoriaANS_Servico where cd_categoria_ans=1)	  
   
    declare @ano_trimeste varchar(8) 
    set @ano_trimeste	= convert(varchar(4),@ano)+ ''+ right('00'+ convert(varchar(2), @trimestre),2)
	
	delete ANS_SIP where ano_trimestre = @ano_trimeste and tipo_empresa = @tp_empresa --and uf = @cd_uf 

	--INSERT INTO ANS_SIP (ano_trimestre ,tipo_empresa,cd_categoria_ans,qt_eventos ,qt_beneficiarios ,vl_despesa ,uf)
	--SELECT   @ano_trimeste, @tp_empresa, t1.cd_categoria_ans, 0,0,0,@cd_uf FROM Categoria_Ans T1

   --Return
 -----------------------------------------------------------------------------------------  
 -----------------------------------------------------------------------------------------  
   Delete tps_sip 
   if @trimestre > 4 
	Begin -- 2.1
	  Raiserror('Trimestre aceitavel 1 a 4.',16,1)
	  RETURN
	End -- 2.1
	
   Declare @cd_planoans varchar(10)
   Select top 1 @cd_planoans = cd_ans from classificacao_ans where tp_empresa = @tp_empresa 
   if @cd_planoans is null 
	Begin -- 2.1
	  Raiserror('Classificação ANS não localizada.',16,1)
	  RETURN
	End -- 2.1
   
   Declare @qtde_repeticao smallint = 3
   Declare @qtde_curr smallint = 1 
   Declare @dt_ref datetime
   Declare @dt_serv varchar(6), @dt_servico datetime 
   Set @dt_ref = convert(datetime,convert(varchar(2),(((@trimestre-1)*3)+1))+'/01/'+CONVERT(varchar(4),@ano))
   print @dt_ref 

   Create table #_uf (ufid int)
   
   insert #_uf (ufid)
   select distinct ISNULL(t2.ufid,isnull(t3.ufid,@ufp)) 
     from pagamento_dentista_lancamento as t1 
             left join funcionario as t2 on t1.cd_funcionario = t2.cd_funcionario
             left join filial as t3 on t1.cd_filial = t3.cd_filial
    where  t1.dt_conhecimento >= @dt_ref and t1.dt_conhecimento < DATEADD(month,3,@dt_ref) 	

   -- Calcular os Beneficiarios  
   While @qtde_curr<=@qtde_repeticao
	Begin
	
	  insert tps_sip(competencia,qt0,qt1,qt2)
	  select convert(varchar,year(dateadd(day,-1,DATEADD(month,@qtde_curr,@dt_ref)))) + right('00'+convert(varchar,month(dateadd(day,-1,DATEADD(month,@qtde_curr,@dt_ref)))),2), 
	         isnull(COUNT(0),0) ,
			 isnull(sum(case when dbo.FS_Idade(b.dt_nascimento,DATEADD(month,@qtde_curr,@dt_ref))>=12 then 1 else 0 end),0),
			 isnull(sum(case when dbo.FS_Idade(b.dt_nascimento,DATEADD(month,@qtde_curr,@dt_ref))>=12 then 0 else 1 end),0)
		from ans_beneficiarios as b, ASSOCIADOS as a, DEPENDENTES as d,empresa as e 
	   where dt_inclusao < DATEADD(month,@qtde_curr,@dt_ref)
		 and (dt_exclusao is null or dt_exclusao >= DATEADD(month,@qtde_curr,@dt_ref) )
         and cd_plano_ans in (select cd_ans from CLASSIFICACAO_ANS where tp_empresa=@tp_empresa)
         and b.cd_sequencial_dep = d.cd_sequencial 
         and d.cd_associado = a.cd_associado 
         and a.cd_empresa = e.cd_empresa 
       --   and isnull(a.ufId,isnull(e.ufid,@ufp)) = @cd_uf
	  
      set @qtde_curr=@qtde_curr+1
	End  

    Declare @qt0 int, @qt1 int, @qt2 int 
    select @qt0=avg(qt0),@qt1=avg(qt1),@qt2=avg(qt2) from tps_sip

    Declare @sql varchar(8000)
    Declare @qtde_eventos int 
    
    -- Responder as perguntas que NÃO sao agrupadas 
    Declare @cd_categoria_ans smallint, @padrao_idade smallint, @ud_inicial smallint, @ud_final smallint, @peso smallint 

    Declare cursor_uf Cursor For
    select Ufid from #_uf 
     OPEN cursor_uf  
	FETCH NEXT FROM cursor_uf INTO @cd_uf
	WHILE (@@FETCH_STATUS <> -1)  
	begin  -- 2.2       
			DECLARE cursor_gera_sip_serv CURSOR FOR 
			 Select CONVERT(varchar(4),year(t3.dt_servico))+
					case when MONTH(t3.dt_servico)<4 then '01'
						 when MONTH(t3.dt_servico)<7 then '02'
						 when MONTH(t3.dt_servico)<10 then '03'
						 else '04' end 
					  from categoriaANS_Servico as T2, Consultas as T3, DEPENDENTES as T4,
						   pagamento_dentista as pg , Modelo_Pagamento_Prestador as mpp , 
						   PLANOS as p, CLASSIFICACAO_ANS as CANS ,
						   (select t1.* 
							  from pagamento_dentista_lancamento as t1 
									 left join funcionario as t2 on t1.cd_funcionario = t2.cd_funcionario
									 left join filial as t3 on t1.cd_filial = t3.cd_filial
							 where ISNULL(t2.ufid,isnull(t3.ufid,@ufp))  = @cd_uf       
						   ) as pdl, 
						   SERVICO T5
					 where 
						   t2.cd_servico = t5.cd_servicoANS and 
						   t5.cd_servico = t3.cd_servico  and 
						   t3.cd_sequencial_dep = t4.cd_sequencial and 
						   t4.cd_plano = p.cd_plano and 
						   p.cd_classificacao = CANS.cd_classificacao and
						   CANS.idconvenio is null and 
						   t3.nr_numero_lote is not null and 
						   T3.nr_numero_lote = pg.cd_sequencial and
						   pg.cd_modelo_pgto_prestador = mpp.cd_modelo_pgto_prestador and 
						   pg.cd_pgto_dentista_lanc = pdl.cd_pgto_dentista_lanc and 
						   cans.tp_empresa= @tp_empresa and 
						   --t3.status in (3,6,7) and 
						   pdl.dt_conhecimento >= @dt_ref and 
						   pdl.dt_conhecimento < DATEADD(month,3,@dt_ref) and 
			               
						 --  pdl.uf = @cd_uf and 
			               
						   T3.dt_servico is not null and 
						   T3.dt_cancelamento is null and 
						   t3.status not in (7) and 
						   
						   (
							  (isnull(t3.vl_Pago_produtividade,0)+isnull(t3.vl_acerto_pgto_produtividade,0)>0)
						   -- or
						  --     T3.vl_glosa>0
						   )
			               ---and convert(varchar(4), year(pdl.dt_conhecimento)) + right('00' + convert(varchar(2), DATEPART(QUARTER,pdl.dt_conhecimento)),2) >= convert(varchar(4), year(t3.dt_servico)) + right('00' + convert(varchar(2), DATEPART(QUARTER,t3.dt_servico)),2) 
					group by   CONVERT(varchar(4),year(t3.dt_servico))+case when MONTH(t3.dt_servico)<4 then '01'
								 when MONTH(t3.dt_servico)<7 then '02'
								 when MONTH(t3.dt_servico)<10 then '03'
								 else '04' end 
					order by CONVERT(varchar(4),year(t3.dt_servico))+case when MONTH(t3.dt_servico)<4 then '01'
								 when MONTH(t3.dt_servico)<7 then '02'
								 when MONTH(t3.dt_servico)<10 then '03'
								 else '04' end              
			   OPEN cursor_gera_sip_serv  
			  FETCH NEXT FROM cursor_gera_sip_serv INTO @dt_serv
			  WHILE (@@FETCH_STATUS <> -1)  
			  begin  -- 2.2  

				Set @dt_servico = convert(datetime,convert(varchar(2),(((convert(int,right(@dt_serv,2))-1)*3)+1))+'/01/'+left(@dt_serv,4))
		        
				DECLARE cursor_gera_sip CURSOR FOR 
				 select top 100 cd_categoria_ans , padrao_idade, ud_inicial, ud_final , 1-- isnull(peso,1)
				   from Categoria_Ans
				  where cd_codigo_ans is null or len(cd_codigo_ans)=0
				   OPEN cursor_gera_sip  
				  FETCH NEXT FROM cursor_gera_sip INTO @cd_categoria_ans , @padrao_idade, @ud_inicial, @ud_final ,@peso
   				  WHILE (@@FETCH_STATUS <> -1)  
				  begin  -- 2.2        

					 set @sql = 'insert into ans_sip (ano_trimestre,tipo_empresa,cd_categoria_ans,qt_beneficiarios,vl_despesa,qt_eventos,uf,ano_trimestre_execucao)
						Select '+CONVERT(varchar(4),@ano)+right('00'+CONVERT(varchar(2),@trimestre),2) +','+
							   CONVERT(varchar(10),@tp_empresa) + ','+
							   CONVERT(varchar(10),@cd_categoria_ans) + ',' + 
							   convert(varchar(10),case when @padrao_idade=0 then @qt0 when @padrao_idade=1 then @qt1 else @qt2 end)+',round(isnull(SUM(isnull(t3.vl_Pago_produtividade,0)+isnull(t3.vl_acerto_pgto_produtividade,0)),0),2),
							   isnull(sum(isnull(t5.qt_peso_sip,1)),0),' + CONVERT(varchar(10),@cd_uf) + ',' + @dt_serv + '
						  from categoriaANS_Servico as T2, Consultas as T3, DEPENDENTES as T4,
							   pagamento_dentista as pg , Modelo_Pagamento_Prestador as mpp , 
							   PLANOS as p, CLASSIFICACAO_ANS as CANS ,
							   (select t1.* 
								  from pagamento_dentista_lancamento as t1 
										 left join funcionario as t2 on t1.cd_funcionario = t2.cd_funcionario
										 left join filial as t3 on t1.cd_filial = t3.cd_filial
								 where ISNULL(t2.ufid,isnull(t3.ufid,'+convert(varchar(4),@ufp)+')) = '+convert(varchar(4),@cd_uf)+'		 
							   ) as pdl, 
							   SERVICO T5
						 where t2.cd_categoria_ans = ' + convert(varchar(10),@cd_categoria_ans) + ' and
							   t2.cd_servico = t5.cd_servicoANS and 
							   t5.cd_servico = t3.cd_servico  and 
							   t3.cd_sequencial_dep = t4.cd_sequencial and 
							   t4.cd_plano = p.cd_plano and 
							   p.cd_classificacao = CANS.cd_classificacao and
							   CANS.idconvenio is null and 
							   t3.nr_numero_lote is not null and 
							   T3.nr_numero_lote = pg.cd_sequencial and
							   pg.cd_modelo_pgto_prestador = mpp.cd_modelo_pgto_prestador and 
							   pg.cd_pgto_dentista_lanc = pdl.cd_pgto_dentista_lanc and 
							   cans.tp_empresa= ' + convert(varchar(10),@tp_empresa) + ' and 
							   
							  -- t3.status in (3,6,7) and 

							   pdl.dt_conhecimento >= ''' + convert(varchar(10),@dt_ref,101) + ''' and 
							   pdl.dt_conhecimento < DATEADD(month,3,''' + convert(varchar(10),@dt_ref,101) + ''') and 
				               
							   t3.dt_servico >= ''' + convert(varchar(10),@dt_servico,101) + ''' and 
							   t3.dt_servico < DATEADD(month,3,''' + convert(varchar(10),@dt_servico,101) + ''') and 
							   
							   T3.dt_cancelamento is null and 
							   t3.status not in (7) and 
				               
							  (
								  (isnull(t3.vl_Pago_produtividade,0)+isnull(t3.vl_acerto_pgto_produtividade,0)>0)
							--	or
							--	   T3.vl_glosa>0
							   )
							   
							   '
					if  @padrao_idade = 1 -- Maior ou igual a 12 anos 
						set @sql = @sql + ' and dbo.FS_Idade(t4.dt_nascimento,t3.dt_servico)>=12 ' 

					if  @padrao_idade = 2 -- Menor de 12 anos
						set @sql = @sql + ' and dbo.FS_Idade(t4.dt_nascimento,t3.dt_servico)<12 '    
				  
					if @ud_inicial is not null 
					   set @sql = @sql + ' and t3.cd_ud >= ' + convert(varchar(2),@ud_inicial) + '
										   and t3.cd_ud <= ' + convert(varchar(2),@ud_final)


							  -- t3.dt_servico >= ''' + convert(varchar(10),@dt_servico,101) + ''' and 
							  -- t3.dt_servico < DATEADD(month,3,''' + convert(varchar(10),@dt_servico,101) + ''') and 
							  		     
					print @sql     
					exec(@sql)
			 
					FETCH NEXT FROM cursor_gera_sip INTO @cd_categoria_ans , @padrao_idade, @ud_inicial, @ud_final , @peso
				  End    
				  close cursor_gera_sip
				  Deallocate cursor_gera_sip
			 
			  FETCH NEXT FROM cursor_gera_sip_serv INTO @dt_serv
			  End 
			  Close cursor_gera_sip_serv
			  Deallocate cursor_gera_sip_serv
	   	  
	   	  	FETCH NEXT FROM cursor_uf INTO @cd_uf     
	   End 
	   Close cursor_uf
	   Deallocate cursor_uf		

		update ANS_SIP
		  set qt_beneficiarios = s1.qt_beneficiarios
		 from (select distinct ano_trimestre, tipo_empresa, cd_categoria_ans, qt_beneficiarios 
				 from ANS_SIP 
				where ano_trimestre <> CONVERT(varchar(4),@ano)+right('00'+CONVERT(varchar(2),@trimestre),2)
				  and ano_trimestre = ano_trimestre_execucao
				  and cd_arquivo in (select max(cd_arquivo)
									   from ANS_SIP 
									  where ano_trimestre = ano_trimestre_execucao
									  group by ano_trimestre, tipo_empresa, cd_categoria_ans
									 ) 
			   ) as s1
		where ANS_SIP.ano_trimestre = CONVERT(varchar(4),@ano)+right('00'+CONVERT(varchar(2),@trimestre),2) 
		  and ANS_SIP.ano_trimestre_execucao <> ANS_SIP.ano_trimestre 
		  and ANS_SIP.tipo_empresa = s1.tipo_empresa 
		  and ANS_SIP.cd_categoria_ans=s1.cd_categoria_ans
		 -- and ANS_SIP.uf=s1.uf
		  and ANS_SIP.ano_trimestre_execucao=s1.ano_trimestre
		  
		  
		  -- Incluido dia 29.11
		update ANS_SIP 
		   set qt_eventos=0 ,vl_despesa=0
		  WHERE ANO_TRIMESTRE= @ano_trimeste
			and ( (qt_eventos=0 and vl_despesa>0)
				 or
				  (qt_eventos>0 and vl_despesa=0)
				)   

		delete ANS_SIP
		  from (
		select ano_trimestre_execucao, tipo_empresa, uf 
		  from ANS_SIP 
		  WHERE ANO_TRIMESTRE= @ano_trimeste
			and qt_eventos=0 
			and vl_despesa=0
			and cd_categoria_ans=1) as x 
		 where ANS_SIP.ano_trimestre=@ano_trimeste
		   and ANS_SIP.ano_trimestre_execucao = x.ano_trimestre_execucao
		   and ANS_SIP.tipo_empresa=x.tipo_empresa 
		   and ANS_SIP.uf = x.uf 

End 
