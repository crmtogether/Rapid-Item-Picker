<%

var objar=new Array();//this stores our data objects

var _obj=new Object();
_obj.sql="select uom_familyID,UOM_UOMID,uom_name "+
		"from UOM "+
		"where uom_Active='Y' and uom_deleted is null order by uom_familyID";
		
_obj.columns=new Array();
_obj.title="UOMbyFam";
_obj.columns.push('uom_familyID');
_obj.columns.push('UOM_UOMID');
_obj.columns.push('uom_name');
objar.push(_obj);

var _contentuom=createJSON_New2(objar,CRM);

%>
<script>
var _uombyfam=<%=_contentuom%>
</script>