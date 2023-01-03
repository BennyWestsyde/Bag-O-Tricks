shell=$(echo $0 | cut -c 2-)
shell_rc="${HOME}/.${shell}rc"

log_array () 
{
    new_log=$1
    logs[5]=${logs[4]}
    logs[4]=${logs[3]}
    logs[3]=${logs[2]}
    logs[2]=${logs[1]}
    logs[1]=${logs[0]}
    logs[0]=$new_log
}

prog ()
{
    clear
    index_array=(⠦ ⠋ ⠙ ⠴)
    pa=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
    comp=$1
    progress=$2
    i=1
    while [[ $i -lt 16 ]]
    do
        if [[ $i -lt $comp ]];
        then
            pa[$i]="✓"
        else
            pro_i=$(echo "$i + $progress" | bc)
            num=$(echo "($pro_i % 4)" | bc)
            pa[$i]=${index_array[$num]}
        fi
        i=`expr $i + 1`
    done
    echo " ___________________________   ___________________________"
    echo "|        DAILY TOOLS        | |      PENTESTING TOOLS     |"
    echo "|═══════════════════════════| |═══════════════════════════|"
    echo "| [${pa[1]}] | Package Manager     | | [${pa[4]}] | Nmap                |"
    echo "| [${pa[2]}] | Git                 | | [${pa[5]}] | Metasploit          |"
    echo "| [${pa[3]}] | Python              | | [${pa[6]}] | Gobuster            |"
    echo "|___________________________| | [${pa[7]}] | FFUF                |"
    echo "|       SYSTEM TOOLS        | | [${pa[8]}] | SQLMap              |"
    echo "|═══════════════════════════| | [${pa[9]}] | Searchsploit        |"
    echo "| [${pa[13]}] | Wordlists           | | [${pa[10]}] | Hydra               |"
    echo "| [${pa[14]}] | Payloads            | | [${pa[11]}] | John                |"
    echo "| [${pa[15]}] | Web Server          | | [${pa[12]}] | Crunch              |"
    echo " ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾   ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"
    echo "|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|"
    
    inf_len=${#logs[@]}
    inf_len2=$((inf_len - 1))

    for (( l=$inf_len2; l >= 0; l=l-1 ));
    do
        j=${logs[$l]}
        #sleep .25
        space_num=$((56 - ${#j}))
        for i in $(seq $space_num); do
            j+="\x20"
        done
        echo "| ${j}|"
        #sleep .25
    done
    echo "|═════════════════════════════════════════════════════════|"
    echo "|                                                         |"
    if [[ "${j}" =~ "[?]" ]];
    then
        echo " ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\033[A\033[A" && read -p "| [y/n] : " over
    fi
    echo " ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"
    sleep .2
    if [[ "$over" =~ "y" ]];
    then
        overwrite="REMOVE"
        
    fi
    if [[ "$over" =~ "n" ]]; 
    then
        overwrite="KEEP"
    fi

}
prog 5 23 "${logs[]}"
create_server ()
{
    mkdir ${install_dir}py_server
    mkdir ${install_dir}py_server/root
    start_server_command="""\n
if [[ \$1 == \"\" ]];
then
    serv_port=\"8888\"
else
    serv_port=\"\$1\"
fi
export local_ip=\"127.0.0.1\"
export priv_ip=\`ifconfig|egrep -x \"en0:.*\" -A 4|egrep -o \"inet (([0-9]+\.){3}[0-9]+)\"|egrep -o \"(([0-9]+\.){3}[0-9]+)\"\`
export vpn_ip=\`ifconfig|egrep -x \"utun3:.*\" -A 1|egrep -o \"inet (([0-9]+\.){3}[0-9]+)\"|egrep -o \"(([0-9]+\.){3}[0-9]+)\"\`
echo \"Starting server on:\"
echo \"\tLocalhost:\t\thttp://\$local_ip:\$serv_port/\"
echo \"\tPrivate IP:\t\thttp://\$priv_ip:\$serv_port/\"
echo \"\tVPN IP:\t\thttp://\$vpn_ip:\$serv_port/\"
python -m http.server \$serv_port --directory ${install_dir}py_server/root"""
    echo "[*] Creating Start Server Script"
    echo "${start_server_command}" > ${install_dir}py_server/start_server.sh
    chmod +x ${install_dir}py_server/start_server.sh
    stop_server_command="""
if [[ \$1 == \"\" ]];
then
    echo \"No Port Specified\"
    exit 1
fi
export serv_port=\"\$1\"
echo \"Looking for server at port \$serv_port\"
export pid_no=\`lsof -i :\$serv_port|egrep -o \" ([0-9]+) \"\`
export pid_no=\`echo $pid_no | egrep -o \"([0-9]+)\"\`
if [[ \$pid_no =~ \"([0-9]+)\" ]]; then
    echo \"Server Found...\"
    echo \"Killing PID \$pid_no\"
    kill \$pid_no
    echo \"Server Killed\"
else
    echo \"Server Not Found\"
fi

"""
    echo '[*] Creating Stop Server Script'
    echo "${stop_server_command}" > ${install_dir}py_server/stop_server.sh
    chmod +x ${install_dir}py_server/stop_server.sh
}

localize_wordlists ()
{
    mkdir ${install_dir}wordlists
    cd ${install_dir}wordlists
    git clone https://github.com/danielmiessler/SecLists.git
}

localize_payloads ()
{
    mkdir ${install_dir}payloads
    cd ${install_dir}payloads
    git clone https://github.com/DevanshRaghav75/PayloadsOfAllTheThings.git
}

print_banner ()
{
    echo " ____                         _____      __"  
    echo "/\\  _\`\\                      /\\  __\`\\   /\\ \\"
    echo "\\ \\ \\L\\ \\     __       __    \\ \\ \\/\\ \\  \\ \\/"  
    echo " \\ \\  _ <'  /'__\`\\   /'_ \`\\   \\ \\ \\ \\ \\  \\/"
    echo "  \\ \\ \\L\\ \\/\\ \\L\\.\\_/\\ \\L\\ \\   \\ \\ \\_\\ \\" 
    echo "   \\ \\____/\\ \\__/.\\_\\ \\____ \\   \\ \\_____\\"
    echo "    \\/___/  \\/__/\\/_/\\/___L\\ \\   \\/_____/"
    echo "                       /\\____/"
    echo "                       \\_/__/"
    echo " ______                   __"
    echo "/\\__  _\\       __        /\\ \\"
    echo "\\/_/\\ \\/ _ __ /\\_\\    ___\\ \\ \\/'\\     ____"
    echo "   \\ \\ \\/\\\`'__\\/\\ \\  /'___\\ \\ , <    /',__\\"
    echo "    \\ \\ \\ \\ \\/ \\ \\ \\/\\ \\__/\\ \\ \\\\\\\`\\ /\\__, \`\\"
    echo "     \\ \\_\\ \\_\\  \\ \\_\\ \\____ \\\\ \\_\\ \\_\\/\\____/"
    echo "      \\/_/\\/_/   \\/_/\\/____/ \\/_/\\/_/\\/___/"
}


if [ "$(whoami)" != "root" ]; then
    echo '[X] Please run again with sudo'
    exit 0
fi
logs=()
complete=0
progress=1
overwrite="KEEP"
echo '[*] Root User Verified...'
print_banner
echo '[*] Would you like to build the suite across the system or in one location?'
echo '[*] 1. System Wide'
echo '[*] 2. One Location'
read -p '[?] Enter your choice (1/2): ' choice
if [ "${choice}" == "1" ]; 
then
    if [ $(uname -s) == Darwin ]; then

        log_array "[*] Mac Detected... Switching to Normal User"
        progress=$(($progress+1))
        prog $complete $progress
        def_user=$(dscl . list /Users | grep -v '_' -m 1)
        install_dir="/Users/Shared/"
        log_array "[*] Checking for required packages..."
        progress=$(($progress+1))
        prog $complete $progress
        if [[ "$(which brew)" =~ 'not found' ]]; then
            log_array "[*] Installing Homebrew"
            progress=$(($progress+1))
            prog $complete $progress
            sudo -u $def_user /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            log_array "[✓] Homebrew Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Homebrew already installed"
            progress=$(($progress+1))
		    prog $complete $progress
        fi
        complete=$(($complete+1))
        progress=$(($progress+1))
		prog $complete $progress
        if [[ "$(which git)" =~ 'not found' ]]; then
            log_array "[*] Installing Git"
            progress=$(($progress+1))
			prog $complete $progress
            sudo -u $def_user brew install git
            log_array "[✓] Git Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Git already installed"
            progress=$(($progress+1))
			prog $complete $progress
        fi
        complete=$(($complete+1))
        progress=$(($progress+1))
		prog $complete $progress

        if [[ "$(which pyenv)" =~ 'not found' ]]; then
            log_array "[*] Installing Pyenv"
            progress=$(($progress+1))
			prog $complete $progress
            sudo -u $def_user brew install pyenv
            log_array "[✓] Pyenv Installed"
            progress=$(($progress+1))
            prog $complete $progress
            log_array "[*] Installing Python"
            pyenv install 3.11.0
            pyenv global 3.11.0
            log_array "[✓] Python Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Pyenv already installed"
            progress=$(($progress+1))
			prog $complete $progress
        fi
        complete=$(($complete+1))
        progress=$(($progress+1))
		prog $complete $progress

        log_array "[*] Installing Pentesting Tools"
        progress=$(($progress+1))
		prog $complete $progress
        if [[ "$(which msfconsole)" =~ 'not found' ]]; then
            log_array "[*] Installing Metasploit"
            progress=$(($progress+1))
			prog $complete $progress
            curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
            chmod 755 msfinstall && ./msfinstall
            log_array "[✓] Metasploit Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Metasploit Already Installed"
            progress=$(($progress+1))
			prog $complete $progress
        fi
        complete=$(($complete+1))
        progress=$(($progress+1))
		prog $complete $progress

        if [[ "$(which nmap)" =~ 'not found' ]]; then
            log_array "[*] Installing Nmap"
            progress=$(($progress+1))
			prog $complete $progress
            sudo -u $def_user brew install nmap
            log_array "[✓] Nmap Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Nmap Already Installed"
            progress=$(($progress+1))
			prog $complete $progress
        fi
        complete=$(($complete+1))
		prog $complete $progress


        

        if [[ "$(which gobuster)" =~ 'not found' ]]; then
            log_array "[*] Installing Gobuster"
            progress=$(($progress+1))
			prog $complete $progress           
            sudo -u $def_user brew install gobuster
            log_array "[✓] GoBuster Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Gobuster Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which ffuf)" =~ 'not found' ]]; then
            log_array "[*] Installing FFUF"
            progress=$(($progress+1))
            prog $complete $progress
            sudo -u $def_user brew install ffuf
            log_array "[✓] FFUF Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] FFUF Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which sqlmap)" =~ 'not found' ]]; then
            log_array "[*] Installing SQLMap"
            progress=$(($progress+1))
            prog $complete $progress
            sudo -u $def_user brew install sqlmap
            log_array "[✓] SQLMap Installed"

        else
            log_array "[✓] SQLMap Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress
        

        if [[ "$(which searchsploit)" =~ 'not found' ]]; then
            log_array "[*] Installing Searchsploit"
            progress=$(($progress+1))
            prog $complete $progress
            sudo -u $def_user brew install exploitdb
            log_array "[✓] Searchsploit Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Searchsploit Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress

        if [[ "$(which hydra)" =~ 'not found' ]]; then
            log_array "[*] Installing Hydra"
            progress=$(($progress+1))
            prog $complete $progress
            sudo -u $def_user brew install hydra
            log_array "[✓] Hydra Installed"
            progress=$(($progress+1))
            prog $complete $progress

        else
            log_array "[✓] Hydra Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which john)" =~ 'not found' ]]; then
            log_array "[*] Installing John"
            progress=$(($progress+1))
            prog $complete $progress
            sudo -u $def_user brew install john-jumbo
            log_array "[✓] John Installed"
            progress=$(($progress+1))
            prog $complete $progress

        else
            log_array "[✓] John Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which hashcat)" =~ 'not found' ]]; then
            log_array "[*] Installing Hashcat"
            progress=$(($progress+1))
            prog $complete $progress
            sudo -u $def_user brew install hashcat
            log_array "[✓] Hashcat Installed"
            progress=$(($progress+1))

        else
            log_array "[✓] Hashcat Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which crunch)" =~ 'not found' ]]; then
            log_array "[*] Installing Crunch"
            progress=$(($progress+1))
            prog $complete $progress
            sudo -u $def_user brew install crunch
            log_array "[✓] Crunch Installed"
            progress=$(($progress+1))       

        else
            log_array "[✓] Crunch Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


    else
        install_dir="/usr/share/"
        log_array "[*] Checking for required packages..."
        progress=$(($progress+1))
        prog $complete $progress
        if [[ "$(which git)" =~ 'not found' ]]; then
            echo '[*] Installing Git'
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install git -y
            echo '[✓] Git Installed'
            progress=$(($progress+1))
            prog $complete $progress
        else
            echo '[✓] Git already installed'
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress
        
        if [[ "$(which python3)" =~ 'not found' ]]; then
            log_array "[*] Installing Python"
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install python3 -y
            log_array "[✓] Python Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Python Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which msfconsole)" =~ 'not found' ]]; then
            log_array "[*] Installing Metasploit"
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install metasploit-framework -y
            log_array "[✓] Metasploit Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Metasploit Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress

        if [[ "$(which nmap)" =~ 'not found' ]]; then
            log_array "[*] Installing Nmap"
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install gcc make libpcap-dev g++ -y
            mkdir /tmp/nmap
            cd /tmp/nmap
            git clone https://github.com/nmap/nmap.git
            cd nmap
            ./configure
            make
            make install
            cd ~
            rm -rf /tmp/nmap
            log_array "[✓] Nmap Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Nmap Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which gobuster)" =~ 'not found' ]]; then
            log_array "[*] Installing Gobuster"
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install gobuster -y
            log_array "[✓] Gobuster Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Gobuster Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress

        if [[ "$(which ffuf)" =~ 'not found' ]]; then
            log_array "[*] Installing FFUF"
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install ffuf -y
            log_array "[✓] FFUF Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] FFUF Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which sqlmap)" =~ 'not found' ]]; then
            log_array "[*] Installing SQLMap"
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install sqlmap -y
            log_array "[✓] SQLMap Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] SQLMap Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which searchsploit)" =~ 'not found' ]]; then
            log_array "[*] Installing Searchsploit"
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install exploitdb -y
            log_array "[✓] Searchsploit Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Searchsploit Already Installed"
            progress=$(($progress+1))
            prog $complete $progress

        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which hydra)" =~ 'not found' ]]; then
            log_array "[*] Installing Hydra"
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install hydra -y
            log_array "[✓] Hydra Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Hydra Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which john)" =~ 'not found' ]]; then
            log_array "[*] Installing John"
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install john -y
            log_array "[✓] John Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] John Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress

        if [[ "$(which hashcat)" =~ 'not found' ]]; then
            log_array "[*] Installing Hashcat"
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install hashcat -y
            log_array "[✓] Hashcat Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Hashcat Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress


        if [[ "$(which crunch)" =~ 'not found' ]]; then
            log_array "[*] Installing Crunch"
            progress=$(($progress+1))
            prog $complete $progress
            apt-get install crunch -y
            log_array "[✓] Crunch Installed"
            progress=$(($progress+1))
            prog $complete $progress
        else
            log_array "[✓] Crunch Already Installed"
            progress=$(($progress+1))
            prog $complete $progress
        fi
        complete=$(($complete+1))
        prog $complete $progress

        
    fi
