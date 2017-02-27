source /home/mastinder/servers1 
#lobal variables
D=( $(date +"%Y %m %d %b  %M %S") )
action=""
app=""
build=""
env=""
user=""
isd_apps="tomcat report"
LOG=/home/mastinder/audit-deploy.log
LOG1=/home/mastinder/audit-deploy1.log
#mv  /tmp/audit-deploy.log  /tmp/audit.log
rm $LOG
echo "Start time: `date` "  >> $LOG 
validateInputAction () {
	echo "Please enter Action (Possible values:stop,start,restart,status)"
	read action
echo "Action: $action" >> $LOG
}



validateInputEnv () {
	echo "Please enter Environment (Possible values:na2stg,na3stg,eu1stg,na3qa,na2qa,eu1qa,na3smise,na2smise,eu1smise )"
	read env

echo "Environment: $env" >> $LOG
}

validateInputApp ()

{
  
echo "Please enter app  (Possible values:jboss,report,default20,sch,bill,alrtsch,appdebug,schdebug,alrtdebug,sso,ss,alfresco,http,actual,schstatus,jbossstatus,stopstub)"
	read app
echo "Application: $app" >> $LOG

}

validateInputUser ()

{
  echo "Please enter user"
   read user
  echo "User: $user" >> $LOG 
#mv $LOG $LOG1
MAILRECIPIENT="singhm,singh,,"
mail -s "$action on  $env and app $app by  $user " $MAILRECIPIENT < $LOG 
cat $LOG >> $LOG1
}

 getInputs () {
	if [ "$1" ]
	then
		action=$1
	else
		validateInputAction
	fi
                             

         if [ "$2" ]	
		then
			env=$2
		else
			validateInputEnv
		fi
           if [ "$3"]
then                       app=$3
else                      
                validateInputApp        
fi 
               if [ "$4" ]
then
                           user=$4
else 
              validateInputUser
fi
                 
}



getTargetAppServers () {
	local app=$3
	local env=$2
	
		eval app_servers=\$server_${env}_jboss_all
		
	
	echo $app_servers
}

getTargetHttpServers () {
        local app=$3
        local env=$2

                eval app_servers=\$server_${env}_http_all


        echo $app_servers
}





getTargetAltServers ()

{

  # echo "alert het"
   local app=$3
   local env=$2

                eval app_servers=\$server_${env}_alert_all


        echo $app_servers
}




getTargetAlfrescoServers ()
{ 
 local env=$2

  eval alfresco_servers=\$server_${env}_alfresco_all
    echo $alfresco_servers
}

getTargetReportServers ()

{


 local app=$3
  local env=$2
  
eval report_servers=\$server_${env}_report_all

 echo $report_servers
}

  


getTargetDefault20Servers ()

{

 local app=$3
 local env=$2

eval default20_servers=\$server_${env}_default20_all

 echo $default20_servers
}


getTargetAlertSch ()

{

 local app=$3
  local env=$2

eval alert_servers=\$server_${env}_alertsch

 echo $alert_servers
}

getTargetSchServers ()

{

 local app=$3
  local env=$2

eval Sch_servers=\$server_${env}_util_all

 echo $Sch_servers
}


getTargetSsServers  ()

{

local app=$3
local env=$2

eval Ss_servers=\$server_${env}_ss_all

 echo $Ss_servers

}
getTargetBillServers ()

{

 local app=$3
  local env=$2

eval Bill_servers=\$server_${env}_bill_all
 echo $Bill_servers

}


getTargetSsoServers ()

{
  local app=$3
  local env=$2
eval Sso_servers=\$server_${env}_sso_all
echo $Sso_servers



}


getTargetrSsoServers ()

{
  local app=$3
  local env=$2
eval Sso_servers=\$server_${env}_rsso_all
echo $Sso_servers



}



getTargetrJbossServers ()

{
  local app=$3
  local env=$2
eval Sso_servers=\$server_${env}_rjboss_all
echo $Sso_servers

}



startSso () {


                echo "-------Start SSO servers---------------------------------------"

                        local servers=`getTargetSsoServers $app $env`
                      echo "Serversn: $servers"



                        for server in $servers
                        do
                ssh $server "/dnbusr1/dnbiadm/dnbiadm_jboss_start.sh"
                                     echo "start"
                        done



}

stopSso ()

