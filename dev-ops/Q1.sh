#!/bin/sh

gunzip -c DevOps_interview_data_set.gz > test.txt

for i in {00..23}
do
    n=$(grep "May 13 $i:" test.txt|awk '{print $4}' |sort -u)
    list=""
    for deviceName in $(echo $n)
    do
        grep "May 13 $i:" test.txt|awk -F "$deviceName" '{print $2}' |sort |uniq -c|while read numberOfOccurrence msg
        do
            s=$(echo $msg |grep '])'|wc -l)
            if [ $s == 1 ];then
                processId=$(echo $msg|awk -F "[" '{print $3}' |cut -d ']' -f 1)
                processName=$(echo $msg|awk -F '(' '{print $2}'|cut -d '[' -f 1)
                description=$(echo $msg|awk -F "]):" '{print $2}')
            else
                processId=$(echo $msg|awk -F ']' '{print $1}'|cut -d '[' -f 2)
                processName=$(echo $msg|awk -F '[' '{print $1}')
                description=$(echo $msg|awk -F ":" '{print $2,$3}')
            fi
            curl -k -X POST -H 'Content-type':'application/json' -d "{\"deviceName\":\"${deviceName}\",\"processId\":\"${processId}\",\"processName\":\"${processName}\",\"description\":\"${description}\",\"timeWindow\":\"${i}00-$((${i}+1))00\","numberOfOccurrence":\"${numberOfOccurrence}\"}" https://foo.com/bar
        done
    done
done
