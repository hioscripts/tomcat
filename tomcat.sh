#!bin/bash

apac(){

echo -e "\nChecking if Apache tomcat installed already..."

t_dir="/usr/local/apache-tomcat-"

if [ -d  ${t_dir}*   ]; then

echo -e "\nApache Tomcat is installed already...Skipping"
	:
elif [ -d != ${t_dir}* ]; then 

echo -e "\nTomcat not installed...Continuing..."

echo -e "\nSelect the Tomcat version which you want to install...Please choose a number between 1 and 4"

tomcat_ver=("8.5" "9" "10" "11")

select tom_ver in "${tomcat_ver[@]}" ; do 

case $tom_ver in 

   "8.5")
          echo -e "\nInstalling Tomcat 8.5...."
          cd $HOME
          curl -Lo apachetomcat.tar.gz https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.92/bin/apache-tomcat-8.5.92.tar.gz
          tar -xvzf apachetomcat.tar.gz --directory /usr/local/
	  break 
;;
     "9")
      	  echo -e "\nInstalling Tomcat 9...."
      	  cd $HOME
          curl -Lo apachetomcat.tar.gz https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz
          tar -xvzf apachetomcat.tar.gz --directory /usr/local/
	  break
;; 

    "10")
	   echo -e "\nInstalling Tomcat 10...."
	   cd $HOME
	   curl -Lo apachetomcat.tar.gz https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.9/bin/apache-tomcat-10.1.9.tar.gz
	   tar -xvzf apachetomcat.tar.gz --directory /usr/local/
	  break
;;

    "11")
          echo -e "\nInstalling Tomcat 11...."
          cd $HOME
          curl -Lo apachetomcat.tar.gz https://archive.apache.org/dist/tomcat/tomcat-11/v11.0.0-M9/bin/apache-tomcat-11.0.0-M9.tar.gz
          tar -xvzf apachetomcat.tar.gz --directory /usr/local/
       break
;;

       *) 
	  echo -e "\nInvalid option..."
esac
done
break

echo "Opening port 8080 on local firewall...."

firewall-cmd --permanent --add-port=8080/tcp

firewall-cmd --reload

echo "Port 8080 is opened on firewall"

fi

}

echo -e "\nChecking if you are root user.."

if [ "$EUID" -eq 0  ]; then

while true; do

echo -en "\nThis script will install Tomcat, JDK, Apache Web Server, MySQL and PHP.Do you want to continue ?\n\nType y for yes and n for no : "
read a

if [[ "$a" == "y"  || "$a" == "Y" || "$a" == "yes"  ]]; then

echo -e "\nUpdating system..."

#yum update && yum upgrade -y

echo -e "\nInstalling prerequisite packages...."

yum install epel-release tar wget policycoreutils-python-utils -y

break

elif [[ "$a" == "n" || "$a" == "N" || "$a" == "no"  ]]; then
	echo -e "\nExiting script....."
exit 1
else
	echo -e "\nInvalid Character...Please type either y or n"
fi
done

else

echo -e "You are not root user. Please run this script as root user."

exit 1

fi

sleep 3


jdk_in(){

echo -e "\nChecking if any existing Java version is installed ...."

if [[ "$JAVA_HOME" == *"/opt/java"* || "$PATH" == *"/opt/java/bin"* ]]; then

echo -e "\nJava  $(java -version | grep "java" | awk '{print $2}') seems to be installed already..."

else

echo -e "\nJava does  not seems to be installed...Continuing..."
	:
echo -e "\nSelect the JDK version to be installed from the following options... Please choose a number between 1 and 6 "

jdk_ver=("1.8" "11" "17" "18" "19" "20") 

select javaver in "${jdk_ver[@]}"; do

case $javaver in 

 "1.8")
	echo -e "\nInstalling JDK version 1.8..."
	cd $HOME
	    curl -Lo jdklinux.tar.gz  http://jdk.orgfree.com/jdk-8u371-linux-x64.tar.gz
	    mkdir -p /opt/java/ 
        tar -xzf jdklinux.tar.gz -C /opt/java --strip-components=1
	break	
