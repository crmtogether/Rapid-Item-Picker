<%

var getProperty = function (obj, propertyName) {
    return obj[propertyName];
};

//was planning on putting this into a grid...
function colIncolumnsToTotal(obj, name)
{
  if (obj.columnsToTotal)
  {
    return obj.columnsToTotal.indexOf(name) > -1;
  }
  return false;
}	
function undefinedToBlank(val)
{
	if (val+""=="undefined")
	{
		return "&nbsp;";
	}
	return val;
}
function undefinedToNum(val)
{
	if (val+""=="undefined")
	{
		return 0;
	}
	val=val.replace(",","");
	val=val.replace(",","");
	return val;
}
//change the structure....so not to use an index
function createJSON_New(objar, CRM)
{
	var totalsArray=new Array();
	//var allcolumns=new Array();
    var grid='{"structureversion":"1",';//version of the json ..use to detemine how to parse it
	for(var i=0;i<objar.length;i++)
	{		
  	  var allcolumns=new Array();
	  var totalsArray=new Array();
      var _totals="0d 0h 0m";
	  grid+='"'+objar[i].title+'":{';
	  var u=objar[i];
    	if (u.columnsToTotal)//currency totals
		{	
			for(var z=0;z<u.columnsToTotal.length;z++)
			{
				totalsArray[u.columnsToTotal[z]]=0;
			}
		}	  
	  var q=CRM.CreateQueryObj(u.sql);
	  try{
		q.SelectSQL();
	  }catch(e)
	  {
		Response.Write("Error in SQL: "+u.sql);
		Response.End();
	  }
	  var _rowcomma="";
	  while(!q.eof)
	  {
		grid+=_rowcomma+'"'+fixupJSON(undefinedToBlank(q(objar[i].columns[0])))+'":';
		grid+='{';
		var _cellcomma="";
		for(j=0;j<objar[i].columns.length;j++)
		{
			if (objar[i].columns[j].indexOf("_secterr")>0)
			{
			  grid+=_cellcomma+'"'+objar[i].columns[j]+'":"'+getTerr(q(objar[i].columns[j]))+'"';				
			}else{
			  grid+=_cellcomma+'"'+objar[i].columns[j]+'":"'+fixupJSON(undefinedToBlank(q(objar[i].columns[j])))+'"';
			}
			_cellcomma=",";
		}
		grid+='}';
		_rowcomma=',';
		if (u.columnsToTotalTime)
	    {
			_totals=addTime(_totals,undefinedToBlank(q(objar[i].columnsToTotalTime[0])));
	    }
		q.NextRecord();
	  }
	  if (u.columnsToTotal)////add in total columns
   	  {  
	    grid+="{";
	
		for (_col in allcolumns) {
			if (_col=="indexOf")//..weird bug
			{
				break;
			}
			var _totl="&nbsp;--";//+_col;
			
			if (totalsArray.hasOwnProperty(_col))
			{
				_totl=getProperty(totalsArray,_col);
				_totl=formatTotals(_totl);
			}
			rowClass="GRIDHEAD";			
			grid+=''+_totl+'';	
		}
		grid+="}";
	  }
	grid+="}}";
	}
	return grid;
}
//change the structure to create an index
function createJSON_New2(objar, CRM)
{
	var totalsArray=new Array();
	//var allcolumns=new Array();
    var grid='{"structureversion":"1",';//version of the json ..use to detemine how to parse it
	for(var i=0;i<objar.length;i++)
	{		
  	  var allcolumns=new Array();
	  var totalsArray=new Array();
      var _totals="0d 0h 0m";
	  grid+='"'+objar[i].title+'":{';
	  var u=objar[i];
	  var q=CRM.CreateQueryObj(u.sql);
	  try{
		q.SelectSQL();
	  }catch(e)
	  {
		Response.Write("Error in SQL: "+u.sql);
		Response.End();
	  }
	  var _rowcomma="";
	  var _rowcomma2="";
	  var _prevalue='---';
	  while(!q.eof)
	  {
		if (_prevalue!=q(objar[i].columns[0]))
		{
			if (_prevalue!='---')
			{
				grid+="]";
			}
			grid+=_rowcomma+'"'+fixupJSON(undefinedToBlank(q(objar[i].columns[0])))+'":['; 
			_prevalue=q(objar[i].columns[0]);
		}else{
			grid+=_rowcomma2;
		}
		grid+='{';
		var _cellcomma="";
		for(j=0;j<objar[i].columns.length;j++)
		{
			if (objar[i].columns[j].indexOf("_secterr")>0)
			{
			  grid+=_cellcomma+'"'+objar[i].columns[j]+'":"'+getTerr(q(objar[i].columns[j]))+'"';				
			}else{
			  grid+=_cellcomma+'"'+objar[i].columns[j]+'":"'+fixupJSON(undefinedToBlank(q(objar[i].columns[j])))+'"';
			}
			_cellcomma=",";
		}
		grid+='}';
		_rowcomma=',';	
		_rowcomma2=',';			
		q.NextRecord();
	  }
		  
	grid+="]}}";
	}
	return grid;
}


