DECLARE @RELEVANT_DISPOSITIONS TABLE (Disp VARCHAR(100))

-- Add any other action types to be included here
INSERT INTO @RELEVANT_DISPOSITIONS VALUES ('Dismissed Under Investigation')
INSERT INTO @RELEVANT_DISPOSITIONS VALUES ('Sustained/Dismissal')
INSERT INTO @RELEVANT_DISPOSITIONS VALUES ('DUI from another case')
INSERT INTO @RELEVANT_DISPOSITIONS VALUES ('Sustained/Dismissed Under another Case')

SELECT
-- Actions taken
act.actiontaken as "Action taken",
act.actiontaken_dt as "Action taken on",
act.dayssuspended as "Days suspended",
act.completed as "Action taken completed",
act.fieldunit_level as "Action taken field unit level",
act.at_category as "Action taken category",

-- Incident
inc.filenum as "FIT Number",
inc.occurred_dt as "Ocurred date",
inc.occurred_day as "Day of week",
inc.occurred_hour_i as "Hour of day",
cast(inc.occurred_tm as time) as "Ocurred time",
inc.incident_type as "Incident type",
inc.received_dt as "Received date",
inc.open_dt as "Open date",
inc.due_dt as "Due date",
inc.assigned_dt as "Assigned date",
inc.completed_dt as "Completed date",
inc.created_dt as "Created date",
inc.inv_unit as "Assigned unit",
inc.udtext24A as "Assigned department",
inc.udtext24B as "Assigned division",
inc.udtext24C as "Assigned sub-division A",
inc.udtext24D as "Assigned sub-division B",
inc.udtext24E as "Working status",
inc.udtext24F as "Shift details",
inc.priority as "Priority",
inc.status as "Status",
inc.disposition as "Disposition",
inc.source as "Source",
inc.service_type as "Service type",
inc.nypd_corruption as "Rule violation",
inc.nypd_crime as "Paragraph violation",
inc.cit_complaint as "CIT complaint",
inc.off_invol_shoot as "Officer involved shooting",
inc.off_duty as "Off duty",
inc.off_duty_employ as "Off duty employment",
inc.unidentified_off as "Unidentified officer",
inc.why_forwarded as "Why forwarded",
inc.county as "County",
inc.traffic_stop as "Traffic stop",
inc.fieldunit_level as "Field unit level",
inc.length_of_job as "Length of job",
inc.sustained as "Sustained",
inc.uof_reason as "Reason for force",
inc.other_incidents as "Other incidents",
inc.light_condition as "Light condition",
inc.weather_condition as "Weather condition",
inc.cit_uof_dist as "Distance from officer",
inc.bt_body_image as "Body worn camera available",
inc.created_app as "App used",

-- Citizen info
inc.cit_arrested as "Citizen arrested",
inc.cit_hospital as "Citizen hospitalized",
inc.cit_injured as "Citizen injured",
inc.cit_uof_build as "Citizen build",
inc.cit_uof_height as "Citizen height",

-- Allegations
alleg.allegation as "Allegation",
alleg.finding as "Allegation finding",
alleg.finding_dt as "Allegation finding date",
alleg.created_dt as "Allegation created on",
alleg.alg_class as "Allegation class",
alleg.final_dispo as "Allegation final disposition",
alleg.final_dispo_dt as "Allegation final disposition date",
alleg.directive as "Allegation directive",

-- Officer info
o.TITLE as "Officer title",
o.SEX as "Officer sex",
o.RACE as "Race",
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

FROM
IA_ADM.INCIDENTS as inc
LEFT JOIN IA_ADM.ASSOC_INC_OFF as ol on ol.INCNUM = inc.INCNUM
LEFT JOIN IA_ADM.OFFICERS as o on o.OFFNUM = ol.OFFNUM
LEFT JOIN IA_ADM.ALLEGATIONS as alleg on alleg.AIO_NUM = ol.AIO_NUM
LEFT JOIN IA_ADM.ACTIONS_TAKEN as act on act.AIO_NUM = ol.AIO_NUM

-- select relevant action types defined above
WHERE inc.DISPOSITION in (SELECT Disp FROM @RELEVANT_DISPOSITIONS)