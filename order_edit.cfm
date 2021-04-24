<!--- Start Content Template --->

<!--- This page calls itself using CFCASE / CFSWITCH. g Each CFCASE value can be
found by searching for 3 astericks [***].  This indicates the start of a CFCASE value --->

<cfif IsDefined("url.act")>
<cfset TemplateSwitch=url.act>
<cfswitch expression="#TemplateSwitch#">

<!--- *** Synopsis of Orders --->
<cfcase value="view">

<cfif IsDefined("form.ShowStatus")>
<cfset currentStatus = #Val(form.ShowStatus)#>
<cfelse>
<cfset currentStatus = 7>
</cfif>

<cfif IsDefined("form.ShowStatus") AND form.ShowStatus is not 6 AND form.ShowStatus is not 7>
<!--- Retrieve All Orders According to Status--->
<cfquery name="GetOrders" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT *
FROM #APPLICATION.DBPRE#Orders
WHERE Status = #Val(form.ShowStatus)#
ORDER BY CreatedDate Desc, OrderID Desc
</CFQUERY>

<cfelseif IsDefined("url.sort")>
<!--- Retrieve All Orders For Customer --->
<cfquery name="GetOrders" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT *
FROM #APPLICATION.DBPRE#Orders
WHERE CustomerID = #Val(url.cid)#
ORDER BY CreatedDate Desc, OrderID Desc
</CFQUERY>

<cfelseif currentStatus is 7>

<cfset today = #DateFormat(Now(), "mm")#>

<!--- Current Month --->
<cfquery name="GetOrders" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT *
FROM #APPLICATION.DBPRE#Orders
WHERE CreatedDate >= '2003-#today#-01' AND Status = 0
ORDER BY CreatedDate Desc, OrderID Desc
</CFQUERY>

<cfelse>
<!--- Retrieve All Orders --->
<cfquery name="GetOrders" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT *
FROM #APPLICATION.DBPRE#Orders
ORDER BY CreatedDate Desc, Status
</CFQUERY>

</cfif>


<cfif GetOrders.RecordCount is not 0 AND currentStatus is 1>
<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=3 COLS=1 WIDTH="96%">
<TR><TD CLASS="bblackfont">
<a target="_blank" href="index.cfm?page=gennames&status=1">Generate Address Text File</a><br>
<a target="_blank" href="index.cfm?page=gennameprod&status=1">Generate Name &amp; Product
List</a>
</TD></TR>
</CENTER>
</cfif>

<cfif GetOrders.RecordCount is not 0 AND currentStatus is 8>
<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=3 COLS=1 WIDTH="96%">
<TR><TD CLASS="bblackfont">
<a target="_blank" href="index.cfm?page=gennames&status=8">Generate Address Text File</a><br>
<a target="_blank" href="index.cfm?page=gennameprod&status=8">Generate Name &amp; Product
List</a>
</TD></TR>
</CENTER>
</cfif>


<cflock name="Session.SessionID" timeout="5" type="READONLY">
<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=3 COLS=1 WIDTH="96%">
<TR>
<TD CLASS="bblackfont">There are <SPAN class="bredfont"><cfoutput>#GetOrders.RecordCount#</cfoutput></SPAN> Orders. | <SPAN class="bredfont">(-) = Discount Authorized</span>
<BR>Select Orders to Delete. Click on the link under "CustomerID" to Review Orders or Number to sort by Customer.
<br><A HREF="index.cfm?page=orders&act=view">Display All Orders</A>
</TD>

<TD CLASS="bblackfont">
<CFFORM ACTION="index.cfm?page=orders&act=view" METHOD="POST"><SELECT NAME="ShowStatus" SIZE=1>
<OPTION VALUE="0" <CFIF currentStatus is 0> SELECTED</CFIF>>New Order!</OPTION>
<OPTION VALUE="1" <CFIF currentStatus is 1> SELECTED</CFIF>>Card Approved - 1</OPTION>
<OPTION VALUE="8" <CFIF currentStatus is 8> SELECTED</CFIF>>Card Approved - 8</OPTION>
<!--<OPTION VALUE="2" <CFIF currentStatus is 2> SELECTED</CFIF>>Unauthorized Card</OPTION>--->
<!--<OPTION VALUE="3" <CFIF currentStatus is 3> SELECTED</CFIF>>Order Shipped</OPTION>-->
<OPTION VALUE="4" <CFIF currentStatus is 4> SELECTED</CFIF>>Back Order</OPTION>
<!--
<OPTION VALUE="5" <CFIF currentStatus is 5> SELECTED</CFIF>>Deleted</OPTION>
<OPTION VALUE="6" <CFIF currentStatus is 6> SELECTED</CFIF>>All Orders</OPTION>
<OPTION VALUE="7" <CFIF currentStatus is 7> SELECTED</CFIF>>Current Month</OPTION>
-->
</SELECT>
</TD>
<TD CLASS="bblackfont">
<INPUT TYPE="Submit" VALUE="Show by Status" CLASS="button"></TD></TR>
</CFFORM>
</TD

></TR>
</CENTER></TABLE>
</cflock>

<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=3 COLS=8 WIDTH="96%">
<TR ALIGN=RIGHT>
<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="5%" class="bblackfont">Delete?</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="11%" class="bblackfont">Order Status</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="25%" class="bblackfont">Customer Name &amp;ID</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="11%" class="bblackfont">Sub Total</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="11%" class="bblackfont">Tax Total</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="11%" class="bblackfont">Shipping Total</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="11%" class="bblackfont">Grand Total</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="11%" class="bblackfont">Date of Order</TD>
</TR>
<cflock name="Session.SessionID" timeout="5" type="READONLY">
	<cfoutput query="GetOrders">
<cfif (CurrentRow MOD 2) IS 1>
<!--- a row using first color --->

<!--- Retrieve Past Orders --->
<cfquery name="PastOrders" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT OrderID
FROM #APPLICATION.DBPRE#Orders
WHERE CustomerID = #Val(CustomerID)#
</cfquery>

<!--- Retrieve Billing Name --->
<cfquery name="BillingName" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT BillToName
FROM #APPLICATION.DBPRE#CustomerCheckout
WHERE CustomerID = #Val(CustomerID)#
</cfquery>

<TR ALIGN=RIGHT>
<TD class="bblackfont"><A HREF="index.cfm?page=orders&act=confirm&oid=#Val(OrderID)#">Delete?</A></TD>

<TD class="nblackfont"><cfif Status IS 0><span class="Status0">New!</span></cfif>
<cfif Status IS 1><span class="bblackfont">Card Approved - 1</span></cfif>
<cfif Status IS 8><span class="bblackfont">Card Approved - 8</span></cfif>
<cfif Status IS 2><span class="bredfont">Unauthorized Card</span></cfif>
<cfif Status IS 3><span class="bblackfont">Shipped</span></cfif>
<cfif Status IS 4><span class="bblackfont">Back Order</span></cfif>
<cfif Status IS 5><span class="bblackfont">Deleted</span></cfif>
<cfif Status IS 6><span class="bblackfont">Diff Bill/Ship</span></cfif>
</TD>

