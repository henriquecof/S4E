/****** Object:  Table [dbo].[mensalidades_planos_temp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[mensalidades_planos_temp](
	[cd_empresa] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_plano] [int] NOT NULL,
	[valor] [money] NOT NULL,
	[cd_tipo_parcela] [smallint] NOT NULL,
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_mensalidade_plano_temp] PRIMARY KEY CLUSTERED 
(
	[cd_empresa] ASC,
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
