#!/bin/bash



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