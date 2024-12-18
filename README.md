
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

_af_ and its scripts can be installed from the Debian archive or by
running `sudo make -f af.makefile install`.  Execute first with `-n` to
see what make is going to do.

_af_ supports _bash_'s tab-completion but the relevant file is not
copied by the above _make_ command.  You have to install it on your own
with `sudo cp bc.archive-files /etc/bash_completion.d`. 

For _moba_ the zip archive is extracted on the removable media.  The
_moba_ zip is included in the Debian package and located in
_/usr/lib/af_.

