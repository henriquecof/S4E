/****** Object:  Table [dbo].[MobileConfig]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MobileConfig](
	[id] [int] NOT NULL,
	[agenda] [bit] NULL,
	[marcacao_multipla] [bit] NULL,
	[carteira] [bit] NULL,
	[telefone_usuario_plano] [varchar](50) NULL,
	[telefone_usuario_prestador] [varchar](50) NULL,
	[email_usuario_plano] [varchar](50) NULL,
	[email_usuario_prestador] [varchar](50) NULL,
	[site] [varchar](50) NULL,
	[versao_ios] [varchar](50) NULL,
	[versao_android] [varchar](50) NULL,
	[mensagem_primeiro_acesso] [varchar](500) NULL,
	[orto_clinica_fixa] [bit] NULL,
	[mensagem_especialidade] [varchar](500) NULL,
	[mensagem_clinicas] [varchar](500) NULL,
	[url_seja_nosso_cliente] [varchar](500) NULL,
	[usa_lat_lon] [bit] NULL,
 CONSTRAINT [PK_MobileConfig] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
