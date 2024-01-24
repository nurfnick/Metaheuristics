reset;
option solver cplex
;

set bondName;
set govAndAg;


param numberBonds; #total number of bonds

param yearsToMaturity {bondName};
param afterTaxYield {bondName};
param qualityControl {bondName};
param beforeTaxYield {bondName};

var invest{bondName} >= 0;

maximize returnOnInvestment: sum {b in bondName} afterTaxYield[b]*invest[b];

subject to totalSumInvested: sum {b in bondName}invest[b] <= 10000000;
subject to GovAndAg: sum {b in govAndAg}invest[b]>= 4000000;
#subject to qualityControlAverage: (sum {b in bondName} invest[b]*qualityControl[b])/(numberBonds*(sum {b in bondName} invest[b]))<= 1.4;
#subject to yearsToMaturityAverage: (sum {b in bondName} invest[b]*yearsToMaturity[b])/(numberBonds*(sum{b in bondName} invest[b]))<= 5;
#subject to qualityControlAverageSimplified: (sum {b in bondName} invest[b]*qualityControl[b])/(numberBonds*10000000)<= 1.4;
#subject to yearsToMaturityAverageSimplified: (sum {b in bondName} invest[b]*yearsToMaturity[b])/(numberBonds*10000000)<= 5;
subject to qualityControlAverageLinear: (sum {b in bondName} invest[b]*qualityControl[b]) -(1.4*(sum {b in bondName} invest[b]))<= 0;
subject to yearsToMaturityAverageLinear: (sum {b in bondName} invest[b]*yearsToMaturity[b])-(5*(sum{b in bondName} invest[b]))<= 0;

data group3_HW1_p2.dat;

solve;

display invest;
display returnOnInvestment;
/*
display returnOnInvestment;
display totalSumInvested;
display GovAndAg;
display qualityControlAverageLinear;
display yearsToMaturityAverageLinear;*/

