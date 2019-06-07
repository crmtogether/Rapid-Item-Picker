<%

var objar=new Array();//this stores our data objects

var quoteid=CRM.GetContextInfo("quotes","quot_orderquoteid");
var json_note="";
if (!quoteid)
{
  quoteid="514";
}

var _obj=new Object();
_obj.sql="SELECT TOP 51  prfa_productfamilyid, prfa_name FROM ProductFamily "+
		"WHERE (prfa_name LIKE N'%' ESCAPE '|' OR COALESCE(prfa_name, N'') = N'')  "+
		"and prfa_Deleted is Null and  prfa_active = N'Y'AND  "+
		"prfa_productfamilyid IN (select prod_productfamilyid from newproduct where prod_productid  "+
		"in(select pric_productid from pricing WHERE pric_deleted IS NULL AND pric_pricinglistid  "+
		"=(select quot_pricinglistid from quotes where quot_orderquoteid = "+quoteid+" and pricing.pric_price_cid = quotes.quot_currency)))  "+
		"and ((prfa_intid is null and prfa_active= N'Y' )) "+
 		"order by prfa_name"; 

_obj.columns=new Array();
_obj.title="ProductFamily";
_obj.columns.push('prfa_productfamilyid');
_obj.columns.push('prfa_name');
objar.push(_obj);

var _contentprodfam=createJSON(objar,CRM);

%>
<script>
var _productFamily=<%=_contentprodfam%>
</script>