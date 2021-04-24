<cfif IsDefined("url.act")>
<cfset TemplateSwitch=url.act>
<cfswitch expression="#TemplateSwitch#">

<!--- *** CUSTOMER RESULTS --->
<cfcase value="enroll">

<cfif IsDefined("form.button")>

<!--- UPDATE --->
<cfquery name="EnrollAS" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
UPDATE #APPLICATION.DBPRE#Orders
SET Autoship = 1, Cycle = #Val(form.cycle)#
WHERE OrderID = #Val(form.oid)#
</CFQUERY>

<table width="600" height="450" border="0" align="center">
  <tr>
    <td width="600" height="450" valign="top"><div align="center">
    <hr>
      <p>&nbsp;</p>
      <p><font face="Arial, Helvetica, sans-serif">Email Reminders For Order Number <cfoutput>#form.oid#</cfoutput> <br>Will Be Sent as Requested. Have a Good Day! </font></p>

    </div></td>
  </tr>
</table>

<cfelse>

<table width="600" height="450" border="0" align="center">
  <tr>
    <td width="600" height="450" valign="top"><div align="center">
    <hr>
      <p>&nbsp;</p>
      <p><font face="Arial, Helvetica, sans-serif">No Email Reminders For Order Number <cfoutput>#form.oid#</cfoutput> Will Be Sent! </font></p>
    </div></td>
  </tr>
</table>

</cfif>
</cfcase>
</cfswitch>

<cfelse>
	<cflocation url="http://www.quick2you.com" ADDTOKEN="No">
</cfif>
