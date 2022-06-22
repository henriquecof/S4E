/****** Object:  Table [dbo].[TB_AvisoUsuario_AUs]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_AvisoUsuario_AUs](
	[SequencialAvisoUsuario_AUs] [int] IDENTITY(1,1) NOT NULL,
	[SequencialAviso_Avi] [int] NOT NULL,
	[cd_associado] [int] NULL,
	[cd_empresa] [int] NULL,
	[cd_funcionario] [int] NULL,
	[DtCadastro_AUs] [datetime] NOT NULL,
	[DtVisualizacao_AUs] [datetime] NULL,
 CONSTRAINT [PK_TB_AvisoUsuario_AUs] PRIMARY KEY CLUSTERED 
(
	[SequencialAvisoUsuario_AUs] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_AvisoUsuario_AUs] ADD  CONSTRAINT [DF_TB_AvisoUsuario_AUs_DtCadastro_AUs]  DEFAULT (getdate()) FOR [DtCadastro_AUs]
ALTER TABLE [dbo].[TB_AvisoUsuario_AUs]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_AvisoUsuario_AUs_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[TB_AvisoUsuario_AUs] CHECK CONSTRAINT [FK_TB_AvisoUsuario_AUs_ASSOCIADOS]
ALTER TABLE [dbo].[TB_AvisoUsuario_AUs]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_AvisoUsuario_AUs_TB_Aviso_Avi] FOREIGN KEY([SequencialAviso_Avi])
REFERENCES [dbo].[TB_Aviso_Avi] ([SequencialAviso_Avi])
ALTER TABLE [dbo].[TB_AvisoUsuario_AUs] CHECK CONSTRAINT [FK_TB_AvisoUsuario_AUs_TB_Aviso_Avi]
