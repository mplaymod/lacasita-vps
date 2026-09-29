clear
CTRL_C(){
rm -rf LACASITA.sh
  exit
}

if [ `whoami` != 'root' ]
	then 
     echo -e "\e[1;31mPARA PODER USAR EL INSTALADOR ES NECESARIO SER ROOT\nAUN NO SABES COMO INICAR COMO ROOT?\nDIJITA ESTE COMANDO EN TU TERMINAL ( sudo -i )\e[0m" 
     rm *
     exit 
fi
trap "CTRL_C" INT TERM EXIT
time_reboot(){

REBOOT_TIMEOUT="$1"
  echo -e "	\e[1;97m\e[1;100mREINICIANDO VPS EN$1 SEGUNDOS\e[0m"
while [ $REBOOT_TIMEOUT -gt 0 ]; do
msg -ne "	-$REBOOT_TIMEOUT-\r"
     sleep 2
     : $((REBOOT_TIMEOUT--))
  done
  sudo reboot
}
v1=$(curl -fsSL "${GITHUB_RAW_BASE}/version/vercion" 2>/dev/null || echo "2026")
  echo "$v1" > /etc/versin_script
msg () {

  v22=$(cat /etc/versin_script)
vesaoSCT="\033[1;37mVersion \033[1;32m$v22\033[1;31m]" 
BRAN='\033[1;37m' && ROJO='\e[91m' && VERMELHO='\e[91m' && VERDE='\e[92m' && AMARELO='\e[93m'
AZUL='\e[94m' && MAGENTA='\e[95m' && MAG='\033[1;96m' &&NEGRITO='\e[1m' && SEMCOR='\e[0m'
 case $1 in
  -ne)cor="${VERMELHO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nazu) cor="${ROJO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nverd)cor="${VERDE}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nama) cor="${AMARELO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
  -ama)cor="${AMARELO}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verm)cor="${AMARELO}${NEGRITO}${VERMELHO}" && echo -e "${cor}${2}${SEMCOR}";;
  -azu)cor="${MAG}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verd)cor="${VERDE}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -bra)cor="${BRAN}" && echo -ne "${cor}${2}${SEMCOR}";;
  -tit)echo -e "\e[91m≪━━─━━─━─━─━─━─━━─━━─━─━─◈─━━─━─━─━─━━─━─━━─━─━━─━≫ \e[0m\n  \e[2;97m\e[3;93m❯❯❯❯❯❯ ꜱᴄʀɪᴩᴛ ᴍᴏᴅ ʟᴀᴄᴀꜱɪᴛᴀᴍx ❮❮❮❮❮❮\033[0m \033[1;31m[\033[1;32m$vesaoSCT\n\e[91m≪━━─━─━━━─━─━─━─━─━━─━─━─◈─━─━─━─━─━━━─━─━─━━━─━─━≫   \e[0m" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
  "-bar2"|"-bar")cor="${VERMELHO}————————————————————————————————————————————————————" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
 esac
}

fun_ip () {
  MIP2=$(wget -qO- ipv4.icanhazip.com)
MIP=$(wget -qO- whatismyip.akamai.com)
if [ $? -eq 0 ]; then
   IP="$MIP"
else
   IP="$MIP2"
fi
echo "$IP" >/bin/IPca
}  

