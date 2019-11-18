<%

var objar=new Array();//this stores our data objects

var _famfilter="";

var prfa_productfamilyid=Request.Querystring("prfa_productfamilyid");
var pageCount=Request.Querystring("pageCount");
if (pageCount+""=="undefined")
{
  pageCount=1;
}
pageCount=new Number(pageCount);

var rowsatatime=20000;
var rowsfrom=1;
if (pageCount>1)
{
	var rowsfrom=((pageCount-1)*rowsatatime)+pageCount;
}
var rowsto=rowsfrom+rowsatatime;

var returndataonly=true;
if (prfa_productfamilyid+""=="undefined")
{
  returndataonly=false;
}

var quoteid=CRM.GetContextInfo("quotes","quot_orderquoteid");
var json_note="";
//test line
if (!quoteid)
{
  quoteid="514";
}

//Oct 2019 - Get the first families items only...
var _fam_sql="SELECT TOP 1 prfa_productfamilyid, prfa_name FROM ProductFamily "+
		"WHERE (prfa_name LIKE N'%' ESCAPE '|' OR COALESCE(prfa_name, N'') = N'')  "+
		"and prfa_Deleted is Null and  prfa_active = N'Y'AND  "+
		"prfa_productfamilyid IN (select prod_productfamilyid from newproduct where prod_productid  "+
		"in(select pric_productid from pricing WHERE pric_deleted IS NULL AND pric_pricinglistid  "+
		"=(select quot_pricinglistid from quotes where quot_orderquoteid = "+quoteid+" and pricing.pric_price_cid = quotes.quot_currency)))  "+
		"and ((prfa_intid is null and prfa_active= N'Y' )) "+
 		"order by prfa_name"; 

if (prfa_productfamilyid+""=="undefined")
{
	var _fam_sqlds=CRM.CreateQueryObj(_fam_sql);
	_fam_sqlds.SelectSQL();

	if (!_fam_sqlds.eof)
	{
	  prfa_productfamilyid=_fam_sqlds("prfa_productfamilyid");
	}
}
_famfilter=" and prod_productfamilyid="+prfa_productfamilyid;

var _obj=new Object();
_obj.sql="SELECT * FROM (select Row_Number() OVER (ORDER BY prod_name) as rowid,"+
		"Prod_ProductID,prod_name,prod_code,prod_productfamilyid ,prod_UOMCategory,prod_Active "+
		"from NewProduct where Prod_Deleted is null and (prod_Active is null or prod_Active='Y') "+_famfilter+
		") as a  where rowid >= "+rowsfrom+" and rowid < "+rowsto;
		
//Response.Write(_obj.sql);
		
_obj.columns=new Array();
_obj.title="Products";
_obj.columns.push('prod_productid');
_obj.columns.push('prod_name');
_obj.columns.push('prod_code');
_obj.columns.push('prod_productfamilyid');
_obj.columns.push('prod_UOMCategory');
_obj.columns.push('prod_Active');
objar.push(_obj);

var _contentprodfam=createJSON_New(objar,CRM);

if (!returndataonly)
{
%>
<script>

var products_prfa_productfamilyid_<%=prfa_productfamilyid %>=<%=_contentprodfam%>;

//raw html...for speed purposes
var html_products_prfa_productfamilyid_<%=prfa_productfamilyid %>=null;

</script>

<% }else{
  Response.ContentType = "application/json";
%>
<%=_contentprodfam%>
<% } %>
