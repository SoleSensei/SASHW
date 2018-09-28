libname Orion "/folders/myfolders/Task2";

proc import file="/folders/myfolders/Task2/PRICES.xlsx"
		    out=Orion.PRICES
		    DBMS=XLSX
		    REPLACE;
run;

proc print data=Orion.PRICES (obs=5); run;

data work.price_increase; 
    set orion.prices;

    Year=1;    /* первый год */
    Unit_Price=Unit_Price * Factor; /* цена изменилась на Factor */
    output; /* выводим результаты для первого года */
    
    Year=2;    /* второй год */
    Unit_Price=Unit_Price * Factor; /* цена изменилась на Factor */
    output; /* выводим результаты для второго года */
    
    Year=3;    /* третий год */
    Unit_Price=Unit_Price * Factor; /* цена изменилась на Factor */
    output; /* выводим результаты для третьего года */
    
run;

proc print data=work.price_increase;    
    var Product_ID Unit_Price Year; 
run;

data work.admin work.stock work.purchasing;    
	set orion.employee_organization;
	if Department = 'Administration' then output work.admin;
	if Department = 'Stock & Shipping' then output work.stock;
	if Department = 'Purchasing' then output work.purchasing;
run;

/*  альтернативное решение */
data work.admin work.stock work.purchasing;   
    set orion.employee_organization;
    select (Department);
       when ('Administration')      output work.admin;
       when ('Stock & Shipping')    output work.stock;
       when ('Purchasing')          output work.purchasing;
       otherwise ;
     end;
run; 


data work.fast work.slow work.veryslow;
	set orion.orders;
	
	if Order_Type = '2' or Order_type = '3' then
	do;
		ShipDays = intck('day', Order_Date, Delivery_Date);
		output;
	end;
run;