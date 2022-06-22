/****** Object:  Table [dbo].[ArquivoPonto]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ArquivoPonto](
	[arpId] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial] [int] NOT NULL,
	[arpUsuExclusao] [int] NULL,
	[arpDtExclusao] [datetime] NULL,
	[arpNome] [varchar](50) NOT NULL,
	[arpExtensao] [varchar](5) NOT NULL,
	[arpUsuInclusao] [int] NULL,
	[arpDtInclusao] [datetime] NULL,
 CONSTRAINT [PK_ArquivoPonto] PRIMARY KEY CLUSTERED 
(
	[arpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ArquivoPonto]  WITH CHECK ADD  CONSTRAINT [FK_ArquivoPonto_Funcionario_BatePonto] FOREIGN KEY([cd_sequencial])
REFERENCES [dbo].[Funcionario_BatePonto] ([cd_sequencial])
ALTER TABLE [dbo].[ArquivoPonto] CHECK CONSTRAINT [FK_ArquivoPonto_Funcionario_BatePonto]
