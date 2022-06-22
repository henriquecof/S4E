/****** Object:  Table [dbo].[FaixaCarenciaVidasPlano]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FaixaCarenciaVidasPlano](
	[id] [int] NOT NULL,
	[cd_plano] [int] NOT NULL,
	[minimoVidas] [int] NOT NULL,
	[maximoVidas] [int] NOT NULL,
	[cd_especialidade] [int] NOT NULL,
	[diasCarencia] [int] NOT NULL,
 CONSTRAINT [PK_FaixaCarenciaVidasPlano] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
