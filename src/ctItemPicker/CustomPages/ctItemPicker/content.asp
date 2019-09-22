<!-- #include file ="crmwizard.js" -->
<!-- #include file ="json_engine.js" -->
<!-- #include file ="quote_inc.asp" -->
<!-- #include file ="quoteitems_inc.asp" -->
<!-- #include file ="currency_inc.asp" -->
<!-- #include file ="product_family_inc.asp" -->
<!-- #include file ="product_inc.asp" -->
<!-- #include file ="uom_inc.asp" -->
<!-- #include file ="uom_family_inc.asp" -->
<!-- #include file ="custom_sysparams_inc.asp" -->
<!-- #include file ="pricinglist_inc.asp" -->
<!-- #include file ="pricing_inc.asp" -->
<%
var OutputAsJSON=false;//only used in quoteitems_inc
%>
<style>
.column {
  float: left;
  width: 25%;
}
.columnMain {
  float: left;
  width: 75%;
}
.columnFull {
  float: left;
  width: 100%;
}
.columnSpacer {
  float: left;
  width: 100%;
  height: 5px;
  background-color: #34b233;
}
.moneyRight
{
  float: right;
}
/* Clear floats after the columns */
.row:after {
  content: "";
  display: table;
  clear: both;
}

#quoteitemsTable{
  height: 300px;
  overflow:auto;
  max-height: 300px;

}
#quoteitems_gentable
{
   table-layout:fixed;
  width:100%;
}
.customGridHead{
  white-space: nowrap !important;
    width: 100px;
    overflow: hidden;
}
#productTable{
height: 300px;
  overflow: scroll;
}

.familyDisplay{
  padding-left: 50px;
}
.FAMCELL{
  cursor:pointer;
}
.updateButtonHide{
  visibility:hidden;
}
#productfamilyTable{
  height: 300px;
  overflow: scroll;
}
</style>

<div class="row">
  <div class="column">
	<span id="_Captproductfamily" class="VIEWBOXCAPTION">Product Family:</span><br><span id="_Dataproductfamily" class="VIEWBOX"><input type="text" class="EDIT" id="productfamily" name="productfamily" value="" maxlength="20" size="20" onkeyup="productfamily_change(this)" ></span>
	<div id="productfamilyTable">
	
	</div>
  </div>
  <div class="columnMain">
  
  	<span id="_Captproduct" class="VIEWBOXCAPTION">Product:</span><br><span id="_Dataproduct" class="VIEWBOX"><input type="text" class="EDIT" id="product" name="product" value="" maxlength="20" size="20"onkeyup="product_change(this)" ></span>
	<span id="familyDisplay" class="VIEWBOXCAPTION familyDisplay">loading...</span>
	
	<span id="edits_clear" style="float:right" >
	<button onclick="edits_clear_click(this)" >Clear</button>
	</span>
	
	<div id="productTable">
	
    </div>
  </div>
</div> 
<div class="row">
  <div class="columnSpacer">
	
	
  </div>
</div> 
<div class="row">
  <div class="columnFull">
	<div id="quoteitemsTable">
	
    </div>
  </div>
</div> 


<script>

var G_SelectedProductFamily=-1;

var _quoteitem_template='{'+
  '"QuIt_orderquoteid":"'+_quote.Quote[0]["Quot_OrderQuoteID"]+'",'+
  '"QuIt_LineItemID":"-1",'+
  '"QuIt_linenumber":"",'+
  '"QuIt_UOMID":"",'+
  '"QuIt_productid":"",'+
  '"QuIt_productfamilyid":"",'+
  '"QuIt_quantity":"",'+
  '"Prod_ProductID":"",'+
  '"QuIt_discount":"",'+
  '"QuIt_quotedprice":"",'+
  '"QuIt_quotedpricetotal":"",'+
  '"QuIt_LineType":"i",'+
  '"QuIt_taxrate":"",'+
  '"QuIt_listprice":"",'+
  '"QuIt_description":"",'+
  '"prod_name":""}';
  
function getQITemplate()
{
  return JSON.parse(_quoteitem_template);
}

function edits_clear_click(sender)
{
  $('#productfamily').val('');
  $('#product').val('');
  createProductFamilyTable();
  createProductTable(_productFamily.ProductFamily[0]['prfa_productfamilyid']);
  G_SelectedProductFamily=_productFamily.ProductFamily[0]['prfa_productfamilyid'];
}

