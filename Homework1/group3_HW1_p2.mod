reset;
option solver cplex
;

set bondName; #bond names as defined in the problem statement
set govAndAg; #bond types defined as agency and government


param numberBonds; #total number of bonds

param yearsToMaturity {bondName}; #years to maturity for each bond
param afterTaxYield {bondName}; #after tax yield for each bond
param qualityControl {bondName}; #quality scale ranking for each bond
param beforeTaxYield {bondName}; #before tax yield for each bond

var invest{bondName} >= 0;

maximize returnOnInvestment: sum {b in bondName} afterTaxYield[b]*invest[b];

subject to totalSumInvested: sum {b in bondName}invest[b] <= 10000000; #constraint that total investment amount cannot exceed ten million dollars
subject to GovAndAg: sum {b in govAndAg}invest[b]>= 4000000; #constraint that the sum of government and agency bonds must be equal to or greater than four million dollars
#subject to qualityControlAverage: (sum {b in bondName} invest[b]*qualityControl[b])/(numberBonds*(sum {b in bondName} invest[b]))<= 1.4;
#subject to yearsToMaturityAverage: (sum {b in bondName} invest[b]*yearsToMaturity[b])/(numberBonds*(sum{b in bondName} invest[b]))<= 5;
#subject to qualityControlAverageSimplified: (sum {b in bondName} invest[b]*qualityControl[b])/(numberBonds*10000000)<= 1.4;
#subject to yearsToMaturityAverageSimplified: (sum {b in bondName} invest[b]*yearsToMaturity[b])/(numberBonds*10000000)<= 5;
subject to qualityControlAverageLinear: (sum {b in bondName} invest[b]*qualityControl[b]) -(1.4*(sum {b in bondName} invest[b]))<= 0; #constraint that average quality of portfolio max not exceed 1.4
subject to yearsToMaturityAverageLinear: (sum {b in bondName} invest[b]*yearsToMaturity[b])-(5*(sum{b in bondName} invest[b]))<= 0; #constraint that average yield to maturity may not exceed 5 years

data group3_HW1_p2.dat; #connect to data file

solve;

printf "Solution: \n"; #print the return on investment and the total investment in each bond
printf "Return on Investment: %g\n", returnOnInvestment;
printf "Investment in Each Bond = \n";
display invest;

/*
display invest;
display returnOnInvestment;
display returnOnInvestment;
display totalSumInvested;
display GovAndAg;
display qualityControlAverageLinear;
display yearsToMaturityAverageLinear;*/

