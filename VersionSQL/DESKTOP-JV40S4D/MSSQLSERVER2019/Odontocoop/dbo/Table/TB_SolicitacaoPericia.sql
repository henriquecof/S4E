/****** Object:  Table [dbo].[TB_SolicitacaoPericia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_SolicitacaoPericia](
	[speId] [int] IDENTITY(1,1) NOT NULL,
	[speDescricao] [varchar](500) NOT NULL,
	[cd_funcionario_cadastro] [int] NOT NULL,
	[cd_funcionario_analise] [int] NULL,
	[cd_associado] [int] NULL,
	[cd_sequencial_dep] [int] NULL,
	[cd_sequencial_consulta] [int] NULL,
	[speDtCadastro] [datetime] NOT NULL,
	[speDtAceito] [datetime] NULL,
	[speDtRecusado] [datetime] NULL,
	[speDtAnalise] [datetime] NULL,
	[oppId] [smallint] NULL,
 CONSTRAINT [PK_TB_SolicitacaoPericia] PRIMARY KEY CLUSTERED 
(
	[speId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_SolicitacaoPericia]  WITH CHECK ADD  CONSTRAINT [FK_TB_SolicitacaoPericia_OpcaoPericia] FOREIGN KEY([oppId])
REFERENCES [dbo].[OpcaoPericia] ([oppId])
ALTER TABLE [dbo].[TB_SolicitacaoPericia] CHECK CONSTRAINT [FK_TB_SolicitacaoPericia_OpcaoPericia]