function productfamily_change(sender)
{
  createProductFamilyTable(sender.value);
}
function product_change(sender)
{
  createProductTable(G_SelectedProductFamily, sender.value);
}
function createProductFamilyTable(filter)
{
    $('#productfamilyTable').empty();
	var data=_productFamily.ProductFamily;
    var html = '<table class="CONTENTGRID" id="ProductFamilyTable" width="100%">';
    html += '<tr>';
	html += '<th class="GRIDHEAD">Product Family</th>';
    html += '</tr>';
	var _row="ROW1";
	for (var i = 0; i < data.length; i++){
		var obj = data[i];
		if ((!filter)|| ((obj["prfa_name"]).toLowerCase().indexOf(filter.toLowerCase())>=0))
		{
			html += '<tr><td class="'+_row+' FAMCELL" id="prfa_productfamilyid_'+obj["prfa_productfamilyid"]+'" onclick="_product_family_click(this,\''+obj["prfa_productfamilyid"]+'\');" >';
			html += obj["prfa_name"];
			html += '</td></tr>';
			if (_row=="ROW1")
			{
			  _row="ROW2";
			}else{
			   _row="ROW1";
			}
		}
	}
    html += '</table>';
	document.getElementById("productfamilyTable").insertAdjacentHTML( 'beforeend', html );
    getProductFamilyTitle(data[0]["prfa_productfamilyid"]);
}

function getProductFamilyTitle(id)
{
    $('#familyDisplay').empty();
	var data=_productFamily.ProductFamily;
	for (var i = 0; i < data.length; i++){
		var obj = data[i];
		if(obj["prfa_productfamilyid"]==id)
		{
		  document.getElementById("familyDisplay").insertAdjacentHTML( 'beforeend', obj["prfa_name"] );
		  break;
		}
	}
} 
//family is the product family
function createProductTable(family, filter)
{
    $('#productTable').empty();
	var data=_products.Products;
    var html = '<table class="CONTENTGRID" width="100%">';
    html += '<tr>';
	html += '<th class="GRIDHEAD">Products</th>';
	html += '<th class="GRIDHEAD">Code</th>';
	html += '<th class="GRIDHEAD">UOM</th>';
	html += '<th class="GRIDHEAD">Quantity</th>';
	html += '<th class="GRIDHEAD">List Price</th>';
	html += '<th class="GRIDHEAD">Quoted Price</th>';
	html += '<th class="GRIDHEAD">Selected</th>';
    html += '</tr>';
	var _row="ROW1";
	for (var i = 0; i < data.length; i++){
		var obj = data[i];
		//alert(JSON.stringify(obj));
		if (family==obj["prod_productfamilyid"])
		{
			if ((!filter)||(obj["prod_name"].toLowerCase().indexOf(filter.toLowerCase())>=0)
					||(obj["prod_code"].toLowerCase().indexOf(filter.toLowerCase())>=0))
			{
				if (obj["prod_Active"].toLowerCase()=='y')
				{
					html += '<tr>';
					//product
					html += '<td class="'+_row+'" id="'+obj["prod_productid"]+'" >';
					html += obj["prod_name"];
					html += '</td>';

					//productcode
					html += '<td class="'+_row+'" id="prod_code_'+obj["prod_productid"]+'" >';
					html += obj["prod_code"];
					html += '</td>';
					//uom
					html += '<td class="'+_row+'">';
					var obj = data[i];
					html += getUOMSelect(obj);
					html += '</td>';

					//quantity
					html += '<td class="'+_row+'">';
					var obj = data[i];
					html += getQuantity(obj);
					html += '</td>';
					
					//list price
					html += '<td class="'+_row+'" id="td_quit_listprice_'+obj["prod_productid"]+'" >';
					html += getListPrice(obj);
					html += '</td>';

					//quoted price
					html += '<td class="'+_row+'" id="td_quit_quotedprice_'+obj["prod_productid"]+'" >';
					html += getQuotedPrice(obj);
					html += '</td>';
					
					//selected
					html += '<td class="'+_row+'">';
					var obj = data[i];
					html += '<button class="EDIT" style="float: right;" id="prod_productid_selected_'+obj["prod_productid"]+'" name="prod_productid_selected_'+obj["prod_productid"]+'" onclick="_add_quoteitem(this,'+obj["prod_productid"]+')" >Add</button>';
					html += '</td>';
					
					html += '</tr>';
					if (_row=="ROW1")
					{
					  _row="ROW2";
					}else{
					   _row="ROW1";
					}
				}
			}
		}
	}
    html += '</table>';
	document.getElementById("productTable").insertAdjacentHTML( 'beforeend', html );
}