;;

   "11")
	echo -e "\nInstalling JDK version 11..."
	cd $HOME
	    curl -Lo jdklinux.tar.gz  http://jdk.orgfree.com/jdk-11.0.19_linux-x64_bin.tar.gz
	    mkdir -p /opt/java/
	    tar -xzf jdklinux.tar.gz -C /opt/java --strip-components=1
    break
;;
   "17")	
	echo -e "\nInstalling JDK version 17..."
	cd $HOME
        curl -Lo jdklinux.tar.gz https://download.oracle.com/java/17/archive/jdk-17.0.8_linux-x64_bin.tar.gz
        mkdir -p /opt/java/
        tar -xzf jdklinux.tar.gz -C /opt/java --strip-components=1
    break
;;
   "18")
	echo -e "\nInstalling JDK version 18..."
	cd $HOME
        curl -Lo jdklinux.tar.gz https://download.oracle.com/java/18/archive/jdk-18.0.2.1_linux-x64_bin.tar.gz
	    mkdir -p /opt/java/      
        tar -xzf jdklinux.tar.gz -C /opt/java --strip-components=1
    break
;;
   "19")
	echo -e "\nInstalling JDK version 19..."
	cd $HOME
	    curl -Lo jdklinux.tar.gz https://download.oracle.com/java/19/archive/jdk-19.0.2_linux-x64_bin.tar.gz
	    mkdir -p /opt/java/
        tar -xzf jdklinux.tar.gz -C /opt/java --strip-components=1
	break
;;
   "20")
	echo -e "\nInstalling JDK version 20..."
	cd $HOME
        curl -Lo jdklinux.tar.gz https://download.oracle.com/java/20/archive/jdk-20.0.2_linux-x64_bin.tar.gz
	    mkdir -p /opt/java/
        tar -xzf jdklinux.tar.gz -C /opt/java --strip-components=1
    break
;;
     *)
	echo -e "\nInvalid option..."
esac
done

sleep 3


export JAVA_HOME=/opt/java/

export PATH=/opt/java/bin:$PATH

echo -e "\nStarting Tomcat Service..."

sh /usr/local/apache-tomcat-*/bin/startup.sh

sleep 3

echo -en "\nCreating Java_Home path..."

cd $HOME

echo -en "\nexport JAVA_HOME=/opt/java/\n
export PATH=/opt/java/bin:$PATH"  >> .bashrc

fi

}

apcins() {

service_name="httpd"

if [ -d "/etc/httpd" ]  || (systemctl is-active --quiet "$service_name.service"); then

echo -e "\nApache Web Server is already installed...Skipping.."

elif !(systemctl is-active --quiet "$service_name.service") ; then

echo -e "\nInstalling Apache web server...."

yum install httpd -y

systemctl enable httpd

service httpd start 

echo -en "\nApache server installed successfully"

echo -en "\nOpening port 80 on local firewall...."

firewall-cmd --permanent --add-service=http

firewall-cmd --reload

echo -en "\nPort 80 is opened on firewall"

sleep 4

else
	:
fi

vir_ins(){
cd /etc/httpd/conf.d
echo -ne "\nEnter the domain name : "
read domain_name

touch "${domain_name%????}".conf

cat << EOF >> "${domain_name%????}".conf
<VirtualHost *:80>
ServerName $domain_name
ServerAlias www.$domain_name
ProxyPass /phpmyadmin !
ProxyRequests Off
ProxyPreserveHost On
ProxyPass / http://localhost:8080/
ProxyPassReverse / http://localhost:8080/
DocumentRoot /var/www/html/
ErrorLog /etc/httpd/logs/error_log
</VirtualHost>
EOF

echo "Virtual hosts created successfully".

sleep 3

echo "Changing permissions for /var/www/html/"

chown -R apache:apache /var/www/html/

chmod 755 /var/www/html/

echo "Permission applied successfully"

sleep 3

echo "Changing SElinux Permission..."

# chcon - is a SElinux command to change the security context of files and folders

chcon -R -t httpd_sys_content_t /var/www/html 
      
# SElinux command to manipulate the permissive policy and allow tomcat 

setsebool -P httpd_can_network_connect 1

}

while true; do 
	echo -en "\n\nDo you want to create virtual hosts for a domain name ? Type y for yes or n for no : "
	read v
if [[ "$v" == "y" || "$v" == "Y" || "$v" == "yes"  ]]; then
vir_ins
break

elif [[ "$v" == "n" || "$v" == "N" || "$v" == "no" ]]; then

echo -e "\nSkipping....."
	:
break

else
	echo -e "\nInvalid Character...Please type either y or n"
fi
done

}


