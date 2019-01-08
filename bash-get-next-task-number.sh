#!/bin/bash

source ~/last_task_number.txt
((TaskNumber++))
echo $TaskNumber
echo "TaskNumber=$TaskNumber" > ~/last_task_number.txt
