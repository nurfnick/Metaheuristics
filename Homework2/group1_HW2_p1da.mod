reset;

option solver cplex;
option cplex_options 'sensitivity';

set products;
set grapeQuality;

param quality{products};
param poundsPerProduct{products};
param variableCost{products};
param sellingPrice{products};
param fruitCost{grapeQuality};
param totalWeight{grapeQuality};
param rating{grapeQuality};
param maxDemand{products} default Infinity;

var weight{p in products,q in grapeQuality} >=0;


var totalProduct{p in products} = (sum{g in grapeQuality} weight[p,g])/poundsPerProduct[p];

maximize marginalProfit: sum{p in products} 
						((sellingPrice[p]-variableCost[p])*(sum{g in grapeQuality} weight[p,g])/poundsPerProduct[p]
						-
						sum{q in grapeQuality} weight[p,q]*fruitCost[q]);
						
subject to qualityControl {p in products}: sum {q in grapeQuality} rating[q]*weight[p,q]>= quality[p]*(sum {q in grapeQuality}weight[p,q]) ;
subject to weightLimit {q in grapeQuality}: sum {p in products} weight[p,q] <= totalWeight[q];
subject to demandRestrictions {p in products}: (sum{g in grapeQuality} weight[p,g])/poundsPerProduct[p] <= maxDemand[p];

data group1_HW2_p1c.dat;

solve;

printf "\n Shadow Price of Weight Limit\n";
display weightLimit, weightLimit.up, weightLimit.down;
