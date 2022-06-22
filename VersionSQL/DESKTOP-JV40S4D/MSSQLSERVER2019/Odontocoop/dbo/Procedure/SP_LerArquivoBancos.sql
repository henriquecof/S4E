/****** Object:  Procedure [dbo].[SP_LerArquivoBancos]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[SP_LerArquivoBancos] 
as
Begin -- 1

print 'odontocob'
    exec [dbo].[SP_LerArquivoBancos_OdontoCob]
print 's4e'
	exec [dbo].[SP_LerArquivoBancos_s4e]

End 
