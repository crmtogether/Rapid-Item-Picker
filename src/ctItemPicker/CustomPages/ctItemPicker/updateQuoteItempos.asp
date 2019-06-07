<!-- #include file ="crmwizard.js" -->
<!-- #include file ="json_header.js" -->
<!-- #include file ="json_engine.js" -->
<%

function _dev(msg)
{
  if (false)
  {
	Response.Write("<br>dbg: "+msg);
  }
}

var quot_orderquoteid="-1";

var QuIt_LineItemId=Request.Form("QuIt_LineItemId");
var old_QuIt_linenumber=Request.Form("from");
var new_QuIt_linenumber=Request.Form("to");

_dev("QuIt_LineItemId:"+QuIt_LineItemId);

//find QuoteItem..we are moving
var QuoteItemsrec=CRM.FindRecord("QuoteItems","QuIt_LineItemId="+QuIt_LineItemId);
quot_orderquoteid=QuoteItemsrec("QuIt_orderquoteid");
quoteid=QuoteItemsrec("QuIt_orderquoteid");

//find other item and update with the old number
var QuoteItemsrec2=CRM.FindRecord("QuoteItems","QuIt_orderquoteid="+quot_orderquoteid+" and QuIt_linenumber="+new_QuIt_linenumber);
QuoteItemsrec2("QuIt_linenumber")=old_QuIt_linenumber;
QuoteItemsrec2.SaveChangesNoTLS();

//update the item we are changing...
QuoteItemsrec("QuIt_linenumber")=new_QuIt_linenumber;
QuoteItemsrec.SaveChangesNoTLS();

_dev("update QuoteItems pos");

var OutputAsJSON=true;
%>
<!-- #include file ="quoteitems_inc.asp" -->
<!-- #include file ="json_footer.js" -->