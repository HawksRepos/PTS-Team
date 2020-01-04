#!/bin/bash
#
# Title:      Plex Library
# org.Author(s):
#
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/install.sh
# KEY VARIABLE RECALL & EXECUTION
fid="/var/plexguide/plexlibrary"
if [[ ! -d "$fid" ]]; then
mkdir -p /var/plexguide/plexlibrary
apt update -yqq
apt install python-pip -yqq
pip install plexapi requests trakt ruamel.yaml lxml 1>/dev/null 2>&1
fi

# FUNCTIONS START ##############################################################
oldvalue(){
value="/var/plexguide/plexlibrary"
if [[ ! -d $value ]]; then
rm -rf /var/plexguide/plexlibrary; fi
}

# FIRST FUNCTION
variable() {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" >$1; fi
}

doneenter(){
 echo
  read -p 'All done | PRESS [ENTER] ' typed </dev/tty
  question1
}

# BAD INPUT
badinput() {
  echo
  read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed </dev/tty
  question1
}

api() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Trakt API-Key
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: In order for this to work, you must retrieve your API Key! Prior to
continuing, please follow the current steps.

[ 1 ] Visit - https://trakt.tv/oauth/applications
[ 2 ] Click - New Applications
[ 3 ] Name  - Whatever You Like
[ 4 ] Redirect UI - https://google.com
[ 5 ] Permissions - Click /checkin and /scrobble
[ 6 ] Click - Save App
[ 7 ] Copy the Client ID & Secret for the Next Step!

Go Back? Type > exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️ Type Trakt Username | Press [ENTER]: ' typed </dev/tty
  echo $typed >/var/plexguide/plexlibrary/trak.user
  read -p '↘️ Type API Client | Press [ENTER]: ' typed </dev/tty
  echo $typed >/var/plexguide/plexlibrary/trak.client
  read -p '↘️ Type API Secret | Press [ENTER]: ' typed </dev/tty
  echo $typed >/var/plexguide/plexlibrary/trak.secret

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    question1
  else
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SYSTEM MESSAGE: Traktarr API Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: The API Client and Secret is set! Ensure to setup your <paths> and
<profiles> prior to deploying Traktarr.

INFO: Messed up? Rerun this API Interface to update the information!

EOF

    read -p '🌎 Acknowledge Info | Press [ENTER] ' typed </dev/tty
    question1
  fi

}
selection1() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Library Type?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] TV
[2] Movie

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty

  case $typed in
  1) echo -e "TV" >/var/plexguide/plexlibrary/library.type && question1 ;;
  2) echo -e "Movie" >/var/plexguide/plexlibrary/library.type && question1 ;;
  *) badinput ;;
  esac
}

# FIRST QUESTION
question1() {
deploycheck
  ltype=$(cat /var/plexguide/plexlibrary/library.type)
  slurl=$(cat /var/plexguide/plexlibrary/source.url)
  plibs=$(cat /var/plexguide/plexlibrary/plex.library)
  fpath=$(cat /var/plexguide/plexlibrary/file.path)
  rname=$(cat /var/plexguide/plexlibrary/recipe.name)

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Plex - Library Interface || adamgot/python-plexlibrary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Library Type?                         [ $ltype ]
[2] Source List URL?                      [ $slurl ]
[3] Plex Source Library?                  [ $plibs ]
[4] Path to $ltype                        [ $fpath ]
[5] Recipe Name                           [ $rname ]

[7] Deploy Plex Library                  [ $dstatus ]
[8] Remove Plex Library

[C] Credits

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty

  case $typed in
  1) selection1 && clear && question1 ;;
  2) selection2 && clear && question1 ;;
  3) selection3 && clear && question1 ;;
  4) selection4 && clear && question1 ;;
  5) selection5 && clear && question1 ;;
  6) selection6 && clear && question1 ;;
  7) ansible-playbook /opt/plexguide/menu/pg.yml --tags plexlibrary && sleep 5 && clear &&  exit ;;
  8) selection7 && question1 ;;
  C) credits && clear && question1 ;;
  c) credits && clear && question1 ;;
  z) exit ;;
  Z) exit ;;
  *) question1 ;;
  esac
}

# FUNCTIONS END ##############################################################
oldvalue
section0
plexcheck
token
variable /var/plexguide/plexpatrol/video.transcodes "NON-SET"
variable /var/plexguide/plexpatrol/video.transcodes4k "NON-SET"
variable /var/plexguide/plexpatrol/audio.transcodes "NON-SET"
variable /var/plexguide/plexpatrol/check.interval "NON-SET"
variable /var/plexguide/plexpatrol/multiple.ips "NON-SET"
variable /var/plexguide/plexpatrol/kick.minutes "NON-SET"
deploycheck
question1
