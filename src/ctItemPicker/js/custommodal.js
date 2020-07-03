/*
to implement this make a copy of the function below (dont use the same method name though) and add in a custom button (using crm's client api or buttongroups and call the method filling the model with what you want displayed. 
From a buttongroup your would call this like this

  javascript:custommodalmethod();
*/
var customModalCloseEvent=null;

function custommodalmethod()
{
	console.log("custommodalitems");
	var custommodal = document.getElementById('customModal');
	
	//your code here......
	
	
	//show the modal
	custommodal.style.display = "block";
}

$(document).ready(function () {
	console.log("custommodal.js loading...");
	
	var _url = new String(document.location.href);
    _url = _url.toLowerCase();
    var _installName = crm.installName();
    if (_installName == "interactivedashboard") {
        return;
    }
    //366=meeting planner
    if (_url.indexOf("=366&") > 0) {
        return;
    }
    var _csspath = "../js/custom/custommodal.css";

    if (_url.indexOf("custompages") > 0)//for custom asp pages
    {
        _csspath = "/" + crm.installName() + "/js/custom/custommodal.css";
	}
	console.log(_csspath);
    $('head').append('<link rel="stylesheet" type="text/css" href="' + _csspath + '" >');
	var modal_text='<div id="customModal" class="custommodal">'+
					'<!-- Modal content -->'+
					'  <div class="custommodal-content">'+
					'  	  <div id="custommodalheaderid" class="custommodal-header">'+
					'  		<span class="customclose">&times;</span>'+
					'  		<h2>custommodal-header</h2>'+
					'  	</div>'+
					'  	<div class="custommodal-body">'+
					'  		<p>Some text in the Modal Body</p>'+
					'  		<p>Some other text...</p>'+
					'  	 </div>'+
					'  	 <div id="custommodalfooterid" class="custommodal-footer">'+
					'  		<h3>custommodal-footer</h3>'+
					'  	 </div>'+
					'  </div>'+
					'</div>';
	$('body').append(modal_text);
	
	var custommodal = document.getElementById('customModal');
	var span = document.getElementsByClassName("customclose")[0];
	span.onclick = function() {
		custommodal.style.display = "none";
		window.onclick = function(event) {
		  var custommodal = document.getElementById('customModal');
		  if (event.target == custommodal) {
			  var custommodal = document.getElementById('customModal');
			  custommodal.style.display = "none";
		  }
		}
		if (customModalCloseEvent!=null)
		{
			customModalCloseEvent();
		}
		console.log("custommodal.js unloaded");
	}
});

function setcustommodalheader(val)
{
	$('#custommodalheaderid h2').text(val);
}
function setcustommodalfooter(val)
{
	$('#custommodalfooterid h3').text(val);
}