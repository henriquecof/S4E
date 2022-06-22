/****** Object:  Table [dbo].[regraCadastroContratoEmpresa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[regraCadastroContratoEmpresa](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idRegra] [int] NULL,
	[idEmpresa] [bigint] NULL,
	[InformacoesAdicionais] [varchar](50) NULL,
 CONSTRAINT [PK__regraCad__3213E83F37DC191E] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[regraCadastroContratoEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_EMPRESA_CD_empresa_idEmpresa] FOREIGN KEY([idEmpresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[regraCadastroContratoEmpresa] CHECK CONSTRAINT [FK_EMPRESA_CD_empresa_idEmpresa]
ALTER TABLE [dbo].[regraCadastroContratoEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_regraCadastroContrato_id_idRegra] FOREIGN KEY([idRegra])
REFERENCES [dbo].[regraCadastroContrato] ([id])
ALTER TABLE [dbo].[regraCadastroContratoEmpresa] CHECK CONSTRAINT [FK_regraCadastroContrato_id_idRegra]
