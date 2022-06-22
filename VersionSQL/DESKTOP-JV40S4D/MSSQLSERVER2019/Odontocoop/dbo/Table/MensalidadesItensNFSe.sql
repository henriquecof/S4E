/****** Object:  Table [dbo].[MensalidadesItensNFSe]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MensalidadesItensNFSe](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_parcela] [int] NOT NULL,
	[descricao] [varchar](300) NOT NULL,
	[valorUnitario] [money] NOT NULL,
	[quantidade] [int] NOT NULL,
	[dataCadastro] [datetime] NULL,
	[usuarioCadastro] [int] NULL,
	[dataExclusao] [datetime] NULL,
	[usuarioExclusao] [int] NULL,
 CONSTRAINT [PK_MensalidadesItensNFSe] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MensalidadesItensNFSe]  WITH CHECK ADD  CONSTRAINT [FK_MensalidadesItensNFSe_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[MensalidadesItensNFSe] CHECK CONSTRAINT [FK_MensalidadesItensNFSe_FUNCIONARIO]
ALTER TABLE [dbo].[MensalidadesItensNFSe]  WITH CHECK ADD  CONSTRAINT [FK_MensalidadesItensNFSe_FUNCIONARIO1] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[MensalidadesItensNFSe] CHECK CONSTRAINT [FK_MensalidadesItensNFSe_FUNCIONARIO1]
ALTER TABLE [dbo].[MensalidadesItensNFSe]  WITH CHECK ADD  CONSTRAINT [FK_MensalidadesItensNFSe_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[MensalidadesItensNFSe] CHECK CONSTRAINT [FK_MensalidadesItensNFSe_MENSALIDADES]
