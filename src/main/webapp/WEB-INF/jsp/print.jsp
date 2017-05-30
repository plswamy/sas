<html>
<head>
<title> Print Report </title>
<script>
function assignLocation(filename) {
document.location.href  = '/pdf/'+filename;
return;
}
</script>
</head>
<% 
	String pdfFile = (String) request.getAttribute("pdffile");
	System.out.println(pdfFile);
%>
<BODY onLoad="assignLocation('<%=pdfFile%>'); ">
 PDF is Loading!!!..... 

</BODY>

</html>
