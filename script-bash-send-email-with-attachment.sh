#!/bin/bash
# send and email (with an attachment) from the command line using mutt
# use to send a .csv file or .pdf to a recipient
echo "Hey Ben, I know how to use command line to send and email with an attachment, this is from one of our AWS instances." | mutt -e 'my_hdr From: EMS DevOps <jared@ems.com.au>' -a SugarCRM_Prereq.sh -s "I worked it out" -- ben@evolutionmarketing.com.au