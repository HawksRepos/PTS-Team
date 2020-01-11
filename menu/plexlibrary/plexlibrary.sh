#!/bin/bash
#
# Title:      Plex Library
# org.Author(s): MrDoob, Hawkinzzz, adamgot
#
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/install.sh
# KEY VARIABLE RECALL & EXECUTION
fid1="/var/plexguide/plexlibrary"
fid2="/mnt/plexlib"
fid3="/mnt/plexlib/movies"
fid4="/mnt/plexlib/tv"
if [[ ! -d "$fid1" && ! -d "$fid2" && ! -d "$fid3" && ! -d "$fid4" ]]; then
mkdir -p "$fid" && apt-get update -yqq
sleep 0.5
apt-get install python-pip -yqq
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

# All DONE
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

#ADD PLEX TOKEN
tokencreate() {
X_PLEX_TOKEN=$(sudo cat "/opt/appdata/plex/database/Library/Application Support/Plex Media Server/Preferences.xml" | sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1)
echo $X_PLEX_TOKEN >/var/plexguide/plexlibrary/plex.token
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
<profiles> prior to deploying Plex-Library.

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
selection2() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Source List URL?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Visit https://github... to look for example lists.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type URL | Press [ENTER]: ' typed </dev/tty

  echo $typed >/var/plexguide/plexlibrary/source.url && question1 ;;
}
selection3() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Plex Source Library?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

What library are we taking the films from. (Example 'Movies')

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty

  echo $typed >/var/plexguide/plexlibrary/plex.library && question1 ;;
}

selection4() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Path to Movies/TV Files?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Example: '/mnt/unionfs/movies'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty

  echo $typed >/var/plexguide/plexlibrary/file.path && question1 ;;
}
selection5() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Recipe Name?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

What would you like your library to be called (Example: Movies - Trending)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty

  echo $typed >/var/plexguide/plexlibrary/recipe.name && question1 ;;
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
[4] Path to Movie/TV files                [ $fpath ]
[5] Recipe Name                           [ $rname ]

[A] Deploy Plex Library                  [ $dstatus ]
[R] Remove Plex Library

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
  A) ansible-playbook /opt/plexguide/menu/pg.yml --tags plexlibrary && sleep 5 && clear && exit ;;
  a) ansible-playbook /opt/plexguide/menu/pg.yml --tags plexlibrary && sleep 5 && clear && exit ;;
  R) rplexlib && question1 ;;
  r) rplexlib && question1 ;;
  C) credits && clear && question1 ;;
  c) credits && clear && question1 ;;
  z) exit ;;
  Z) exit ;;
  *) question1 ;;
  esac
}

# FUNCTIONS END ##############################################################
tokencreate
variable /var/plexguide/plexlibrary/library.type "NON-SET"
variable /var/plexguide/plexlibrary/source.url "NON-SET"
variable /var/plexguide/plexlibrary/plex.library "NON-SET"
variable /var/plexguide/plexlibrary/file.path "NON-SET"
variable /var/plexguide/plexlibrary/recipe.name "NON-SET"
deploycheck
question1
