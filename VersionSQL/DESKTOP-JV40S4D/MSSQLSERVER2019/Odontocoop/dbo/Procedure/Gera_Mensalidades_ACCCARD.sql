/****** Object:  Procedure [dbo].[Gera_Mensalidades_ACCCARD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  procedure [dbo].[Gera_Mensalidades_ACCCARD]
as
begin
	declare @dtvenc datetime
	declare @counter int
	declare @day int
	set @dtvenc = convert(datetime,convert(varchar(10),getdate(),101))
	set @counter = 1
	while (@counter < 35)
	begin
		print @dtvenc
		set @day = day(@dtvenc)
		exec SP_GERA_MENSALIDADE_ASS 3, @dtvenc, @day, 0, 'SYS'
		set @counter = @counter + 1
		set @dtvenc = dateadd(day,1,@dtvenc)
	end
end
