-- Setup
with
officerLink as (
	select * from iadata_oipm.ia_adm.[ASSOC_inc_off] where LINK_TYPE = 'Officer'
),
officer as (
	select * from iadata_oipm.ia_adm.officers
),
allegation as (
	select * from iadata_oipm.ia_adm.allegations
),
citLink as (
	select * from IADATA_OIPM.IA_ADM.ASSOC_INC_CIT WHERE LINK_TYPE = 'Complainant'
),
cit as (
	select * from IADATA_OIPM.IA_ADM.CITIZENS
)

-- Query
select 

-- Incident info
filenum as "PIB Control Number",
incident_type as "Incident type",
o.offnum as "Officer primary key",
c.citnum as "Citizen primary key",
alleg.algnum as "Allegation primary key",

alleg.allegation as "Allegation",
alleg.finding as "Allegation finding",
alleg.final_dispo as "Allegation final disposition",

CAST(occurred_dt AS date) as "Occurred date",
year(occurred_dt) as "Year occurred",
month(occurred_dt) as "Month occurred",

-- Combine all allegations into one long string
STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '') AS "All Findings",
        
-- tsql doesn't support regex so have to get creative
-- when AllFindings contains more than one finding, select disposition in this order:
-- sustained, withdrawn / mediated, dI2, pending, not sustained, unfounded, exonerated, NFIM, Illegitimate outcome
case
	-----    
	-- Sustained
	when alleg.final_dispo = 'BWC - Redirection' then 'DI-2'
	when PATINDEX('SUSTAINED%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'Sustained'
    
    -- Don't confuse sustained and not sustained
    when PATINDEX('%[^n][^o][^t] SUSTAINED%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'Sustained'
        
    -- Negotiated settlement is sustained
	when PATINDEX('%NEGOTIATED SETTLEMENT%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'Sustained'
     
    -- Awaiting hearing is sustained
	when PATINDEX('%AWAITING HEARINGT%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'Sustained'    
        
    -----       
    -- Mediation
	when PATINDEX('%WITHDRAWN%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'Mediation'    
        
    -----    
    -- DI-2
	when PATINDEX('%DI-2%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'DI-2'  
     
    -- Redirection is DI2
	when PATINDEX('%REDIRECTION%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'DI-2'  
        
    -----    
    -- Pending
    when PATINDEX('%PENDING INVESTIGATION%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'Pending'      
    
    -----    
    -- Not sustained
    when PATINDEX('%NOT SUSTAINED%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'Not Sustained' 
        
    -----    
    -- Unfounded
    when PATINDEX('%UNFOUNDED%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'Unfounded' 
        
    -- No violations is not sustained
    when PATINDEX('%NO VIOLATIONS OBSERVED%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'Unfounded' 
    
    -----    
    -- Exonerated
    when PATINDEX('%EXONERATED%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'Exonerated'   
        
    -----    
    -- NFIM
    when PATINDEX('%NFIM%', STUFF((
        SELECT N', ' + CAST([finding] AS VARCHAR(255))
        FROM allegation alleg2
        WHERE alleg.AIO_NUM = alleg2.AIO_NUM ---- string with grouping by AIO_NUM
        FOR XML PATH ('')), 1, 2, '')) > 0 then 'NFIM' 
        
    -- Anything else that's not complete is pending    
    when incident.status <> 'Completed' then 'Pending'
    
    -- But anything else that is complete is illegitimate
	else 'Illegitimate outcome'
END as 'Disposition OIPM by officer',

-- Disposition / findings for individual allegations
case
---
-- Pending
--	when incident.status = 'Active' then 'Pending'
	
	-----    
	-- Sustained
	when PATINDEX('SUSTAINED%', finding) > 0 then 'Sustained'
    
    -- Don't confuse sustained and not sustained
    when PATINDEX('%[^n][^o][^t] SUSTAINED%', finding) > 0 then 'Sustained'
        
    -- Negotiated settlement is sustained
	when PATINDEX('%NEGOTIATED SETTLEMENT%', finding) > 0 then 'Sustained'
     
    -- Awaiting hearing is sustained
	when PATINDEX('%AWAITING HEARING%', finding) > 0 then 'Sustained'    
        
    -----       
    -- Mediation
	when PATINDEX('%WITHDRAWN%', finding) > 0 then 'Mediation'    
        
    -----    
    -- DI-2
	when PATINDEX('%DI-2%', finding) > 0 then 'DI-2'  
     
    -- Redirection is DI2
	when PATINDEX('%REDIRECTION%', finding) > 0 then 'DI-2'  
        
    -----    
    -- Pending
    when PATINDEX('%PENDING INVESTIGATION%', finding) > 0 then 'Pending'      
    
    -----    
    -- Not sustained
    when PATINDEX('%NOT SUSTAINED%', finding) > 0 then 'Not Sustained' 
        
    -----    
    -- Unfounded
    when PATINDEX('%UNFOUNDED%', finding) > 0 then 'Unfounded' 
        
    -- No violations is not sustained
    when PATINDEX('%NO VIOLATIONS OBSERVED%', finding) > 0 then 'Unfounded' 
    
    -----    
    -- Exonerated
    when PATINDEX('%EXONERATED%', finding) > 0 then 'Exonerated'   
        
    -----    
    -- NFIM
    when PATINDEX('%NFIM%', finding) > 0 then 'NFIM' 
    
    -----    
	-- Specific illigitimate outcomes
	when PATINDEX('%DUPLICATE ALLEGATION%', finding) > 0 then 'Illegitimate outcome'
	when PATINDEX('%CANCELLED%', finding) > 0 then 'Illegitimate outcome'
    
	----- 
	 -- Anything else that's not complete is pending    
    when incident.status <> 'Completed' then 'Pending'
    
    -- But anything else that is complete is illegitimate
	else 'Illegitimate outcome'
END as 'Allegation Finding OIPM',

-- Disposition as reported
incident.status as "Status",
	
-- Disposition according to NOPD's classifications
case 

when incident.status <> 'Completed' then 'Pending'
Else 
	case
	when Disposition = 'Awaiting Hearing' then 'Other'
	when Disposition = 'Cancelled - Investigation Cancelled' then 'Other'
	when Disposition = 'CHARGES PROVEN' then 'Other'
	when Disposition = 'Deceased' then 'Other'
	when Disposition = 'DI-2' then 'Other'
	when Disposition = 'Dismissed Under Investigation' then 'Other'
	when Disposition = 'DUI from another Case' then 'Other'
	when Disposition = 'Duplicate Investigation' then 'Other'
	when Disposition = 'Exonerated' then 'Exonerated'
	when Disposition = 'INFO' then 'Other'
	when Disposition = 'Negotiated Settlement' then 'Negotiated Settlement'
	when Disposition = 'NFIM' then 'NFIM'
	when Disposition = 'NFIM - Exonerated' then 'NFIM'
	when Disposition = 'No Formal Investigation Merited (NFIM)' then 'NFIM'
	when Disposition = 'NO FURTHER INVESTIGATION MERITED' then 'NFIM'
	when Disposition = 'Not Sustained' then 'Not Sustained'
	when Disposition = 'NULL' then 'NULL'
	when Disposition = 'NVO' then 'Other'
	when Disposition = 'PENDING' then 'Pending'
	when Disposition = 'RUI - Awaiting Hearing' then 'Resigned under investigation'
	when Disposition = 'RUI - Resigned Under Investigation' then 'Resigned under investigation'
	when Disposition = 'RUI - Retired/Resigned - Exonerated' then 'Resigned under investigation'
	when Disposition = 'Sustained' then 'Sustained'
	when Disposition = 'Sustained Resign/Retired (1 PO RUI)' then 'Sustained'
	when Disposition = 'Sustained RUI-Resigned Under Investigation' then 'Sustained'
	when Disposition = 'Sustained RUI-Retired Under Investigation' then 'Sustained'
	when Disposition = 'Sustained/Dismissal' then 'Sustained'
	when Disposition = 'Sustained/Dismissal (1 PO Dismissed)' then 'Sustained'
	when Disposition = 'Sustained-Awaiting Hearing' then 'Sustained'
	when Disposition = 'Unfounded' then 'Unfounded'
	when Disposition = 'Use Of Force Authorized' then 'Use Of Force Authorized'
	when Disposition = 'Use Of Force Not Authorized' then 'Use Of Force Not Authorized'
	when Disposition = 'Withdrawn - Investigation Withdrawn' then 'Other'
	when Disposition = 'Withdrawn- Mediation' then 'Withdrawn - Mediation'
	Else 'Other'
	END
End as "Disposition NOPD",


-- Allegations
case
when alleg.allegation IS NULL or datalength(alleg.allegation) = 0 then 'Unknown Allegation'
Else SUBSTRING(alleg.allegation, 16, 99)
end as "Allegation",

case
when alleg.alg_class IS NULL or datalength(alleg.alg_class) = 0 then 'Unknown Class'
Else alleg.alg_class
end as "Allegation class",

alleg.finding_dt as "Allegation finding date",
alleg.created_dt as "Allegation created on",
alleg.alg_code as "Allegation code",
alleg.alg_class as "Allegation class",
alleg.published as "Allegation published",
cast(alleg.final_dispo_dt as date) as "Allegation final disposition date",
alleg.directive as "Allegation directive",
alleg.crim_charge as "Allegation criminal charges",
alleg.civil_suit as "Allegation civil suit",
cast(alleg.cpoa_finding_dt as date) as "Allegation criminal charges",
alleg.cpoa_finding as "Allegation cpoa finding",
alleg.alert_processed as "Allegation alert processed",
cast(alleg.alert_processed_dt as date) as "Allegation alert processed date",
alleg.aus_alg_comment as "Allegation AUS ALG comment",

occurred_day as "Day of week",
occurred_hour_i as "Hour of day",
cast(occurred_tm as time) as "Ocurred time",
received_dt as "Received date",
open_dt as "Open date",
due_dt as "Due date",
assigned_dt as "Assigned date",
completed_dt as "Completed date",
incident.created_dt as "Created date",
inv_unit as "Assigned unit",
incident.udtext24A as "Assigned department",
incident.udtext24B as "Assigned division",
incident.udtext24C as "Assigned sub-division A",
incident.udtext24D as "Assigned sub-division B",
incident.udtext24E as "Working status",
incident.udtext24F as "Shift details",
incident.priority as "Priority",
source as "Source",
service_type as "Service type",
nypd_corruption as "Rule violation",
nypd_crime as "Paragraph violation",
cit_complaint as "CIT complaint",
off_invol_shoot as "Officer involved shooting",
incident.off_duty as "Off duty",
incident.off_duty_employ as "Off duty employment",
unidentified_off as "Unidentified officer",
why_forwarded as "Why forwarded",
county as "County",
traffic_stop as "Traffic stop",
incident.fieldunit_level as "Field unit level",
length_of_job as "Length of job",
sustained as "Sustained",
bt_body_image as "Body worn camera available",
created_app as "App used",

-- Citizen info
cit_arrested as "Citizen arrested",
cL.cit_age as "Citizen age",
cL.LINK_TYPE as "Citizen involvement",
cL.FD_INVOLVEMENT as "FD involvement",
cL.NUM_SHOTS as "Citizen num shots",
cL.CIT_AFFECT_TYPE as "Citizen affect type",
cL.INJ_CAUSED_BY as "Citizen injury caused by",

CASE
when (c.FNAM is null or c.FNAM = '') and (c.LNAM is null or c.LNAM = '') then 'Anon - No name'
when (PATINDEX('%Anonymous%', c.FNAM) > 0) or (PATINDEX('%Anonymous%', c.LNAM) > 0) then 'Anon - Explicit'
else 'Not anonymous' 
end as "Is anonymous",

-- Normalize citizen gender
case
when c.sex = 'Male' or c.sex = 'M' then 'M'
when c.sex = 'Female' or c.sex = 'F' then 'F'
Else 'Unknown sex'
end as "Citizen sex",

case
when c.race = 'American Ind' then 'Native American'
when c.race = 'Asian/Pacif' or c.race = 'Asian/Pacifi' then 'Asian / Pacific Islander'
when c.race = 'Black' then 'Black / African American'
when c.race = 'Hispanic' then 'Hispanic'
when c.race = 'White' then 'White'
Else 'Unknown race'
end as "Citizen race",

c.narrative as "Citizen narrative",
c.dob as "Citizen dob",

-- Sensitive info
o.CURRENT_BADGE_NO as "Officer badge number",
o.CURRENT_SUP_OFFNUM as "Officer current supervisor",
-- s.SUMMARY as "Narrative",
o.UDTEXT24G as "Officer UNKNOWN ID",

-- Officer shareable info
o.TITLE as "Officer title",

-- Normalize officer gender
case
when o.sex = 'Male' or o.sex = 'M' then 'M'
when o.sex = 'Female' or o.sex = 'F' then 'F'
Else 'Unknown sex'
end as "Officer sex",

-- Normalize officer race
case
when o.race = 'American Ind' then 'Native American'
when o.race = 'Asian/Pacif' or o.race = 'Asian/Pacifi' then 'Asian / Pacific Islander'
when o.race = 'Black' then 'Black / African American'
when o.race = 'Hispanic' then 'Hispanic'
when o.race = 'White' then 'White'
Else 'Unknown race'
end as "Officer Race",

datediff(yy, o.DOB, occurred_Dt) as "Officer age at time of UOF",
datediff(yy, o.HIRE_DT, occurred_Dt) as "Officer years exp at time of UOF",
datediff(yy, o.UNIT_DT_ASSIGNED, occurred_Dt) as "Officer years with unit",
o.EMP_TYPE as "Officer type",
o.STATUS as "Officer employment status",
o.UDTEXT24A as "Officer department",
o.UDTEXT24B as "Officer division",
o.UDTEXT24C as "Officer sub-division A",
o.UDTEXT24D as "Officer sub-division B"
-- o.CITY1 as "Officer city",
-- o.STATE1 as "Officer state",
-- o.ZIPCODE1 as "Officer ZIP"

from iadata_oipm.ia_adm.incidents incident 

-- Join officer
left join officerLink as oL on incident.incnum = oL.incnum
left join officer o on o.offnum = oL.offnum

-- Join citizens
left join citLink as cL on incident.INCNUM = cL.INCNUM
left join cit c on c.CITNUM = cL.CITNUM

-- Join allegations
left join allegation as alleg on alleg.AIO_NUM = oL.AIO_NUM

where incident.INCIDENT_TYPE in (
'Rank Initiated', 'Public Initiated'
-- 'Firearm discharge', 'Vehicle accident', 'Civil lawsuit', 'Criminal lawsuit', 'Discretionary arrest',
-- 'Forced entry', 'Integrity test', 'IPM Review', 'JPIP', 'K9 Utilization', 'MISC',
-- 'PPEP', 'Protection Order', 'Stop', 'Vehicle pursuit'
) 

-- and FILENUM like '%2016-0385-P%'