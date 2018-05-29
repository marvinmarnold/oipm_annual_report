-- from generic to dated
USE master;  
ALTER DATABASE IADATA_OIPM  
Modify Name = IADATA_OIPM_20180228;  

-- from dated to generic
ALTER DATABASE IADATA_OIPM_20180518 
Modify Name = IADATA_OIPM; 