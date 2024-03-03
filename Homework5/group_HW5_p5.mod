reset;

option solver cplex;

var x1>=0, <=1;
var x2>=0, <=1;
var x3>=0, <=1;
var x4>=0, <=1;

maximize objs: 90*x1+55*x2+63*x3 +47*x4;

s.t. con1: 7*x1 + 2*x2+8*x3+3*x4 <= 10;
s.t. con2: x3+x4<=1;
s.t. con3: x3-x1<=0;
s.t. con4: x4-x2<=0;

problem fullLP: objs, x1, x2, x3, x4, con1, con2, con3, con4;


printf "\n Full LP Solution\n";
solve fullLP;


display x1, x2, x3, x4;

s.t. x1is0: x1 = 0;
s.t. x1is1: x1 = 1; 

problem step1: objs, x1, x2, x3, x4, con1, con2, con3, con4, x1is0;
printf "\n Step 1 x1 = 0\n";
solve step1;

display x1, x2, x3, x4;

problem step2: objs, x1, x2, x3, x4, con1, con2, con3, con4, x1is1;
printf "\n Step 2 x1 = 1\n";
solve step2;

display x1, x2, x3, x4;

s.t. x4is0: x4 = 0;
s.t. x4is1: x4 = 1; 

problem step3: objs, x1, x2, x3, x4, con1, con2, con3, con4, x1is1, x4is0;
printf "\n Step 3 x1 = 1 and x4 = 0\n";
solve step3;

display x1, x2, x3, x4;

problem step4: objs, x1, x2, x3, x4, con1, con2, con3, con4, x1is1, x4is1;
printf "\n Step 4 x1 = 1 and x4 = 1\n";
solve step4;

display x1, x2, x3, x4;

s.t. x3is0: x3 = 0;
s.t. x3is1: x3 = 1; 

problem step5: objs, x1, x2, x3, x4, con1, con2, con3, con4, x1is1, x4is0, x3is0;
printf "\n Step 5 x1 = 1 and x4 = 0 and x3 = 0\n";
solve step5;

display x1, x2, x3, x4;

problem step6: objs, x1, x2, x3, x4, con1, con2, con3, con4, x1is1, x4is0, x3is1;
printf "\n Step 6 x1 = 1 and x4 = 0 and x3 = 1\n";
solve step6;

display x1, x2, x3, x4;

var x1b binary;
var x2b binary;
var x3b binary;
var x4b binary;

maximize objsb: 90*x1b+55*x2b+63*x3b +47*x4b;

s.t. con1b: 7*x1b + 2*x2b+8*x3b+3*x4b <= 10;
s.t. con2b: x3b+x4b<=1;
s.t. con3b: x3b-x1b<=0;
s.t. con4b: x4b-x2b<=0;

problem binarySolution: objsb, x1b, x2b, x3b, x4b, con1b, con2b, con3b, con4b;
solve binarySolution;

display x1b, x2b, x3b, x4b;