<%

var objar=new Array();//this stores our data objects

var quoteid=CRM.GetContextInfo("quotes","quot_orderquoteid");
var Quot_currency=CRM.GetContextInfo("quotes","Quot_currency");
var json_note="";
if (!quoteid)
{
  quoteid="514";
}

var _obj=new Object();
_obj.sql="select Quot_OrderQuoteID,Quot_currency,Quot_PricingListID,Quot_associatedid,"+
	"Quot_discountamt,Quot_grossamt,Quot_lineitemdisc,Quot_nettamt "+
	"from Quotes "+
	"where Quot_OrderQuoteID="+quoteid;
		
_obj.columns=new Array();
_obj.title="Quote";
_obj.columns.push('Quot_OrderQuoteID');
_obj.columns.push('Quot_currency');
_obj.columns.push('Quot_PricingListID');
_obj.columns.push('Quot_associatedid');
_obj.columns.push('Quot_discountamt');
_obj.columns.push('Quot_grossamt');
_obj.columns.push('Quot_lineitemdisc');
_obj.columns.push('Quot_nettamt');
objar.push(_obj);

if (!OutputAsJSON){
	var _content=createJSON(objar,CRM);

	%>
	<script>
	var _quote=<%=_content%>
	</script>
<% } %>