mysql_ins(){

service_name="mysqld"

if [ -d "/var/lib/mysql" ] || (systemctl is-active --quiet "$service_name.service") ; then

sleep 4 

echo -e "\nMySQL is already installed and service is running"

elif !(systemctl is-active --quiet "$service_name.service") ; then

echo -e "\nInstalling MySQL...."

sleep 2

cd $HOME

echo "Downloading MySQL 8 Community repo..."

curl -Lo mysql80-community.rpm  https://dev.mysql.com/get/mysql80-community-release-el8-7.noarch.rpm

yum install mysql80-community.rpm -y 

echo "Mysql repository is installed"

#Disabling MySQL default module

yum module -y disable mysql

sleep 2

echo "Installing MySQL8 Community server"

yum install mysql-server -y

systemctl enable mysqld

systemctl start mysqld

echo "MySQL community server installed successfully" 

grep 'temporary password' /var/log/mysqld.log > tempass.txt

echo -e "\nMySQL root temp password saved in a file tempass.txt on the current directory" 

sleep 3

else 
    :

fi

}

php_myadmin(){

service_name="httpd"

if (systemctl is-active --quiet "$service_name.service") ; then

echo "Creating folder to install phpmyadmin in home directory..."

sleep 3

mkdir $HOME/phpMyAdmin

echo "Navigating to the phpmyadmin folder..."

cd $HOME/phpMyAdmin

curl -Lo phpMyAdmin.tar.gz https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz

tar -xzvf phpMyAdmin.tar.gz --strip-components=1 && cd ..

echo "Moving phpmyadmin to /usr/share location..."

mv phpMyAdmin /usr/share/phpMyAdmin

echo "Assigning apache permission for phpmyadmin directory ...."

chown -R apache:apache /usr/share/phpMyAdmin

chmod -R 755 /usr/share/phpMyAdmin

echo "Creating phpMyAdmin conf file..."

cd /etc/httpd/conf.d/ 

touch phpMyAdmin.conf

cat << EOF >> phpMyAdmin.conf
Alias /phpMyAdmin /usr/share/phpMyAdmin
Alias /phpmyadmin /usr/share/phpMyAdmin

<Directory /usr/share/phpMyAdmin/>
   AddDefaultCharset UTF-8

   <IfModule mod_authz_core.c>
     # Apache 2.4
     <RequireAny>
       Require all granted
     </RequireAny>
   </IfModule>
   <IfModule !mod_authz_core.c>
     # Apache 2.2
     Order Deny,Allow
     Allow from 127.0.0.1
     Allow from ::1
     Allow from all
   </IfModule>
</Directory>

<Directory /usr/share/phpMyAdmin/setup/>
   <IfModule mod_authz_core.c>
     # Apache 2.4
     <RequireAny>
       Require ip 127.0.0.1
       Require ip ::1
     </RequireAny>
   </IfModule>
   <IfModule !mod_authz_core.c>
     # Apache 2.2
     Order Deny,Allow
     Deny from All
     Allow from 127.0.0.1
     Allow from ::1
   </IfModule>
</Directory>
EOF
echo "Phpmyadmin config file created successfully"

sleep 4

echo "Applying SELinux permission...."

chcon -R -t httpd_sys_content_t /usr/share/phpMyAdmin/

elif !(systemctl is-active --quiet "$service_name.service") ; then

echo -e "\nApache Web Server is either not installed or apache web service is not running. Please recheck if apache server is installed/ service is running and try again."

sleep 3

fi

}

