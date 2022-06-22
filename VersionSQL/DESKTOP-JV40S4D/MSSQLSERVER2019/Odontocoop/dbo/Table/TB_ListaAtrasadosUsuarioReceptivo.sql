/****** Object:  Table [dbo].[TB_ListaAtrasadosUsuarioReceptivo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ListaAtrasadosUsuarioReceptivo](
	[sequencial] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [int] NULL,
	[tipo_pessoa] [int] NULL,
	[data] [smalldatetime] NULL,
	[comentario] [varchar](4000) NULL,
	[status] [smallint] NULL,
	[cd_funcionario] [int] NULL,
 CONSTRAINT [PK_TB_ListaAtrasadosUsuarioReceptivo] PRIMARY KEY CLUSTERED 
(
	[sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_ListaAtrasadosUsuarioReceptivo] ADD  CONSTRAINT [DF_TB_ListaAtrasadosUsuarioReceptivo_status]  DEFAULT ((1)) FOR [status]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 - Ligação Recebida
2 - Providência Tomada
3 - Outros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_ListaAtrasadosUsuarioReceptivo', @level2type=N'COLUMN',@level2name=N'status'
