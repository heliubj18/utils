#!/bin/sh
set -e

function check_cmds()
{
   local cmds=$1
   for cmd in "${cmds[@]}"; do
      if ! command -v "$cmd" > /dev/null; then
        echo "Error: $cmd command not found, exit"
        exit 1
      fi
   done
}

function check_cli_dependency()
{
  local cli_dep=(go git)
  check_cmds $cli_dep
}

function check_s3_dependency()
{
  local s3_dep=(aws)
  check_cmds $s3_dep

}

function check_hypershift_install_dependency()
{
  local hypershift_dep=(hypershift aws oc)
  check_cmds $hypershift_dep
  oc version
}


