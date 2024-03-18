#!/bin/sh
wget https://cdn.mysql.com/archives/mysql-5.7/mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz
##解压
tar -xvf mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz -C ~/
cd ~
mv mysql-5.7.17-linux-glibc2.5-x86_64 mysql
#
###建好配置文件与mysql数据存储目录
mkdir /home/$USER/mysql/data
mkdir /home/$USER/mysql/conf
 
#echo $USER
 
cat > /home/$USER/mysql/conf/my.cnf << EOF
#!/bin/sh
[client]
default-character-set=utf8mb4
socket = /home/$USER/mysql/data/mysql.sock
[mysql]
port = 3306
socket = /home/$USER/mysql/data/mysql.sock
default-character-set=utf8mb4
[mysqld]
explicit_defaults_for_timestamp=true
port = 3306
default_storage_engine=InnoDB
basedir = /home/$USER/mysql
datadir = /home/$USER/mysql/data
socket  = /home/$USER/mysql/data/mysql.sock
character-set-client-handshake = FALSE
character-set-server=utf8mb4
collation-server = utf8mb4_unicode_ci
init_connect='SET NAMES utf8mb4'
max_connections = 2000
max_allowed_packet = 128M
innodb_file_per_table = 1
tmp_table_size = 134217728
max_heap_table_size = 134217728
lower_case_table_names=1
log-bin = mysql-bin
max_binlog_size = 1024M
expire_logs_days = 1
log_slave_updates = 1
server-id = 1
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
skip-grant-tables
EOF
 
cat >> ~/.bashrc << EOF
export PATH=/home/$USER/mysql/bin:\$PATH
EOF
source ~/.bashrc
 
 
##将sock文件链接到/tmp目录，默认mysql是读/tmp下的
ln -s /home/$USER/mysql/data/mysql.sock /tmp/mysql.sock
 
sh mysql_start
 
#初始化数据库
mysqld --defaults-file=/home/$USER/mysql/conf/my.cnf --user=$USER --initialize
 
 
#启动数据库
/home/$USER/mysql/bin/mysqld_safe --defaults-file=/home/$USER/mysql/conf/my.cnf --user=$USER &
 
#mysqladmin -u root -p password "root"
#mysql -uroot -proot
#更改密码为root
#set password for root@localhost = password("root")
 
