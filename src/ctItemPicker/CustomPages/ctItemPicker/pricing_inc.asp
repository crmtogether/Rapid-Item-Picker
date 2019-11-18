<%

var objar=new Array();//this stores our data objects

var qsql_="select Quot_OrderQuoteID,Quot_currency,Quot_PricingListID from Quotes "+
	"where Quot_OrderQuoteID="+quoteid;
var qp=CRM.CreateQueryObj(qsql_);
qp.SelectSQL();

var pric_PricingListID="-1";//default
var pric_price_CID="-1";
if (!qp.eof)
{
  pric_PricingListID=qp("Quot_PricingListID");
  pric_price_CID=qp("Quot_currency");
}

var _obj=new Object();
_obj.sql="select "+
	"Pric_PricingID,pric_UOMID,pric_ProductID,pric_price,pric_price_CID,pric_PricingListID "+
	"from Pricing where pric_PricingListID="+pric_PricingListID+" and pric_Active='Y' and "+
	"pric_price_CID="+pric_price_CID;
		
_obj.columns=new Array();
_obj.title="Pricing";
_obj.columns.push('pric_ProductID');
_obj.columns.push('Pric_PricingID');
_obj.columns.push('pric_UOMID');
_obj.columns.push('pric_price');
_obj.columns.push('pric_price_CID');
_obj.columns.push('pric_PricingListID');
objar.push(_obj);

var _content=createJSON_New2(objar,CRM);

%>
<script>
var _Pricing=<%=_content%>
</script>