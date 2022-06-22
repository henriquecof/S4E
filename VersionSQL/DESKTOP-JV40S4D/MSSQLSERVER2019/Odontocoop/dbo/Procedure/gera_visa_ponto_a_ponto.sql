/****** Object:  Procedure [dbo].[gera_visa_ponto_a_ponto]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[gera_visa_ponto_a_ponto]
	@v_base datetime
as

begin

declare @v_dia int
declare @v_venc datetime


if (@v_base is null) set @v_base=getdate()
/*set @v_base='10/08/2004'*/
set @v_dia=1
while (@v_dia<31)
begin
	set @v_venc = convert(datetime, 
	right('00' + convert(varchar(2),month(@v_base)),2) 
	+ '/' + 
	right('00' + convert(varchar(2),@v_dia),2) 
	+ '/' + 
	right('00' + convert(varchar(4),year(@v_base)),4))

	if (month(@v_base)=2 and @v_dia>28) 
		set @v_venc = convert(datetime, '02/28/' + right('00' + convert(varchar(4),year(@v_base)),4))

	exec SP_GERA_MENSALIDADE_ASS 21, @v_venc, @v_dia, 0, 'SYS'

	set @v_dia=@v_dia+1
end

end