function getUOMSelect(productobj, defaultUOM, quoteitemobj)
{
    console.log("getUOMSelect productobj:"+JSON.stringify(productobj));
    console.log("getUOMSelect defaultUOM:"+defaultUOM);
    var uomobj=null;
	if (defaultUOM)
	{
		uomobj=getUOM_UOMObj2(defaultUOM);
		console.log("getUOMSelect uomobj:"+JSON.stringify(uomobj));
	}
	var _id=productobj["prod_productid"];
	var _selectname=_id;
	var _productid=productobj["prod_productid"];
	var qilist="false";
	if (quoteitemobj)
	{
		_id=quoteitemobj["QuIt_LineItemID"];
		_selectname="_line_item_"+_id;
		_productid=quoteitemobj["QuIt_productid"];
		qilist="true";
	}
	console.log("getUOMSelect getQuantity _id:"+_id);	
	var html = '<select class="EDIT" style="float: right;" size="1" name="quit_uomid_'+_selectname+'" id="quit_uomid_'+_selectname+'" onchange="UOMDisplayPricesCustom(this,'+_productid+','+qilist+','+_id+');">';
    var data=_uom.UOM;
	for (var i = 0; i < data.length; i++){
		var obj = data[i];
		if (productobj["prod_UOMCategory"]==obj["uom_familyID"])
		{
			var selected="";
			if ((uomobj!=null)&&(uomobj["UOM_UOMID"]==obj["UOM_UOMID"])){
			  selected=" selected ";
			}
			html += '<option value="'+obj["UOM_UOMID"]+'"'+selected+' >'+obj["uom_name"]+'</option>';
		}
	}
	html += '</select>';
	return html;
}
function getUOMText(quoteobj)
{   var data=_uom.UOM;
	for (var i = 0; i < data.length; i++){
		var obj = data[i];
		if (quoteobj["QuIt_UOMID"]==obj["UOM_UOMID"])
		{
			return obj["uom_name"];
		}
	}
	return '';
}
//qilist is the quote item list
// qiid quote item id
function UOMDisplayPricesCustom(sender, productid,qilist, qiid)
{
  console.log("UOMDisplayPricesCustom uom="+sender.value+":productid:"+productid);
  //update list price
  var productobj=getProductObj(productid);
  if (!qilist)
  {
	  $('#quit_listprice_'+productid).text(getListPriceval(productobj, sender.value));
	  $('#quit_quotedprice_'+productid).val(getListPriceval(productobj, sender.value)); 
  }else{
	  $('#quit_quotedprice__line_item_'+ qiid).val(getListPriceval(productobj, sender.value));   
	  __onchangeQuoteItem(sender,qiid,productobj);
  }
}

function anyItembeingEdited(){
    var res=false;
	var table = document.getElementById("quoteitems_gentable");
	for (var i = 1, row; row = table.rows[i]; i++) {
	   //iterate through rows
	   //rows would be accessed using the "row" variable assigned in the for loop
	   col = row.cells[0];
	   console.log(col.style.backgroundColor);
	   if (col.style.backgroundColor=="khaki"){
	     res=true;
		 break;
	   }
	}  
	return res;
}

