#!/bin/bash

source init.sh
source commit.sh
source log.sh
source head.sh

function help() {
  echo "DF - DeezFeeling Version Control System"
  echo "Available Commands: "
  echo " init                 -- init current directory"
  echo " log                  -- view history of commit"
  echo " commit [message]     -- commit changes"
  echo " head   [id]          -- checkout to commit id"
  echo " help                 -- help command"
}

if [ "$#" -lt 1 ]
then
  echo "[-] Please provide correct number of argument"
  help
  exit 1
fi

if [ "$1" != "init" -a "$1" != "log" -a "$1" != "commit" -a "$1" != "head" ]
then
  echo "[-] Please provide correct argument"
  help
  exit 1
fi

if [ "$1" == "help" ]
then
  help
  exit 0
fi

if [ "$1" == "init" ]
then
  echo "$(init)"
  exit 0
fi

if [ "$1" == "commit" ]
then
  echo "$(commit "$2")"
  exit 0
fi

if [ "$1" == "log" ]
then
  echo "$(log)"
  exit 0
fi

if [ "$1" == "head" ]
then

  if [ -z "$2" ]
  then
    echo "[-] Please provide command with commit id"
    help
    exit 1
  fi

  echo "$(head $2)"
  exit 0
fi
