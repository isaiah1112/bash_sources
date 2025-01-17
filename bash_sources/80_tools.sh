### Random Tools
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)

function myip() {
    curl -s 'http://ip6only.me/api/' | cut -d ',' -f1,2 | sed 's/,/: /';
    curl -s 'http://ip4.me/api/' | cut -d ',' -f1,2 | sed 's/,/: /';
}

# Reverse SSH Tunnel for SOCKS proxy on port 8080
alias tunnel="ssh -D 8080 -f -C -q -N";
alias lstunnel="ps aux | grep '[s]sh' | grep '\-D 8080'";
function ktunnel() {
pids=$(ps aux | grep '[s]sh' | grep '\-D 8080' | awk '{print $2}');
if [ -n ${pids} ]; then
    kill ${pids};
fi
}

# Create and mount a RAM disk
function mkramdisk() {
    if [ -z "$1" -o "$1" == "--help" -o "$1" == "-h" ]; then
          echo "Usage: mkramdisk <size in MB>";
          return 1;
      fi
    if [ "$(uname)" != "Darwin" ]; then  # Running OS X
      size=$(bc <<< "$1 * 1024 * 1024 / 512");  # Size is in 512-byte blocks
      diskutil erasevolume HFS+ "RAMDisk" $(hdiutil attach -nomount ram://${size});
    else  # Running Linux
      if [ -z "$2" ]; then
          echo "Usage: mkramdisk <size in MB> <mount point>";
          return 1;
      fi
      size=$1;
      mount_point=$2;
      sudo mount -t tmpfs -o size=${size}m tmpfs ${mount_point};
    fi
}