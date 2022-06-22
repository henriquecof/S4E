/****** Object:  Function [dbo].[formatarCNPJ]    Committed by VersionSQL https://www.versionsql.com ******/

Create function [dbo].[formatarCNPJ](@cnpj char(14))			returns char(18)		as		begin			declare @retorno varchar(18)			set @retorno = substring(@cnpj,1,2) + '.' + substring(@cnpj,3,3) + '.' + substring(@cnpj,6,3) + '/' + substring(@cnpj,9,4) + '-' + substring(@cnpj,13,2)			return @retorno		end
