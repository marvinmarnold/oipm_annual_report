select 
-- TODO
--    We have a few officers that are either 106 (9) or 116 (2) years of age. Curiously, they were all hired on the same day in 2014 and the other information is nearly identical. 
--    There are 68 officers who are marked as “Active” and “Commissioned” but have dates in the “Employment ended on field” 
--        Should I still report this data?
--    Of of 1189 “Commissioned” & “Active” officers, 4 have “Working Statuses” of RUI, DUI, Re-Assigned while 1185 have either Regular Working (21), Unknown Working Status (215), or NULL (949)
--        It seems like it would make sense to include the latter 3 categories but possibly exclude the first 3 categories — does this make sense? 
--

-- Employment details
offnum AS "Officer number",
current_badge_no as "Badge number",
usrnum as "User number",
num_emp as "Employment number",
title as "Title",
emp_type as "Employee type",
status as "Employment status",
hire_dt as "Hired on",
end_employ_dt as "Employment ended on",
off_inactive as "Officer inactive",
datediff(yy, hire_dt, getdate()) as "Years employed",
udtext24e as "Working status",
udtext24f as "Shift hours",
exclude_reason as "Exclude reason",

-- Demographics
-- dob as "Date of Birth",
datediff(yy, dob, getdate()) as "Age",

-- Normalize officer gender
case
when sex = 'Male' or sex = 'M' then 'M'
when sex = 'Female' or sex = 'F' then 'F'
Else 'Unknown sex'
end as "Officer sex",

-- Normalize officer race
case
when race = 'American Ind' then 'Native American'
when race = 'Asian/Pacif' or race = 'Asian/Pacifi' then 'Asian / Pacific Islander'
when race = 'Black' then 'Black / African American'
when race = 'Hispanic' then 'Hispanic'
when race = 'White' then 'White'
Else 'Unknown race'
end as "Officer race",

-- Department
UDTEXT24A as "Officer department",
UDTEXT24B as "Officer division",
UDTEXT24C as "Officer sub-division A",
UDTEXT24D as "Officer sub-division B",
unit_dt_assigned as "Assigned to unit on",

-- Location
-- city1 as "City",
-- state1 as "State",
-- zipcode1 as "Zip",
-- Confidential

-- fnam as "First name",
-- mnam as "Middle initial",
-- lnam as "Last name",
current_sup_offnum as "Current supervisor"

from iadata_oipm.ia_adm.officers
-- where officers.emp_type in ('Commissioned') 
-- AND

-- This is inacurrate but pending a resolution to alternative below
-- status = 'Active'

-- The code below won't work because end_employ_dt is often null
-- Officers hired before the end of 2017
--and HIRE_DT < '2018-01-01' AND

-- Employment never ended or ended after jan 1, 2017
--((END_EMPLOY_DT is null) or (END_EMPLOY_DT >= '2017-01-01'))
