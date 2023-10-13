#!/bin/bash
## Checking for required dependencies
## @author wborkowski@uw.edu.pl
echo "Running" `realpath $0`

#echo "COLOR1="$COLOR1
source $(dirname "$0")/screen.ini > screen.lst
#echo "COLOR1="$COLOR1

set -e #https://intoli.com/blog/exit-on-errors-in-bash-scripts/

echo -e $COLOR2"\n\tThis script stops on any error!"
echo -e "\tWhen it stop, remove source of the error & run it again!\n"$NORMCO

echo -e $COLOR1"Test for required software:\n"$COLOR4
echo -e "Processing.org..."$NORMCO

find ~/ -name "processing" -type f -executable -print > processing_dirs.lst
grep --color "processing" processing_dirs.lst
wc -l processing_dirs.lst

echo -e $COLOR2"\n\tLooks like you have Processing."
echo -e "\tRemember to run install in its main directory."$NORMCO

echo -e $COLOR4"\nVideo library..." $NORMCO
find ~/ -name "hamoid"  -print > hamoid_dirs.lst
grep --color "hamoid" hamoid_dirs.lst
wc -l hamoid_dirs.lst

echo -e $COLOR2"\n\tLooks like you have Hamoid Video Library."$NORMCO

echo -e $COLOR4"\nffmpeg tool..."$NORMCO
ffmpeg -version | grep --color "ffmpeg.*version"
echo -e $COLOR2"\n\tLooks like you have ffmpeg tool instaled\n"$NORMCO


#instalacja zmiennej ze ścieżką do IDE processingu
#jesli jest to potrzebne
set +e
grep -q "PRIDE" $HOME/.profile

if [  $? != 0  ]
then
     tmp=`tail -1 processing_dirs.lst`
     PRIDE="$tmp"
     echo -e "\nProcessing IDE is" $PRIDE
     echo -e "\nexport PRIDE="$tmp >> $HOME/.profile
fi
echo "In $HOME/.profile:"
grep --color "PRIDE" $HOME/.profile


