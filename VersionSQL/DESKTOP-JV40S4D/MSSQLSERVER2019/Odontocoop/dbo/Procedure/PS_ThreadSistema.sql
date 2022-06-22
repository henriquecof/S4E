/****** Object:  Procedure [dbo].[PS_ThreadSistema]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_ThreadSistema]
AS
BEGIN TRY
	SET NOCOUNT ON;

	Declare @idProcessos varchar(max)
	Declare @id integer
	Declare @descricao varchar(1000)
	Declare @SQL varchar(max)
	Declare @mensagemUsuario varchar(1000)

	select
	@idProcessos =
	isnull(
	substring(
	(
		select ',' + convert(varchar(10),id) 'data()'
		from ThreadSistema
		where isnull(execucaoSQL,0) = 1
		and dataExecucaoSQL is null
		and dataExclusao is null
		order by isnull(prioridade,1) desc, dataCadastro asc
		For XML PATH ('')
	), 2, 8000)
	,'')
	
	if (@idProcessos <> '')
		begin
			set @SQL = ''

			set @SQL = @SQL + ' update ThreadSistema '
			set @SQL = @SQL + ' set dataExecucaoSQL = getdate() '
			set @SQL = @SQL + ' where id in (' + @idProcessos + ') '
			
			set @SQL = @SQL + ' Declare cursor_thread CURSOR FOR '
			set @SQL = @SQL + ' select id, isnull(descricao,''''), isnull(comandoCompleto,'''') '
			set @SQL = @SQL + ' from ThreadSistema '
			set @SQL = @SQL + ' where id in (' + @idProcessos + ') '
			set @SQL = @SQL + ' order by dataCadastro asc '
		
			exec(@SQL)
			
			set @SQL = ''
			
			OPEN cursor_thread
			FETCH NEXT FROM cursor_thread INTO @id, @descricao, @SQL
			WHILE (@@FETCH_STATUS <> -1)
				BEGIN
					update ThreadSistema
					set dataExecucaoSQL = getdate()
					where id = @id
					
					if (@SQL = '')
						begin
							update ThreadSistema
							set dataConclusao = getdate(),
							mensagemUsuario = @descricao + ' [Comando de execução não encontrado]'
							where id = @id
						end
					else
						begin
							exec(@SQL)

							update ThreadSistema
							set dataConclusao = getdate(),
							mensagemUsuario = @descricao + ' [Realizado com sucesso]'
							where id = @id
						end
					
					FETCH NEXT FROM cursor_thread INTO @id, @descricao, @SQL
				End
			Close cursor_thread
			Deallocate cursor_thread
		end

	print 'Thread SQL executada'
END TRY
BEGIN CATCH
	set @mensagemUsuario = left(@descricao + ' [' + replace(replace(replace(ERROR_MESSAGE(),'''',''),char(10),' '),char(13), ' ') + ']',1000)

	set @SQL = ''
	set @SQL = @SQL + ' Close cursor_thread '
	set @SQL = @SQL + ' Deallocate cursor_thread '
	
	set @SQL = @SQL + ' update ThreadSistema '
	set @SQL = @SQL + ' set dataConclusao = getdate(), '
	set @SQL = @SQL + ' mensagemUsuario = ''' + @mensagemUsuario + ''' '
	set @SQL = @SQL + ' where id = ' + convert(varchar(10),@id)
	
	set @SQL = @SQL + ' update ThreadSistema '
	set @SQL = @SQL + ' set dataExecucaoSQL = null '
	set @SQL = @SQL + ' where id in (' + @idProcessos + ') '
	set @SQL = @SQL + ' and id > ' + convert(varchar(10),@id)
	
	exec(@SQL)

	print 'Thread SQL executada com erro'
END CATCH