php_in(){

if [ -d  "/usr/share/phpMyAdmin" ]

then

echo "PhpMyAdmin Directory exists....Continuing PHP install"

echo "Installing PHP remi repository...."

sleep 3

cd $HOME

curl -Lo remi-release.rpm https://rpms.remirepo.net/enterprise/remi-release-8.rpm 

yum install remi-release.rpm -y

sleep 3

echo -e "Type a number between 1 and 5 to install the required PHP version : "

php_ver=("7.4" "8.0" "8.1" "8.2" "8.3")

select php_version in "${php_ver[@]}"; do

case $php_version in 

  "7.4")
	    echo "Installing php7.4..."
	    dnf module reset php -y
        dnf module install php:remi-7.4 -y
  	    dnf install php php-cli  php-mysqlnd -y
	 break
  ;;
  "8.0")
        echo "Installing php8.0..."
        dnf module reset php -y
        dnf module install php:remi-8.0 -y
        dnf install php php-cli php-mysqlnd -y
     break
  ;;

  "8.1")
        echo "Installing php8.1..."
        dnf module reset php -y
        dnf module install php:remi-8.1 -y
        dnf install php php-cli php-mysqlnd -y
      break
  ;;
  "8.2")
        echo "Installing php8.2..."
        dnf module reset php -y
        dnf module install php:remi-8.2 -y
        dnf install php php-cli php-mysqlnd -y
	break
  ;;
  "8.3")
        echo "Installing php8.3..."
        dnf module reset php -y
        dnf module install php:remi-8.3 -y
        dnf install php php-cli php-mysqlnd -y
	break
  ;;
      *)
	echo "Invalid option..."	
  ;;	
esac
done

elif [ -d != "/usr/share/phpMyAdmin" ]
then

echo -e "\nPhpMyAdmin directory does not exist.You need to install Apache Web server,phpMyAdmin first to continue installing PHP."

sleep 3

echo -e "\nExiting the script.."

exit 1

fi
}

while true; do

echo -en "\nDo you want to install Tomcat ? Type y for yes and n for no : "
read ap
if [[ "$ap" == "y" || "$ap" == "Y" || "$ap" == "yes" ]]; then
apac
break
elif [[ "$ap" == "n" || "$ap" == "N" || "$ap" == "no" ]]; then
        :
break
else
        echo -e "\nInvalid Character...Please type either y or n"
fi
done

while true; do

echo -en "\nDo you want to install JDK ? Type y for yes and n for no : "
read j
if [[ "$j" == "y" || "$j" == "Y" || "$j" == "yes"  ]]; then
jdk_in
break
elif [[ "$j" == "n" || "$j" == "N" || "$j" == "no" ]]; then
        :
break
else
        echo -e "\nInvalid Character...Please type either y or n"
fi
done


while true; do

echo -en "\nDo you want to install Apache Web Server ? Type y for yes and n for no : "
read web
if [[ "$web" == "y" || "$web" == "Y" || "$web" == "yes" ]]; then
apcins
break
elif [[ "$web" == "n" || "$web" == "N" || "$web" == "no"  ]]; then
	:
break
else
	echo -e "\nInvalid Character...Please type either y or n"
fi
done

while true; do 
	
echo -en "\nDo you want to install MySQL 8 ? Type y for yes and n for no : "
read ms

if [[ "$ms" == "y" || "$ms" == "Y" || "$ms" == "yes" ]]; then
mysql_ins
break
elif [[ "$ms" == "n" || "$ms" == "N" || "$ms" == "no" ]]; then
    :
break
else
	echo -e "\nInvalid Character...Please type either y or n"
fi
done

while true; do 

echo -en "\nDo you want to install PHPMyAdmin ? Type y for yes and n for no : "
read m

if [[ "$m" == "y" || "$m" == "Y" || "$m" == "yes" ]]; then
php_myadmin
break
elif [[ "$m" == "n" || "$m" == "N" || "$m" == "no" ]]; then
    :
break
else
	echo -e "\nInvalid Character...Please type either y or n"
fi
done

while true; do 

echo -en "\nDo you want to install PHP ? Type y for yes and n for no : "
read p 
if [[ "$p"  == "y" || "$p" == "Y" || "$p" == "yes"   ]]; then
php_in
break
elif [[ "$p" == "n" || "$p" == "N" || "$p" == "no"  ]]; then
exit 1
else 
    echo "\nInvalid character...Please type either y or n"
fi
done

echo "Restarting apache web server..."

if systemctl is-active --quiet "$service_name.service" ; then

systemctl restart httpd

echo "Installation is complete. Good Bye"
else
echo "Apache web server is not running or not installed...Skipping.."
exit 1
fi
