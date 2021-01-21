
--Linked Server with both Windows Authentication and SQL Authentication.   Windows Authentication is setup for impoersonation.
EXEC master.dbo.sp_addlinkedserver @server = N'RAIDER8\I1', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RAIDER8\I1',@useself=N'False',@locallogin=NULL,@rmtuser=N'Res',@rmtpassword='########'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RAIDER6\I1',@useself=N'True',@locallogin=N'COLO\SQLt',@rmtuser=NULL,@rmtpassword=NULL
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RAIDER6\I1',@useself=N'True',@locallogin=N'COLO\Res',@rmtuser=NULL,@rmtpassword=NULL




--SSAS Linked Server with login defined.
EXEC master.dbo.sp_addlinkedserver
@server = N'SSAS', -- name of linked server
@srvproduct=N'', 
@provider=N'MSOLAP', -- see list of providers avaoilable on SQL Server under Linked Server > Prover node in SSMS Object Browser
@datasrc=N'colo1-analysis1', -- machine that host Analysis Services
@catalog=N'DW' -- Analysis Services database (cube)




exec master.dbo.sp_droplinkedsrvlogin 'RAIDER8\I1', 'COLO\SQLAgentAccount'


select *
from openquery (ssas, 'select [Measures].[Cart Revenue] on 0 from [Target Session]')





----------------
----------------
--SSAS example using impersonation and hopefully delegation.

/****** Object:  LinkedServer [colo1-analysis1]    Script Date: 03/05/2013 19:42:03 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'colo1-analysis1', @provider=N'MSOLAP', @datasrc=N'colo1-analysis1', @catalog=N'DWPeapod'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'colo1-analysis1',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL

GO

EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'colo1-analysis1', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

------------------------------
------------------------------
--Open Rowset Example

select *
from OpenRowset('MSOLAP'
,'DATASOURCE=COLO1-ANALYSIS1;CATALOG = DWPeapod'
,'select [Measures].[Cart Revenue] on 0 from [Target Session]')


select cube_name, datename(dw,dateadd(hour,-7,last_data_update)),
dateadd(hour,-7,last_data_update) as last_update 
from
OpenRowset('MSOLAP','DATASOURCE=COLO1-ANALYSIS1; Catalog=StaplesDataMart;',
'SELECT CUBE_NAME, LAST_DATA_UPDATE 
FROM $System.MDSCHEMA_CUBES') as t
order by last_update desc


DECLARE @SQL NVARCHAR(MAX)
SELECT @SQL = 'select cube_name, datename(dw,dateadd(hour,-7,last_data_update)),
dateadd(hour,-7,last_data_update) as last_update from
OpenRowset(''MSOLAP'',''DATASOURCE=COLO1-ANALYSIS1; Initial Catalog=StaplesDataMart;'',
''SELECT CUBE_NAME, LAST_DATA_UPDATE 
FROM $System.MDSCHEMA_CUBES'') as t
order by last_update desc'
EXEC sp_executesql @SQL

sp_configure 'show advanced options',1
go

reconfigure
go

sp_configure
GO


-----------------------------------------------------------------------
-------------------------------------------------------------------------
--Loopback linked server example.


EXEC sys.sp_addlinkedserver @server = 'resadmindb', -- sysname
    @srvproduct = N'', -- nvarchar(128)
    @provider = N'SQLNCLI', -- nvarchar(128)
    @datasrc = N'Raider01', -- nvarchar(4000)
    @location = NULL, -- nvarchar(4000)
    @provstr = NULL, -- nvarchar(4000)
    @catalog = NULL -- sysname

--Loopback to different instance on same server.
/****** Object:  LinkedServer [CHDC\DATAMARTDEV]    Script Date: 6/12/2019 4:14:34 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'CHDC\DATAMARTDEV', @srvproduct=N'', @provider=N'SQLNCLI', @datasrc=N'127.0.0.1\datamartdev'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'CHDC\DATAMARTDEV',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO

    
    
    
SELECT *
FROM test.reportserver.dbo.ActiveSubscriptions


SELECT *
FROM reportserver.dbo.ActiveSubscriptions
    
    
    
    
----------------------
----------------------
--Normal linked server for windows authentication
    
EXEC sp_addlinkedserver 'Reporting3', N'SQL Server'
EXEC sp_addlinkedsrvlogin 'Reporting3', 'true'

EXEC sp_addlinkedserver 'Raider5\I1', N'SQL Server'
EXEC sp_addlinkedsrvlogin 'Raider5\I1', 'true'

EXEC sp_addlinkedserver 'PT1', N'SQL Server'
EXEC sp_addlinkedsrvlogin 'PT1', 'true'



------------------------------


SELECT *
FROM sys.servers

sp_dropserver '[dev-base]' 


---------------------------------------
---------------------------------------

--Linked server for both Windows authentication and SQL Server authentication.

/****** Object:  LinkedServer [RAIDER8\I1]    Script Date: 3/13/2014 12:52:42 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'RAIDER8\I1', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RAIDER8\I1',@useself=N'False',@locallogin=NULL,@rmtuser=N'Res',@rmtpassword='########'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RAIDER8\I1',@useself=N'True',@locallogin=N'COLO\SQL',@rmtuser=NULL,@rmtpassword=NULL




GRANT EXECUTE ON sys.xp_prop_oledb_provider TO Res


    
   
    
