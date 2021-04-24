<!--- Start Template - SEARCH FOR Astericks [***] for each CFIF action --->

<cflock name="Session.SessionID" timeout="5" type="READONLY">
	<cfif not IsDefined("url.act")>
		<cflocation url="index.cfm?frm=shopcart&missing=y" ADDTOKEN="No">
	</cfif>
	<cfif not IsDefined("url.jxy42")>
		<cflocation url="index.cfm?frm=shopcart&missing=y" ADDTOKEN="No">
	</cfif>
	<cfif not IsDefined("url.dupecid")>
		<cflocation url="index.cfm?frm=shopcart&missing=y" ADDTOKEN="No">
	</cfif>
	<cfif not IsDefined("url.mycid")>
		<cflocation url="index.cfm?frm=shopcart&missing=y" ADDTOKEN="No">
	<cfelse>
		<cfset session.mycid = url.mycid>
		<cfif IsDefined("url.isas")>
		<cfset session.isas = url.isas>
		<cfset session.ooid = url.oid>
		</cfif>
	</cfif>
</cflock>

<!--- *** Add a New Product --->
<cfif act IS "new">
<cfsetting enablecfoutputonly="yes">

<!--- Get the Order Cart --->
<cfquery name="OrderCartIDs" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT TotalShipping, ShopIDList, CouponSave
FROM #APPLICATION.DBPRE#Orders
WHERE OrderID = #Val(url.oid)#
</CFQUERY>

