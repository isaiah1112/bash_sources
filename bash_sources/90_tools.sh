### Random Tools
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)

function myip() {
    ipv6=$(curl -s 'http://ip6.me/' | grep -A 1 'Address of' | cut -d '>' -f4 | cut -d '<' -f1);
    echo ${ipv6} | sed 's/ /: /'; 
    if [ -n "$(echo ${ipv6} | grep 'IPv6')" ]; then
      ipv4=$(curl -s 'http://ip4.me/' | grep -A 1 'Address of' | cut -d '>' -f4 | cut -d '<' -f1);
      echo ${ipv4} | sed 's/ /: /';
    fi
}

# Reverse SSH Tunnel for SOCKS proxy on port 8080
function ktunnel() {
pids=$(ps aux | grep '[s]sh' | grep '\-D 8080' | awk '{print $2}');
if [ -n ${pids} ]; then
    kill ${pids};
fi
}
alias lstunnel="ps aux | grep '[s]sh' | grep '\-D 8080'";
alias tunnel='ssh -D 8080 -f -C -q -N';