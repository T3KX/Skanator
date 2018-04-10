echo "Starting Scanator V1.0"

cat << "EOF"
======================================================================
  _________                            __
 /   _____/ ____ _____    ____ _____ _/  |_  ___________  
 \_____  \_/ ___\\__  \  /    \\__  \\   __\/  _ \_  __ \ 
 /        \  \___ / __ \|   |  \/ __ \|  | (  |_| )  | \/ 
/_______  /\___  >____  /___|  (____  /__|  \____/|__|    
        \/     \/     \/     \/     \/                    V 1.0 
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
read ip



file=$PWD/ping


echo "Testing if $ip is reachable"
echo ""



ping $ip -c2> $file


if cat $file |grep -q ttl  ; then
   echo " ${green}Host $ip is UP${reset} "
   echo ""
   cat ping |grep ttl
   echo ""
   echo " ${green}Starting Masscan${reset}"
   rm $file
else
   echo " ${red}Host $ip is down${reset} "
   echo " Please check host $1"
   exit
fi




#gnome-terminal --geometry=20x20 -x sh -c "ping  10.10.10.59; bash"
masscan -e tun0 -p0-65535 --max-rate 500 --wait 0 $ip > masscan.txt 

# apparently  --wait 0  fix the bug of masscan freezing after scanning 
#masscan -e tap0 -p0-65535 --max-rate 500 $ip > masscan.txt


sleep 1
echo ""
echo ""

cat masscan.txt | sort -V
echo ""
echo ""
echo ""



cat masscan.txt |cut -d" " -f4|cut -d"/" -f1 |sort -n|paste -sd "," >masscan.final
sleep 1
nmap -p$(cat ./masscan.final) -sV -sC -oA Nmap-scan-$ip-$DATE $ip -vv -Pn

echo "Scan Completed"

rm $PWD/mass*

echo $DATE

echo ""
echo "Scan results are in $PWD/Nmap-scan-$ip-$DATE.nmap "

