# SSH Tunnel From Bash Command Line

Use this if you need to establish an SSH tunnel, and then connect to the MySQL database the command line. i.e. to establish an SSH Tunnel for a local app (Navicat) to talk to remote MySQL DB 

```
ssh -p22 -i ~/.ssh/privatekeyfilenamehere -v user@1.1.1.1 -L 3306:127.0.0.1:3306 -N
```

Explaining that command line:

- which port to ssh on: `-p 22`
- which ssh private key to use: `-i ~/.ssh/privatekeyfilenamehere`
- which username @ ip or hostname: `-v user@1.1.1.1`
- remap local port to remote port: `-L 3306:127.0.0.1:3306`
- no idea what this one does yet: `-N`

*Note*: change which PRIVATE key it references, change the username and IP address, and remap the MySQL port as required

To connect to a terminal connection, use this command:

```
ssh user@1.1.1.1 -p 22 -i ~/.ssh/privatekeyfilenamehere
```

tags: #mysql #ssh #iterm #port #publickey #privatekey

---

To connect to local MySQL database do:

```
mysql -u USERNAME -p
```
You will be prompted for the password, type it in and press enter

```
show databases;
```

```
use DATABASENAME;
```

Then you can run your queries i.e.
```
SELECT
	*
FROM
	contacts
WHERE 
	first_name = 'Ben'
	AND last_name 'Hamilton';
```

---

How many rows are in each table?

```
SELECT table_name, table_rows FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = "DATABASENAME" ORDER BY table_rows ASC;
```

---

To remove all rows from a table in MySQL, you can use the truncate command, which is similar to doing a drop table and create table, but quicker and less risky, although there is no undo:

```
TRUNCATE tbl_name
```

---

Count how many rows are in the job_queue after a certain date:
```
select count(id) 
from job_queue 
where execute_time > "2018-11-15";
```

---

Delete rows from the SugarCRM job_queue for all done jobs:
```
DELETE FROM job_queue WHERE status = 'DONE';
```

---

How many distinct values (i.e. unique) are in a column? Useful to know how many dropdown values there are.

```
SELECT DISTINCT mycolumn FROM mytable
```

---


