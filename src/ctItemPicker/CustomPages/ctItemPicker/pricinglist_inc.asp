<%

var objar=new Array();//this stores our data objects

var _obj=new Object();
_obj.sql="Select PrLi_PricingListID,prli_Description,prli_Active,prli_name "+
	"from PricingList  WITH (NOLOCK)  where  PrLi_Active = N'Y' "+
	"and COALESCE(PrLi_DefaultValue, N'') = N''";
		
_obj.columns=new Array();
_obj.title="UOMFamily";
_obj.columns.push('PrLi_PricingListID');
_obj.columns.push('prli_Description');
_obj.columns.push('prli_Active');
_obj.columns.push('prli_name');
objar.push(_obj);

var _content=createJSON(objar,CRM);

%>
<script>
var _PricingList=<%=_content%>
</script>