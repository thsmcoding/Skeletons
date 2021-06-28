#!bin/bash
#CREATES ALL THE BASIC FILES FOR THEME IN A DRUPAL WEBSITE
#THEMENAME.theme, THEMENAME.libraries.yml, THEMENAME.info.yml 
function createfiles() {
    [[ "$#" -gt 2 ]] || (echo "Function createfiles : missing args"  && return);
    themename=${1}
    shift
    filenames=("$@")
    printf $filenames
    for f in "${!filenames[@]}"; do
	echo "function createfiles : " $f
	if [[ $f -eq 0 ]]; then
	    touch "${filenames[$f]}"
	else
	    touch "$themename${filenames[$f]}"
	fi
    done
    echo "Function createfiles : File creation completed";
}
#CREATES THE FOLDER STRUCTURE FOR A THEME IN A DRUPAL PROJECT
function createfolders() {
    echo "number of arguments :" $#
    [[ $# -gt 1 ]] || (echo "function createfolders : Missing args " && return);
    local folders=("$@")
    for folder in "${folders[@]}"; do
	case "$folder" in
	    "config")
		mkdir -p {"./config","./config/install","./config/schema"}
		;;
	    *)			
		mkdir $folder
		;;
	esac
    done
    echo "function createfolders : Folder structure creation completed! "
}
#SETS UP THE FOLDER STRUCTURE FOR A THEME IN A DRUPAL WEBSITE
function setuptheme() {
    read -p "Please enter your theme name: " theme
    echo "Your theme's name is :"${theme}
    files=("theme-settings.php" ".theme" ".libraries.yml" ".info.yml" ".breakpoints.yml");
    folders=("config" "css" "js" "images" "templates")
    read -p "Do you wish to set up your theme in current location?" yn
    if [[ $yn =~ ^[Yy]$ ]] ; then
	mkdir ./$theme && cd ./$theme
    else
	read -p "Please choose a location to set up your theme : " location
	cd ${location} && mkdir ./$theme && cd ./$theme
    fi
    createfolders "${folders[@]}"
    createfiles "$theme" "${files[@]}"
    echo "Function setuptheme: Settting up theme folder completed with success !"
}



