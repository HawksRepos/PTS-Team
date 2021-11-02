#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'pgvault' >/var/plexguide/pgcloner.rolename
echo 'PTS-Vault' >/var/plexguide/pgcloner.roleproper
echo 'PTS-Vault' >/var/plexguide/pgcloner.projectname
echo 'master' >/var/plexguide/pgcloner.projectversion
echo 'pgvault.sh' >/var/plexguide/pgcloner.startlink

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 Vault is a combined group of services that utilizes the backup
and restore processes, which enables the safe storage and transport through
the use of Google Drive in a hasty and efficient manner!" >/var/plexguide/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
source /opt/plexguide/menu/functions/functions.sh

rolename=$(cat /var/plexguide/pgcloner.rolename)
roleproper=$(cat /var/plexguide/pgcloner.roleproper)
projectname=$(cat /var/plexguide/pgcloner.projectname)
projectversion=$(cat /var/plexguide/pgcloner.projectversion)
startlink=$(cat /var/plexguide/pgcloner.startlink)

mkdir -p "/opt/$rolename"

initial() {
    ansible-playbook "/opt/plexguide/menu/pgcloner/clone/primary.yml" >/dev/null 2>&1
    echo ""
    echo "💬  Pulling Update Files - Please Wait"
    file="/opt/$rolename/place.holder"
    waitvar=0
    while [ "$waitvar" == "0" ]; do
        sleep .5
        if [ -e "$file" ]; then waitvar=1; fi
    done
    bash /opt/${rolename}/${startlink}
}
initial
