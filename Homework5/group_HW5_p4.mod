reset;

option solver cplex;

set toys;

param revenue{toys};
param plastic{toys};
param labor{toys};
param maxplastic;
param maxlabor;
param maxproduct;

var produce{toys}>= 0 integer;
var sr1 >=0;
var sr2 >=0;
var sr3 >=0;
var sr4 >=0;
var srb1 binary;
var srb2 binary;
var srb3 binary;
var z1 >=0;
var z2 >=0;
var z3 >=0;
var zb1 binary;
var zb2 binary;


maximize profit: sum{t in toys} revenue[t]*produce[t] - (1.5*sr1 +1.05*sr2+0.95*sr3+0.75*sr4)
														-(1.05*z1 +0.75*z2+1.5*z3);
													
s.t. plasticConstraint: sum{t in toys} produce[t]*plastic[t] <= maxplastic;
s.t. labourConstraint: sum{t in toys} produce[t]*labor[t] <= maxlabor;
s.t. totalProduction: sum{t in toys} produce[t] <= maxproduct;
s.t. balanceProduction: produce['SR']<= produce['Z'] + 350;

s.t. sr: produce['SR'] = sr1 + sr2+ sr3+sr4;

s.t. piece1aSR:  125*srb1 <= sr1;
s.t. piece1bSR: sr1 <= 125;

s.t. piece2aSR: 100*srb2 <= sr2;
s.t. piece2bSR: sr2 <= 100*srb1; 

s.t. piece3aSR:  150*srb3<= sr3;
s.t. piece3bSR: sr3<= 150* srb2;

s.t. piece4SR: sr4<=srb3*700;

s.t. z: produce['Z'] = z1 + z2+ z3;

s.t. piece1aZ:  50*zb1 <= z1;
s.t. piece1bZ: z1<= 50;

s.t. piece2aZ: 75*zb2 <= z2;
s.t. piece2bZ: z2<= 75*zb1;

s.t. piece3Z: z3<= 700*zb2;

data group_HW5_p4.dat;

solve;


display produce, sr1, sr2, sr3, sr4, z1, z2, z3;

display plasticConstraint.slack, labourConstraint.slack, balanceProduction.slack;


















