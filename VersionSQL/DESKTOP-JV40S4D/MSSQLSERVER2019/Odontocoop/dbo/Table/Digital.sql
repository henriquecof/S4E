/****** Object:  Table [dbo].[Digital]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Digital](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_origeminformacao] [int] NOT NULL,
	[cd_sequencialOrigem] [int] NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[cd_funcionario_exclusao] [int] NULL,
	[nr_cpfresponsavel] [varchar](11) NULL,
	[digital] [ntext] NULL,
	[cd_funcionario_cadastro] [int] NULL,
	[facial] [varchar](max) NULL,
	[identificadorExterno] [varchar](100) NULL,
 CONSTRAINT [PK_Digital] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Digital]  WITH NOCHECK ADD  CONSTRAINT [FK_Digital_TB_OrigemInformacao] FOREIGN KEY([cd_origeminformacao])
REFERENCES [dbo].[TB_OrigemInformacao] ([cd_origeminformacao])
ALTER TABLE [dbo].[Digital] CHECK CONSTRAINT [FK_Digital_TB_OrigemInformacao]
