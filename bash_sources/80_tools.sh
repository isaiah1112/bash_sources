### Random Tools
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)

function myip() {
    local timeout=5
    
    echo "IPv6:"
    local ipv6=$(curl -s --max-time "$timeout" 'https://api6.ipify.org?format=json' 2>/dev/null | grep -o '"ip":"[^"]*' | cut -d'"' -f4)
    if [ -n "$ipv6" ]; then
        echo "$ipv6"
    else
        echo "Unable to fetch IPv6"
    fi
    
    echo "IPv4:"
    local ipv4=$(curl -s --max-time "$timeout" 'https://api.ipify.org?format=json' 2>/dev/null | grep -o '"ip":"[^"]*' | cut -d'"' -f4)
    if [ -n "$ipv4" ]; then
        echo "$ipv4"
    else
        echo "Unable to fetch IPv4"
    fi
}

# Reverse SSH Tunnel for SOCKS proxy on port 8080
alias tunnel="ssh -D 8080 -f -C -q -N";
alias lstunnel="ps aux | grep '[s]sh' | grep '\-D 8080'";
function ktunnel() {
    local pids=$(ps aux | grep '[s]sh' | grep '\-D 8080' | awk '{print $2}');
    if [ -n ${pids} ]; then
        kill ${pids};
    fi
}

# Create and mount a RAM disk
function mkramdisk() {
    if [ -z "$1" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "Usage: mkramdisk <size in MB> [mount point]"
        echo "Examples:"
        echo "  mkramdisk 512           # macOS: create 512MB RAM disk"
        echo "  mkramdisk 1024 /mnt    # Linux: create 1GB tmpfs at /mnt"
        return 1
    fi
    
    # Validate size is a positive number
    if ! [[ "$1" =~ ^[0-9]+$ ]] || [ "$1" -le 0 ]; then
        echo "Error: size must be a positive integer"
        return 1
    fi
    
    if [ "$(uname)" == "Darwin" ]; then  # Running macOS
        if ! command -v bc &>/dev/null; then
            echo "Error: bc is required for macOS"
            return 1
        fi
        local size=$(bc <<< "$1 * 1024 * 1024 / 512")  # Size is in 512-byte blocks
        local dev=$(hdiutil attach -nomount ram://${size} 2>&1) || {
            echo "Error: failed to create RAM disk: $dev"
            return 1
        }
        diskutil erasevolume HFS+ "RAMDisk" "$dev" || {
            echo "Error: failed to format RAM disk"
            hdiutil detach "$dev" 2>/dev/null
            return 1
        }
        echo "Created RAM disk (${1}MB) at $dev"
    else  # Running Linux
        if [ -z "$2" ]; then
            echo "Usage: mkramdisk <size in MB> <mount point>"
            return 1
        fi
        local mount_point=$2
        if [ -e "$mount_point" ]; then
            echo "Error: mount point already exists"
            return 1
        fi
        sudo mkdir -p "$mount_point" || {
            echo "Error: failed to create mount point"
            return 1
        }
        sudo mount -t tmpfs -o size="${1}m" tmpfs "$mount_point" || {
            echo "Error: failed to mount tmpfs"
            sudo rmdir "$mount_point" 2>/dev/null
            return 1
        }
        echo "Created tmpfs (${1}MB) at $mount_point"
    fi
}

# List RAM disks
function lsramdisk() {
    if [ "$(uname)" == "Darwin" ]; then
        diskutil list | grep -i "ramdisk" || echo "No RAM disks found"
    else
        mount | grep tmpfs || echo "No tmpfs mounts found"
    fi
}

# Unmount RAM disk (macOS)
function rmramdisk() {
    if [ "$(uname)" != "Darwin" ]; then
        echo "Error: rmramdisk only works on macOS"
        return 1
    fi
    if [ -z "$1" ]; then
        echo "Usage: rmramdisk <device>"
        echo "Use 'lsramdisk' to see available devices"
        return 1
    fi
    hdiutil detach "$1" || {
        echo "Error: failed to detach $1"
        return 1
    }
    echo "Detached $1"
}