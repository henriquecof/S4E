/****** Object:  Function [dbo].[formatarCPF]    Committed by VersionSQL https://www.versionsql.com ******/

Create function [dbo].[formatarCPF](@cpf char(11))			 returns char(14)		as		begin			 declare @retorno varchar(14)			 set @retorno = substring(@cpf,1,3) + '.' + substring(@cpf,4,3) + '.' + substring(@cpf,7,3) + '-' + substring(@cpf,10,2) 			 return @retorno		end
