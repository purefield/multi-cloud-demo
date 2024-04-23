# Output
RED='\033[0;31m'
GREEN='\033[0;32m'
NOC='\033[0m'
export OK='\033[0;32mOK\033[0m'
export ERROR='\033[0;31mERROR\033[0m'

function cmd {
 args=$@
 out=$(bash -c "$args" 2>&1)
if [ $? -eq 0 ]; then
  printf "[ $OK    ] $args\n"
  if [ -n "$out" ]; then
    echo "$out"
  fi
else
  printf "[ $ERROR ] $args\n"
fi
}

function __ {
 msg=$1
 echo; echo "$msg"
}

function ___ {
 msg=$1
 sec=$2
 echo; echo " * $msg"
 if [ -n "$2" ]; then
   sleep $sec
 else
   echo; read -p "Press any key to continue... " -n1 -s
 fi
 echo;
}
