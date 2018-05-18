# Info
The last full clone taken in May 18 2018 is 15097548800 (output of `ls -l` not sure of units).

# Commands for cloning the DB
From the computer at NOPD, we only have read access to the DB. Without write access,
the convenient `BACKUP DATABASE` command. Instead, we have to:

## 0. Setup
1) [Install Microsoft SQL on Ubuntu](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-ubuntu).
2) `sqlcmd -S localhost -U SA`

## 1. Copy DB from host to VM
1) Setup a virtual machine on the same computer.
2) Install Microsoft Server on the VM https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-ubuntu
3) From the VM: Create a new DB (`sqlcmd -S localhost -U SA` then `create database DB_NAME_HERE` and finally `go`. If there was already an existing DB, you may want to free up space first with `drop database DB_NAME_HERE`)
4) From the host: Turn on port forwarding for the VM so it can communicate with the host machine. SQL is TCP port 1433.
5) From the host: Open SSMS. Connect to the IAPro DB using Windows authentication.
6) From the host: Find the IADATA_OIPM DB. Right click on it -> Tasks -> Export Data...
7) From the host: Select SQL Server Native Client > Select IADATA_OIPM for the source.
8) From the host: Repeat the same thing for the desination. Assuming you setup portforwarding, you should be able to use `localhost` as the destination host.
10) From the host: Let that run. It will take about a half hour. It may report warnings and errors
11) Run `integrity-check.sql` on the source and destination and ensure identical results.

## 2. Clone DB from VM to shared drive
BACKUP DATABASE DB_NAME_HERE TO DISK = "/media/MOUNTED_SHARED_DRIVE_PATH/db.bak"

Note: Last time this ran, this took 11077sec (1.29 MB/sec). This is about 3h. It copied just over 15GB.

## 3. Copy DB from shared drive to OIPM computer
List drives: `sudo blkid -o list`
Install exFAT on Ubuntu: `sudo apt install exfat-fuse exfat-utils`
Mount exFAT on Ubuntu (to /media/exfat): `sudo mount -t exfat /dev/sdXX /media/exfat`

## 4. Restore DB from clone
### Get the names of the data and log files
chmod -R 0777 /home/oipm
sqlcmd -S localhost -U SA

### Get filelist from DB backup
RESTORE FILELISTONLY FROM DISK = '/home/oipm/db.bak';

### Rename the existing DB 
So you don't wind up with two IADATA_OIPM databases. Run script `change-name.sql` after altering it to use correct names.

### Restore
RESTORE DATABASE IADATA_OIPM FROM DISK = '/home/oipm/db.bak' 

#### Should no longer need to do these steps as long as db is not saved as master (this is something Marvin would have done incorrectly)
WITH MOVE 'master' TO '/home/oipm/iapro.mdf', 
MOVE 'mastlog' TO '/home/oipm/iapro.ldf';

RESTORE DATABASE IADATA_OIPM FROM DISK = '/home/oipm/IAPro_20180223.bak' WITH MOVE 'master' TO '/home/oipm/iapro.mdf', MOVE 'mastlog' TO '/home/oipm/iapro.ldf'

## 5. Troubleshooting
If you get this error: `Microsoft ODBC Driver 17 for SQL Server : Login failed for user 'sa'. Reason: Server is in script upgrade mode. Only administrator can connect at this time..`
then run `sudo /opt/mssql/bin/mssql-conf traceflag 902 on`.

To securely delete a file after:
Fast: `shred -vzn 0 /path/to/file`
Secure: `shred -vzn 3 /path/to/file`