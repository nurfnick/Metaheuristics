reset;

option solver cplex;


set legs;

param fuelburn{legs};
param fuelprice{legs};
param minGallonsToWaiveFee{legs};
param fee{legs};
param numPass{legs};

var fuel{legs}>=0;
var delta{legs} binary;
var fuelAtLanding{legs}>= 2500;

minimize cost: sum{i in legs} (fuel[i]*fuelprice[i]/6.7 + delta[i]*fee[i]);

s.t. turnFeeOff{i in legs}: 6.7* minGallonsToWaiveFee[i] -fuel[i]<= 14000*(delta[i]);


s.t. computeFuelAtLanding0: fuelAtLanding[0] = 7000;
s.t. computeFuelAtLanding1: fuelAtLanding[1] = fuelAtLanding[0] + fuel[0] - fuelburn[1];
s.t. computeFuelAtLanding2: fuelAtLanding[2] = fuelAtLanding[1] + fuel[1] - fuelburn[2];
s.t. computeFuelAtLanding3: fuelAtLanding[3] = fuelAtLanding[2] + fuel[2] - fuelburn[3];
s.t. computeFuelAtLanding4: fuelAtLanding[4] = fuelAtLanding[3] + fuel[3] - fuelburn[4];
s.t. computeFuelAtLanding5: fuelAtLanding[5] = fuelAtLanding[4] + fuel[4] - fuelburn[5];

s.t. landingWeight{i in legs}: 22800 + 200 * numPass[i] + fuelAtLanding[i] <= 31800;

s.t. takeOffWeigth{i in legs}: 22800 + 200*numPass[i] + fuelAtLanding[i] + fuelburn[i] <= 36400;

s.t. maxFuel{i in legs}: fuelAtLanding[i] + fuel[i] <= 14000;

s.t. readyToGo: fuelAtLanding[5] + fuel[5] = 7000;

s.t. computeFuelAtLanding1e: fuelAtLanding[1] = 2500;
s.t. computeFuelAtLanding2e: fuelAtLanding[2] = 2500;
s.t. computeFuelAtLanding3e: fuelAtLanding[3] = 2500;
s.t. computeFuelAtLanding4e: fuelAtLanding[4] = 2500;
s.t. computeFuelAtLanding5e: fuelAtLanding[5] = 2500;


data group_HW5_p1.dat;

solve;

display fuel, fuelAtLanding, delta;