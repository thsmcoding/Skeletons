#!/bin/bash
#INPUT : ABSOLUTE PATH FOR A FILE TO CREATE
function createtouch() {
	[[ "${1}" ]] || echo "Function createtouch : Missing file path"; return
	#mkdir -p "$(dirname "$1")" && touch $1
	echo "${1}"
}
#CREATE THE BASIC DEFINITION FILES FOR A DRUPAL MODULE
#module.info.yml
#module.install
#module.links.menu.yml etc...
function drupalmoduleFiles() {
    [[ "{1}" ]] || echo "Function drupalmoduleFiles: Missing module name!"; return
    files=("README.md" ".info.yml" ".install" ".links.menu.yml" ".module" ".permissions.yml" ".routing.yml")
    echo "Start creating the basic files for the module..."
    for keys in "${!files[@]}"; do
		if [ keys -eq "0" ]; then
		    touch "${files[$keys]}";
		else
		    touch "${1}${files[$keys]}";
		fi
    done
echo "Function drupalmoduleFiles: Main files for Drupal module have been created. Completed.";
}
#SET UP THE COMPONENTS FOR A CUSTOM MODULE
function setupModule() {
    [[ "${1}" ]] || echo "Function setupModule : You are missing a module name.";
    local moduleName=$1;
	echo "Module settings :"
	read -p "Do you wish to set up in current location?" yn
	if [[ $yn =~ ^[Yy]$ ]] ; then
		local current_path=${pwd}
		buildfolderMod	$current_path $moduleName
	else
		read -p "Choose a location for your module:" mod_path
		buildfolderMod $mod_path $moduleName
	fi
}
#CREATE ALL THE SUBFOLDERS AND FILES WITHIN THE ROOT FOLDER MODULE
function createFolders() {
	[[ "${1}" ]] || echo "Function createFolders: You are missing a module name.";
	mod_name=$1
	drupalmoduleFiles "${mod_name,,}" #to lowercase
	folders=("config" "src" "templates")
	for folder in "${folders[*]}"; do
		mkdir $folder
		case $folder in
			"config" )
			    settings = "./config/install/"${mod_name,,}".settings.yml"
			    createtouch "${settings}"
			    schema = "./config/schema/"${mod_name,,}".schema.yml"
			    createtouch "${schema}"
			;;
			"src" )
			    mkdir -p {./src/Controller, ./src/Form, ./src/Plugin, ./src/Plugin/Block, ./src/Tests};
			    touch "./src/Controller/"${mod_name,,}"Controller.php";
			    touch "./src/Form/"${mod_name,,}"BlockForm.php";
			    touch "./src/Form/"${mod_name,,}"Form.php";
			    touch "./src/Plugin/Block/"${mod_name,,}"Block.php";
			    touch "./src/Tests/"${mod_name}"Tests.php";
			    ;;
			"templates" )
				mkdir templates
				template= ${mod_name,,}".html.twig"
				cd ./templates; touch template
				cd ..
		esac
	done
}
#CREATE THE MAIN MODULE FOLDER STRUCTURE 
function buildfolderMod() {
    if [[ $# -eq 1 ]] ; then
	echo "Function buildfolderMod: Starting to build module structure with module name as the only arg."
	createFolders "${1}"
    else
	cd "${1}"
	createFolders "${2}"
    fi
}
