<%

var objar=new Array();//this stores our data objects

var _obj=new Object();
_obj.sql="select "+
	"Curr_CurrencyID,Curr_Symbol,Curr_DecimalPrecision,Curr_Rate "+
	"from Currency "+
	"where Curr_CurrencyID="+Quot_currency+" and Curr_Deleted is null";
		
_obj.columns=new Array();
_obj.title="Currency";
_obj.columns.push('Curr_CurrencyID');
_obj.columns.push('Curr_Symbol');
_obj.columns.push('Curr_DecimalPrecision');
_obj.columns.push('Curr_Rate');
objar.push(_obj);

var _content=createJSON(objar,CRM);

%>
<script>
var _currency=<%=_content%>
</script>