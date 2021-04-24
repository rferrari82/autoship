<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 COLS=2 WIDTH="750">
<TR>
<TD>
<!--- Start Search Form --->
<b>Search by order nmber:</b>
<form action="index.cfm" method="GET">
<INPUT TYPE="HIDDEN" NAME="page" VALUE="orders">
<INPUT TYPE="HIDDEN" NAME="act" VALUE="details">
<INPUT TYPE="TEXT" NAME="oid" SIZE="10" MAXLENGTH="10">
<INPUT TYPE="Submit" VALUE="Search" CLASS="button">
<!--- End Search Form --->
</form>
</TD>
</TR>
</TABLE><br><br>

<cfset today = #DateFormat(Now(), "mm")#>
<cfset year = #DateFormat(Now(), "yyyy")#>
<cfset thisday = #DateFormat(Now(), "yyyy-mm-dd")#>

<b>Search by one of the following:</b>
<TABLE BORDER=1 CELLSPACING=0 CELLPADDING=0 COLS=2 WIDTH="300">
<TR>
<TD>
<form action="index.cfm?page=searchorders&act=view" method="POST">
<INPUT TYPE="TEXT" NAME="searchtext" SIZE="30" MAXLENGTH="30">
</TD>
</TR>
<tr>
<td><INPUT TYPE=radio NAME="searchfor" VALUE="BillToName" CHECKED>BillToName <INPUT TYPE=radio NAME="searchfor" VALUE="BillToPostalCode">BillToZip
<INPUT TYPE=radio NAME="searchfor" VALUE="CCNum3">Credit Card <INPUT TYPE=radio NAME="searchfor" VALUE="CustomerID">CustomerID
<INPUT TYPE=radio NAME="searchfor" VALUE="BillToPhone">BillToPhone <INPUT TYPE=radio NAME="searchfor" VALUE="BillToEmail">BillToEmail
<INPUT TYPE=radio NAME="searchfor" VALUE="ShipToName">ShipToName<INPUT TYPE=radio NAME="searchfor" VALUE="TNum">Tracking Number<INPUT TYPE=radio NAME="searchfor" VALUE="SalesPerson">Sales Person<INPUT TYPE=radio NAME="searchfor" VALUE="IP">IP<INPUT TYPE=radio NAME="searchfor" VALUE="BillToStateID"><a href="index.cfm?page=getstates" target="_blank">BillToStateID</a>
<br><INPUT TYPE=radio NAME="searchfor" VALUE="BillToCountryID"><a href="index.cfm?page=getcountries" target="_blank">BillToCountryID</a><cfif astatus is 1><INPUT TYPE=radio NAME="searchfor" VALUE="KW">Keyword</cfif></td>
</tr>
<tr>
<td><BR>
Range1:<INPUT TYPE="Text" NAME="date1" <cfoutput>VALUE="#APPLICATION.DATEMINUS30#"</cfoutput> CLASS="button"><br>
Range2:<INPUT TYPE="Text" NAME="date2" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button"><br>
Search in Range?<INPUT TYPE=radio NAME="dd" VALUE="1" CHECKED>Yes<INPUT TYPE=radio NAME="dd" VALUE="0">No
</td>
</tr>
<tr>
<td><br>
<INPUT TYPE="Submit" VALUE="Search" CLASS="button">
</form>
</td>
</tr>
</TABLE>
<br>
<br>

<b>Search for orders with a specific status:</b>
<form action="index.cfm?page=searchordersstatus&act=view" method="POST">
<TABLE BORDER=1 CELLSPACING=0 CELLPADDING=0 COLS=2 WIDTH="100">
<TR><TD>
<SELECT NAME="status" SIZE=1>
<OPTION VALUE="0">NEW</OPTION>
<OPTION VALUE="1">CARD APPROVED</OPTION>
<OPTION VALUE="2">DECLINED</OPTION>
<OPTION VALUE="3">SHIPPED</OPTION>
<OPTION VALUE="4">BACKORDER</OPTION>
<OPTION VALUE="5">DELETED</OPTION>
<OPTION VALUE="6">DIFF BILL/SHIP</OPTION>
</SELECT>
</TD></TR>
<TR><TD>
<INPUT TYPE=radio NAME="as" VALUE="1" CHECKED>All Orders<INPUT TYPE=radio NAME="as" VALUE="0">Autoship Only
</TD></TR>
<tr>
<TD CLASS="bblackfont">
Range1:<INPUT TYPE="Text" NAME="date1" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
<br>
Range2:<INPUT TYPE="Text" NAME="date2" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
</TD>
</tr>
<TR><TD>
<INPUT TYPE=radio NAME="samebillship" VALUE="all" CHECKED>All Orders<INPUT TYPE=radio NAME="samebillship" VALUE="yes">Shipping Matches Billing<INPUT TYPE=radio NAME="samebillship" VALUE="no">Shipping Doesn't Match Billing
</TD></TR>
<tr>
<td><br>
<INPUT TYPE="Submit" VALUE="Search" CLASS="button">
</form>
</td>
</tr>
</TABLE><br><br>

<cfif astatus is 1>

