#!/bin/bash
# A Simple Shell Script to Backup Red Hat / CentOS / Fedora / Debian / Ubuntu Apache Webserver and SQL Database
# Path to backup directories
DIRS="/var/www/www.botfrank.zonedns.education/"

# Store todays date
NOW=$(date +"%F")

# Store backup path
BACKUP="/backup/$NOW"

# Backup file name hostname.time.tar.gz
BFILE="$(hostname).$(date +'%T').tar.gz"
MFILE="$(hostname).$(date +'%T').mysql.sq.gz"

# Set MySQL username and password
MYSQLUSER="wordpress_user"
MYSQLPASSWORD="Cegep2020"

# Paths for binary files
TAR="/bin/tar"
MYSQLDUMP="/usr/bin/mysqldump"
GZIP="/bin/gzip"
LOGGER="/usr/bin/logger"

# make sure backup directory exists
[ ! -d $BACKUP ] && mkdir -p ${BACKUP}

# Log backup start time in /var/log/messages
$LOGGER "$0: *** Backup started @ $(date) ***"

# Backup websever dirs
$TAR -zcvf ${BACKUP}/${BFILE} ${DIRS}

# Backup MySQL
$MYSQLDUMP -u ${MYSQLUSER} -h localhost -p${MYSQLPASSWORD} --all-databases | $GZIP -9 > ${BACKUP}/${MFILE}

mkdir -p ${BACKUP}/${NOW}
mv ${BACKUP} /var/surveillance/

# Log backup end time in /var/log/messages
$LOGGER "$0: *** Backup Ended @ $(date) ***"
