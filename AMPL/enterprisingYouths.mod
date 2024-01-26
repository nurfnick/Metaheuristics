#AMPL model for "Enterprising Youths" problem DSA/ISE 5113

reset;

#OPTIONS -------------------------------------
option solver cplex;
option cplex_options 'sensitivity';



#PARAMETERS AND SETS --------------------------

set I;  # set of items to be pilfered

param v{I} >=0;    #value of item
param w{I} >=0;    #weight of item
param k{I} >=0;    #weight of item
param vol{I} >=0;  #volume of item
param a{I} >=0;    #availability of item

param WEIGHT >=0;  #max weight
param VOLUME >=0;  #max volume


#DECISION VARIABLES ----------------------------
var x{I} >=1;  #number of each item to be pilfered


#OBJECTIVE --------------------------------------
maximize profit: sum{i in I} v[i]*x[i];


#CONSTRAINTS ------------------------------------
subject to weight_limit: sum{i in I} w[i]*x[i] <= WEIGHT;
subject to volume_limit: sum{i in I} vol[i]*x[i] <= VOLUME;
subject to availability {i in I}: x[i] <= a[i];


#DATA ------------------------------------------
data EnterprisingYouths.dat;

#COMMANDS --------------------------------------
solve;

display x;
display weight_limit, weight_limit.up, weight_limit.slack;
display volume_limit, volume_limit.up, volume_limit.slack;
display availability,availability.up,availability.down, availability.slack;