<cfquery name="ShowCart" DATASOURCE="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
SELECT *
FROM #APPLICATION.DBPRE#OrderCart
WHERE ShoppingCartID IN (0#OrderCartIDs.ShopIDList#)
</CFQUERY>

<!--- Go through each product in the cart --->
<cfloop query="ShowCart">

	<CFQUERY NAME="GetProduct1" datasource="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
		SELECT SKUName, Package as P
		FROM OCProductList
		WHERE PID = #Val(ShowCart.PID)# AND Status = 1
	</CFQUERY>

	<cfif GetProduct1.SKUName contains "Replaced">
	<cflocation url="index.cfm?frm=details&piid=#ShowCart.PID#" ADDTOKEN="No">
	</cfif>

	<cfif (ShowCart.PackageID GT 0) AND (GetProduct1.P IS 0)>
		<cflocation url="index.cfm?frm=dupeerror" ADDTOKEN="No">
	</cfif>

	<cfif ShowCart.PackageID GT 0>
	<CFQUERY NAME="GetPackages" datasource="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
		SELECT A.ID as ID, A.PID as PID, A.Title as Title, A.Price as Price, A.Cost as Cost, A.Bonus as Bonus
		FROM ProductPackages A inner join OCProductList B
			on A.PID = B.PID
		WHERE A.ID = #Val(ShowCart.PackageID)# AND B.Status = 1
		ORDER BY Price
	</CFQUERY>

	<cfif GetPackages.RecordCount is 0>
	<cflocation url="index.cfm?frm=dupeerror" ADDTOKEN="No">
	</cfif>

	<CFSET stl = REFindNoCase(" - ",GetPackages.Title,1,"True")>

	<cflock name="Session.SessionID" timeout="5" type="exclusive">
		<cfset CustomerID = #Val(url.dupecid)#>
		<cfset PID = ShowCart.pid>
		<cfset SKUName = #Mid(GetPackages.Title,1,stl.pos[1])#>
		<cfset SKU = ShowCart.SKU>
		<cfset CreatedDate = "#DateFormat(Now(), "yyyy-mm-dd")#">
		<cfset Quantity = 1>
		<cfset PackageID = ShowCart.PackageID>
		<cfset Taxable = ShowCart.Taxable>
		<cfset Price = #NumberFormat(GetPackages.Price, "(999999.99)")#>
	</cflock>

	<cfif GetPackages.Price GT ShowCart.Price>
	<cfset flag = "true">
	</cfif>

	<cfelse>
	<CFQUERY NAME="GetProduct" datasource="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
		SELECT *
		FROM OCProductList
		WHERE PID = #Val(ShowCart.PID)# AND Status = 1
	</CFQUERY>

	<cfif GetProduct.RecordCount is 0>
		<cflocation url="index.cfm?frm=dupeerror" ADDTOKEN="No">
	</cfif>

	<cfif GetProduct.Package GT 0>
			<cflocation url="index.cfm?frm=dupeerror" ADDTOKEN="No">
	</cfif>

	<cflock name="Session.SessionID" timeout="5" type="exclusive">
		<cfset CustomerID = #Val(url.dupecid)#>
		<cfset PID = ShowCart.pid>
		<cfset SKUName = GetProduct.SKUName>
		<cfset SKU = GetProduct.SKU>
		<cfset CreatedDate = "#DateFormat(Now(), "yyyy-mm-dd")#">
		<cfset Quantity = 1>
		<cfset PackageID = 0>
		<cfset Taxable = GetProduct.Taxable>
		<cfset Price = #NumberFormat(GetProduct.Price, "(999999.99)")#>
	</cflock>

	<cfif GetProduct.Price GT ShowCart.Price>
	<cfset flag = "true">
	</cfif>
	</cfif>



	<cfquery name="CheckIfThere" datasource="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
	SELECT PID, Quantity
	FROM #APPLICATION.DBPRE#ShopCart
	WHERE CustomerID = #Val(url.dupecid)#
	AND PID = #Val(PID)# <cfif ShowCart.PackageID GT 0> AND SKUName = '#Mid(GetPackages.Title,1,stl.pos[1])#' </cfif>
	</cfquery>

	<!--- *153 If Already In Shopping Cart --->
	<cfif CheckIfThere.RecordCount IS NOT 0>

	<!--- RETRIEVE ORIGINAL PRODUCT PRICE --->
	<cfquery name="ActualPrice" datasource="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
	SELECT Price, Discount, Package
	FROM #APPLICATION.DBPRE#ProductList
	WHERE PID = #Val(PID)#
	</cfquery>

	<!--- Calculate Cost --->
	<cflock name="Session.SessionID" timeout="5" type="ReadOnly">
	<cfif ActualPrice.Package GT 0>
	<cfset RegPrice = #Val(Price)#>
	<cfelse>
	<cfset RegPrice = #ActualPrice.Price#>
	</cfif>
	<cfset Discount = #ActualPrice.Discount#>
	<cfset Sale_Price = #RegPrice# * #APPLICATION.DISCOUNT#>
	</cflock>

	<cflock name="Session.SessionID" timeout="5" type="ReadOnly">
	<CFSET NewQuantity = CheckIfThere.Quantity + 1>
		<CFSET NewPriceTemp = #NumberFormat(Sale_Price, "(999999.99)")# * #NewQuantity#>
		<CFIF #NewQuantity# greater than 1>
			<CFSET NewPrice = #NewPriceTemp# - (#NewQuantity# * #Discount#)>
		<CFELSE>
			<CFSET NewPrice = #NewPriceTemp#>
		</CFIF>
	</cflock>

	<cfquery name = "PutItThere" datasource="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
	UPDATE #APPLICATION.DBPRE#ShopCart
	SET Quantity = #Val(NewQuantity)#,
    CreatedDate = '#DateFormat(Now(), "yyyy-mm-dd")#',
	Price = #NewPrice#
	WHERE CustomerID = #Val(url.dupecid)#
	AND PID = #Val(PID)# <cfif ShowCart.PackageID GT 0> AND SKUName = '#Mid(GetPackages.Title,1,stl.pos[1])#' </cfif>
	</CFQUERY>--->

	<cfoutput>
	#url.mycid#, #url.dupecid#, #Val(PID)#, #Trim(SKUName)#, #Trim(SKU)#, #Val(Quantity)#, #Price#, #PackageID#, #Trim(CreatedDate)#, #Val(Taxable)#, #Feature1#, #Feature2#, #Feature3#, #Feature4#, #Feature5#
	</cfoutput>

	<!--- If NOT Already In Shopping Cart --->
	<cfelse>

	<CFPARAM NAME="Feature1" DEFAULT="">
	<CFPARAM NAME="Feature2" DEFAULT="">
	<CFPARAM NAME="Feature3" DEFAULT="">
	<CFPARAM NAME="Feature4" DEFAULT="">
	<CFPARAM NAME="Feature5" DEFAULT="">

	<cfquery datasource="#APPLICATION.DB#" USERNAME="#APPLICATION.UN#" PASSWORD="#APPLICATION.PW#">
			INSERT INTO #APPLICATION.DBPRE#ShopCart(CustomerID, PID, SKUName, SKU, Quantity, Price, PackageID, CreatedDate, Taxable, Feature1, Feature2, Feature3, Feature4, Feature5, IP)
			VALUES(#url.dupecid#, #Val(PID)#, '#Trim(SKUName)#', '#Trim(SKU)#', #Val(Quantity)#, #Price#, #PackageID#, '#DateFormat(Now(), "yyyy-mm-dd")#', '#Val(Taxable)#', '#Feature1#', '#Feature2#', '#Feature3#', '#Feature4#', '#Feature5#', '#cgi.remote_addr#')
	</cfquery>

	<cfoutput>
	#url.mycid#, #url.dupecid#, #Val(PID)#, #Trim(SKUName)#, #Trim(SKU)#, #Val(Quantity)#, #Price#, #PackageID#, #Trim(CreatedDate)#, #Val(Taxable)#, #Feature1#, #Feature2#, #Feature3#, #Feature4#, #Feature5#
	</cfoutput>

	<cfsetting enablecfoutputonly="no">
	</cfif> <!--- End of If for in cart already --->

	</cfloop>

	<cfif isDefined("flag")>
	<cflocation url="index.cfm?frm=shopcart&flag=1" ADDTOKEN="No">
	<cfelse>
	<cflocation url="index.cfm?frm=shopcart" ADDTOKEN="No">
	</cfif>

</cfif> <!-- End of If for type of action --->
<!--- End Template --->