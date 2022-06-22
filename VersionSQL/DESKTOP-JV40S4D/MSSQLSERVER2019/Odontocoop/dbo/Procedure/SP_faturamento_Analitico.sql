/****** Object:  Procedure [dbo].[SP_faturamento_Analitico]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_faturamento_Analitico] 
    @cd_filial int,
    @dt_inicio varchar(10),
    @dt_fim varchar(10), 
    @cd_fp int 
AS
begin

declare @Valor money
declare @Qtde money
declare @codigo int
declare @cd_filial_f int 

if @cd_filial = 0 
 Begin
   select @cd_filial_f = 9999
 End
Else
 Begin
   select @cd_filial_f = @cd_filial
 End 

delete extrato_associado_empresa

insert into extrato_associado_empresa
select cd_empresa,nm_fantasia,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 from empresa 

/* select para os campos FaturadoValor e FaturadoQtde */
DECLARE cursor_atrasado CURSOR FOR 
 SELECT t.codigo, Sum(m.VL_PARCELA),count(m.cd_associado_empresa) 
   FROM mensalidades as m , associados as a, extrato_associado_empresa as t 
  WHERE m.cd_associado_Empresa = a.cd_associado and 
        a.cd_empresa = t.codigo and 
        m.DT_vencimento>= @dt_inicio And 
        m.DT_vencimento<= @dt_fim and 
        m.tp_associado_empresa=1 and 
        a.cd_filial >= @cd_filial and 
        a.cd_filial <= @cd_filial_f and 
        m.cd_tipo_recebimento not in (1,2) and 
        a.cd_tipo_pagamento = @cd_fp
  GROUP BY  t.codigo
   OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
     /* Inserir no campo faturadovalor e FaturadoQtde */ 
    update extrato_associado_empresa 
       set FaturadoValor = @Valor,
           FaturadoQtde = @Qtde
     where codigo = @codigo

     FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
   END
   DEALLOCATE cursor_atrasado

  /* Recebido Periodo */

  DECLARE cursor_atrasado CURSOR FOR 
 SELECT t.codigo, Sum(m.VL_Pago),count(m.cd_associado_empresa) 
   FROM mensalidades as m , associados as a, extrato_associado_empresa as t 
  WHERE m.cd_associado_Empresa = a.cd_associado and 
        a.cd_empresa = t.codigo and 
        m.DT_vencimento>= @dt_inicio And 
        m.DT_vencimento<= @dt_fim and 
        m.DT_pagamento>= @dt_inicio And 
        m.DT_pagamento<= @dt_fim and 
        m.tp_associado_empresa=1 and 
        a.cd_filial >= @cd_filial and 
        a.cd_filial <= @cd_filial_f and 
        a.CD_TIPO_PAGaMENTO = @cd_fp  
  GROUP BY  t.Codigo
   OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
     /* Inserir nos campos Recebidovalor e recebidoQtde*/ 
    update extrato_associado_empresa 
       set recebidoValor = @Valor,
           recebidoQtde = @Qtde
     where codigo = @codigo

     FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
   END
   DEALLOCATE cursor_atrasado

  /* Recebimento Fora do Período */

  DECLARE cursor_atrasado CURSOR FOR 
 SELECT t.Codigo, Sum(m.VL_Pago),count(m.cd_associado_empresa) 
   FROM mensalidades as m , associados as a, extrato_associado_empresa as t 
  WHERE m.cd_associado_Empresa = a.cd_associado and 
        a.cd_empresa = t.codigo and 
        m.DT_pagamento>= @dt_inicio And m.DT_pagamento<= @dt_fim and 
        m.tp_associado_empresa=1 and 
        a.cd_filial >= @cd_filial and a.cd_filial <= @cd_filial_f and 
        a.CD_TIPO_PAGaMENTO = @cd_fp and 
        (m.DT_vencimento< @dt_inicio or m.DT_vencimento> @dt_fim)  
  GROUP BY  t.codigo
   OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
     /* Inserir nos campos RecebidovalorFora e recebidoQtdeFora*/ 
    update extrato_associado_empresa
       set recebidoValorFora = @Valor,
           recebidoQtdeFora = @Qtde
     where codigo = @codigo
      

     FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
   END
   DEALLOCATE cursor_atrasado

   /* Atrasados */

