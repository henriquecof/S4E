/****** Object:  Function [dbo].[converter_moeda]    Committed by VersionSQL https://www.versionsql.com ******/

create function [dbo].[converter_moeda] (@valor as money, @cultura as nvarchar(5)) returns nvarchar(40)
as begin return (
    select case @cultura
        when 'pt-br' then 'R$ ' + replace(replace(replace(
            convert(nvarchar, @valor, 1), --converte para o formato "moeda americana"
            '.', '|'), -- substitui . por | somente para separar o inteiro das casas decimais
            ',', '.'), -- substitui , por . (separador de milhar no brasil)
            '|', ',')  -- substitui | por , (separador de decimais)
        when 'en-gb' then '£' + convert(nvarchar, @valor, 1) -- United Kingdom
        when 'en-us' then '$' + convert(nvarchar, @valor, 1) -- us
        when 'de-de' then replace(replace(replace(convert(nvarchar, @valor, 1),'.', '|'), ',', '.'), '|', ',')  + ' €' -- german
        when 'ja-jp' then '¥' + convert(nvarchar, @valor, 1)
        else '$ ' + convert(nvarchar, @valor, 1) -- us (padrão)
    end
    )
end
