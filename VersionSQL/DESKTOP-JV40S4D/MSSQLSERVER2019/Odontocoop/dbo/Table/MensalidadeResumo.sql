/****** Object:  Table [dbo].[MensalidadeResumo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MensalidadeResumo](
	[codigo] [int] NOT NULL,
	[tipo] [smallint] NOT NULL,
	[dias] [int] NOT NULL,
	[situacao] [int] NOT NULL,
	[cd_seqdep] [int] NULL,
	[qtde] [money] NULL,
	[valor] [money] NULL,
	[uso] [money] NULL,
	[vl_totalplano] [money] NULL,
	[dt_asscto] [datetime] NULL,
	[dt_venccto] [datetime] NULL,
	[nr_contrato] [varchar](20) NULL,
	[dt_nascimento] [datetime] NULL,
	[cpf] [varchar](11) NULL,
	[vl_plano] [money] NULL,
	[qt_meses] [int] NULL,
	[qtde_abertas] [int] NULL,
 CONSTRAINT [PK_MensalidadeResumo_1] PRIMARY KEY NONCLUSTERED 
(
	[codigo] ASC,
	[tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
