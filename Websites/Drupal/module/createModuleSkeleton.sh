#!/bin/bash
function createtouch() {
    echo "NUMBER OF ARGS :"$#
    [[ "${1}" ]] || echo "Function createtouch : Missing file path";
    mkdir -p "$(dirname "$1")" && touch ${1}
    echo ${1}
}
function drupalmoduleFiles() {
    [[ "{1}" ]] || echo "Function drupalmoduleFiles: Missing module name!";
    files=("README.md" ".info.yml" ".install" ".links.menu.yml" ".module" ".permissions.yml" ".routing.yml")
    echo "Start creating the basic files for the module..."
    for keys in "${!files[@]}"; do
		if [[ $keys -eq 0 ]]; then
		    touch "${files[$keys]}";
		else
		    touch "${1}${files[$keys]}";
		fi
    done
echo "Function drupalmoduleFiles: Main files for Drupal module have been created. Completed.";
}
function setupModule() {
    [[ "${1}" ]] || echo "Function setupModule : You are missing a module name."return;
    moduleName=${1};
    echo "Chosen module name : " $moduleName
    echo "Module settings :"
    read -p "Do you wish to set up in current location?" yn
    if [[ $yn =~ ^[Yy]$ ]] ; then
	local current_path=${pwd}
	mkdir ./$moduleName && cd ./$moduleName
	buildfolderMod $moduleName
    else
	read -p "Choose a location for your module:" mod_path
	buildfolderMod $mod_path $moduleName
    fi
}
function createFolders() {
	[[ "${1}" ]] || echo "Function createFolders: You are missing a module name."
	mod_name=${1}
	mod_name=${mod_name,,}
	drupalmoduleFiles ${mod_name} 
	folders=("config" "src" "templates")
	for folder in "${folders[@]}"; do
	    mkdir $folder;
	    case "$folder" in
		"config")
		    settings="./config/install/"${mod_name}".settings.yml"
		    createtouch ${settings}
		    schema="./config/schema/"${mod_name}".schema.yml"
		    createtouch ${schema}
		    ;;
		"src")
		    mkdir -p {"./src/Controller","./src/Form","./src/Plugin","./src/Plugin/Block","./src/Tests"};
		    touch "./src/Controller/"${mod_name^}"Controller.php" "./src/Form/"${mod_name^}"BlockForm.php" "./src/Form/"${mod_name^}"Form.php" "./src/Plugin/Block/"${mod_name^}"Block.php" "./src/Tests/"${mod_name^}"Tests.php"
		    ;;
		"templates")
		    template=${mod_name,,}".html.twig"
		    cd ./templates && touch $template
		    cd ..
	    esac
	done
}
#CREATE THE MAIN MODULE FOLDER STRUCTURE 
function buildfolderMod() {
    if [[ $# -eq 1 ]] ; then
	echo "Function buildfolderMod: Starting to build module structure with module name as the only arg."
	createFolders ${1}
    else
	cd ${1}
	mkdir ${2} && cd ${2}
	createFolders ${2}
    fi
    cd ..
}
