#!/bin/bash

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

