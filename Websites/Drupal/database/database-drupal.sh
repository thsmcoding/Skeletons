#!bin/bash
dumpdb() {
    if [[ !$(which ddev &> /dev/null) ]]; then
	echo 'The ddev command works. DDEV is already installed';
	ddev list &> 'ddev.txt' && awk '!NF{f=0} /NAME/ {f=1} f' ddev.txt 
	rm ddev.txt
	echo "\n"
	echo "Make sure current location is same as a project name!";
	echo 'Current location is '${pwd}
	read -p 'Is it ok?' yn
	if [[ $yn =~ ^[Yy]$ ]] ; then
	    if [[ -d './DB_DUMPS' ]]; then
		echo "DB_DUMPS directory ready";
	    else
		mkdir ./DB_DUMPS
		echo "./DB_DUMPS directory has just been created."
	    fi
	else
	    echo "Please choose your project location :" $location
	fi
	currentdate=`date '+%F_%H-%M-%S'`;
	echo $currentdate;
	local currentfile=$(basename "${PWD}")"_db_dump_"${currentdate}".sql.gz";
	echo "Last db dump saved under name : " $currentfile;
	ddev export-db --file=./DB_DUMPS/${currentfile};
	echo "Database dump saved with success";
    else 
	echo 'ddev is not installed.Install DDEV first' && return;    
    fi
}
