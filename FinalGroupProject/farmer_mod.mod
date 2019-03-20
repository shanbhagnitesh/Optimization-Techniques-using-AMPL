# Deterministic farmer problem

set CROPS1;
set CROPS2;
set CROPS3;
set CROPSu := CROPS1 union CROPS2;
set CROPS := CROPSu union CROPS3;
set CROPSq := CROPS2 union CROPS3; 

param prod {CROPS} >= 0;				# productivity T/Ha
param cplant {CROPS} >= 0;				# production cost(€/Ha)
param min_cattle {CROPS1} >= 0;				# required minimum quantity for cattle feed
param psale {CROPS1} >= 0;				# sale price (€/T)
param pbuy {CROPS1} >= 0;				# purchase price (€/T)
param pvbelow >= 0;					# sugar sale price below 6000 T 
param pvabove >= 0;					# sugar sale price above 6000 T 
param potbelow >= 0;					# potato sale price below 5000 T 
param potabove >= 0;					# potato sale price above 5000 T 
param u >= 0;
param v >= 0;						# 0 if potato is grown 
param mprice {CROPS} >= 0;                 		# cost of maintaince of crops
param tax {CROPS} >= 0;                 		# cost of maintaince of crops

param terra_total >= 0;

var x {i in CROPS} >= 0;
var w {i in CROPS1} >= 0;
var y {i in CROPS1} >= 0;
var wbelow {i in CROPS2} >= 0;
var wabove {i in CROPS2} >= 0;
var wzbelow {i in CROPS3} >= 0;
var wzabove {i in CROPS3} >= 0;


minimize Total_cost: 
 sum {i in CROPS} cplant[i] * x[i]
 + sum {i in CROPS1} (pbuy[i] * y[i]- psale[i] * w[i])
   + sum{i in CROPS} (mprice[i]*x[i]) 
                + sum{i in CROPS1} (tax[i]*w[i])+ sum{i in CROPS2}(u)*(tax[i]*(wbelow[i]+wabove[i]))+ sum{i in CROPS3}(v)*(tax[i]*(wzbelow[i]+wzabove[i])) 
     - sum {i in CROPS2} (u)*(pvbelow * wbelow[i] + pvabove *wabove[i]) 
             - sum {i in CROPS3} (v)*(potbelow * wzbelow[i] + potabove *wzabove[i]);


subject to Total_land:
	sum {i in CROPS1} x[i]+ u*(sum {i in CROPS2} x[i])+(v)*(sum {i in CROPS3} x[i])  <= terra_total;

subject to Min_cattle {i in CROPS1}:
	prod[i]*x[i]+y[i]-w[i] >= min_cattle[i];

subject to Regulated_production_1 {i in CROPS2}:
	wbelow[i]+wabove[i] <= prod[i]*x[i];

subject to Regulated_production_2 {i in CROPS3}:
	wzbelow[i]+wzabove[i] <= prod[i]*x[i];

subject to Regulated_production_3 {i in CROPS2}:
	wbelow[i] <= 6000;

subject to Regulated_production_4 {i in CROPS3}:
	wzbelow[i] <= 5000;

subject to Regulated_production_5 :
	sum {i in CROPSq} x[i] >= 75 ;


	




