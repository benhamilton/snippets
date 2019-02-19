
# SugarCRM MySQL

The config.php file contains the MySQL connection details.

On linux, this is often found at: `/var/www/html/FOLDERNAME/config.php`

```
'dbconfig' =>
  array (
    'db_host_name' => 'localhost',
    'db_host_instance' => 'DBHOSTINSTANCE',
    'db_user_name' => 'DBUSERNAME',
    'db_password' => 'DBPASSWORD',
    'db_name' => 'DBNAME',
    'db_type' => 'mysql',
    'db_port' => '',
    'db_manager' => 'MysqliManager',
```

tags: #mysql #password #connection