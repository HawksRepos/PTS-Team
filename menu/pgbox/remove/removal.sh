#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
rm -rf /tmp/backup.build 1>/dev/null 2>&1
rm -rf /tmp/backup.list 1>/dev/null 2>&1
rm -rf /tmp/backup.final 1>/dev/null 2>&1

tree -d -L 1 /opt/appdata | awk '{print $2}' | tail -n +2 | head -n -2  >/tmp/backup.list
sed -i -e "/traefik/d" /tmp/backup.list
sed -i -e "/oauth/d" /tmp/backup.list
sed -i -e "/wp-*/d" /tmp/backup.list
sed -i -e "/plexguide/d" /tmp/backup.list
sed -i -e "/cloudplow/d" /tmp/backup.list
sed -i -e "/phlex/d" /tmp/backup.list
sed -i -e "/plexguide/d" /tmp/backup.list
sed -i -e "/plexpatrol/d" /tmp/backup.list
sed -i -e "/uploader/d" /tmp/backup.list
sed -i -e "/portainer/d" /tmp/backup.list

#### Commenting Out To Let User See
num=0
while read p; do
  let "num++"
  echo -n $p >>/tmp/backup.final
  echo -n " " >>/tmp/backup.final
  if [[ "$num" == 7 ]]; then
    num=0
    echo " " >>/tmp/backup.final
  fi
done </tmp/backup.list

running=$(cat /tmp/backup.final)

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀  App Removal Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  Backup Data if Required! Removes Local App Data!

💾 Current Installed Apps or Folders

$running

[ Z ] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '🌍 Type APP for QUEUE | Press [[ENTER]: ' typed </dev/tty

if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then exit; fi

tcheck=$(echo $running | grep "\<$typed\>")
if [[ "$tcheck" == "" ]]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Type an Application Name! Case Senstive! Restarting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1.5
     bash /opt/plexguide/menu/pgbox/remove/removal.sh
  exit
fi

if [[ "$typed" == "" ]]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - The App Name Cannot Be Blank!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 3
     bash /opt/traefik/tld.sh
  exit
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💎  PASS: Uninstalling - $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 1.5
##check for running docker 
drunning=$(docker ps --format '{{.Names}}' | grep "$typed")
if [[ "$drunning" == "$typed" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Stopping | Removing > $typed Docker Container
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
     docker stop $typed 1>/dev/null 2>&1
     docker rm $typed 1>/dev/null 2>&1
	 rm -rf /opt/appdata/$typed
fi

if [[ "$drunning" != "$typed" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Removing /opt/appdata/$typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
	 rm -rf /opt/appdata/$typed
fi

file="/opt/coreapps/apps/$typed.yml"
if [[ -e "$file" ]]; then
  check=$(cat /opt/coreapps/apps/$typed.yml | grep '##PG-Community')
  if [[ "$check" == "##PG-Community" ]]; then rm -r /opt/communityapps/apps/$typed.yml; fi
  rm -rf /var/plexguide/community.app
fi

sleep 1.5

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: Uninstalled - $typed - Exiting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 2
