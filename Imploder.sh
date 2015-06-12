#!/bin/bash

NO_ARGS=0
if [ $# -eq "$NO_ARGS" ] # Script invoked with no command-line args?
then
	  echo "You did not enter a value."
fi


halp()
{
	echo "use -s to begin, -e to end, and -r to remove the packages installed with apt-get"
	#add command line arg to pass in for apt-get versus yum, etc.
	#add interactive use, for package by package deletion
}

starts()
{
	less /var/log/apt/history.log | sed -n -e 's/^.*Commandline: apt-get .* install //p' > [put file path for log 1 here] && less /var/log/apt/history.log | sed -n -e 's/^.*Commandline: apt-get install //p' >> [put file path for log 1 here]
}

ends()
{
	less /var/log/apt/history.log | sed -n -e 's/^.*Commandline: apt-get .* install //p' > [put file path for log 2 here] && less /var/log/apt/history.log | sed -n -e 's/^.*Commandline: apt-get install //p' >> [put file path for log 2 here]
}

removes()
{
	diff [log 1] [log 2] | tail -n +2 | cut -d'>' -f2 >> [path to final file of packages to remove]
	sudo xargs -a [path to file of packages] apt-get remove --purge
	
	rm [log 1] && rm [log 2] && rm [file of packages]
}




while getopts ":hser" Option
do
	 case $Option in
		   h ) halp ;;
	   	   s ) starts ;;
	   	   e ) ends ;;
	   	   r ) removes ;;
		   * ) echo "Unimplemented option chosen.";; # Default.
	 esac
done

shift $(($OPTIND - 1))
