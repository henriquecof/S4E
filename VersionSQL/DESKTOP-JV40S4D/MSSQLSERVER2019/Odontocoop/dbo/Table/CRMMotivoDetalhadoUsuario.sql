/****** Object:  Table [dbo].[CRMMotivoDetalhadoUsuario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMMotivoDetalhadoUsuario](
	[mdeId] [smallint] NOT NULL,
	[Usuario] [int] NOT NULL,
	[tusId] [tinyint] NOT NULL,
 CONSTRAINT [PK_CRMMotivoDetalhado_FuncionarioAcompanhamento] PRIMARY KEY CLUSTERED 
(
	[mdeId] ASC,
	[Usuario] ASC,
	[tusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
