

echo "Starting Scanator V2.0"

cat << "EOF"
======================================================================
  _________                            __
 /   _____/ ____ _____    ____ _____ _/  |_  ___________  
 \_____  \_/ ___\\__  \  /    \\__  \\   __\/  _ \_  __ \ 
 /        \  \___ / __ \|   |  \/ __ \|  | (  |_| )  | \/ 
/_______  /\___  >____  /___|  (____  /__|  \____/|__|    
        \/     \/     \/     \/     \/                    V 2.0 
                                                          By Tech.
=====================================================================
EOF


red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
#printf "I ${green}love${reset} shells\n"

DATE=$(date +%d-%m-%Y"-"%H:%M:%S);

echo $DATE



echo " Enter IP to scan "
echo ""
read ip

echo ""
echo " Scan UDP also ? "
echo " 1 = Yes "
echo " 2 = No "  
read udp


file=$PWD/ping

echo ""
echo "Testing if $ip is reachable"
echo ""



ping $ip -c2> $file


if cat $file |grep -q ttl  ; then
   echo " ${green}Host $ip is UP${reset} "
   echo ""
   cat ping |grep ttl
   echo ""
   #echo " ${green}Starting Masscan${reset}"
   rm $file
else
   echo " ${red}Host $ip is down${reset} "
   echo " Please check host $1"
   exit
fi




#gnome-terminal --geometry=20x20 -x sh -c "ping  10.10.10.59; bash"
#masscan -e tun0 -p0-65535 --max-rate 500 --wait 0 $ip > masscan.txt 


echo "${green}Stating initial scanning - Stage 1${reset}"
nmap -Pn -sS --stats-every 3m --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit -T4 -p1-65535 -oN nmap-initial-$ip.nmap $ip -vv


sleep 1
cat nmap-initial-$ip.nmap |grep open |cut -d" " -f1|cut -d"/" -f1|sort -n|paste -sd ","> initcp.$ip


echo "${green}Stating detail scanning - Stage 2${reset}"

nmap -p$(cat ./initcp.$ip) -sV -sC -oN Nmap-TCP-$ip-$DATE.nmap $ip -vv -Pn

echo "${green} TCP Scan Completed${reset}"
echo ""
echo ""



if [ "$udp" == "1" ]; then 
        echo " ${green}Starting UDP scanning${reset} "
        nmap -Pn --top-ports 1000 -sU --stats-every 3m --max-retries 1 -T3 -oN namp-UDP-$ip.nap $ip -vv
        echo " ${green}Starting UDP finish${reset} "

else
   exit
fi


