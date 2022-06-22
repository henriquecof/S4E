/****** Object:  Table [dbo].[excelToSqlAgenda]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[excelToSqlAgenda](
	[NOME_DENTISTA] [nvarchar](255) NULL,
	[Data] [datetime] NULL,
	[HoraInicio] [nvarchar](255) NULL,
	[HoraFim] [nvarchar](255) NULL,
	[MOTIVO] [nvarchar](255) NULL,
	[NOME] [nvarchar](255) NULL,
	[CODASSOC] [nvarchar](255) NULL,
	[cd_funcionario] [int] NULL,
	[hr_compromisso] [int] NULL,
	[cd_id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_atuacao_dent] [int] NULL,
 CONSTRAINT [PK_excelToSqlAgenda] PRIMARY KEY CLUSTERED 
(
	[cd_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
