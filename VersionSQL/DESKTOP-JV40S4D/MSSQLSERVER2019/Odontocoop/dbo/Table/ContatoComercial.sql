/****** Object:  Table [dbo].[ContatoComercial]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ContatoComercial](
	[ccoId] [int] IDENTITY(1,1) NOT NULL,
	[ccoNome] [varchar](300) NOT NULL,
	[ccoTelefone] [varchar](50) NULL,
	[ccoCelular] [varchar](50) NOT NULL,
	[ccoCelularOperadora] [smallint] NOT NULL,
	[ccoEmail] [varchar](150) NULL,
	[ccoMelhorHorario] [tinyint] NOT NULL,
	[ccoOBS] [varchar](300) NULL,
	[ccoDataAtualizacao] [datetime] NULL,
 CONSTRAINT [PK_ContatoComercial] PRIMARY KEY CLUSTERED 
(
	[ccoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ContatoComercial]  WITH NOCHECK ADD  CONSTRAINT [FK_ContatoComercial_TB_TipoContato] FOREIGN KEY([ccoCelularOperadora])
REFERENCES [dbo].[TB_TipoContato] ([tteSequencial])
ALTER TABLE [dbo].[ContatoComercial] CHECK CONSTRAINT [FK_ContatoComercial_TB_TipoContato]
