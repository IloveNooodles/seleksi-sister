#!/bin/bash

function help() {
  echo "DF - DeezFeeling Version Control System"
  echo "Available Commands: "
  echo " init                 -- init current directory"
  echo " log                  -- view history of commit"
  echo " commit [message]     -- commit changes"
  echo " head   [id]          -- checkout to commit id"
  echo " help                 -- help command"
}

function init() {

  if test -d ".df"
  then
    echo "[-] Repository already created!"
    exit 1
  fi

  echo "[+] Initializing an empty repository"
  mkdir ".df"
  mkdir ".df/refs"
  mkdir ".df/refs/tags"
  mkdir ".df/snapshots"
  echo  "[+] repository created succesfully"
  exit 0
  
}

function log() {
  
  if test -d ".df"
  then 
    local dir="${PWD}/.df/snapshots"
    local num=$(ls $dir | wc -l)
    if [ $num == 0 ]
    then
      echo "[-] No commit has been made"
      exit 0
    fi

    for directory in $(ls $dir)
    do
      cat "$dir/$directory/.commit"
      echo -e "\n"
    done
    exit 0
  fi

  echo "[-] Repository hasn't been initialized";
  exit 1

}

function head(){
  
  if test -d ".df"
  then  
    local WD="${PWD}/.df/snapshots"
    local num=$(ls $dir | wc -l)
    if [ $1 -lt 0 -o $1 -gt $((num - 1)) ]  
    then
      echo "[-] No such commit id"
      exit 1
    fi

    rm -rf *
    cp -r "$WD/$1/"* .
    echo "[*] Successfully checkout to the commit-ID of $1"
    exit 0
  fi

  echo "[-] Repository hasn't been initialized";
  exit 1

}

function commit() {

  if test -d ".df"
  then
    local WD="${PWD}/.df/snapshots"
    local message="$1"
    echo "[*] Commiting changes"
    local CURRENT_VERSION=$(ls $WD | wc -l)
    test -d "$WD/$CURRENT_VERSION" || mkdir "$WD/$CURRENT_VERSION"
    cp -r * "$WD/$CURRENT_VERSION"
    touch "$WD/$CURRENT_VERSION/.commit"
    echo "commitID  : $CURRENT_VERSION" >> "$WD/$CURRENT_VERSION/.commit"
    echo "author    : $USER" >> "$WD/$CURRENT_VERSION/.commit"
    echo "time      : $(date)" >> "$WD/$CURRENT_VERSION/.commit"
    echo "message   : $message" >> "$WD/$CURRENT_VERSION/.commit"
    echo "[*] Successfully commited changes with the commit-ID of $CURRENT_VERSION"
    exit 0
  fi

  echo "[-] Repository hasn't been initialized"
  exit 1
  
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
