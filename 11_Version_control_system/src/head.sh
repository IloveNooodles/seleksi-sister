#!/bin/bash

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