{


echo " ------------- Stop Sso server -----------------------"

local servers=`getTargetSsoServers $app $env`



echo "Servers:  $servers"

for server in $servers

do


ssh $server "sudo -u www /pkg1/jboss-4.0.3SP1/bin/jboss_startup.sh kill"
ssh $server "sudo -u www /pkg1/jboss-4.0.3SP1/bin/dnbi_rm-jboss_cache.sh"
                            

echo "stop"
done

}






 startAlrt ()

{
     local servers=`getTargetAltServers  $app $env`

echo "start alrt"
echo "Server: $servers"
 for server in $servers
   #echo "start alrt"
do

ssh $server "sudo -u www /dnbusr1/dnbi/lxp-sched/run-scheduler.sh >& /dnbusr1/dnbi/logs/stdout.log &"
 done




}

     

stopAlrt ()

{
     local servers=`getTargetAltServers  $app $env`

echo "stop  alrt"
echo "Server: $servers"
 for server in $servers
   #echo "sta alrt"
do


ssh $server "sudo -u www kill \$(ps -ef | grep  sch | grep -v -e 'grep sch' | awk '{print \$2}')"

#ssh $server "sudo -u www /dnbusr1/dnbi/lxp-sched/run-scheduler.sh >& /dnbusr1/dnbi/logs/stdout.log &"
 done




}



startJboss () {
	
                  
		echo "-------Start JBOSS servers---------------------------------------"	
		
			local servers=`getTargetAppServers $app $env`
	              echo "Servers: $servers"
     if [ "${env:0:3}" = eu1 ] || [ "${env:0:3}" = na2 ]


        then
			for server in $servers
			do
		ssh $server "/dnbusr1/dnbiadm/dnbiadm_jboss_start.sh"
			done
      	elif [ "${env:0:3}" = na3 ]
	
            then
            for server in $servers
                                     
                        do
                ssh $server "/dnbusr1/dnbiadm/dnbiadm_jboss_start.sh" 
                                         
                                
                        done
         # elif [ "{env:0:3}" = alr ]            
fi	

}


stopJboss ()

{
      

echo " ------------- Stop JBOSS server -----------------------"

local servers=`getTargetAppServers $app $env`

if [ "${env:0:3}" = eu1 ] || [ "${env:0:3}" = na2 ] ;then

echo "Servers:  $servers"

for server in $servers

do 

ssh $server "sudo -u www /pkg1/jboss-4.0.3SP1/bin/jboss_startup.sh kill"
ssh $server "sudo -u www /pkg1/jboss-4.0.3SP1/bin/dnbi_rm-jboss_cache.sh"

done
   elif [ "${env:0:3}" = na3 ]

then
            for server in $servers
                        do
                ssh $server "sudo -u www   /pkg1/jboss/current/bin/jboss_startup.sh  kill && sudo -u www  /pkg1/jboss/current/bin/dnbi_rm-jboss_cache.sh"
                        done
 fi
}


rrestartSso ()

{
  local servers=`getTargetrSsoServers $app $env`
echo "Servers:  $servers"

for server in $servers

do
echo "ripple restart"
ssh $server "sudo -u www /pkg1/jboss-4.0.3SP1/bin/jboss_startup.sh kill"
ssh $server "sudo -u www /pkg1/jboss-4.0.3SP1/bin/dnbi_rm-jboss_cache.sh"
ssh $server "/dnbusr1/dnbiadm/dnbiadm_jboss_start.sh"
done



}

rrestartJboss ()

{
  local servers=`getTargetrJbossServers $app $env`
echo "Servers:  $servers"

for server in $servers

do
echo "ripple restart"
ssh $server "sudo -u www /pkg1/jboss-4.0.3SP1/bin/jboss_startup.sh kill"
ssh $server "sudo -u www /pkg1/jboss-4.0.3SP1/bin/dnbi_rm-jboss_cache.sh"
ssh $server "/dnbusr1/dnbiadm/dnbiadm_jboss_start.sh"
done



}


JbossStatus ()

{
  local servers=`getTargetAppServers $app $env`
if [ "${env}" = eu1smise ]; then



wget -O - --http-user=admin --http-passwd=admin http://10.190.1.87:8080/jmx-console > /tmp/jmxConsole.dmp$$ 2>/dev/null

if [ $? -ne 0 ]; then
      echo "failed"
      else
echo "passed"
   fi



else 



echo "Servers:  $servers"

for server in $servers

do

wget -O - --http-user=admin --http-passwd=admin http://${server}:8080/jmx-console > /tmp/jmxConsole.dmp$$ 2>/dev/null

if [ $? -ne 0 ]; then
      echo "failed"
      else
echo "passed"
   fi

done

fi
}

