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
function getField(fname){
  if (fname.indexOf("_CID")>0)
  {
    return currencyCID;
  }
  return Request.Form(fname);
}

var quot_orderquoteid=Request.Form("QuIt_orderquoteid");
_dev("quot_orderquoteid:"+quot_orderquoteid);
if (!quot_orderquoteid)
{
  quot_orderquoteid="514";
}
var quoteid=quot_orderquoteid;

var QuIt_LineItemId=Request.Form("QuIt_LineItemId");
_dev("QuIt_LineItemId:"+QuIt_LineItemId);
if (!QuIt_LineItemId)
{
  QuIt_LineItemId="1249";
}

//get the quote
var quoterec=CRM.FindRecord("Quotes","quot_orderquoteid="+quot_orderquoteid);
var oppoid=quoterec("Quot_opportunityid");
var currencyCID=quoterec("Quot_currency");
var quot_DiscountPC=quoterec("quot_DiscountPC");

//find QuoteItem
var QuoteItemsrec=CRM.FindRecord("QuoteItems","QuIt_LineItemId="+QuIt_LineItemId);
var QuIt_LineType=QuoteItemsrec("QuIt_LineType");
var QuIt_quantity=new Number(getField("QuIt_quantity"));
var QuIt_quotedprice=new Number(getField("QuIt_quotedprice"));
if (QuIt_LineType!="f")
{
	var QuIt_listprice=new Number(getField("QuIt_listprice"));
	QuoteItemsrec("QuIt_UOMID")=getField("QuIt_UOMID");
	QuoteItemsrec("QuIt_productfamilyid")=getField("QuIt_productfamilyid");
	QuoteItemsrec("QuIt_listprice")=QuIt_listprice;
}
QuoteItemsrec("QuIt_quantity")=QuIt_quantity;
QuoteItemsrec("QuIt_quotedprice")=QuIt_quotedprice;
if (QuIt_LineType!="f")
{
	var QuIt_discount=QuIt_listprice - QuIt_quotedprice;
	QuoteItemsrec("QuIt_discount")=QuIt_discount;//list-quoted 
	QuoteItemsrec("QuIt_discountsum")=QuIt_discount*QuIt_quantity;
	QuoteItemsrec("QuIt_quotedpricetotal")=QuIt_quantity*QuIt_quotedprice;
}
QuoteItemsrec.SaveChangesNoTLS();
_dev("update QuoteItems");

//get new values
var newquotetotals_sql="Select Sum(COALESCE(quit_DiscountSum, 0)) as DiscTotal,"+
		"Sum(COALESCE(quit_quotedpricetotal, 0)) as NetTotal,"+
		"Sum(COALESCE(quit_DiscountSum, 0))+Sum(COALESCE(quit_quotedpricetotal, 0)) as NoDiscAmt "+
		"from vLineItemsQuote "+
		"WITH (NOLOCK) where COALESCE(quit_deleted, 0) = 0 and quit_orderquoteID="+quot_orderquoteid;
var newquotetotals=CRM.CreateQueryObj(newquotetotals_sql);
newquotetotals.SelectSQL();
_dev("newquotetotals_sql:"+newquotetotals_sql);
//work out totals
var quot_NettAmt=0;
var quot_LineItemDisc=0;
var NoDiscAmt=0;
var quot_DiscountAMT=0;
var quot_GrossAmt="";
if (!newquotetotals.eof)
{
	quot_LineItemDisc=newquotetotals("DiscTotal");
	quot_NettAmt=newquotetotals("NetTotal");
	NoDiscAmt=newquotetotals("NoDiscAmt");
    quot_DiscountAMT=((quot_NettAmt/100)*quot_DiscountPC);
}
_dev("quot_NettAmt: "+quot_NettAmt);
quoterec("quot_NettAmt")=quot_NettAmt;
_dev("quot_LineItemDisc: "+quot_LineItemDisc);
quoterec("quot_LineItemDisc")=quot_LineItemDisc;
_dev("quot_DiscountAMT:"+quot_DiscountAMT);
quoterec("quot_DiscountAMT")=quot_DiscountAMT;

quot_GrossAmt=quot_NettAmt-quot_DiscountAMT;
_dev("quot_GrossAmt:"+quot_GrossAmt);
quoterec("quot_GrossAmt")=quot_GrossAmt; ;
quoterec.SaveChangesNoTLS();

var quotetotals_sql="Select COALESCE(Sum(Quot_GrossAmt), 0) as TotalForOppo, "+
		"COALESCE(Sum(Quot_NoDiscAmt), 0) as NettTotalForOppo "+
		"from vQuotes WITH (NOLOCK) "+
		"where Quot_OpportunityID="+oppoid+
		" and Quot_Status = N'Active' and COALESCE(Quot_RollUp, N'') <> N''";
var quotetotals=CRM.CreateQueryObj(quotetotals_sql);
quotetotals.SelectSQL();
_dev("quotetotals_sql:"+quotetotals_sql);
var Oppo_TotalQuotes=0;
var Oppo_Total=0;
var Oppo_NoDiscAmtSum=0;
if (!quotetotals.eof)
{
  Oppo_TotalQuotes=quotetotals("TotalForOppo");
  Oppo_Total=quotetotals("NettTotalForOppo");
}
_dev("Oppo_TotalQuotes:"+Oppo_TotalQuotes);
_dev("Oppo_Total:"+Oppo_Total);

//oppo totals
//UPDATE Opportunity SET Oppo_TotalOrders=16151.600000,Oppo_TotalOrders_CID=1,
//Oppo_TotalQuotes=145.000000,Oppo_TotalQuotes_CID=1,Oppo_Total=16296.600000,
//Oppo_Total_CID=1,Oppo_NoDiscAmtSum=0.000000,Oppo_NoDiscAmtSum_CID=1,oppo_UpdatedBy=1,
//oppo_TimeStamp='20190416 07:33:54',oppo_UpdatedDate='20190416 07:33:54' 
//WHERE (Oppo_OpportunityID=10)
var oppores=CRM.FindRecord("Opportunity","oppo_opportunityid="+oppoid);
oppores("Oppo_TotalQuotes")=Oppo_TotalQuotes;
oppores("Oppo_Total")=Oppo_Total;
//oppores("Oppo_NoDiscAmtSum")=Oppo_NoDiscAmtSum;
oppores.SaveChangesNoTLS();
_dev("oppores save:"+oppoid);

var OutputAsJSON=true;
%>
<!-- #include file ="quoteitems_inc.asp" -->
<!-- #include file ="json_footer.js" -->