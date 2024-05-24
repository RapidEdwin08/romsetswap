# romsetswap
![romsetswap.png](https://raw.githubusercontent.com/RapidEdwin08/romsetswap/main/romsetswap.png )

Menu driven script to SWAP between Rom Sets for RetroPie  
![romsetswap.png](https://raw.githubusercontent.com/RapidEdwin08/romsetswap/main/romsetswapmenus.png )

*** USE AT YOUR OWN RISK ***   
It is Recommended you have a BACKUP of your [~/RetroPie/roms]  

Script will SWAP between [$HOME/RetroPie/roms_a] & [$HOME/RetroPie/roms_b]  
[romset.cfg] determines the ES [Theme] & [ScreenSaverBehavior] Settings  
Use this Script to PREPARE [roms_a]/[roms_b] + a [romset.cfg] for each  

## INSTALLATION  

If you want 1-Run-N-Done:
```bash
curl -sSL https://raw.githubusercontent.com/RapidEdwin08/romsetswap/main/romsetswap.sh  | bash  
```

If you want to Put the Script in the retropiemenu [+Icon]:  
```bash
wget https://raw.githubusercontent.com/RapidEdwin08/romsetswap/main/romsetswap.sh -P ~/RetroPie/retropiemenu
wget https://raw.githubusercontent.com/RapidEdwin08/romsetswap/main/romsetswap.png -P ~/RetroPie/retropiemenu/icons

```

0ptionally you can Add an Entry [+Icon] to your retropiemenu [gamelist.xml]:  
*Example Entry:*  
```
	<game>
		<path>./romsetswap.sh</path>
		<name>[Rom Set Swap]</name>
		<desc>Swap Rom Sets for [RetroPie] *USE AT YOUR OWN RISK*</desc>
		<image>./icons/romsetswap.png</image>
	</game>
```

If you want to GIT it All:  
```bash
cd ~
git clone --depth 1 https://github.com/RapidEdwin08/romsetswap.git
chmod 755 ~/romsetswap/romsetswap.sh
cd ~/romsetswap && ./romsetswap.sh && cd ~

```

## REMOVAL   
Creation of [roms_a/b] can NOT be REVERSED by this Script Once PREPARED  
To REVERSE Changes you must Rename/Remove [roms_a]/[roms_b] MANUALLY!  

Example:
```bash
rm -Rf ~/RetroPie/roms_b #Remove ROM Set B Entirely
rm ~/RetroPie/roms/romset.cfg #Remove ROMSet.Cfg

```

