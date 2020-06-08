//Last update 8 June 2020

ObjectName='CRMTogetherOS';
ObjectType='TabGroup';
EntityName='system';
var CObjId10869 = AddScreenObject();

var TabsId11081 = AddCustom_Tabs(0,0,11,'Admin','CRM Together OS','customfile','CRMTogetherOS/admin.asp','','waves.gif',0,'',false,0);

var TabsId11082 = AddCustom_Tabs(0,0,1,'CRMTogetherOS','Home','customfile','CRMTogetherOS/admin.asp','','',0,'',false,0);

var TabsId11083 = AddCustom_Tabs(0,0,2,'CRMTogetherOS','Rapid Item Picker','customfile','ctItemPicker/ctItemPicker.asp','','',0,'',false,0);

//copy files
var CRMTogetherOS="CRMTogetherOS";
CreateNewDir(GetDLLDir() + '\\CustomPages\\' + CRMTogetherOS);
CopyASPTo(CRMTogetherOS+'\\admin.asp','\\CustomPages\\'+CRMTogetherOS+'\\admin.asp');
CopyASPTo(CRMTogetherOS+'\\sagecrm.js','\\CustomPages\\'+CRMTogetherOS+'\\sagecrm.js');
CopyASPTo(CRMTogetherOS+'\\sagecrmnolang.js','\\CustomPages\\'+CRMTogetherOS+'\\sagecrmnolang.js');


var ctItemPicker="ctItemPicker";
CreateNewDir(GetDLLDir() + '\\CustomPages\\' + ctItemPicker);
CopyASPTo(ctItemPicker+'\\addQuoteItem.asp','\\CustomPages\\'+ctItemPicker+'\\addQuoteItem.asp');
CopyASPTo(ctItemPicker+'\\content.asp','\\CustomPages\\'+ctItemPicker+'\\content.asp');
CopyASPTo(ctItemPicker+'\\crmconst.js','\\CustomPages\\'+ctItemPicker+'\\crmconst.js');
CopyASPTo(ctItemPicker+'\\crmwizard.js','\\CustomPages\\'+ctItemPicker+'\\crmwizard.js');
CopyASPTo(ctItemPicker+'\\crmwizardnolang.js','\\CustomPages\\'+ctItemPicker+'\\crmwizardnolang.js');
CopyASPTo(ctItemPicker+'\\currency_inc.asp','\\CustomPages\\'+ctItemPicker+'\\currency_inc.asp');
CopyASPTo(ctItemPicker+'\\custom_sysparams_inc.asp','\\CustomPages\\'+ctItemPicker+'\\custom_sysparams_inc.asp');
CopyASPTo(ctItemPicker+'\\deleteQuoteItem.asp','\\CustomPages\\'+ctItemPicker+'\\deleteQuoteItem.asp');
CopyASPTo(ctItemPicker+'\\getQuoteTotals.asp','\\CustomPages\\'+ctItemPicker+'\\getQuoteTotals.asp');
CopyASPTo(ctItemPicker+'\\json_engine.js','\\CustomPages\\'+ctItemPicker+'\\json_engine.js');
CopyASPTo(ctItemPicker+'\\json_footer.js','\\CustomPages\\'+ctItemPicker+'\\json_footer.js');
CopyASPTo(ctItemPicker+'\\json_header.js','\\CustomPages\\'+ctItemPicker+'\\json_header.js');
CopyASPTo(ctItemPicker+'\\pricing_inc.asp','\\CustomPages\\'+ctItemPicker+'\\pricing_inc.asp');
CopyASPTo(ctItemPicker+'\\pricinglist_inc.asp','\\CustomPages\\'+ctItemPicker+'\\pricinglist_inc.asp');
CopyASPTo(ctItemPicker+'\\product_family_inc.asp','\\CustomPages\\'+ctItemPicker+'\\product_family_inc.asp');
CopyASPTo(ctItemPicker+'\\product_family_json.asp','\\CustomPages\\'+ctItemPicker+'\\product_family_json.asp');
CopyASPTo(ctItemPicker+'\\product_inc.asp','\\CustomPages\\'+ctItemPicker+'\\product_inc.asp');
CopyASPTo(ctItemPicker+'\\product_inc_ajax.asp','\\CustomPages\\'+ctItemPicker+'\\product_inc_ajax.asp');
CopyASPTo(ctItemPicker+'\\quote_inc.asp','\\CustomPages\\'+ctItemPicker+'\\quote_inc.asp');
CopyASPTo(ctItemPicker+'\\quoteitems_inc.asp','\\CustomPages\\'+ctItemPicker+'\\quoteitems_inc.asp');
CopyASPTo(ctItemPicker+'\\readme.txt','\\CustomPages\\'+ctItemPicker+'\\readme.txt');
CopyASPTo(ctItemPicker+'\\uom_family_inc.asp','\\CustomPages\\'+ctItemPicker+'\\uom_family_inc.asp');
CopyASPTo(ctItemPicker+'\\uom_byfam_inc.asp','\\CustomPages\\'+ctItemPicker+'\\uom_byfam_inc.asp');
CopyASPTo(ctItemPicker+'\\uom_inc.asp','\\CustomPages\\'+ctItemPicker+'\\uom_inc.asp');
CopyASPTo(ctItemPicker+'\\updateQuoteItem.asp','\\CustomPages\\'+ctItemPicker+'\\updateQuoteItem.asp');
CopyASPTo(ctItemPicker+'\\updateQuoteItempos.asp','\\CustomPages\\'+ctItemPicker+'\\updateQuoteItempos.asp');

CopyASPTo(ctItemPicker+'\\sagecrmnolang.js','\\CustomPages\\'+ctItemPicker+'\\sagecrmnolang.js');
CopyASPTo(ctItemPicker+'\\sagecrm.js','\\CustomPages\\'+ctItemPicker+'\\sagecrm.js');
CopyASPTo(ctItemPicker+'\\ctItemPicker.asp','\\CustomPages\\'+ctItemPicker+'\\ctItemPicker.asp');

CopyASPTo('\\js\\custommodal.css','\\js\\custom\\custommodal.css');
CopyASPTo('\\js\\custommodal.js','\\js\\custom\\custommodal.js');
CopyASPTo('\\js\\ctItemPicker.js','\\js\\custom\\ctItemPicker.js');

﻿
ObjectName='BGQuotesReport';
ObjectType='ButtonGroup';
EntityName='system';
Properties='Action=1469';
var CObjId10739 = AddScreenObject();

var TabsId10851 = AddCustom_Tabs(0,0,1,'BGQuotesReport','Rapid Item Picker','customurl','javascript:custommodalitems();','','',0,'',false,0,'1');




