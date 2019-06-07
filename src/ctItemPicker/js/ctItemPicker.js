function custommodalitems()
{
	console.log("custommodalitems");
	
	var _url=crm.url('../custompages/ctitempicker/content.asp');
	console.log("_url:"+_url);
    $('.custommodal-body').load(_url,function(){
		var custommodal = document.getElementById('customModal');
        custommodal.style.display = "block";
    });
}