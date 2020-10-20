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

===========================================================================

Example SQL for Product Families displayed..note you must change the quot_orderquoteid value to your value
----SQL start

SELECT TOP 51  prfa_productfamilyid, prfa_name FROM ProductFamily 
		WHERE (prfa_name LIKE N'%' ESCAPE '|' OR COALESCE(prfa_name, N'') = N'') 
		and prfa_Deleted is Null and  prfa_active = N'Y'AND  
		prfa_productfamilyid IN (select prod_productfamilyid from newproduct where prod_productid  
		in(select pric_productid from pricing WHERE pric_deleted IS NULL AND pric_pricinglistid  
		=(select quot_pricinglistid from quotes where quot_orderquoteid = 11 and pricing.pric_price_cid = quotes.quot_currency)))  
		order by prfa_name
----SQL end


===========================================================================
How product matching works!

How the matching works is that it checks if the string exists in the product name. At any point. That’s it. So its always a LIKE and you don’t need to put in the % or *. 

