/****** Object:  Function [dbo].[FS_ContaDiasUteisVencimento]    Committed by VersionSQL https://www.versionsql.com ******/

Create function [dbo].[FS_ContaDiasUteisVencimento] (@Dataini date , @DataFim date)  
	RETURNS Int  
	AS  
	BEGIN  
		
	Declare @CountdiaUtil Int = 0
	declare @dataSeguinte date = @Dataini

	While @dataSeguinte <= @DataFim and @CountdiaUtil <= 1
	Begin  
		If (DatePart(WeekDay, @dataSeguinte) not In (1,7) and (select count(0) from crmferiado where ferdata = @dataSeguinte) = 0) or @CountdiaUtil>0
		begin
			set @CountdiaUtil = @CountdiaUtil + 1 
		end
		set @dataSeguinte = Dateadd(day,1,@dataSeguinte)
	End


	if (@CountdiaUtil <=1)
	begin
		return 0
	end

	return datediff(day,@Dataini,@DataFim)
END 
