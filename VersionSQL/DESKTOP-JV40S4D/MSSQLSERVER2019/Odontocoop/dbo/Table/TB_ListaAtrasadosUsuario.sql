/****** Object:  Table [dbo].[TB_ListaAtrasadosUsuario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ListaAtrasadosUsuario](
	[sequencial] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [int] NULL,
	[tipo_pessoa] [smallint] NULL,
	[cd_filial] [int] NULL,
	[cd_parcela] [int] NULL,
	[dias_atrasado] [int] NULL,
	[nome_usuario] [varchar](20) NULL,
	[data_gerado] [datetime] NULL,
	[status] [smallint] NULL,
	[lista_atual] [smallint] NULL,
	[data_status] [smalldatetime] NULL,
	[Faixa_dias_atrasado] [smallint] NULL,
	[Data_Vencimento] [datetime] NULL,
	[Situacao_Associado] [smallint] NULL,
	[Gerar_Novamente] [smallint] NULL,
 CONSTRAINT [PK_tb_lista_atrasados_usuario] PRIMARY KEY CLUSTERED 
(
	[sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_tb_lista_atrasados_usuario_1] ON [dbo].[TB_ListaAtrasadosUsuario]
(
	[nome_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