<b>Search for orders that purchased a specific product:</b>
<TABLE BORDER=1 CELLSPACING=0 CELLPADDING=0 COLS=2 WIDTH="100">
<TR><TD><form action="index.cfm?page=searchorders2&act=view" method="POST">
<SELECT NAME="status" SIZE=1>
<OPTION VALUE="0">NEW</OPTION>
<OPTION VALUE="1">CARD APPROVED</OPTION>
<OPTION VALUE="2">DECLINED</OPTION>
<OPTION VALUE="3">SHIPPED</OPTION>
<OPTION VALUE="4">BACKORDER</OPTION>
<OPTION VALUE="5">DELETED</OPTION>
<OPTION VALUE="6">DIFF BILL/SHIP</OPTION>
</SELECT>
</TD></TR>
<TR><TD>
<INPUT TYPE="TEXT" NAME="searchtext" SIZE="10" MAXLENGTH="10"></TD></TR>
<tr><td><INPUT TYPE=radio NAME="searchfor" VALUE="PID" CHECKED>PID</td></tr>
<TR><TD>
<INPUT TYPE="TEXT" NAME="thestate" SIZE="10" MAXLENGTH="10" VALUE="0"></TD></TR>
<tr><td><INPUT TYPE=radio NAME="thestateid" VALUE="STATEID" CHECKED>STATEID</td></tr>
<tr>
<TD CLASS="bblackfont">
Range1:<INPUT TYPE="Text" NAME="date1" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
<br>
Range2:<INPUT TYPE="Text" NAME="date2" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
<br>
PID or PackageID?<INPUT TYPE=radio NAME="pp" VALUE="PID" CHECKED>PID<INPUT TYPE=radio NAME="pp" VALUE="PackageID">PackaggeID
<br>
Display KW?<INPUT TYPE=radio NAME="kk" VALUE="1">Yes<INPUT TYPE=radio NAME="kk" VALUE="0" CHECKED>No
</TD>
</tr>
<tr>
<td><br>
<INPUT TYPE="Submit" VALUE="Search" CLASS="button">
</form>
</td>
</tr>
</TABLE><br><br>

<b>Search for autoship orders that need to be placed:</b>
<form action="index.cfm?page=searchas&act=view" method="POST">
<TABLE BORDER=1 CELLSPACING=0 CELLPADDING=0 COLS=2 WIDTH="100">
<TR><TD>
<SELECT NAME="AutoshipStatus" SIZE=1>
<OPTION VALUE="1">IS</OPTION>
<OPTION VALUE="2">WAS</OPTION>
</SELECT>
</TD></TR>
<tr>
<TD CLASS="bblackfont">
Chosen Date:<INPUT TYPE="Text" NAME="date" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
</TD>
</tr>
<tr>
<td><br>
<INPUT TYPE="Submit" VALUE="Search" CLASS="button">
</form>
</td>
</tr>
</TABLE><br><br>

<b>Search for orders that purchased within a specific subcategory and were shipped:</b>
<TABLE BORDER=1 CELLSPACING=0 CELLPADDING=0 COLS=2 WIDTH="100">
<TR><TD><form action="index.cfm?page=searchsub&act=view" method="POST">
<INPUT TYPE="TEXT" NAME="searchtext" SIZE="10" MAXLENGTH="10"></TD></TR>
<tr><td><INPUT TYPE=radio NAME="searchfor" VALUE="SCID" CHECKED>SCID</td></tr>
<tr>
<TD CLASS="bblackfont">
Range1:<INPUT TYPE="Text" NAME="date1" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
<br>
Range2:<INPUT TYPE="Text" NAME="date2" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
</TD>
</tr>
<tr>
<td><br>
<INPUT TYPE="Submit" VALUE="Search" CLASS="button">
</form>
</td>
</tr>
</TABLE><br><br>

<b>Total Profit for Time Period:</b>
<TABLE BORDER=1 CELLSPACING=0 CELLPADDING=0 COLS=2 WIDTH="100">
<form action="index.cfm?page=searchorders2x&act=view" method="POST">
<tr>
<td>
Range1:<INPUT TYPE="Text" NAME="date1" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
</td>
<td>
Range2:<INPUT TYPE="Text" NAME="date2" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
</td>
</tr>
<tr>
<td>
<INPUT TYPE="Submit" VALUE="Search" CLASS="button">
</form>
</td>
</tr>
</TABLE><br><br>

<b>Search for product opposite company paid for:</b>
<TABLE BORDER=1 CELLSPACING=0 CELLPADDING=0 COLS=2 WIDTH="100">
	<TR>
		<TD>
			<form action="index.cfm?page=searchorders3&act=view" method="POST">
		</TD>
	</TR>
	<tr>
		<TD CLASS="bblackfont">
			Range1:<INPUT TYPE="Text" NAME="date1" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
		</TD>
		<TD CLASS="bblackfont">
			Range2:<INPUT TYPE="Text" NAME="date2" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
		</TD>

	</tr>
	<tr>
		<td>
			<INPUT TYPE="Submit" VALUE="Search" CLASS="button">
			</form>
		</td>
	</tr>
</TABLE><br><br>

<b>Search for call center orders with a specific status:</b>
<form action="index.cfm?page=searchcallcenterorders&act=view" method="POST">
<TABLE BORDER=1 CELLSPACING=0 CELLPADDING=0 COLS=2 WIDTH="100">
<tr>
<TD CLASS="bblackfont">
Range1:<INPUT TYPE="Text" NAME="date1" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
<br>
Range2:<INPUT TYPE="Text" NAME="date2" <cfoutput>VALUE="#thisday#"</cfoutput> CLASS="button">
</TD>
</tr>
<tr>
<td><br>
<INPUT TYPE="Submit" VALUE="Search" CLASS="button">
</form>
</td>
</tr>
</TABLE><br><br>

</cfif>

