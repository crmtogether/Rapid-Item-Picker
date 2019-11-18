<%

var objar=new Array();//this stores our data objects

var _obj=new Object();
_obj.sql="Select "+
	"QuIt_orderquoteid,QuIt_LineItemID,QuIt_linenumber,QuIt_UOMID,"+
	"QuIt_productid,QuIt_productfamilyid,"+
	"QuIt_quantity,QuIt_description,Prod_ProductID,"+
	"QuIt_discount,QuIt_quotedprice,QuIt_quotedpricetotal,QuIt_LineType,"+
	"QuIt_taxrate, prod_name, prod_code,QuIt_listprice, "+
	"uom_name,uom_description, QuIt_UOMID "+
	"from vLineItemsQuote WITH (NOLOCK) "+
	"left join UOM on QuIt_UOMID=UOM_UOMID "+
	"where "+
	"quit_OrderQuoteID = "+quoteid+" and quit_deleted is null "+
	"order by QuIt_linenumber";
		
_obj.columns=new Array();
_obj.title="QuoteItems";
_obj.columns.push('QuIt_LineItemID');
_obj.columns.push('QuIt_orderquoteid');
_obj.columns.push('QuIt_linenumber');
_obj.columns.push('QuIt_UOMID');
_obj.columns.push('QuIt_productid');
_obj.columns.push('QuIt_productfamilyid');
_obj.columns.push('QuIt_quantity');
_obj.columns.push('QuIt_description');
_obj.columns.push('Prod_ProductID');
_obj.columns.push('QuIt_discount');
_obj.columns.push('QuIt_quotedprice');
_obj.columns.push('QuIt_quotedpricetotal');
_obj.columns.push('QuIt_LineType');
_obj.columns.push('QuIt_taxrate');
_obj.columns.push('prod_name');
_obj.columns.push('prod_code');
_obj.columns.push('QuIt_listprice');
_obj.columns.push('uom_name');
_obj.columns.push('uom_description');

objar.push(_obj);
//
//if OutputAsJSON is true see json_footer.js or json_footer2.js
//
if (!OutputAsJSON){
	var _content=createJSON(objar,CRM);

	%>
	<script>
	var _quoteitems=<%=_content%>
	</script>
<% } %>
