#!/usr/bin/env bash
# https://github.com/RapidEdwin08/romsetswap

currentROMdir=~/RetroPie/roms
romSETcfgFILE=~/RetroPie/roms/romset.cfg

GLrefreshLOGO=$(
echo '               .----.______             .----.______
               | roms_a    |            | roms_b    |
               |    _______|___         |    _______|___
               |   /          /  <--->  |   /          /
               |  /          /          |  /          /
               | /          /           | /          /
               |/__________/            |/__________/                
'
)

readMEfirst=$(
echo "                       *USE AT YOUR OWN RISK*
=======================================================================
     It is Recommended you have a BACKUP of your [~/RetroPie/roms]
=======================================================================

Script will MOVE [~/RetroPie/roms_a] & [~/RetroPie/roms_b] back & forth

Use this Script to PREPARE [roms_a]/[roms_b] + a [romset.cfg] for each

[romset.cfg] determines the ES [Theme] & [ScreenSaverBehavior] Settings

[roms_a]/[roms_b] Folders MUST be PREPARED 1st + contain a [romset.cfg]

Creation of [roms_a/b] can NOT be REVERSED by this Script Once PREPARED

To REVERSE Changes you must Rename/Remove [roms_a]/[roms_b] MANUALLY!

=======================================================================
      rm -Rf ~/RetroPie/roms_b #Remove ROM Set B Entirely
      rm ~/RetroPie/roms/romset.cfg #Remove ROMSet.Cfg
"
)

