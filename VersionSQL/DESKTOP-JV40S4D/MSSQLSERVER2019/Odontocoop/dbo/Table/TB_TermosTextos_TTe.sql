/****** Object:  Table [dbo].[TB_TermosTextos_TTe]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_TermosTextos_TTe](
	[Sequencial_TTe] [int] NOT NULL,
	[Titulo_TTe] [varchar](500) NOT NULL,
	[Texto_TTe] [varchar](max) NOT NULL,
	[cd_tipo_termo_texto] [tinyint] NULL,
	[fl_exibir_titulo_impressao] [bit] NULL,
	[fl_ativo] [bit] NULL,
	[Logomarca_TTe] [varchar](50) NULL,
	[tp_empresa] [tinyint] NULL,
 CONSTRAINT [PK_TB_TermosTextos_TTe] PRIMARY KEY CLUSTERED 
(
	[Sequencial_TTe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TB_TermosTextos_TTe]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_TermosTextos_TTe_TipoTermosTextos] FOREIGN KEY([cd_tipo_termo_texto])
REFERENCES [dbo].[TipoTermosTextos] ([cd_tipo_termo_texto])
ALTER TABLE [dbo].[TB_TermosTextos_TTe] CHECK CONSTRAINT [FK_TB_TermosTextos_TTe_TipoTermosTextos]
