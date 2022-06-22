/****** Object:  Procedure [dbo].[ps_modifica]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[ps_modifica]
as
begin

update consultas set
nr_numero_lote = -1
where dt_servico is not null and
      dt_cancelamento is null and
      nr_numero_lote is null and
      cd_filial in (select cd_filial from filial where cd_clinica <> 2) and
      dt_servico <= '06/30/2009'
end
