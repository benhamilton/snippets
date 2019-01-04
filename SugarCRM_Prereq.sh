#!/bin/bash
# Filename: Sugar_script.sh
# Description: Installs the Prerequisites for SugarCRM

        ##Gather information from the EMS Technician##
echo "Welcome to the Evolution Marketing SugarCRM automatic environment setup script for Centos 7.
to begin, please provide some basic information (please be sure to make a note of what you input)
"
sleep 5
read -p "Please enter the short name for the client:
" sname;
read -p "Please enter SugarCRM version (PRO or ENT):
" ver;
read -p "Please enter a password for the MySQL root user:
" sqlroot;
read -p "Please enter a password for the MySQL sugar user:
" sqlpwd;

        ##Disable SELinux##
echo "Now Disabling SELinux"
sleep 1
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux;
cat >> /etc/sysconfig/selinux <<EOF
# SETLOCALDEFS= Check local definition changes
SETLOCALDEFS=0
EOF

        ##Install first Prerequisites##
echo "Installing Minimum required programs"
sleep 1
yum install -y wget gd openssl zip unzip zlib java mc curl postfix firewalld httpd expect git;

        ##Install PHP and required dependencies##
echo " Installing PHP and all required Dependencies"
sleep 1
yum install -y php php-bcmath php-common php-gd php-imap php-mbstring php-mysql php-odbc php-pear php-xml php-cli php-pdo php-pecl-apc;

        ##Configure Apache and Firewall to start at Boot, and then turn them on##
echo "Turning Firewall and Apache on, and setting them to start at Boot"
sleep 1
chkconfig firewalld on && sudo service firewalld start;
chkconfig httpd on && sudo service httpd start;

        ##Add rules to the Firewall to allow SSH access and open ports for SugarCRM and then restart Firewall##
echo "Adding exception rules to Firewall to allow external traffic"
sleep 1
firewall-cmd --permanent --zone=public --add-port=22/tcp;
firewall-cmd --permanent --zone=public --add-port=80/tcp;
firewall-cmd --permanent --zone=public --add-port=443/tcp;
firewall-cmd --permanent --zone=public --add-port=9200/tcp;
firewall-cmd --permanent --zone=public --add-port=9300/tcp;
firewall-cmd --permanent --zone=public --add-port=32222/tcp;

        ##Install RPM's for specific Packages required for SugarCRM##
echo "Installing RPM  Packages for MySQL and Elasticsearch"
sleep 1
rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm;
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch;

        ##Create the Elasticsearch RPM file##
echo "Creating the Elasticsearch RPM config file"
sleep 1
touch /etc/yum.repos.d/elasticsearch.repo;
cat > /etc/yum.repos.d/elasticsearch.repo << EOF
[elasticsearch-1.4]
name=Elasticsearch repository for 1.4.x packages
baseurl=http://packages.elastic.co/elasticsearch/1.4/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
EOF

        ##Install the additional packages##
echo "Installing MySQL and Elasticsearch"
sleep 1
yum install -y mysql mysql-server elasticsearch;

        ##Add updates to Elasticsearch config files##
echo "Updating the Elasticsearch Configuration"
sleep 1
sed -i "s/\#cluster.name: elasticsearch/cluster.name: $sname/g;
        s/\#node.name: \"Franz Kafka\"/node.name: sugarcrm_node_1/g;
        s/\#bootstrap\.mlockall: true/bootstrap\.mlockall: true/g" /etc/elasticsearch/elasticsearch.yml

cat >> /etc/elasticsearch/elasticsearhc.yml <<EOF
# Increase ES Security as outlined by Sugar KB 'Installing and Administering Elasticsearch for Sugar 7'
action.disable_close_all_indices: true
action.disable_delete_all_indices: true
action.disable_shutdown: true
script.disable_dynamic: true
EOF

sed -i 's/\#ES_HEAP_SIZE=2g/ES_HEAP_SIZE=2g/g;
        s/\#MAX_OPEN_FILES=65535/MAX_OPEN_FILES=65535/g;
        s/\#MAX_LOCKED_MEMORY=/MAX_LOCKED_MEMORY=unlimited/g' /etc/sysconfig/elasticsearch

        ##Set MySQL and Elasticsearch to start at Boot and turn them on"
echo "Turning MySQL and Elasticsearch on, and setting them to start at Boot"        
sleep 1
chkconfig elasticsearch on && service elasticsearch start;
chkconfig mysqld on && service mysqld start;

        ##Launch the MySQL first run script##
echo "Performing MySQL First run configuration"
sleep 1
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"y\r\"
expect \"New password:\"
send \"$sqlroot\r\"
expect \"Re-enter new password:\"
send \"$sqlroot\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

        ##Update Mysql config file##
echo "Updating the MySQL config File"
sleep 1
sed -i 's/\[mysqld_safe\]/max_connections = 501\n&/;
        s/\[mysqld_safe\]/\n&/g' /etc/my.cnf        
        
        ##Create the SugarCRM Database##
echo "Creating the SugarCRM MySQL Database and setting access for the SugarCRM SQL User"
sleep 1
mysql -u root -p$sqlroot <<EOF
CREATE Database sugarcrm;
GRANT ALL PRIVILEGES ON sugarcrm.* To 'sugarmin'@'localhost' IDENTIFIED BY '$sqlpwd';
quit
EOF

        ##Set preferences for PHP##
echo "Configuring Preferences for PHP"
sleep 1
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g; 
        s/\;date.timezone =/date.timezone = Australia\/Brisbane/g;
        s/max_execution_time = 30/max_execution_time = 120/g;
        s/memory_limit = 128M/memory_limit = 512M/g;
        s/post_max_size = 8M/post_max_size = 100M/g;
        s/upload_max_filesize = 2M/upload_max_filesize = 100M/g' /etc/php.ini