currentROMSab() {
checkCFGcurrent
currentROMSabCFG=$(
echo "
ls ~/RetroPie/roms*
$(ls ~/RetroPie/roms* | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/' )
=======================================================================
$(cat $romSETcfgFILEa)
=======================================================================
$(cat $romSETcfgFILEb)
")
}

checkROMSab() {
if [[ -d ~/RetroPie/roms/ ]] && [[ ! -d ~/RetroPie/roms_a/ ]] && [[ ! -d ~/RetroPie/roms_b/ ]]; then
	dialog --no-collapse --title "  [roms_a] + [roms_b] NOT FOUND!  Did you PREPARE [roms_a] + [roms_b]?  " --ok-label CONTINUE --msgbox "$(ls ~/RetroPie/* | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/' )"  25 75
	romSWAPmenu
fi
}

checkROMSabCFG() {
checkCFGcurrent
if [[ -f "$romSETcfgFILEa" ]] && [[ -f "$romSETcfgFILEb" ]]; then
	currentROMSab
	dialog --no-collapse --title "  [roms_a] + [roms_b] are PREPARED!  " --ok-label CONTINUE --msgbox "$currentROMSabCFG"  25 75
	romSWAPmenu
fi
}

checkCFGcurrent() {
if [[ -d ~/RetroPie/roms ]] && [[ -d ~/RetroPie/roms_b ]]; then currentROMa=~/RetroPie/roms; currentROMb=~/RetroPie/roms_b; fi
if [[ -d ~/RetroPie/roms ]] && [[ -d ~/RetroPie/roms_a ]]; then currentROMa=~/RetroPie/roms_a; currentROMb=~/RetroPie/roms; fi
romSETcfgFILEa=$currentROMa/romset.cfg
romSETcfgFILEb=$currentROMb/romset.cfg
}

restartES()
{
tput reset
confRESTART=$(dialog --no-collapse --title " ? RESTART ? " \
	--ok-label OK --cancel-label SKIP \
	--menu "                          Emulationstation                             " 25 75 20 \
	Y " YES RESTART [Emulationstation] " \
	N " NO" 2>&1>/dev/tty)
	if [ "$confRESTART" == 'Y' ]; then
		tput reset
		touch /tmp/es-restart
		pkill -f "/opt/retropie/supplementary/.*/emulationstation([^.]|$)" &
		exit 0
	fi
}

romSETcfg()
{
tput reset
romSETsetup=$1
if [[ "$romSETsetup" == 'roms_a' ]]; then romSELECTcfg="$romSETcfgFILEa"; romINFOsimple="R0M SET A"; fi
if [[ "$romSETsetup" == 'roms_b' ]]; then romSELECTcfg="$romSETcfgFILEb"; romINFOsimple="R0M SET B"; fi
if [[ "$2" == '' ]]; then
	confCFG=$(dialog --no-collapse --title " CONFIGURE [$romINFOsimple] " \
	--ok-label OK --cancel-label BACK \
	--menu "                          ? ARE YOU SURE ?                           $(cat $romSELECTcfg)" 25 75 20 \
	1 " CONFIGURE [$romINFOsimple]" \
	2 " BACK " 2>&1>/dev/tty)
	if [ "$confCFG" == '' ] || [ "$confCFG" == '2' ]; then romSWAPmenu; fi
fi
romSETinfoMENU=$(dialog --no-collapse --title "   SELECT Settings for [$romINFOsimple]             " \
		--ok-label SELECT --cancel-label "SKIP" \
		--menu "  Set [INFO] Settings for [$romINFOsimple] " 25 75 20 \
		1 "$romINFOsimple" \
		2 "Full R0M SET" \
		3 "Alternate R0M Set" \
		4 "Adult Games" \
		5 "Kids Games" \
		6 "Knee Deep In Pi" \
		7 "Too Young to Pi  " 2>&1>/dev/tty)
		if [ "$romSETinfoMENU" == '1' ] || [ "$romSETinfoMENU" == '' ]; then romINFOselect="$romINFOsimple"; fi
		if [ "$romSETinfoMENU" == '2' ]; then romINFOselect="Full R0M Set"; fi
		if [ "$romSETinfoMENU" == '3' ]; then romINFOselect="Alternate R0M Set"; fi
		if [ "$romSETinfoMENU" == '4' ]; then romINFOselect="Adult Games"; fi
		if [ "$romSETinfoMENU" == '5' ]; then romINFOselect="Kids Games"; fi
		if [ "$romSETinfoMENU" == '6' ]; then romINFOselect="Knee Deep In Pi"; fi
		if [ "$romSETinfoMENU" == '7' ]; then romINFOselect="Too Young to Pi"; fi
		echo "romSETinfo=\"$romINFOselect\"" > "$romSELECTcfg"

echo "romSETpath=~/RetroPie/$romSETsetup" >> "$romSELECTcfg"

currentTHEMEcount=$(( $(find /etc/emulationstation/themes /opt/retropie/configs/all/emulationstation/themes -mindepth 1 -maxdepth 1 -type d | rev | cut -d '/' -f 1 | rev | wc -l) ))
let i=0 # define counting variable
W=() # define working array
while read -r line; do # process file by file
    let i=$i+1
    W+=($i "$line")
done < <( find /etc/emulationstation/themes /opt/retropie/configs/all/emulationstation/themes -mindepth 1 -maxdepth 1 -type d | sort | rev | cut -d '/' -f 1 | rev )
esTHEME=$(dialog --title " SELECT ES Theme for [$romINFOselect] " --ok-label SELECT --cancel-label "SKIP" --menu " {$currentTHEMEcount} Emulationstation [Themes] available" 25 75 20 "${W[@]}" 3>&2 2>&1 1>&3  </dev/tty > /dev/tty) # show dialog and store output
tput reset
selectTHEME=$(find /etc/emulationstation/themes /opt/retropie/configs/all/emulationstation/themes -mindepth 1 -maxdepth 1 -type d | sort | rev | cut -d '/' -f 1 | rev | sed -n "`echo "$esTHEME p" | sed 's/ //'`")
if [[ "$esTHEME" == '' ]]; then
	echo "EStheme=$(cat /opt/retropie/configs/all/emulationstation/es_settings.cfg | grep ThemeSet | rev | cut -c 5- | rev | cut -c 32-)" >> $romSELECTcfg
else
	echo "EStheme=\"$selectTHEME\"" >> "$romSELECTcfg"
fi

customSREENsaver=$(dialog --no-collapse --title " SELECT [ScreenSaver] Settings for [$romINFOselect]             " \
		--ok-label SELECT --cancel-label "SKIP" \
		--menu " Set [ScreenSaverBehavior] " 25 75 20 \
		1 "DIM Screen" \
		2 "Black Screen" \
		3 "Random Video" \
		4 "Slideshow with [Custom] Media" \
		5 "Slideshow with [Game Image] Media " 2>&1>/dev/tty)
		# Pull Current ScreenSaver Settings
		ESscreenSAVER="$(cat /opt/retropie/configs/all/emulationstation/es_settings.cfg | grep ScreenSaverBehavior  | rev | cut -c 5- | rev | cut -c 43-)"
		customMEDIAsource=$(cat /opt/retropie/configs/all/emulationstation/es_settings.cfg | grep SlideshowScreenSaverCustomMediaSource  | rev | cut -c 5- | rev | cut -c 59-)
		# Selected ScreenSaver Settings
		if [ "$customSREENsaver" == '1' ]; then ESscreenSAVER="dim"; customMEDIAsource=false; fi
		if [ "$customSREENsaver" == '2' ]; then ESscreenSAVER="black"; customMEDIAsource=false; fi
		if [ "$customSREENsaver" == '3' ]; then ESscreenSAVER="random video"; customMEDIAsource=false; fi
		if [ "$customSREENsaver" == '4' ]; then ESscreenSAVER="slideshow"; customMEDIAsource=true; fi
		if [ "$customSREENsaver" == '5' ]; then ESscreenSAVER="slideshow"; customMEDIAsource=false; fi
		echo "screenSAVERsettings=\"$ESscreenSAVER\"" >> "$romSELECTcfg"
		echo "customMEDIAsource=$customMEDIAsource" >> "$romSELECTcfg"
}

romSETswap()
{
romSETselect=$1
if [[ "$romSETselect" == 'roms_a' ]]; then romSELECTcfg="$romSETcfgFILEa"; fi
if [[ "$romSETselect" == 'roms_b' ]]; then romSELECTcfg="$romSETcfgFILEb"; fi

source $romSELECTcfg
#TrailingSpaceRemoved=${TrailingSpaceRemoved%%[[:space:]]}
romSETinfo=${romSETinfo%%[[:space:]]}
romSETpath=${romSETpath%%[[:space:]]}
#EStheme=${EStheme%%[[:space:]]}
screenSAVERsettings=${screenSAVERsettings%%[[:space:]]}
customMEDIAsource=${customMEDIAsource%%[[:space:]]}

	confSWAP=$(dialog --no-collapse --title " SWAP to [$romSETselect] " \
		--ok-label OK --cancel-label BACK \
		--menu "                          ? ARE YOU SURE ?                           $(cat $romSELECTcfg)" 25 75 20 \
		1 " SWAP to [$romSETselect]" \
		2 " BACK " 2>&1>/dev/tty)
	if [ "$confSWAP" == '' ]; then romSWAPmenu; fi
	if [ "$confSWAP" == '1' ]; then
		# Update [es_settings.cfg] with Selected [ThemeSet] [ScreenSaverBehavior] [SlideshowScreenSaverCustomMediaSource]
		sed -i "s/<string\ name=\"ThemeSet\".*/<string\ name=\"ThemeSet\"\ value=\"$EStheme\"\ \/\>/g" /opt/retropie/configs/all/emulationstation/es_settings.cfg
		sed -i "s/<string\ name=\"ScreenSaverBehavior\".*/<string\ name=\"ScreenSaverBehavior\"\ value=\"$screenSAVERsettings\"\ \/\>/g" /opt/retropie/configs/all/emulationstation/es_settings.cfg
		sed -i "s/<bool\ name=\"SlideshowScreenSaverCustomMediaSource\".*/<bool\ name=\"SlideshowScreenSaverCustomMediaSource\"\ value=\"$customMEDIAsource\"\ \/\>/g" /opt/retropie/configs/all/emulationstation/es_settings.cfg
		
		# Swap [roms] around
		if [[ "$romSETselect" == "roms_a" ]]; then
			# Swap roms_a
			if [[ -d ~/RetroPie/roms ]] && [[ -d ~/RetroPie/roms_a ]]; then mv ~/RetroPie/roms ~/RetroPie/roms_b; mv ~/RetroPie/roms_a ~/RetroPie/roms; fi
		fi
		if [[ "$romSETselect" == "roms_b" ]]; then
			# Swap to roms_b
			if [[ -d ~/RetroPie/roms ]] && [[ -d ~/RetroPie/roms_b ]]; then mv ~/RetroPie/roms ~/RetroPie/roms_a; mv ~/RetroPie/roms_b ~/RetroPie/roms; fi
		fi
	fi
}

romSETprep()
{
confPREProms=$(dialog --no-collapse --title " PREPARE [~/RetroPie/roms] -> [~/RetroPie/roms_a] -> [~/RetroPie/roms_b]" \
--ok-label OK --cancel-label BACK \
--menu "                          ? ARE YOU SURE ?                           \n         NOTE: This action can NOT be REVERSED by this Script" 25 75 20 \
1 " PREPARE [roms_a] + [roms_b] " \
2 " BACK " 2>&1>/dev/tty)
if [[ "$confPREProms" == '' ]] || [[ "$confPREProms" == '2' ]]; then romSWAPmenu; fi
tput reset
echo 'PREPARING [~/RetroPie/roms] -> [~/RetroPie/roms_a] -> [~/RetroPie/roms_b]'
if [[ ! -d ~/RetroPie/roms_b ]]; then
	# Prep the [roms_b] Folder based on [roms]
	mkdir ~/RetroPie/roms_b
	for dirs in $(find ~/RetroPie/roms/ -mindepth 1 -maxdepth 1 -type d | grep -v genesis | rev | cut -d '/' -f 1 | rev | sort); do mkdir ~/RetroPie/roms_b/"$dirs" > /dev/null 2>&1; done
	cp -R ~/RetroPie/roms/arcade/mame2003 ~/RetroPie/roms_b/arcade/ > /dev/null 2>&1
	cp -R ~/RetroPie/roms/arcade/mame2003-plus ~/RetroPie/roms_b/arcade/ > /dev/null 2>&1
	ln -s ~/RetroPie/roms/megadrive ~/RetroPie/roms_b/genesis > /dev/null 2>&1
	cp ~/RetroPie/roms/amiga/'+Start Amiberry.sh' ~/RetroPie/roms_b/amiga/ > /dev/null 2>&1
	cp ~/RetroPie/roms/dreamcast/'+Start Reicast.sh' ~/RetroPie/roms_b/dreamcast/ > /dev/null 2>&1
	cp ~/RetroPie/roms/scummvm/'+Start ScummVM.sh' ~/RetroPie/roms_b/scummvm/ > /dev/null 2>&1
	cp ~/RetroPie/roms/ps2/'+Start AetherSX2.sh' ~/RetroPie/roms_b/ps2/ > /dev/null 2>&1
	cp ~/RetroPie/roms/pc/+Start* ~/RetroPie/roms_b/pc/ > /dev/null 2>&1
	cp ~/RetroPie/roms/gc/+Start* ~/RetroPie/roms_b/gc/ > /dev/null 2>&1
	cp -R ~/RetroPie/roms/kodi/* ~/RetroPie/roms_b/kodi/ > /dev/null 2>&1
	cp -R ~/RetroPie/roms/desktop/* ~/RetroPie/roms_b/desktop/ > /dev/null 2>&1
	if [[ -d ~/RetroPie/roms/music ]] && [[ -d ~/RetroPie/roms_b/music ]]; then cp -R ~/RetroPie/roms/music/* ~/RetroPie/roms_b/music; fi
	if [[ -d ~/RetroPie/roms/ports/doom ]] && [[ ! -d ~/RetroPie/roms_b/ports/doom ]]; then
		#for f in $(find ~/RetroPie/roms/ports/doom -maxdepth 1 -type f | sort); do cp $f ~/RetroPie/roms_b/ports/doom/; done
		mkdir ~/RetroPie/roms_b/ports/doom > /dev/null 2>&1
		mkdir ~/RetroPie/roms_b/ports/doom/addon > /dev/null 2>&1
		mkdir ~/RetroPie/roms_b/ports/doom/mods > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/doom/prboom.wad ~/RetroPie/roms_b/ports/doom > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/doom/prboom-plus.wad ~/RetroPie/roms_b/ports/doom > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/doom/doom1.wad ~/RetroPie/roms_b/ports/doom > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/doom/freedoom* ~/RetroPie/roms_b/ports/doom > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/doom/COPYING.txt ~/RetroPie/roms_b/ports/doom > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/doom/CREDITS-MUSIC.txt ~/RetroPie/roms_b/ports/doom > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/doom/CREDITS.txt ~/RetroPie/roms_b/ports/doom > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/doom/NEWS.html ~/RetroPie/roms_b/ports/doom > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/doom/README.html ~/RetroPie/roms_b/ports/doom > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/doom/lzdoom.ini ~/RetroPie/roms_b/ports/doom > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/Doom.sh ~/RetroPie/roms_b/ports/ > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/Freedoom*.sh ~/RetroPie/roms_b/ports/ > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/Kodi.sh ~/RetroPie/roms_b/ports/ > /dev/null 2>&1
		cp ~/RetroPie/roms/ports/Desktop.sh ~/RetroPie/roms_b/ports/ > /dev/null 2>&1
		chmod 755 ~/RetroPie/roms/kodi/*.sh > /dev/null 2>&1
		chmod 755 ~/RetroPie/roms/desktop/*.sh > /dev/null 2>&1
		chmod 755 ~/RetroPie/roms/amiga/*.sh  > /dev/null 2>&1
		chmod 755 ~/RetroPie/roms/dreamcast/*.sh > /dev/null 2>&1
		chmod 755 ~/RetroPie/roms/scummvm/*.sh > /dev/null 2>&1
		chmod 755 ~/RetroPie/roms/ps2/*.sh > /dev/null 2>&1
	fi
fi
}

romSWAPmenu()
{
tput reset

Custom SLIDESHOW: $(cat /opt/retropie/configs/all/emulationstation/es_settings.cfg | grep SlideshowScreenSaverCustomMediaSource  | rev | cut -c 5- | rev | cut -c 59-)
romSWAPcurrent=$(
echo "=======================================================================
Current R0M Set: $(cat ~/RetroPie/roms/romset.cfg 2> /dev/null | grep romSETinfo= | cut -c 13- | rev | cut -c 2- | rev)
Current Theme: $(cat /opt/retropie/configs/all/emulationstation/es_settings.cfg | grep ThemeSet | rev | cut -c 5- | rev | cut -c 32-)
Current ScreenSaver: $(cat /opt/retropie/configs/all/emulationstation/es_settings.cfg | grep ScreenSaverBehavior  | rev | cut -c 5- | rev | cut -c 43-)
Custom Media Source: $(cat /opt/retropie/configs/all/emulationstation/es_settings.cfg | grep SlideshowScreenSaverCustomMediaSource  | rev | cut -c 5- | rev | cut -c 59-)
"
)

romSWAPmain=$(dialog --no-collapse --title "ROM SET SWAP" \
	--ok-label OK --cancel-label EXIT \
	--menu "$GLrefreshLOGO $romSWAPcurrent" 25 75 20 \
	1 " READ ME 1st! " \
	2 " SWAP to [roms_a]  " \
	3 " SWAP to [roms_b]  " \
	4 " CONFIGURE [R0M SET A]  " \
	5 " CONFIGURE [R0M SET B]  " \
	P " PREPARE [roms_a] + [roms_b]  " \
	R " RESTART [ES]  " 2>&1>/dev/tty)

if [ "$romSWAPmain" == '1' ]; then 
	dialog --no-collapse --title "  READ ME 1st! " --ok-label CONTINUE --msgbox "$readMEfirst"  25 75
	romSWAPmenu
fi

if [ "$romSWAPmain" == '2' ]; then
	checkROMSab
	checkCFGcurrent
	romSETswap roms_a
	currentROMSab
	dialog --no-collapse --title "  SWAP to [roms_a] COMPLETE!  " --ok-label CONTINUE --msgbox "$currentROMSabCFG"  25 75
	restartES
	romSWAPmenu
fi

if [ "$romSWAPmain" == '3' ]; then
	checkROMSab
	checkCFGcurrent
	romSETswap roms_b
	currentROMSab
	dialog --no-collapse --title "  SWAP to [roms_b] COMPLETE!  " --ok-label CONTINUE --msgbox "$currentROMSabCFG"  25 75
	restartES
	romSWAPmenu
fi

if [ "$romSWAPmain" == '4' ]; then
	checkROMSab
	checkCFGcurrent
	romSETcfg roms_a
	dialog --no-collapse --title "  CONFIGURE [roms_a] COMPLETE! " --ok-label CONTINUE --msgbox "$(cat $romSETcfgFILEa)"  25 75
	romSWAPmenu
fi

if [ "$romSWAPmain" == '5' ]; then
	checkROMSab
	checkCFGcurrent
	romSETcfg roms_b
	dialog --no-collapse --title "  CONFIGURE [roms_b] COMPLETE! " --ok-label CONTINUE --msgbox "$(cat $romSETcfgFILEb)"  25 75
	romSWAPmenu
fi

if [ "$romSWAPmain" == 'P' ]; then 
	checkROMSabCFG
	romSETprep
	checkCFGcurrent
	romSETcfg roms_a auto
	romSETcfg roms_b auto
	checkROMSabCFG
	romSWAPmenu
fi

if [ "$romSWAPmain" == 'R' ]; then
	restartES
	romSWAPmenu
fi

tput reset
exit 0
}

romSWAPmenu
tput reset
exit 0
