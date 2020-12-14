## Automatisation avec CRON

- crontab -e

## ALLER CHERCHER LES BUILD ESSENTIALS
apt-get install build-essential

## CRÉER LES COMPTES NÉCESSAIRES
useradd nagios

groupadd nagcmd

usermod -a -G nagcmd nagios

usermod -a -G nagcmd www-data

## TÉLÉCHARGER LES PACKAGES NAGIOS
mkdir downloads

cd downloads

wget https://ufpr.dl.sourceforge.net/project/nagios/nagios-4.x/nagios-4.4.2/nagios-4.4.2.tar.gz

## EXTRAIRE,COMPILER ET INSTALLER LE PACKAGE NAGIOS
tar -zxvf nagios-4.4.2.tar.gz

cd nagios-4.4.2/

sudo ./configure --with-nagios-group=nagios --with-command-group=nagcmd

sudo make all

sudo make install

sudo make install-init

sudo make install-config

sudo make install-commandmode

sudo make install-webconf

sudo make install-daemoninit

## CRÉER LE MOT DE PASSE DU COMPTE ADMINISTRATEUR NAGIOS
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

New password: *****
Re-type new password: *****
Adding password for user nagiosadmin

## S’ASSURER QUE LES MODULES APACHE SONT ACTIVER
sudo a2enmod rewrite

sudo a2enmod cgi

systemctl restart apache2

## VÉRIFIER LA CONFIGURATION DE NAGIOS
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

## DÉMARRER NAGIOS ET ACCEDER A L’INTERFACE WEB
service nagios start

Une fois nagios démarrer aller sur votre navigateur et ouvrir votre adresse ip /nagios et se connecter avec le compte administrateur : nagiosadmin et votre mot de passe.

# INSTALLATION DES PLUGINS
## INSTALLATION DES PACKAGES REQUIS
apt-get install autoconf libc6 libmcrypt-dev libssl-dev bc

apt-get install gawk dc snmp libnet-snmp-perl gettext libperl-dev

apt-get install libpqxx3-dev libdbi-dev libldap2-dev

apt-get install libmysqlclient-dev smbclient qstat fping

apt install build-essential libgd-dev openssl libssl-dev unzip apache2 -y

apt install libcarp-clan-perl rrdtool php-rrd libssl1.0-dev

## TÉLÉCHARGER LES PLUGINS
cd /downloads

wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz

## EXTRAIRE,COMPILER ET INSTALLER LES PLUGINS
tar -zxvf nagios-plugins-2.2.1.tar.gz

cd nagios-plugins-2.2.1/

./configure --enable-perl-modules

make

make install

## REDEMARRER NAGIOS
service nagios restart

# NAGIOS GRAPH
## TELECHARGER ET EXTRAIRE
wget ’https://downloads.sourceforge.net/project/nagiosgraph/nagiosgraph/1.5.2/nagiosgraph-1.5.2.tar.gz’ -O nagiosgraph-1.5.2.tar.gz

tar -xvf nagiosgraph-1.5.2.tar.gz

## INSTALLER DÉPENDANCE ET NAGIOS GRAPH PLUGIN
apt install libnet-snmp-perl libsensors4 libsnmp-base libtalloc2 libtdb1 libwbclient0 snmp whois mrtg libcgi-pm-perl librrds-perl libgd-perl libnagios-object-perl nagios-plugins-contrib

./install.pl --check-prereq

./install.pl --layout standalone --prefix /usr/local/nagiosgraph

Le résultat de la commande devrait être comme ceci :

Destination directory (prefix)? [/usr/local/nagiosgraph]

Location of configuration files (etc-dir)? [/usr/local/nagiosgraph/etc]

Location of executables? [/usr/local/nagiosgraph/bin]

Location of CGI scripts? [/usr/local/nagiosgraph/cgi]

Location of documentation (doc-dir)? [/usr/local/nagiosgraph/doc]

Location of examples? [/usr/local/nagiosgraph/examples]

Location of CSS and JavaScript files? [/usr/local/nagiosgraph/share]

Location of utilities? [/usr/local/nagiosgraph/util]

Location of state files (var-dir)? [/usr/local/nagiosgraph/var]

Location of RRD files? [/usr/local/nagiosgraph/var/rrd]

Location of log files (log-dir)? [/usr/local/nagiosgraph/var/log]

Path of log file? [/usr/local/nagiosgraph/var/log/nagiosgraph.log]

Path of CGI log file? [/usr/local/nagiosgraph/var/log/nagiosgraph-cgi.log]

Base URL? [/nagiosgraph]

URL of CGI scripts? [/nagiosgraph/cgi-bin]

URL of CSS file? [/nagiosgraph/nagiosgraph.css]

URL of JavaScript file? [/nagiosgraph/nagiosgraph.js]

URL of Nagios CGI scripts? [/nagios/cgi-bin]

Path of Nagios performance data file? [/tmp/perfdata.log]

username or userid of Nagios user? [nagios]

username or userid of web server user? [www-data]

Modify the Nagios configuration? [n] y

Path of Nagios configuration file? [/usr/local/nagios/etc/nagios.cfg]

Path of Nagios commands file? [/usr/local/nagios/etc/objects/commands.cfg]

Modify the Apache configuration? [n] y

Path of Apache configuration directory? /etc/apache2/sites-enabled

## S’ASSURER QUE LA CONFIG NAGIOS POUR APACHE SOIT COMME CECI
ScriptAlias /nagiosgraph/cgi-bin “/usr/local/nagiosgraph/cgi”

<Directory “/usr/local/nagiosgraph/cgi”>

Options ExecCGI

AllowOverride None

Order allow,deny

Allow from all

Require all granted

</Directory>

Alias /nagiosgraph “/usr/local/nagiosgraph/share”

<Directory “/usr/local/nagiosgraph/share”>

Options None

AllowOverride None

Order allow,deny

Allow from all

Require all granted

</Directory>

## AVOIR CETTE CONFIG DANS LA MAIN CONFIG DE NAGIOS
nano /usr/local/nagios/etc/nagios.cfg

process_performance_data=1

service_perfdata_file=/usr/local/nagios/var/service-perfdata.log

service_perfdata_file_template=$LASTSERVICECHECK$||$HOSTNAME$||$SERVICEDESC$||$SERVICEOUTPUT$||$SERVICEPERFDATA$

service_perfdata_file_mode=a

service_perfdata_file_processing_interval=30

service_perfdata_file_processing_command=process-service-perfdata-for-nagiosgraph

## S’ASSURER D’AVOIR CETTE CONFIG DE COMMAND NAGIOSGRAPH
nano /usr/local/nagios/etc/objects/commands.cfg

define command {

command_name process-service-perfdata-for-nagiosgraph

command_line /usr/local/nagiosgraph/bin/insert.pl
}

## CRÉER UN TEMPLATE POUR NOS SERVICES
nano /usr/local/nagios/etc/objects/templates.cfg

## ALLER DANS CHANGER LE USE DANS LES DEFINE_SERVICE POUR NOTRE TEMPLATE
nano /usr/local/nagios/etc/objects/localhost.cfg

## ACTIVER HTTPS
sudo certbot --apache

Et choisir votre site www.nomdomaine