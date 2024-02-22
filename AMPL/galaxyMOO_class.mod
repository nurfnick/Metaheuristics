#Galaxy Industries Linear Programming Problem - Multiple Objective Approaches

reset;

#OPTIONS
option solver cplex;


#SETS AND PARAMETERS -----------------------------------------
set PRODUCTS;  #space rays and zappers

param profit{PRODUCTS} >=0;
param labor{PRODUCTS} >=0;
param plastic{PRODUCTS} >=0;
param mix{PRODUCTS};

param PlasticSupply >=0;
param LaborSupply >=0;
param ProductionLimit >=0;
param ManagementMix;

#DATA --------------------------------------------------------
data galaxyMOO.dat;

#DECISION VARIABLES
var x{PRODUCTS} >=0; #number of SpaceRay guns to manufacture

#OBJECTIVES ---------------------------------------------------
maximize objProfits:        sum{i in PRODUCTS} profit[i] * x[i];
minimize objLabor: 		    sum{i in PRODUCTS}  labor[i] * x[i];

#CONSTRAINTS -------------------------------------------------
#constraints
subject to Plastic:     sum{i in PRODUCTS} plastic[i] * x[i] <= PlasticSupply;
subject to Labor:       sum{i in PRODUCTS} labor[i] * x[i] <= LaborSupply;
subject to Production:  sum{i in PRODUCTS} x[i] <= ProductionLimit;
subject to Management:  sum{i in PRODUCTS} mix[i]*x[i] <= ManagementMix;

#PROBLEMS
problem maxProfit: objProfits, x, Plastic, Labor, Production, Management; 
problem minLabor:   objLabor, x, Plastic, Labor, Production, Management; 


#INDEPENDENT OBJECTIVES -------------------------------------------------
printf "\n\nINDEPENDENT OBJECTIVES -------------------------------------------------\n";

printf "\nMaximize Profit...........\n";
solve maxProfit;
display x, objProfits, objLabor;

printf "\nMinimze Labor...........\n";
solve minLabor;
display x, objProfits, objLabor;


#PREMPTIVE OPTIMIZATION -------------------------------------------------
printf "\n\nPREMPTIVE OPTIMIZATION -------------------------------------------------\n";

param optimalValue;

#using PROFIT as the 1st priority

printf "\nOptimize first priority...\n";
solve maxProfit;
let optimalValue := objProfits;
s.t. stayOptProfit: sum{i in PRODUCTS} profit[i] * x[i] >= optimalValue;

printf "\nOptimize second priority subject to bounds on first...\n";
problem minLabor_2: objLabor, x, Plastic, Labor, Production, Management, stayOptProfit;
solve minLabor_2;
display x, objProfits, objLabor;


#using LABOR as the 1st priority
printf "\nOptimize first priority...\n";
solve minLabor;
let optimalValue := objLabor;
s.t. stayOptLabor: sum{i in PRODUCTS} labor[i] * x[i] <= optimalValue;

printf "\nOptimize second priority subject to bounds on first...\n";
problem maxProfit_2: objProfits, x, Plastic, Labor, Production, Management, stayOptLabor;
solve maxProfit_2;
display x, objProfits, objLabor;



#SCALARIZATION -------------------------------------------------
printf "\n\nSCALARIZATION -------------------------------------------------\n";
param gamma1; 
param gamma2;


#SCALARIZED OBJECTIVE (a.k.a., weighted sum)
maximize objWeightedSum: sum{i in PRODUCTS} (gamma1 * (profit[i] * x[i]) - gamma2 * (labor[i] * x[i]));

problem maxScalarized: objWeightedSum, x, Plastic, Labor, Production, Management; 


printf "\n\nMultiple values for SCALARIZATION -------------------------------------------------\n";
for {k in 0..10} {
	let gamma1 := k/10;
	let gamma2 := 1 - gamma1;
     
    solve maxScalarized;
   
    printf "\n\ngamma1 = %6.2f; gamma2 = %6.2f \n", gamma1, gamma2; 
    printf "Optimal solution values: SR = %6.2f   Z = %6.2f \n", x['SR'], x['Z']; 
	printf "Profit generated: %6.2f\n",  objProfits; 
	printf "Labor used: %6.2f \n\n", objLabor ;
    printf "%d, %3.2f, %3.2f, %7.4f, %7.4f, %7.4f, %7.4f\n", k, gamma1, gamma2, x['SR'], x['Z'], objProfits, objLabor > "galaxyParetoS.txt";
}





#EPSILON-CONSTRAINT
printf "\n\EPSILON-CONSTRAINT METHOD ---------------------------------------------\n";

#get upper and lower bounds for objectives
param upperLabor;
param lowerLabor;

#in this example, put Profits as the objective function and use epsilon contstraints on the labor

#Let's get the lower and upper bounds for labor values by solving the independent problems
solve minLabor;
let lowerLabor:=objLabor;

solve maxProfit;
let upperLabor:=objLabor;

param epsilon;
let epsilon := lowerLabor;

s.t. epsilsonLabor:  sum{i in PRODUCTS} labor[i] * x[i] <= epsilon;
problem epsConst:  objProfits, x, Plastic, Labor, Production, Management, epsilsonLabor; 

param steps = 50;

printf "\n\nMultiple values for EPSILON-CONSTRAINT -------------------------------------------------\n";
for {eps in 0..steps} {
	
	let epsilon := lowerLabor + eps*(upperLabor - lowerLabor)/(steps+1);
	solve epsConst;
	
	display x, epsilon, objProfits, objLabor;
	
	printf "%d, %7.4f, %7.4f, %7.4f\n", eps, epsilon, objProfits, objLabor > "galaxyParetoEps.txt";
	
}
