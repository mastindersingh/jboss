DATE=( $(date +"%Y %m %d %B" -d "${DAYS_AGO:-"1"} days ago") )
D=( $(date +"%Y %m %d %b") )
Month="${D[3]}"
Day="${D[2]}"
echo $Day
LOGDIR="/home//mastinder/"

FULLDIR="$LOGDIR/${DATE[0]}/${DATE[1]}_${DATE[3]}"

FILE1="${DATE[0]}-${DATE[1]}-${DATE[2]}_month.log"

FILE2="${DATE[0]}-${DATE[1]}-${DATE[2]}_daily.log"

mkdir -p $FULLDIR
eval pushd $FULLDIR

cat /tmp/audit-deploy1.log |  grep Start    > file1.txt
cat /tmp/audit-deploy1.log |  grep User   > file2.txt

cat /tmp/audit-deploy1.log  | grep Action  > file3.txt

cat /tmp/audit-deploy1.log |  grep Environment  > file4.txt

cat /tmp/audit-deploy1.log |  grep Application  > file5.txt

paste -d "," file1.txt file2.txt file3.txt file4.txt file5.txt > file.txt

cat file.txt | grep "$Month $Day"   > $FILE2

cat file.txt | grep $Month > $FILE1

cp file.txt /pkg1/ctier/pkgs/jetty-6.1.14/webapps/test/jsp/combined.txt
cp $FILE1 /pkg1/ctier/pkgs/jetty-6.1.14/webapps/test/jsp/monthly.txt

cp $FILE2 /pkg1/ctier/pkgs/jetty-6.1.14/webapps/test/jsp/daily.txt

eval popd $FULLDIR

CON=/pkg1/ctier/pkgs/jetty-6.1.14/webapps/test/jsp/
eval pushd $CON

sh  tesdaily.sh
sh tes.sh

eval popd $CON
