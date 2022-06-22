/****** Object:  Table [dbo].[TelefoniaRetorno]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TelefoniaRetorno](
	[treId] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [PK_TelefoniaRetorno] PRIMARY KEY CLUSTERED 
(
	[treId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TelefoniaRetorno]  WITH CHECK ADD  CONSTRAINT [FK_TelefoniaRetorno_TelefoniaTipoContato] FOREIGN KEY([ttcId])
REFERENCES [dbo].[TelefoniaTipoContato] ([ttcId])
ALTER TABLE [dbo].[TelefoniaRetorno] CHECK CONSTRAINT [FK_TelefoniaRetorno_TelefoniaTipoContato]
ALTER TABLE [dbo].[TelefoniaRetorno]  WITH CHECK ADD  CONSTRAINT [FK_TelefoniaRetorno_TelefoniaTipoRetorno] FOREIGN KEY([ttrId])
REFERENCES [dbo].[TelefoniaTipoRetorno] ([ttrId])
ALTER TABLE [dbo].[TelefoniaRetorno] CHECK CONSTRAINT [FK_TelefoniaRetorno_TelefoniaTipoRetorno]