else
    log_array "[?] Where would you like to install the tools?"
    read 'install_dir?[*] Enter the location: '
fi

log_array "[*] Installing to system wide"
progress=$(($progress+1))
prog $complete $progress
log_array "[*] Installing Wordlists"
progress=$(($progress+1))
prog $complete $progress
if [[ -e ${install_dir}wordlists ]]; 
then
    log_array "[*] Wordlists already installed"
    progress=$(($progress+1))
    prog $complete $progress
    log_array "[?] Would you like to overwrite the current wordlists?"
    progress=$(($progress+1))
    prog $complete $progress
    #overwrite=$(prog $complete $progress)
    echo ""
    echo $overwrite
    if [[ "$overwrite" =~ "R" ]]; 
    then
        log_array "[*] Overwriting Wordlists"
        progress=$(($progress+1))
        prog $complete $progress
        echo $overwrite
        sudo rm -r ${install_dir}wordlists
        localize_wordlists
        log_array "[✓] Wordlists Overwritten"
        progress=$(($progress+1))
        prog $complete $progress
    elif [[ "$overwrite" =~ "K" ]];
    then
        log_array "[*] Skipping Wordlists"
        progress=$(($progress+1))
        prog $complete $progress
    fi
else
    localize_wordlists
    log_array "[✓] Wordlists Installed"
    progress=$(($progress+1))
    prog $complete $progress
