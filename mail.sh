cp /dev/null /tmp/dm.log

 /home/dnbiadm/mastinder/manage.sh | tee -a /tmp/dm.log


#lo=/tmp/dm.log
MAILRECIPIENT=",,m"
mailx -s "finished" $MAILRECIPIENT <  /tmp/dm.log
