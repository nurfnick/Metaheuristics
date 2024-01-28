reset;
option solver cplex;
option cplex_options 'sensitivity';

set bondName;
set govAndAg;


param numberBonds; #total number of bonds

param yearsToMaturity {bondName};
param afterTaxYield {bondName};
param qualityControl {bondName};
param beforeTaxYield {bondName};

var invest{bondName} >= 0;
var borrowedFunds >=0, <= 1000000;

maximize returnOnInvestment: sum {b in bondName} afterTaxYield[b]*invest[b]-.02175*borrowedFunds ;

subject to totalSumInvested: sum {b in bondName}invest[b] <= 10000000 +borrowedFunds;
subject to GovAndAg: sum {b in govAndAg}invest[b]>= 4000000;
subject to qualityControlAverageLinear: (sum {b in bondName} invest[b]*qualityControl[b]) -(1.4*(sum {b in bondName} invest[b]))<= 0;
subject to yearsToMaturityAverageLinear: (sum {b in bondName} invest[b]*yearsToMaturity[b])-(5*(sum{b in bondName} invest[b]))<= 0;
subject to municipalLimit: invest['A'] <= 3000000;

data group3_HW1_p5.dat;

solve;

display municipalLimit, municipalLimit.up, municipalLimit.down;

display borrowedFunds;