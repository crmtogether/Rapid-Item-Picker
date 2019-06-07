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

var quot_orderquoteid=Request.Form("quot_orderquoteid");
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
var quot_DiscountPC=quoterec("quot_DiscountPC");

//get the line item number of the record..we use this to update the line no's
var quit_linenumber=0;
var vLineItemsQuote_sql="select quit_linenumber from vLineItemsQuote  WITH (NOLOCK)  where QuIt_LineItemId="+QuIt_LineItemId;
var vLineItemsQuote=CRM.CreateQueryObj(vLineItemsQuote_sql);
vLineItemsQuote.SelectSQL();
if (!vLineItemsQuote.eof)
{
	quit_linenumber=vLineItemsQuote("quit_linenumber");
}
_dev("quit_linenumber:"+quit_linenumber);

//delete QuoteItem
var itemid=Request.Form["quoteitemid"];
var QuoteItemsrec=CRM.FindRecord("QuoteItems","QuIt_LineItemID="+QuIt_LineItemId+" AND quit_Deleted is null");
QuoteItemsrec.DeleteRecord=true;
QuoteItemsrec.SaveChangesNoTLS();
_dev("DeleteRecord:"+QuIt_LineItemId);
//fix up the line items
//UPDATE QuoteItems SET quit_linenumber = (quit_linenumber -1)  
//WHERE quit_linenumber  > 8 AND quit_linenumber >= 0 AND quit_orderquoteid = 514 AND quit_DELETED IS NULL
var quit_linenumber_sql="UPDATE QuoteItems "+
			"SET quit_linenumber = (quit_linenumber -1)  "+
			"WHERE quit_linenumber  > "+quit_linenumber+" AND quit_linenumber >= 0 "+
			"AND quit_orderquoteid = "+quot_orderquoteid+" AND quit_DELETED IS NULL";
CRM.ExecSql(quit_linenumber_sql);
_dev("quit_linenumber_sql:"+quit_linenumber_sql);

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
var quot_GrossAmt=0;
if ((!newquotetotals.eof)&&(newquotetotals("NetTotal")!=null))
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
oppores.SaveChangesNoTLS();
_dev("oppores save:"+oppoid);

var OutputAsJSON=true;
%>
<!-- #include file ="quoteitems_inc.asp" -->
<!-- #include file ="json_footer.js" -->