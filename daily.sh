
echo "<html>" >> daily.html

echo "<Body>" >> daily.html

awk 'BEGIN{print "<table>"} {print "<tr>";for(i=1;i<=NF;i++)print "<td>" $i"</td>";print "</tr>"} END{print "</table>"}' daily.txt >> daily.html

echo "</Body>" >> daily.html

echo "</html>" >> daily.html

