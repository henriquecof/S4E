/****** Object:  Table [dbo].[DadosBancariosLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DadosBancariosLog](
	[cdSequencial] [int] IDENTITY(1,1) NOT NULL,
	[agencia] [varchar](50) NULL,
	[agencia_dv] [varchar](2) NULL,
	[nr_conta] [varchar](20) NULL,
	[nr_conta_DV] [varchar](2) NULL,
	[nr_autorizacao] [varchar](20) NULL,
	[cd_bandeira] [int] NULL,
	[nr_conta_operacao] [int] NULL,
	[val_cartao] [varchar](6) NULL,
	[cd_seguranca] [varchar](4) NULL,
	[cd_associado] [int] NOT NULL,
	[cd_empresa] [bigint] NOT NULL,
	[dt_exclusao] [datetime] NOT NULL,
	[cd_usuario_exclusao] [int] NOT NULL,
 CONSTRAINT [PK__DadosBan__99F9077A2AE904F8] PRIMARY KEY CLUSTERED 
(
	[cdSequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DadosBancariosLog]  WITH CHECK ADD  CONSTRAINT [FK__DadosBanc__cd_as__2CD14D6A] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[DadosBancariosLog] CHECK CONSTRAINT [FK__DadosBanc__cd_as__2CD14D6A]
ALTER TABLE [dbo].[DadosBancariosLog]  WITH CHECK ADD  CONSTRAINT [FK__DadosBanc__cd_em__2EB995DC] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[DadosBancariosLog] CHECK CONSTRAINT [FK__DadosBanc__cd_em__2EB995DC]
ALTER TABLE [dbo].[DadosBancariosLog]  WITH CHECK ADD  CONSTRAINT [FK__DadosBanc__cd_us__2FADBA15] FOREIGN KEY([cd_usuario_exclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[DadosBancariosLog] CHECK CONSTRAINT [FK__DadosBanc__cd_us__2FADBA15]