stopSs ()

{
     local servers=`getTargetSsServers $app $env`  

echo "Servers:  $servers"

for server in $servers

do


ssh $server "sudo -u www /pkg1/jboss-4.0.3SP1/bin/jboss_startup.sh kill"
ssh $server "sudo -u www /pkg1/jboss-4.0.3SP1/bin/dnbi_rm-jboss_cache.sh"

done

}


startSs ()


{


 local servers=`getTargetSsServers $app $env`

echo "Servers:  $servers"

for server in $servers
                        do
                ssh $server "/dnbusr1/dnbiadm/dnbiadm_jboss_start.sh"
                             echo $server

                        done




}
startAlfresco () {
        

  echo "start Alfresco server"
  local servers=`getTargetAlfrescoServers $app $env`
                        echo "Servers: $servers"
                                        echo $servers  
                        for server in $servers
                        do
   ssh $server "sudo -u www   /pkg1/covalent/ers/servers/alfresco/bin/tomcat_startup.sh start"
                        done

}

stopAlfresco ()

{

echo "stop Alfresco server"
  local servers=`getTargetAlfrescoServers $app $env`
                        echo "Servers: $servers"
                                        echo $servers
                        for server in $servers
                        do
     ssh $server "sudo -u www   /pkg1/covalent/ers/servers/alfresco/bin/tomcat_startup.sh stop"
                        done

}

stopReport ()
{
echo "stop Report Server"

local servers=`getTargetReportServers $app $env`

echo "Server: $servers"
 for server in $servers

do 

ssh $server "sudo -u www /pkg1/covalent/ers/servers/reports/bin/tomcat_startup.sh stop"
                        done
}

startReport ()
{
echo " start Report Server "

local servers=`getTargetReportServers  $app $env`

echo "Server: $servers"
 for server in $servers

do

ssh $server "sudo -u www /pkg1/covalent/ers/servers/reports/bin/tomcat_startup.sh start"
                        done
}



startDefault20 ()
{
echo " start Report Server "

local servers=`getTargetDefault20Servers  $app $env`

echo "Server: $servers"
 for server in $servers

do

ssh $server "sudo -u www /pkg1/covalent/ers/servers/default20/bin/tomcat_startup.sh start"
                        done
}



stopDefault20 ()
{
echo " stop  Report Server "

local servers=`getTargetDefault20Servers  $app $env`

echo "Server: $servers"
 for server in $servers

do

ssh $server "sudo -u www /pkg1/covalent/ers/servers/default20/bin/tomcat_startup.sh stop"
                        done
}






stopSch ()


{


if [ "$env" = na3stg ]

then

local servers=`getTargetSchServers $app $env`

echo "Server: $servers"
for server in $servers

do

#ssh lnx273 "sudo -u www kill \$(ps -ef | grep  sch | grep -v -e 'grep sch' | awk '{print \$2}')"

ssh $server "sudo -u www kill \$(ps -ef | grep  sch | grep -v -e 'grep sch' | awk '{print \$2}')"

done

elif [ "$env" = na2stg ] || [ "$env" =  eu1stg ] || [ "$env" = na3qa ] || [ "$env" = eu1qa ] || [ "$env" = na2qa ] || [ "$env"  = eu1smise ] || [ "$env" = na2smise ] || [ "$env" = na3smise ]

then

echo " stop Sch Server "

local servers=`getTargetSchServers  $app $env`

echo "Server: $servers"
 for server in $servers

do

ssh $server "sudo -u www kill \$(ps -ef | grep  sch | grep -v -e 'grep sch' | awk '{print \$2}')"
ssh $server "rm -rf  /dnbusr1/dnbi/logs/livexp-scheduler.log"
echo "dead" 
    done
fi
}

startSch ()


