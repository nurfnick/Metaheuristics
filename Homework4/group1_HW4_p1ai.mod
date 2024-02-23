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
 

 #SCALARIZATION -------------------------------------------------
printf "\n\nSCALARIZATION -------------------------------------------------\n";
param gamma1; 
param gamma2;


#SCALARIZED OBJECTIVE (a.k.a., weighted sum)
maximize objWeightedSum:  (gamma1 * (amountInvested['B'] + 1.4*amountInvested['E'] + 1.75*amountInvested['D'] + 1.06*amountInvested[3]) 
			- gamma2 * (sum{i in projects} amountInvested[i]*risks[i]));

problem maxScalarized: objWeightedSum, amountInvested, year1, year2, year3; 


printf "\n\nMultiple values for SCALARIZATION -------------------------------------------------\n";
for {k in 0..4} {
	let gamma1 := k/4;
	let gamma2 := 1 - gamma1;
     
    solve maxScalarized;
   
    printf "\n\ngamma1 = %6.2f; gamma2 = %6.2f \n", gamma1, gamma2; 
    printf "Optimal solution values: A = %6.2f   B = %6.2f C= %6.2f D= %6.2f E= %6.2f 1= %6.2f 2= %6.2f 3= %6.2f\n", 
    		amountInvested['A'], amountInvested['B'], amountInvested['C'], amountInvested['D'], amountInvested['E'], amountInvested[1], amountInvested[2], amountInvested[3]; 
	printf "Return generated: %6.2f\n",  totalReturn; 
	printf "Risk Faced: %6.2f \n\n", risk ;
    printf "%d, %3.2f, %3.2f, %7.4f,%7.4f,%7.4f,%7.4f,%7.4f,%7.4f,%7.4f, %7.4f, %7.4f, %7.4f\n", k, gamma1, gamma2, 
    		amountInvested['A'], amountInvested['B'], amountInvested['C'], amountInvested['D'], amountInvested['E'], 
    		amountInvested[1], amountInvested[2], amountInvested[3], totalReturn, risk > "titanParetoS.txt";
}


#EPSILON-CONSTRAINT
printf "\n\EPSILON-CONSTRAINT METHOD ---------------------------------------------\n";

#get upper and lower bounds for objectives
param upperRisk;
param lowerRisk;

#in this example, put Profits as the objective function and use epsilon contstraints on the labor

#Let's get the lower and upper bounds for labor values by solving the independent problems
solve minrisk;
let lowerRisk:= risk;

solve maxreturn;
let upperRisk:= risk;

param epsilon;
let epsilon := lowerRisk;

s.t. epsilsonRisk: sum {a in projects} amountInvested[a]*risks[a] <= epsilon;
problem epsConst:  totalReturn, amountInvested, year1, year2, year3, epsilsonRisk; 

param steps = 20;

printf "\n\nMultiple values for EPSILON-CONSTRAINT -------------------------------------------------\n";
for {eps in 0..steps} {
	
	let epsilon := lowerRisk + eps*(upperRisk - lowerRisk)/(steps);
	solve epsConst;
	
	display epsilon, totalReturn, risk;
	
	printf "%d, %7.4f, %7.4f, %7.4f\n", eps, epsilon, totalReturn, risk > "titanParetoEps.txt";
	
}
