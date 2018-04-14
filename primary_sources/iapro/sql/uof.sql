
-- Setup
with
officerLink as (
	select * from iadata_oipm.ia_adm.[ASSOC_inc_off] where LINK_TYPE = 'Officer'
),
officer as (
	select * from iadata_oipm.ia_adm.officers
),
actionTaken as (
	select * from iadata_oipm.ia_adm.actions_taken
),
citLink as (
	select * from IADATA_OIPM.IA_ADM.ASSOC_INC_CIT
),
cit as (
	select * from IADATA_OIPM.IA_ADM.CITIZENS
),
useOfForce as (
	select * from IADATA_OIPM.IA_ADM.USES_OF_FORCE
)

-- Query
select 

-- Incident info
filenum as "FIT Number",
SUBSTRING(filenum, 4, 4) as "Year reported",
year(occurred_dt) as "Year Occurred",
occurred_dt as "Occurred date",
month(occurred_dt) as "Month occurred",

o.offnum as "Officer primary key",
c.citnum as "Citizen primary key",

-- type
case
when uof.uof_force_type is null or datalength(uof.uof_force_type) = 0 then 'L0-Not reported'
Else uof.uof_force_type
end as "Force descr",

case
when uof.uof_force_type is null or datalength(uof.uof_force_type) = 0 then 'Not defined'
Else SUBSTRING(uof.uof_force_type, 2, 1)
end as "Force level",

case
when uof.uof_force_type is null or datalength(uof.uof_force_type) = 0 then 'Not reported'
-- Other is repeated so need to diambiguate it
when SUBSTRING(uof.uof_force_type, 4, 30) = 'Other' then uof.uof_force_type
else SUBSTRING(uof.uof_force_type, 4, 30) 
end as "Force type",

uof.uof_effective as "UOF effective",
uof.accidental_dis as "Accidental discharge",
uof.deployed_only AS "Deployed only",
uof.arc_display_only AS "Arc display only",
uof.ds_contact AS "DS contact",
uof.ds_injury AS "DS injury",
uof.proj_contact AS "Proj contact",
uof.proj_injury AS "Proj injury",
uof.skin_penet AS "Skin penetration",
uof.ds_body_area AS "DS body area",
uof.proj_body_area AS "Proj body area",
uof.ds_num AS "DS num",
uof.air_cart_num AS "Air cart num",
uof.cycles_num AS "Cycles num",
uof.darts_hit_num AS "Num darts hit",
uof.darts_used_num AS "Num darts used",
uof.less_than_lethal AS "Less than lethal",
uof.citizen_painted AS "Citizen painted",
uof.cart_attached AS "Cartridge attached",
uof.followup_ds AS "Follow up discharge",
uof.additional_cart AS "Additional cartridge",
occurred_day as "Day of week",
occurred_hour_i as "Hour of day",
cast(occurred_tm as time) as "Ocurred time",
incident_type as "Incident type",
received_dt as "Received date",
open_dt as "Open date",
due_dt as "Due date",
assigned_dt as "Assigned date",
completed_dt as "Completed date",
incident.created_dt as "Created date",
inv_unit as "Assigned unit",

-- The real values for these are in table AIO_COLS
incident.udtext24A as "Bureau",
incident.udtext24B as "District or division",
incident.udtext24C as "Division assignment",
incident.udtext24D as "Unit assignment",
incident.udtext24E as "Working status",
incident.udtext24F as "Shift details",
incident.priority as "Priority",
incident.status as "Status",
disposition as "Disposition",
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
uof_reason as "Reason for force",
other_incidents as "Other incidents",
light_condition as "Light condition",
weather_condition as "Weather condition",
cit_uof_dist as "Distance from officer",
bt_body_image as "Body worn camera available",
created_app as "App used",

-- Citizen info
cit_arrested as "Citizen arrested",
incident.arrest as "UOF reported an arrest",
cit_hospital as "Citizen hospitalized",
cit_injured as "Citizen injured",
cit_uof_build as "Citizen build",
cit_uof_height as "Citizen height",
cL.cit_age as "Citizen age",
cL.LINK_TYPE as "Citizen involvement",
cL.FD_INVOLVEMENT as "FD involvement",
cL.NUM_SHOTS as "Citizen num shots",
cL.CIT_AFFECT_TYPE as "Citizen affect type",
cL.INJ_CAUSED_BY as "Citizen injury caused by",
cL.ANIMAL as "Animal",
cL.ANIMAL_INJURED as "Animal injured",
cL.ANIMAL_KILLED as "Animal killed",
cL.ANIMAL_TYPE as "Animal type",
cL.FD_CIT_ARRESTED as "FD_CIT_ARRESTED",
cL.FD_CIT_CHARGES as "FD_CIT_CHARGES",
cL.VICTIM as "Citizen victim",
cL.INMATE as "Citizen inmate",
cL.CIT_PROBATION as "Citizen probation",
cL.cit_parole as "Citizen parole",
cL.cit_role as "Citizen role",

-- Normalize citizen gender
case
when c.sex = 'Male' or c.sex = 'M' then 'M'
when c.sex = 'Female' or c.sex = 'F' then 'F'
Else 'Unknown sex'
end as "Citizen sex",

-- Blank race -> Race-Unknown
case
when c.race is null or datalength(c.race) = 0 then 'Race-Unknown'
when c.race = 'B' then 'Black'
when c.race = 'W' then 'White'
Else c.race
end as "Citizen race",

c.narrative as "Citizen narrative",
datediff(yy, c.DOB, occurred_Dt) as "Citizen age",

-- Sensitive info
o.OFFNUM as "Officer DB primary key",
o.CURRENT_SUP_OFFNUM as "Officer current supervisor",

-- Officer shareable info
o.TITLE as "Officer title",

-- Normalize officer gender
case
when o.sex = 'Male' or o.sex = 'M' then 'M'
when o.sex = 'Female' or o.sex = 'F' then 'F'
Else 'Unknown sex'
end as "Officer sex",

o.RACE as "Race",
incident.off_injured as "Officer injured",
incident.off_hospital as "Officer hospital",
datediff(yy, o.DOB, occurred_Dt) as "Officer age at time of UOF",
datediff(yy, o.HIRE_DT, occurred_Dt) as "Officer years exp at time of UOF",
datediff(yy, o.UNIT_DT_ASSIGNED, occurred_Dt) as "Officer years with unit",
o.EMP_TYPE as "Officer type",
o.STATUS as "Officer employment status",
o.UDTEXT24A as "Officer department",
o.UDTEXT24B as "Officer division",
o.UDTEXT24C as "Officer sub-division A",
o.UDTEXT24D as "Officer sub-division B",
o.CITY1 as "Officer city",
o.STATE1 as "Officer state",
o.ZIPCODE1 as "Officer ZIP"

from iadata_oipm.ia_adm.incidents incident 

-- Join officer
left join officerLink as oL on incident.incnum = oL.incnum
left join officer o on o.offnum = oL.offnum

-- Join citizens
left join citLink as cL on incident.INCNUM = cL.INCNUM
left join cit c on c.CITNUM = cL.CITNUM

-- Join info about the incident
left join useOfForce as uof on ol.aio_num = uof.aio_num

where 
--incident.OCCURRED_DT >= '2015-01-01 00:00:00' and 
incident.filenum LIKE 'FTN2017%'
order by occurred_dt DESC