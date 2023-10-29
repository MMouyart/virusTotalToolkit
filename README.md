# virusTotalToolkit
Bash functions using virustotal scanning api for file, url and ip address.
This simple repository contains a bash file which contains functions that use virustotal apis to scan file, url and ip address.

Only suitable for linux based OS (not tested on MacOS).

Make sure the following commands are installed on the system : 
- ls
- grep
- curl
- jq

Create a virustotal account, and get your api key.
In func.sh replace the fields <your api key> with you api key.

Copy the func.sh file anywhere on the system (preferably somewhere that belongs to you, not in the / or the /root directories for instance).
Simply add the following line in your shell interpretor config file (.bashrc, .zshrc, ...) : 
./home/<user name>/<path to func.sh>

Reload your shell interpretor (source .bashrc, source .zshrc, ...).

You can now use the 3 functions like this : 
- vurl <url to scan>
- vfile <file to scan>
- vip <ip address to scan>

N.B. The virus total API only allows scan for files smaller than 200MB, hence for files that are bigger than that the vfile function will abort the process.
