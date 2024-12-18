#!/bin/sh
#

error() {
	echo "$0: $@" >&2
	exit 1
	}

usage() {
	echo "$0 <config-name> <dir> ..." >&2
	exit 0
	}

SCRIPT=$(realpath $0)
DIR=$(dirname "$SCRIPT")
BASE=$(dirname "$DIR")


NAME=$1;  shift  ||  usage
HOSTDIR="$BASE/conf/$(hostname)"
CONFIG="$HOSTDIR/$NAME.conf"

#test -f "$CONFIG"  &&  error "file exists: $CONFIG"
test -d "$HOSTDIR"  ||  mkdir "$HOSTDIR"  ||
  error "cannot create directory: $HOSTDIR"

echo "# $CONFIG"
{ for I in $@; do
    echo "src $I"
  done
  echo
  echo "af-mode mtp"
  echo "show-progress yes"
  }

	
