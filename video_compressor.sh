#!/bin/bash

base="."

if [ $# -gt 0 ]; then
    base=$1
fi

cd "$base"

for vid in *.*; do

    # declaring usefull input variables 
    initial_size="$(du -h "${vid}" | awk '{print $1}')"
    duration=$(mediainfo $vid | grep "Duration" | awk 'NR==1 {print}' | cut -d ':'  -f 2 )
    
    # printing size of initial file
    tput setaf 1; echo "compressing ${vid} with initial size ${initial_size} and duration ${duration} Started."
    tput setaf 0
    
    # compressing
    ffmpeg -i $vid -b 300k "0${vid}" && rm $vid &&  mv "0${vid}" $vid
    
    
    # declaring usefull output variables 
    final_size="$(du -h "${vid}" | awk '{print $1}')"
    percent="$(bc <<< "scale=2; 100 * $final_size / $initial_size")"
    
    # printing details of final file
    tput setaf 1
    echo "${vid} compressed."
    echo "Duration: ${duration}"
    echo "Compression: ${initial_size} --> ${final_size} (${percent}%)"
    tput setaf 0
    echo "------------------------------------------------------------------------------------"
done
