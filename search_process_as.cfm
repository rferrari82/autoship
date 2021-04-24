<!--- Start Content Template --->

<!--- This page calls itself using CFCASE / CFSWITCH. g Each CFCASE value can be
found by searching for 3 astericks [***].  This indicates the start of a CFCASE value --->

<cfif IsDefined("url.act")>
<cfset TemplateSwitch=url.act>
<cfswitch expression="#TemplateSwitch#">

<!--- *** Synopsis of Orders --->
<cfcase value="view">

<cfquery name="GetOrders" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT C.BillToName as BillToName, C.BillToAddress as BillToAddress, C.BillToCity as BillToCity, C.BillToPostalCode as BillToPostalCode, A.OrderID as OrderID, A.CustomerID as CustomerID,
A.TotalSub as TotalSub, A.TotalAmount as TotalAmount, A.TotalTax as TotalTax,
A.TotalShipping as TotalShipping, A.Status as Status, A.CouponSave as CouponSave, A.CreatedDate as CreatedDate, A.Autoship, A.Cycle
FROM OCCustomerCheckout C inner join OCOrders A
    on C.CustomerID = A.CustomerID
WHERE A.CustomerID IN (SELECT CustomerID FROM OCOrderCart WHERE Autoship = #Val(form.AutoshipStatus)#)
ORDER BY C.BillToName
</cfquery>

<cfif GetOrders.RecordCount GT 0>

<CENTER><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=3 COLS=9 WIDTH="96%">
<TR ALIGN=RIGHT>
<!---<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="5%" class="bblackfont">Delete?</TD>--->

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="10%" class="bblackfont">Order Status</TD>

<!---<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="25%" class="bblackfont">Customer Name &amp;ID</TD>--->
<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="25%" class="bblackfont">Customer Name &amp;Address</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="10%" class="bblackfont">Sub Total</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="10%" class="bblackfont">Tax Total</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="10%" class="bblackfont">Shipping Total</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="10%" class="bblackfont">Grand Total</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="10%" class="bblackfont">Date of Order</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="5%" class="bblackfont">AS Satus</TD>

<TD <cfoutput>BGCOLOR="#APPLICATION.SILVERTABLE1#"</cfoutput> WIDTH="6%" class="bblackfont">Cycle</TD>
</TR>


<cfset MyRow = 1>
<cflock name="Session.SessionID" timeout="5" type="READONLY">
<cfoutput query="GetOrders">

<cfset CreatedDate1 = CreatedDate>

<!-- Add the Cyle (30,60,90) to the Created Date -->
<cfset CREATEDDATEPLUS = DateAdd("d", Cycle, CreatedDate1)>

<!-- Get number of days difference between order date and requested date -->
<cfset MYDATEDIFFPLUS = DateDiff("d", DateFormat(CREATEDDATEPLUS, "yyyy-mm-dd"), form.date)>

<!-- CreatedDate: #CreatedDate# Input: #form.date# MYDATEDIFFPLUS #MYDATEDIFFPLUS# -->

<cfif MYDATEDIFFPLUS MOD #Val(Cycle)# IS 0 AND MYDATEDIFFPLUS GTE 0>

<cfif (MyRow MOD 2) IS 1>
<TR ALIGN=RIGHT>
<!---<TD class="bblackfont"><A HREF="index.cfm?page=orders&act=confirm&oid=#Val(OrderID)#">Delete?</A></TD>--->
<TD class="nblackfont"><cfif Status IS 0><span class="Status0">New!</span></cfif>
<cfif Status IS 1><span class="bblackfont">Card Approved - 1</span></cfif>
<cfif Status IS 8><span class="bblackfont">Card Approved - 8</span></cfif>
<cfif Status IS 2><span class="bredfont">Unauthorized Card</span></cfif>
<cfif Status IS 3><span class="bblackfont">Shipped</span></cfif>
<cfif Status IS 4><span class="bblackfont">Back Order</span></cfif>
<cfif Status IS 5><span class="bblackfont">Deleted</span></cfif>
<cfif Status IS 6><span class="bblackfont">Diff Bill/Ship</span></cfif></TD>

<!---<TD class="bblackfont">XXXXXX XXXXXX</TD>--->
<TD class="bblackfont"><A HREF="index.cfm?page=orders&act=details&cid=#Val(CustomerID)#&cd=#Trim(CreatedDate)#&oid=#Val(OrderID)#&st=#Val(Status)#">#Trim(BillToName)#-#Val(CustomerID)#</A></TD>

<TD VALIGN=TOP class="nblackfont">#DollarFormat(TotalSub)#
<br><cfif (CouponSave IS NOT 0) OR (CouponSave IS NOT 0.00)><span class="bredfont">(-#DollarFormat(CouponSave)#)</span></cfif></TD>

<TD class="nblackfont">#DollarFormat(TotalTax)#</TD>

<TD class="nblackfont">#DollarFormat(TotalShipping)#</TD>

<TD class="nblackfont">#DollarFormat(TotalAmount)#</TD>

<TD class="nblackfont">#Trim(CreatedDate)#</TD>

<TD class="nblackfont"><cfif Autoship IS 1><span class="bblackfont">IS</span></cfif><cfif Autoship IS 2><span class="bblackfont">WAS</span></cfif></TD>

<TD class="nblackfont">#Trim(Cycle)#</TD>

</TR>
<TR ALIGN=RIGHT>
<!---<TD></TD>
<TD class="nblackfont">XXXXXXXXXX<br>XXXXXX, XX XXXXX</TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD>--->

<!---<TD class="nblackfont">#Trim(BillToAddress)#<br>#Trim(BillToCity)#<br>#Trim(BillToPostalCode)#</TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD>--->
</TR>
<cfelse>
<TR ALIGN=RIGHT BGCOLOR="#APPLICATION.SILVERTABLE2#">
<!---<TD class="bblackfont"><A HREF="index.cfm?page=orders&act=confirm&oid=#Val(OrderID)#">Delete?</A></TD>--->

<TD class="nblackfont"><cfif Status IS 0><span class="Status0">New!</span></cfif>
<cfif Status IS 1><span class="bblackfont">Card Approved - 1</span></cfif>
<cfif Status IS 8><span class="bblackfont">Card Approved - 8</span></cfif>
<cfif Status IS 2><span class="bredfont">Unauthorized Card</span></cfif>
<cfif Status IS 3><span class="bblackfont">Shipped</span></cfif>
<cfif Status IS 4><span class="bblackfont">Back Order</span></cfif>
<cfif Status IS 5><span class="bblackfont">Deleted</span></cfif>
<cfif Status IS 6><span class="bblackfont">Diff Bill/Ship</span></cfif></TD>

<!---<TD class="bblackfont">XXXXXX XXXXXX</TD>--->
<TD class="bblackfont"><A HREF="index.cfm?page=orders&act=details&cid=#Val(CustomerID)#&cd=#Trim(CreatedDate)#&oid=#Val(OrderID)#&st=#Val(Status)#">#Trim(BillToName)#-#Val(CustomerID)#</A></TD>

<TD VALIGN=TOP class="nblackfont">#DollarFormat(TotalSub)#
<br><cfif (CouponSave IS NOT 0) OR (CouponSave IS NOT 0.00)><span class="bredfont">(-#DollarFormat(CouponSave)#)</span></cfif></TD>

<TD class="nblackfont">#DollarFormat(TotalTax)#</TD>

<TD class="nblackfont">#DollarFormat(TotalShipping)#</TD>

<TD class="nblackfont">#DollarFormat(TotalAmount)#</TD>

<TD class="nblackfont">#Trim(CreatedDate)#</TD>

<TD class="nblackfont"><cfif Autoship IS 1><span class="bblackfont">IS</span></cfif><cfif Autoship IS 2><span class="bblackfont">WAS</span></cfif></TD>

<TD class="nblackfont">#Trim(Cycle)#</TD>

</TR>
<TR ALIGN=RIGHT BGCOLOR="#APPLICATION.SILVERTABLE2#">
<!---<TD></TD>
<TD class="nblackfont">XXXXXXXXXX<br>XXXXXX, XX XXXXX</TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD>--->
<!---<TD class="nblackfont">#Trim(BillToAddress)#<br>#Trim(BillToCity)#<br>#Trim(BillToPostalCode)#</TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD>--->
</TR>
</cfif>
<cfset MyRow = MyRow + 1>

<cfelse>

</cfif>

</cfoutput>
</cflock>
</TABLE></CENTER>
<br>

<cfelse>
<br>
<center><b>Sorry, no orders match your criteria</b></center>
</cfif>
</cfcase>
</cfswitch>

<cfelse>
	<cflocation url="index.cfm?page=orders&act=view&missing=y" ADDTOKEN="No">
</cfif>
<!--- END CONTENT TEMPLATE --->