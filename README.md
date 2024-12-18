
## af - archive files

_af_ is a simple file archiver.  Every time it runs it checks which
files have changed since the last archive volume was created and
copies the modified files into a directory.  _af_ stores the files as
copies of the original files.  Information about the standard UNIX
permissions and last-modified timestamp (which is used to determine if
a file did change) is stored in a text file.

This method has its limitations but

 1. It keeps things simple and makes it very easy to get files from an
    archive.  Even without _af_, it is simple to locate files manually
    and retrieve them with a _cp_ command.

 2. The storage format makes it easy to verify if a copy is complete.

 3. _af_ operations can be inspected by adding the `--show-commands`
    option.

See the manpages for documentation.


### Installation

_af_ is installed with the script _make-install_.  It's parameter is
usually _/bin_ or _/usr/bin_ and the script construct commands to
install the file in the expected locations:

    $ ./make-install /usr

The output must be piped to `sudo sh`.  Additionally, the script
_uninstall_ is stored in _lib/af_ which removes the installes files.

The mobile archives _moba.sh_ is installed from the output of
_lib/af/install-moba_.  The destination directory can be supplied as
command line parameter and _._ is assumed if it's missing.  The
commands can be inspected and must be piped to a shell interpreter.

    $ /usr/lib/af/install-moba | sh

Superuser permissions are usually not required.
