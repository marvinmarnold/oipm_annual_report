-- Setup
with
allegation as (
	select * from iadata_oipm.ia_adm.allegations
)

-- Query
select 

-- Incident info
actionTaken.ATNUM as "Action primary key",
actionTaken.AIO_NUM as "Allegation Incident Officer ID",
actionTaken.algnum as "Allegation primary key",
actionTaken.SUMMARY as "Action taken summary",
CAST(actionTaken.actiontaken_dt AS date) as "Action taken date",
year(actionTaken.actiontaken_dt) as "Action taken year",
month(actionTaken.actiontaken_dt) as "Action taken month",
actionTaken.completed as "Action taken completed",
actionTaken.at_category as "Action taken category",

actionTaken.ACTIONTAKEN as "Action taken",


-- Normalize officer race
case

-- None
when actionTaken.ACTIONTAKEN = 'None' then 'None'
when actionTaken.ACTIONTAKEN = 'None - NFIM' then 'None'
when actionTaken.ACTIONTAKEN = 'None - Not Sustained' then 'None'
when actionTaken.ACTIONTAKEN = 'None - Exonerated' then 'None'
when actionTaken.ACTIONTAKEN = 'None - Unfounded' then 'None'
when actionTaken.ACTIONTAKEN = 'None - Cancelled' then 'None'
when actionTaken.ACTIONTAKEN = 'None - Duplicate Allegation' then 'None'
when actionTaken.ACTIONTAKEN = 'None - Duplicate Investigation' then 'None'
when actionTaken.ACTIONTAKEN = 'None - RUI - Unfounded' then 'None'
when actionTaken.ACTIONTAKEN = 'None - RUI - Not Sustained' then 'None'
when actionTaken.ACTIONTAKEN = 'None - No Violations Observed' then 'None'
when actionTaken.ACTIONTAKEN = 'Nulified per 40:2531, Paragraph C' then 'None'
when actionTaken.ACTIONTAKEN = 'Letter of Reprimand / Overturned by Civil Service' then 'None'
when actionTaken.ACTIONTAKEN = 'None - Withdrawn' then 'None'
when actionTaken.ACTIONTAKEN = 'Duplicate Allegation' then 'None'
when actionTaken.ACTIONTAKEN = 'None - Resigned / Retired' then 'None'
when actionTaken.ACTIONTAKEN = 'None - Deceased' then 'None'
when actionTaken.ACTIONTAKEN = 'Suspension - Rescinded per Civil Service Agreement' then 'None'

-- RUI
when actionTaken.ACTIONTAKEN = 'RUI - Resigned/Retired Under Investigation' then 'Resigned before disposition'
when actionTaken.ACTIONTAKEN = 'None - RUI - Sustained' then 'Resigned before disposition'
when actionTaken.ACTIONTAKEN = 'None - Resigned Under Investigation' then 'Resigned before disposition'

-- Illigitimate
when actionTaken.ACTIONTAKEN = 'Sustained' then 'Illegitimate outcome'
when actionTaken.ACTIONTAKEN = 'Awaiting Hearing' then 'Illegitimate outcome'
when actionTaken.ACTIONTAKEN = 's' then 'Illegitimate outcome'
when actionTaken.ACTIONTAKEN = '011618' then 'Illegitimate outcome'
when actionTaken.ACTIONTAKEN = 'Counseled' then 'Illegitimate outcome'
when actionTaken.ACTIONTAKEN = 'None - RUI - Sustained - Awaiting Hearing' then 'Illegitimate outcome'


-- Pending
when actionTaken.ACTIONTAKEN = 'Pending Investigation' then 'Pending Investigation'

-- Some form of action
when actionTaken.ACTIONTAKEN = 'DI-2' then 'DI-2'
when actionTaken.ACTIONTAKEN = 'BWC - Redirection' then 'DI-2'
when actionTaken.ACTIONTAKEN = 'Oral Redirection' then 'DI-2'
when actionTaken.ACTIONTAKEN = 'Redirection' then 'DI-2'
when actionTaken.ACTIONTAKEN = 'NSA - Oral Redirection' then 'DI-2'

when actionTaken.ACTIONTAKEN = 'Withdrawn - Mediation' then 'Mediation'
when actionTaken.ACTIONTAKEN = 'Demoted' then 'Demoted'
when actionTaken.ACTIONTAKEN = 'NSA - Training' then 'Training'

when actionTaken.ACTIONTAKEN = 'Oral Reprimand' then 'Oral Reprimand'
when actionTaken.ACTIONTAKEN = 'NSA - Oral Reprimand' then 'Oral Reprimand'

when actionTaken.ACTIONTAKEN = 'Letter of Reprimand' then 'Letter of Reprimand'
when actionTaken.ACTIONTAKEN = 'NSA  - Letter of Reprimand' then 'Letter of Reprimand'

when actionTaken.ACTIONTAKEN = 'DUI-Dismissed Under Investigation' then 'Dismissed'
when actionTaken.ACTIONTAKEN = 'Dismissal' then 'Dismissed'
when actionTaken.ACTIONTAKEN = 'Dismissal - Rule 9' then 'Dismissed'

when actionTaken.ACTIONTAKEN = 'NSA - Suspension' then 'Suspension'
when actionTaken.ACTIONTAKEN = 'Suspension' then 'Suspension'
when actionTaken.ACTIONTAKEN = 'Suspended' then 'Suspension'

-- when actionTaken.ACTIONTAKEN = '' then ''


Else 'Unknown action taken'
end as "Action taken OIPM",

-- Allegation
alleg.allegation as "Allegation",
alleg.finding as "Allegation finding",
alleg.final_dispo as "Allegation final disposition",

CAST(alleg.created_dt AS date) as "Allegation created date",
year(alleg.created_dt) as "Allegation year created",
month(alleg.created_dt) as "Allegation month created",
alleg.finding_dt as "Allegation finding date",
alleg.created_dt as "Allegation created on",
alleg.alg_code as "Allegation code",
alleg.published as "Allegation published",
cast(alleg.final_dispo_dt as date) as "Allegation final disposition date",
alleg.directive as "Allegation directive",
alleg.crim_charge as "Allegation criminal charges",
alleg.civil_suit as "Allegation civil suit",
cast(alleg.cpoa_finding_dt as date) as "Allegation criminal charges"

from iadata_oipm.ia_adm.ACTIONS_TAKEN actionTaken 

-- Join officer
left join allegation as alleg on actionTaken.algnum = alleg.algnum
