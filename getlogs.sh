#!/bin/bash

# getlogs
# a smart and fast way to  get journalctl logs, and exporting it to a log or text file
# 
#
# a ninetyninebytes project!
# built on 2023-05-01 

# MIT License
#
# Copyright (c) 2023 ninetyninebytes
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

if [ `id -u` = 0 ] ; then 
  echo -e "\e[1;31m=== root account detected ===\e[0m"
  echo
  echo "ooh! we've detected that you're running this script with root privileges." 
  echo "by running this script as root, you unlock functions like advanced journalctl outputs."
  echo "however, it's not recommended to use root because the output will be at /root, rather than /home"
  echo "we might add extra root features soon!" 
  echo "by continuing, you understand that things may go wrong when using the script!"
  echo
  read -n1 -s -r -p $'press any key to ignore and continue, or press ctrl + c to exit.\n' key
fi

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\e[1;32mgetlogs 1.0.0\e[0m"
echo
echo "a simple way to get journalctl logs from your system"
echo "and export it as a .log or .txt file"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "current user:"
if [ `id -u` = 0 ]
then
  echo -e "\e[1;31m===running as root!===\e[0m"
else
  echo $USER
fi
echo
echo "current home directory (your log outputs will be put here!)"
if [ `id -u` = 0 ]
then
  echo -e "\e[1;31m$HOME\e[0m"
else
  echo $HOME
fi
echo
echo "(also dont worry, if you dont have the proper directories we will make them for you)"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\e[1;33ma ninetyninebytes project!\e[0m"
echo built on 2023-05-01
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"


while true; do
    read -p "press C to continue, or X to exit: " cx
    case $cx in
        [Cc]* ) break;;
        [Xx]* ) echo "application quit."; exit;;
        * ) echo "Please choose a valid selection";;
    esac
done

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\033[1mchoosing a timeframe\033[0m"
echo
echo "please choose a timeframe for your logs"
echo "protip! you can use words like today, yesterday, tomorrow, and now"
echo "you can also use a date, but it must be formatted specifically."
echo "the date formatting is YYYY-MM-DD"
echo
echo "please enter the timeframe"
read timeframe
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\033[1mchoosing a file format\033[0m"
echo "getlogs supports using multiple file formats"
echo "it is recommended to use .log over .txt, however it is your choice"
echo
while true; do
    read -p "press L to use .log (recommended), or T to use .txt: " lt
    case $lt in
        [Ll]* ) 
            fileformat=$(echo ".log");
            break;;
        [Tt]* ) 
            fileformat=$(echo ".txt"); 
            break;;
        * ) echo "Please choose a valid selection";;
    esac
done

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\033[1mchoosing the type of log\033[0m"
echo
echo "please enter the type of log you want to get"
echo 
echo "A = All System Logs (all logs)"
echo "C = Choose a log for a specific process (example: NetworkManager)"

while true; do
    read -p "your selection [A/C]: " ac 
    case $ac in
        [Aa]* )
            timestamp=$(date +%Y-%m-%d-%H-%M-%S); 
            mkdir -p $HOME/getlogs_exports/all_system_logs
            export_location="$HOME/getlogs_exports/all_system_logs"
            journalctl -S $timeframe --no-tail > getlogs_all_${timestamp}${fileformat};
            mv getlogs_* $HOME/getlogs_exports/all_system_logs 
            break;;
        [Cc]* ) 
            timestamp=$(date +%Y-%m-%d-%H-%M-%S);
            echo "please enter the process name";
            read processname;
            mkdir -p $HOME/getlogs_exports/process_logs
            export_location="$HOME/getlogs_exports/process_logs"
            journalctl -u $processname -S $timeframe --no-tail > getlogs_process_${processname}_${timestamp}${fileformat};
            mv getlogs_process_* $HOME/getlogs_exports/process_logs
            break;;
        * ) echo "Please choose a valid selection";;
    esac
done

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\e[1;32msuccess!\e[0m"
echo "your file should be exported at"
echo $export_location
echo "note! if you'd like to get more log access, add yourself to the systemd-journal group and run this script again."
echo "thanks for using my script!"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
