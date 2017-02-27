source ~/.bash_profile
source /home/mastinder/jfunctions.sh 
getInputs $1 $2  $3 $4
##stop function here
if [ "$action" = stop ];then
if [ "$app" = tomcat ];then      
stopTomcat
fi
if [ "$app" = report ];then
stopReport
fi

if [ "$app" = stopstub ];then
stopStub
fi

if [ "$app" = schstatus ];then
startSchStatus
fi
if [ "$app"  = default20 ];then
stopDefault20
fi
if [ "$app" = jboss ];then
stopJboss    
fi
if [ "$app" = sch ];then
stopSch
   fi
if [ "$app" = bill ];then
stopBill
fi
if [ "$app" = appdebug ];then
stopAppdebug
fi
if [ "$app" = schdebug ];then
stopSchdebug
fi
if [ "$app" = http ];then
stopHttp
fi                                        
if [ "$app" = sso ];then
stopSso
fi            
if [ "$app" = ss ];then
stopSs
fi 
if [ "$app" = actual ];
then
stopActual
fi
if [ "$app" = alfresco ];then
stopAlfresco
fi                                                         
 if [ "$app" = alrtsch ];then          
stopAlrt
fi
##start funtions here 
elif [ "$action" = start ]
then
if [ "$app" = report ]; then
startReport
fi
if [ "$app" = startstub ];then
startStub
fi
if [ "$app"  = default20 ];then 
startDefault20
fi                                                                
if [ "$app" = jboss ];then 
startJboss                                                                    
 fi                                                                    
if [ "$app" = sch ];then
 startSch
fi
if [ "$app" = bill ];then
 startBill
fi
if [ "$app" = appdebug ];then
 startAppdebug 
fi
if [ "$app" = schdebug ];then
 startSchdebug
fi
if [ "$app" = http ];then
startHttp
fi
if [ "$app" = sso ];then
startSso
fi            
if [ "$app" = ss ];then
startSs
fi
if [ "$app" = actual ]; then
startActual
fi
if [ "$app" = alfresco ]; then
startAlfresco
fi

if [ "$app" = alrtsch ];then
startAlrt
fi
##restart function 
elif [ "$action" = restart ];then
if [ "$app" = sch ];then 
restartSch
fi
if [ "$app" = jboss ];then
restartJboss
fi
if [ "$app" = sso ];then 
restartSso
fi
if [ "$app" = ss ];then 
restartSs
fi
if [ "$app" = alfresco ];then
restartAlfresco
fi
if [ "$app" = http ];then
restartHttp
fi
if [ "$app" = default20 ];then
restartDefault20 
fi
if [ "$app" = report ];then
restartReport
fi
if [ "$app" = alrtsch ];then
restartAlrt
fi
if [ "$app" = rsso ];then
rrestartSso
fi
if [ "$app" = rjboss ];then
rrestartJboss
fi

elif [ "$action" = status ];then
if [ "$app" = schstatus ];then
startSchStatus
fi
if [ "$app" = jbossstatus ];then
JbossStatus
fi
if [ "$app" = tomcatstatus ];then
JbossStatus
fi

fi

#manage.sh | tee -a /tmp/dm.log
#MAILRECIPIENT="singhm@"
#mail -s "$action on  $env and application $app by  $user " $MAILRECIPIENT < /tmp/dm.log
#MAILRECIPIENT="singhm@dnb.com"
#mail -s "$action on  $env and application $app by  $user " $MAILRECIPIENT < $LOG
