<%

var objar=new Array();//this stores our data objects

var _obj=new Object();
_obj.sql="select UOMF_FamilyID,uomf_description,uomf_Active"+
		",uomf_defaultvalue,uomf_name from UOMFamily where UOMF_Deleted is null";
		
_obj.columns=new Array();
_obj.title="UOMFamily";
_obj.columns.push('UOMF_FamilyID');
_obj.columns.push('uomf_description');
_obj.columns.push('uomf_Active');
_obj.columns.push('uomf_defaultvalue');
_obj.columns.push('uomf_name');
objar.push(_obj);

var _contentuomfam=createJSON_New(objar,CRM);

%>
<script>
var _uomfam=<%=_contentuomfam%>
</script>