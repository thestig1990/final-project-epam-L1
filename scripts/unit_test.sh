#!/bin/bash

ARTIFACT="index.html"

echo "#-------------------Test STARTED-------------------#"
sleep 5
result=`grep "Yevhen Yakymov" $ARTIFACT | wc -l`
echo "The phrase 'Yevhen Yakymov' is used $result times on the website"
if [ "$result" == "2" ]
then
    echo "#-------------------Test Passed--------------------#"
    exit 0
else
    echo "Test Failed"
    exit 1
fi
echo "#-------------------Test FINISHED------------------#"
