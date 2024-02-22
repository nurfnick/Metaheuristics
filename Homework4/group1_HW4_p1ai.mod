reset;

option solver cplex;



set projects;

#param startDate{years,projects} default No;
#param returns{years, projects} default 0;
#param maxAmt{projects} default Infinity;
param risks{projects} default 0;

var amountInvested{a in projects} >=0; 

data group1_HW4_p1ai.dat;
									
maximize totalReturn: amountInvested['B'] + 1.4*amountInvested['E'] + 1.75*amountInvested['D'] + 1.06*amountInvested[3];
minimize risk: sum {a in projects} amountInvested[a]*risks[a];

subject to year1: amountInvested['A']+amountInvested['C']+amountInvested['D'] +amountInvested[1] = 1000000;
subject to year2: 0.3*amountInvested['A'] +1.1*amountInvested['C'] + 1.06*amountInvested[1] = amountInvested['B'] + amountInvested[2];
subject to year3: amountInvested['A'] + 0.3*amountInvested['B'] + 1.06*amountInvested[2] = amountInvested['E'] +amountInvested[3];


problem maxreturn: totalReturn, amountInvested, year1, year2, year3;
problem minrisk:  risk, amountInvested, year1, year2, year3;




#INDEPENDENT OBJECTIVES -------------------------------------------------
printf "\n\nINDEPENDENT OBJECTIVES -------------------------------------------------\n";

printf "\nMaximize Profit...........\n";
solve maxreturn;
display amountInvested, totalReturn, risk;

printf "\nMinimze Labor...........\n";
solve minrisk;
display amountInvested, totalReturn, risk;
 
