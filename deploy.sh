cp /dev/null /tmp/$$.log

 /home/dnbiadm/mastinder/manage.sh | tee -a /tmp/$$.log


#lo=/tmp/dm.log
FROM="singhm@.com"
MAILRECIPIENT=""

mailx -s "`date` finished time `tr '\n' '\t' < audit-deploy.log`"  $MAILRECIPIENT <  /tmp/$$.log
