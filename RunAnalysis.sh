#!/bin/bash
# This script runs calibrations for the EPD.
# This looks through the directories containing
# data in production and finds all relevant files
# from across the runs. This program takes two arguments:
# Argument 1 is the day to run analysis on, or the first day in a range of days;
# Argument 2, if supplied, is the last day in a range of days to do analysis on.
# import from Erik Loyd's code at /star/u/eloyd/Documents/EPD_Calibration
        #This is where the data is within /star/dataXX/
        Directory="reco/production_pp500_2022/ReversedFullField/dev/2022/"

    #This is argument 1, if supplied
        daystart=349 #default
        if [ $# -ge 1 ]
        then
                daystart=$1
        fi

    #This is argument 2, if supplied
        dayend=daystart
        if [ $# -ge 2 ]
        then
                dayend=$2
        fi

        for (( day = daystart; day <= dayend; day++ )); do
                Day=$day

                #Fix day for output
                if [ "$day" -lt 100 ]
                then
                        Day=0$day
                fi

                if [ "$day" -lt 10 ]
                then
                        Day=00$day
                fi

                #Make directories if they don't exist already
                mkdir -p Day$day/{raw_files,run_files}


: '
                for i in /star/data97/$Directory$Day/*; do
                        for j in $i/st_physics*.picoDst.root; do
                                root -q -l -b "RunAnalysis.C("\""$j"\"")" &
                        done

                        wait

                        run=${i:((${#i}-8)):8}
                        mkdir -p Day$day/raw_files/$run
                        mv Day$day/st_physics*.picoDst.root Day$day/raw_files/$run
                done
'
                for i in /star/data09/$Directory$Day/*; do
                        for j in $i/st_physics*.picoDst.root; do
                                root -q -l -b "RunAnalysis.C("\""$j"\"")" &
                        done

                        wait

                        run=${i:((${#i}-8)):8}
                        mkdir -p Day$day/raw_files/$run
                        mv Day$day/st_physics*.picoDst.root Day$day/raw_files/$run
                done

                for i in /star/data10/$Directory$Day/*; do
                        for j in $i/st_physics*.picoDst.root; do
                                root -q -l -b "RunAnalysis.C("\""$j"\"")" &
                        done

                        wait

                        run=${i:((${#i}-8)):8}
                        mkdir -p Day$day/raw_files/$run
                        mv Day$day/st_physics*.picoDst.root Day$day/raw_files/$run
                done

                for i in /star/data11/$Directory$Day/*; do
                        for j in $i/st_physics*.picoDst.root; do
                                root -q -l -b "RunAnalysis.C("\""$j"\"")" &
                        done

                        wait

                        run=${i:((${#i}-8)):8}
                        mkdir -p Day$day/raw_files/$run
                        mv Day$day/st_physics*.picoDst.root Day$day/raw_files/$run
                done

                for i in /star/data12/$Directory$Day/*; do
                        for j in $i/st_physics*.picoDst.root; do
                                root -q -l -b "RunAnalysis.C("\""$j"\"")" &
                        done

                        wait

                        run=${i:((${#i}-8)):8}
                        mkdir -p Day$day/raw_files/$run
                        mv Day$day/st_physics*.picoDst.root Day$day/raw_files/$run
                done
                wait

                for i in ./Day$day/raw_files/*; do
                        hadd -f ./Day$day/run_files/${i:((${#i}-8)):8}.picoDst.root $i/st_physics*.root &
                done

                wait
                hadd -f Day$day.root ./Day$day/run_files/*.root # Combine seperate data files

                cp Day$day.root ./Day$day/Day$day.root

        done


# Don't forget to: chmod +x RunAnalysis.sh.
# If macros won't run in Linux, try the following:
# dos2unix RunAnalysis.sh
