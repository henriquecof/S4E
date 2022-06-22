/****** Object:  Table [dbo].[TelefoniaRetornoBKP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TelefoniaRetornoBKP](
	[treId] [int] NOT NULL,
	[ttrId] [tinyint] NULL,
	[treDtCadastro] [datetime] NOT NULL,
	[treProcessado] [bit] NOT NULL,
	[treProcessadoOuvidor] [bit] NOT NULL,
	[treCaller] [varchar](50) NULL,
	[treCallee] [varchar](50) NULL,
	[treUniqueID] [varchar](50) NULL,
	[treDialStatus] [varchar](50) NULL,
	[treDialedTime] [varchar](50) NULL,
	[cocProtocolo] [varchar](50) NULL,
	[ttcId] [tinyint] NOT NULL,
 CONSTRAINT [PK_TelefoniaRetornoBKP] PRIMARY KEY CLUSTERED 
(
	[treId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TelefoniaRetornoBKP]  WITH CHECK ADD  CONSTRAINT [FK_TelefoniaRetornoBKP_TelefoniaTipoContato] FOREIGN KEY([ttcId])
REFERENCES [dbo].[TelefoniaTipoContato] ([ttcId])
ALTER TABLE [dbo].[TelefoniaRetornoBKP] CHECK CONSTRAINT [FK_TelefoniaRetornoBKP_TelefoniaTipoContato]
ALTER TABLE [dbo].[TelefoniaRetornoBKP]  WITH CHECK ADD  CONSTRAINT [FK_TelefoniaRetornoBKP_TelefoniaTipoRetorno] FOREIGN KEY([ttrId])
REFERENCES [dbo].[TelefoniaTipoRetorno] ([ttrId])
ALTER TABLE [dbo].[TelefoniaRetornoBKP] CHECK CONSTRAINT [FK_TelefoniaRetornoBKP_TelefoniaTipoRetorno]
