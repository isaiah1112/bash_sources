### Random Tools
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)

function myip() {
    echo "IPv6:"
    curl -s 'https://api6.ipify.org?format=json' | grep -o '"ip":"[^"]*' | cut -d'"' -f4 || echo "Unable to fetch IPv6"
    echo "IPv4:"
    curl -s 'https://api.ipify.org?format=json' | grep -o '"ip":"[^"]*' | cut -d'"' -f4 || echo "Unable to fetch IPv4"
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
    if [ -z "$1" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "Usage: mkramdisk <size in MB> [mount point]"
        return 1
    fi
    
    if [ "$(uname)" == "Darwin" ]; then  # Running macOS
        if ! command -v bc &>/dev/null; then
            echo "Error: bc is required for macOS"
            return 1
        fi
        size=$(bc <<< "$1 * 1024 * 1024 / 512")  # Size is in 512-byte blocks
        diskutil erasevolume HFS+ "RAMDisk" $(hdiutil attach -nomount ram://${size}) 2>/dev/null
    else  # Running Linux
        if [ -z "$2" ]; then
            echo "Usage: mkramdisk <size in MB> <mount point>"
            return 1
        fi
        size=$1
        mount_point=$2
        sudo mount -t tmpfs -o size="${size}m" tmpfs "${mount_point}"
    fi
}