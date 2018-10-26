#!/bin/bash
#replace / use in scan func in basic
cw=$(tput setaf 7)
cg=$(tput setaf 10)
c1=$(tput setaf 253)
c2=$(tput setaf 251)
c3=$(tput setaf 249)
c4=$(tput setaf 247)
c5=$(tput setaf 245)
c6=$(tput setaf 243)
c7=$(tput setaf 241)
c8=$(tput setaf 239)
c9=$(tput setaf 237)
c10=$(tput setaf 235)

logo(){
	clear
	echo ${c1}'   ▄▄▄▄    ▄▄▄        ██████  ██▓ ▄████▄         ██████  ██░ ██ '
	echo ${c2}'  ▓█████▄ ▒████▄    ▒██    ▒ ▓██▒▒██▀ ▀█       ▒██    ▒ ▓██░ ██▒'
	echo ${c3}'  ▒██▒ ▄██▒██  ▀█▄  ░ ▓██▄   ▒██▒▒▓█    ▄      ░ ▓██▄   ▒██▀▀██░'
	echo ${c4}'  ▒██░█▀  ░██▄▄▄▄██   ▒   ██▒░██░▒▓▓▄ ▄██▒       ▒   ██▒░▓█ ░██ '
	echo ${c5}'  ░▓█  ▀█▓ ▓█   ▓██▒▒██████▒▒░██░▒ ▓███▀ ░ ██▓ ▒██████▒▒░▓█▒░██▓'
	echo ${c6}'  ░▒▓███▀▒ ▒▒   ▓▒█░▒ ▒▓▒ ▒ ░░▓  ░ ░▒ ▒  ░ ▒▓▒ ▒ ▒▓▒ ▒ ░ ▒ ░░▒░▒'
	echo ${c7}'  ▒░▒   ░   ▒   ▒▒ ░░ ░▒  ░ ░ ▒ ░  ░  ▒    ░▒  ░ ░▒  ░ ░ ▒ ░▒░ ░'
	echo ${c8}'   ░    ░   ░   ▒   ░  ░  ░   ▒ ░░         ░   ░  ░  ░   ░  ░░ '
	echo ${c9}'   ░            ░  ░      ░   ░  ░ ░        ░        ░   ░  ░  ░'
	echo ${c10}'        ░                        ░          ░                   '
	echo ${cw} by @fmlsec
	echo ""
}

report(){
	logo
	
	echo ${cg}' ---------<< BINARY REPORT >>---------'
	echo ""
	echo ${cg}File Name:${cw}'      ' $name
	echo ${cg}File Size:${cw}'      ' $Size bytes
	echo ""
	echo ${cg}File Type:${cw}'      '$Type ' ''('$File')'
	echo ${cg}File Header:${cw}'    '$Magic
	echo ${cg}Sha1 Hash:${cw}'       '$Hash
	echo ${cg}Entry Point:${cw}'    '$Entry
	echo ${cg}Section headers:${cw}$Section
	echo ${cg}Main Function? ${cw}'  '$Mainfunc
	echo ""
	echo ${cg}' ---------<< SYMBOLS >>---------'
	echo ""
	echo ${cw}$Symbols
	echo ""
	echo ${cg}' ---------<< ALL STRINGS >>---------'
	echo ""
	echo ${cw}$IntString
	echo ""
	echo ${cg}' ---------<< INTERESTING STRINGS >>---------'
	echo ""
	echo ${cw}$Preflag
	echo ""
	echo ${cg}' ---------<< END OF REPORT >>---------'
	echo ""
}
analysis(){
	Magic=$(readelf -h $name | grep 'Magic' | cut -d: -f2- )
	Type=$(readelf -h $name | grep 'Class' | cut -d: -f2- )
	Entry=$(readelf -h $name | grep 'Entry' | cut -d: -f2- ) 
	Section=$(readelf -h $name | grep 'Start of section' | cut -d: -f2- )
	Size=$(du -b $name | cut -f 1)
	Hash=$(sha1sum $name | cut -c1-40 )
	File=$(objdump -f $name | grep 'format' | cut -d- -f2- )
	Mainfunc=$(strings $name | grep -ho 'main' | head -1 )
	if [ -z "$Mainfunc" ]
	then
		let $Mainfunc == 'No Main Function found '
	else 
		let $Mainfunc == 'Main Function present '
	fi
	Symbols=$(nm $name | cut -c19-40 )
	echo $Symbols > Symbols.out
	Symlines=$(nm $name | wc -l)
	Stringz=$(strings $name)
	echo $Stringz > Strings.out
	Preflag=$(strings $name | grep $flag )
	IntString=$(diff Symbols.out Strings.out | grep "^>")

report

}
logo
echo ${cw}Enter name of file
read name
if [ -z "$name" ]
then
	echo No file Selected. Exiting
	exit
fi
echo ${cw}Enter flag format "(E.g FLAG{..})"
read flag
if [ -z "$flag" ]
then
	echo Using "'FLAG'"
fi

analysis


#basic.sh by fmlsec

#this script attempts to automate basic tasks during ctf challenges

