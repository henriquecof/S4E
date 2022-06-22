/****** Object:  Procedure [dbo].[ps_updateconsultas]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[ps_updateconsultas]
as 
begin
update consultas set
consultas.nr_numero_lote = -1
from  filial 
where consultas.cd_filial = filial.cd_filial
and filial.cd_clinica <> 2
and consultas.dt_servico is not null
and consultas.dt_servico <= '05/31/2009'
and consultas.nr_numero_lote is null
end
