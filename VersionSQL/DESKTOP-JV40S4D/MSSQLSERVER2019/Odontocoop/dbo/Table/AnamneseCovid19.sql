/****** Object:  Table [dbo].[AnamneseCovid19]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AnamneseCovid19](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[tipoUsuarioCadastro] [tinyint] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[ip] [varchar](50) NOT NULL,
	[febre] [bit] NULL,
	[febreUltimosDias] [bit] NULL,
	[tosseUltimosDias] [bit] NULL,
	[alteracaoPaladarOlfatoUltimosDias] [bit] NULL,
	[viajouUltimosDias] [bit] NULL,
	[contatoPacienteDiagnosticadoUltimosDias] [bit] NULL,
	[encontroMuitasPessoasDesconhecidas] [bit] NULL,
	[transitaPredio] [bit] NULL,
	[circulaElevador] [bit] NULL,
	[trabalhaAreaSaude] [bit] NULL,
	[dorCabecaIntensa] [bit] NULL,
	[desarranjoIntestinal] [bit] NULL,
	[obs] [varchar](max) NULL,
	[clinica] [int] NULL,
	[dentista] [int] NULL,
 CONSTRAINT [PK_AnamneseCovid19] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[AnamneseCovid19]  WITH CHECK ADD  CONSTRAINT [FK_AnamneseCovid19_Dentista] FOREIGN KEY([dentista])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[AnamneseCovid19] CHECK CONSTRAINT [FK_AnamneseCovid19_Dentista]
ALTER TABLE [dbo].[AnamneseCovid19]  WITH CHECK ADD  CONSTRAINT [FK_AnamneseCovid19_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[AnamneseCovid19] CHECK CONSTRAINT [FK_AnamneseCovid19_DEPENDENTES]
ALTER TABLE [dbo].[AnamneseCovid19]  WITH CHECK ADD  CONSTRAINT [FK_AnamneseCovid19_Filial] FOREIGN KEY([clinica])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[AnamneseCovid19] CHECK CONSTRAINT [FK_AnamneseCovid19_Filial]