DECLARE cursor_atrasado CURSOR FOR 
 SELECT t.codigo, Sum(m.VL_Parcela),count(m.cd_associado_empresa) 
   FROM mensalidades as m , associados as a, extrato_associado_empresa as t 
  WHERE m.cd_associado_Empresa = a.cd_associado and 
        a.cd_empresa = t.codigo and 
        m.DT_vencimento>= @dt_inicio And 
        m.DT_vencimento<= @dt_fim and 
        m.cd_tipo_recebimento = 0 and 
        m.tp_associado_empresa=1 and 
        a.cd_filial >= @cd_filial and a.cd_filial <= @cd_filial_f and 
        a.CD_TIPO_PAGaMENTO = @cd_fp 
  GROUP BY  t.codigo
   OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
     /* Inserir nos campos Atrasadovalor e AtrasadoQtde*/ 
    update extrato_associado_empresa 
       set atrasadoValor = @Valor,
           atrasadoQtde = @Qtde
     where codigo = @codigo

     FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
   END
   DEALLOCATE cursor_atrasado

  /* Pagamento Fora do Período */

  DECLARE cursor_atrasado CURSOR FOR 
 SELECT t.codigo, Sum(m.VL_Pago),count(m.cd_associado_empresa) 
   FROM mensalidades as m , associados as a, extrato_associado_empresa as t 
  WHERE m.cd_associado_Empresa = a.cd_associado and 
        a.cd_empresa = t.codigo and 
        m.DT_vencimento>= @dt_inicio and m.DT_vencimento<= @dt_fim and 
        m.tp_associado_empresa=1 and 
        a.cd_filial >= @cd_filial and a.cd_filial <= @cd_filial_f and 
        a.CD_TIPO_PAGaMENTO = @cd_fp and 
        (m.DT_pagamento< @dt_inicio or m.DT_pagamento> @dt_fim) 
  GROUP BY  t.codigo
   OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
     /* Inserir nos campos RecebidovalorFora e recebidoQtdeFora*/ 
    update extrato_associado_empresa 
       set PagoValorFora = @Valor,
           PagoQtdeFora = @Qtde
     where codigo = @codigo
      
     FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
   END
   DEALLOCATE cursor_atrasado

/* Peso */

  DECLARE cursor_atrasado CURSOR FOR 
 SELECT T.CODIGO, s.vl_pago_produtividade_CRED, count(m.cd_sequencial) 
   FROM associados as a, extrato_associado_empresa as t , consultas as m , servico as s
  WHERE a.cd_associado = m.cd_Associado and 
        a.CD_empresa = t.codigo and 
        m.cd_servico = s.cd_servico and 
        a.cd_filial >= @cd_filial and a.cd_filial <= @cd_filial_f and 
        m.dt_servico>= @dt_inicio and m.dt_servico<= @dt_fim and 
        a.cd_tipo_pagamento = @cd_fp 
  GROUP BY  T.CODIGO,s.vl_pago_produtividade_CRED
   OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
     /* Inserir nos campos RecebidovalorFora e recebidoQtdeFora*/ 
    if @valor=0 
     Begin
      update extrato_associado_empresa 
         set QtdePeso0 = @Qtde
       where codigo = @codigo
     End
    
    if @valor=1
     Begin
      update extrato_associado_empresa 
         set QtdePeso1 = @Qtde
       where codigo = @codigo
     End

    if @valor=2
     Begin
      update extrato_associado_empresa 
         set QtdePeso2 = @Qtde
       where codigo = @codigo
     End
     
    if @valor=3 
     Begin
      update extrato_associado_empresa 
         set QtdePeso3 = @Qtde
       where codigo = @codigo
     End
 
    if @valor=4
     Begin
      update extrato_associado_empresa 
         set QtdePeso4 = @Qtde
       where codigo = @codigo

     End

     FETCH NEXT FROM cursor_atrasado INTO @codigo, @Valor, @Qtde
   END
   DEALLOCATE cursor_atrasado

   delete extrato_associado_empresa 
    where FaturadoQtde=0 and 
          RecebidoQtde=0 and 
          RecebidoQtdeFora=0 and 
          AtrasadoQtde=0 and 
          PagoQtdeFora=0 and 
          QtdePeso0=0 and 
          QtdePeso1=0 and 
          QtdePeso2=0 and 
          QtdePeso3=0 and 
          QtdePeso4=0

End 
