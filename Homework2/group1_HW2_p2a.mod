reset;

option solver cplex;


set years;
set projects;

param startDate{years,projects} default No;

var amountInvested{y in years, a in projects} >=0 