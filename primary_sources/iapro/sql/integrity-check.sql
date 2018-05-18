-- Prints the number of rows in several essential tables

-- Declare variables
declare @numIncidents int
declare @numOfficers int
declare @numAllegations int
declare @numActionsTaken int
declare @numAssocIncCit int
declare @numAssocIncInvOff int
declare @numAssocIncOff int
declare @numUsesOfForce int
declare @numCitizens int

-- Count rows and set variables
set @numIncidents = (SELECT count(*) FROM [IADATA_OIPM].[IA_ADM].[INCIDENTS])
set @numOfficers = (SELECT count(*) FROM [IADATA_OIPM].[IA_ADM].[OFFICERS])
set @numAllegations = (SELECT count(*) FROM [IADATA_OIPM].[IA_ADM].[ALLEGATIONS])
set @numActionsTaken = (SELECT count(*) FROM [IADATA_OIPM].[IA_ADM].[ACTIONS_TAKEN])
set @numAssocIncCit = (SELECT count(*) FROM [IADATA_OIPM].[IA_ADM].[ASSOC_INC_CIT])
set @numAssocIncInvOff = (SELECT count(*) FROM [IADATA_OIPM].[IA_ADM].[ASSOC_INC_INV_OFF])
set @numAssocIncOff = (SELECT count(*) FROM [IADATA_OIPM].[IA_ADM].[ASSOC_INC_OFF])
set @numUsesOfForce = (SELECT count(*) FROM [IADATA_OIPM].[IA_ADM].[USES_OF_FORCE])
set @numCitizens = (SELECT count(*) FROM [IADATA_OIPM].[IA_ADM].[CITIZENS])

-- Print results
print N'There are ' + cast(@numIncidents as varchar) + ' incidents'
print N'There are ' + cast(@numOfficers as varchar) + ' officers'
print N'There are ' + cast(@numAllegations as varchar) + ' allegations'
print N'There are ' + cast(@numActionsTaken as varchar) + ' actions taken'
print N'There are ' + cast(@numAssocIncCit as varchar) + ' assoc-inc-cit'
print N'There are ' + cast(@numAssocIncInvOff as varchar) + ' assoc-inc-inv-off'
print N'There are ' + cast(@numAssocIncOff as varchar) + ' assoc-inc-off'
print N'There are ' + cast(@numCitizens as varchar) + ' citizens'
print N'There are ' + cast(@numUsesOfForce as varchar) + ' uses of force'

