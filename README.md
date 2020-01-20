# Rapid-Item-Picker

Modal Screen on Quotes that allows you quickly add/update and remove quote items

This is designed to make creating quotes easier and quicker from Sage CRM.

Files are installed on the following folders:

    wwwroot/js/custom
  
  and
  
    wwwroot/custompages/ctItemPicker
  
A button group is created on Quotes Summary an a button added here also (after installing the component you need to reload metadata to see the button or restart IIS or recycle the CRM application pool). 

  Screen shot 

<img src="https://github.com/crmtogether/Rapid-Item-Picker/blob/master/RapidItemPicker.png" />


The component ZIP file is available from 
https://github.com/crmtogether/Rapid-Item-Picker/tree/master/src

===========================================================================

Sample SQL code used to mass populate the NewProduct table for testing ONLY
----SQL start
	Declare @Id int
	Set @Id = 1

	While @Id <= 1000
	Begin 
	 INSERT INTO NewProduct(
		prod_Active,prod_UOMCategory,prod_name,prod_code,prod_productfamilyid)
	 VALUES (
	   'Y',6002,'testb-' + CAST(@Id as nvarchar(10)),'cb' + CAST(@Id as nvarchar(10)),4)
	   Print @Id
	   Set @Id = @Id + 1
	End
----SQL end

