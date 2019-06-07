<%

var objar=new Array();//this stores our data objects

var _obj=new Object();
_obj.sql="select UOM_UOMID,uom_familyID,uom_description"+
		",uom_units,uom_Active,uom_defaultvalue,uom_name from UOM "+
		"where uom_Active='Y'";
		
_obj.columns=new Array();
_obj.title="UOM";
_obj.columns.push('UOM_UOMID');
_obj.columns.push('uom_familyID');
_obj.columns.push('uom_description');
_obj.columns.push('uom_units');
_obj.columns.push('uom_Active');
_obj.columns.push('uom_defaultvalue');
_obj.columns.push('uom_name');
objar.push(_obj);

var _contentuom=createJSON(objar,CRM);

%>
<script>
var _uom=<%=_contentuom%>
</script>