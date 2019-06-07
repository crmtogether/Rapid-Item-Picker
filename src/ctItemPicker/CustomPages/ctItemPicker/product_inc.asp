<%

var objar=new Array();//this stores our data objects

var prfa_productfamilyid=Request.Querystring("prfa_productfamilyid");
if (!prfa_productfamilyid)
{
  prfa_productfamilyid="4";
}
var quoteid=CRM.GetContextInfo("quotes","quot_orderquoteid");
var json_note="";
if (!quoteid)
{
  quoteid="514";
}

var _obj=new Object();
_obj.sql="select Prod_ProductID,prod_name,prod_code,prod_productfamilyid ,prod_UOMCategory,prod_Active "+
		"from NewProduct where Prod_Deleted is null";
		
_obj.columns=new Array();
_obj.title="Products";
_obj.columns.push('prod_productid');
_obj.columns.push('prod_name');
_obj.columns.push('prod_code');
_obj.columns.push('prod_productfamilyid');
_obj.columns.push('prod_UOMCategory');
_obj.columns.push('prod_Active');
objar.push(_obj);

var _contentprodfam=createJSON(objar,CRM);

%>
<script>
var _products=<%=_contentprodfam%>
</script>