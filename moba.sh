#/bin/sh
#


error() {
    echo "$@" >&2
    exit 1
    }


# listConfigs hostname
listConfigs() {
    /usr/bin/gawk '
	BEGIN {
		argi = 1;
		host = ARGV[argi];  ARGV[argi++] = "";
		if (host == "")
			host = ENVIRON["hostname"];

		cmd = "find conf -name '\''*.conf'\'' -print | sort";
		while (cmd | getline fn > 0) {
			n = split(fn, x, "/");
			if (n > 3)
				continue;

			hostname = x[2];
			bn = x[3];
			sub(/\.conf$/, "", bn);

			if (host == hostname) {
				# List all configuration files for the local host
				if (conf[host] == "")
					conf[host] = "*";

				conf[host] = conf[host] " " bn;
				continue;
				}

			while (getline line <fn > 0) {
				sub(/^[ \t]*/, "", line);
				if (substr(line, 1, 1) == "#")
					continue;
				else if (substr(line, 1, 1) == "[")
					break;
				else if (line ~ /^mtp[ \t]+/) {
					conf[hostname] = conf[hostname] " " bn;
					break;
					}
				}

			close (fn);
			}

		if (close (cmd) != 0)
			exit (1);

		n = asorti(conf, x);
		for (i = 1; i <= n; i++) {
			hostname = x[i];
			printf ("  %s %s\n", hostname, conf[hostname]);
			}

		exit (0);
		}' "$@"
    }



# doOperation op config
doOperation() {
    local conf="$CONF/$2.conf"
    if [ ! -f "$conf" ]
    then echo $program: no such configuration: $2 >&2; return 1; fi

    local data="$DATA/$2"
    mkdir -p "$data"  ||  exit

    gawk -f "$bin"/af -- -m mobile -s -c "$conf" -D "$data" $1
    if [ $? != 0 ]; then
        ERR="$ERR $2"
    fi
    }


processAll() {
    for conf in $files; do
	p=`basename "$conf" .conf`
	echo
	echo == processing "$p" ...
    	doOperation $1 "$p"
    done
    }


usage() {
    # Use $thisbin to allow `sh moba.sh` from outside moba's usual
    # directory tree (i.e., in source directory).
    version=$(gawk -f "${thisbin}/af" -- -VV)

    echo "moba.sh $version - mobile archiver

  Usage: sh moba.sh [-H <host>] <op> [<conf> ...]

performs operation <op> on all (or listed) configurations <conf>
for the local host.

Options:

  -H <host>		runs operations for <host> instead the local host.

Valid operations are

  config		show configuration data.
  create		archive modified files.
  edit			edit first configuration.
  list			list modified files.
  show			show af commands but do not execute.

Available hosts and configurations are:
  "

    listConfigs "$hostname"

  relbase=$(realpath --relative-to "$thisdir" "$bin/..")
  echo "
Archives are stored below ${relbase}/data.

Other operations in ${dir} are:

  delete-files		delete files from an archive.
  extract-volumes	get specific volumes from an archive.
  restore-files		restore (parts of) an archive volume.

Run the scripts without an argument to get a brief description or
see ${relbase}/doc.
  "
    }


thisdir=`pwd`

program=`basename "$0"`
dir=`dirname "$0"`
thisbin=$(realpath "$dir")
cd "$dir"/..  ||  exit

BASE=`pwd`
bin="$BASE/bin"


hostname=`hostname`
if [ "$#" = 0 ]; then
    usage
    exit
fi


# Take hostname from option `-H`
if [ "$1" = "-H" ]; then
    hostname=$2
    shift 2  ||  exit 1

    if [ ! -d "./conf/$hostname" ]; then
        error "no such directory: conf/$hostname"
    fi
fi

CONF="./conf/$hostname"
DATA="./data/$hostname"

for D in "$CONF" "$DATA"; do
  if [ ! -d "$D" ]
  then
    echo creating directory $D >&2
    mkdir -p "$D"  ||  exit 1
  fi
done

files=`ls -1 "$CONF"/*.conf 2>/dev/null`
if [ "$files" = "" ]; then
    error "$program: no configuration files found in $BASE/conf/$hostname"
fi


op=$1; shift
if [ "$op" = "copy" ]; then op=create; fi


if [ "$op" = "edit" ]; then
    if [ "$#" = 0 ]; then
        fn=$(echo $files | cut -d ' ' -f 1)
    else
        fn="$CONF/$1.conf"
    fi
    nano "$fn"
    exit
fi


if [ "$#" = 0 ]; then
    processAll $op
else
    for I in $*; do
        doOperation $op $I
    done
fi


if [ "$ERR" != "" ]; then
    echo $program: errors occured for: $ERR >&2
    exit 1
fi

