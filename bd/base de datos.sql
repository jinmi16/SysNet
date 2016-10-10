USE [EJERCITO_BD]
GO
/****** Object:  Schema [SEG]    Script Date: 10/10/2016 17:27:10 ******/
CREATE SCHEMA [SEG]
GO
/****** Object:  StoredProcedure [SEG].[SP_PERSONAL_USUARIO_Insertar]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [SEG].[SP_PERSONAL_USUARIO_Insertar] '0','LIDONIL','VEGA','VEGA','44617765','INGENIERO','JINMI16@GMAIL.COM','1'
CREATE PROCEDURE [SEG].[SP_PERSONAL_USUARIO_Insertar]
@pID_PERSONAL int,
@pNOMBRE varchar(100),
@pPATERNO varchar(100),
@pMATERNO varchar(100),
@pDNI char(8),
@pCARGO varchar(100),
@pCORREO varchar(500),
@activo CHAR(1)


AS
BEGIN
		SET NOCOUNT ON;
			-----------------------
	if(@pID_PERSONAL<1)
	BEGIN
		BEGIN TRY
			  DECLARE @pCONTRASENA VARCHAR(50),@pUSUARIO VARCHAR(40)

			   BEGIN TRAN 
						------------------------------------------------------------------------------------
						--	EXEC [PT].[SP_PERSONAL_Insertar]	@pNOMBRE,@pPATERNO,@pMATERNO,@pDNI,@pCARGO,@pCORREO,@pID_AREA
						INSERT INTO [SEG].[PERSONAL]
							(
							nombre,	paterno,materno,dni,cargo,correo,activo,[fechaRegistro]					
							)VALUES(
							@pNOMBRE,@pPATERNO,@pMATERNO,@pDNI,@pCARGO,@pCORREO,'1',GETDATE()
							)
						
							------------------------------------------------------------------------------------
							SET @pID_PERSONAL= IDENT_CURRENT( '[SEG].[PERSONAL]') 

							SET @pUSUARIO=[SEG].[FN_GennerarUsuario](@pNOMBRE,@pPATERNO,@pMATERNO)
							SET @pCONTRASENA=@pUSUARIO+@pDNI

							INSERT INTO [SEG].[USUARIO]
								(idPersonal,usuario,contrasena,perfilPersonalizado,cambioContraseña,activo,fechaRegistro
)
								VALUES(@pID_PERSONAL,@pUSUARIO,ENCRYPTBYPASSPHRASE('iTeamDevs',@pCONTRASENA),'0','0','1',GETDATE())

							
							
							SELECT 1 AS 'INSERT','EXITO' AS MENSAJE
			   COMMIT TRAN 
		END TRY
		BEGIN CATCH 
				DECLARE @MENSAJE VARCHAR(MAX)
			
				SET @MENSAJE= 'ERROR:: '+'errNumber: '+CONVERT(VARCHAR(5),ERROR_NUMBER())+' errSeverity: '+ CONVERT(VARCHAR(20),ERROR_SEVERITY())+' errState: '+CONVERT(VARCHAR(20),ERROR_STATE())+' errProcedure: '+ERROR_PROCEDURE()+' errLine: '+CONVERT(VARCHAR(20),ERROR_LINE())+' errMessage: '+ERROR_MESSAGE()
		  
			   SELECT 1 AS 'INSERT',@MENSAJE AS MENSAJE
			
 
			   ROLLBACK TRAN 
 
 
		END CATCH
	END
	ELSE
	BEGIN 

			BEGIN TRY
			 

			   BEGIN TRAN 
						------------------------------------------------------------------------------------
						UPDATE SG.PERSONAL SET 
						nombre=@pNOMBRE,
						paterno=@pPATERNO,
						materno=@pMATERNO,
						dni=@pDNI,
						cargo=@pCARGO,
						correo=@pCORREO,
						activo=@activo
					WHERE ID_PERSONAL=@pID_PERSONAL
								
							
							SELECT 1 AS 'MODIFICADO','EXITO' AS MENSAJE
			   COMMIT TRAN 
		END TRY
		BEGIN CATCH 
				DECLARE @MENSAJE2 VARCHAR(MAX)
			
				SET @MENSAJE2= 'ERROR:: '+'errNumber: '+CONVERT(VARCHAR(5),ERROR_NUMBER())+' errSeverity: '+ CONVERT(VARCHAR(20),ERROR_SEVERITY())+' errState: '+CONVERT(VARCHAR(20),ERROR_STATE())+' errProcedure: '+ERROR_PROCEDURE()+' errLine: '+CONVERT(VARCHAR(20),ERROR_LINE())+' errMessage: '+ERROR_MESSAGE()
		  
			   SELECT 1 AS 'MODIFICADO',@MENSAJE2 AS MENSAJE
			
 
			   ROLLBACK TRAN 
 
 
		END CATCH

	END
	
	
	-----------

	
END







GO
/****** Object:  UserDefinedFunction [SEG].[FN_DESENCRIPTAR_CONTRASENA]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  [PT].[FN_DESENCRIPTAR_CONTRASENA] '0x0100000032EEB7240417F1A4C0882F68C0BA70772FE699ECFF28C8CC3C41AB065318F719'
CREATE FUNCTION [SEG].[FN_DESENCRIPTAR_CONTRASENA]
(
    @pCONTRASENA_ENCRIPTADA VARBINARY(8000)
)
RETURNS VARCHAR(100)
AS
BEGIN
    
    
    DECLARE @pCONTRASENA_DESENCRIPTADA AS VARCHAR(100)
    SET @pCONTRASENA_DESENCRIPTADA = DECRYPTBYPASSPHRASE('iTeamDevs',@pCONTRASENA_ENCRIPTADA)
    RETURN @pCONTRASENA_DESENCRIPTADA

END



GO
/****** Object:  UserDefinedFunction [SEG].[FN_GennerarUsuario]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<JINMI LIDONIL VEGA VEGA>
-- Create date: <31-03-2016>
-- Description:	<GENERA EL NOMBRE DE USUARIO>
-- =============================================
CREATE FUNCTION [SEG].[FN_GennerarUsuario]
(
@vNombre varchar(50),
@vPaterno varchar(50), 
@vMaterno varchar(50)

)
RETURNS varchar(100)
AS
BEGIN
	
DECLARE @vCadena varchar(100),@vCadenaAux1 varchar(100)
DECLARE  @CONTADOR INT,@FLAG CHAR(1)
SET @vNombre= [SEG].[FN_QuitarEspacios](@vNombre)
SET @vPaterno=[SEG].[FN_QuitarTodoEspacio](@vPaterno)
SET @vMaterno=[SEG].[FN_QuitarTodoEspacio](@vMaterno)
SET @vCadena= SUBSTRING( @vNombre, 1, 1 )+(CASE CHARINDEX(' ',@vNombre)WHEN 0 THEN '' ELSE SUBSTRING( @vNombre, CHARINDEX(' ',@vNombre)+1 ,1)END)+@vPaterno+SUBSTRING( @vMaterno, 1, 1 )
-------------------------------------------------------------------------------------------------------------------------
SET @CONTADOR=0
SET @FLAG='0'
SET @vCadenaAux1=''
WHILE @FLAG='0'
BEGIN
	IF (EXISTS(SELECT USUARIO FROM SEG.USUARIO WHERE USUARIO=@vCadena+@vCadenaAux1))
	BEGIN
		SET @CONTADOR=@CONTADOR+1
		set @vCadenaAux1=CONVERT(VARCHAR(30),@CONTADOR)			
		SET @FLAG='0'
	END
	ELSE BEGIN	
	SET @vCadena=@vCadena+@vCadenaAux1
		SET @FLAG='1'
	END
END
---------------------------------------------------------------------------------------
SET @vCadena=UPPER([SEG].[FN_RemoverTildes](@vCadena))


		
RETURN @vCadena

END
-------------------
 --  select [BV].[FN_GENERA_USUARIO]('RAFÁEL','VÁRGÁS','SUAREZ')



GO
/****** Object:  UserDefinedFunction [SEG].[FN_QuitarEspacios]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<JINMI LIDONIL>
-- Create date: <31-03-2016>
-- Description:	<QUITA ESPACIOS EN BLACO INICIALES,FINALES E INTERMEDIOS SI EXISTEN MAS DE DOS>
-- 
-- =============================================
CREATE FUNCTION [SEG].[FN_QuitarEspacios]
(
@pCadena VARCHAR(100) 
)
RETURNS VARCHAR(30)
AS
BEGIN
			DECLARE @total INT
			DECLARE @x INT
			DECLARE @letra VARCHAR(20)
			DECLARE @palabra VARCHAR(30)
			DECLARE @contador INT
			SET @contador=0
			SET @palabra=''
			SET @letra=''
			SET @x=1
			while @x<=len(@pCadena)
				BEGIN    
					SET @letra=SUBSTRING(@pCadena,@x,1)  
					IF(@letra=' ')
					BEGIN
						SET @contador=@contador+1   
					END
					ELSE
					BEGIN
						SET @contador=0
					END
					IF(@contador<=1)
					  SET @palabra=@palabra + @letra
				SET @x=@x+1
				END
			RETURN UPPER(LTRIM(RTRIM(@palabra)))



END




GO
/****** Object:  UserDefinedFunction [SEG].[FN_QuitarTodoEspacio]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<JINMI LIDONIL>
-- Create date: <31-03-2016>
-- Description:	<QUITA ESPACIOS EN BLACO,TODO LO DEJA JUNTO>
-- 
-- =============================================
CREATE FUNCTION [SEG].[FN_QuitarTodoEspacio]
(
@pCadena VARCHAR(100) 
)
RETURNS VARCHAR(30)
AS
BEGIN
			DECLARE @total INT
			DECLARE @x INT
			DECLARE @letra VARCHAR(20)
			DECLARE @palabra VARCHAR(30)
			DECLARE @contador INT
			SET @contador=0
			SET @palabra=''
			SET @letra=''
			SET @x=1
			while @x<=len(@pCadena)
				BEGIN    
					SET @letra=SUBSTRING(@pCadena,@x,1)  
					IF(@letra=' ')
					BEGIN
						SET @contador=@contador+1   
					END
					ELSE
					BEGIN
						SET @contador=0
					END
					IF(@contador<1)
					  SET @palabra=@palabra + @letra
				SET @x=@x+1
				END
			RETURN UPPER(LTRIM(RTRIM(@palabra)))



END




GO
/****** Object:  UserDefinedFunction [SEG].[FN_RemoverTildes]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [SEG].[FN_RemoverTildes] ( @Cadena VARCHAR(100) )
RETURNS VARCHAR(100)
AS BEGIN
 
 --Reemplazamos las vocales acentuadas
    RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Cadena, 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u')
 
   END



GO
/****** Object:  Table [SEG].[MENU]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SEG].[MENU](
	[idMenu] [int] IDENTITY(1,1) NOT NULL,
	[menu] [varchar](500) NULL,
	[idMenuPadre] [int] NULL,
	[url] [varchar](500) NULL,
	[menuHabilitado] [char](1) NULL,
	[descripcionMenu] [varchar](500) NULL,
	[icono] [varchar](500) NULL,
 CONSTRAINT [XPKMENU] PRIMARY KEY CLUSTERED 
(
	[idMenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SEG].[PERFIL]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SEG].[PERFIL](
	[idPerrfil] [int] IDENTITY(1,1) NOT NULL,
	[codPerfil] [varchar](500) NULL,
	[Perfil] [varchar](500) NULL,
	[DescripcionPerfil] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[idPerrfil] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SEG].[PERFIL_MENU]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SEG].[PERFIL_MENU](
	[idPerfil] [int] NOT NULL,
	[idMenu] [int] NOT NULL,
	[pemisoLectura] [char](1) NULL,
	[permisoEscritura] [char](1) NULL,
	[permisoEliminacion] [char](1) NULL,
	[idUsuarioRegistro] [int] NULL,
	[fechaRegistro] [datetime] NOT NULL,
 CONSTRAINT [XPKPERFIL_MENU] PRIMARY KEY CLUSTERED 
(
	[idPerfil] ASC,
	[idMenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SEG].[PERSONAL]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SEG].[PERSONAL](
	[idPersonal] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NULL,
	[paterno] [varchar](100) NULL,
	[materno] [varchar](100) NULL,
	[dni] [char](8) NULL,
	[cargo] [varchar](100) NULL,
	[correo] [varchar](500) NULL,
	[activo] [char](1) NULL,
	[fechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[idPersonal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SEG].[TIPO_MENU]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SEG].[TIPO_MENU](
	[idTipoMenu] [int] IDENTITY(1,1) NOT NULL,
	[tipoMenu] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idTipoMenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SEG].[USUARIO]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SEG].[USUARIO](
	[idUsuario] [int] IDENTITY(1,1) NOT NULL,
	[idPersonal] [int] NULL,
	[usuario] [varchar](500) NULL,
	[contrasena] [varbinary](2000) NULL,
	[idPerfil] [int] NULL,
	[perfilPersonalizado] [char](1) NULL,
	[cambioContraseña] [char](1) NULL,
	[activo] [char](1) NULL,
	[fechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[idUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SEG].[USUARIO_MENU_PERSONALIZADO]    Script Date: 10/10/2016 17:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SEG].[USUARIO_MENU_PERSONALIZADO](
	[idUsuario] [int] NOT NULL,
	[idMenu] [int] NOT NULL,
	[pemisoLectura] [char](1) NULL,
	[permisoEscritura] [char](1) NULL,
	[permisoEliminacion] [char](1) NULL,
	[idUsuarioRegistro] [int] NULL,
	[fechaRegistro] [datetime] NOT NULL,
	[flag] [char](1) NOT NULL,
 CONSTRAINT [PK_USUARIO_MENU_PERSONALIZADO_1] PRIMARY KEY CLUSTERED 
(
	[idUsuario] ASC,
	[idMenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [SEG].[PERSONAL] ON 

INSERT [SEG].[PERSONAL] ([idPersonal], [nombre], [paterno], [materno], [dni], [cargo], [correo], [activo], [fechaRegistro]) VALUES (1, N'Jinmi', N'Vega', N'Vega', N'44617765', N'Analista desarrollador', N'jinmi16@gmail.com', N'1', NULL)
INSERT [SEG].[PERSONAL] ([idPersonal], [nombre], [paterno], [materno], [dni], [cargo], [correo], [activo], [fechaRegistro]) VALUES (8, N'LIDONIL', N'VEGA', N'VEGA', N'44617765', N'INGENIERO', N'JINMI16@GMAIL.COM', N'1', CAST(0x0000A69B01177078 AS DateTime))
SET IDENTITY_INSERT [SEG].[PERSONAL] OFF
SET IDENTITY_INSERT [SEG].[USUARIO] ON 

INSERT [SEG].[USUARIO] ([idUsuario], [idPersonal], [usuario], [contrasena], [idPerfil], [perfilPersonalizado], [cambioContraseña], [activo], [fechaRegistro]) VALUES (1, 8, N'LVEGAV', 0x0100000094478E7ED415573AAA9D3E60897582A2E898852DA164633E8A2568E7FB66740A, NULL, N'0', N'0', N'1', CAST(0x0000A69B0117707D AS DateTime))
SET IDENTITY_INSERT [SEG].[USUARIO] OFF
ALTER TABLE [SEG].[MENU]  WITH CHECK ADD  CONSTRAINT [FK_MENU_MENU] FOREIGN KEY([idMenuPadre])
REFERENCES [SEG].[MENU] ([idMenu])
GO
ALTER TABLE [SEG].[MENU] CHECK CONSTRAINT [FK_MENU_MENU]
GO
ALTER TABLE [SEG].[PERFIL_MENU]  WITH CHECK ADD  CONSTRAINT [FK_PERFIL_MENU_MENU] FOREIGN KEY([idMenu])
REFERENCES [SEG].[MENU] ([idMenu])
GO
ALTER TABLE [SEG].[PERFIL_MENU] CHECK CONSTRAINT [FK_PERFIL_MENU_MENU]
GO
ALTER TABLE [SEG].[PERFIL_MENU]  WITH CHECK ADD  CONSTRAINT [FK_PERFIL_MENU_PERFIL] FOREIGN KEY([idMenu])
REFERENCES [SEG].[PERFIL] ([idPerrfil])
GO
ALTER TABLE [SEG].[PERFIL_MENU] CHECK CONSTRAINT [FK_PERFIL_MENU_PERFIL]
GO
ALTER TABLE [SEG].[USUARIO]  WITH CHECK ADD  CONSTRAINT [FK_USUARIO_PERFIL] FOREIGN KEY([idPerfil])
REFERENCES [SEG].[PERFIL] ([idPerrfil])
GO
ALTER TABLE [SEG].[USUARIO] CHECK CONSTRAINT [FK_USUARIO_PERFIL]
GO
ALTER TABLE [SEG].[USUARIO]  WITH CHECK ADD  CONSTRAINT [FK_USUARIO_PERSONAL] FOREIGN KEY([idPersonal])
REFERENCES [SEG].[PERSONAL] ([idPersonal])
GO
ALTER TABLE [SEG].[USUARIO] CHECK CONSTRAINT [FK_USUARIO_PERSONAL]
GO
ALTER TABLE [SEG].[USUARIO_MENU_PERSONALIZADO]  WITH CHECK ADD  CONSTRAINT [FK_USUARIO_MENU_PERSONALIZADO_MENU] FOREIGN KEY([idMenu])
REFERENCES [SEG].[MENU] ([idMenu])
GO
ALTER TABLE [SEG].[USUARIO_MENU_PERSONALIZADO] CHECK CONSTRAINT [FK_USUARIO_MENU_PERSONALIZADO_MENU]
GO
ALTER TABLE [SEG].[USUARIO_MENU_PERSONALIZADO]  WITH CHECK ADD  CONSTRAINT [FK_USUARIO_MENU_PERSONALIZADO_USUARIO] FOREIGN KEY([idUsuario])
REFERENCES [SEG].[USUARIO] ([idUsuario])
GO
ALTER TABLE [SEG].[USUARIO_MENU_PERSONALIZADO] CHECK CONSTRAINT [FK_USUARIO_MENU_PERSONALIZADO_USUARIO]
GO
