#!/bin/bash
# Output
RED='\033[0;31m'
GREEN='\033[0;32m'
NOC='\033[0m'
export OK='\033[0;32mOK\033[0m'
export ERROR='\033[0;31mERROR\033[0m'

function cmd {
 unset OUTPUT
 local args=$@
 local out
 out=$(bash -c "$args" 2>&1)
 if [ $? -eq 0 ]; then
   _msg "$args" ok
   if [ -n "$out" ]; then
     export OUTPUT="$out"
     echo -e "$out"
   fi
 else
   _msg "$args" error
   trap 'echo; echo "Cancelled by user in cmd"; exit 130' INT
   echo; read -p "Press any key to continue... " -n1 -s
 fi
}
# Alias
_:(){ cmd "$@"; }

function ctrl_c(){
  export trappedCtrlC=1
}

function _loop {
  # oo 3 "ls -1 | wc -c"
  local args="${@:2}"
  local count=-1
  local readyCount=$1;
  __ "$args" cmd 
  __ "$readyCount <= " sameline
  trap ctrl_c INT
  export trappedCtrlC=0
  start_time="$(date -u +%s)"
  while true; do 
    cmd "$args" 1>/dev/null
    countNew=$OUTPUT
    if [[ ! "$count" == "$countNew" ]]; then 
      count="$countNew"
      echo -n "$count "
    fi 
    if [ $trappedCtrlC -ge 1 ]; then 
      unset trappedCtrlC
      count=$readyCount
      ___ "As you wish!!"
    fi 
    if [ "$count" -ge "$readyCount" ]; then 
      elapsed_total="$(date -d@$(($(date -u +%s)-$start_time)) -u +%M:%Ss)"
      __ "Waited: $elapsed_total" 5
      break 
    fi; 
    sleep 2 
  done
 trap - INT
}
# Alias
oo() { _loop "$@"; }


# format output with headings
function _msg {
 local msg=$1
 local fmt=$2
 echo; 
 case "$fmt" in
  1)
    echo '******************************************************************************************'
    echo '******************************************************************************************'
    echo "**"
    echo "** $msg"
    echo "**"
    echo '******************************************************************************************'
    echo '******************************************************************************************'
    ;;
  2)
    echo ' ******************************************************************************************'
    echo " *"
    echo " * $msg"
    echo " *"
    echo ' ******************************************************************************************'
    ;;
  3)
    echo ' ,~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    echo " | $msg"
    echo ' `~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    echo 
    ;;
  4)
    echo '  ........................................................................................'
    echo "  $msg"
    echo '  ````````````````````````````````````````````````````````````````````````````````````````'
    ;;
  5)
    echo " - $msg"
    echo
    ;;
  6)
    echo " * $msg"
    ;;
  cmd)
    echo -n " > $msg"
    ;;
  sameline)
    echo -n "   $msg"
    ;;
  error)
    printf "[ $ERROR ] $msg\n"
    ;;
  ok)
    printf "[ $OK    ] $msg\n"
    ;;
  *)
    echo "$msg"
    ;;
  esac
}
# Alias
__() { _msg "$@"; }

# Pause for user key or time
function _wait {
 local msg=$1
 local sec=$2
 echo; echo " * $msg"
 trap 'echo; echo "Cancelled by user in wait"; exit 130' INT
 if [ -n "$2" ]; then
   read -p "Wait for $sec sec - skip with any key" -n1 -st $sec
 else
   echo; read -p "Press any key to continue... " -n1 -s
 fi
 trap - INT
 echo;
}
# Alias
___() { _wait "$@"; }


# Prompt for input
function _ask {
 # example: _? "a or b" action b $1
 local msg=$1 # message to show
 local var=$2 # variable name to export
 local def=$3 # optional default value
 local ask=$4 # if not provided ask for input
 local input
 if [ -n "$var" ]; then
   if [[ "ask$ask" != "ask" ]]; then 
     input="$ask"
   else
     # Prompt the user with the default value
     __ "$msg [${def}]: " sameline
     read input
     # Use the default if no input is provided
     input="${input:-$def}"
   fi 
   # Export the input to the specified environment variable
   export "$var"="$input"
   echo " -> $var = $input"
 fi
 echo;
}
# Alias
function _? { _ask "$@"; }
