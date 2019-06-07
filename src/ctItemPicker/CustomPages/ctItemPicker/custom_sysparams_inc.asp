<%

var objar=new Array();//this stores our data objects

var _obj=new Object();
_obj.sql="select parm_name, parm_value from Custom_SysParams "+
	"where parm_name in "+	"('QuoteFormat','QuoteExpirations','OrderFormat','PricingCIDList','UsePricingLists','UseUOMs','OrderLevelDiscounts');";
		
_obj.columns=new Array();
_obj.title="Custom_SysParams";
_obj.columns.push('parm_name');
_obj.columns.push('parm_value');
objar.push(_obj);

var _content=createJSON(objar,CRM);

%>
<script>
var _Custom_SysParams=<%=_content%>
</script>