function flagQIChange(qiid)
{
   itemBeingEdited=true;
   document.getElementById("QuIt_LineItemID_"+qiid).style="background-color: khaki";
   $('#QuIt_orderquoteid_update_'+qiid).removeClass("updateButtonHide");
}
function unflagQIChange(qiid)
{
   document.getElementById("QuIt_LineItemID_"+qiid).style="";
   $('#QuIt_orderquoteid_update_'+qiid).addClass("updateButtonHide");
}
function __onchangeQuoteItem(sender, qiid,productobj)
{
      setcustommodalfooter("Commit all changes to see an updated price");
	  var _qty=$('#quit_quantity__line_item_'+ qiid).val();
	  var _qprice=$('#quit_quotedprice__line_item_'+ qiid).val();
      $('#QuIt_quotedpricetotal_'+ qiid).html(_formatMoney(_qprice*_qty));
	  var _lp=0;
	  if (sender!=null)
		_lp=getListPriceval(productobj, sender.value);
	  $('#QuIt_listprice_'+ qiid).text(_lp);
	  // QuIt_discount_1294
	  $('#QuIt_discount_'+ qiid).html(_formatMoney(_lp-_qprice));
	  flagQIChange(qiid);
}
function getListPrice(productobj,uomval){
    console.log("getListPrice:"+productobj["prod_productid"]);
	var html = '<span id="quit_listprice_'+productobj["prod_productid"]+'" class="VIEWBOX">';
	html += _formatMoney(getListPriceval(productobj,uomval));
	html += '</span>';
	return html;
}
function getListPriceval(productobj,uomval){
    console.log("getListPriceval productobj:"+JSON.stringify(productobj));
    console.log("getListPriceval uomval:"+uomval);
  	var val = '';
    var data=_Pricing.Pricing;
	for (var i = 0; i < data.length; i++){
		var obj = data[i];
		var uomobj = null;
		if (!uomval){
		  console.log("getListPriceval prod_UOMCategory:"+productobj["prod_UOMCategory"]);
		  uomobj=getUOM_UOMObj(productobj["prod_UOMCategory"]);
		}else{
		  uomobj=getUOM_UOMObj2(uomval);		
		}
		if ((obj["pric_UOMID"]==uomobj["UOM_UOMID"]) && (productobj["prod_productid"]==obj["pric_ProductID"]))
		{
			console.log(JSON.stringify(obj));
			val += obj["pric_price"];
		}
	}
	return val;
}

function getProductObj(prod_productid)
{
    console.log("getProductObj:"+prod_productid);
	var data=_products.Products;
	for (var i = 0; i < data.length; i++){
		var obj = data[i];
		console.log("getProductObj: is  "+prod_productid+"=?="+obj["prod_productid"]);
		if (prod_productid==obj["prod_productid"])
		{
		  return obj;
		}
	}
	console.log("getProductObj: no product found");
	
	//create a dummy empty object
	
return {"prod_Active": "Y","prod_UOMCategory": "-1","prod_code": "","prod_name": "","prod_productfamilyid": "-1","prod_productid": "-1"}
	
//	return null;
}
function getUOM_UOMObj(uomfamilyid)
{
    console.log("getUOM_UOMObj:"+uomfamilyid);
	var data=_uom.UOM;
	for (var i = 0; i < data.length; i++){
		var obj = data[i];
		if (uomfamilyid==obj["uom_familyID"])
		{
		  return obj;
		}
	}
	return {"UOM_UOMID": "-1","uom_Active": "Y","uom_defaultvalue": "Y","uom_description": "","uom_familyID": "-1","uom_name": "Default","uom_units": "-1"};
}
function getUOM_UOMObj2(uomid)
{
    console.log("getUOM_UOMObj2:"+uomid);
	var data=_uom.UOM;
	for (var i = 0; i < data.length; i++){
		var obj = data[i];
		if (uomid==obj["UOM_UOMID"])
		{
		  return obj;
		}
	}
	return {"UOM_UOMID": "-1","uom_Active": "Y","uom_defaultvalue": "Y","uom_description": "","uom_familyID": "-1","uom_name": "Default","uom_units": "-1"};

}
function getQuantity(productobj, defaultvalue){
  console.log("getQuantity:"+JSON.stringify(productobj));
  console.log("getQuantity defaultvalue:"+defaultvalue);
  var _id=productobj["prod_productid"];
  var _onchange="";
  if (!_id)
  {
    _id="_line_item_"+productobj["QuIt_LineItemID"];
	_onchange="__onchangeQuoteItem(document.getElementById('quit_uomid__line_item_"+productobj["QuIt_LineItemID"]+"'), "+productobj["QuIt_LineItemID"]+",getProductObj("+productobj["QuIt_productid"]+"));";
  }
  console.log("getQuantity _id:"+_id);
  var _val='1';
  if (defaultvalue)
  {
    _val=defaultvalue;
  }
  return '<input type="number" class="EDIT" style="float: right;width:5em;text-align: right;" id="quit_quantity_'+_id+'" name="quit_quantity_'+_id+'" onchange="'+_onchange+'" value="'+_val+'" '+
	' onchange="quit_quantity_change(this,'+_id+')"  maxlength="10" size="5">';

}
function quit_quantity_change(sender, productid){
  var qty=new Number($('#quit_quantity_'+productid).val());
  
}
function getQuotedPrice(productobj,defaultvalue, quoteitemobj){
  console.log("getQuotedPrice product:"+JSON.stringify(productobj));
  console.log("getQuotedPrice defaultvalue:"+defaultvalue);
  var qval=getListPriceval(productobj);
  var _id=productobj["prod_productid"];
  var _onchange="";
  if (quoteitemobj)
  {
    _id="_line_item_"+quoteitemobj["QuIt_LineItemID"];
	_onchange="__onchangeQuoteItem(document.getElementById('quit_uomid__line_item_"+quoteitemobj["QuIt_LineItemID"]+"'), "+quoteitemobj["QuIt_LineItemID"]+",getProductObj("+quoteitemobj["QuIt_productid"]+"));";
  }
  console.log("getQuotedPrice getQuantity _id:"+_id);
  if (defaultvalue)
  {
    qval=defaultvalue;
  }
  qval=+qval;
  qval=qval.toFixed(2);
  return  '<input type="text" class="EDIT" style="float: right;text-align: right;" id="quit_quotedprice_'+_id+'" name="quit_quotedprice_'+_id+'" onchange="'+_onchange+'" value="'+qval+'" maxlength="10" size="5">';
}

