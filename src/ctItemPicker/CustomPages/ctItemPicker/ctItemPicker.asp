<!-- #include file ="sagecrm.js" -->
<%

var forReading = 1, forWriting = 2, forAppending = 8;
var newline="<br>";
var newlinetext="\n";

var CurrentUser=CRM.GetContextInfo("user", "User_logon");
CurrentUser=CurrentUser.toLowerCase();
var CurrentUserName=CRM.GetContextInfo("user", "User_firstname");
var CurrentUserEmail=CRM.GetContextInfo("user", "User_emailaddress");

Container=CRM.GetBlock("container");
Container.DisplayButton(Button_Default) =false;
Container.DisplayForm = true;

content=eWare.GetBlock('content');
content.contents = newline+"Hi "+CurrentUserName;
content.contents +=newline+"Welcome to the CRM Together Open Source page for the <b>Rapid Item Picker</b>.";
content.contents +=newline+"This will add a button to your CRM Quotes summary page.";
content.contents +=newline+"When this button is clicked it opens a modal window.";
content.contents +=newline+"This modal window provides users with a better experience in creating quotes.";
content.contents +=newline+"Regards";
content.contents +=newline+"The CRM Together Open Source Team"+newline+newline;

Container.AddBlock(content);
	 
btnSend = eWare.Button("Email CRM Together", "", "mailto:sagecrm@crmtogether.com?subject=CRM Together Rapid Item Picker");
Container.AddButton(btnSend);

CRM.AddContent(Container.Execute());

Response.Write(CRM.GetPage('CRMTogetherOS'));

%>