{

local servers=`getTargetSchServers $app $env`
if [ "$env" = na3stg ]

then


local servers=`getTargetSchServers $app $env`
echo "Server: $servers"
 for server in $servers

do

#ssh lnx273 "cd /dnbusr1/dnbi/logs && sudo -u www /dnbusr1/dnbi/lxp-sched/run-scheduler.sh >& /dnbusr1/dnbi/logs/stdout.log &"

#ssh $server "sudo -u www /dnbusr1/dnbi/lxp-sched/run-scheduler.sh >& /dnbusr1/dnbi/logs/stdout.log  &"

#ssh $server "rm -rf  /dnbusr1/dnbi/logs/livexp-scheduler.log"
#echo "i273up"

ssh $server "sudo -u www /dnbusr1/dnbi/lxp-sched/run-scheduler.sh >& /dnbusr1/dnbi/logs/stdout.log  &"

sleep 60
ssh $server "cat /dnbusr1/dnbi/logs/stdout.log | grep 'Process Started' "


if [ $? -ne 0 ]; then
echo $server DOWN
else
echo $server UP
fi
echo "up"


done

elif [ "$env" = na2stg ] || [ "$env" =  eu1stg ] || [ "$env" = na3qa ] || [ "$env" = eu1qa ] || [ "$env" = na2qa ] || [ "$env"  = eu1smise ] || [ "$env" = na2smise ] || [ "$env" = na3smise ]

then

echo " start Sch Server "

local servers=`getTargetSchServers  $app $env`

echo "Server: $servers"
 for server in $servers

do


ssh $server "sudo -u www /dnbusr1/dnbi/lxp-sched/run-scheduler.sh >& /dnbusr1/dnbi/logs/stdout.log  &"

sleep 60
ssh $server "cat /dnbusr1/dnbi/logs/stdout.log | grep 'Process Started' "

if [ $? -ne 0 ]; then
echo $server DOWN
else
echo $server UP
fi
  done
fi

}

startSchStatus ()
{
echo "hello"
local servers=`getTargetSchServers $app $env`
echo "Server: $servers"
 for server in $servers
do
ssh $server "ps auxww  |grep lxp-sched/bin/run-scheduler.sh |grep -vq grep"
   if [ $? -ne 0 ]; then
    echo $server DOWN
   else
   echo $server UP
   fi
done

}


startBill ()


{

echo "start Bill  Server "


local servers=`getTargetSchServers  $app $env`

echo "Server: $servers"


for server in $servers

do

echo ${env:0:3}
#local  env=$(echo ${env:0:3} |  tr '[a-z]' '[A-Z]')
local  env1=$(echo ${env:0:3} |  tr '[a-z]' '[A-Z]')
#eval    env1=$($echo $env| tr '[a-z]' '[A-Z]')
echo  $env


ssh $server "cp /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env1.properties /tmp/old.`date +%F%T` &&  sed '/^.*#BatchBilling.*/ s/^#//' /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env1.properties >/tmp/new.prp.`date +%F%T` && cp /tmp/new.prp.`date +%F%T` /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env1.properties"



#ssh $server "sed '/^.*#BatchBilling.*/ s/^#//' /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env.properties >/tmp/new.prp.`date +%F%T` && cp /tmp/new.prp.`date +%F%T` /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env.properties"
                                         
 done
 
#env=$(echo ${env:0:3} |  tr '[A-Z]' '[a-z]')
echo $env
echo "start"
restartSch $app $env

}


stopBill ()


{
echo "stop  Bill  Server "


local servers=`getTargetSchServers  $app $env`

echo "Server: $servers"
 for server in $servers

do

echo ${env:0:3}
local  env1=$(echo ${env:0:3} |  tr '[a-z]' '[A-Z]')

#eval    env1=$($echo $env| tr '[a-z]' '[A-Z]')
echo  $env


#ssh $server "sed '/^BatchBilling.*/ s/^/#/' /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env.properties >/tmp/new.prp.`date +%F%T` && cp /tmp/new.prp.`date +%F%T` /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env.properties"
#ssh $server "sed '/^BatchBilling.*/ s/^/#/' /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env.properties >/tmp/new.prp.`date +%F%T` && cp /tmp/new.prp.`date +%F%T` /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env.properties"


ssh $server "cp /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env1.properties /tmp/old.`date +%F%T` && sed '/^BatchBilling.*/ s/^/#/' /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env1.properties >/tmp/new.prp.`date +%F%T` && cp /tmp/new.prp.`date +%F%T` /dnbusr1/dnbi/lxp-sched/bin/task_configuration_$env1.properties"

 done
#local env=$(echo ${env:0:3} |  tr '[A-Z]' '[a-z]')
echo $env
echo "test"
restartSch $env


}


startActual ()


