#DSA/ISE 5113 Integer Programming
#Example IP: oil exploration

#Find least-cost selection of 5 out of 10 possible sites 

reset;

#OPTIONS -----------------------------------------------------
option solver cplex;


#SETS AND PARAMETERS -----------------------------------------
set tanks = 1..8;
set types;
param cost{types,tanks};
param cap{tanks};
param g{types};

#DECISION VARIABLES ------------------------------------------
var delta{types, tanks} binary;     #pump type into tank?
var x{types, tanks} >=0; #volume moved in 1000L


#OBJECTIVE ---------------------------------------------------
minimize totalCost: sum{a in types, i in tanks} cost[a,i]*x[a,i];

#CONSTRAINTS -------------------------------------------------

#one type fuel in each tank
s.t. oneTypePerTank {i in tanks}: sum {a in types} delta[a,i] <= 1;

#enough storage
s.t. storage {a in types}: sum { i in tanks} cap[i]*delta[a,i]>= g[a];

#don't overfill
s.t. overfill {i in tanks}: sum {a in types} 1000*x[a,i]<=cap[i];

#placeall fuel
s.t. placefuel {a in types}: sum{i in tanks} 1000*x[a,i] = g[a];

#announce the tank has been taken
s.t. announce {i in tanks, a in types}: x[a,i]<=g[a]*delta[a,i];
s.t. announce2 {i in tanks, a in types}: x[a,i]>= delta[a,i];


data;
set types:= A	B	C	D	E;

param cost: 	1	2	3	4	5	6	7	8 := 
		A		1	2	2	1	4	4	5	3
		B		2	3	3	3	1	4	5	2
		C		3	4	1	2	1	4	5	1
		D		1	1	2	2	3	4	5	2
		E		1	1	1	1	1	1	5	5
;

param g:=
	A	75000
	B	50000
	C	25000
	D	80000
	E	20000;
	
param cap:=
	1	25000
	2	25000
	3	30000
	4	60000	
	5	80000
	6	85000	
	7	100000
	8	50000;
	
solve;
display x, delta;