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
var extraA{products} >=0;


var totalProduct{p in products} = (sum{g in grapeQuality} weight[p,g]+extraA[p])/poundsPerProduct[p];

maximize marginalProfit: sum{p in products} 
						((sellingPrice[p]-variableCost[p])*totalProduct[p]
						-
						sum{q in grapeQuality} weight[p,q]*fruitCost[q]
						- 0.5*extraA[p]);
						
subject to qualityControl {p in products}: sum {q in grapeQuality} rating[q]*weight[p,q]+9*extraA[p]>= quality[p]*(sum {q in grapeQuality}weight[p,q]+extraA[p]) ;
subject to weightLimit {q in grapeQuality}: sum {p in products} weight[p,q] <= totalWeight[q];
subject to demandRestrictions {p in products}: totalProduct[p] <= maxDemand[p];
subject to extraGrapes: sum {p in products} extraA[p] <= 300000;

data group1_HW2_p1c.dat;

solve;


display weight;
display extraA;
display weightLimit;
display extraGrapes;

