/****** Object:  Table [dbo].[DadosDMED]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DadosDMED](
	[ddmId] [int] IDENTITY(1,1) NOT NULL,
	[ddmDECPJCNPJ] [varchar](14) NOT NULL,
	[ddmDECPJNomeEmpresarial] [varchar](150) NOT NULL,
	[ddmDECPJTipoDeclarante] [tinyint] NOT NULL,
	[ddmDECPJRegistroANS] [varchar](6) NULL,
	[ddmDECPJCNES] [varchar](7) NULL,
	[ddmDECPJCPFResponsavel] [varchar](11) NOT NULL,
	[ddmDECPJIndicadorSituacaoDeclaracao] [varchar](1) NOT NULL,
	[ddmRESPCPF] [varchar](11) NOT NULL,
	[ddmRESPNome] [varchar](60) NOT NULL,
	[ddmRESPDDDResponsavel] [varchar](2) NOT NULL,
	[ddmRESPTelefone] [varchar](9) NOT NULL,
	[ddmRESPRamal] [varchar](6) NULL,
	[ddmRESPFax] [varchar](9) NULL,
	[ddmRESPEmail] [varchar](50) NULL,
	[ddmDtCadastro] [datetime] NOT NULL,
	[ddmUsuarioCadastro] [int] NOT NULL,
	[ddmDtAlteracao] [datetime] NULL,
	[ddmUsuarioAlteracao] [int] NULL,
	[ddmDtExclusao] [datetime] NULL,
	[ddmUsuarioExclusao] [int] NULL,
	[ddmDescricao] [varchar](50) NULL,
	[ddmRESPNrCRC] [varchar](10) NULL,
 CONSTRAINT [PK_DadosDMED] PRIMARY KEY CLUSTERED 
(
	[ddmId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DadosDMED]  WITH NOCHECK ADD  CONSTRAINT [FK_DadosDMED_FUNCIONARIO] FOREIGN KEY([ddmUsuarioAlteracao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[DadosDMED] CHECK CONSTRAINT [FK_DadosDMED_FUNCIONARIO]
ALTER TABLE [dbo].[DadosDMED]  WITH NOCHECK ADD  CONSTRAINT [FK_DadosDMED_FUNCIONARIO1] FOREIGN KEY([ddmUsuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[DadosDMED] CHECK CONSTRAINT [FK_DadosDMED_FUNCIONARIO1]
ALTER TABLE [dbo].[DadosDMED]  WITH NOCHECK ADD  CONSTRAINT [FK_DadosDMED_FUNCIONARIO2] FOREIGN KEY([ddmUsuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[DadosDMED] CHECK CONSTRAINT [FK_DadosDMED_FUNCIONARIO2]
