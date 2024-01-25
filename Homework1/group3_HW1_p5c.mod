reset;
option solver cplex;

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
subject to qualityControlAverageLinear: (sum {b in bondName} invest[b]*qualityControl[b]) -(1.4*(sum {b in bondName} invest[b]))<= 0;
subject to yearsToMaturityAverageLinear: (sum {b in bondName} invest[b]*yearsToMaturity[b])-(5*(sum{b in bondName} invest[b]))<= 0;
subject to municipalLimit: invest['A'] <= 4000000;

data group3_HW1_p5.dat;

solve;

display invest;
display returnOnInvestment;
display totalSumInvested;
/*
display returnOnInvestment;
display totalSumInvested;
display GovAndAg;
display qualityControlAverageLinear;
display yearsToMaturityAverageLinear;*/