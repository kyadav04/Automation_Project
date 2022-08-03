#!/bin/bash

#Script updates the package information
while read package
do
apt install ${package} -y
done < requirement.txt

#Script ensures that the HTTP Apache server is installed

c2=`dpkg --get-selections | grep apache`
if [[ $? > 0 ]]
then
  sudo apt install apache2
fi

#Script ensures that HTTP Apache server is running

c1=`ps -eaf | grep -i apache2 |sed '/^$/d' | wc -l`
if [[ $c1 > 1 ]]
then
  echo "apache2 is installed and running"
else
  sudo systemctl start apache2
fi

#Script ensures that HTTP Apache service is enabled

systemctl list-unit-files | grep enabled >> output2.txt
if ! [ grep -q "apache2" output2.txt ]; then
        systemctl enable apache2
fi

#Create Tar File

tar -cf kanishk-httpd-logs-$(date '+%d%m%Y-%H%M%S').tar /temp/

#Archiving logs to S3

aws s3 \
cp /tmp/${kanishk}-httpd-logs-$ {(date '+%d%m%Y-%H%M%S')}.tar \
s3://$ {upgrad-kanishkyadav}/${kanishk}-httpd-logs-$ {(date '+%d%m%Y-%H%M%S')}.tar

#Cron Job

CRON='/etc/cron.d/automation' if test -f "$CRON" then
    echo "cron exists" else
    touch $CRON
    echo "SHELL=/bin/bash" > $CRON
    echo 
"PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >> 
$CRON
    echo "0 20 * * * root /root/Automation_Project/automation.sh" >> 
$CRON
fi