os_system(){
v3=$(curl -fsSL "${GITHUB_RAW_BASE}/version/anio" 2>/dev/null || date +%Y)
  echo "$v3" > /etc/anio
#code by rufu99
  system=$(cat -n /etc/issue |grep 1 |cut -d ' ' -f6,7,8 |sed 's/1//' |sed 's/      //')
  distro=$(echo "$system"|awk '{print $1}')

  case $distro in
    Debian)vercion=$(echo $system|awk '{print $3}'|cut -d '.' -f1);;
    Ubuntu)vercion=$(echo $system|awk '{print $2}'|cut -d '.' -f1,2);;
  esac

  link="https://raw.githubusercontent.com/rudi9999/ADMRufu/main/Repositorios/${vercion}.list"

  case $vercion in
    8|9|10|11|16.04|18.04|20.04|20.10|21.04|21.10|22.04);; #wget -O /etc/apt/sources.list ${link} &>/dev/null;;
	12*|24.04*);; #fixDeb12Ubu24;;
  esac
}
repo_install(){
  link="https://raw.githubusercontent.com/rudi9999/ADMRufu/main/Repositorios/$VERSION_ID.list"
  case $VERSION_ID in
    8*|9*|10*|11*|16.04*|18.04*|20.04*|20.10*|21.04*|21.10*|22.04*);; #[[ ! -e /etc/apt/sources.list.back ]] && cp /etc/apt/sources.list /etc/apt/sources.list.back
                                                                #    wget -O /etc/apt/sources.list ${link} &>/dev/null;;
	12*|24.04*);; # fixDeb12Ubu24;;
  esac
}
stop_install(){
 	msg -verm "	INSTALACION CANCELADA"
 	exit
 }

