/****** Object:  Table [dbo].[LoteCadastroDepartamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LoteCadastroDepartamento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigoGrupo] [varchar](10) NOT NULL,
	[nomeGrupo] [varchar](20) NULL,
	[dataGravacao] [varchar](50) NULL,
	[numSequencialRegistro] [varchar](6) NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[dataProcesso] [datetime] NULL,
	[quantidade] [int] NULL,
	[arquivo] [varchar](500) NULL,
	[mensagemErro] [varchar](300) NULL,
 CONSTRAINT [PK_LoteCadastrosEmpresa] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LoteCadastroDepartamento]  WITH CHECK ADD  CONSTRAINT [FK_LoteCadastrosEmpresa_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[LoteCadastroDepartamento] CHECK CONSTRAINT [FK_LoteCadastrosEmpresa_FUNCIONARIO]
