#!/bin/sh

#Add SCOM MS to hosts
echo '' >> /etc/hosts
echo '#SCOM MS' >> /etc/hosts
echo '10.153.122.28	SMO00EPA31.corpnet.landbank.com.tw' >> /etc/hosts
echo '10.153.122.29	SMO00EPA32.corpnet.landbank.com.tw' >> /etc/hosts
echo '10.153.122.30	SMO00EPA33.corpnet.landbank.com.tw' >> /etc/hosts
echo '10.153.122.31	SMO00EPA34.corpnet.landbank.com.tw' >> /etc/hosts

#Add permission in sudoers for SCOM
echo '' >> /etc/sudoers
echo '#-----------------------------------------------------------------------------------' >> /etc/sudoers
echo '#User configuration for Operations Manager agent for a user with the name: monuser' >> /etc/sudoers
echo ' #General requirements' >> /etc/sudoers
echo ' Defaults:monuser !requiretty' >> /etc/sudoers
echo ' #Agent maintenance (discovery, install, uninstall, upgrade, restart, cert signing)' >> /etc/sudoers
echo ' monuser ALL=(root) NOPASSWD: /bin/sh -c cp /tmp/scx-monuser/scx.pem /etc/opt/microsoft/scx/ssl/scx.pem; rm -rf /tmp/scx-monuser; /opt/microsoft/scx/bin/tools/scxadmin -restart' >> /etc/sudoers
echo ' monuser ALL=(root) NOPASSWD: /bin/sh -c sh /tmp/scx-monuser/GetOSVersion.sh; EC=$?; rm -rf /tmp/scx-monuser; exit $EC' >> /etc/sudoers
echo ' monuser ALL=(root) NOPASSWD: /bin/sh -c  cat /etc/opt/microsoft/scx/ssl/scx.pem' >> /etc/sudoers
echo ' monuser ALL=(root) NOPASSWD: /bin/sh -c  rpm -e scx' >> /etc/sudoers
echo ' monuser ALL=(root) NOPASSWD: /bin/sh -c /bin/rpm -F --force /tmp/scx-monuser/scx-1.[0-9].[0-9]-[0-9][0-9][0-9].rhel.[0-9].x[6-8][4-6].rpm; EC=$?; cd /tmp; rm -rf /tmp/scx-monuser; exit $EC' >> /etc/sudoers
echo ' monuser ALL=(root) NOPASSWD: /bin/sh -c /bin/rpm -U --force /tmp/scx-monuser/scx-1.[0-9].[0-9]-[0-9][0-9][0-9].rhel.[0-9].x[6-8][4-6].rpm; EC=$?; cd /tmp; rm -rf /tmp/scx-monuser; exit $EC' >> /etc/sudoers
echo '#Log file monitoring' >> /etc/sudoers
echo ' monuser ALL=(root) NOPASSWD: /opt/microsoft/scx/bin/scxlogfilereader -p' >> /etc/sudoers
echo '#End user configuration for Operations Manager agent' >> /etc/sudoers
echo '#-----------------------------------------------------------------------------------' >> /etc/sudoers
echo '' >> /etc/sudoers

#Create user for SCOM
useradd -s /sbin/false monuser
echo "monuser:monuser" | passwd

#Create user account & Setting permission for catch data
useradd SCOMUser
echo "SCOMUser:SCOMUser" | chpasswd

#Monitor initial setting
mkdir /home/SCOMUser/scom
chmod 777 /home/SCOMUser/scom
mkdir /home/SCOMUser/scom/log
chmod 777 /home/SCOMUser/scom/log

echo "#!/bin/sh" > /home/SCOMUser/scom/scom.sh
echo "mall=\`ls -lat /var/log | grep messages | awk '{print \$NF}'\`" >> /home/SCOMUser/scom/scom.sh
echo "mf=\`echo \$mall | awk '{print \$1}'\`" >> /home/SCOMUser/scom/scom.sh
echo "ms=\`echo \$mall | awk '{print \$2}'\`" >> /home/SCOMUser/scom/scom.sh
echo "sall=\`ls -lat /var/log | grep secure | awk '{print \$NF}'\`" >> /home/SCOMUser/scom/scom.sh
echo "sf=\`echo \$sall | awk '{print \$1}'\`" >> /home/SCOMUser/scom/scom.sh
echo "ss=\`echo \$sall | awk '{print \$2}'\`" >> /home/SCOMUser/scom/scom.sh
echo "aall=\`ls -lat /var/log/audit | grep audit | awk '{print \$NF}'\`" >> /home/SCOMUser/scom/scom.sh
echo "af=\`echo \$aall | awk '{print \$1}'\`" >> /home/SCOMUser/scom/scom.sh
echo "as=\`echo \$aall | awk '{print \$2}'\`" >> /home/SCOMUser/scom/scom.sh

echo "/bin/cat /etc/passwd > /home/SCOMUser/scom/log/passwd.log" >> /home/SCOMUser/scom/scom.sh
echo "/bin/cat /etc/shadow > /home/SCOMUser/scom/log/shadow.log" >> /home/SCOMUser/scom/scom.sh
echo "/bin/cat /etc/group > /home/SCOMUser/scom/log/group.log" >> /home/SCOMUser/scom/scom.sh
echo "/bin/cat /var/log/\$mf > /home/SCOMUser/scom/log/messages.log" >> /home/SCOMUser/scom/scom.sh
echo "/bin/cat /var/log/\$ms > /home/SCOMUser/scom/log/messages.1.log" >> /home/SCOMUser/scom/scom.sh
echo "/bin/cat /var/log/\$sf > /home/SCOMUser/scom/log/secure.log" >> /home/SCOMUser/scom/scom.sh
echo "/bin/cat /var/log/\$ss > /home/SCOMUser/scom/log/secure.1.log" >> /home/SCOMUser/scom/scom.sh
echo "#/bin/cat /var/log/audit/\$af > /home/SCOMUser/scom/log/audit.log.log" >> /home/SCOMUser/scom/scom.sh
echo "#/bin/cat /var/log/audit/\$as > /home/SCOMUser/scom/log/audit.log.1.log" >> /home/SCOMUser/scom/scom.sh

chmod 755 /home/SCOMUser/scom/scom.sh
sh /home/SCOMUser/scom/scom.sh

echo '0 0 * * * root /bin/sh /home/SCOMUser/scom/scom.sh >/dev/null 2>&1' >> /etc/crontab

#Fix LANG & LC_ALL script
echo '#!/bin/sh' > /home/SCOMUser/scom/fix.sh
echo "echo \"export LANG=en_US.utf8\" >> /opt/microsoft/scx/bin/tools/setup.sh" >> /home/SCOMUser/scom/fix.sh
echo "echo \"export LC_ALL=en_US.utf8\" >> /opt/microsoft/scx/bin/tools/setup.sh" >> /home/SCOMUser/scom/fix.sh

#Finish
echo 'Create user account for monitor & monitor initail setting is finished!'
