/****** Object:  Table [dbo].[TB_ListaAtrasadosFuncionario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ListaAtrasadosFuncionario](
	[sequencial_ListaAtrasadosFuncionario] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [int] NULL,
	[tipo_pessoa] [smallint] NULL,
	[nome_funcionario] [varchar](20) NULL,
	[data_agenda] [smalldatetime] NULL,
 CONSTRAINT [PK_TB_ListaAtrasadosFuncionario] PRIMARY KEY CLUSTERED 
(
	[sequencial_ListaAtrasadosFuncionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
