CREATE TABLE [dbo].[Users] (
    [UserId]   INT           IDENTITY (1, 1) NOT NULL,
    [Email]    NVARCHAR (50) NULL,
    [Name]     NVARCHAR (50) NULL,
    [Password] NVARCHAR (50) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId] ASC)
);

CREATE TABLE [dbo].[Connections] (
    [Id]           INT              IDENTITY (1, 1) NOT NULL,
    [UserId]       INT              NULL,
    [ConnectionId] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_Connections] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserId_Email] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
);


GO
CREATE NONCLUSTERED INDEX [IX_FK_UserId_Email]
    ON [dbo].[Connections]([UserId] ASC);

CREATE TABLE [dbo].[Messages] (
    [Id]       INT            IDENTITY (1, 1) NOT NULL,
    [Sender]   INT            NULL,
    [Receiver] INT            NULL,
    [Message]  NVARCHAR (MAX) NULL,
    [Date]     DATETIME       NULL,
    CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Sender_User] FOREIGN KEY ([Sender]) REFERENCES [dbo].[Users] ([UserId]),
    CONSTRAINT [FK_Receiver_User] FOREIGN KEY ([Receiver]) REFERENCES [dbo].[Users] ([UserId])
);


GO
CREATE NONCLUSTERED INDEX [IX_FK_Sender_User]
    ON [dbo].[Messages]([Sender] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_FK_Receiver_User]
    ON [dbo].[Messages]([Receiver] ASC);

SET IDENTITY_INSERT [dbo].[Users] ON
INSERT INTO [dbo].[Users] ([UserId], [Email], [Name], [Password]) VALUES (1, N'admin@admin.com', N'Admin', N'123456')
INSERT INTO [dbo].[Users] ([UserId], [Email], [Name], [Password]) VALUES (2, N'u1@chat.com', N'User1', N'123456')
INSERT INTO [dbo].[Users] ([UserId], [Email], [Name], [Password]) VALUES (3, N'u2@chat.com', N'User2', N'123456')
INSERT INTO [dbo].[Users] ([UserId], [Email], [Name], [Password]) VALUES (4, N'u3@chat.com', N'User3', N'123456')
SET IDENTITY_INSERT [dbo].[Users] OFF