<TD class="bblackfont"><A HREF="index.cfm?page=orders&act=details&cid=#Val(CustomerID)#&cd=#Trim(CreatedDate)#&oid=#Val(OrderID)#&st=#Val(Status)#">#Trim(BillingName.BillToName)#-#Val(CustomerID)#</A>
<br><span class="nblackfont">Total Orders:</span> <span class="bblackfont"><A HREF="index.cfm?page=orders&act=view&sort=y&cid=#Val(CustomerID)#">#Val(PastOrders.RecordCount)#</A></span></TD>

<TD VALIGN=TOP class="nblackfont">#DollarFormat(TotalSub)#
<br><cfif (CouponSave IS NOT 0) OR (CouponSave IS NOT 0.00)><span class="bredfont">(-#DollarFormat(CouponSave)#)</span></cfif></TD>

<TD class="nblackfont">#DollarFormat(TotalTax)#</TD>

<TD class="nblackfont">#DollarFormat(TotalShipping)#</TD>

<TD class="nblackfont">#DollarFormat(TotalAmount)#</TD>

<TD class="nblackfont">#Trim(CreatedDate)#</TD>
</TR>
<cfelse>

<!--- a row using the second color --->

<!--- Retrieve Past Orders --->
<cfquery name="PastOrders" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT OrderID
FROM #APPLICATION.DBPRE#Orders
WHERE CustomerID = #Val(CustomerID)#
</cfquery>

<!--- Retrieve Billing Name --->
<cfquery name="BillingName" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT BillToName, SameBillShip
FROM #APPLICATION.DBPRE#CustomerCheckout
WHERE CustomerID = #Val(CustomerID)#
</cfquery>

<TR ALIGN=RIGHT BGCOLOR="#APPLICATION.SILVERTABLE2#">
<TD class="bblackfont"><A HREF="index.cfm?page=orders&act=confirm&oid=#Val(OrderID)#">Delete?</A></TD>

<TD class="nblackfont"><cfif Status IS 0><span class="Status0">New!</span></cfif>
<cfif Status IS 1><span class="bblackfont">Card Approved - 1</span></cfif>
<cfif Status IS 8><span class="bblackfont">Card Approved - 8</span></cfif>
<cfif Status IS 2><span class="bredfont">Unauthorized Card</span></cfif>
<cfif Status IS 3><span class="bblackfont">Shipped</span></cfif>
<cfif Status IS 4><span class="bblackfont">Back Order</span></cfif>
<cfif Status IS 5><span class="bblackfont">Deleted</span></cfif>
<cfif Status IS 6><span class="bblackfont">Diff Bill/Ship</span></cfif>
</TD>


<TD class="bblackfont"><A HREF="index.cfm?page=orders&act=details&cid=#Val(CustomerID)#&cd=#Trim(CreatedDate)#&oid=#Val(OrderID)#&st=#Val(Status)#">#Trim(BillingName.BillToName)#-#Val(CustomerID)#</A><cfif BillingName.SameBillShip is 'No'>*</cfif><cfif OOrderID GT 0>&##8224</cfif>
<br><span class="nblackfont">Total Orders:</span> <span class="bblackfont"><A HREF="index.cfm?page=orders&act=view&sort=y&cid=#Val(CustomerID)#">#Val(PastOrders.RecordCount)#</A></span></TD>

<TD VALIGN=TOP class="nblackfont">#DollarFormat(TotalSub)#
<br><cfif (CouponSave IS NOT 0) OR (CouponSave IS NOT 0.00)><span class="bredfont">(-#DollarFormat(CouponSave)#)</span></cfif></TD>

<TD class="nblackfont">#DollarFormat(TotalTax)#</TD>

<TD class="nblackfont">#DollarFormat(TotalShipping)#</TD>

<TD class="nblackfont">#DollarFormat(TotalAmount)#</TD>

<TD class="nblackfont">#Trim(CreatedDate)#</TD>
</TR>
</cfif>
</cfoutput>
</cflock>
</TABLE></CENTER>

<cfif IsDefined("url.sort")>
<!--- Retrieve Customer Totals --->
<cfquery name="ToDateTotals" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT Sum(TotalShipping) AS DateTotalShipping, Sum(TotalTax) AS DateTotalTax, Sum(TotalSub) AS DateTotalSub,
	   Sum(TotalAmount) AS DateTotalAmount
FROM #APPLICATION.DBPRE#Orders
WHERE CustomerID = #Val(url.cid)#
</cfquery>

<cfelse>

<!--- Retrieve Totals --->
<cfif IsDefined("form.ShowStatus") AND form.ShowStatus is not 6 AND form.ShowStatus is not 7>

<cfquery name="ToDateTotals" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT Sum(TotalShipping) AS DateTotalShipping, Sum(TotalTax) AS DateTotalTax, Sum(TotalSub) AS DateTotalSub,
	   Sum(TotalAmount) AS DateTotalAmount
FROM #APPLICATION.DBPRE#Orders
WHERE Status = #Val(form.ShowStatus)#
</cfquery>

<cfelseif currentStatus is 7>

<cfset today = #DateFormat(Now(), "mm")#>

<!--- Current Month --->
<cfquery name="ToDateTotals" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT Sum(TotalShipping) AS DateTotalShipping, Sum(TotalTax) AS DateTotalTax, Sum(TotalSub) AS DateTotalSub,
	   Sum(TotalAmount) AS DateTotalAmount
FROM #APPLICATION.DBPRE#Orders
WHERE CreatedDate >= '2003-#today#-01' AND Status = 0
</CFQUERY>


<cfelse>
<cfquery name="ToDateTotals" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT Sum(TotalShipping) AS DateTotalShipping, Sum(TotalTax) AS DateTotalTax, Sum(TotalSub) AS DateTotalSub,
	   Sum(TotalAmount) AS DateTotalAmount
FROM #APPLICATION.DBPRE#Orders
WHERE Status = 0
</cfquery>
</cfif>

</cfif>



<cflock name="Session.SessionID" timeout="5" type="READONLY">
	<cfoutput query="ToDateTotals">

<cfif astatus is 1>
<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=3 COLS=8 WIDTH="96%">
<TR ALIGN=RIGHT BGCOLOR="#APPLICATION.SILVERTABLE1#">
<TD WIDTH="5%" class="bblackfont">&nbsp;</TD>

<TD WIDTH="11%" class="bblackfont">To Date Totals:</TD>

<TD WIDTH="25%" class="bblackfont">---></TD>

<TD WIDTH="11%" class="bblackfont">#DollarFormat(DateTotalSub)#</TD>

<TD WIDTH="11%" class="bblackfont">#DollarFormat(DateTotalTax)#</TD>

<TD WIDTH="11%" class="bblackfont">#DollarFormat(DateTotalShipping)#</TD>

<TD WIDTH="11%" class="bblackfont">#DollarFormat(DateTotalAmount)#</TD>

<TD WIDTH="11%" class="bblackfont">&nbsp;</TD>
</TR>
</TABLE></CENTER>
</cfif>
</cfoutput>
</cflock>
</cfcase>

<!--- *** Details of Orders --->
<cfcase value="details">
<cflock name="Session.SessionID" timeout="5" type="READONLY">
	<cfif not IsDefined("url.cid")>
		<cfif IsDefined("url.oid")>
			<!--- Get Customer ID --->
			<CFQUERY NAME="GetCID" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
			SELECT CustomerID, CreatedDate, Status
			FROM #APPLICATION.DBPRE#Orders
			WHERE OrderID = #Val(url.oid)#
			</CFQUERY>
			<cfif GetCID.RecordCount is 0>
				<cflocation url="index.cfm?page=orders&act=view&missing=y" ADDTOKEN="No">
			</cfif>

		<cfelse>
			<cflocation url="index.cfm?page=orders&act=view&missing=y" ADDTOKEN="No">
		</cfif>
	</cfif>
</cflock>

<cfif IsDefined("url.cid")>
	<cflock name="Session.SessionID" timeout="5" type="EXCLUSIVE">
		<cfset CustomerID = url.cid>
		<cfset CreatedDate = url.cd>
		<cfset Status = url.st>
	</cflock>
<cfelse>
	<cflock name="Session.SessionID" timeout="5" type="EXCLUSIVE">
		<cfset CustomerID = #GetCID.CustomerID#>
		<cfset CreatedDate = #GetCID.CreatedDate#>
		<cfset Status = #GetCID.Status#>
	</cflock>
</cfif>

<!--- GET CUSTOMER BILLING INFORMATION --->

<CFQUERY NAME="CustomerOrder" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT *
FROM #APPLICATION.DBPRE#CustomerCheckout
WHERE CustomerID = #Val(CustomerID)#
</CFQUERY>

<!--- GET SHIPTOSTATE NAME --->
<cfquery name="ShipStateName" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT StateName, StateAbbrev
FROM USStates
WHERE StateID = #Val(CustomerOrder.ShiptoStateID)#
</CFQUERY>

<!--- GET SHIPTOCOUNTRY NAME --->
<cfquery name="ShipCountryName" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT CountryName
FROM UNCountries
WHERE CountryID = #Val(CustomerOrder.ShiptoCountryID)#
</CFQUERY>

<!--- GET BILLTOSTATE NAME --->
<cfquery name="BillStateName" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT StateName
FROM USStates
WHERE StateID = #Val(CustomerOrder.BilltoStateID)#
</CFQUERY>

<!--- GET BILLTOCOUNTRY NAME --->
<cfquery name="BillCountryName" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT CountryName
FROM UNCountries
WHERE CountryID = #Val(CustomerOrder.BilltoCountryID)#
</CFQUERY>

<cflock name="Session.SessionID" timeout="5" type="ReadOnly">
	<CFOUTPUT QUERY ="CustomerOrder">
	<cfset ShippingType = #ShippingType#>

<CFQUERY NAME="MyCost" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
	SELECT TotalCost, ProcessedBy, TotalAmount, Autoship, Cycle, OOrderID, ShopIDList, ASDiscount
	FROM #APPLICATION.DBPRE#Orders
	WHERE OrderID = #Val(url.oid)#
</CFQUERY>

<cfquery name="GetCustomerID" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT CustomerID
FROM #APPLICATION.DBPRE#OrderCart
WHERE ShoppingCartID IN (0#MyCost.ShopIDList#)
</CFQUERY>

<CFQUERY Name="GetShopCartItems" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
   SELECT PID, Quantity, PackageID, SKUName
   FROM #APPLICATION.DBPRE#OrderCart
   WHERE CustomerID = #Val(GetCustomerID.CustomerID)#
</CFQUERY>

<cfset runningtotal = 0>
<cfset pounds = 0>
<cfset ounces = 0>

<cftry>

<cfloop query="GetShopCartItems">

<CFQUERY Name="GetProduct" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
   SELECT UseMQ, ShipWeight, Box, BoxWeight
   FROM #APPLICATION.DBPRE#ProductList
   WHERE PID = #Val(GetShopCartItems.PID)#
</CFQUERY>

<cfif (GetShopCartItems.PackageID GT 0) AND (GetProduct.UseMQ IS 1)>

<CFQUERY Name="GetN1" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
   SELECT NuminPackage
   FROM ProductPackages
   WHERE ID = #Val(GetShopCartItems.PackageID)#
</CFQUERY>

<cfset runningtotal = runningtotal + ((GetProduct.ShipWeight) * GetN1.NuminPackage * GetShopCartItems.Quantity)>

<cfelseif (GetShopCartItems.PackageID GT 0) AND (GetProduct.UseMQ IS 0)>

<CFQUERY Name="GetWeight" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
   SELECT ShipWeight, Box, BoxWeight
   FROM ProductPackages
   WHERE ID = #Val(GetShopCartItems.PackageID)#
</CFQUERY>

<cfset runningtotal = runningtotal + ((GetWeight.ShipWeight) * GetShopCartItems.Quantity)>

<cfelse>


<cfset runningtotal = runningtotal + ((GetProduct.ShipWeight) * GetShopCartItems.Quantity)>

</cfif>

</cfloop>

<cfset pounds = runningtotal \ 16>
<cfset ounces = runningtotal % 16>
<cfcatch>

</cfcatch>
</cftry>



<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=2 COLS=1 WIDTH="600" BGCOLOR="#APPLICATION.WHITETABLE#">
<TR BGCOLOR="#APPLICATION.SILVERTABLE1#">
<TD ALIGN=CENTER CLASS="bblackfont">&raquo;&nbsp;<A HREF="javascript:winopen('print_order.cfm?cid=#Val(CustomerID)#&cd=#Trim(CreatedDate)#&oid=#Val(url.oid)#&st=#Val(Status)#','print','height=500,width=700,scrollbars=yes,resize=no')"><IMG SRC="../images/buttn-print.gif" BORDER=0 ALT="Print">&nbsp;Click Here To Print Order.</A></TD>
</TR>
<TR>
<TD ALIGN=CENTER CLASS="bblackfont">Order: #Val(url.oid)#</TD>
</TR>
<cfif astatus is 1>
<TR>
<TD ALIGN=CENTER CLASS="bblackfont">Cost: $#NumberFormat(MyCost.TotalCost, "(999999.99)")#</TD>
</TR>
</cfif>
<cfif runningtotal GT 0>
<TR>
<TD ALIGN=CENTER CLASS="bblackfont">Weight: <cfif pounds GT 0>#pounds# lb </cfif>#ounces# oz</TD>
</TR>
</cfif>
<TR>
<TD ALIGN=CENTER CLASS="bblackfont">Processed By: #MyCost.ProcessedBy#</TD>
</TR>
<cfif (ShiptoStateID IS 32 OR BilltoStateID IS 32) OR (Left(ShipToPostalCode,5) GT "07001" AND Left(ShipToPostalCode,5) LT "08990") OR (Left(BillToPostalCode,5) GT "07001" AND Left(BillToPostalCode,5) LT "08990")>
<TR>
<TD ALIGN=CENTER><strong><font color="FF0000">REQUIRES VERIFICATION: DO NOT PROCESS</font></strong></TD>
</TR>
</cfif>
<TR>
<TD ALIGN=CENTER CLASS="bblackfont"><a href="../index.cfm?frm=scartmanaged&amp;act=new&amp;oid=#Val(url.oid)#&amp;jxy42=1&dupecid=#Val(session.CFID)#&mycid=#Val(CustomerID)#&SalesPerson=#Trim(session.LogAdmin.AdminName)#<cfif MyCost.AutoShip IS 1>&isas=1</cfif>" target="_blank">Dupe this Order</a></TD>
</TR>
</TABLE></CENTER>
<BR>
<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=3 COLS=3 WIDTH="498">
<TR>
<TD WIDTH="166" CLASS="bblackfont"><A HREF="index.cfm?page=editinfo&cid=#Val(CustomerID)#&oid=#Val(url.oid)#&act=view" target="_blank">Ship To:</a></TD>

<TD WIDTH="166" CLASS="bblackfont"><A HREF="index.cfm?page=editinfo&cid=#Val(CustomerID)#&oid=#Val(url.oid)#&act=view" target="_blank">Bill To:</a></TD>

<TD WIDTH="166" CLASS="bblackfont"><A HREF="index.cfm?page=editinfo&cid=#Val(CustomerID)#&oid=#Val(url.oid)#&act=view" target="_blank">Payment By:</TD>
</TR>

<TR>
<TD CLASS="nblackfont">
	<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 COLS=1 WIDTH="99%">
	<TR>
	<TD class="nblackfont">#Trim(ShipToCompany)#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#Trim(ShipToName)#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#Trim(ShipToAddress)#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#Trim(ShipToAddress2)#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#Trim(ShipToCity)#, #Trim(ShipStateName.StateAbbrev)#&nbsp; #ReReplace(UCase(Trim(ShipToPostalCode)), "[[:space:]]","","ALL")#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#Trim(ShipCountryName.CountryName)#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#ReReplace(UCase(Trim(ShipToPhone)), "[[:space:]]","","ALL")#</TD>
	</TR>

	<TR>
	<TD class="bblackfont"><A HREF="mailto:#Trim(ShipToEmail)#">#Trim(ShipToEmail)#</A></TD>
	</TR>
	</TABLE>
</TD>

<TD CLASS="nblackfont">
	<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 COLS=1 WIDTH="99%">
	<TR>
	<TD class="nblackfont">#Trim(BillToCompany)#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#Trim(BillToName)#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#Trim(BillToAddress)#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#Trim(BillToAddress2)#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#Trim(BillToCity)#, #Trim(BillStateName.StateName)#&nbsp; #ReReplace(UCase(Trim(BillToPostalCode)), "[[:space:]]","","ALL")#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#Trim(BillCountryName.CountryName)#</TD>
	</TR>

	<TR>
	<TD class="nblackfont">#ReReplace(UCase(Trim(BillToPhone)), "[[:space:]]","","ALL")#</TD>
	</TR>

	<TR>
	<TD class="bblackfont"><A HREF="mailto:#Trim(BillToEmail)#">#Trim(BillToEmail)#</A></TD>
	</TR>
	</TABLE>
</TD>

<!--- Show the Order Cart --->

<cfquery name="OrderCartIDs" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT TotalShipping, ShopIDList, CouponSave, PMaterials
FROM #APPLICATION.DBPRE#Orders
WHERE OrderID = #Val(url.oid)#
</CFQUERY>

<cfquery name="ShowCart" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT *
FROM #APPLICATION.DBPRE#OrderCart
WHERE ShoppingCartID IN (0#OrderCartIDs.ShopIDList#)
</CFQUERY>

<cfset sex = 0>

<cfloop query="ShowCart">
<cfset yo = ShowCart.PID>
<cfquery name="GetSex" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT *
FROM #APPLICATION.DBPRE#ProductList
WHERE PID = #Val(yo)#
</CFQUERY>


<cfif GetSex.CategoryID IS 14>
<cfset sex = 1>
</cfif>
</cfloop>


<!--- DETERMINE PRODUCT TOTAL --->

<CFQUERY Name="GetTotal" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT SUM(Tax) AS TaxTotal, SUM(Price) AS TheTotal
FROM #APPLICATION.DBPRE#OrderCart
WHERE ShoppingCartID IN (0#OrderCartIDs.ShopIDList#)
</CFQUERY>

<cfif IsDefined("CouponPrice")>
	<cfset GrandTotal = #Trim(NumberFormat(CouponPrice, "(999999.99)"))# + #Trim(NumberFormat(OrderCartIDs.TotalShipping, "(999999.99)"))# + #Trim(NumberFormat(GetTotal.TaxTotal, "(999999.99)"))#>
<cfelse>
	<cfset GrandTotal = #Trim(NumberFormat(GetTotal.TheTotal, "(999999.99)"))# + #Trim(NumberFormat(OrderCartIDs.TotalShipping, "(999999.99)"))# + #Trim(NumberFormat(GetTotal.TaxTotal, "(999999.99)"))#>
</cfif>

<TD VALIGN=TOP CLASS="nblackfont">
Order Date: <span class="bredfont">#Trim(CreatedDate)#</span>
<BR><A HREF="index.cfm?page=processcc&cid=#Val(CustomerID)#&oid=#Val(url.oid)#&act=view&amount=#Val(MyCost.TotalAmount)#" target="_blank">CustomerID:</a> <span class="bredfont">#Val(CustomerID)#</span>
</TD>
</TR>
</TABLE></CENTER>
<BR>

<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=3 COLS=1 WIDTH="540">
<TR>
<TD CLASS="bblackfont">Shipping Type:</TD>
</TR>

<TR>
<TD CLASS="bredfont">#Trim(ShippingType)#:<BR><SPAN CLASS="nblackfont">Match Total Shipping Price (below) with the price above to determine the type of shipping. <BR>R=Regular | 2D=2 Day | ND= Next Day</SPAN></TD>
</TR>
</TABLE></CENTER>

<BR>
<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=3 COLS=1 WIDTH="540">
<TR>
<TD CLASS="bblackfont">Comments:</TD>
</TR>

<TR>
<TD CLASS="nblackfont"><cfif Len(Comments) IS 0>No Comments Provided<cfelse>#Comments#</cfif></TD>
</TR>

<cfif MyCost.OOrderID GT 0>
<TR>
<TD COLSPAN="3" CLASS="nblackfont"><span class="bredfont">GENERATED FROM AUTOSHIP - <a href="index.cfm?page=orders&act=details&oid=#Val(MyCost.OOrderID)#">#Val(MyCost.OOrderID)#</a></span></TD>
</TR>
</cfif>

<cfif MyCost.AutoShip IS 1 OR MyCost.AutoShip IS 2>
<TR>
<TD COLSPAN="3" CLASS="nblackfont"><span class="bredfont">THIS <cfif MyCost.AutoShip IS 1>IS<cfelseif MyCost.AutoShip IS 2>WAS</cfif> AN AUTOSHIP ORDER (WITH DISCOUNT OF #MyCost.ASDiscount#%), CYCLE: #Val(MyCost.Cycle)#</span> <br><FORM ACTION="index.cfm?page=orders&act=autoshipc" METHOD="post"><b>CHANGE CYCLE:</b> <input type="text" size="5" maxsize="5" name="mycycle" id="mycycle" /><INPUT TYPE="hidden" NAME="oid" VALUE="#Val(url.oid)#"><br><INPUT TYPE="SUBMIT" VALUE="UPDATE CYCLE" CLASS="button"></form></TD>
</TR>
<TR>
<TD COLSPAN="3" CLASS="bwhitefont">AutoShip Status:&nbsp; <span class="whitefont">to change autoship status&raquo; make selection&raquo; update status</span>
<FORM ACTION="index.cfm?page=orders&act=autoship" METHOD="post">
<SELECT NAME="AStatus" SIZE="1">
<OPTION SIZE="20" VALUE="2"<cfif MyCost.AutoShip IS "1">selected</cfif>>CANCEL AUTOSHIP</OPTION>
<OPTION SIZE="20" VALUE="1"<cfif MyCost.AutoShip IS "2">selected</cfif>>RESUME AUTOSHIP</OPTION>
</SELECT>
&nbsp;
<INPUT TYPE="hidden" NAME="oid" VALUE="#Val(url.oid)#"><br>
<INPUT TYPE="SUBMIT" VALUE="UPDATE AUTOSHIP STATUS" CLASS="button">
</FORM>
</TD>
</TR>
</cfif>

<cfif sex is 1 AND (CustomerOrder.ShiptoStateID IS 34 OR CustomerOrder.BilltoStateID IS 34)>
<TR>
<TD ALIGN=CENTER><strong><font color="FF0000">REQUIRES VERIFICATION: DO NOT PROCESS</font></strong></TD>
</TR>
</cfif>
</TABLE></CENTER>

<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=3 COLS=1 WIDTH="540">
<TR>
<TD CLASS="bblackfont">Order Status:</TD>
</TR>


<!--- Retrieve Tracking Number --->
<cfquery name="TrackingNumber" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT TNUM, IP, CTime, KW, SalesPerson
FROM #APPLICATION.DBPRE#Orders
WHERE OrderID = #Val(url.oid)#
</cfquery>

<TR><TD CLASS="nblackfont"><CFFORM ACTION="index.cfm?page=status&act=status"><SELECT NAME="Status" SIZE=1>
<OPTION VALUE="0"<cfif Status IS "0">selected</cfif>>New Order!</OPTION>
<OPTION VALUE="1"<cfif Status IS "1">selected</cfif>>Card Approved - 1</OPTION>
<OPTION VALUE="8"<cfif Status IS "8">selected</cfif>>Card Approved - 8</OPTION>
<OPTION VALUE="2"<cfif Status IS "2">selected</cfif>>Unauthorized Card</OPTION>
<OPTION VALUE="3"<cfif Status IS "3">selected</cfif>>Order Shipped</OPTION>
<OPTION VALUE="4"<cfif Status IS "4">selected</cfif>>Back Order</OPTION>
<OPTION VALUE="5"<cfif Status IS "5">selected</cfif>>Deleted</OPTION>
<OPTION VALUE="6"<cfif Status IS "6">selected</cfif>>Diff Bill/Ship</OPTION>
</SELECT></TD></TR>

<TR>
<TD CLASS="bblackfont">Update Inventory?</TD>
</TR>
<TR>
<TD CLASS="bblackfont"><INPUT TYPE="radio" NAME="updatei" VALUE="1" checked>Yes&nbsp;|&nbsp;<INPUT TYPE="radio" NAME="updatei" VALUE="0">No</TD>
</TR>

<TR><TD CLASS="bblackfont">
Back Order Time:<br><INPUT TYPE="text" NAME="backordertime" SIZE="25" MAXLENGTH="25" VALUE="3-4 Days"><br>
Tracking Number:<br><INPUT TYPE="text" NAME="trkngnum" SIZE="25" MAXLENGTH="25" VALUE="#TrackingNumber.TNUM#"><br>
<INPUT TYPE=radio NAME="shiptype" VALUE="ups" CHECKED>ups <INPUT TYPE=radio NAME="shiptype" VALUE="usps">usps
<INPUT TYPE="hidden" NAME="cid" VALUE="#Val(CustomerID)#">
<INPUT TYPE="hidden" NAME="oid" VALUE="#Val(url.oid)#"><br>
<INPUT TYPE="Submit" VALUE="Update" CLASS="button">
</cfform></TD></TR>
</TABLE></CENTER>
</cfoutput>
</cflock>

<CENTER><TABLE BORDER=0 CELLSPACING=1 CELLPADDING=3 COLS=5 WIDTH="185">
<TR <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput>>
<TD WIDTH="70" class="bblackfont">IP</TD>

<TD WIDTH="40" class="bblackfont">Time</TD>

<cfif astatus is 1><TD WIDTH="75" class="bblackfont">KW</TD></cfif>
<TD WIDTH="40" class="bblackfont">SalesPerson</TD>
</TR>

<cfoutput>
<TR>
<TD><cfif IsDefined("TrackingNumber.IP")>#TrackingNumber.IP#</cfif></TD>
<TD>#TrackingNumber.CTime#</TD>
<cfif astatus is 1><TD>#TrackingNumber.KW#</TD></cfif>
<TD align="center">#TrackingNumber.SalesPerson#</TD>
</TR>
</TABLE>
</CENTER>
</cfoutput>

<!---

<CFOBJECT TYPE="COM" ACTION="Create" CLASS="GeoIPCOMEx.GeoIPEx" NAME="geoip">
<CFSCRIPT>
    hostname = TrackingNumber.IP;
	geoip.set_db_path("D:\Websites\GetFastShipping\quick2you\#APPLICATION.SUBFOLDER1#\GeoIPFeb11\");
	geoip.find_by_name(hostname);
	city1 = geoip.city;
	country1 = geoip.country_name;
	region1 = geoip.region;
</CFSCRIPT>

--->

<cftry>
<cfhttp url="http://geoip.maxmind.com/f?l=G6MzZv960vPF&i=#TrackingNumber.IP#" timeout="2" throwOnError="yes">
<cfset country1 = #trim(listGetAt(CFHTTP.FileContent, 1, ","))#>
<cfset region1 = #trim(listGetAt(CFHTTP.FileContent, 2, ","))#>
<cfset city1 = #trim(listGetAt(CFHTTP.FileContent, 3, ","))#>
<cfcatch>
<cfset country1 = "NA">
<cfset city1 = "NA">
<cfset region1 = "NA">
</cfcatch>

</cftry>

<CENTER><TABLE BORDER=0 CELLSPACING=1 CELLPADDING=3 COLS=3 WIDTH="275">
<TR <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput>>
<TD class="bblackfont" width="100">Country</TD>
<TD class="bblackfont" width="100">City</TD>
<TD class="bblackfont" width="100">Region</TD>
</TR>

<cfoutput>
<TR>
<TD width="100">#country1#</TD>
<TD width="100">#city1#</TD>
<TD width="100">#region1#</TD>
</TR>
</TABLE>
</CENTER>
</cfoutput>



<HR SIZE="1" WIDTH="540">

<CENTER><TABLE BORDER=0 CELLSPACING=1 CELLPADDING=3 COLS=5 WIDTH="600">
<TR <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput>>
<TD WIDTH="50" class="bblackfont">Item No.</TD>

<TD WIDTH="330" class="bblackfont">Product Name</TD>

<TD WIDTH="40" class="bblackfont">QTY</TD>

<TD WIDTH="90" class="bblackfont">TAX</TD>

<TD WIDTH="90" class="bblackfont">Price</TD>
</TR>

<cflock name="Session.SessionID" timeout="5" type="READONLY">
	<cfoutput query="ShowCart">

	<cfset str = 0>
	<cfquery name="GetItem" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
	Select UseMQ, MasterQuantity, Location
	From #APPLICATION.DBPRE#ProductList
	Where PID = #Val(PID)#
 	</cfquery>

 	<cfif GetItem.RecordCount GT 0>
		<!-- CASE ONE NOT USING MQ -->
		<cfif GetItem.UseMQ IS 0>
		 <cfquery name="GetNumberItems" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
		 Select NuminPackage, QQ
		 From ProductPackages
		 Where ID = #ShowCart.PackageID#
		 </cfquery>
		<cfset str = GetNumberItems.QQ>
		<!-- USING MQ -->
		 <cfelse>
		 <cfset str = GetItem.MasterQuantity>
		 </cfif>
	</cfif>

<cfif (CurrentRow MOD 2) IS 1>
<!--- a row using first color --->
<TR>
<TD class="nblackfont"><cfif astatus is 1><A HREF="index.cfm?page=updatecart&scartid=#Val(ShowCart.ShoppingCartID)#&act=view" target="_blank">#CurrentRow#.</a></cfif></TD>
<TD class="bblackfont"><A target="_blank" HREF="../index.cfm?frm=details&piid=#Val(PID)#">#Trim(SKUName)#</A> - #str#<cftry> - #Trim(GetItem.Location)#<cfcatch></cfcatch></cftry>
<br><span class="nblackfont">Product ID: #Trim(SKU)#
<cfset prods[#CurrentRow#] = #Trim(SKU)#>
<br><cfif Len(Feature1) GT 0>Feature1: #Trim(Feature1)#<br></cfif>
<cfif Len(Feature2) GT 0>Feature2: #Trim(Feature2)#<br></cfif>
<cfif Len(Feature3) GT 0>Feature3: #Trim(Feature3)#<br></cfif>
<cfif Len(Feature4) GT 0>Feature4: #Trim(Feature4)#<br></cfif>
<cfif Len(Feature5) GT 0>Feature5: #Trim(Feature5)#<br></cfif></span>
</TD>

<TD class="nblackfont">#Val(Quantity)#</TD>

<TD ALIGN=RIGHT WIDTH="40" class="nblackfont">#DollarFormat(Tax)#</TD>

<TD ALIGN=RIGHT class="nblackfont">#DollarFormat(Price)#</TD>
</TR>

<cfelse>

<!--- a row using the second color --->

<TR BGCOLOR="#APPLICATION.SILVERTABLE2#">
<TD class="nblackfont"><cfif astatus is 1><A HREF="index.cfm?page=updatecart&scartid=#Val(ShowCart.ShoppingCartID)#&act=view" target="_blank">#CurrentRow#.</a></cfif></TD>

<TD class="bblackfont"><A target="_blank" HREF="../index.cfm?frm=details&piid=#Val(PID)#">#Trim(SKUName)#</A> - #str#<cftry> - #Trim(GetItem.Location)#<cfcatch></cfcatch></cftry>
<br><span class="nblackfont">Product ID: #Trim(SKU)#
<br><cfif Len(Feature1) GT 0>Feature1: #Trim(Feature1)#<br></cfif>
<cfif Len(Feature2) GT 0>Feature2: #Trim(Feature2)#<br></cfif>
<cfif Len(Feature3) GT 0>Feature3: #Trim(Feature3)#<br></cfif>
<cfif Len(Feature4) GT 0>Feature4: #Trim(Feature4)#<br></cfif>
<cfif Len(Feature5) GT 0>Feature5: #Trim(Feature5)#<br></cfif></span>
</TD>

<TD class="nblackfont">#Val(Quantity)#</TD>

<TD ALIGN=RIGHT class="nblackfont">#DollarFormat(Tax)#</TD>

<TD ALIGN=RIGHT class="nblackfont">#DollarFormat(Price)#</TD>
</TR>
</cfif>
</cfoutput>
</cflock>
</CENTER></TABLE>





<cflock name="Session.SessionID" timeout="5" type="READONLY">
<cfoutput>

<CENTER><TABLE BORDER=0 CELLSPACING=1 CELLPADDING=3 COLS=5 WIDTH="600">
<TR BGCOLOR="#APPLICATION.SILVERTABLE1#">
<TD WIDTH="50" class="nblackfont">&nbsp;</TD>

<TD ALIGN=RIGHT WIDTH="380" class="bblackfont">SUBTOTAL</TD>

<TD ALIGN=RIGHT WIDTH="40" class="bblackfont">--</TD>

<TD WIDTH="40" class="bblackfont">--&gt;</TD>

<TD ALIGN=RIGHT WIDTH="90" class="bblackfont">#DollarFormat(GetTotal.TheTotal)#</TD>
</TR>

<cfif (OrderCartIDs.CouponSave IS NOT 0) OR (OrderCartIDs.CouponSave IS NOT 0.00)>
<TR BGCOLOR="#APPLICATION.SILVERTABLE1#">
<TD class="nblackfont">&nbsp;</TD>

<TD ALIGN=RIGHT class="bblackfont">Coupon Savings</TD>

<TD ALIGN=RIGHT class="bblackfont">--</TD>

<TD class="bblackfont">--&gt;</TD>


<TD ALIGN=RIGHT class="bredfont">(-)&nbsp;#DollarFormat(OrderCartIDs.CouponSave)#</TD>
</TR>
<cfset CouponPrice = #Trim(NumberFormat(GetTotal.TheTotal, "(999999.99)"))# - #Trim(NumberFormat(OrderCartIDs.CouponSave, "(999999.99)"))#>
</cfif>

<TR BGCOLOR="#APPLICATION.SILVERTABLE1#">
<TD class="nblackfont">&nbsp;</TD>

<TD ALIGN=RIGHT class="bblackfont">Shipping &amp; Handling:</TD>

<TD ALIGN=RIGHT class="bblackfont">--</TD>

<TD class="bblackfont">--&gt;</TD>

<TD ALIGN=RIGHT class="bblackfont">#DollarFormat(OrderCartIDs.TotalShipping)#</TD>
</TR>

<TR BGCOLOR="#APPLICATION.SILVERTABLE1#">
<TD class="nblackfont">&nbsp;</TD>

<TD ALIGN=RIGHT class="bblackfont">Packaging Materials:</TD>

<TD ALIGN=RIGHT class="bblackfont">--</TD>

<TD class="bblackfont">--&gt;</TD>

<TD ALIGN=RIGHT class="bblackfont">#DollarFormat(OrderCartIDs.PMaterials)#</TD>
</TR>

<TR BGCOLOR="#APPLICATION.SILVERTABLE1#">
<TD class="nblackfont">&nbsp;</TD>

<TD ALIGN=RIGHT class="bblackfont">Tax Total:</TD>

<TD ALIGN=RIGHT class="bblackfont">--</TD>

<TD class="bblackfont">--&gt;</TD>

<TD ALIGN=RIGHT class="bblackfont">#DollarFormat(GetTotal.TaxTotal)#</TD>
</TR>


<TR BGCOLOR="#APPLICATION.SILVERTABLE1#">
<TD class="nblackfont">&nbsp;</TD>

<TD ALIGN=RIGHT class="bblackfont">GrandTotal</TD>

<TD ALIGN=RIGHT class="bblackfont">--</TD>

<TD class="bblackfont">--&gt;</TD>

<cfif IsDefined("CouponPrice")>
	<cfset GrandTotal = #Trim(NumberFormat(CouponPrice, "(999999.99)"))# + #Trim(NumberFormat(OrderCartIDs.TotalShipping, "(999999.99)"))# + #Trim(NumberFormat(GetTotal.TaxTotal, "(999999.99)"))# + #Trim(NumberFormat(OrderCartIDs.PMaterials, "(999999.99)"))#>
<cfelse>
	<cfset GrandTotal = #Trim(NumberFormat(GetTotal.TheTotal, "(999999.99)"))# + #Trim(NumberFormat(OrderCartIDs.TotalShipping, "(999999.99)"))# + #Trim(NumberFormat(GetTotal.TaxTotal, "(999999.99)"))# + #Trim(NumberFormat(OrderCartIDs.PMaterials, "(999999.99)"))#>
</cfif>
<TD ALIGN=RIGHT class="bblackfont">#DollarFormat(GrandTotal)#</TD>
</TR>

<TR BGCOLOR="#APPLICATION.SILVERTABLE1#">
<TD class="nblackfont">&nbsp;</TD>

<TD ALIGN=RIGHT class="bblackfont">Adjusted Total:</TD>

<TD ALIGN=RIGHT class="bblackfont">--</TD>

<TD class="bblackfont">--&gt;</TD>

<TD ALIGN=RIGHT class="bblackfont">#DollarFormat(MyCost.TotalAmount)#</TD>
</TR>

</TABLE></CENTER>
</cfoutput>
</cflock>
<hr>
<CFQUERY Name="GetComments" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT Date, Text, Who
FROM Comments
WHERE OrderNumber = #Val(url.oid)#
</CFQUERY>
<br>

<CFOUTPUT>
<SCRIPT LANGUAGE="Javascript">

function fillIn(obj)
{
	document.myform.theemail.value = obj.value;
}

function replaceIT()
{

  var first = document.myform.theemail.value;
  var second = "";
  var validchars = " ";
  var replacement = "<br>";
  var number = 0;

  for (var i=0; i < first.length; i++) {
    number = number + 1;
    var letter = first.charAt(i);
    if ((validchars.indexOf(letter) != -1) && (number > 60))
    {
      second = second + replacement;
      number = 0;
    }
    else
    {
       second = second + letter;

    }
  }
  document.myform.theemail.value = second;
}

function replaceIT2()
{

  var first = document.myform2.thecomments.value;
  var second = "";
  var validchars = " ";
  var replacement = "<br>";
  var number = 0;

  for (var i=0; i < first.length; i++) {
    number = number + 1;
    var letter = first.charAt(i);
    if ((validchars.indexOf(letter) != -1) && (number > 60))
    {
      second = second + replacement;
      number = 0;
    }
    else
    {
       second = second + letter;

    }
  }
  document.myform2.thecomments.value = second;
}




</SCRIPT>
</CFOUTPUT>

<CENTER><TABLE BORDER=1 CELLSPACING=0 CELLPADDING=3 COLS=8 WIDTH="600">
<TR>
<TD WIDTH="100" <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> class="bblackfont">Date & Time:</TD>
<TD WIDTH="500" <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> class="bblackfont">Comments About this order:</TD>
</TR>
<cfoutput query="GetComments">
<TR>
<TD WIDTH="100" VALIGN="TOP" class="bblackfontsmall">#Date#<BR>Eastern Standard<BR><b>User: #Who#</b></TD>
<TD WIDTH="500" VALIGN="TOP" class="bblackfontsmall">#ParagraphFormat(Text)#</TD>
</TR>
</cfoutput>
<TR>

<TD></TD>
<TD VALIGN="BOTTOM">
<TABLE>
<TR>
<TD WIDTH="500">

<CFFORM NAME="myform2" ACTION="index.cfm?page=orders&act=comments" METHOD="POST">
<TEXTAREA WRAP="Virtual" NAME="thecomments" ROWS="10" COLS="60"></TEXTAREA><INPUT NAME="fixit" TYPE="CHECKBOX" onClick="replaceIT2()">Clean Up Text

</TD></TR>
</TD>
</TR>
<TR>
<TD>
<INPUT TYPE="Submit" VALUE="Submit New Comment" CLASS="button">
<INPUT TYPE="Hidden" NAME="oid" <cfoutput>VALUE="#Val(url.oid)#"</cfoutput>>
</TD>
</TR>
</cfform>
</TABLE>
</TD>
</TR>
</TABLE>
</CENTER>
<br>
<hr>

<CFQUERY Name="GetEmails" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT Date, Text, Who
FROM Emails
WHERE OrderNumber = #Val(url.oid)#
</CFQUERY>

<br>
<br>

<CFQUERY Name="GetEmailContents" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT Name, Message
FROM EmailContents
</CFQUERY>





<CENTER><TABLE BORDER=1 CELLSPACING=0 CELLPADDING=3 COLS=8 WIDTH="600">
<TR>
<TD  WIDTH="100" <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> class="bblackfont">Date & Time:</TD>
<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> class="bblackfont">Emails sent to the customer about this order:</TD>
</TR>
<cfoutput query="GetEmails">
<TR>
<TD WIDTH="100" VALIGN="TOP" class="bblackfontsmall">#Date#<BR>Eastern Standard<BR><b>User: #Who#</b></TD>

<TD VALIGN="TOP" class="bblackfontsmall">#Text#</TD>
</TR>
</cfoutput>
<TR><TD></TD><TD>
<TABLE>
<CFFORM NAME="myform" ACTION="index.cfm?page=orders&act=email" METHOD="POST">
<TR><TD><SELECT NAME="emaillist" onChange="fillIn(this)">
<cfoutput query="GetEmailContents"><OPTION LABEL="#Name#" VALUE="#Message#">#GetEmailContents.Name#</OPTION></cfoutput>
</SELECT></TD></TR>
<TR>
<TD>
<TEXTAREA NAME="theemail" ROWS="10" COLS="60" WRAP="virtual"></TEXTAREA><br><INPUT NAME="fixit" TYPE="CHECKBOX" onClick="replaceIT()">Clean Up Text
</TD></TR>
<TR>
<TD>
<INPUT TYPE="Submit" VALUE="Send a new email to the customer" CLASS="button">
<INPUT TYPE="Hidden" NAME="oid" <cfoutput>VALUE="#Val(url.oid)#"</cfoutput>>
<INPUT TYPE="Hidden" NAME="emailaddress" <cfoutput>VALUE="#Trim(CustomerOrder.BillToEmail)#"</cfoutput>>
<INPUT TYPE="Hidden" NAME="name" <cfoutput>VALUE="#Trim(CustomerOrder.BillToName)#"</cfoutput>>
</TD>
</TR>
</cfform>
</TABLE>
</TD></TR>
</TABLE>
</CENTER>



</cfcase>


<cfcase value="comments">


<cfquery DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
		INSERT INTO Comments
		VALUES(#Val(form.oid)#, '#DateFormat(Now(),"mm-dd-yyyy")# <br> #TimeFormat(Now(), "H:mm:tt")#', '#form.thecomments#', '#Session.AdminName#')
</cfquery>

<cflocation url="index.cfm?page=orders&act=view&complete=y" ADDTOKEN="No">

</cfcase>

<cfcase value="email">

<cftry>

<cfquery name="GETCID" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT CustomerID
FROM #APPLICATION.DBPRE#Orders
Where OrderID = #Val(form.oid)#
</CFQUERY>

<cfquery name="GETSKUNAME" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT SKUName
FROM #APPLICATION.DBPRE#OrderCart
Where CustomerID = #Val(GETCID.CustomerID)#
</CFQUERY>

<cfset name1 = REReplace(GETSKUNAME.SKUName,",.*","","ALL")>
<cfset namex = REReplace(name1," - .*","","ALL")>
<cfset name2 = REReplace(namex," \(.*","","ALL")>

<cflock name="Session.SessionID" timeout="5" type="READONLY">
<CFMAIL TO="#form.emailaddress#"
CC="#APPLICATION.ADMINEMAIL#"
FROM="#APPLICATION.ALTEMAIL3#"
SUBJECT="#APPLICATION.COMPANYNAME# Information about your Recent #name2# Order" SERVER="#APPLICATION.EMAILSERVER#" USERNAME="#APPLICATION.EMAILUSERNAME#" PASSWORD="#APPLICATION.EMAILPW#" TYPE="HTML">

<PRE><P>
Dear #form.name#,

Regarding your recent order with us, order number #form.oid#:

#form.theemail#

Thank You,

#APPLICATION.COMPANYNAME#<br>
#APPLICATION.TELEPHONE1#

--------------------------

#APPLICATION.COMPANYURL#
</P></PRE>
</cfmail>

</cflock>
<cfcatch></cfcatch>
</cftry>

<cfquery DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
		INSERT INTO Emails
		VALUES(#Val(form.oid)#, '#DateFormat(Now(),"mm-dd-yyyy")# <br> #TimeFormat(Now(), "H:mm:tt")#', '#form.theemail#', '#Session.AdminName#')
</cfquery>


<cflocation url="index.cfm?page=orders&act=view&complete=y" ADDTOKEN="No">


</cfcase>

<!--- *** CHANGE AUTOSHIP STATUS --->
<cfcase value="autoship">
<cfparam name="show" default= "all">
<cfparam name="mid" default= "0">

<cfif Not IsDefined("form.oid")>
<cflock name="Session.SessionID" timeout="5" type="READONLY">
	<cfif not IsDefined("url.oid")>
		<cflocation url="index.cfm?page=orders&act=view&missing=y" ADDTOKEN="No">
	</cfif>
</cflock>
</cfif>

<!--- UPDATE --->
<cfquery datasource="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
	UPDATE #APPLICATION.DBPRE#Orders
	SET Autoship = #Val(form.AStatus)#
	WHERE OrderID = #Val(form.oid)#
</CFQUERY>

<cfset thestatus = "">

<cfif form.AStatus is 1>
<cfset thestatus = "RESUMED">
<cfelseif form.AStatus is 2>
<cfset thestatus = "CANCELLED">
</cfif>

<cfquery DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
		INSERT INTO Comments
		VALUES(#Val(form.oid)#, '#DateFormat(Now(),"mm-dd-yyyy")# <br> #TimeFormat(Now(), "H:mm:tt")#', 'AUTOSHIP #thestatus#', '#Session.AdminName#')
</cfquery>

<cflock name="Session.SessionID" timeout="5" type="exclusive">
	<cflocation url="index.cfm?page=orders&act=view&complete=y" ADDTOKEN="No">
</cflock>

</cfcase>

<!--- *** CHANGE AUTOSHIP CYCLE --->
<cfcase value="autoshipc">
<cfparam name="show" default= "all">
<cfparam name="mid" default= "0">

<cfif Not IsDefined("form.oid")>
<cflock name="Session.SessionID" timeout="5" type="READONLY">
	<cfif not IsDefined("url.oid")>
		<cflocation url="index.cfm?page=orders&act=view&missing=y" ADDTOKEN="No">
	</cfif>
</cflock>
</cfif>

<cfif form.mycycle GT 0>

<!--- UPDATE --->
<cfquery datasource="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
	UPDATE #APPLICATION.DBPRE#Orders
	SET Cycle = #Val(form.mycycle)#
	WHERE OrderID = #Val(form.oid)#
</CFQUERY>

</cfif>

<cflock name="Session.SessionID" timeout="5" type="exclusive">
	<cflocation url="index.cfm?page=orders&act=view&complete=y" ADDTOKEN="No">
</cflock>

</cfcase>

<!--- *** CONFIRM DELETION OF SELECTED RECORDS --->
<cfcase value="confirm">
<cflock name="Session.SessionID" timeout="5" type="READONLY">
	<cfif not IsDefined("url.oid")>
		<cflocation url="index.cfm?page=orders&act=view&missing=y" ADDTOKEN="No">
	</cfif>
</cflock>

<cfquery name="confirm_orders" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT OrderID, CustomerID
FROM #APPLICATION.DBPRE#Orders
Where OrderID = #Val(url.oid)#
</CFQUERY>

<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=2 COLS=1 WIDTH="500">
<TR>
<TD CLASS="bredfont">Delete Confirmation</TD>
</TR>

<TR>
<TD CLASS="bblackfont">WARNING!
<p>You are about to delete the following Order(s) from the database:</p>

<cflock name="Session.SessionID" timeout="5" type="READONLY">
<cfoutput query="confirm_orders">
<p class="bredfont"><span class="bblackfont">OrderID</span>:#Val(OrderID)#, #Val(CustomerID)#</p>
</cfoutput>
</cflock>

<cflock name="Session.SessionID" timeout="5" type="READONLY">
<cfoutput>
<cfform action="index.cfm?page=orders&act=action">
<p class="bblackfont">Are you sure you want to do this?</p>

<INPUT TYPE="hidden" NAME="oid" VALUE="#Val(url.oid)#">
<INPUT TYPE="submit" VALUE="Delete" class="button">
<INPUT TYPE="Button" VALUE="Cancel" onclick="javascript:history.back()" class="button">
</cfform>
</cfoutput>
</cflock>
</TD>
</TR>
</TABLE></CENTER>
</cfcase>

<!--- *** NO TURNING BACK - SELECTED RECORDS ARE DELETED --->
<cfcase value="action">
<cfsetting enablecfoutputonly="yes">
<cflock name="Session.SessionID" timeout="5" type="READONLY">
	<cfif not IsDefined("form.oid")>
		<cflocation url="index.cfm?page=orders&act=view&missing=y" ADDTOKEN="No">
	</cfif>
</cflock>

<CFQUERY Name="GetIDs" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
   SELECT ShopIDList
   FROM #APPLICATION.DBPRE#Orders
   WHERE OrderID = #Val(form.oid)#
</CFQUERY>

<cfquery name="delete_order_cart" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
	DELETE
	FROM #APPLICATION.DBPRE#OrderCart
	Where ShoppingCartID IN (0#GetIDs.ShopIDList#)
</CFQUERY>

<cfquery name="delete_orders" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
	DELETE
	FROM #APPLICATION.DBPRE#Orders
	Where OrderID = #Val(form.oid)#
</CFQUERY>

	<cflocation url="index.cfm?page=orders&act=view&complete=y" ADDTOKEN="No">
<cfsetting enablecfoutputonly="no">
</cfcase>
</cfswitch>

<cfelse>
	<cflocation url="index.cfm?page=orders&act=view&missing=y" ADDTOKEN="No">
</cfif>
<!--- END CONTENT TEMPLATE --->