function printTitle
{
    echo ""
    echo -e "\033[1;92m$1\033[1;91m"
    printf '%0.s-' $(seq 1 ${#1})
    echo ""
}
del(){
  for (( i = 0; i < $1; i++ )); do
    tput cuu1 && tput dl1
  done
}

rootvps(){
msg -tit
echo -e "\033[31m     OPTENIENDO ACCESO ROOT    "
repo_get "files/root.sh" "/usr/bin/rootlx" 1 || return
chmod 775 /usr/bin/rootlx &>/dev/null
rootlx
clear
echo -e "\033[31m     ACCESO ROOT CON ÉXITO    "
sleep 1
rm -rf /usr/bin/rootlx
}
	msg -bar
	echo -e "\033[1;93m  YA TIENES ACCESO ROOT A TU VPS?\n  ESTO SOLO FUNCIONA PARA (AWS,GOOGLECLOUD,AZURE,ETC)\n  SI YA TIENES ACCESO A ROOT SOLO IGNORA ESTE MENSAJE\n  Y SIGUE CON LA INSTALACION NORMAL..."
   msg -bar
   read -p "Responde [ s | n ]: " -e -i n rootvps
   [[ "$rootvps" = "s" || "$rootvps" = "S" ]] && rootvps
   
	msg -bar
	echo "\e[1;92m╭╮\e[93m╱╱╱\e[93m╭━━━╮\e[94m╭━━━╮\e[95m╭━━━╮\e[96m╭━━━╮\e[97m╭━━╮\e[93m╭━━━━╮\e[92m╭━━━╮\e[91m╭━╮╭━╮\e[93m╭━╮╭━╮\e[0m
\e[92m┃┃\e[93m╱╱╱\e[93m┃╭━╮┃\e[94m┃╭━╮┃\e[95m┃╭━╮┃\e[96m┃╭━╮┃\e[97m╰┫┣╯\e[93m┃╭╮╭╮┃\e[92m┃╭━╮┃\e[91m┃┃╰╯┃┃\e[93m╰╮╰╯╭╯\e[95m
┃┃\e[93m╱╱╱\e[94m┃┃\e[91m╱\e[96m┃┃┃┃\e[91m╱\e[97m╰╯┃┃\e[91m╱\e[93m┃┃┃╰━━╮\e[91m╱\e[94m┃┃\e[91m╱\e[93m╰╯┃\e[94 ┃╰╯┃┃\e[91m╱\e[97m┃┃\e[93m┃╭╮╭╮┃\e[91m╱\e[94m╰╮╭╯\e[91m╱\e[0m
\e[92m┃\e[93m┃\e[91m╱\e[93m╭╮┃\e[94m╰━╯┃\e[95m┃┃\e[91m╱\e[97m╭╮┃╰━╯┃\e[93m╰━━╮┃\e[91m╱\e[93m┃\e[91m┃\e[93m╱╱╱\e[96m┃┃\e[93m╱╱\e[913m┃╰━╯┃┃┃┃┃┃┃\e[91m╱\e[93m╭╯╰╮\e[91m╱\e[0m
\e[93m┃╰━╯┃\e[94m┃╭━╮┃\e[91m┃╰━╯┃\e[97m┃╭━╮┃\e[95m┃╰━╯┃\e[97m╭┫┣╮\e[93m╱╱\e[94m┃┃\e[93m╱╱\e[94m┃╭━╮┃\e[97m┃┃\e[94m┃┃\e[93m┃┃\e[97m╭╯╭╮╰╮\e[0m
\e[94m╰━━━╯\e[93m╰╯\e[91m╱╰╯\e[93m╰━━━╯\e[97m╰╯\e[91m╱\e[95m╰╯╰━━━╯\e[94m╰━━╯\e[93m╱╱\e[94m╰╯\e[93m╱╱\e[94m╰╯\e[91m╱\e[91m╰╯\e[93m╰╯\e[94m╰╯\e[95m╰╯\e[97m╰━╯\e[93m╰━╯\e[0m
\e[1;93m╱╱╱╱╱╱╱╱╱╱╱╱╱\e[91m╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱\e[94m╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱\e[95m╱╱╱╱\e[0m
\e[1;93m╱╱╱╱╱╱╱╱╱╱╱╱╱\e[91m╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱\e[94m╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱\e[95m╱╱╱╱\e[0m" >/bin/last12
	clear
	
dependencias(){
msg -tit
msg -ama "               PREPARANDO INSTALACION"
msg -bar2

clear

printTitle "Limpieza de caché local"
apt-get clean
clear
printTitle "Actualizando paquetes"
dpkg --configure -a &>/dev/null
#apt -f install -y >/dev/null 2>&1
apt install sudo -y &>/dev/null
clear
os_system

msg -tit
echo "$distro $vercion" >/tmp/distro
echo -e "\e[1;31m	🖥SISTEMA: \e[33m$distro $vercion   " 
echo -e "\e[1;31m	🖥IP: \e[33m$IP   "
#clear; clear

echo -e "  \033[41m   -- INSTALACION DE PAQUETES |$(cat /etc/anio) --    \e[49m"

msg -bar
	soft="sudo bsdmainutils zip unzip ufw curl python python3 python3-pip openssl screen cron iptables lsof nano at mlocate gawk figlet grep bc jq curl socat netcat net-tools cowsay lolcat figlet toilet pv perl apache2"

	for install in $soft; do
		leng="${#install}"
		puntos=$(( 21 - $leng))
		pts="."
		for (( a = 0; a < $puntos; a++ )); do
			pts+="."
		done
		msg -nazu "   INSTALANDO $install $(msg -ama "$pts")"
		if [[ $(dpkg --get-selections|grep -w "${install}"|head -1) ]] || sudo apt-get install ${install} -y &>/dev/null; then
			msg -verd " INSTALADO"
		else
			msg -verm2 " FALLA"
			sleep 2
			del 1
			if [[ $install = "python" ]]; then
				pts=$(echo ${pts:1})
				msg -nazu "   INSTALANDO python2 $(msg -ama "$pts")"
				if apt-get install python2 -y &>/dev/null ; then
			# INSTALA PYTHON AO PYTHON2
    apt-get install python -y >/dev/null 2>&1
    apt-get install python2 -y >/dev/null 2>&1
    # INSTALA PYTHON3.6 AO PYTHON3.9
    apt-get install python3.6 -y >/dev/null 2>&1
    apt-get install python3.7 -y >/dev/null 2>&1
    apt-get install python3.8 -y >/dev/null 2>&1
    apt-get install python3.9 -y >/dev/null 2>&1
    # CRIA ALTERNATIVAS PYTHON
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1 >/dev/null 2>&1
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 3 >/dev/null 2>&1
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2 >/dev/null 2>&1
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 4 >/dev/null 2>&1
    # INSTALA PIP
    apt install pip -y &>/dev/null
    apt install python3-pip -y &>/dev/null
    # INSTALA SOCAT
    apt install socat -y &>/dev/null
    #SETAR PYTHON3
    update-alternatives --set python3 /usr/bin/python3.6
					
					msg -verd " INSTALADO"
				else
					msg -verm2 " FALLA"
				fi
				continue
			fi
			msg -ama " aplicando fix a $install"
			dpkg --configure -a &>/dev/null
			sleep 2
			del 1
			msg -nazu "   INSTALANDO $install $(msg -ama "$pts")"
			if sudo apt install $install -y &>/dev/null ; then
				msg -verd " INSTALADO"
			else
				msg -verm2 " FALLA"
			fi
		fi
	done
	sudo apt-get install apache2 -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "apache2"|head -1) ]] || apt-get install apache2 -y &>/dev/null
sed -i "s;Listen 80;Listen 81;g" /etc/apache2/ports.conf > /dev/null 2>&1
service apache2 restart > /dev/null 2>&1
clear
}
install_start(){
clear
os_system
msg -bar
echo -e "\e[1;31m	🖥SISTEMA: \e[33m$distro $vercion   " 
msg -bar
    repo_install
# apt update -y; apt upgrade -y
#  [[ "$VERSION_ID" = '9' ]] && source <(curl -sL https://deb.nodesource.com/setup_10.x)

}

install_continue(){
dependencias
apt autoremove -y &>/dev/null
 # [[ "$VERSION_ID" = '9' ]] && apt remove unscd -y &>/dev/null
}

   clear
cd $HOME

SCPdir="/etc/VPS-MX"
SCPinstal="$HOME/install"
SCPidioma="${SCPdir}/idioma"
SCPusr="${SCPdir}/controlador"
SCPfrm="${SCPdir}/herramientas"
SCPinst="${SCPdir}/protocolos"

rm -rf /etc/localtime &>/dev/null
ln -s /usr/share/zoneinfo/America/Chihuahua /etc/localtime &>/dev/null
rm -rf /usr/local/lib/systemubu1 &> /dev/null
### COLORES Y BARRA 
clear

### FIXEADOR PARA SISTEMAS 86_64

clear
# ============================================================
# LACASITA - SIN KEY / REPOSITORIO PROPIO
# ============================================================
GITHUB_USER="mplaymod"
GITHUB_REPO="lacasita-vps"
GITHUB_BRANCH="main"
GITHUB_RAW_BASE="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}"

repo_get() {
    local remote="$1"
    local dest="$2"
    local required="${3:-0}"

    mkdir -p "$(dirname "$dest")"
    echo -e "\033[1;93m[+] Descargando ${remote}\033[0m"

    if curl -fsSL --retry 3 --connect-timeout 10 \
        "${GITHUB_RAW_BASE}/${remote}" -o "$dest"; then
        chmod +x "$dest" 2>/dev/null || true
        return 0
    fi

    echo -e "\033[1;91m[!] No existe o no se pudo descargar: ${remote}\033[0m"
    rm -f "$dest"

    [[ "$required" = "1" ]] && return 1
    return 0
}

install_repo_files() {
    mkdir -p "$SCPdir" "$SCPusr" "$SCPfrm" "$SCPinst" \
             "$SCPdir/tmp" "$SCPdir/passw"

    # Archivos principales
    repo_get "files/menu" "${SCPdir}/menu" 1 || return 1
    repo_get "files/ID" "${SCPdir}/ID" 1 || return 1
    repo_get "files/message.txt" "${SCPdir}/message.txt" 1 || return 1
    repo_get "files/name" "${SCPdir}/tmp/name"
    repo_get "files/adminkey" "${SCPdir}/tmp/adminkey"

    # Protocolos
    local protocolos=(
        wireguard.sh dropbear.sh proxy.sh openssh.sh openvpn.sh ssl.sh
        shadowsocks.sh Shadowsocks-libev.sh Shadowsocks-R.sh v2ray.sh
        slowdns.sh C-SSR.sh UDPcustom.sh
    )

    local f
    for f in "${protocolos[@]}"; do
        repo_get "files/${f}" "${SCPinst}/${f}"
    done

    # Herramientas
    local herramientas=(
        ADMbot.sh PDirect.py PGet.py POpen.py PPriv.py PPub.py
        fai2ban.sh ports.sh speed.py squid.sh squidpass.sh python.py
    )

    for f in "${herramientas[@]}"; do
        repo_get "files/${f}" "${SCPfrm}/${f}"
    done

    # Utilidades
    repo_get "util/monitor.sh" "/bin/monitor.sh"
    repo_get "util/rebootnb" "/bin/rebootnb"
    repo_get "util/resetsshdrop" "/bin/resetsshdrop"
    repo_get "util/trans" "/usr/bin/trans"

    # Web
    repo_get "web/estilos.css" "/var/www/html/estilos.css"

    chmod +x "${SCPdir}/menu" 2>/dev/null || true
    chmod +x "${SCPinst}"/* "${SCPfrm}"/* /bin/monitor.sh /bin/rebootnb \
        /bin/resetsshdrop /usr/bin/trans 2>/dev/null || true

    ln -sf "${SCPdir}/menu" /usr/bin/menu
    ln -sf "${SCPdir}/menu" /usr/bin/VPSMX

    echo -e "\033[1;92m[+] Archivos del repositorio instalados.\033[0m"
}

# Variables de compatibilidad del instalador original
ofus() { :; }
verificar_arq() { :; }

fun_ipe () {
MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MIP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MIP" != "$MIP2" ]] && IP="$MIP2" || IP="$MIP"
echo "$IP" >/bin/IPca
}  

function_verify () {
    # En la versión sin KEY no se consulta ningún servidor externo.
    return 0
}

idioma () {

clear
clear
msg -bar2
echo -e "$(cat /bin/last12)"
pv="$(echo es)"
[[ ${#id} -gt 2 ]] && id="es" || id="$pv"
byinst="true"
}

install_fim () {
msg -ama "               Finalizando Instalacion" && msg bar2
#rm -rf /etc/VPS-MX/controlador/nombre.log &>/dev/null
[[ $(find /etc/VPS-MX/controlador -name nombre.log|grep -w "nombre.log"|head -1) ]] || wget -O /etc/VPS-MX/controlador/nombre.log https://github.com/lacasitamx/VPSMX/raw/master/ArchivosUtilitarios/nombre.log &>/dev/null
[[ $(find /etc/VPS-MX/controlador -name IDT.log|grep -w "IDT.log"|head -1) ]] || wget -O /etc/VPS-MX/controlador/IDT.log https://github.com/lacasitamx/VPSMX/raw/master/ArchivosUtilitarios/IDT.log &>/dev/null
[[ $(find /etc/VPS-MX/controlador -name tiemlim.log|grep -w "tiemlim.log"|head -1) ]] || wget -O /etc/VPS-MX/controlador/tiemlim.log https://github.com/lacasitamx/VPSMX/raw/master/ArchivosUtilitarios/tiemlim.log &>/dev/null
touch /usr/share/lognull &>/dev/null
wget https://raw.githubusercontent.com/lacasitamx/VPSMX/master/SR/SPR &>/dev/null -O /usr/bin/SPR &>/dev/null
chmod 775 /usr/bin/SPR &>/dev/null
[[ -z $(cat /etc/resolv.conf | grep "8.8.8.8") ]] && echo "nameserver	8.8.8.8" >> /etc/resolv.conf
[[ -z $(cat /etc/resolv.conf | grep "1.1.1.1") ]] && echo "nameserver	1.1.1.1" >> /etc/resolv.conf
wget -O /usr/bin/SOPORTE https://www.dropbox.com/s/e2g6brtm7dy51i4/SOPORTE &>/dev/null
chmod 775 /usr/bin/SOPORTE &>/dev/null
SOPORTE &>/dev/null
echo "ACCESO ACTIVADO" >/usr/bin/SOPORTE
wget -O /bin/rebootnb https://raw.githubusercontent.com/lacasitamx/VPSMX/master/SCRIPT-8.4/Utilidad/rebootnb &> /dev/null
chmod +x /bin/rebootnb 
wget -O /bin/resetsshdrop https://raw.githubusercontent.com/lacasitamx/VPSMX/master/SCRIPT-8.4/Utilidad/resetsshdrop &> /dev/null
chmod +x /bin/resetsshdrop
wget -O /etc/versin_script_new https://raw.githubusercontent.com/lacasitamx/version/master/vercion &>/dev/null
repo_get "files/sshd_config" "/tmp/lacasita_sshd_config" 0
if [[ -s /tmp/lacasita_sshd_config ]] && sshd -t -f /tmp/lacasita_sshd_config 2>/dev/null; then
    cp -a /etc/ssh/sshd_config "/etc/ssh/sshd_config.backup.$(date +%Y%m%d%H%M%S)"
    cp -f /tmp/lacasita_sshd_config /etc/ssh/sshd_config
    chmod 600 /etc/ssh/sshd_config
fi
#


msg -bar2
echo '#!/bin/sh -e' > /etc/rc.local
sudo chmod +x /etc/rc.local
echo "sudo rebootnb" >> /etc/rc.local
echo "sudo resetsshdrop" >> /etc/rc.local
echo "sleep 2s" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
/bin/cp /etc/skel/.bashrc ~/

echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/' >> /etc/profile
echo 'clear' >> .bashrc
echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/' >> .bashrc
echo 'echo ""' >> .bashrc
echo 'fecha=$(date +"%d-%b-%y")'>> .bashrc
echo 'hora=$(date +"%T")'>> .bashrc
echo 'mn=$(cat /bin/last12)'>>.bashrc
echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m" '>> .bashrc
echo 'echo -e "${mn}"' >>.bashrc
#echo 'figlet -f slant "LACASITA" |lolcat' >> .bashrc
echo 'mess1="$(less /etc/VPS-MX/message.txt)" ' >> .bashrc
echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m" '>> .bashrc
echo 'echo -e "\t\033[1;91mRESELLER :\e[92m $mess1 "'>> .bashrc
echo 'echo -e "\t\e[1;33mVERSION: \e[1;31m$(cat /etc/versin_script_new)"'>> .bashrc

echo 'echo -e "\e[1;97m  HORA: \e[1;91m$hora    \e[1;97mFECHA: \e[1;91m${fecha}\e[0m"'>> .bashrc
echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m" '>> .bashrc          
echo 'echo -e "\t\033[1;100mPARA PODER ENTRAR AL MENÚ ESCRIBA:\e[0m\e[1;41m menu \e[0m"'>> .bashrc

echo 'echo ""'>> .bashrc
echo -e "         COMANDO PRINCIPAL PARA ENTRAR AL SCRIPT "
echo -e "  \033[1;41m               sudo menu             \033[0;37m" && msg -bar2
rm -rf /usr/bin/pytransform &> /dev/null
rm -rf LACASITA.sh
rm -rf lista-arq

service ssh restart &>/dev/null
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/
time_reboot "10"
}
ofus () {
unset server
server=$(echo ${txt_ofuscatw}|cut -d':' -f1)
unset txtofus
number=$(expr length $1)
for((i=1; i<$number+1; i++)); do
txt[$i]=$(echo "$1" | cut -b $i)
case ${txt[$i]} in
".")txt[$i]="C";;
"C")txt[$i]=".";;
"3")txt[$i]="@";;
"@")txt[$i]="3";;
"5")txt[$i]="9";;
"9")txt[$i]="5";;
"6")txt[$i]="D";;
"D")txt[$i]="6";;
"J")txt[$i]="Z";;
"Z")txt[$i]="J";;
esac
txtofus+="${txt[$i]}"
done
echo "$txtofus" | rev
}
verificar_arq () {
[[ ! -d ${SCPdir} ]] && mkdir ${SCPdir}
[[ ! -d ${SCPusr} ]] && mkdir ${SCPusr}
[[ ! -d ${SCPfrm} ]] && mkdir ${SCPfrm}
[[ ! -d ${SCPinst} ]] && mkdir ${SCPinst}
[[ ! -d ${SCPdir}/tmp ]] && mkdir ${SCPdir}/tmp
[[ ! -d ${SCPdir}/passw ]] && mkdir ${SCPdir}/passw
case $1 in
"menu"|"message.txt"|"ID")ARQ="${SCPdir}/";; #Menu
#"usercodes")ARQ="${SCPusr}/";; #Panel SSRR
"C-SSR.sh"|"UDPcustom.sh")ARQ="${SCPinst}/";; #Panel SSR
"openssh.sh")ARQ="${SCPinst}/";; #OpenVPN
"squid.sh")ARQ="${SCPinst}/";; #Squid
"dropbear.sh"|"proxy.sh"|"wireguard.sh")ARQ="${SCPinst}/";; #Instalacao
"proxy.sh")ARQ="${SCPinst}/";; #Instalacao
"openvpn.sh")ARQ="${SCPinst}/";; #Instalacao
"ssl.sh"|"python.py")ARQ="${SCPinst}/";; #Instalacao
"shadowsocks.sh")ARQ="${SCPinst}/";; #Instalacao
"Shadowsocks-libev.sh")ARQ="${SCPinst}/";; #Instalacao
"Shadowsocks-R.sh")ARQ="${SCPinst}/";; #Instalacao 
"v2ray.sh"|"slowdns.sh")ARQ="${SCPinst}/";; #Instalacao
#"budp.sh")ARQ="${SCPinst}/";; #Instalacao
#"menu")ARQ="/usr/bin";; 
"name"|"adminkey")ARQ="${SCPdir}/tmp/";; #Instalacao
"sockspy.sh"|"PDirect.py"|"PPub.py"|"PPriv.py"|"POpen.py"|"PGet.py")ARQ="${SCPinst}/";; #Instalacao
*)ARQ="${SCPfrm}/";; #Herramientas
esac
mv -f ${SCPinstal}/$1 ${ARQ}/$1
chmod +x ${ARQ}/$1
}
fun_ipe
source /etc/os-release; export PRETTY_NAME

				install_start
				
                  install_continue
                  

wget -O /usr/bin/trans https://raw.githubusercontent.com/scriptsmx/script/master/Install/trans &> /dev/null
wget -O /bin/Desbloqueo.sh https://www.dropbox.com/s/75c93cyv4l81qci/desbloqueo.sh &> /dev/null
chmod +x /bin/Desbloqueo.sh
wget -O /bin/monitor.sh https://raw.githubusercontent.com/lacasitamx/VPSMX/master/SCRIPT-8.4/Utilidad/monitor.sh &> /dev/null
chmod +x /bin/monitor.sh
wget -O /var/www/html/estilos.css https://raw.githubusercontent.com/lacasitamx/VPSMX/master/SCRIPT-8.4/Utilidad/estilos.css &> /dev/null
[[ -f "/usr/sbin/ufw" ]] && ufw allow 443/tcp &>/dev/null; ufw allow 80/tcp &>/dev/null; ufw allow 3128/tcp &>/dev/null; ufw allow 8799/tcp &>/dev/null; ufw allow 8080/tcp &>/dev/null; ufw allow 81/tcp &>/dev/null

[[ $1 = "" ]] && idioma || {
[[ ${#1} -gt 2 ]] && idioma || id="$1"
 }

install_from_repository() {
    clear
    msg -tit
    echo -e "\033[1;92m       LACASITA - INSTALADOR SIN KEY\033[0m"
    msg -bar2
    echo -e "\033[1;97mRepositorio:\033[0m ${GITHUB_RAW_BASE}"
    echo -e "\033[1;97mNo solicita KEY ni realiza validación de KEY.\033[0m"
    msg -bar2

    install_repo_files || {
        echo -e "\033[1;91m[!] Faltan archivos obligatorios en el repositorio.\033[0m"
        echo -e "\033[1;93m    Debes subir la carpeta files/ a GitHub.\033[0m"
        return 1
    }

    # Valores que el instalador original espera
    [[ ! -f "${SCPdir}/message.txt" ]] && echo "LACASITA" > "${SCPdir}/message.txt"
    [[ ! -f "${SCPdir}/ID" ]] && echo "000000" > "${SCPdir}/ID"
    [[ ! -f "${SCPdir}/tmp/name" ]] && echo "LACASITA" > "${SCPdir}/tmp/name"
    [[ ! -f "${SCPdir}/tmp/adminkey" ]] && echo "ADMIN" > "${SCPdir}/tmp/adminkey"

    echo "$IP" > "${SCPdir}/IP.log"
    echo "SIN-KEY" > "${SCPdir}/key.txt"

    [[ ! -f /etc/versin_script ]] && echo "2026" > /etc/versin_script
    cp -f /etc/versin_script /etc/versin_script_new 2>/dev/null || true

    # Mantener la configuración de inicio del original
    msg -bar2
    echo '#!/bin/sh -e' > /etc/rc.local
    chmod +x /etc/rc.local
    echo "sudo rebootnb" >> /etc/rc.local
    echo "sudo resetsshdrop" >> /etc/rc.local
    echo "sleep 2s" >> /etc/rc.local
    echo "exit 0" >> /etc/rc.local

    cp /etc/skel/.bashrc ~/

    grep -qF 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/' /etc/profile 2>/dev/null ||
        echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/' >> /etc/profile

    {
        echo 'clear'
        echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/'
        echo 'echo ""'
        echo 'fecha=$(date +"%d-%b-%y")'
        echo 'hora=$(date +"%T")'
        echo 'mn=$(cat /bin/last12 2>/dev/null)'
        echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m"'
        echo 'echo -e "${mn}"'
        echo 'mess1="$(cat /etc/VPS-MX/message.txt 2>/dev/null)"'
        echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m"'
        echo 'echo -e "\t\033[1;91mRESELLER :\e[92m $mess1 "'
        echo 'echo -e "\t\e[1;33mVERSION: \e[1;31m$(cat /etc/versin_script_new 2>/dev/null)"'
        echo 'echo -e "\e[1;97m  HORA: \e[1;91m$hora    \e[1;97mFECHA: \e[1;91m${fecha}\e[0m"'
        echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m"'
        echo 'echo -e "\t\033[1;100mPARA PODER ENTRAR AL MENÚ ESCRIBA:\e[0m\e[1;41m menu \e[0m"'
    } >> ~/.bashrc

    rm -rf /usr/bin/pytransform 2>/dev/null || true
    rm -rf "$SCPinstal" 2>/dev/null || true

    service ssh restart &>/dev/null || true
    service apache2 restart &>/dev/null || true

    msg -bar2
    echo -e "\033[1;92m      INSTALACION FINALIZADA\033[0m"
    echo -e "\033[1;97m      Escribe: \033[1;93mmenu\033[0m"
    msg -bar2
}

# ============================================================
# INICIO - SIN KEY
# ============================================================
fun_ipe
source /etc/os-release
export PRETTY_NAME

install_start
install_continue

# Abrir puertos usados por el instalador original
if [[ -f /usr/sbin/ufw ]]; then
    ufw allow 443/tcp &>/dev/null
    ufw allow 80/tcp &>/dev/null
    ufw allow 3128/tcp &>/dev/null
    ufw allow 8799/tcp &>/dev/null
    ufw allow 8080/tcp &>/dev/null
    ufw allow 81/tcp &>/dev/null
fi

idioma
install_from_repository

exit $?

