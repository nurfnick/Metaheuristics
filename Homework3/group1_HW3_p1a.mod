#Homework 3 Problem 1 Part A - Group 1

reset;
option solver cplex;


#define the sets and parameters
set Nodes;
set Arcs within {i in Nodes, j in Nodes};
param compatibilityScores{i in Nodes, j in Nodes} >= 0; #compatibility must be greater than or equal to zero

#define decision variables
var networkFlow {Arcs} >= 0, <= 1;
var totalCompatibility;

#define objective function
maximize compatibilityPairs: sum {(i,j) in Arcs} compatibilityScores[i,j] * networkFlow[i,j];

#define constraints
subject to onePairing {i in Nodes}: sum {(i,j) in Arcs} networkFlow[i,j] = 1; #only one pairing for each node is possible
subject to netZero {i in Nodes}:sum {(i,j) in Arcs} networkFlow[i,j] - sum {(j,i) in Arcs} networkFlow[j,i] = 0; #constraint that flow in must equal flow out of each node

#connect to the data file
data Desktop/AMPL/group1_HW3_p1a.dat;

#solve to maximize objective function
solve;

#print the results
printf "Total Compatibility Score: %f\n", totalCompatibility;
printf "Pairs:\n";
for {(i,j) in Arcs: networkFlow[i,j] > 0} {
    printf "%s - %s\n", i, j;
}

/*
1: Rick
2: Negan
3: Carl
4: Glenn
5: Maggie
6: Michonne
7: Daryl
8: Shane
*/
