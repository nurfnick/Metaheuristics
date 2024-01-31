reset;

option solver cplex;

## Quality max of grapes

var A >= 0;
var B >=0;

maximize totalPounds: A +B;
subject to productionMaxA: A<= 2100000;
subject to productionMaxB: B<= 6300000;
subject to qualityPoints: 9*A +5*B >= 8*(A+B);

solve;

display A, B, totalPounds;