{

local servers=`getTargetSchServers  $app $env`

echo " doing upload resource"



echo ${servers[@]:7:13}

ssh ${servers[@]:7:13} "cd  /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6} && ./uploadResource.sh -c ${env:0:3} -e ${env:3:6}"





echo " finished actual region "

stopHttp $env
stopJboss $env 
stopDefault20  $env
stopSs  $env
#stophttp $env
stopSch  $env
stopSso  $env
sleep 30
startSso $env
#startJboss $env
startDefault20 $env
startSs $env
#startHttp $env
startSch  $env
startHttp $env
startJboss
if [ "$env" = na3stg ];then
ssh lnx294 "sudo -u www /pkg1/covalent/ers/servers/default20/bin/tomcat_startup.sh stop &&  sudo -u www /pkg1/covalent/ers/servers/default20/bin/tomcat_startup.sh start"

echo " lnx273"
elif [ "$env" = eu1stg ]

then

echo "not na3stg"

fi

}



stopActual ()


{

local servers=`getTargetSchServers  $app $env`

echo "moving to stubs"

#ssh ${servers[@]:7:13} "cd  /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6}/deploy/ && cp livexp-deploy.properties.stubs-live livexp-deploy.properties"

echo "doing upload resource"

ssh ${servers[@]:7:13} "cd  /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6} && ./uploadResource.sh -c ${env:0:3} -e ${env:3:6}"









stopHttp $env
stopJboss $env
stopDefault20  $env
stopSs  $env
#stophttp $env
stopSch  $env
stopSso  $env

stopAlfresco $env
sleep 30
startSso $env
#startJboss $env
startDefault20 $env
startSs $env
startHttp $env
startSch  $env
startAlfresco $env
startJboss $env
if [ "$env" = na3stg ];then
ssh lnx294 "sudo -u www /pkg1/covalent/ers/servers/default20/bin/tomcat_startup.sh stop &&  sudo -u www /pkg1/covalent/ers/servers/default20/bin/tomcat_startup.sh start"

elif [ "$env" = eu1stg ]
then
echo "not na3stg"

fi

}              

startStub ()

{
  
local servers=`getTargetSchServers  $app $env`




sh /home/dnbiadm/BuildScripts/deployConfig.sh Stg stubs dtr

sh /home/dnbiadm/BuildScripts/deployConfig.sh Stg stubs infocenter

sh /home/dnbiadm/BuildScripts/deployConfig.sh Stg stubs entitlement




echo " finished stub  region "

}

stopStub ()

{

local servers=`getTargetSchServers  $app $env`






sh /home/dnbiadm/BuildScripts/deployConfig.sh Stg actual dtr

sh /home/dnbiadm/BuildScripts/deployConfig.sh Stg actual infocenter

sh /home/dnbiadm/BuildScripts/deployConfig.sh Stg actual entitlement

echo " finished actual region "


}

startAppdebug ()

{
  local servers=`getTargetSchServers  $app $env`
echo "start application in debug mode"
echo "Server: $servers"
 for server in $servers


do

echo 

#echo ${env:0:3}

echo ${env:3:6}
#local  env=$(echo ${env:0:3} )


#local  clus=$(echo ${env:3:6}) 
echo $clus
echo $env


ssh $server "sed  's/^log4j.log.level=error/log4j.log.level=debug/' /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6}/deploy/livexp-deploy.properties  >/tmp/debug.prp.`date +%F%T` && cp /tmp/debug.prp.`date +%F%T` /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6}/deploy/livexp-deploy.properties"

ssh $server "cd  /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6} && ./uploadResource.sh -c ${env:0:3} -e ${env:3:6}"

done
restartJboss $env

}


stopAppdebug ()