function _product_family_click(sender, productfamilyid)
{
  //clear the filter
  $('#product').val('');
  //remove style from all
  var data=_productFamily.ProductFamily;
  for (var i = 0; i < data.length; i++){
    var elm=document.getElementById("prfa_productfamilyid_"+data[i]["prfa_productfamilyid"]);
	if (elm!=null)
	{
		elm.style="";
	}
  }
  console.log('_product_family_click:'+productfamilyid);
  createProductTable(productfamilyid);
  getProductFamilyTitle(productfamilyid);
  //add in style
  sender.style="text-decoration: underline;";
  G_SelectedProductFamily=productfamilyid;
}

function getAddData(obj)
{
	var res="";
	for (var key in obj) {
		if (res!="")
		{
			res+="&";
		}
		if (obj.hasOwnProperty(key)) {
			console.log(key + " -> " + obj[key]);
			var _val=encodeURIComponent(obj[key]);
			res+=key+"="+_val;
		}
	}
	return res;
}
function buildQI(newQI, id)
{
   //get the product data
   var product=getProductObj(id);
   newQI.QuIt_productid =product.prod_productid;
   newQI.QuIt_productfamilyid =product.prod_productfamilyid;
   newQI.QuIt_description =customEscape(product.prod_name);
   newQI.Prod_ProductID=product.prod_productid;
   newQI.prod_name=customEscape(product.prod_name);

   
   //get the inputs data
   var QuIt_UOMID=getfieldval("quit_uomid",id);
   newQI.QuIt_UOMID =QuIt_UOMID;
   newQI.QuIt_listprice=getListPriceval(product, QuIt_UOMID);
   newQI.QuIt_quotedprice=getfieldval("quit_quotedprice",id);
   newQI.QuIt_quantity=getfieldval("quit_quantity",id);
   
   
   //reset the inputs?
   return newQI;
}
function getfieldval(fieldName, id)
{
  return $('#'+fieldName+'_'+id).val();
}
function _add_quoteitem(sender, id)
{
	console.log('_add_quoteitem:'+id);
	var newQI=getQITemplate();
	newQI=buildQI(newQI, id);
	//send request to add the item
	var _url=crm.url('../custompages/ctitempicker/addQuoteItem.asp');
	console.log("_url:"+_url);
	
	$.ajax(
	{
	  method: "POST",
	  url: _url,
	  cache: false,
	  data: getAddData(newQI),
	  success: function( data ) {
		_quoteitems=data;
		createQuoteItemsTable();
	  },
	  error: function( error )
	  {
		 alert( error );
	  }
	});

}
function getCurrency(){
  return _currency.Currency[0]["Curr_Symbol"];
}
//family is the product family
function createQuoteItemsTable()
{
    $('#quoteitemsTable').empty();
	var data=_quoteitems.QuoteItems;
    var html = '<table class="CONTENTGRID" id="quoteitems_gentable" width="100%" >';
    html += '<tr>';
	html += '<th class="GRIDHEAD customGridHead" style="width: 30px;" >Line #</th>';
	html += '<th class="GRIDHEAD customGridHead" style="width: 140px;max-width: 160px;" >Product Name</th>';
	html += '<th class="GRIDHEAD customGridHead" style="width: 70px;max-width: 80px;" >Code</th>';
	html += '<th class="GRIDHEAD customGridHead" style="width: 70px;max-width: 80px;" >UOM</th>';
	html += '<th class="GRIDHEAD customGridHead" style="width: 70px;" >Quantity</th>';
	html += '<th class="GRIDHEAD customGridHead" style="width: 60px;">List Price ('+getCurrency()+')</th>';
	html += '<th class="GRIDHEAD customGridHead" style="width: 85px;">Quoted Price ('+getCurrency()+')</th>'; 
	//removed 15 may 2019 on request
	//html += '<th class="GRIDHEAD customGridHead" style="width: 100px;">Line Item Discount ('+getCurrency()+')</th>';
	html += '<th class="GRIDHEAD customGridHead" style="width: 100px;">Quoted Price Sum ('+getCurrency()+')</th>';
	html += '<th class="GRIDHEAD customGridHead" style="width: 60px;" >&nbsp;</th>';
	html += '<th class="GRIDHEAD customGridHead" style="width: 60px;" >&nbsp;</th>';
	html += '<th class="GRIDHEAD customGridHead" style="width: 20px;" >&nbsp;</th>';
    html += '</tr>';
	var _row="ROW1";
	var canEditItem=true;
	for (var i = 0; i < data.length; i++){
		var obj = data[i];
		var product=getProductObj(obj["QuIt_productid"]);
		html += '<tr>';
		//QuIt_linenumber
		html += '<td class="'+_row+'" id="QuIt_LineItemID_'+obj["QuIt_LineItemID"]+'" >';
		
		html += obj["QuIt_linenumber"];
		html += '</td>';
		console.log("QuIt_linenumber:"+obj["QuIt_linenumber"]);

		//product name
		
		if (obj["QuIt_LineType"]=="c")
		{
			html += '<td class="'+_row+'" colspan="7" >';
			html += obj["QuIt_description"];
		}else{
			//QuIt_description
			html += '<td class="'+_row+'" >';
			if (obj["QuIt_LineType"]=="f")
				html += obj["QuIt_description"];
			else
				html += obj["prod_name"];
		}
		html += '</td>';
				
		//product name
		if (obj["QuIt_LineType"]!="c")
		{
			html += '<td class="'+_row+'">';
			html += product["prod_code"];
			html += '</td>';
			//uom
			html += '<td class="'+_row+'" ct_QuIt_UOMID="'+obj["QuIt_UOMID"]+'" >';
			if (obj["QuIt_LineType"]!="f")
			{
				if (canEditItem)
				{
					console.log("getUOMSelect calling...:"+obj["QuIt_LineItemID"]);
					html += getUOMSelect(product,obj["QuIt_UOMID"],obj);
					console.log("getUOMSelect called");
				}else{
					html += getUOMText(obj);
				}
			}
			html += '</td>';
			
			//quantity
			html += '<td class="'+_row+'">';
			if (canEditItem)
			{
				html += getQuantity(obj, obj["QuIt_quantity"]);
			}else{
				html += _formatMoney(obj["QuIt_quantity"]);
			}
			html += '</td>';
			
			//list price
			html += '<td class="'+_row+'" >';
			if (obj["QuIt_LineType"]!="f")
				html += '<span id="QuIt_listprice_'+obj["QuIt_LineItemID"]+'" >'+ _formatMoney(obj["QuIt_listprice"])+"</span>";
			else
				html += '<span id="QuIt_listprice_'+obj["QuIt_LineItemID"]+'" >'+ _formatMoney(0)+"</span>";			
			html += '</td>';
			
			//quoted price
			html += '<td class="'+_row+' " >';
			if (canEditItem)
			{
				html += getQuotedPrice(product,obj["QuIt_quotedprice"],obj);
			}else{
				html += _formatMoney(obj["QuIt_quotedprice"]);
			}
			html += '</td>';
			
			//removed 15 may 2019 on request
			//line item discount
			//html += '<td class="'+_row+' " >';
			//html += '<span id="QuIt_discount_'+obj["QuIt_LineItemID"]+'" >'+_formatMoney(obj["QuIt_discount"])+"</span>";
			//html += '</td>';
			
			//quoted sum/total
			html += '<td class="'+_row+' " >';
			html += '<span id="QuIt_quotedpricetotal_'+obj["QuIt_LineItemID"]+'" >'+_formatMoney(obj["QuIt_quotedpricetotal"])+"</span>";
			html += '</td>';	
		}
		//delete
		html += '<td class="'+_row+' ">';
		var obj = data[i];
		html += '<button class="EDIT" id="QuIt_orderquoteid_selected_'+obj["QuIt_LineItemID"]+'" name="QuIt_orderquoteid_selected_'+obj["QuIt_LineItemID"]+'" onclick="_delete_quoteitem(this,'+obj["QuIt_LineItemID"]+')" >Delete</button>';
		html += '</td>';
		//update
		html += '<td class="'+_row+' ">';
		var obj = data[i];

		html += '<button class="EDIT updateButtonHide" id="QuIt_orderquoteid_update_'+obj["QuIt_LineItemID"]+'" name="QuIt_orderquoteid_selected_'+obj["QuIt_LineItemID"]+'" onclick="_update_quoteitem(this,'+obj["QuIt_LineItemID"]+')" >Update</button>';
		html += '</td>';
		
		html += '<td class="'+_row+' ">';
			//var __from=new Number(obj["QuIt_linenumber"]);
			var __from=new Number((i+1));
			var __to_down=new Number(obj["QuIt_linenumber"]);
			__to_down++;
			var __to_up=new Number(obj["QuIt_linenumber"]);
			__to_up--;

			if (i > 0)
			{
				html += '<button class="EDIT updateButtonUp" id="QuIt_orderquoteid_update_'+obj["QuIt_LineItemID"]+'" name="QuIt_orderquoteid_selected_'+obj["QuIt_LineItemID"]+'" onclick="_update_quoteitem_pos(this,'+obj["QuIt_LineItemID"]+','+__from+','+__to_up+')" >&#8593;</button>';
			}
			if (i < (data.length-1))
			{
				html += '<button class="EDIT updateButtonDown" id="QuIt_orderquoteid_update_'+obj["QuIt_LineItemID"]+'" name="QuIt_orderquoteid_selected_'+obj["QuIt_LineItemID"]+'" onclick="_update_quoteitem_pos(this,'+obj["QuIt_LineItemID"]+','+__from+','+__to_down+')" >&#8595;</button>';
			}
		html += '</td>';
		
		html += '</tr>';
		if (_row=="ROW1")
		{
		  _row="ROW2";
		}else{
		   _row="ROW1";
		}
		
	}
    html += '</table>';
	document.getElementById("quoteitemsTable").insertAdjacentHTML( 'beforeend', html );
	
	getQuoteTotals();
}
function buildQIFromQI(newQI)
{
   console.log("buildQIFromQI:"+JSON.stringify(newQI));
   //get the inputs data
   var id=newQI["QuIt_LineItemID"];
   var product=getProductObj(newQI["QuIt_productid"]);
   var QuIt_UOMID=getfieldval("quit_uomid__line_item",id);
   newQI.QuIt_UOMID =QuIt_UOMID;
   newQI.QuIt_listprice=getListPriceval(product, QuIt_UOMID);
   newQI.QuIt_quotedprice=getfieldval("quit_quotedprice__line_item",id);
   newQI.QuIt_quantity=getfieldval("quit_quantity__line_item",id);

   newQI.prod_name=customEscape(newQI.prod_name);
   newQI.QuIt_taxrate=customEscape(newQI.QuIt_taxrate);
   
   console.log("buildQIFromQI NEW:"+JSON.stringify(newQI));
   return newQI;
}
function customEscape(val)
{
  return encodeURIComponent(val);
}
function _update_quoteitem(sender, id)
{
	console.log('_update_quoteitem:'+id);
	var newQI=getQuoteItemObj(id);
	newQI=buildQIFromQI(newQI);
	//send request to add the item
	var _url=crm.url('../custompages/ctitempicker/updateQuoteItem.asp');
	console.log("_url:"+_url);
	console.log(JSON.stringify(getAddData(newQI)));
	
	$.ajax(
	{
	  method: "POST",
	  url: _url,
	  cache: false,
	  data: getAddData(newQI),
	  success: function( data ) {
	    unflagQIChange(id);
		_quoteitems=data;
		if (!anyItembeingEdited())
		{
		  createQuoteItemsTable();
		}
	  },
	  error: function( error )
	  {
		 alert( error );
	  }
	});  
	
}

