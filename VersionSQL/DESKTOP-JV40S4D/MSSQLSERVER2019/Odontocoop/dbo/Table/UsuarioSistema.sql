/****** Object:  Table [dbo].[UsuarioSistema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UsuarioSistema](
	[usiId] [int] IDENTITY(1,1) NOT NULL,
	[usiNome] [varchar](100) NOT NULL,
	[usiEmail] [varchar](100) NOT NULL,
	[usiCPF] [varchar](11) NOT NULL,
	[usiSenha] [varchar](50) NOT NULL,
	[usiAtivo] [bit] NOT NULL,
	[tusId] [smallint] NOT NULL,
	[usiDtCadastro] [datetime] NOT NULL,
	[usiDtExclusao] [datetime] NULL,
 CONSTRAINT [PK_TB_UsuarioSistema] PRIMARY KEY CLUSTERED 
(
	[usiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
