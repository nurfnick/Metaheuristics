reset;

# number of months in the planning horizon
param MONTHS;
# inventory holding cost per unit per month
param ic;
# cost of producing one ton in month i
param c {1 .. MONTHS};
# tons of product needed in month i
param d {1 .. MONTHS};

#DECISION VARIABLES
# tons produced in month i
# nonnegativity and max production limits
var P {1 .. MONTHS} >= 0, <= 4000;
# tons in inventory at the end of month I
# nonnegativity constraints
var I {0 .. MONTHS} >= 0;

#OBJECTIVE
#minimize production and inventory costs
minimize cost:
sum{i in 1..MONTHS} (c[i]*P[i] + ic*I[i]);
#CONSTRAINTS
#flow-balance constraint
subject to inventory {i in 1..MONTHS}:
P[i] + I[i-1] = I[i] + d[i];
subject to initial_inventory: I[0] = 1000;
subject to final_inventory: I[MONTHS] = 1500; 

data;
param MONTHS := 4;
param ic := 120;
param c :=
1 7400
2 7500
3 7600
4 7800;
param d :=
1 2400
2 2200
3 2700
4 2500 ;

solve;

display P;
display I;