#!bin/bash
function touchBis() {
	[[ "${1}" ]] || echo "Missing file path"; return
	mkdir -p "$(dirname "$1")" && touch $1
}
#Set up the necessary components for a custom module
function setModule() {
	[ "${1}" ] || echo "You are missing a module name."; return
	local moduleName= $1;
	echo "Where do you want to set your module ?"
	read "Do you wish to set up in current location?" yn
	if [[ $yn =~[Yy]$ ]] ; then
		local correct_path = ${pwd}
		crMod	
	else
		read -p "Choose a location for your module:" mod_path
		crMod $mod_path
	fi
}
function strmod() {
	[[ "${1}" ]] || echo "You are missing a module name."; return
	local mod_name = $1
	folders=("config" "src" "templates")
	for folder in ${folders[@]}; do
		mkdir $folder
		case $folder in
			"config")
				local settings = "./config/install/"+$mod_name+".settings.yml"
				touchBis settings
				local schema = "./config/schema/"+$mod_name+".schema.yml"
				touchBis schema
			;;
			"src")
				mkdir -p {./src/Controller, ./src/Form, ./src/Plugin, ./src/Plugin/Block, ./src/Test}

			;;
			"templates")
				mkdir templates
				local template= $mod_name+".html.twig"
				cd ./templates; touch template
		esac
	done

}
#Create older structure for a custom module in Drupal 
function crMod() {
	if [[ $# -eq 2 ]]  ; then
	else
		cd $1
		strmod $2
	fi
}