function _update_quoteitem_pos(sender, id,_from, _to)
{
	console.log('_update_quoteitem_pos:'+id+' from '+_from+' to '+_to);
	//send request to add the item
	var _url=crm.url('../custompages/ctitempicker/updateQuoteItempos.asp');
	console.log("_url:"+_url);
	
	$.ajax(
	{
	  method: "POST",
	  url: _url,
	  cache: false,
	  data: "QuIt_LineItemId="+id+"&from="+_from+"&to="+_to,
	  success: function( data ) {
	    unflagQIChange(id);
		_quoteitems=data;
		if (!anyItembeingEdited())
		{
		  createQuoteItemsTable();
		}
	  },
	  error: function( error )
	  {
		 alert( error );
	  }
	});  
	
}
function getQuoteItemObj(QuIt_LineItemID)
{
	var data=_quoteitems.QuoteItems;
	for (var i = 0; i < data.length; i++){
		var obj = data[i];
		if (QuIt_LineItemID==obj["QuIt_LineItemID"])
		{
		  return obj;
		}
	}
	return null;
}
function getQuoteTotals(){
    var _url=crm.url('../custompages/ctitempicker/getQuoteTotals.asp');
	_url+="&quot_orderquoteid="+_quote.Quote[0]["Quot_OrderQuoteID"];
	$.ajax(
	{
	  method: "GET",
	  url: _url,
	  cache: false,
	  success: function( data ) {
		_quote=data;
		var footerdisplay="Gross Amount: "+getCurrency()+" "+_formatMoneyVal(_quote.Quote[0]["Quot_grossamt"]);
		footerdisplay+=" - Discount Amount: "+getCurrency()+" "+_formatMoneyVal(_quote.Quote[0]["Quot_discountamt"]);
		footerdisplay+=" - Net Amount: "+getCurrency()+" "+_formatMoneyVal(_quote.Quote[0]["Quot_nettamt"]);
		setcustommodalfooter(footerdisplay);
	  },
	  error: function( error )
      {
         alert( error );
      }
    });
}

