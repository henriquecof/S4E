/****** Object:  Table [dbo].[DescricaoConvenio]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DescricaoConvenio](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [varchar](1000) NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
	[situacao] [int] NULL,
	[arquivo] [varchar](250) NULL,
 CONSTRAINT [PK_DescricaoConvenio] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DescricaoConvenio]  WITH CHECK ADD  CONSTRAINT [FK_DescricaoConvenio_DescricaoConvenio] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[DescricaoConvenio] CHECK CONSTRAINT [FK_DescricaoConvenio_DescricaoConvenio]
ALTER TABLE [dbo].[DescricaoConvenio]  WITH CHECK ADD  CONSTRAINT [FK_DescricaoConvenio_FUNCIONARIO] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[DescricaoConvenio] CHECK CONSTRAINT [FK_DescricaoConvenio_FUNCIONARIO]
