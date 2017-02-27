
echo "<html>" >> monthly.html

echo "<Body>" >> monthly.html

awk 'BEGIN{print "<table>"} {print "<tr>";for(i=1;i<=NF;i++)print "<td>" $i"</td>";print "</tr>"} END{print "</table>"}' monthly.txt >> monthly.html

echo "</Body>" >> monthly.html

echo "</html>" >> monthly.html

