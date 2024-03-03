

reset;

option solver cplex;


param H > 0;
let H := 10;

set animals;
set edges within {animals,animals};



var x{animals,1..H} binary;
var w{1..H} binary;

minimize exhibits: sum{i in 1..H} w[i];
subject to homeForAll {a in animals}: sum{i in 1..H} x[a,i] = 1;
subject to edgeConstraint {(u,v) in edges, i in 1..H}:  x[u,i]+x[v,i]<= w[i];

data group_HW5_p2.dat;

solve;

display x, w;