fi
complete=$(($complete+1))


log_array "[*] Installing Payloads"
progress=$(($progress+1))
prog $complete $progress
if [[ -e ${install_dir}payloads ]]; then
    log_array "[*] Payloads already installed"
    progress=$(($progress+1))
    prog $complete $progress
    log_array "[?] Would you like to overwrite the current payloads?"
    progress=$(($progress+1))
    prog $complete $progress
    #overwrite=$(prog $complete $progress)

    echo ""
    echo $overwrite
    if [[ "$overwrite" =~ "R" ]]; 
    then
        log_array "[✓] Overwriting Payloads"
        progress=$(($progress+1))
        prog $complete $progress
        sudo rm -r ${install_dir}payloads
        localize_payloads
        log_array "[*] Payloads Overwritten"
        progress=$(($progress+1))
        prog $complete $progress
    elif [[ "$overwrite" =~ "K" ]];
    then
        log_array "[✓] Skipping Payloads"
        progress=$(($progress+1))
        prog $complete $progress
    fi
else
    localize_payloads
    log_array "[✓] Payloads Installed"
    progress=$(($progress+1))
    prog $complete $progress
fi
complete=$(($complete+1))


log_array "[*] Creating Python Server "
progress=$(($progress+1))
prog $complete $progress
if [[ -e ${install_dir}py_server ]]; then
    log_array "[*] Python Server already installed"
    progress=$(($progress+1))
    prog $complete $progress
    log_array "[?] Would you like to overwrite the current server?"
    progress=$(($progress+1))
    prog $complete $progress
    #overwrite=$(prog $complete $progress)
    echo ""
    echo $overwrite
    if [[ "$overwrite" =~ "R" ]]; then
        log_array "[✓] Overwriting Python Server"
        progress=$(($progress+1))
        prog $complete $progress
        sudo rm -r ${install_dir}py_server
        create_server
        log_array "[*] Python Server Overwritten"
        progress=$(($progress+1))
        prog $complete $progress
    elif [[ "$overwrite" =~ "K" ]];
    then
        log_array "[✓] Skipping Python Server"
        progress=$(($progress+1))
        prog $complete $progress
    fi
else
    create_server
    log_array "[✓] Python Server Installed"
    progress=$(($progress+1))
    prog $complete $progress
fi
complete=$(($complete+1))
log_array "[✓] Installation Finished. Happy Hacking!"
progress=$(($progress+1))
prog $complete $progress