function createJSON(objar, CRM)
{
	var totalsArray=new Array();
	//var allcolumns=new Array();
    var grid='{"structureversion":"1",';//version of the json ..use to detemine how to parse it
	for(var i=0;i<objar.length;i++)
	{		
  	  var allcolumns=new Array();
	  var totalsArray=new Array();
      var _totals="0d 0h 0m";
	  grid+='"'+objar[i].title+'":[';
	  var u=objar[i];
    	if (u.columnsToTotal)//currency totals
		{	
			for(var z=0;z<u.columnsToTotal.length;z++)
			{
				totalsArray[u.columnsToTotal[z]]=0;
			}
		}	  
	  var q=CRM.CreateQueryObj(u.sql);
	  try{
		q.SelectSQL();
	  }catch(e)
	  {
		Response.Write("Error in SQL: "+u.sql);
		Response.End();
	  }
	  /*
	  ///to do...add in list of columns
	  grid+="<tr>";
	  for(j=0;j<objar[i].columns.length;j++)
	  {
		grid+="<td class=\"GRIDHEAD\" >"+objar[i].columns[j]+"</td>";
		allcolumns[objar[i].columns[j]]="";
	  }
	  grid+="</tr>";
	  */
	  var _rowcomma="";
	  while(!q.eof)
	  {
		grid+=_rowcomma+'{';
		var _cellcomma="";
		for(j=0;j<objar[i].columns.length;j++)
		{
			if (totalsArray.hasOwnProperty (objar[i].columns[j]))
			{
				var _nm=new Number(undefinedToNum(q(objar[i].columns[j])));
				if (!isNaN(_nm))
				{
					totalsArray[objar[i].columns[j]]+=_nm;
				}else{
				//Response.write("<br />"+objar[i].columns[j]+"="+_nm);
				}
			}
			if (objar[i].columns[j].indexOf("_secterr")>0)
			{
			  grid+=_cellcomma+'"'+objar[i].columns[j]+'":"'+getTerr(q(objar[i].columns[j]))+'"';				
			}else{
			  grid+=_cellcomma+'"'+objar[i].columns[j]+'":"'+fixupJSON(undefinedToBlank(q(objar[i].columns[j])))+'"';
			}
			_cellcomma=",";
		}
		grid+='}';
		_rowcomma=',';
		if (u.columnsToTotalTime)
	    {
			_totals=addTime(_totals,undefinedToBlank(q(objar[i].columnsToTotalTime[0])));
	    }
		q.NextRecord();
	  }
	  if (u.columnsToTotal)////add in total columns
   	  {  
	    grid+="{";
	
		for (_col in allcolumns) {
			if (_col=="indexOf")//..weird bug
			{
				break;
			}
			var _totl="&nbsp;--";//+_col;
			
			if (totalsArray.hasOwnProperty(_col))
			{
				_totl=getProperty(totalsArray,_col);
				_totl=formatTotals(_totl);
			}
			rowClass="GRIDHEAD";			
			grid+=''+_totl+'';	
		}
		grid+="}";
	  }
	  grid+="]}";
	}
	return grid;
}

function formatTotals(val)
{
	var valn=new Number(val);
	valn=valn.toFixed(2);
	return numberWithCommas(valn);
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
function _getCompanyName(id)
{
	var _res="";

	if (id)
	{
		var _x=CRM.CreateQueryObj("select comp_name from company where comp_companyid="+id);
		_x.SelectSQL();
		if (!_x.eof)
		{
			_res=_x("comp_name");
		}
	}
	return _res;
}

function _getCurrencySign(val)
{
	var _res="no currency set!!!";
	var _s="select * from Currency where Curr_CurrencyID="+val;
	var _q=CRM.CreateQueryObj(_s);
	_q.SelectSQL();
	if (!_q.eof)
	{
		_res=_q("Curr_Symbol");
	}
	return _res;
}

function getTerr(val)
{
	var _res=val;;
	var _s="select * from Territories where Terr_TerritoryID="+val;
	var _q=CRM.CreateQueryObj(_s);
	_q.SelectSQL();
	if (!_q.eof)
	{
		_res=_q("Terr_Caption");
	}
	return _res;
}
function fixupJSON(val)
{
	val=val.replace('"','&quot;');
	val=val.replace('"','&quot;');
	val=val.replace('"','&quot;');
	val=val.replace('"','&quot;');
	val=val.replace('"','&quot;');
	val=val.replace('"','&quot;');
	val=val.replace('"','&quot;');
	val=val.replace('"','&quot;');
	
	val=val.replace(/\n/g,' ');
	val=val.replace(/\\/g,' ');	
	return val;
}
%>