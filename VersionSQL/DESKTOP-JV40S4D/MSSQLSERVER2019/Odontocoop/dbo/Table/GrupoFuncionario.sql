/****** Object:  Table [dbo].[GrupoFuncionario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoFuncionario](
	[gfuId] [int] IDENTITY(1,1) NOT NULL,
	[gfuDescricao] [varchar](50) NOT NULL,
	[gfuUsuarioCadastro] [int] NOT NULL,
	[gfuDtCadastro] [datetime] NOT NULL,
	[gfuUsuarioExclusao] [int] NULL,
	[gfuDtExclusao] [datetime] NULL,
 CONSTRAINT [PK_GrupoFuncionario] PRIMARY KEY CLUSTERED 
(
	[gfuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