{
  local servers=`getTargetSchServers  $app $env`
if [ "${env:3:6}" = smise ]

then
echo "Server: $servers"
 for server in $servers

do

echo

#echo ${env:0:3}

#echo ${env:3:6}
#local  env=$(echo ${env:0:3} )


#local  clus=$(echo ${env:3:6})
echo $clus
echo $env
echo "starting application in error mode"

ssh $server "sed  's/^log4j.log.level=debug/log4j.log.level=error/' /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6}/deploy/livexp-deploy.properties  >/tmp/debug.prp.`date +%F%T` && cp /tmp/debug.prp.`date +%F%T` /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6}/deploy/livexp-deploy.properties && cd  /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6} && ./uploadResource.sh -c ${env:0:3} -e ${env:3:6}"



done

elif [ "${env:3:6}" = qa ]
then 

for server in $servers
do 
 echo "hello"


ssh $server "sed  's/^log4j.log.level=debug/log4j.log.level=error/' /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6}/deploy/livexp-deploy.properties  >/tmp/debug.prp.`date +%F%T` && cp /tmp/debug.prp.`date +%F%T` /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6}/deploy/livexp-deploy.properties && cd  /dnbusr1/ExportFiles/deploy/utilServer-${env:0:3}-${env:3:6} && ./uploadResource.sh -c ${env:0:3} -e ${env:3:6}"

done 


fi

restartJboss $env

}

stopSchdebug ()

{
  local servers=`getTargetSchServers  $app $env`



echo "Server: $servers"
 for server in $servers

do



echo "starting scheduler in error mode"

ssh $server "sed  's/^log4j.log.level=debug/log4j.log.level=error/' /dnbusr1/dnbi/lxp-sched/lib/deploy/livexp-deploy.properties >/tmp/Schdebug.prp.`date +%F%T` && cp /tmp/Schdebug.prp.`date +%F%T` /dnbusr1/dnbi/lxp-sched/lib/deploy/livexp-deploy.properties"

 restartSch $env

done

}

startSchdebug ()

{
  local servers=`getTargetSchServers  $app $env`



echo "Server: $servers"
 for server in $servers

do



echo "starting scheduler in debug  mode"
ssh $server "cd /dnbusr1/dnbi/logs/   && rm -rf sched-verbose-gc.*"
ssh $server "sed  's/^log4j.log.level=error/log4j.log.level=debug/' /dnbusr1/dnbi/lxp-sched/lib/deploy/livexp-deploy.properties >/tmp/Schdebug.prp.`date +%F%T` && cp /tmp/Schdebug.prp.`date +%F%T` /dnbusr1/dnbi/lxp-sched/lib/deploy/livexp-deploy.properties"

restartSch $env

done

}

startHttp ()

{
  local servers=`getTargetHttpServers  $app $env`



echo "Server: $servers"

if [ "${env:3:6}"  = stg ]

then
 for server in $servers

do



echo "starting Http  server"

ssh $server "sudo /pkg1/covalent/ers4/servers/dnbi/bin/apache_startup.sh start"

#ssh $server "sudo /pkg1/covalent/ers4/servers/dnbi-pdf/bin/apache_startup.sh start"
done
elif [ "${env:3:6}" = qa ] || [ "${env:3:6}" = smise ]
then
for server in $servers
do
echo "stop  Http  server"
ssh $server "sudo /pkg1/covalent/ers4/servers/dnbi/bin/apache_startup.sh start"
done
fi
}
stopHttp ()
{
local servers=`getTargetHttpServers  $app $env`
echo "Server: $servers"
if [ "${env:3:6}"  = stg ]
then
for server in $servers
do
echo "stop  Http  server"
ssh $server "sudo /pkg1/covalent/ers4/servers/dnbi/bin/apache_startup.sh stop"
#ssh $server "sudo /pkg1/covalent/ers4/servers/dnbi-pdf/bin/apache_startup.sh stop" 
done
elif [ "${env:3:6}" = qa ] || [ "${env:3:6}" = smise ]
then
for server in $servers

do
echo "stop  Http  server"
ssh $server "sudo /pkg1/covalent/ers4/servers/dnbi/bin/apache_startup.sh stop"
done
fi
}
restartReport()
{
 stopReport
 startReport
}
restartSch()
{
stopSch
startSch
}
restartJboss ()
{
stopJboss
startJboss
}
restartDefault20 ()
{
  stopDefault20
  startDefault20
}
restartSso  ()
{
stopSso
startSso
}
restartSs ()
{
stopSs 
startSs 
}
restartAlrt ()
{
stopAlrt
startAlrt
}
restartAlfresco ()
{
stopAlfresco
startAlfresco
}
restartHttp ()
{
stopHttp
startHttp
}
rSso ()

{
 rrestartSso
}

rJboss ()
{

rrestartJboss
}
#lo=/tmp/dm.log
#manage.sh | tee -a /tmp/dm.log
#MAILRECIPIENT="singhm@drd.com"
#mail -s "finished" $MAILRECIPIENT < $lio

echo "end time: `date` "  >> $LOG
