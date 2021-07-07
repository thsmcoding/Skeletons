#!bin/bash
#save the last version of the database in a Drupal website
function dumpdb() {
    if [[ !$(which ddev &> /dev/null) ]]; then
	echo 'The ddev command works. DDEV is already installed' && return;
	ddev list | awk 'NR>1 { print $1; }' | awk NR==1;


    else
	echo ' ddev is not installed' && return;
	echo ${date};
    fi
}
