<%@ page import="java.util.*,java.text.*" %>
<html>
    <body>

<%
    System.out.println( "date now" );
    Date date = new Date();
%>
  The time is now <%= date %>


<%@ page import="java.util.*,java.text.*" %>
    <%@ include file='includedFile.txt' %>
    </body>
</html>
