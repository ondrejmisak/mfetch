#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
DEFAULT='\033[0m'

colors=(196 46 21 39 124 15)

display_ascii_art() {
    cat << "EOF"
                    _____       __         .__ 
  _____           _/ ____\_____/  |_  ____ |  |__
 /     \   ______ \   __\/ __ \   __\/ ___\|  |  \
|  Y Y  \ /_____/  |  | \  ___/|  | \  \___|   Y  \
|__|_|  /          |__|  \___  >__|  \___  >___|  /
      \/                     \/          \/     \/ 
EOF
}

print_square() {
    printf "\e[48;5;${1}m   "
}

get_system_info() {
    HOSTNAME=$(hostname)
    USER=$(whoami)
    OS=$(uname -s)
    KERNEL=$(uname -r)
    ARCH=$(uname -m)
    UPTIME=$(uptime | awk '{print $3}' | sed 's/,//')
    CPU=$(sysctl -n machdep.cpu.brand_string)
    MEMVAIL=$(vm_stat | grep "Pages free" | awk '{print $3 * 4096 / 1024 / 1024}') 
    STORAGE=$(df -h / | tail -1 | awk '{print "Used: " $3 ", Available: " $4 ", Total: " $2}')

    RAM=$(( ($(sysctl -n hw.memsize) / 1048576 / 1024)))
    RAM_USAGE=$(top -l 1 | grep 'PhysMem' | awk '{print $2, $6}')

    SYSTEM_INFO=$(printf ".")
    SYSTEM_INFO+=$(printf "\n%s")
    SYSTEM_INFO+=$(printf "\n└── ${CYAN}${DEFAULT}%s$HOSTNAME${DEFAULT}" )
    SYSTEM_INFO+=$(printf "\n%s    ├─ ")
    SYSTEM_INFO+=$(printf "${CYAN}User: ${DEFAULT}%s\n" "$USER")
    SYSTEM_INFO+=$(printf "\n%s    ├─ ")
    SYSTEM_INFO+=$(printf "${CYAN}OS: ${DEFAULT}%s$OS${DEFAULT}" )
    SYSTEM_INFO+=$(printf "\n%s    ├─ ")
    SYSTEM_INFO+=$(printf "${CYAN}Kernel: ${DEFAULT}%s\n" "$KERNEL")
    SYSTEM_INFO+=$(printf "\n%s    ├─ ")
    SYSTEM_INFO+=$(printf "${CYAN}Architecture: ${DEFAULT}%s\n" "$ARCH")
    SYSTEM_INFO+=$(printf "\n%s    ├─ ")
    SYSTEM_INFO+=$(printf "${CYAN}CPU: ${DEFAULT}%s\n" "$CPU")
    SYSTEM_INFO+=$(printf "\n%s    ├─ ")
    SYSTEM_INFO+=$(printf "${CYAN}STORAGE: ${DEFAULT}%s\n" "$STORAGE")
    SYSTEM_INFO+=$(printf "\n%s    ├─ ")
    SYSTEM_INFO+=$(printf "${CYAN}RAM: ${DEFAULT}%s\n" "$RAM"G)
    # SYSTEM_INFO+=$(printf "\n%s    ├─ ")
    # SYSTEM_INFO+=$(printf "${CYAN}RAM: ${DEFAULT}%s\n" "$RAM_USAGE")
    
    SYSTEM_INFO+=$(printf "\n%s    └─ ")
    SYSTEM_INFO+=$(printf "${CYAN}Uptime: ${DEFAULT}%s\n" "$UPTIME")
    printf "%s\n"
    
    printf "%s\n" "${SYSTEM_INFO[@]}"
    for color in "${colors[@]}"; do
        print_square $color
    done
    SYSTEM_INFO+=$(printf "${DEFAULT}%s\n")

}

main() {
    clear
    ASCII_ART=$(display_ascii_art)
    
    SYSTEM_INFO=$(get_system_info)

    IFS=$'\n' read -r -d '' -a ASCII_ART_LINES <<< "$ASCII_ART"

    IFS=$'\n' read -r -d '' -a SYSTEM_INFO_LINES <<< "$SYSTEM_INFO"

    ART_LINE_COUNT=${#ASCII_ART_LINES[@]}
    INFO_LINE_COUNT=${#SYSTEM_INFO_LINES[@]}
    
    MAX_LINES=$(( ART_LINE_COUNT > INFO_LINE_COUNT ? ART_LINE_COUNT : INFO_LINE_COUNT ))

    for ((i=0; i<MAX_LINES; i++)); do
        ART_LINE="${ASCII_ART_LINES[i]:-}"
        printf "%-53s  " "$ART_LINE"

        printf "%s" "${SYSTEM_INFO_LINES[i]:-}"

        echo ""
    done
    printf ""

}

main