function _delete_quoteitem(sender,QuIt_LineItemId)
{
  console.log('_delete_quoteitem:'+QuIt_LineItemId);
  if (window.confirm("Are you sure you want to delete this item?"))
  {
    console.log("delete quote item:"+QuIt_LineItemId);
	//send request to delete the item
	var _url=crm.url('../custompages/ctitempicker/deleteQuoteItem.asp');
	console.log("_url:"+_url);
	$.ajax(
	{
	  method: "POST",
	  url: _url,
	  cache: false,
	  data: "quot_orderquoteid="+_quote.Quote[0]["Quot_OrderQuoteID"]+"&QuIt_LineItemId="+QuIt_LineItemId,success: function( data ) {
		//alert('don');
		//alert(JSON.stringify(data));
		_quoteitems=data;
		createQuoteItemsTable();
	  },
	  error: function( error )
      {
         alert( error );
      }
    });
  }
}
function _formatMoney(val)
{
  val=+val; //convert to number
  val=val.toFixed(2);
  val=val.toLocaleString();
  return '<div class="moneyRight" >'+val+'</div>';
}
function _formatMoneyVal(val)
{
  val=+val; //convert to number
  val=val.toFixed(2);
  val=val.toLocaleString();
  return val;
}

if (_quote.Quote[0]["Quot_associatedid"]=="&nbsp;")
{
	setcustommodalheader("Quote Items");
	createProductFamilyTable();
	createProductTable(_productFamily.ProductFamily[0]['prfa_productfamilyid']);
	G_SelectedProductFamily=_productFamily.ProductFamily[0]['prfa_productfamilyid'];
	createQuoteItemsTable();
	document.getElementById("prfa_productfamilyid_"+_productFamily.ProductFamily[0]['prfa_productfamilyid']).style="text-decoration: underline;";
}else{
	setcustommodalheader("This Quote has been converted and locked");
}

setcustommodalfooter("");
function customModalCloseEventMethod()
{
  console.log("customModalCloseEventMethod");
  //document.location.reload(); //note : do NOT use reload as when you create a new quote this reposts the screen and you get a second quote.
  document.location.href=crm.url(1469);
}
customModalCloseEvent=customModalCloseEventMethod;

</script>
